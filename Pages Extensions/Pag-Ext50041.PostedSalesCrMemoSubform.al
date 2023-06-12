pageextension 50041 "Posted Sales Cr. Memo Subform" extends "Posted Sales Cr. Memo Subform"
{
    //p135
    layout
    {
        addafter("Shortcut Dimension 2 Code")
        {
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = ALL;
            }
            field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = ALL;
            }
            field(PO; Rec.PO)
            {
                ApplicationArea = ALL;
            }
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = ALL;
            }
        }
    }
}
