pageextension 50056 "Sales Order Archive Subform" extends "Sales Order Archive Subform"
{
    //p5160
    layout
    {
        addafter("Shortcut Dimension 2 Code")
        {
            field(PO; Rec.PO)
            {
                ApplicationArea = ALL;
            }
            field(PROFORMA; Rec.PROFORMA)
            {
                ApplicationArea = ALL;
            }
        }
    }
}
