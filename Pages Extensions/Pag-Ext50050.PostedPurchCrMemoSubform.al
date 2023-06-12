pageextension 50050 "Posted Purch. Cr. Memo Subform" extends "Posted Purch. Cr. Memo Subform"
{
    //p141
    layout
    {
        addafter("Shortcut Dimension 2 Code")
        {
            field("Location Code"; Rec."Location Code")
            {
                ApplicationArea = ALL;
            }
            field("P.O."; Rec."P.O.")
            {
                ApplicationArea = ALL;
            }

        }
    }
}
