tableextension 50022 "Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    //t311
    fields
    {
        field(50001; "Packing List No."; Code[20])
        {
            Caption = 'Packing List No.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(50002; "Intranet Directory"; Text[250])
        {
            Caption = 'Intranet Directory';
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                FileMgt: Codeunit "File Management";
                FileName: Text;
                Path: Text;
                Text001: Label 'Choose Path for Intranet Export';
            begin
                FileName := '*.pdf';
                FileName := FileMgt.SaveFileDialog(Text001, FileName, '');
                Path := FileMgt.GetDirectoryName(FileName);
                IF Path <> '' THEN
                    "Intranet Directory" := COPYSTR(Path, 1, 250);
            end;
        }

    }

}