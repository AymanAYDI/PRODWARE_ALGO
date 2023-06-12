table 50008 "Production Forecast EntryInit"
{
    // version NAVW16.00

    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Delivery                                                                                       |
    // | http://www.prodware.fr                                                                                         |
    // |                                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // //>>ALGO2.00
    // TO 120716 : ajout du champ 50000
    // +----------------------------------------------------------------------------------------------------------------+

    Caption = 'Production Forecast Entry';

    fields
    {
        field(1; "Production Forecast Name"; Code[10])
        {
            Caption = 'Production Forecast Name';
            DataClassification = CustomerContent;
            TableRelation = "Production Forecast Name";
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
            TableRelation = Item;
        }
        field(4; "Forecast Date"; Date)
        {
            Caption = 'Forecast Date';
            DataClassification = CustomerContent;
        }
        field(5; "Forecast Quantity"; Decimal)
        {
            Caption = 'Forecast Quantity';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                "Forecast Quantity (Base)" := "Forecast Quantity" * "Qty. per Unit of Measure";
            end;
        }
        field(6; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            DataClassification = CustomerContent;
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));

            trigger OnValidate()
            begin
                ItemUnitofMeasure.GET("Item No.", "Unit of Measure Code");
                "Qty. per Unit of Measure" := ItemUnitofMeasure."Qty. per Unit of Measure";
                "Forecast Quantity" := "Forecast Quantity (Base)" / "Qty. per Unit of Measure";
            end;
        }
        field(7; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(8; "Forecast Quantity (Base)"; Decimal)
        {
            Caption = 'Forecast Quantity (Base)';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                IF "Unit of Measure Code" = '' THEN BEGIN
                    Item.GET("Item No.");
                    "Unit of Measure Code" := Item."Sales Unit of Measure";
                    ItemUnitofMeasure.GET("Item No.", "Unit of Measure Code");
                    "Qty. per Unit of Measure" := ItemUnitofMeasure."Qty. per Unit of Measure";
                END;
                VALIDATE("Unit of Measure Code");
            end;
        }
        field(10; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            DataClassification = CustomerContent;
            TableRelation = Location;
        }
        field(12; "Component Forecast"; Boolean)
        {
            Caption = 'Component Forecast';
            DataClassification = CustomerContent;
        }
        field(13; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(50000; "Planning Imported"; Boolean)
        {
            Caption = 'Planning Imported';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Production Forecast Name", "Item No.", "Location Code", "Forecast Date", "Component Forecast")
        {
            SumIndexFields = "Forecast Quantity (Base)";
        }
        key(Key2; "Production Forecast Name", "Item No.", "Component Forecast", "Forecast Date", "Location Code")
        {
            SumIndexFields = "Forecast Quantity (Base)";
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
    begin
        TESTFIELD("Forecast Date");
        TESTFIELD("Production Forecast Name");
        LOCKTABLE();
        PlanningAssignment.AssignOne("Item No.", '', "Location Code", "Forecast Date");
    end;

    trigger OnModify()
    begin
        PlanningAssignment.AssignOne("Item No.", '', "Location Code", "Forecast Date");
    end;

    var
        ItemUnitofMeasure: Record "Item Unit of Measure";
        Item: Record "Item";
        PlanningAssignment: Record "Planning Assignment";
}

