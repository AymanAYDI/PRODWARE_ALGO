tableextension 50023 "Sales Header Archive" extends "Sales Header Archive"
{
    //t5107
    fields
    {
        field(50000; PO; Code[20])
        {
            Caption = 'PO';
            DataClassification = CustomerContent;
        }
        field(50001; PROFORMA; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50002; "Packing Number"; Code[20])
        {
            Caption = 'Packing Number';
            DataClassification = CustomerContent;
        }

    }

}