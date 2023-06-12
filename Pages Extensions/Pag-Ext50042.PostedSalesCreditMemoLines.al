pageextension 50042 "Posted Sales Credit Memo Lines" extends "Posted Sales Credit Memo Lines"
{
    //p527
    layout
    {
        addafter("Job No.")
        {
            field("Shipment Date"; Rec."Shipment Date")
            {
                ApplicationArea = ALL;
            }
            field("Location Code"; Rec."Location Code")
            {
                ApplicationArea = ALL;
            }
            field("Posting Group"; Rec."Posting Group")
            {
                ApplicationArea = ALL;
            }
            field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
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
