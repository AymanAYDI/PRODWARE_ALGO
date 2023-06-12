codeunit 50006 "VDOC - Export Xls Multifichier"
{
    // //----------------------------------------------------------
    // // 10/04/2018 :  codeunit developpé pour MoovApps
    // // - Il va exporter par atelier, pour une date de comptabilisation
    // // les données dans un fichier Excel.
    // // - Le fichier excel répond à une nomenclature définie par MoovApps
    // // - Il va mettre un flag à jour dans la table 121 lorsqu'une ligne sera exportée
    // // - il va copier chaque fichier excel généré dans 2 répertoires :
    // //    > sur le serveur VMVDOC pour intégration automatique de MoovApps
    // //    > sur le serveur J: dans le but d'avoir une copie de sauvegarde.
    // //----------------------------------------------------------
    // //----------------------------------------------------------
    // // 20/02/2020 : Modification pour Moovapps par rapport au WMS
    // // modification du regroupement : Frns+ Date cpta + No Imputation
    // //----------------------------------------------------------
    // //----------------------------------------------------------
    // // 03/03/2020 : Modification pour Moovapps par rapport au WMS
    // // modification du regroupement : Frns+ Date cpta + No Imputation
    // // Creation de la table tempreceiptline 2 -> groupcode = frns + date + wmsimputation
    // //----------------------------------------------------------
    // //----------------------------------------------------------


    Permissions = TableData 121 = rm;

    trigger OnRun()
    begin

        Nav_Import_PurchaseLine();
        Nav_Lecture_TblTmp();
    end;

    var
        RecGPurchaseLine: Record "Purch. Rcpt. Line";
        TempReceipLine: Record "Temp Receipt Line 2";
        ExcelBuf: Record "Excel Buffer" temporary;
        SMAIL: Codeunit "SMTP Mail";
        Tcol001: Label 'sys_index.current', locked = true;
        Tcol002: Label 'sys_definition.uri', locked = true;
        Tcol003: Label 'sys_Title', locked = true;
        Tcol004: Label 'DateDeSaisieDeLaReceptionDansNavision', locked = true;
        Tcol005: Label 'NomDeLAtelier', locked = true;
        Tcol006: Label 'CodeRegroupementDesBLs', locked = true;
        Tcol007: Label 'sys_Creator.login', locked = true;
        TextVdoc1: Label 'uril://vdoc/workflow/DefaultOrganization/Qualite/ControleQualite:0/ControleDesProduitsFinis/', locked = true;
        // Go in variable (ControleDesProduitsFinis_1.1)
        TextVdoc2: Label 'uri://vdoc/resource/584;uri://vdoc/resource/585;', locked = true;
        Lcol001: Label 'sys_index.current', locked = true;
        Lcol002: Label 'sys_index.parent', locked = true;
        Lcol003: Label 'sys_index.tab', locked = true;
        Lcol004: Label 'sys_definition.uri', locked = true;
        Lcol005: Label 'sys_definition.childType', locked = true;
        Lcol006: Label 'QuantiteDePieces', locked = true;
        Lcol007: Label 'CodeArticle', locked = true;
        Lcol008: Label 'Designation2', locked = true;
        Lcol009: Label 'NumeroDeScelle', locked = true;
        Lcol010: Label 'NumeroDeBL', locked = true;
        Lcol011: Label 'NumeroDeCommande', locked = true;
        Lcol012: Label 'PrixUnitaire', locked = true;
        Lcol013: Label 'QuantiteDePiecesControlees', locked = true;
        Lcol014: Label 'ReferenceDuControlePrecedent', locked = true;
        Lcol015: Label 'Designation', locked = true;
        Lcol016: Label 'sys_Creator.login', locked = true;
        Lcol017: Label 'IDDeLaLigne', locked = true;
        Txtvdocl03: Label 'uril://vdoc/resourceDefinition/DefaultOrganization/Qualite/ControleQualite:0/DetailsDesPieces', locked = true;
        Txtvdocl04: Label 'ILinkedResource', locked = true;
        Txtvdocl05: Label 'VDocResource', locked = true;
        FileName: Text[250];
        FilePath: Text[250];
        ExportDirectory: Text[80];
        legroupename: Text[250];
        GroupNo: Code[30];
        "Count": Integer;
        Selection: Integer;
        CountLine: Integer;
        Countdistinctgroupname: Integer;
        i: Integer;
        IndiceBoucleDeSortie: Integer;

    procedure Header_Entetes()
    begin
        ExcelBuf.NewRow();
        ExcelBuf.AddColumn(FORMAT(Tcol001), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(Tcol002), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(Tcol003), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(Tcol004), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(Tcol005), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(Tcol006), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(Tcol007), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.NewRow();
        ExcelBuf.AddColumn(FORMAT('INDEX'), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT('RESOURCE_DEFINITION'), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT('STRING'), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT('DATE'), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT('STRING'), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT('STRING'), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT('USER'), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
    end;

    procedure Header_Details()
    var
        CompanyInfo: Record "Company Information";
        process: Text;
    begin
        CompanyInfo.Get();
        CompanyInfo.TestField("VDOC process");
        process := TextVdoc1 + CompanyInfo."VDOC process";
        ExcelBuf.NewRow();
        ExcelBuf.AddColumn(FORMAT(Countdistinctgroupname), false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(FORMAT(process), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(TempReceipLine."Buy-from Vendor No." + ' - ' + TempReceipLine."WMS No Imputation"), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(FORMAT(TempReceipLine."Posting Date")), false, '', false, false, false, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn(FORMAT(FORMAT(TempReceipLine."Buy-from Vendor No.")), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        //        ExcelBuf.AddColumn(FORMAT(TempReceipLine."Group Code" + ' - ' + TempReceipLine."WMS No Imputation"), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(TempReceipLine."Group Code"), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT('Navision'), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
    end;

    procedure Line_Entetes()
    begin
        ExcelBuf.NewRow();
        ExcelBuf.AddColumn(FORMAT(Lcol001), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(Lcol002), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(Lcol003), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(Lcol004), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(Lcol005), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(Lcol006), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(Lcol007), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(Lcol008), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(Lcol009), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(Lcol010), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(Lcol011), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(Lcol012), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(Lcol013), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(Lcol014), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(Lcol015), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(Lcol016), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(Lcol017), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);

        ExcelBuf.NewRow();
        ExcelBuf.AddColumn(FORMAT('INDEX'), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT('INDEX'), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT('INDEX'), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT('RESOURCE_DEFINITION'), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT('RESOURCE_DEFINITION'), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT('FLOAT'), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT('STRING'), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT('STRING'), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT('STRING'), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT('STRING'), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT('STRING'), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT('FLOAT'), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT('FLOAT'), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT('STRING'), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT('STRING'), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT('USER'), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT('STRING'), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
    end;

    procedure Line_Details()
    begin
        ExcelBuf.NewRow();
        ExcelBuf.AddColumn(FORMAT(CountLine - 2), false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(FORMAT(Countdistinctgroupname), false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(FORMAT(Txtvdocl05), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(Txtvdocl03), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(Txtvdocl04), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(TempReceipLine."Receipt Qty"), false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(FORMAT(TempReceipLine."ItemNo."), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(TempReceipLine.Description2), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(TempReceipLine."P.O."), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(TempReceipLine."Vendor Shipment No."), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(TempReceipLine."Order No."), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(TempReceipLine."Direct Unit Cost"), false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(FORMAT(TempReceipLine."Receipt Qty"), false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(FORMAT(TempReceipLine."Vdoc Control No."), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(TempReceipLine.Description), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT('Navision'), false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(CountLine - 2), false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
    end;

    procedure Nav_Import_PurchaseLine()
    begin

        RecGPurchaseLine.RESET();
        TempReceipLine.DELETEALL();
        TempReceipLine."LineNo." := 0;

        // Check : filtre uniquement sur les lignes CA de type article
        RecGPurchaseLine.SETRANGE(Type, RecGPurchaseLine.Type::Item);
        // check sur les lignes non exportées : si TRUE alors exclue
        RecGPurchaseLine.SETRANGE("Exported Line", FALSE);
        // check si la ligne CA correspond à une commande DEV : si DEV alors exclue
        RecGPurchaseLine.SETRANGE("Development Order", FALSE);
        //Check sur la date de comptabilisation : uniquement les Lig Rcpt Ach Enreg depuis le 01/01/2019
        //yyyy-mm-ddD 090418D
        RecGPurchaseLine.SETFILTER(RecGPurchaseLine."Posting Date", '>%1', 20190101D);
        RecGPurchaseLine.SETFILTER(RecGPurchaseLine."No.", '<>SAV*');
        RecGPurchaseLine.SETFILTER(RecGPurchaseLine."Posting Group", 'PF');
        RecGPurchaseLine.SETFILTER(RecGPurchaseLine.Quantity, '<>%1', 0);
        RecGPurchaseLine.CALCFIELDS("Vendor Shipment No.");
        //========================== Lecture de la table PurchaseLine / Alimentation de la table tempo ===

        IF RecGPurchaseLine.FINDSET() THEN
            REPEAT
                TempReceipLine."Group Code" := STRSUBSTNO('%1-%2%3%4-%5', RecGPurchaseLine."Buy-from Vendor No."
                                             , DATE2DMY(RecGPurchaseLine."Posting Date", 3)
                                             , DATE2DMY(RecGPurchaseLine."Posting Date", 2)
                                             , DATE2DMY(RecGPurchaseLine."Posting Date", 1)
                                             , RecGPurchaseLine."WMS No Imputation");
                TempReceipLine."Buy-from Vendor No." := RecGPurchaseLine."Buy-from Vendor No.";
                TempReceipLine."LineNo." += 1;
                TempReceipLine."Posting Date" := RecGPurchaseLine."Posting Date";
                TempReceipLine."ItemNo." := RecGPurchaseLine."No.";
                TempReceipLine.Model := '';
                TempReceipLine."Vendor Shipment No." := RecGPurchaseLine."Vendor Shipment No.";
                TempReceipLine."Document No." := RecGPurchaseLine."Document No.";
                TempReceipLine."Line No." := RecGPurchaseLine."Line No.";
                TempReceipLine."Receipt Qty" := RecGPurchaseLine.Quantity;
                TempReceipLine."Order No." := RecGPurchaseLine."Order No.";
                TempReceipLine."P.O." := RecGPurchaseLine."P.O.";
                TempReceipLine."Direct Unit Cost" := RecGPurchaseLine."Direct Unit Cost";
                TempReceipLine."Vdoc Control No." := RecGPurchaseLine."Vdoc Control No.";
                TempReceipLine.Description := RecGPurchaseLine.Description;
                TempReceipLine.Description2 := RecGPurchaseLine."Description 2";
                TempReceipLine."Exported Line" := RecGPurchaseLine."Exported Line";
                TempReceipLine."WMS No Imputation" := RecGPurchaseLine."WMS No Imputation";
                TempReceipLine.INSERT();
            UNTIL RecGPurchaseLine.NEXT() = 0;
    end;

    procedure Nav_Lecture_TblTmp()
    var
        CompanyInfo: Record "Company Information";
    begin
        CompanyInfo.Get();
        CompanyInfo.TestField("VDOC Path");
        CompanyInfo.TestField("VDOC Backup Path");

        TempReceipLine.RESET();
        TempReceipLine.SETCURRENTKEY("Group Code");
        TempReceipLine.SETRANGE("Exported Line", FALSE);

        // A Supprimer lors du passage en PROD ==========================
        // TempReceipLine.SETFILTER(TempReceipLine."Group Code",'Y*2018*') ;
        // ==============================================================

        IndiceBoucleDeSortie := 0;
        Countdistinctgroupname := 1;
        CountLine := 3;

        IF TempReceipLine.FINDSET() THEN BEGIN
            legroupename := TempReceipLine."Group Code";
            // création du fichier
            Excel_Creation(CompanyInfo."VDOC Path" + '\' + legroupename + '.xlsx');
            REPEAT
                TempReceipLine.CALCFIELDS("Vendor Shipment No.");
                // On crée le fichier lorsque le GROUPECODE change :
                IF (TempReceipLine."Group Code" <> legroupename) THEN BEGIN
                    //Sauvegarde du précédant fichier.
                    ExcelBuf.WriteSheet('DetailsDesPieces', CompanyName(), UserId());
                    ExcelBuf.CloseBook();
                    //Sauvegarde du fichier
                    File.Copy(CompanyInfo."VDOC Path" + '\' + legroupename + '.xlsx', CompanyInfo."VDOC Backup Path" + '\' + legroupename + '.xlsx');

                    legroupename := TempReceipLine."Group Code";

                    // création du fichier
                    Excel_Creation(CompanyInfo."VDOC Path" + '\' + legroupename + '.xlsx');

                    Countdistinctgroupname := 1;
                    IndiceBoucleDeSortie := IndiceBoucleDeSortie + 1;
                    CountLine := 3;
                END;

                Line_Details();

                CountLine := CountLine + 1;

                // 20200220 - WMS - Desactivation/activation du flag à la ligne pour les tests
                IF RecGPurchaseLine.GET(TempReceipLine."Document No.", TempReceipLine."Line No.") THEN BEGIN
                    RecGPurchaseLine."Exported Line" := TRUE;
                    RecGPurchaseLine.MODIFY();
                END;
            UNTIL TempReceipLine.NEXT() = 0;

            //Sauvegarde du précédant fichier.
            if ExcelBuf.Count() > 0 then begin
                ExcelBuf.WriteSheet('DetailsDesPieces', CompanyName(), UserId());
                ExcelBuf.CloseBook();
                //Sauvegarde du fichier
                File.Copy(CompanyInfo."VDOC Path" + '\' + legroupename + '.xlsx', CompanyInfo."VDOC Backup Path" + '\' + legroupename + '.xlsx');
            end;

        END;
    end;


    procedure Excel_Creation(FileName: Text)
    begin
        ExcelBuf.Reset();
        ExcelBuf.DeleteAll();
        ExcelBuf.Init();
        ExcelBuf.CreateBook(FileName, 'VDocResource');
        Header_Entetes();
        Header_Details();
        ExcelBuf.WriteSheet('VDocResource', CompanyName(), UserId());
        ExcelBuf.DeleteAll();
        ExcelBuf.SelectOrAddSheet('DetailsDesPieces');
        ExcelBuf.ClearNewRow();
        Line_Entetes();
    end;

}