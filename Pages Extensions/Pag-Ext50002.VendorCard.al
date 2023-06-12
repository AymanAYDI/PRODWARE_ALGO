pageextension 50002 "Vendor Card" extends "Vendor Card"
{
    layout
    {
        addafter(General)
        {
            group(ALGO)
            {
                Caption = 'ALGO', Locked = true;
                field("Vendor Class"; Rec."Vendor Class")
                {
                    ApplicationArea = ALL;
                }
                field("GED Class"; Rec."GED Class")
                {
                    ApplicationArea = ALL;
                }
            }
        }
    }
}