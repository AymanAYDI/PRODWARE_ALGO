tableextension 50015 "Sales Cr.Memo Line" extends "Sales Cr.Memo Line"
{
    //t115
    fields
    {
        field(50000; PO; Code[20])
        {
            Caption = 'PO';
            DataClassification = CustomerContent;
        }
        field(50002; "Cust Ref."; Code[20])
        {
            Caption = 'Réf. Cde Client';
            DataClassification = CustomerContent;
        }

    }

}
