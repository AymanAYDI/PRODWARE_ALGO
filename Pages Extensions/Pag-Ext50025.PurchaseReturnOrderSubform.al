pageextension 50025 "Purchase Return Order Subform" extends "Purchase Return Order Subform"
{
    //p6641
    layout
    {
        addafter("ShortcutDimCode[8]")
        {
            field("P.O."; Rec."P.O.")
            {
                ApplicationArea = ALL;
            }
            field("Vdoc Delivery Order No."; Rec."Vdoc Delivery Order No.")
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
