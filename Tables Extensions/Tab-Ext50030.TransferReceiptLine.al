tableextension 50030 "Transfer Receipt Line" extends "Transfer Receipt Line"
{
    //t5747
    fields
    {
        field(50003; "Tracking No."; Text[100])
        {
            Caption = 'No. Lot';
            DataClassification = CustomerContent;
        }

    }
}