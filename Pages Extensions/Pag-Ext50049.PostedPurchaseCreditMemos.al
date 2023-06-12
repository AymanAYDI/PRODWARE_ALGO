pageextension 50049 "Posted Purchase Credit Memos" extends "Posted Purchase Credit Memos"
{
    //p147
    layout
    {
        addafter("Applies-to Doc. Type")
        {
            field("User ID"; Rec."User ID")
            {
                ApplicationArea = ALL;
            }
            field("Vendor Cr. Memo No."; Rec."Vendor Cr. Memo No.")
            {
                ApplicationArea = ALL;
            }

        }
    }
}
