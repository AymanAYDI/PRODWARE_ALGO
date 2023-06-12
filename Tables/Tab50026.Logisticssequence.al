table 50026 "Logistics sequence"
{
    Caption = 'Logistics sequence';

    fields
    {
        field(1; "Sequence No."; Integer)
        {
            Description = 'N° Sequence Logistique';
            DataClassification = CustomerContent;
        }
        field(2; Date; Date)
        {
            Caption = 'Date';
            DataClassification = CustomerContent;
        }
        field(3; MidiSoir; Text[1])
        {
            Caption = 'MidiSoir';
            DataClassification = CustomerContent;
            Description = '1 pour Midi, 2 pour soir';
        }
    }

    keys
    {
        key(Key1; "Sequence No.")
        {
        }
    }

    fieldgroups
    {
    }
}

