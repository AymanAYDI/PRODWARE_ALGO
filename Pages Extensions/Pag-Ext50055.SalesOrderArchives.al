pageextension 50055 "Sales Order Archives" extends "Sales Order Archives"
{
    //p9349
    layout
    {
        addafter("Shipment Date")
        {
            field(PO; Rec.PO)
            {
                ApplicationArea = ALL;
            }
            field(PROFORMA; Rec.PROFORMA)
            {
                ApplicationArea = ALL;
            }
            field("Packing Number"; Rec."Packing Number")
            {
                ApplicationArea = ALL;
            }
        }
    }
}
