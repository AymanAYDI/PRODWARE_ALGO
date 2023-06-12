tableextension 50010 "Sales Shipment Header" extends "Sales Shipment Header"
{
    //t110
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
        field(50002; "Shipment No."; Code[20])
        {
            Caption = 'Shipment No.';
            DataClassification = CustomerContent;
        }
        field(50050; "Packing Exported"; Boolean)
        {
            Caption = 'Packing Exported';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

}
