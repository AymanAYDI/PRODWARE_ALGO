pageextension 50039 "Posted Sales Invoice Lines" extends "Posted Sales Invoice Lines"
{
    //p526
    layout
    {
        addafter("Job No.")
        {
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = ALL;
            }
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = ALL;
            }
            field("Cross-Reference Type No."; Rec."Cross-Reference Type No.")
            {
                ApplicationArea = ALL;
            }
            field("Blanket Order No."; Rec."Blanket Order No.")
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
            field("Cross-Reference No."; Rec."Cross-Reference No.")
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
            field("Shipment Date"; Rec."Shipment Date")
            {
                ApplicationArea = ALL;
            }
            field("Posting Group"; Rec."Posting Group")
            {
                ApplicationArea = ALL;
            }
            field("Exit Point"; Rec."Exit Point")
            {
                ApplicationArea = ALL;
            }
        }
    }
}
