tableextension 50031 "Return Shipment Header" extends "Return Shipment Header"
{
    //t6650
    fields
    {
        field(50000; "Vendor Shipment No."; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Purchase Header"."Vendor Shipment No." WHERE("No." = FIELD("Return Order No.")));
            Caption = 'Vendor Shipment No.';
            Editable = false;
        }

    }

}