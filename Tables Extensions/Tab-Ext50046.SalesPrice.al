tableextension 50046 "Sales Prices" extends "Sales Price"
{
    fields
    {
        field(50000; "Last Modified by"; Code[50])
        {
            Caption = 'Last Modified by';
            DataClassification = CustomerContent;
            Editable = false;
            NotBlank = true;
            TableRelation = User;
            ValidateTableRelation = false;


        }
        field(50001; "Last Modified Date"; DateTime)
        {
            Caption = 'Last Modified date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        //>>#69_20211129
        //>> Activation lignes de code 20221104 - DDE : JVE - EXEC : DSP
        field(50002; "MOQ"; Decimal)
        {
            Caption = 'MOQ';
            DataClassification = CustomerContent;
            Editable = true;
        }
        field(50003; "Multiple"; Decimal)
        {
            Caption = 'Multiple';
            DataClassification = CustomerContent;
            Editable = true;
        }
        //>> Activation lignes de code 20221104 - DDE : JVE - EXEC : DSP
        //<<#69_20211129        
    }
    trigger OnBeforeInsert()
    begin
        "Last Modified Date" := CREATEDATETIME(TODAY(), TIME());
        "Last Modified by" := USERID();
    end;

    trigger OnBeforeModify()
    begin
        "Last Modified Date" := CREATEDATETIME(TODAY(), TIME());
        "Last Modified by" := USERID();
    end;
}