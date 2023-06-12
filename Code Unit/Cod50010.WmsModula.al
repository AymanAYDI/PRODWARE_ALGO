codeunit 50010 "MODULA - EDI Transfert"
{
    // //----------------------------------------------------------
    // // 31/03/2020 : Creation d'un fichier EDI pour le MODULA
    // //              avec flag d'un champs EXT pour ne pas reexporter
    // // 01/04/2020 : Le repertoire de sauvegarde est définie en variable dans informations sociétés  
    // //   
    // //----------------------------------------------------------

    Permissions = TableData 7312 = rm;

    trigger OnRun()
    begin
        NAV_LECTURE();
    end;

    var
        ExcelBuf: Record "CSV Buffer" temporary;
        RecGWhentry: Record "Warehouse Entry";
        intGLineNo: Integer;
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

        // Test de l'existence du repertoire MODULA
        IF COMPANYNAME() <> 'ALGO PROD' THEN EXIT;
        CompanyInfo.Get();
        CompanyInfo.TestField("MODULA Path");

        // PARCOURS de la table des entetes CV
        RecGWhentry.RESET();
        RecGWhentry.SETCURRENTKEY("Entry No.");

        // FILTRES sur les champs au niveau des ecritures entrepots donnés par JVENANT
        RecGWhentry.SETRANGE("Location Code", 'LANNOLIER1');
        RecGWhentry.SETRANGE("Bin Code", 'MODULA');
        RecGWhentry.SETRANGE("Source code", 'FRECLASS');
        RecGWhentry.SETRANGE("TRANSFERT MODULA", FALSE);
        RecGWhentry.SETFILTER(RecGWhentry.Quantity, '>%1', 0);

        // Filtre sur date à désactiver en production
        // RecGWhentry.SETFILTER(RecGWhentry."Registering Date", '>=%1', 20200301D);

        IF RecGWhentry.FINDSET() THEN BEGIN
            // création du fichier
            MakeExcelInfo();
            // Ecriture de l'entete du fichier - activé en PROD
            MakeExcelDataHeader();
            REPEAT
                // PARCOURS de la table des écritures entrepot
                MakeExcelDataBody();
                //>> FLAG du booleen TRANSFERT MODULA
                RecGWhentry."TRANSFERT MODULA" := TRUE;
                RecGWhentry.MODIFY();  // si on écrit une ligne dans le fichier d'extraction alors on flag la  ligne                           
            UNTIL RecGWhentry.NEXT() = 0;
            // Message à desactiver en PROD
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

    // Generation de l'entete du fichier - Activé à la demande de JVENANT
    local procedure MakeExcelDataHeader()
    begin
        intGLineNo := 1;
        ExcelBuf.InsertEntry(intGLineNo, 1, 'N°Document');
        ExcelBuf.InsertEntry(intGLineNo, 2, 'Article');
        ExcelBuf.InsertEntry(intGLineNo, 3, 'Quantite');
    end;

    // Ecriture d'une ligne dans le fichier
    local procedure MakeExcelDataBody()
    begin
        intGLineNo += 1;
        ExcelBuf.InsertEntry(intGLineNo, 1, FORMAT(RecGWhentry."Source No."));
        ExcelBuf.InsertEntry(intGLineNo, 2, FORMAT(RecGWhentry."Item No."));
        ExcelBuf.InsertEntry(intGLineNo, 3, FORMAT(RecGWhentry.Quantity, 0, 1));
    end;

    local procedure SaveExcelbook()
    // Dans 1er temps : le fichier va s'ecrire en local du client NAV sur c:\temp avec une extension *.TRT
    // Lorsque le traitement va se terminer
    // Il va renommer le fichier en .CSV et le déplacer dans le répertoire paramétré dans infos société pour traitement WMS
    var
        CompanyInfo: Record "Company Information";
    begin
        CompanyInfo.Get();
        CompanyInfo.TestField("Modula Path");
        myTime := TIME();
        timeText := FORMAT(TODAY(), 0, '<Day>_<Month>_<Year4>');
        timeText += FORMAT(mytime, 0, '-<Hours24,2>_<Minutes,2>_<Seconds,2>');
        pathname := CompanyInfo."Modula Path";
        filestartname := 'RECLASSMPBIJ-';
        fileName := 'c:\temp\' + fileStartName + timeText + '.TRT';
        fileName2 := pathName + fileStartName + timeText + '.CSV';
        ExcelBuf.SaveData(filename, ';');
        File.Rename(filename, filename2);
    end;
}