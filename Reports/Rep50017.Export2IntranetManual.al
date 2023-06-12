report 50017 "Export2Intranet Manual"
{
    Caption = 'Export2Intranet Manual';
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            RequestFilterFields = "No.", "Sell-to Customer No.";

            trigger OnPreDataItem()
            var
                SalesReceivablesSetup: Record "Sales & Receivables Setup";
            begin
                IF GETFILTERS() = '' THEN
                    ERROR(TxtLabel1, "Sales Invoice Header".TABLECAPTION());

                SalesReceivablesSetup.GET();
                SalesReceivablesSetup.TESTFIELD("Intranet Directory");
                IntranetDirectory := SalesReceivablesSetup."Intranet Directory";
            end;

            trigger OnAfterGetRecord()
            var
                SalesInvoiceHeader: Record "Sales Invoice Header";
                SalesInvoiceHeader2: Record "Sales Invoice Header";
            begin
                //Export to Intranet Directory.
                SalesInvoiceHeader := "Sales Invoice Header";
                SalesInvoiceHeader.SETRECFILTER();
                SalesInvoiceHeader.Export2Intranet();
                //flag exportation
                SalesInvoiceHeader2.GET("No.");
                SalesInvoiceHeader2."Intranet Export" := TRUE;
                SalesInvoiceHeader2.MODIFY();

            end;
        }

        dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
        {
            RequestFilterFields = "No.", "Sell-to Customer No.";

            trigger OnPreDataItem()
            var
                SalesReceivablesSetup: Record "Sales & Receivables Setup";
            begin
                IF GETFILTERS() = '' THEN
                    ERROR(TxtLabel1, "Sales Cr.Memo Header".TABLECAPTION());

                SalesReceivablesSetup.GET();
                SalesReceivablesSetup.TESTFIELD("Intranet Directory");
                IntranetDirectory := SalesReceivablesSetup."Intranet Directory";
            end;

            trigger OnAfterGetRecord()
            var
                SalesCrMemoHeader: Record "Sales Cr.Memo Header";
                SalesCrMemoHeader2: Record "Sales Cr.Memo Header";
            begin
                //Export to Intranet Directory.
                SalesCrMemoHeader := "Sales Cr.Memo Header";
                SalesCrMemoHeader.SETRECFILTER();
                SalesCrMemoHeader.Export2Intranet();
                //flag exportation
                SalesCrMemoHeader2.GET("No.");
                SalesCrMemoHeader2."Intranet Export" := TRUE;
                SalesCrMemoHeader2.MODIFY();
            end;
        }


        dataitem("Purch. Rcpt. Header"; "Purch. Rcpt. Header")
        {
            RequestFilterFields = "No.", "Pay-to Vendor No.";

            trigger OnPreDataItem()
            var
                PurchPayablesSetup: Record "Purchases & Payables Setup";
            begin
                IF GETFILTERS() = '' THEN
                    ERROR(TxtLabel1, "Purch. Rcpt. Header".TABLECAPTION());

                PurchPayablesSetup.GET();
                PurchPayablesSetup.TESTFIELD("Intranet Directory");
                IntranetDirectory := PurchPayablesSetup."Intranet Directory";
            end;

            trigger OnAfterGetRecord()
            var
                SalesCrMemoHeader: Record "Purch. Rcpt. Header";
                SalesCrMemoHeader2: Record "Purch. Rcpt. Header";
            begin
                //Export to Intranet Directory.
                SalesCrMemoHeader := "Purch. Rcpt. Header";
                SalesCrMemoHeader.SETRECFILTER();
                SalesCrMemoHeader.Export2Intranet();
                //flag exportation
                SalesCrMemoHeader2.GET("No.");
                SalesCrMemoHeader2."Intranet Export" := TRUE;
                SalesCrMemoHeader2.MODIFY();
            end;
        }
    }


    var
        IntranetDirectory: Text[250];
        TxtLabel1: Label 'You must defined a filter on %1';
}