pageextension 50071 "Posted Return Shipment Subform" extends "Posted Return Shipment Subform"
{
    //p6651
    layout
    {
        addafter(Correction)
        {
            field("P.O."; Rec."P.O.")
            {
                ApplicationArea = ALL;
            }
        }
    }
}
