pageextension 50014 "Sales Return Order Subform" extends "Sales Return Order Subform"
{
    //p6631
    layout
    {
        addafter("ShortcutDimCode[8]")
        {
            field(PO; Rec.PO)
            {
                ApplicationArea = ALL;
            }
        }
    }
}