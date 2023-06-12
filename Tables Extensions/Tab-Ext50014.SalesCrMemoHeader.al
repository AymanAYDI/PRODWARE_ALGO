tableextension 50014 "Sales Cr.Memo Header" extends "Sales Cr.Memo Header"
{
    //t114
    fields
    {
        field(50000; PO; Code[20])
        {
            Caption = 'PO';
            DataClassification = CustomerContent;
        }
        field(50010; "Intranet Export"; Boolean)
        {
            Caption = 'Intranet Export';
            DataClassification = CustomerContent;
        }
    }

    procedure Export2Intranet()
    var
        SalesSetup: Record "Sales & Receivables Setup";
        DummyReportSelections: Record "Report Selections";
        DocumentSendingProfile: Record "Document Sending Profile";
        RecordLink: Record "Record Link";
        PDFFile: Text;
        CrMemoTxt: Label 'Credit Memo';
    begin
        SalesSetup.GET();
        SalesSetup.TESTFIELD("Intranet Directory");

        PDFFile := DocumentSendingProfile.Export2IntranetSalesDoc(
          DummyReportSelections.Usage::"S.Cr.Memo", SalesSetup."Intranet Directory", Rec, "No.", CrMemoTxt, "Sell-to Customer No.", Date2DMY("Posting Date", 3));

        IF PDFFile <> '' THEN BEGIN
            RecordLink.SETRANGE("Record ID", Rec.RECORDID());
            RecordLink.SETRANGE(URL1, PDFFile);
            RecordLink.SETRANGE(Type, RecordLink.Type::Link);
            IF RecordLink.COUNT() = 0 THEN BEGIN
                CLEAR(RecordLink);
                RecordLink."Record ID" := Rec.RECORDID();
                RecordLink.URL1 := PDFFile;
                RecordLink.Description := 'Document';
                RecordLink.Type := RecordLink.Type::Link;
                RecordLink.Created := CURRENTDATETIME();
                RecordLink."User ID" := USERID();
                RecordLink.Company := COMPANYNAME();
                RecordLink.Notify := TRUE;
                RecordLink."To User ID" := USERID();
                RecordLink.INSERT(TRUE);
            END;
        END;
    end;

    //>> Projet#410 : Avoir GSH
    procedure ExportGSH()
    var
        SalesCreditLine: Record "Sales Cr.Memo Line";
        CompanyInfo: Record "Company Information";
    begin

        IF COMPANYNAME() <> 'ALGO PROD' then exit;
        CompanyInfo.get();
        CompanyInfo.TestField("GSH Credit Memo Path");
        CompanyInfo.TestField("GSH Credit Memo Backup Path");
        CompanyInfo.TestField("LU Credit Memo Path");

        MakeExcelInfo();

        SalesCreditLine.SetRange("Document No.", "No.");

        if SalesCreditLine.FindSet() then
            repeat
                MakeExcelDataBody(SalesCreditLine);
            until SalesCreditLine.Next() = 0;

        if intGLineNo > 0 then begin
            // Ajout d'une ligne en fin de fichier pour indiquer le nombre d'enregistrements
            intGLineNo += 1;
            ExcelBuf.InsertEntry(intGLineNo, 1, '#TOTAL#');
            ExcelBuf.InsertEntry(intGLineNo, 2, '');
            ExcelBuf.InsertEntry(intGLineNo, 3, '');
            ExcelBuf.InsertEntry(intGLineNo, 4, '');
            ExcelBuf.InsertEntry(intGLineNo, 5, '');
            ExcelBuf.InsertEntry(intGLineNo, 6, '');
            ExcelBuf.InsertEntry(intGLineNo, 7, '');
            ExcelBuf.InsertEntry(intGLineNo, 8, FORMAT(VG_Compteur));
            ExcelBuf.InsertEntry(intGLineNo, 9, '');
            ExcelBuf.InsertEntry(intGLineNo, 10, '');
            ExcelBuf.InsertEntry(intGLineNo, 11, '');
            ExcelBuf.InsertEntry(intGLineNo, 12, '');
            ExcelBuf.InsertEntry(intGLineNo, 13, '');
        end;



        IF "Sell-to Customer No." = 'GOYARD MONDE' THEN BEGIN


            FileNameFTP := STRSUBSTNO(CompanyInfo."GSH Credit Memo Path",
                        FctShipNo("No.") + RecGPostDateFic);

            FileNameLocal := STRSUBSTNO(CompanyInfo."GSH Credit Memo Backup Path",
                              FctShipNo("No.") + RecGPostDateFic);

            ExcelBuf.SaveData(FileNameFTP, ';');
            //FileMgt.CopyServerFile(FileNameFTP, FileNameLocal, TRUE);
            IF NOT FILE.COPY(FileNameFTP, FileNameLocal) THEN
                MESSAGE('Echec de la copie FTP vers ServeurJ');


            // ===================================================================================            
            SMTPMailSetup.GET();

            // L envoi du mail se fera uniquement pour le client GOYARD ===========EN TEST =========
            SMTPMail.CreateMessage('Service Facturation ALGO',
                      'server@manufacture-algo.com',
                      CompanyInfo."Invoice Mail Recipient",
                      STRSUBSTNO('AVOIR_ALGO_%1', FctShipNo("No.") + RecGPostDateFic),
                      '',
                      TRUE);
            // ===========================================================================================

            SMTPMail.AppendBody('Bonjour,');
            SMTPMail.AppendBody('<br>');
            SMTPMail.AppendBody('<br>');
            SMTPMail.AppendBody('Un nouveau fichier d avoir a été généré sur le site FTP, ');
            SMTPMail.AppendBody('<br>');
            SMTPMail.AppendBody('vous l aurez à disposition dans les 15 prochaines minutes. ');
            SMTPMail.AppendBody('<br>');
            SMTPMail.AppendBody('<br>');
            SMTPMail.AppendBody('Cordialement, ');
            SMTPMail.AppendBody('<br>');
            SMTPMail.AppendBody('<br>');
            SMTPMail.AppendBody('Le Service Facturation.');
            SMTPMail.AppendBody('<br>');
            SMTPMail.AppendBody('<br>');
            SMTPMail.AppendBody('S.A.S. ALGO');
            SMTPMail.AppendBody('<br>');
            SMTPMail.AppendBody('Domaine de la Providence Vieille');
            SMTPMail.AppendBody('<br>');
            SMTPMail.AppendBody('Route de Saint Hilaire');
            SMTPMail.AppendBody('<br>');
            SMTPMail.AppendBody('11000 CARCASSONNE');
            SMTPMail.AppendBody('<br>');
            SMTPMail.AppendBody('FRANCE');
            SMTPMail.AppendBody('<br>');
            SMTPMail.AppendBody('<br>');
            SMTPMail.AppendBody('<br>');
            SMTPMail.AppendBody('Tel : +33(0)4.68.11.58.11');
            SMTPMail.AppendBody('<br>');
            SMTPMail.AppendBody('<br>');
            SMTPMail.AppendBody('<br>');
            SMTPMail.AppendBody('<HR>');
            SMTPMail.AppendBody('Ce message provient d une adresse de messagerie non moderée. Merci de ne pas y répondre.');
            SMTPMail.AddAttachment(FileNameFTP, FileNameFTP);
            SMTPMail.Send();
            CLEAR(SMTPMail);

        END;


        IF "Sell-to Customer No." = 'LUNIFORM' THEN BEGIN
            FileNameLocal := STRSUBSTNO(CompanyInfo."LU Credit Memo Path",
              FctShipNo("No.") + RecGPostDateFic);
            ExcelBuf.SaveData(FileNameLocal, ';');
        END;

        Message('Export Réussi.');
    end;

    local procedure FctShipNo(CodPShipNo: Code[20]): Code[20]
    var
        CodLShipNo: code[20];
    begin

        CodLShipNo := CodPShipNo;
        //Replace characters
        IF STRPOS(CodPShipNo, '/') > 0 THEN
            CodLShipNo := CONVERTSTR(CodPShipNo, '/', '-');
        EXIT(CodLShipNo);
    end;

    local procedure MakeExcelDataBody(SalesCreditLine: Record "Sales Cr.Memo Line")
    begin

        //>>EMI_DSP20181112
        IF SalesCreditLine.Quantity > 0 THEN BEGIN
            intGLineNo += 1;

            RecGPostDate := FORMAT(SalesCreditLine."Posting Date", 10, '<Year4>-<Month,2>-<Day,2>');
            RecGPostDateRes := COPYSTR(RecGPostDate, 1, 4) + '-' + COPYSTR(RecGPostDate, 6, 2) + '-' + COPYSTR(RecGPostDate, 9, 2);
            RecGPostDateFic := '_' + COPYSTR(RecGPostDate, 1, 4) + COPYSTR(RecGPostDate, 6, 2) + COPYSTR(RecGPostDate, 9, 2);

            ExcelBuf.InsertEntry(intGLineNo, 1, SalesCreditLine."Document No.");
            ExcelBuf.InsertEntry(intGLineNo, 2, RecGPostDateRes);
            ExcelBuf.InsertEntry(intGLineNo, 3, SalesCreditLine."Sell-to Customer No.");
            ExcelBuf.InsertEntry(intGLineNo, 4, SalesCreditLine.PO);
            ExcelBuf.InsertEntry(intGLineNo, 5, SalesCreditLine."No.");
            ExcelBuf.InsertEntry(intGLineNo, 6, SalesCreditLine.Description);
            ExcelBuf.InsertEntry(intGLineNo, 7, SalesCreditLine."Description 2");
            ExcelBuf.InsertEntry(intGLineNo, 8, FORMAT(SalesCreditLine.Quantity, 0, 1));
            ExcelBuf.InsertEntry(intGLineNo, 9, SalesCreditLine."Unit of Measure Code");
            ExcelBuf.InsertEntry(intGLineNo, 10, FORMAT(SalesCreditLine."Unit Price", 0, 1));
            ExcelBuf.InsertEntry(intGLineNo, 11, FORMAT(SalesCreditLine.Amount, 0, 1));
            ExcelBuf.InsertEntry(intGLineNo, 12, '');
            ExcelBuf.InsertEntry(intGLineNo, 13, '');
            VG_Compteur := VG_Compteur + 1;
        END;
        //>>EMI_DSP20181112    
    end;

    local procedure MakeExcelInfo()
    begin
        ExcelBuf.DeleteAll();
    end;

    var
        SMTPMailSetup: Record "SMTP Mail Setup";
        ExcelBuf: Record "CSV Buffer" temporary;
        SMTPMail: Codeunit "SMTP Mail";
        FileMgt: Codeunit "File Management";
        RecGPostDateFic: Text[30];
        RecGPostDate: Text[30];
        RecGPostDateRes: Text[30];
        FileNameFTP: Text[250];
        FileNameLocal: Text[250];
        VG_Compteur: Integer;
        intGLineNo: Integer;
        Text013: Label 'Lignes Avoir', Locked = true;
}
//<< Projet#410 : Avoir GSH