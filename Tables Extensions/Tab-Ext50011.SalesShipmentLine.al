tableextension 50011 "Sales Shipment Line" extends "Sales Shipment Line"
{
    //t111
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
        field(50002; "Cust Ref."; Code[30])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key50; PO)
        {

        }
        key(key51; "Cust Ref.")
        {

        }
    }

}
