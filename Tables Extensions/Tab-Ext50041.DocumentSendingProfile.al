
tableextension 50041 "Document Sending Profile" extends "Document Sending Profile" //MyTargetTableId
{
    //t60
    procedure Export2IntranetSalesDoc(ReportUsage: Integer; TargetPath: Text; RecordVariant: Variant; DocNo: Code[20]; DocName: Text[150]; ToCust: Code[20]; Year: Integer): Text[255]
    var
        ReportSelections: Record "Report Selections";
    begin
        EXIT(ReportSelections.Export2IntranetSalesDoc(ReportUsage, TargetPath, RecordVariant, DocNo, DocName, ToCust, Year));
    end;

    procedure Export2IntranetPurchDoc(ReportUsage: Integer; TargetPath: Text; RecordVariant: Variant; DocNo: Code[20]; DocName: Text[150]; ToVend: Code[20]): Text[255]
    var
        ReportSelections: Record "Report Selections";
    begin
        EXIT(ReportSelections.Export2IntranetPurchDoc(ReportUsage, TargetPath, RecordVariant, DocNo, DocName, ToVend));
    end;

}