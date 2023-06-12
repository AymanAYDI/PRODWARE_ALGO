tableextension 50009 "Item Journal Line" extends "Item Journal Line"
{
    //t83
    fields
    {
        field(50003; "Tracking No."; Text[100])
        {
            Caption = 'No. Lot';
            DataClassification = CustomerContent;
        }

        field(50004; "Qty_Capacity_Posted"; Decimal)
        {
            Caption = 'Quantité Capacité Validée';
            DataClassification = CustomerContent;
        }


    }
}
