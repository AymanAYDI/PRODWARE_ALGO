page 50029 "Log Import Sales Card"
{
    // version ALG2.00,MIG2009R2

    // ------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // ------------------------------------------------------------------------
    // //>>ALG2.00
    // FED-Algo-20100224-Vente01:MA 24/03/2010  Data port:creation sales order
    //                                              Creation

    Caption = 'Log Import Sales Card';
    PageType = Card;
    SourceTable = "Log Import Sales";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            field(DateGImportDate; DateGImportDate)
            {
                ApplicationArea = Basic, Suite;

                trigger OnValidate()
                begin
                    DateGImportDateOnAfterValidate();
                end;
            }
            field(TxtGFileName; TxtGFileName)
            {
                ApplicationArea = Basic, Suite;

                trigger OnValidate()
                begin
                    TxtGFileNameOnAfterValidate();
                end;
            }
            repeater(Control1)
            {
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(File; Rec.File)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            field(ImportFileName; '')
            {
                ApplicationArea = Basic, Suite;
                CaptionClass = Text19011692;
            }
            field(ImportDate; '')
            {
                ApplicationArea = Basic, Suite;
                CaptionClass = Text19033406;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.RESET();
        DateGImportDate := 0D;
        TxtGFileName := '';
    end;

    var
        RecGLogImportSales: Record "Log Import Sales";
        DateGImportDate: Date;
        TxtGFileName: Text[250];
        Text19033406: Label 'Import Date';
        Text19011692: Label 'Import File Name';

    procedure ApplyFilter()
    begin
        Rec.RESET();
        IF ((TxtGFileName <> '') AND (DateGImportDate <> 0D)) THEN BEGIN
            Rec.SETRANGE(File, TxtGFileName);
            Rec.SETRANGE(Date, DateGImportDate);
        END;
        IF ((TxtGFileName <> '') AND (DateGImportDate = 0D)) THEN
            Rec.SETRANGE(File, TxtGFileName);
        IF ((TxtGFileName = '') AND (DateGImportDate <> 0D)) THEN
            Rec.SETRANGE(Date, DateGImportDate);
        IF ((TxtGFileName = '') AND (DateGImportDate = 0D)) THEN
            Rec.RESET();
        CurrPage.UPDATE();
    end;

    local procedure DateGImportDateOnAfterValidate()
    begin
        ApplyFilter();
    end;

    local procedure TxtGFileNameOnAfterValidate()
    begin
        ApplyFilter();
    end;
}

