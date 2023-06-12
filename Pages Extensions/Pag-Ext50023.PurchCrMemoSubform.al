pageextension 50023 "Purch. Cr. Memo Subform" extends "Purch. Cr. Memo Subform"
{
    //p98
    layout
    {
        addafter("ShortcutDimCode[8]")
        {
            field("P.O."; Rec."P.O.")
            {
                ApplicationArea = ALL;
            }
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = ALL;
            }
            field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = ALL;
            }
        }
    }
}