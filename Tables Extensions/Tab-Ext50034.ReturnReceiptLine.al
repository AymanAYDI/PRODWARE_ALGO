tableextension 50034 "Return Receipt Line" extends "Return Receipt Line"
{
    //t6661
    fields
    {
        field(50000; PO; Code[20])
        {
            Caption = 'PO';
            DataClassification = CustomerContent;
        }
    }

}