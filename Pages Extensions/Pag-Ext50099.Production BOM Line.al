pageextension 50099 "Production BOM Lines" extends "Production BOM Lines"
{
    //p99000788
    layout
    {
        addafter("No.")
        {
            field("Raw material sale"; Rec."Raw Material sale")
            {
                ApplicationArea = ALL;
            }
        }
    }
}

