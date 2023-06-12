pageextension 50069 "Posted Return Shipments" extends "Posted Return Shipments"
{
    //p6652
    layout
    {
        addafter("Applies-to Doc. Type")
        {
            field("Return Order No."; Rec."Return Order No.")
            {
                ApplicationArea = ALL;
            }
        }
    }
}
