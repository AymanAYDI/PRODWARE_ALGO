pageextension 50048 "Posted Purchase Credit Memo" extends "Posted Purchase Credit Memo"
{
    //p140
    layout
    {
        modify("Order Address Code")
        {
            Visible = false;
        }
        addafter("Shipping and Payment")
        {
            group(ALGO)
            {
                Caption = 'ALGO', Locked = true;

                field("Due Date"; Rec."Due Date")
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
}
