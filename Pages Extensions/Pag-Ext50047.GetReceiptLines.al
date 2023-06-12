pageextension 50047 "Get Receipt Lines" extends "Get Receipt Lines"
{
    layout
    {
        addafter("Qty. Rcd. Not Invoiced")
        {
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = ALL;
            }
            field("Vendor Shipment No."; Rec."Vendor Shipment No.")
            {
                ApplicationArea = ALL;
            }
        }
    }
}
