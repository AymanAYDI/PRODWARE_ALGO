report 50067 "Purchase Service Rate"
{
    caption = 'Purchase Service Rate';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports/Rep50067.PurchaseServiceRate.rdl';
    ApplicationArea = Basic, Suite;

    dataset
    {
        dataitem("Purchase Line"; "Purchase Line")
        {
            DataItemTableView = sorting("Document No.", "Line No.", "Document Type") where("Document Type" = const(Order), Type = FILTER(Item));
            RequestFilterFields = "Document No.";

            column(Document_No_Caption; FieldCaption("Document No.")) { }
            column(Document_No_; "Document No.") { }

            column(Buy_from_Vendor_No_Caption; FieldCaption("Buy-from Vendor No.")) { }
            column(Buy_from_Vendor_No_; "Buy-from Vendor No.") { }

            column(Order_Date_Caption; FieldCaption("Order Date")) { }
            column(Order_Date; "Order Date") { }

            column(No_Caption; FieldCaption("No.")) { }
            column(No_; "No.") { }

            column(Quantity_Caption; FieldCaption(Quantity)) { }
            column(Quantity; Quantity) { }

            column(Outstanding_Quantity_Caption; FieldCaption("Outstanding Quantity")) { }
            column(Outstanding_Quantity; "Outstanding Quantity") { }

            column(Direct_Unit_Cost_Caption; FieldCaption("Direct Unit Cost")) { }
            column(Direct_Unit_Cost; "Direct Unit Cost") { }

            column(Line_Amount_Caption; FieldCaption("Line Amount")) { }
            column(Line_Amount; "Line Amount") { }

            column(Promised_Receipt_Date_Caption; FieldCaption("Promised Receipt Date")) { }
            column(Promised_Receipt_Date; "Promised Receipt Date") { }

            column(Rcpt_Qty_at_Due_Date_Caption; FieldCaption("Rcpt Qty at Due Date")) { }
            column(Rcpt_Qty_at_Due_Date; "Rcpt Qty at Due Date") { }

            column(txtTds; txtTds) { }

            column(txtRestock; txtRestock) { }

            Column(Last_Rcpt_Date_Caption; FieldCaption("Last Rcpt Date")) { }
            Column(Last_Rcpt_Date; "Last Rcpt Date") { }

            column(Quantity_Received_Caption; FieldCaption("Quantity Received")) { }
            column(Quantity_Received; "Quantity Received") { }

        }
    }

    var
        txtTds: Label 'Service Rate';
        txtRestock: Label 'Restocking Time';

}