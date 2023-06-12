tableextension 50013 "Sales Invoice Line" extends "Sales Invoice Line"
{
    //t113
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
            Caption = 'Réf. Cde Client';
            DataClassification = CustomerContent;
        }
        field(50004; "Order Qty"; Decimal)
        {
            Caption = 'Qté commandée';
            DataClassification = CustomerContent;
        }
        field(50005; "Promised Delivery Date"; Date)
        {
            Caption = 'Date livraison confirmée';
            DataClassification = CustomerContent;
        }

    }

}
