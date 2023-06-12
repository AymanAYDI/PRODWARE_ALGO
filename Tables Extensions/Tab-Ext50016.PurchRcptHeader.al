tableextension 50016 "Purch. Rcpt. Header" extends "Purch. Rcpt. Header"
{
    //t120
    fields
    {
        field(50002; "Exported Line"; Boolean)
        {
            Caption = 'Ligne exportée', Locked = true;
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(50010; "Intranet Export"; Boolean)
        {
            Caption = 'Intranet Export';
            DataClassification = CustomerContent;
        }
        field(50016; "Development Order"; Boolean)
        {
            Caption = 'Commande Développement', Locked = true;
            DataClassification = CustomerContent;
        }

    }

    procedure Export2Intranet()
    var
        PurchSetup: Record "Purchases & Payables Setup";
        DummyReportSelections: Record "Report Selections";
        DocumentSendingProfile: Record "Document Sending Profile";
        RecordLink: Record "Record Link";
        PDFFile: Text;
        PurchReceipt: Label 'Receipt';
    begin
        PurchSetup.GET();
        PurchSetup.TESTFIELD("Intranet Directory");

        PDFFile := DocumentSendingProfile.Export2IntranetPurchDoc(
          DummyReportSelections.Usage::"P.Receipt", PurchSetup."Intranet Directory", Rec, "No.", PurchReceipt, "Pay-to Vendor No.");

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

}
