tableextension 50032 "Return Shipment Line" extends "Return Shipment Line"
{
    //t6651
    fields
    {
        field(50000; "P.O."; Text[30])
        {
            Caption = 'Seal No';
            DataClassification = CustomerContent;
        }
        field(50005; "Vendor Shipment No."; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Purchase Header"."Vendor Shipment No." WHERE("No." = FIELD("Return Order No.")));
            Caption = 'Vendor Shipment No.';
            Editable = false;

        }
        field(50011; "Vdoc Control No."; Text[30])
        {
            Caption = 'N° Contrôle VDOC';
            DataClassification = CustomerContent;
        }
    }

}
