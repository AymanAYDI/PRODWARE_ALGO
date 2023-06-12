table 50027 "TQL"
{
    // version ALGO

    // --------------------------------------------------
    // //ALGO_10/04/2015 : Create
    // --------------------------------------------------

    Caption = 'Unit Cost Budget';

    fields
    {
        field(1; "Customer No."; Option)
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
            NotBlank = true;
            OptionMembers = ,GSH,"L/UNIFORM";
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
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
        field(5; Coefmajoration; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Coef Majoration Gamme';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            begin
                "Last Modified Date" := CREATEDATETIME(TODAY(), TIME());
                "Last Modified by" := USERID();
            end;
        }
        field(6; CoefTQL; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(7; CoefExworksSouple; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(8; CoefExworksRigide; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(9; CoefEWSoupleSpecial; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(10; CoefEWRigideSpecial; Decimal)
        {
            DataClassification = CustomerContent;
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
        field(16; CoefmajorationNomenclature; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Coef Majoration Nomenclature';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            begin
                "Last Modified Date" := CREATEDATETIME(TODAY(), TIME());
                "Last Modified by" := USERID();
            end;
        }
        field(50001; "Last Modified by"; Code[20])
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
        key(Key1; "Customer No.", "Starting Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        TESTFIELD("Customer No.");
    end;

    trigger OnRename()
    begin
        //TESTFIELD("Customer No.");
        //TESTFIELD("Cost Type");
    end;

    var
        Text000: Label '%1 cannot be after %2';
}

