tableextension 50042 "Report Selections" extends "Report Selections" //MyTargetTableId
{
    //t77
    procedure Export2IntranetSalesDoc(ReportUsage: Integer; TargetFilePath: Text; RecordVariant: Variant; DocNo: Code[20]; DocName: Text; CustNo: Code[20]; Year: Integer): Text[255]
    var
        TempReportSelections: Record "Report Selections" temporary;
        ElectronicDocumentFormat: Record "Electronic Document Format";
        ReportLayoutSelection: Record "Report Layout Selection";
        FileManagement: Codeunit "File Management";
        ServerAttachmentFilePath: Text[250];
        ClientAttachmentFileName: Text;
    begin
        FindPrintUsage(ReportUsage, CustNo, TempReportSelections);
        REPEAT
            //ServerAttachmentFilePath := LocalSaveReportAsPDF("Report ID", RecordVariant, "Custom Report Layout Code");
            ServerAttachmentFilePath := CopyStr(FileManagement.ServerTempFileName('pdf'), 1, 250);

            ReportLayoutSelection.SetTempLayoutSelected(TempReportSelections."Custom Report Layout Code");
            REPORT.SaveAsPdf(TempReportSelections."Report ID", ServerAttachmentFilePath, RecordVariant);
            ReportLayoutSelection.SetTempLayoutSelected('');

            ClientAttachmentFileName := ElectronicDocumentFormat.GetAttachmentFileName(DocNo, DocName, 'pdf');
            ClientAttachmentFileName := FileManagement.GetSafeFileName(ClientAttachmentFileName);

            TargetFilePath := FileManagement.CombinePath(FileManagement.CombinePath(TargetFilePath, CustNo), format(Year));

            FileManagement.ServerCreateDirectory(TargetFilePath);
            FileManagement.CopyServerFile(ServerAttachmentFilePath, TargetFilePath + '\' + ClientAttachmentFileName, TRUE);
        UNTIL TempReportSelections.NEXT() = 0;
        EXIT(TargetFilePath + '\' + ClientAttachmentFileName);

    end;

    procedure Export2IntranetPurchDoc(ReportUsage: Integer; TargetFilePath: Text; RecordVariant: Variant; DocNo: Code[20]; DocName: Text; VendNo: Code[20]): Text[255]
    var
        TempReportSelections: Record "Report Selections" temporary;
        ElectronicDocumentFormat: Record "Electronic Document Format";
        ReportLayoutSelection: Record "Report Layout Selection";
        FileManagement: Codeunit "File Management";
        ServerAttachmentFilePath: Text[250];
        ClientAttachmentFileName: Text;
    begin
        FindPrintUsageVendor(ReportUsage, VendNo, TempReportSelections);
        REPEAT
            //ServerAttachmentFilePath := LocalSaveReportAsPDF("Report ID", RecordVariant, "Custom Report Layout Code");
            ServerAttachmentFilePath := CopyStr(FileManagement.ServerTempFileName('pdf'), 1, 250);

            ReportLayoutSelection.SetTempLayoutSelected(TempReportSelections."Custom Report Layout Code");
            REPORT.SaveAsPdf(TempReportSelections."Report ID", ServerAttachmentFilePath, RecordVariant);
            ReportLayoutSelection.SetTempLayoutSelected('');

            ClientAttachmentFileName := ElectronicDocumentFormat.GetAttachmentFileName(DocNo, DocName, 'pdf');
            ClientAttachmentFileName := FileManagement.GetSafeFileName(ClientAttachmentFileName);
            FileManagement.ServerCreateDirectory(TargetFilePath);
            FileManagement.CopyServerFile(ServerAttachmentFilePath, TargetFilePath + '\' + ClientAttachmentFileName, TRUE);
        UNTIL TempReportSelections.NEXT() = 0;
        EXIT(TargetFilePath + '\' + ClientAttachmentFileName);

    end;

    local procedure LocalSaveReportAsPDF(ReportID: Integer; RecordVariant: Variant; LayoutCode: Code[20]) FilePath: Text[250]
    var
        ReportLayoutSelection: Record "Report Layout Selection";
        FileManagement: Codeunit "File Management";
    begin
        FilePath := CopyStr(FileManagement.ServerTempFileName('pdf'), 1, 250);

        ReportLayoutSelection.SetTempLayoutSelected(LayoutCode);
        REPORT.SaveAsPdf(ReportID, FilePath, RecordVariant);
        ReportLayoutSelection.SetTempLayoutSelected('');

        Commit();
    end;

}