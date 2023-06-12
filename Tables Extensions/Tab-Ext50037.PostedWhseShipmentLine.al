tableextension 50037 "Posted Whse. Shipment Line" extends "Posted Whse. Shipment Line"
{
    //t7323
    fields
    {
        field(50008; "Initial Quantity"; Decimal)
        {
            Caption = 'Qté Initiale';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(50009; "Tracking No."; Text[100])
        {
            Caption = 'No. de Lot';
            DataClassification = CustomerContent;
        }
    }

}