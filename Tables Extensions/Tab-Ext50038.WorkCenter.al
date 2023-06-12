tableextension 50038 "Work Center" extends "Work Center"
{
    //t99000754
    fields
    {
        field(50000; "Consumption Location"; Code[10])
        {
            Caption = 'Magasin de consommation';
            DataClassification = CustomerContent;
            TableRelation = Location;
        }

    }

}
