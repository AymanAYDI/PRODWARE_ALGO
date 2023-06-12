pageextension 50091 "General Ledger Entries" extends "General Ledger Entries"
{
    //p20
    layout
    {
        addafter("Document No.")
        {
            field("Source No."; Rec."Source No.")
            {
                ApplicationArea = ALL;
            }
            field("Letter"; Rec."Letter")
            {
                ApplicationArea = ALL;
            }
        }
    }
}