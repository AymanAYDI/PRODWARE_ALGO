table 50028 "Unit Cost Budget Per Vendor"
{
    Caption = 'Unit Cost Budget Per Vendor';

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
            NotBlank = true;
            TableRelation = Item;
        }
        field(2; "Vendor No."; Code[20])
        {
            Caption = 'Vendor';
            DataClassification = CustomerContent;
            NotBlank = true;
            TableRelation = Vendor;
        }
        field(3; "Market Share"; Decimal)
        {
            Caption = 'Market share';
            DataClassification = CustomerContent;
            MinValue = 0;
            MaxValue = 100;
        }
        field(4; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                IF ("Starting Date" > "Ending Date") AND ("Ending Date" <> 0D) THEN
                    ERROR(Text000, FIELDCAPTION("Starting Date"), FIELDCAPTION("Ending Date"));

                IF CurrFieldNo = 0 THEN
                    EXIT;

                "Last Modified Date" := CREATEDATETIME(TODAY(), TIME());
                "Last Modified by" := USERID();
            end;
        }
        field(5; "Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            begin
                "Last Modified Date" := CREATEDATETIME(TODAY(), TIME());
                "Last Modified by" := USERID();
            end;
        }
        field(13; "Cost Type"; Option)
        {
            Caption = 'Cost Type';
            DataClassification = CustomerContent;
            // OptionCaption = ',Budget Unit Cost,Revised Unit Cost,Vendor Unit Cost,Revised Vendor Unit Cost';
            OptionCaption = ',C.U.B.,C.U.R.,C.U.F.,C.U.F.R.', locked = true;
            OptionMembers = ,"C.U.B.","C.U.R.","C.U.F.","C.U.F.R.";
        }
        field(15; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
            DataClassification = CustomerContent;

            trigger OnLookup()
            begin

                "Last Modified Date" := CREATEDATETIME(TODAY(), TIME());
                "Last Modified by" := USERID();
            end;

            trigger OnValidate()
            begin
                IF CurrFieldNo = 0 THEN
                    EXIT;

                VALIDATE("Starting Date");
            end;
        }
        field(5400; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            DataClassification = CustomerContent;
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(5700; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            DataClassification = CustomerContent;
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(50000; "Forecasted Quantity"; Decimal)
        {
            Caption = 'Forecasted Quantity';
            DataClassification = CustomerContent;
        }
        field(50001; "Last Modified by"; Code[50])
        {
            Caption = 'Last Modified by';
            DataClassification = CustomerContent;
            Editable = false;
            NotBlank = true;
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                LoginMgt: Codeunit "User Management";
            begin
                LoginMgt.LookupUserID("Last Modified by");
            end;

            trigger OnValidate()
            var
                LoginMgt: Codeunit "User Management";
            begin
                LoginMgt.ValidateUserID("Last Modified by");
            end;
        }
        field(50002; "Last Modified Date"; DateTime)
        {
            Caption = 'Last Modified date';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Item No.", "Vendor No.", "Starting Date", "Cost Type")
        {
        }
        key(Key2; "Cost Type", "Item No.", "Starting Date", "Variant Code", "Unit of Measure Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        TESTFIELD("Item No.");
        TestField("Vendor No.");
    end;

    trigger OnRename()
    begin
        TESTFIELD("Item No.");
        TestField("Vendor No.");
        TESTFIELD("Cost Type");
    end;

    var
        Text000: Label '%1 cannot be after %2';
}

