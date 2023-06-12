table 50003 "Packing Header ALGO"
{
    // version ALG1.00.00.00,ALG1.20

    // ------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // ------------------------------------------------------------------------
    // 
    // //>>ALG1.00.00.00
    // 
    // FEVT004.001:10/02/2007 CASC : Packing List
    // 
    // //>>ALG1.20
    // P18635_002.001 DO:ALMI 02/04/2013  : Fe-Gestion de colissage Prod'WIM
    //                                     - Change key

    Caption = 'Packing Header ALGO';
    DrillDownPageID = 50006;
    LookupPageID = 50006;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(2; Date; Date)
        {
            Caption = 'Date';
            DataClassification = CustomerContent;
        }
        field(3; "Shipment Adress"; Text[60])
        {
            Caption = 'Shipment Adress';
            DataClassification = CustomerContent;
        }
        field(4; "Shipment Method"; Text[60])
        {
            Caption = 'Shipment Method';
            DataClassification = CustomerContent;
        }
        field(5; "Document No."; Code[10])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(6; "Document Type"; Option)
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
            OptionCaption = 'Warehouse Shipment,Invoice';
            OptionMembers = "Warehouse Shipment",Invoice;
        }
        field(7; "Customer Code"; Code[20])
        {
            Caption = 'Customer Code';
            DataClassification = CustomerContent;
        }
        field(8; "Posting Number"; Code[20])
        {
            Caption = 'Posting Number';
            DataClassification = CustomerContent;
        }
        field(9; "Invoice Number"; Code[20])
        {
            Caption = 'Invoice Number';
            DataClassification = CustomerContent;
        }
        field(10; "Warehouse Shipment No."; Code[20])
        {
            Caption = 'Warehouse Shipment No.';
            DataClassification = CustomerContent;
        }
        field(12; "Series No."; Code[20])
        {
            Caption = 'Series No.';
            DataClassification = CustomerContent;
        }
        field(20; "Shipment Qty. Outstanding"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Sum("Warehouse Shipment Line"."Qty. Outstanding" WHERE("No." = FIELD("Warehouse Shipment No.")));
            Caption = 'Qté ouverte expédition magasin';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "Warehouse Shipment No.")
        {
        }
    }

    fieldgroups
    {
    }
}

