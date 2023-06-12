pageextension 50078 "Work Center Card" extends "Work Center Card"
{
    //p99000754
    layout
    {
        addafter(Warehouse)
        {
            group(ALGO)
            {
                Caption = 'ALGO', Locked = true;
                field("Consumption Location"; Rec."Consumption Location")
                {
                    ApplicationArea = ALL;
                }
            }
        }
    }
}
