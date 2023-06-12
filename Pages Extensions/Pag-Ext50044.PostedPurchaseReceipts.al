pageextension 50044 "Posted Purchase Receipts" extends "Posted Purchase Receipts"
{
    //p145
    layout
    {
        addafter("Shipment Method Code")
        {
            field("User ID"; Rec."User ID")
            {
                ApplicationArea = ALL;
            }
            field("Vendor Shipment No."; Rec."Vendor Shipment No.")
            {
                ApplicationArea = ALL;
            }
            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = ALL;
            }
            field("Intranet Export"; Rec."Intranet Export")
            {
                ApplicationArea = ALL;
            }
            field("Development Order"; Rec."Development Order")
            {
                ApplicationArea = ALL;
            }
        }
    }
}
