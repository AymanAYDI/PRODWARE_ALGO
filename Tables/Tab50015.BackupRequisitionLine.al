
table 50015 "Backup Requisition Line"
{
    Caption = 'Backup Requisition Line';

    fields
    {
        field(1; "BCK Worksheet Template Name"; Text[50])
        {
        }
        field(2; "BCK Journal Batch Name"; Text[50])
        {
        }
        field(3; "BCK Line No."; Integer)
        {
        }
        field(4; "BCK Type"; Text[50])
        {
        }
        field(5; "BCK No."; Text[50])
        {
        }
        field(6; "BCK Description"; Text[50])
        {
        }
        field(7; "BCK Description 2"; Text[50])
        {
        }
        field(8; "BCK Quantity"; Decimal)
        {
        }
        field(9; "BCK Vendor No."; Text[50])
        {
        }
        field(10; "BCK Direct Unit Cost"; Decimal)
        {
        }
        field(11; "BCK Due Date"; Date)
        {
        }
        field(12; "BCK Confirmed"; Text[50])
        {
        }
        field(13; "BCK Location Code"; Text[50])
        {
        }
        field(14; "BCK Order Date"; Date)
        {
        }

        field(15; "BCK Supply From"; Text[50])
        {
        }
        field(16; "BCK User ID"; Text[50])
        {
        }
        field(17; "BCK Transfer-from Code"; Text[50])
        {
        }
        field(18; "BCK Transfer Shipment Date"; Date)
        {
        }
        field(19; "BCK Type Order Planning"; Text[50])
        {
        }
        field(20; "BCK MPS Order"; Text[50])
        {
        }
        field(21; "BCK Planning Flexibility"; Text[50])
        {
        }
        field(22; "BCK Gen. Prod. Posting Group"; Text[50])
        {
        }
        field(23; "BCK Remaining Quantity"; Decimal)
        {
        }
        field(24; "BCK Ref. Order Type"; Text[50])
        {
        }
        field(25; "BCK Action Message"; Text[50])
        {
        }
        field(26; "BCK Accept Action Message"; Text[50])
        {
        }

        field(27; "BCK Replenishment System"; Text[50])
        {
        }

        field(28; "BCK Insert Date"; Text[50])
        {
        }

    }

    keys
    {
        key(Key1; "BCK Worksheet Template Name", "BCK Journal Batch Name", "BCK Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}

