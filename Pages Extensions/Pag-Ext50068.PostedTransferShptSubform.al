pageextension 50068 "Posted Transfer Shpt. Subform" extends "Posted Transfer Shpt. Subform"
{
    //p5744
    layout
    {
        addafter("Shortcut Dimension 2 Code")
        {
            field("Quantity (Base)"; Rec."Quantity (Base)")
            {
                ApplicationArea = ALL;
            }
            field("Outstanding qty to ship"; Rec."Outstanding qty to ship")
            {
                ApplicationArea = ALL;
            }
            field("Initial Quantity"; Rec."Initial Quantity")
            {
                ApplicationArea = ALL;
            }

            field("Tracking No."; Rec."Tracking No.")
            {
                ApplicationArea = ALL;
            }
        }
    }
}
