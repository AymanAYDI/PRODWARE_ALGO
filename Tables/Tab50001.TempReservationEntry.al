
table 50001 "Temp Reservation Entry"
{
    Caption = 'Temp Reservation Entry';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'No. Sequence';
            DataClassification = CustomerContent;
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'N° Article';
            DataClassification = CustomerContent;
        }
        field(3; "Create Date"; Date)
        {
            Caption = 'Date de création';
            DataClassification = CustomerContent;
        }

        field(4; "Quantity"; Decimal)
        {
            Caption = 'Quantité reservée';
            DataClassification = CustomerContent;
        }
        field(5; "Order No."; Code[10])
        {
            Caption = 'N° commande';
            DataClassification = CustomerContent;
        }

        field(6; "Export WMS"; Boolean)
        {
            Caption = 'Export WMS';
            DataClassification = CustomerContent;
        }
        field(7; "Customer No."; Code[20])
        {
            Caption = 'Code Client';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(Key1; "Entry No.", "Item No.")
        {
        }
    }

    fieldgroups
    {
    }
}

