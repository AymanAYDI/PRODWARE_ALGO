table 50024 "Export Inventory CLIC"
{
    // version ALGO,CLIC


    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
            TableRelation = Item;
        }
        field(2; "Bar code"; Text[13])
        {
            Caption = 'Bar code';
            DataClassification = CustomerContent;
        }
        field(3; Location; Code[10])
        {
            Caption = 'Location';
            DataClassification = CustomerContent;
            TableRelation = Location;
        }
        field(4; "Zone Code"; Code[20])
        {
            Caption = 'Zone Code';
            DataClassification = CustomerContent;
        }
        field(5; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
        }
        field(6; Sequence; Integer)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Item No.", Location, "Zone Code")
        {
        }
    }

    fieldgroups
    {
    }
}

