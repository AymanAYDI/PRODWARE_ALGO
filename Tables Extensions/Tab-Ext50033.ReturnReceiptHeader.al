tableextension 50033 "Return Receipt Header" extends "Return Receipt Header"
{
    //t6660
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
        }
        field(50002; "Packing Number"; Code[20])
        {
            Caption = 'Packing Number';
            DataClassification = CustomerContent;
        }

    }

}