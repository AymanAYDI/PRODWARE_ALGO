tableextension 50048 "Production BOM Line" extends "Production BOM Line"
{
    //t99000772
    fields
    {
        field(50000; "Raw material sale"; Boolean)
        {
            Caption = 'Vente MP';
            DataClassification = CustomerContent;
        }

    }

}