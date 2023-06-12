pageextension 50104 "Prod Routing Line" extends "Prod. Order Routing"
{
    //p99000817
    layout
    {
        addafter("Fixed Scrap Quantity")
        {
            field("Input Quantity"; Rec."Input Quantity")
            {
                ApplicationArea = ALL;
                enabled = false;
            }
            field("Fixed Scrap Qty. (Accum.)"; Rec."Fixed Scrap Qty. (Accum.)")
            {
                ApplicationArea = ALL;
                enabled = false;
            }
        }
    }
}

