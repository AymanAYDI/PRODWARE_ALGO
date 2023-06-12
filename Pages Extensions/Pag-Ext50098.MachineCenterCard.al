pageextension 50098 "Machine Center Card" extends "Machine Center Card"
{
    //p99000760
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
