tableextension 50028 "Transfer Line" extends "Transfer Line"
{
    //t5741
    fields
    {
        field(50000; "PF concerned"; Text[20])
        {
            Caption = 'Concerned PF';
            DataClassification = CustomerContent;
        }
        field(50001; "Prod. Order Line No."; Text[10])
        {
            Caption = 'Prod. Order Line';
            DataClassification = CustomerContent;
            Editable = true;
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
        field(50004; "Prod. Order No."; Text[100])
        {
            Caption = 'Prod. Order No.';
            DataClassification = CustomerContent;
        }
        field(50005; "Purch. Order No."; Text[100])
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Lookup("Transfer Header"."External Document No." WHERE(Status = FIELD(Status), "No." = FIELD("Document No.")));
            Caption = 'N° CA', locked = true;
        }

    }

    trigger OnInsert()
    var
    begin
        "Planning Flexibility" := "Planning Flexibility"::None;
    end;
}