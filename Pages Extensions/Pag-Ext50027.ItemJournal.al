pageextension 50027 "Item Journal" extends "Item Journal"
{
    //p40
    layout
    {
        addafter("Shpt. Method Code")
        {
            field("Return Reason Code"; Rec."Return Reason Code")
            {
                ApplicationArea = ALL;
            }
        }
    }
}
