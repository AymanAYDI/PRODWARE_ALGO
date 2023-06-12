table 50023 "Packing Parcel ALGO"
{
    // version ALG1.20

    // //>>ALG1.20
    // P18635_002.001 DO:ALMI 02/04/2013  : Fe-Gestion de colissage Prod'WIM
    //                                     - Create table

    Caption = 'Colis Liste Colisage ALGO';

    fields
    {
        field(1; "Packing Document No."; Code[20])
        {
            Caption = 'N° doc. colisage';
            DataClassification = CustomerContent;
        }
        field(2; "Parcel No. Integer"; Integer)
        {
            Caption = 'N° Colis';
            DataClassification = CustomerContent;
        }
        field(3; "Parcel Weight"; Decimal)
        {
            Caption = 'Poids';
            DataClassification = CustomerContent;
            FieldClass = Normal;
        }
        field(4; "Parcel Quantity"; Decimal)
        {
            Caption = 'Quantité';
            DataClassification = CustomerContent;
            FieldClass = Normal;
        }
        field(5; Pallet; Code[20])
        {
            Caption = 'Pallet';
            DataClassification = CustomerContent;
            FieldClass = Normal;
        }
    }

    keys
    {
        key(Key1; "Packing Document No.", "Parcel No. Integer")
        {
        }
    }

    fieldgroups
    {
    }
}

