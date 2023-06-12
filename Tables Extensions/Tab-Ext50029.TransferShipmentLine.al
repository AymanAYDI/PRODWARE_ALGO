tableextension 50029 "Transfer Shipment Line" extends "Transfer Shipment Line"
{
    //t5745
    fields
    {
        field(50000; "PF concerned"; Text[20])
        {
            Caption = 'Concerned PF';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50001; "Outstanding qty to ship"; Decimal)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Lookup("Transfer Line"."Outstanding Quantity" WHERE("Document No." = FIELD("Transfer Order No."),
                                                                               "Item No." = FIELD("Item No."),
                                                                               "Line No." = FIELD("Line No.")));
            Caption = 'Qté restante à livrer';

        }
        field(50002; "Initial Quantity"; Decimal)
        {
            Caption = 'Qté Initiale';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(50003; "Tracking No."; Text[100])
        {
            Caption = 'No. Lot';
            DataClassification = CustomerContent;
        }

    }

}