pageextension 50072 "Posted Return Shipment Lines" extends "Posted Return Shipment Lines"
{

    //p6653
    layout
    {
        addafter("Quantity Invoiced")
        {
            field("P.O."; Rec."P.O.")
            {
                ApplicationArea = ALL;
            }
            field("Return Qty. Shipped Not Invd."; Rec."Return Qty. Shipped Not Invd.")
            {
                ApplicationArea = ALL;
            }
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = ALL;
            }
            field("Direct Unit Cost"; Rec."Direct Unit Cost")
            {
                ApplicationArea = ALL;
            }
            field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
            {
                ApplicationArea = ALL;
            }
            field("Unit Price (LCY)"; Rec."Unit Price (LCY)")
            {
                ApplicationArea = ALL;
            }
        }
    }
}

