pageextension 50013 "Sales Cr. Memo Subform" extends "Sales Cr. Memo Subform"
{
    //p96
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