pageextension 50045 "Posted Purchase Rcpt. Subform" extends "Posted Purchase Rcpt. Subform"
{
    //p137
    layout
    {
        addafter(Correction)
        {
            field("Vendor Item No."; Rec."Vendor Item No.")
            {
                ApplicationArea = ALL;
            }
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = ALL;
            }
            field("P.O."; Rec."P.O.")
            {
                ApplicationArea = ALL;
            }
            field("Development Order"; Rec."Development Order")
            {
                ApplicationArea = ALL;
            }
        }
    }
}
