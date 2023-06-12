pageextension 50021 "Purch. Invoice Subform" extends "Purch. Invoice Subform"
{
    //p55
    layout
    {
        addafter("Line No.")
        {
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = ALL;
            }
            field("Unit Cost"; Rec."Unit Cost")
            {
                ApplicationArea = ALL;
            }
            field(Amount; Rec.Amount)
            {
                ApplicationArea = ALL;
            }
            field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = ALL;
            }
            field("Vdoc Control No."; Rec."Vdoc Control No.")
            {
                ApplicationArea = ALL;
            }
        }
    }
}