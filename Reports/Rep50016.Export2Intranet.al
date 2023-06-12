report 50016 "Export2Intranet"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.") ORDER(Ascending) WHERE("Intranet Export" = FILTER(false));

            trigger OnPreDataItem()
            var
                SalesReceivablesSetup: Record "Sales & Receivables Setup";
            begin
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
            DataItemTableView = SORTING("No.") ORDER(Ascending) WHERE("Intranet Export" = FILTER(false));

            trigger OnPreDataItem()
            var
                SalesReceivablesSetup: Record "Sales & Receivables Setup";
            begin
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
            DataItemTableView = SORTING("No.") ORDER(Ascending) WHERE("Intranet Export" = FILTER(false));

            trigger OnPreDataItem()
            var
                PurchPayablesSetup: Record "Purchases & Payables Setup";
            begin
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
}