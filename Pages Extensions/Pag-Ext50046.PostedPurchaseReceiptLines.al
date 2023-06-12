pageextension 50046 "Posted Purchase Receipt Lines" extends "Posted Purchase Receipt Lines"
{
    //p528
    layout
    {
        addafter("Quantity Invoiced")
        {
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = ALL;
            }
            field("Direct Unit Cost"; Rec."Direct Unit Cost")
            {
                ApplicationArea = ALL;
            }
            field("Qty. Rcd. Not Invoiced"; Rec."Qty. Rcd. Not Invoiced")
            {
                ApplicationArea = ALL;
            }
            field("P.O."; Rec."P.O.")
            {
                ApplicationArea = ALL;
            }
            field("Lead Time Calculation"; Rec."Lead Time Calculation")
            {
                ApplicationArea = ALL;
            }
            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = ALL;
            }
            field("Promised Receipt Date"; Rec."Promised Receipt Date")
            {
                ApplicationArea = ALL;
            }
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = ALL;
            }
            field("Vendor Shipment No."; Rec."Vendor Shipment No.")
            {
                ApplicationArea = ALL;
            }
            field("Valuation received"; Rec."Valuation received")
            {
                ApplicationArea = ALL;
            }
        }
    }
}
