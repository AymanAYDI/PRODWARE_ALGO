pageextension 50017 "Purchase Return Order" extends "Purchase Return Order"
{
    //p6640
    layout
    {
        modify("Order Address Code")
        {
            Visible = false;
        }
        addafter("Foreign Trade")
        {
            group(ALGO)
            {
                field("Vendor Shipment No."; Rec."Vendor Shipment No.")
                {
                    ApplicationArea = ALL;
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = ALL;
                }
            }
        }
    }
}