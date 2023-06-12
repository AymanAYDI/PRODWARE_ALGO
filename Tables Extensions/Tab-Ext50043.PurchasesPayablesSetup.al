tableextension 50043 "Purchases & Payables Setup" extends "Purchases & Payables Setup"  //MyTargetTableId
{
    //t312
    fields
    {
        field(50000; "Intranet Directory"; Text[250])
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