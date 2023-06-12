pageextension 50040 "Posted Sales Credit Memos" extends "Posted Sales Credit Memos"
{
    //p144
    layout
    {
        addafter("Document Exchange Status")
        {
            field("Currency Factor"; Rec."Currency Factor")
            {
                ApplicationArea = ALL;
            }
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = ALL;
            }
            field("Intranet Export"; Rec."Intranet Export")
            {
                ApplicationArea = ALL;
            }

        }
    }
}
