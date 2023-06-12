pageextension 50070 "Get Return Shipment Lines" extends "Get Return Shipment Lines"
{
    //p6648
    layout
    {
        addafter("Return Qty. Shipped Not Invd.")
        {
            field("P.O."; Rec."P.O.")
            {
                ApplicationArea = ALL;
            }
        }
    }
}
