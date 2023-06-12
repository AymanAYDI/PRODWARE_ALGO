tableextension 50017 "Purch. Rcpt. Line" extends "Purch. Rcpt. Line"
{
    //t121
    fields
    {
        field(50000; "P.O."; Text[20])
        {
            Caption = 'P.O.';
            DataClassification = CustomerContent;
        }
        field(50001; "Vendor Shipment No."; Code[35])
        {
            Caption = 'Vendor Shipment No.';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Lookup("Purch. Rcpt. Header"."Vendor Shipment No." WHERE("Buy-from Vendor No." = field("Buy-from Vendor No."), "No." = field("Document No.")));
        }
        field(50002; "Exported Line"; Boolean)
        {
            Caption = 'Ligne exportée';
            DataClassification = CustomerContent;
            Editable = true;
        }
        field(50011; "Vdoc Control No."; Text[30])
        {
            Caption = 'N° Contrôle VDOC';
            DataClassification = CustomerContent;
        }
        field(50016; "Development Order"; Boolean)
        {
            Caption = 'Commande Développement';
            DataClassification = CustomerContent;
        }
        field(50017; "Valuation received"; Decimal)
        {
            Caption = 'Valuation received';
            DataClassification = CustomerContent;
        }
        // WMS202001 - n°Imputation WMS
        field(50020; "WMS No Imputation"; Text[100])
        {
            Caption = 'No Imputation WMS', Locked = TRUE;
            DataClassification = CustomerContent;
            Description = 'N° imputation - Cette donnée est fournie par l''application WMS';
        }
    }

}
