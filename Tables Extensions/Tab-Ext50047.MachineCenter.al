tableextension 50047 "Machine Center" extends "Machine Center"
{
    //t99000758
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