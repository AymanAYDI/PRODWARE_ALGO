tableextension 50003 "Item Ledger Entry" extends "Item Ledger Entry"
{
    //t32
    fields
    {
        field(50003; "Tracking No."; Text[100])
        {
            Caption = 'No. Lot';
            DataClassification = CustomerContent;
        }
    }

}
