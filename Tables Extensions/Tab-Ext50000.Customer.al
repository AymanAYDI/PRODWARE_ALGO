tableextension 50000 "Customer" extends Customer
{
    //t18
    fields
    {
        field(50002; "Bank Account n°"; Code[20])
        {
            Caption = 'Bank Account N°';
            TableRelation = "Bank Account";
            DataClassification = CustomerContent;
        }
        field(50003; "Customer Class"; Option)
        {
            Caption = 'Type Client';
            OptionCaption = ',End Product Manufacturer,Recipient';
            OptionMembers = " ",PF,Prestataire;
            DataClassification = CustomerContent;
        }
    }
}
