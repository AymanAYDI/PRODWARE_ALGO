
table 50009 "Temp Receipt Line"
{
    Caption = 'Temp Receipt Line';

    fields
    {
        field(1; "Group Code"; Code[30])
        {
            Caption = 'Code regroupement';
            DataClassification = CustomerContent;
        }
        field(2; "Buy-from Vendor No."; Code[20])
        {
            Caption = 'N° Fournisseur';
            DataClassification = CustomerContent;
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Date de comptabilisation';
            DataClassification = CustomerContent;
        }
        field(4; "ItemNo."; Code[20])
        {
            Caption = 'N° Article';
            DataClassification = CustomerContent;
        }
        field(5; Model; Text[30])
        {
            Caption = 'Modéle';
            DataClassification = CustomerContent;
        }
        field(6; "Vendor Shipment No."; Code[20])
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Lookup("Purch. Rcpt. Header"."Vendor Shipment No." WHERE("Buy-from Vendor No." = FIELD("Buy-from Vendor No."),
                                                                                    "No." = FIELD("Document No.")));
            Caption = 'N° BL fournisseur';
        }
        field(7; "Document No."; Code[10])
        {
            Caption = 'N° Document';
            DataClassification = CustomerContent;
        }
        field(8; "Receipt Qty"; Decimal)
        {
            Caption = 'Quantité reçue';
            DataClassification = CustomerContent;
        }
        field(9; "Order No."; Code[10])
        {
            Caption = 'N° commande';
            DataClassification = CustomerContent;
        }
        field(10; "P.O."; Text[30])
        {
            Caption = 'N° scellé';
            DataClassification = CustomerContent;
        }
        field(11; "Direct Unit Cost"; Decimal)
        {
            Caption = 'Coût Unitaire';
            DataClassification = CustomerContent;
        }
        field(12; Description; Text[50])
        {
            Caption = 'Designation';
            DataClassification = CustomerContent;
        }
        field(13; Description2; Text[50])
        {
            Caption = 'Designation 2';
            DataClassification = CustomerContent;
        }
        field(14; "LineNo."; Integer)
        {
            Caption = 'N° Ligne traitement import';
            DataClassification = CustomerContent;
        }
        field(15; "Exported Line"; Boolean)
        {
            Caption = 'Ligne exportée';
            DataClassification = CustomerContent;
        }
        field(16; "Line No."; Integer)
        {
            Caption = 'N° ligne';
            DataClassification = CustomerContent;
        }
        field(50011; "Vdoc Control No."; Text[30])
        {
            Caption = 'N° Contrôle VDOC';
            DataClassification = CustomerContent;
            Description = 'N° de contrôle VDOC - Cette donnée est importée de l''application VDOC';
        }
        field(50020; "WMS No Imputation"; Text[100])
        {
            Caption = 'No Imputation WMS', Locked = TRUE;
            DataClassification = CustomerContent;
            Description = 'N° imputation - Cette donnée est fournie par l''application WMS';
        }
    }

    keys
    {
        key(Key1; "Group Code", "LineNo.")
        {
        }
    }

    fieldgroups
    {
    }
}

