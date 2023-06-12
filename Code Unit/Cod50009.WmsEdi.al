codeunit 50009 "WMS - EDI Transfert"
{
    // //----------------------------------------------------------
    // // 24/02/2020 : Creation d'un fichier EDI pour le WMS
    // //              avec flag d'un champs EXT pour ne pas reexporter
    // // 25/02/2020 : Le repertoire de sauvegarde est définie en dur dans le code    
    // //----------------------------------------------------------

    trigger OnRun()
    begin
        NAV_LECTURE();
    end;

    var
        ExcelBuf: Record "CSV Buffer" temporary;
        RecGSalesHeader: Record "Sales header";
        RecGSalesLine: Record "Sales Line";
        RecGWhShipLine: Record "Warehouse Shipment Line";
        WSL_QTE: Decimal;
        VDO: text[250];
        VDO_PARCOURS: text[250];
        VG_Article: text[250];
        ARTICLE_PARCOURS: text[250];
        intGLineNo: Integer;
        Premiere_Lecture: integer;
        pathName: text[250];
        filestartname: text[250];
        fileName: text[250];
        filename2: text[250];
        timeText: text[250];
        myTime: Time;



    PROCEDURE NAV_LECTURE()

    var
        CompanyInfo: Record "Company Information";
    begin

        // Initialisation des variables de parcours
        VG_Article := ' ';
        ARTICLE_PARCOURS := ' ';
        VDO := ' ';
        VDO_PARCOURS := ' ';

        // Test de l'existence du repertoire WMS
        IF COMPANYNAME() <> 'CLIC' THEN EXIT;
        CompanyInfo.Get();
        CompanyInfo.TestField("WMS Path");

        // PARCOURS de la table des entetes CV
        RecGSalesHeader.RESET();
        RecGSalesHeader.SETCURRENTKEY("No.");
        // FILTRES sur les champs WMS au niveau des entetes des CV
        // RecGSalesHeader.SETRANGE("No.", 'VDE000011000');
        // RecGSalesHeader.SetFilter("No.", 'VDE0000111*');
        RecGSalesHeader.SETRANGE("NON_WMS", FALSE);
        RecGSalesHeader.SETRANGE("TRANSFERER_VERS_WMS", FALSE);
        // RecGSalesHeader.SETFILTER(RecGSalesHeader."Posting Date", '>%1', 20200101D);

        IF RecGSalesHeader.FINDSET() THEN BEGIN
            // création du fichier
            MakeExcelInfo();

            // Ecriture de l'entete du fichier - DESACTIVATED en PROD
            // MakeExcelDataHeader();

            REPEAT

                // PARCOURS de la table des lignes CV
                RecGSalesLine.RESET();
                RecGSalesLine.SETCURRENTKEY("Document No.", "No.");
                // FILTRES sur les lignes CV
                RecGSalesLine.SETRANGE("Document Type", 1);
                RecGSalesLine.SETRANGE("Type", 2);
                RecGSalesLine.SETRANGE("Document No.", RecGSalesHeader."No.");

                IF RecGSalesLine.FINDSET() THEN
                    REPEAT

                        // Cas champs VDO si c'est BGM ou BGW ou autres
                        CASE RecGSalesLine."Sell-to Customer No." of
                            'BGM':
                                VDO := RecGSalesLine."Document No." + '-' + RecGSalesLine.PO;
                            'BGW':
                                VDO := RecGSalesLine."Document No." + '-' + RecGSalesLine.PO;
                            else
                                VDO := RecGSalesLine."Document No."
                        END;

                        // PARCOURS des lignes Wharehouse Shipt Line
                        RecGWhShipLine.reset();
                        RecGWhShipLine.SETRANGE("Source No.", RecGSalesLine."Document No.");
                        RecGWhShipLine.SETRANGE("Source Line No.", RecGSalesLine."Line No.");
                        RecGWhShipLine.SETRANGE("Item No.", RecGSalesLine."No.");

                        IF RecGWhShipLine.FINDSET() THEN
                            REPEAT
                                WSL_QTE += RecGWhShipLine.Quantity;
                            UNTIL RecGWhShipLine.next() = 0;

                        // Ecriture en détails 
                        IF WSL_QTE <> 0 THEN BEGIN
                            MakeExcelDataBody();
                            WSL_QTE := 0;
                            RecGSalesHeader.TRANSFERER_VERS_WMS := TRUE;
                            RecGSalesHeader.MODIFY();  // si on écrit une ligne dans le fichier d'extraction alors on flag l'entete de CV                            
                        END;

                    UNTIL RecGSalesLine.NEXT() = 0;

            UNTIL RecGSalesHeader.NEXT() = 0;


            // MESSAGE('Terminé');
        END;
        //Sauvegarde du fichier.
        SaveExcelbook();
    END;

    procedure Excel_Creation(FileName: Text)
    begin
        ExcelBuf.Reset();
        ExcelBuf.DeleteAll();
        ExcelBuf.Init();
        ExcelBuf.DeleteAll();
        MakeExcelDataBody();
    end;

    local procedure MakeExcelInfo()
    begin
        ExcelBuf.DeleteAll();
    end;

    // Generation de l'entete du fichier - DESACTIVER lors de la MEP
    local procedure MakeExcelDataHeader()
    begin
        intGLineNo := 1;
        ExcelBuf.InsertEntry(intGLineNo, 1, 'ID_SITE');
        ExcelBuf.InsertEntry(intGLineNo, 2, 'ID_ORDRE');
        ExcelBuf.InsertEntry(intGLineNo, 3, 'TYPE_ORDRE');
        ExcelBuf.InsertEntry(intGLineNo, 4, 'PRIORITE');
        ExcelBuf.InsertEntry(intGLineNo, 5, 'NUM_LIGNE_ORDRE');
        ExcelBuf.InsertEntry(intGLineNo, 6, 'DATE_ORDRE');
        ExcelBuf.InsertEntry(intGLineNo, 7, 'CODE_CLIENT');
        ExcelBuf.InsertEntry(intGLineNo, 8, 'REFERENCE_ARTICLE');
        ExcelBuf.InsertEntry(intGLineNo, 9, 'QUANTITE');
        ExcelBuf.InsertEntry(intGLineNo, 10, 'LOT');
        ExcelBuf.InsertEntry(intGLineNo, 11, 'COM_PREPA');
        ExcelBuf.InsertEntry(intGLineNo, 12, 'COM_DMD');
        ExcelBuf.InsertEntry(intGLineNo, 13, 'NO_CMD_CLT');
    end;

    // Ecriture d'une ligne dans le fichier
    local procedure MakeExcelDataBody()
    begin
        intGLineNo += 1;
        ExcelBuf.InsertEntry(intGLineNo, 1, 'PLPF');
        ExcelBuf.InsertEntry(intGLineNo, 2, FORMAT(VDO));
        ExcelBuf.InsertEntry(intGLineNo, 3, 'BC');
        ExcelBuf.InsertEntry(intGLineNo, 4, '2');
        ExcelBuf.InsertEntry(intGLineNo, 5, FORMAT(intGLineNo));
        ExcelBuf.InsertEntry(intGLineNo, 6, FORMAT(RecGSalesLine."Shipment Date"));
        ExcelBuf.InsertEntry(intGLineNo, 7, FORMAT(RecGSalesLine."Sell-to Customer No."));
        ExcelBuf.InsertEntry(intGLineNo, 8, FORMAT(RecGSalesLine."No."));
        ExcelBuf.InsertEntry(intGLineNo, 9, FORMAT(WSL_QTE, 0, 1));
        ExcelBuf.InsertEntry(intGLineNo, 10, '');
        ExcelBuf.InsertEntry(intGLineNo, 11, '');
        ExcelBuf.InsertEntry(intGLineNo, 12, '');
        ExcelBuf.InsertEntry(intGLineNo, 13, '');
    end;

    local procedure SaveExcelbook()
    // Dans 1er temps : le fichier va s'ecrire en local du client NAV sur c:\temp avec une extension *.trt
    // Lorsque le traitement va se terminer
    // Il va renommer le fichier en .EAI et le déplacer dans le répertoire paramétré dans infos société pour traitement WMS
    var
        CompanyInfo: Record "Company Information";
    begin
        CompanyInfo.Get();
        CompanyInfo.TestField("WMS Path");
        myTime := TIME();
        timeText := FORMAT(TODAY(), 0, '<Day>_<Month>_<Year4>');
        timeText += FORMAT(mytime, 0, '-<Hours24,2>_<Minutes,2>_<Seconds,2>');
        pathname := CompanyInfo."WMS Path";
        filestartname := 'DEM-';
        fileName := 'c:\temp\' + fileStartName + timeText + '.TRT';
        fileName2 := pathName + fileStartName + timeText + '.EAI';
        ExcelBuf.SaveData(filename, ';');
        File.Rename(filename, filename2);
    end;
}