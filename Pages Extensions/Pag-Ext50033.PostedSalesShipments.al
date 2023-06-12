pageextension 50033 "Posted Sales Shipments" extends "Posted Sales Shipments"
{
    //p142
    layout
    {
        addafter("Shipment Date")
        {
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = ALL;
            }
            field("Packing Exported"; Rec."Packing Exported")
            {
                ApplicationArea = ALL;
            }
        }
    }
}
