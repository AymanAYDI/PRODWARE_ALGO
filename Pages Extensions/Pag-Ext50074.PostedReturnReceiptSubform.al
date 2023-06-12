pageextension 50074 "Posted Return Receipt Subform" extends "Posted Return Receipt Subform"
{
    //p6661
    layout
    {
        addafter("Shortcut Dimension 2 Code")
        {
            field(PO; Rec.PO)
            {
                ApplicationArea = ALL;
            }
        }
    }
}
