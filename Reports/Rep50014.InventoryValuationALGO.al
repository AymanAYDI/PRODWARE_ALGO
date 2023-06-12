report 50014 "Inventory Valuation - ALGO"
{
    // version NAVW113.01,ALGO13.00

    // //>>ALGO13.00
    //     - Copy From 1001
    //     - Export 2 Excel
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports/Rep50014.InventoryValuationALGO.rdl';

    Caption = 'Inventory Valuation';
    EnableHyperlinks = true;
    ApplicationArea = Basic, Suite;
    UsageCategory = ReportsAndAnalysis;


    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING("Inventory Posting Group") WHERE(Type = CONST(Inventory));
            RequestFilterFields = "No.", "Inventory Posting Group", "Statistics Group";
            column(BoM_Text; BoM_TextLbl)
            {
            }
            column(COMPANYNAME; COMPANYPROPERTY.DisplayName)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }
            column(STRSUBSTNO___1___2__Item_TABLECAPTION_ItemFilter_; StrSubstNo('%1: %2', TableCaption, ItemFilter))
            {
            }
            column(STRSUBSTNO_Text005_StartDateText_; StrSubstNo(Text005, StartDateText))
            {
            }
            column(STRSUBSTNO_Text005_FORMAT_EndDate__; StrSubstNo(Text005, Format(EndDate)))
            {
            }
            column(ShowExpected; ShowExpected)
            {
            }
            column(ItemFilter; ItemFilter)
            {
            }
            column(Inventory_ValuationCaption; Inventory_ValuationCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(This_report_includes_entries_that_have_been_posted_with_expected_costs_Caption; This_report_includes_entries_that_have_been_posted_with_expected_costs_CaptionLbl)
            {
            }
            column(ItemNoCaption; ValueEntry.FieldCaption("Item No."))
            {
            }
            column(ItemDescriptionCaption; FieldCaption(Description))
            {
            }
            column(IncreaseInvoicedQtyCaption; IncreaseInvoicedQtyCaptionLbl)
            {
            }
            column(DecreaseInvoicedQtyCaption; DecreaseInvoicedQtyCaptionLbl)
            {
            }
            column(QuantityCaption; QuantityCaptionLbl)
            {
            }
            column(ValueCaption; ValueCaptionLbl)
            {
            }
            column(InvCostPostedToGL_Caption; InvCostPostedToGL_CaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(Expected_Cost_IncludedCaption; Expected_Cost_IncludedCaptionLbl)
            {
            }
            column(Expected_Cost_Included_TotalCaption; Expected_Cost_Included_TotalCaptionLbl)
            {
            }
            column(Expected_Cost_TotalCaption; Expected_Cost_TotalCaptionLbl)
            {
            }
            column(GetUrlForReportDrilldown; GetUrlForReportDrilldown("No."))
            {
            }
            column(ItemNo; "No.")
            {
            }
            column(ItemDescription; Description)
            {
            }
            column(ItemBaseUnitofMeasure; "Base Unit of Measure")
            {
            }
            column(Item_Inventory_Posting_Group; "Inventory Posting Group")
            {
            }
            column(StartingInvoicedValue; StartingInvoicedValue)
            {
                AutoFormatType = 1;
            }
            column(StartingInvoicedQty; StartingInvoicedQty)
            {
                DecimalPlaces = 0 : 5;
            }
            column(StartingExpectedValue; StartingExpectedValue)
            {
                AutoFormatType = 1;
            }
            column(StartingExpectedQty; StartingExpectedQty)
            {
                DecimalPlaces = 0 : 5;
            }
            column(IncreaseInvoicedValue; IncreaseInvoicedValue)
            {
                AutoFormatType = 1;
            }
            column(IncreaseInvoicedQty; IncreaseInvoicedQty)
            {
                DecimalPlaces = 0 : 5;
            }
            column(IncreaseExpectedValue; IncreaseExpectedValue)
            {
                AutoFormatType = 1;
            }
            column(IncreaseExpectedQty; IncreaseExpectedQty)
            {
                DecimalPlaces = 0 : 5;
            }
            column(DecreaseInvoicedValue; DecreaseInvoicedValue)
            {
                AutoFormatType = 1;
            }
            column(DecreaseInvoicedQty; DecreaseInvoicedQty)
            {
                DecimalPlaces = 0 : 5;
            }
            column(DecreaseExpectedValue; DecreaseExpectedValue)
            {
                AutoFormatType = 1;
            }
            column(DecreaseExpectedQty; DecreaseExpectedQty)
            {
                DecimalPlaces = 0 : 5;
            }
            column(EndingInvoicedValue; StartingInvoicedValue + IncreaseInvoicedValue - DecreaseInvoicedValue)
            {
            }
            column(EndingInvoicedQty; StartingInvoicedQty + IncreaseInvoicedQty - DecreaseInvoicedQty)
            {
            }
            column(EndingExpectedValue; StartingExpectedValue + IncreaseExpectedValue - DecreaseExpectedValue)
            {
                AutoFormatType = 1;
            }
            column(EndingExpectedQty; StartingExpectedQty + IncreaseExpectedQty - DecreaseExpectedQty)
            {
            }
            column(CostPostedToGL; CostPostedToGL)
            {
                AutoFormatType = 1;
            }
            column(InvCostPostedToGL; InvCostPostedToGL)
            {
                AutoFormatType = 1;
            }
            column(ExpCostPostedToGL; ExpCostPostedToGL)
            {
                AutoFormatType = 1;
            }

            trigger OnAfterGetRecord()
            begin
                CalcFields("Assembly BOM");

                if EndDate = 0D then
                    EndDate := DMY2Date(31, 12, 9999);

                StartingInvoicedValue := 0;
                StartingExpectedValue := 0;
                StartingInvoicedQty := 0;
                StartingExpectedQty := 0;
                IncreaseInvoicedValue := 0;
                IncreaseExpectedValue := 0;
                IncreaseInvoicedQty := 0;
                IncreaseExpectedQty := 0;
                DecreaseInvoicedValue := 0;
                DecreaseExpectedValue := 0;
                DecreaseInvoicedQty := 0;
                DecreaseExpectedQty := 0;
                InvCostPostedToGL := 0;
                CostPostedToGL := 0;
                ExpCostPostedToGL := 0;

                IsEmptyLine := true;
                ValueEntry.Reset;
                ValueEntry.SetRange("Item No.", "No.");
                ValueEntry.SetFilter("Variant Code", GetFilter("Variant Filter"));
                ValueEntry.SetFilter("Location Code", GetFilter("Location Filter"));
                ValueEntry.SetFilter("Global Dimension 1 Code", GetFilter("Global Dimension 1 Filter"));
                ValueEntry.SetFilter("Global Dimension 2 Code", GetFilter("Global Dimension 2 Filter"));

                if StartDate > 0D then begin
                    ValueEntry.SetRange("Posting Date", 0D, CalcDate('<-1D>', StartDate));
                    ValueEntry.CalcSums("Item Ledger Entry Quantity", "Cost Amount (Actual)", "Cost Amount (Expected)", "Invoiced Quantity");
                    AssignAmounts(ValueEntry, StartingInvoicedValue, StartingInvoicedQty, StartingExpectedValue, StartingExpectedQty, 1);
                    IsEmptyLine := IsEmptyLine and ((StartingInvoicedValue = 0) and (StartingInvoicedQty = 0));
                    if ShowExpected then
                        IsEmptyLine := IsEmptyLine and ((StartingExpectedValue = 0) and (StartingExpectedQty = 0));
                end;

                ValueEntry.SetRange("Posting Date", StartDate, EndDate);
                ValueEntry.SetFilter(
                  "Item Ledger Entry Type", '%1|%2|%3|%4',
                  ValueEntry."Item Ledger Entry Type"::Purchase,
                  ValueEntry."Item Ledger Entry Type"::"Positive Adjmt.",
                  ValueEntry."Item Ledger Entry Type"::Output,
                  ValueEntry."Item Ledger Entry Type"::"Assembly Output");
                ValueEntry.CalcSums("Item Ledger Entry Quantity", "Cost Amount (Actual)", "Cost Amount (Expected)", "Invoiced Quantity");
                AssignAmounts(ValueEntry, IncreaseInvoicedValue, IncreaseInvoicedQty, IncreaseExpectedValue, IncreaseExpectedQty, 1);

                ValueEntry.SetRange("Posting Date", StartDate, EndDate);
                ValueEntry.SetFilter(
                  "Item Ledger Entry Type", '%1|%2|%3|%4',
                  ValueEntry."Item Ledger Entry Type"::Sale,
                  ValueEntry."Item Ledger Entry Type"::"Negative Adjmt.",
                  ValueEntry."Item Ledger Entry Type"::Consumption,
                  ValueEntry."Item Ledger Entry Type"::"Assembly Consumption");
                ValueEntry.CalcSums("Item Ledger Entry Quantity", "Cost Amount (Actual)", "Cost Amount (Expected)", "Invoiced Quantity");
                AssignAmounts(ValueEntry, DecreaseInvoicedValue, DecreaseInvoicedQty, DecreaseExpectedValue, DecreaseExpectedQty, -1);

                ValueEntry.SetRange("Posting Date", StartDate, EndDate);
                ValueEntry.SetRange("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Transfer);
                if ValueEntry.FindSet then
                    repeat
                        if true in [ValueEntry."Valued Quantity" < 0, not GetOutboundItemEntry(ValueEntry."Item Ledger Entry No.")] then
                            AssignAmounts(ValueEntry, DecreaseInvoicedValue, DecreaseInvoicedQty, DecreaseExpectedValue, DecreaseExpectedQty, -1)
                        else
                            AssignAmounts(ValueEntry, IncreaseInvoicedValue, IncreaseInvoicedQty, IncreaseExpectedValue, IncreaseExpectedQty, 1);
                    until ValueEntry.Next = 0;

                IsEmptyLine := IsEmptyLine and ((IncreaseInvoicedValue = 0) and (IncreaseInvoicedQty = 0));
                IsEmptyLine := IsEmptyLine and ((DecreaseInvoicedValue = 0) and (DecreaseInvoicedQty = 0));
                if ShowExpected then begin
                    IsEmptyLine := IsEmptyLine and ((IncreaseExpectedValue = 0) and (IncreaseExpectedQty = 0));
                    IsEmptyLine := IsEmptyLine and ((DecreaseExpectedValue = 0) and (DecreaseExpectedQty = 0));
                end;

                ValueEntry.SetRange("Posting Date", 0D, EndDate);
                ValueEntry.SetRange("Item Ledger Entry Type");
                ValueEntry.CalcSums("Cost Posted to G/L", "Expected Cost Posted to G/L");
                ExpCostPostedToGL += ValueEntry."Expected Cost Posted to G/L";
                InvCostPostedToGL += ValueEntry."Cost Posted to G/L";

                StartingExpectedValue += StartingInvoicedValue;
                IncreaseExpectedValue += IncreaseInvoicedValue;
                DecreaseExpectedValue += DecreaseInvoicedValue;
                CostPostedToGL := ExpCostPostedToGL + InvCostPostedToGL;

                if IsEmptyLine then
                    CurrReport.Skip;

                //Prodware EBO 2013/12/06 C1311-0076>>
                if PrintToExcel then begin
                    MakeExcelDataBody;
                    Clear(LocValue);
                    Clear(LocQty);
                end;
                //Prodware EBO 2013/12/06 C1311-0076<<
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals(
                  StartingExpectedQty, IncreaseExpectedQty, DecreaseExpectedQty,
                  StartingInvoicedQty, IncreaseInvoicedQty, DecreaseInvoicedQty);
                CurrReport.CreateTotals(
                  StartingExpectedValue, IncreaseExpectedValue, DecreaseExpectedValue,
                  StartingInvoicedValue, IncreaseInvoicedValue, DecreaseInvoicedValue,
                  CostPostedToGL, ExpCostPostedToGL, InvCostPostedToGL);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(StartingDate; StartDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Starting Date';
                        ToolTip = 'Specifies the date from which the report or batch job processes information.';
                    }
                    field(EndingDate; EndDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Ending Date';
                        ToolTip = 'Specifies the date to which the report or batch job processes information.';
                    }
                    field(IncludeExpectedCost; ShowExpected)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Include Expected Cost';
                        ToolTip = 'Specifies if you want the report to also show entries that only have expected costs.';
                    }
                    field(PrintToExcel; PrintToExcel)
                    {
                        Caption = 'Print to Excel';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if (StartDate = 0D) and (EndDate = 0D) then
                EndDate := WorkDate;
        end;
    }

    labels
    {
        Inventory_Posting_Group_NameCaption = 'Inventory Posting Group Name';
        Expected_CostCaption = 'Expected Cost';
    }

    trigger OnPostReport()
    begin
        if PrintToExcel then begin
            MakeExcelTotals;
            CreateExcelbook;
        end;
    end;

    trigger OnPreReport()
    begin
        if (StartDate = 0D) and (EndDate = 0D) then
            EndDate := WorkDate;

        if StartDate in [0D, 00000101D] then
            StartDateText := ''
        else
            StartDateText := Format(StartDate - 1);

        ItemFilter := Item.GetFilters;

        //>>ALGO13.00
        if PrintToExcel then
            MakeExcelInfo;
        //<<ALGO13.00
    end;

    var
        Text005: Label 'As of %1';
        ValueEntry: Record "Value Entry";
        ClientTypeManagement: Codeunit ClientTypeManagement;
        StartDate: Date;
        EndDate: Date;
        ShowExpected: Boolean;
        ItemFilter: Text;
        StartDateText: Text[10];
        StartingInvoicedValue: Decimal;
        StartingExpectedValue: Decimal;
        StartingInvoicedQty: Decimal;
        StartingExpectedQty: Decimal;
        IncreaseInvoicedValue: Decimal;
        IncreaseExpectedValue: Decimal;
        IncreaseInvoicedQty: Decimal;
        IncreaseExpectedQty: Decimal;
        DecreaseInvoicedValue: Decimal;
        DecreaseExpectedValue: Decimal;
        DecreaseInvoicedQty: Decimal;
        DecreaseExpectedQty: Decimal;
        BoM_TextLbl: Label 'Base UoM';
        Inventory_ValuationCaptionLbl: Label 'Inventory Valuation';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        This_report_includes_entries_that_have_been_posted_with_expected_costs_CaptionLbl: Label 'This report includes entries that have been posted with expected costs.';
        IncreaseInvoicedQtyCaptionLbl: Label 'Increases (LCY)';
        DecreaseInvoicedQtyCaptionLbl: Label 'Decreases (LCY)';
        QuantityCaptionLbl: Label 'Quantity';
        ValueCaptionLbl: Label 'Value';
        InvCostPostedToGL_CaptionLbl: Label 'Cost Posted to G/L';
        TotalCaptionLbl: Label 'Total';
        Expected_Cost_Included_TotalCaptionLbl: Label 'Expected Cost Included Total';
        Expected_Cost_TotalCaptionLbl: Label 'Expected Cost Total';
        Expected_Cost_IncludedCaptionLbl: Label 'Expected Cost Included';
        InvCostPostedToGL: Decimal;
        CostPostedToGL: Decimal;
        ExpCostPostedToGL: Decimal;
        IsEmptyLine: Boolean;
        "---ALGO---": Integer;
        gdec_NetWeight: Decimal;
        PrintToExcel: Boolean;
        ExcelBuf: Record "Excel Buffer" temporary;
        Location: Record Location;
        LocCode: array[30] of Code[10];
        LocName: array[30] of Text[30];
        LocCount: Integer;
        LocValue: array[30] of Decimal;
        LocQty: array[30] of Decimal;
        RowNumber: Integer;
        Text012: Label 'Data';
        Text013: Label 'Inventory Valuation';

    local procedure AssignAmounts(ValueEntry: Record "Value Entry"; var InvoicedValue: Decimal; var InvoicedQty: Decimal; var ExpectedValue: Decimal; var ExpectedQty: Decimal; Sign: Decimal)
    begin
        InvoicedValue += ValueEntry."Cost Amount (Actual)" * Sign;
        InvoicedQty += ValueEntry."Invoiced Quantity" * Sign;
        ExpectedValue += ValueEntry."Cost Amount (Expected)" * Sign;
        ExpectedQty += ValueEntry."Item Ledger Entry Quantity" * Sign;
    end;

    local procedure GetOutboundItemEntry(ItemLedgerEntryNo: Integer): Boolean
    var
        ItemApplnEntry: Record "Item Application Entry";
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        ItemApplnEntry.SetCurrentKey("Item Ledger Entry No.");
        ItemApplnEntry.SetRange("Item Ledger Entry No.", ItemLedgerEntryNo);
        if not ItemApplnEntry.FindFirst then
            exit(true);

        ItemLedgEntry.SetRange("Item No.", Item."No.");
        ItemLedgEntry.SetFilter("Variant Code", Item.GetFilter("Variant Filter"));
        ItemLedgEntry.SetFilter("Location Code", Item.GetFilter("Location Filter"));
        ItemLedgEntry.SetFilter("Global Dimension 1 Code", Item.GetFilter("Global Dimension 1 Filter"));
        ItemLedgEntry.SetFilter("Global Dimension 2 Code", Item.GetFilter("Global Dimension 2 Filter"));
        ItemLedgEntry."Entry No." := ItemApplnEntry."Outbound Item Entry No.";
        exit(not ItemLedgEntry.Find);
    end;

    procedure SetStartDate(DateValue: Date)
    begin
        StartDate := DateValue;
    end;

    procedure SetEndDate(DateValue: Date)
    begin
        EndDate := DateValue;
    end;

    procedure InitializeRequest(NewStartDate: Date; NewEndDate: Date; NewShowExpected: Boolean)
    begin
        StartDate := NewStartDate;
        EndDate := NewEndDate;
        ShowExpected := NewShowExpected;
    end;

    local procedure GetUrlForReportDrilldown(ItemNumber: Code[20]): Text
    begin
        // Generates a URL to the report which sets tab "Item" and field "Field1" on the request page, such as
        // dynamicsnav://hostname:port/instance/company/runreport?report=5801<&Tenant=tenantId>&filter=Item.Field1:1100.
        // TODO
        // Eventually leverage parameters 5 and 6 of GETURL by adding ",Item,TRUE)" and
        // use filter Item.SETFILTER("No.",'=%1',ItemNumber);.
        exit(GetUrl(ClientTypeManagement.GetCurrentClientType, CompanyName, OBJECTTYPE::Report, REPORT::"Invt. Valuation - Cost Spec.") +
          StrSubstNo('&filter=Item.Field1:%1', ItemNumber));
    end;

    local procedure "-MIGNAV2018-"()
    begin
    end;

    procedure MakeExcelInfo()
    begin
        ExcelBuf.NewRow();
        ExcelBuf.AddColumn('Inventory Valuation', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Today, false, '', false, false, false, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(CompanyName, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(UserId, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        RowNumber += 2;
        FillLocationArrays();
        MakeExcelDataHeader();
    end;

    local procedure MakeExcelDataHeader()
    var
        i: Integer;
    begin
        ExcelBuf.NewRow();
        ExcelBuf.AddColumn('.', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('.', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('.', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('.', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(StrSubstNo(Text005, StartDateText), false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('.', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Increases (LCY)', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('.', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Decreases (LCY)', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('.', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(StrSubstNo(Text005, Format(EndDate)), false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        for i := 1 to LocCount do begin
            ExcelBuf.AddColumn('.', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn(LocName[i], false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        end;
        ExcelBuf.NewRow();
        ExcelBuf.AddColumn(Item.FieldCaption("No."), false, '', true, false, false, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Item.FieldCaption(Description), false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Item.FieldCaption(Item."Inventory Posting Group"), false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Item.FieldCaption("Base Unit of Measure"), false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        for i := 1 to (LocCount + 4) do begin
            ExcelBuf.AddColumn('Quantity', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn('Value', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        end;
        RowNumber += 2;
    end;

    procedure MakeExcelDataBody()
    var
        i: Integer;
    begin
        ExcelBuf.NewRow();

        ExcelBuf.AddColumn(Item."No.", false, '', false, false, false, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Item.Description, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Item."Inventory Posting Group", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Item."Base Unit of Measure", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(StartingInvoicedQty, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(StartingInvoicedValue, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(IncreaseInvoicedQty, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(IncreaseInvoicedValue, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(DecreaseInvoicedQty, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(DecreaseInvoicedValue, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);
        if ShowExpected then
            ExcelBuf.AddColumn(StartingExpectedQty + IncreaseExpectedQty - DecreaseExpectedQty, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number)
        else
            ExcelBuf.AddColumn(StartingInvoicedQty + IncreaseInvoicedQty - DecreaseInvoicedQty, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);

        if ShowExpected then
            ExcelBuf.AddColumn(StartingExpectedValue + IncreaseExpectedValue - DecreaseExpectedValue, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number)
        else
            ExcelBuf.AddColumn(StartingInvoicedValue + IncreaseInvoicedValue - DecreaseInvoicedValue, false, '', false, false, false, '', ExcelBuf."Cell Type"::Number);

        for i := 1 to LocCount do begin
            ExcelBuf.AddColumn(LocQty[i], false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
            ExcelBuf.AddColumn(LocValue[i], false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        end;
        RowNumber += 1;
    end;

    procedure CreateExcelbook()
    begin
        ExcelBuf.CreateBookAndOpenExcel('', Text012, Text013, CompanyName(), UserId());
    end;

    procedure FillLocationArrays()
    begin
        if Location.FindSet() then
            repeat
                LocCount += 1;
                LocCode[LocCount] := Location.Code;
                LocName[LocCount] := Location.Name;
            until Location.Next() = 0;
    end;

    procedure MakeExcelTotals()
    begin
        ExcelBuf.NewRow();
        ExcelBuf.NewRow();
        ExcelBuf.AddColumn('Total', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('', false, '', true, false, false, '', ExcelBuf."Cell Type"::Text);

        AddFormula('SUM(E1:E' + Format(RowNumber) + ')');
        AddFormula('SUM(F1:F' + Format(RowNumber) + ')');
        AddFormula('SUM(G1:G' + Format(RowNumber) + ')');
        AddFormula('SUM(H1:H' + Format(RowNumber) + ')');
        AddFormula('SUM(I1:I' + Format(RowNumber) + ')');
        AddFormula('SUM(J1:J' + Format(RowNumber) + ')');
        AddFormula('SUM(K1:K' + Format(RowNumber) + ')');
        AddFormula('SUM(L1:L' + Format(RowNumber) + ')');
        if LocCount >= 1 then begin
            AddFormula('SUM(M1:M' + Format(RowNumber) + ')');
            AddFormula('SUM(N1:N' + Format(RowNumber) + ')');
        end;
        if LocCount >= 2 then begin
            AddFormula('SUM(O1:O' + Format(RowNumber) + ')');
            AddFormula('SUM(P1:P' + Format(RowNumber) + ')');
        end;
        if LocCount >= 3 then begin
            AddFormula('SUM(Q1:Q' + Format(RowNumber) + ')');
            AddFormula('SUM(R1:R' + Format(RowNumber) + ')');
        end;
        if LocCount >= 4 then begin
            AddFormula('SUM(S1:S' + Format(RowNumber) + ')');
            AddFormula('SUM(T1:T' + Format(RowNumber) + ')');
        end;
        if LocCount >= 5 then begin
            AddFormula('SUM(U1:U' + Format(RowNumber) + ')');
            AddFormula('SUM(V1:V' + Format(RowNumber) + ')');
        end;
        if LocCount >= 6 then begin
            AddFormula('SUM(W1:W' + Format(RowNumber) + ')');
            AddFormula('SUM(X1:X' + Format(RowNumber) + ')');
        end;
        if LocCount >= 7 then begin
            AddFormula('SUM(Y1:Y' + Format(RowNumber) + ')');
            AddFormula('SUM(Z1:Z' + Format(RowNumber) + ')');
        end;
        if LocCount >= 8 then begin
            AddFormula('SUM(AA1:AA' + Format(RowNumber) + ')');
            AddFormula('SUM(AB1:AB' + Format(RowNumber) + ')');
        end;
        if LocCount >= 9 then begin
            AddFormula('SUM(AC1..AC' + Format(RowNumber) + ')');
            AddFormula('SUM(AD1..AD' + Format(RowNumber) + ')');
        end;
        if LocCount >= 10 then begin
            AddFormula('SUM(AE1..AE' + Format(RowNumber) + ')');
            AddFormula('SUM(AF1..AF' + Format(RowNumber) + ')');
        end;
        if LocCount >= 11 then begin
            AddFormula('SUM(AG1:AG' + Format(RowNumber) + ')');
            AddFormula('SUM(AH1:AH' + Format(RowNumber) + ')');
        end;
        if LocCount >= 12 then begin
            AddFormula('SUM(AI1:AI' + Format(RowNumber) + ')');
            AddFormula('SUM(AJ1:AJ' + Format(RowNumber) + ')');
        end;
        if LocCount >= 13 then begin
            AddFormula('SUM(AK1:AK' + Format(RowNumber) + ')');
            AddFormula('SUM(AL1:AL' + Format(RowNumber) + ')');
        end;
        if LocCount >= 14 then begin
            AddFormula('SUM(AM:AM' + Format(RowNumber) + ')');
            AddFormula('SUM(AN1:AN' + Format(RowNumber) + ')');
        end;
        if LocCount >= 15 then begin
            AddFormula('SUM(AO1:AO' + Format(RowNumber) + ')');
            AddFormula('SUM(AP1:AP' + Format(RowNumber) + ')');
        end;
        if LocCount >= 16 then begin
            AddFormula('SUM(AQ1:AQ' + Format(RowNumber) + ')');
            AddFormula('SUM(AR1:AR' + Format(RowNumber) + ')');
        end;
        if LocCount >= 17 then begin
            AddFormula('SUM(AS1:AS' + Format(RowNumber) + ')');
            AddFormula('SUM(AT1:AT' + Format(RowNumber) + ')');
        end;
        if LocCount >= 18 then begin
            AddFormula('SUM(AU1:AU' + Format(RowNumber) + ')');
            AddFormula('SUM(AV1:AV' + Format(RowNumber) + ')');
        end;
        if LocCount >= 19 then begin
            AddFormula('SUM(AW1:AW' + Format(RowNumber) + ')');
            AddFormula('SUM(AX1:AX' + Format(RowNumber) + ')');
        end;
        if LocCount >= 20 then begin
            AddFormula('SUM(AY1:AY' + Format(RowNumber) + ')');
            AddFormula('SUM(AZ1:AZ' + Format(RowNumber) + ')');
        end;
        if LocCount >= 21 then begin
            AddFormula('SUM(BA1:BA' + Format(RowNumber) + ')');
            AddFormula('SUM(BB1:BB' + Format(RowNumber) + ')');
        end;
        if LocCount >= 22 then begin
            AddFormula('SUM(BC1:BC' + Format(RowNumber) + ')');
            AddFormula('SUM(BD1:BD' + Format(RowNumber) + ')');
        end;
        if LocCount >= 23 then begin
            AddFormula('SUM(BE1:BE' + Format(RowNumber) + ')');
            AddFormula('SUM(BF1:BF' + Format(RowNumber) + ')');
        end;
        if LocCount >= 24 then begin
            AddFormula('SUM(BG1:BG' + Format(RowNumber) + ')');
            AddFormula('SUM(BH1:BH' + Format(RowNumber) + ')');
        end;
        if LocCount >= 25 then begin
            AddFormula('SUM(BI1:BI' + Format(RowNumber) + ')');
            AddFormula('SUM(BJ1:BJ' + Format(RowNumber) + ')');
        end;
        if LocCount >= 26 then begin
            AddFormula('SUM(BK1:BK' + Format(RowNumber) + ')');
            AddFormula('SUM(BL1:BL' + Format(RowNumber) + ')');
        end;
        if LocCount >= 27 then begin
            AddFormula('SUM(BM1:BM' + Format(RowNumber) + ')');
            AddFormula('SUM(BN1:BN' + Format(RowNumber) + ')');
        end;
        if LocCount >= 28 then begin
            AddFormula('SUM(BO1:BO' + Format(RowNumber) + ')');
            AddFormula('SUM(BP1:BP' + Format(RowNumber) + ')');
        end;
        if LocCount >= 29 then begin
            AddFormula('SUM(BQ1:BQ' + Format(RowNumber) + ')');
            AddFormula('SUM(BR1:BR' + Format(RowNumber) + ')');
        end;
        if LocCount >= 30 then begin
            AddFormula('SUM(BS1:BS' + Format(RowNumber) + ')');
            AddFormula('SUM(BT1:BT' + Format(RowNumber) + ')');
        end;
    end;

    procedure AddFormula(Formula: Text[100])
    begin
        ExcelBuf.AddColumn(Formula, true, '', true, false, false, '', ExcelBuf."Cell Type"::Text);
    end;
}

