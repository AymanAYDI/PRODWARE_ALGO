pageextension 50028 "Phys. Inventory Journal" extends "Phys. Inventory Journal"
{
    //p392
    layout
    {
        addafter("Reason Code")
        {
            field("Tracking No."; Rec."Tracking No.")
            {
                ApplicationArea = ALL;
            }
        }
    }
}
