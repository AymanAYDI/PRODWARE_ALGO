codeunit 50052 "Reports Substitution"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ReportManagement", 'OnAfterSubstituteReport', '', true, true)]
    local procedure "ReportManagement_OnAfterSubstituteReport"
    (
        ReportId: Integer;
        var NewReportId: Integer
    )
    begin
        if ReportId = Report::"Get Source Documents" then
            NewReportId := Report::"Get Source Documents-ALGO";
        if ReportId = Report::"Whse. - Posted Receipt" then
            NewReportId := Report::"Whse. - Posted Receipt - ALGO";
        if ReportId = Report::"Calc. Consumption" then
            NewReportId := Report::"Calc. Consumption - ALGO";
        if ReportId = report::"Item Register - Quantity" then
            NewReportId := Report::"Item Register - Quantity - A";
        if ReportId = report::"Picking List" then
            NewReportId := Report::"Picking List-ALGO";
        if ReportId = report::"Transfer Shipment" then
            NewReportId := Report::"Transfer Shipment - ALGO";
        if ReportId = report::"Purchase - Credit Memo" then
            NewReportId := Report::"Purchase - Credit Memo - A";
    end;

}