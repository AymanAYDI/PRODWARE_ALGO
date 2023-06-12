tableextension 50018 "Purch. Cr. Memo Hdr." extends "Purch. Cr. Memo Hdr."
{
    //t124
    fields
    {
        field(50000; "Vendor Shipment No."; Code[20])
        {
            Caption = 'Vendor Shipment No.';
            FieldClass = FlowField;
            CalcFormula = Lookup("Purchase Header"."Vendor Shipment No." WHERE("No." = field("Return Order No.")));
            Editable = false;
        }

    }

}