tableextension 50024 "Sales Line Archive" extends "Sales Line Archive"
{
    //t5108
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

    }

}