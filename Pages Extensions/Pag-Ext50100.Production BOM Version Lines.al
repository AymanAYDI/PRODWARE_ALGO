pageextension 50100 "Production BOM Version Lines" extends "Production BOM Version Lines"
{
    //p99000789
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

