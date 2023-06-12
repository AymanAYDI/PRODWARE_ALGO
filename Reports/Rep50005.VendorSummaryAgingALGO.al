report 50005 "Vendor - Summary Aging - ALGO"
{
    // version NAVW113.00
    // copy from R305

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports/Rep50005.VendorSummaryAgingALGO.rdl';
    ApplicationArea = Basic, Suite;
    Caption = 'Vendor - Summary Aging';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Search Name", "Vendor Posting Group", "Currency Filter";
            column(COMPANYNAME; COMPANYPROPERTY.DisplayName)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }
            column(PrintAmountsInLCY; PrintAmountsInLCY)
            {
            }
            column(Vendor_TABLECAPTION__________VendFilter; TableCaption + ': ' + VendFilter)
            {
            }
            column(VendFilter; VendFilter)
            {
            }
            column(PeriodStartDate_2_; Format(PeriodStartDate[2]))
            {
            }
            column(PeriodStartDate_3_; Format(PeriodStartDate[3]))
            {
            }
            column(PeriodStartDate_4_; Format(PeriodStartDate[4]))
            {
            }
            column(PeriodStartDate_5_; Format(PeriodStartDate[5]))
            {
            }
            column(PeriodStartDate_6_; Format(PeriodStartDate[6]))
            {
            }
            column(PeriodStartDate_7_; Format(PeriodStartDate[7]))
            {
            }
            column(PeriodStartDate_8_; Format(PeriodStartDate[8]))
            {
            }
            column(PeriodStartDate_9_; Format(PeriodStartDate[9]))
            {
            }
            column(PeriodStartDate_10_; Format(PeriodStartDate[10]))
            {
            }
            column(PeriodStartDate_11_; Format(PeriodStartDate[11]))
            {
            }
            column(PeriodStartDate_12_; Format(PeriodStartDate[12]))
            {
            }
            column(PeriodStartDate_13_; Format(PeriodStartDate[13]))
            {
            }
            column(PeriodStartDate_3____1; Format(PeriodStartDate[3] - 1))
            {
            }
            column(PeriodStartDate_4____1; Format(PeriodStartDate[4] - 1))
            {
            }
            column(PeriodStartDate_5____1; Format(PeriodStartDate[5] - 1))
            {
            }
            column(PeriodStartDate_6____1; Format(PeriodStartDate[6] - 1))
            {
            }
            column(PeriodStartDate_7____1; Format(PeriodStartDate[7] - 1))
            {
            }
            column(PeriodStartDate_8____1; Format(PeriodStartDate[8] - 1))
            {
            }
            column(PeriodStartDate_9____1; Format(PeriodStartDate[9] - 1))
            {
            }
            column(PeriodStartDate_10____1; Format(PeriodStartDate[10] - 1))
            {
            }
            column(PeriodStartDate_11____1; Format(PeriodStartDate[11] - 1))
            {
            }
            column(PeriodStartDate_12____1; Format(PeriodStartDate[12] - 1))
            {
            }
            column(PeriodStartDate_13____1; Format(PeriodStartDate[13] - 1))
            {
            }
            column(PeriodStartDate_14____1; Format(PeriodStartDate[14] - 1))
            {
            }
            column(PrintLine; PrintLine)
            {
            }
            column(VendBalanceDueLCY_1_; VendBalanceDueLCY[1])
            {
                AutoFormatType = 1;
            }
            column(VendBalanceDueLCY_2_; VendBalanceDueLCY[2])
            {
                AutoFormatType = 1;
            }
            column(VendBalanceDueLCY_3_; VendBalanceDueLCY[3])
            {
                AutoFormatType = 1;
            }
            column(VendBalanceDueLCY_4_; VendBalanceDueLCY[4])
            {
                AutoFormatType = 1;
            }
            column(VendBalanceDueLCY_5_; VendBalanceDueLCY[5])
            {
                AutoFormatType = 1;
            }
            column(VendBalanceDueLCY_6_; VendBalanceDueLCY[6])
            {
                AutoFormatType = 1;
            }
            column(VendBalanceDueLCY_7_; VendBalanceDueLCY[7])
            {
                AutoFormatType = 1;
            }
            column(VendBalanceDueLCY_8_; VendBalanceDueLCY[8])
            {
                AutoFormatType = 1;
            }
            column(VendBalanceDueLCY_9_; VendBalanceDueLCY[9])
            {
                AutoFormatType = 1;
            }
            column(VendBalanceDueLCY_10_; VendBalanceDueLCY[10])
            {
                AutoFormatType = 1;
            }
            column(VendBalanceDueLCY_11_; VendBalanceDueLCY[11])
            {
                AutoFormatType = 1;
            }
            column(VendBalanceDueLCY_12_; VendBalanceDueLCY[12])
            {
                AutoFormatType = 1;
            }
            column(VendBalanceDueLCY_13_; VendBalanceDueLCY[13])
            {
                AutoFormatType = 1;
            }
            column(VendBalanceDueLCY_14_; VendBalanceDueLCY[14])
            {
                AutoFormatType = 1;
            }
            column(TotalVendAmtDueLCY; TotalVendAmtDueLCY)
            {
                AutoFormatType = 1;
            }
            column(LineTotalVendAmountDue; LineTotalVendAmountDue)
            {
                AutoFormatType = 1;
            }
            column(VendBalanceDue_14_; VendBalanceDue[14])
            {
                AutoFormatType = 1;
            }
            column(VendBalanceDue_13_; VendBalanceDue[13])
            {
                AutoFormatType = 1;
            }
            column(VendBalanceDue_12_; VendBalanceDue[12])
            {
                AutoFormatType = 1;
            }
            column(VendBalanceDue_11_; VendBalanceDue[11])
            {
                AutoFormatType = 1;
            }
            column(VendBalanceDue_10_; VendBalanceDue[10])
            {
                AutoFormatType = 1;
            }
            column(VendBalanceDue_9_; VendBalanceDue[9])
            {
                AutoFormatType = 1;
            }
            column(VendBalanceDue_8_; VendBalanceDue[8])
            {
                AutoFormatType = 1;
            }
            column(VendBalanceDue_7_; VendBalanceDue[7])
            {
                AutoFormatType = 1;
            }
            column(VendBalanceDue_6_; VendBalanceDue[6])
            {
                AutoFormatType = 1;
            }
            column(VendBalanceDue_5_; VendBalanceDue[5])
            {
                AutoFormatType = 1;
            }
            column(VendBalanceDue_4_; VendBalanceDue[4])
            {
                AutoFormatType = 1;
            }
            column(VendBalanceDue_3_; VendBalanceDue[3])
            {
                AutoFormatType = 1;
            }
            column(VendBalanceDue_2_; VendBalanceDue[2])
            {
                AutoFormatType = 1;
            }
            column(VendBalanceDue_1_; VendBalanceDue[1])
            {
                AutoFormatType = 1;
            }
            column(Vendor_Name; Name)
            {
            }
            column(Vendor__No__; "No.")
            {
            }
            column(InVendBalanceDueLCY_1; InVendBalanceDueLCY[1])
            {
                AutoFormatType = 1;
            }
            column(InVendBalanceDueLCY_2; InVendBalanceDueLCY[2])
            {
                AutoFormatType = 1;
            }
            column(InVendBalanceDueLCY_3; InVendBalanceDueLCY[3])
            {
                AutoFormatType = 1;
            }
            column(InVendBalanceDueLCY_4; InVendBalanceDueLCY[4])
            {
                AutoFormatType = 1;
            }
            column(InVendBalanceDueLCY_5; InVendBalanceDueLCY[5])
            {
                AutoFormatType = 1;
            }
            column(InVendBalanceDueLCY_6; InVendBalanceDueLCY[6])
            {
                AutoFormatType = 1;
            }
            column(InVendBalanceDueLCY_7; InVendBalanceDueLCY[7])
            {
                AutoFormatType = 1;
            }
            column(InVendBalanceDueLCY_8; InVendBalanceDueLCY[8])
            {
                AutoFormatType = 1;
            }
            column(InVendBalanceDueLCY_9; InVendBalanceDueLCY[9])
            {
                AutoFormatType = 1;
            }
            column(InVendBalanceDueLCY_10; InVendBalanceDueLCY[10])
            {
                AutoFormatType = 1;
            }
            column(InVendBalanceDueLCY_11; InVendBalanceDueLCY[11])
            {
                AutoFormatType = 1;
            }
            column(InVendBalanceDueLCY_12; InVendBalanceDueLCY[12])
            {
                AutoFormatType = 1;
            }
            column(InVendBalanceDueLCY_13; InVendBalanceDueLCY[13])
            {
                AutoFormatType = 1;
            }
            column(InVendBalanceDueLCY_14; InVendBalanceDueLCY[14])
            {
                AutoFormatType = 1;
            }
            column(Vendor___Summary_AgingCaption; Vendor___Summary_AgingCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(All_amounts_are_in_LCYCaption; All_amounts_are_in_LCYCaptionLbl)
            {
            }
            column(Balance_DueCaption; Balance_DueCaptionLbl)
            {
            }
            column(Vendor__No___Control29Caption; FieldCaption("No."))
            {
            }
            column(Vendor_Name_Control30Caption; FieldCaption(Name))
            {
            }
            column(VendBalanceDue_1__Control31Caption; VendBalanceDue_1__Control31CaptionLbl)
            {
            }
            column(VendBalanceDue_14__Control35Caption; VendBalanceDue_14__Control35CaptionLbl)
            {
            }
            column(LineTotalVendAmountDue_Control36Caption; LineTotalVendAmountDue_Control36CaptionLbl)
            {
            }
            column(Total__LCY_Caption; Total__LCY_CaptionLbl)
            {
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                column(Currency2_Code; Currency2.Code)
                {
                }
                column(LineTotalVendAmountDue_Control36; LineTotalVendAmountDue)
                {
                    AutoFormatExpression = Currency2.Code;
                    AutoFormatType = 1;
                }
                column(VendBalanceDue_14__Control35; VendBalanceDue[14])
                {
                    AutoFormatExpression = Currency2.Code;
                    AutoFormatType = 1;
                }
                column(VendBalanceDue_13__Control35; VendBalanceDue[13])
                {
                    AutoFormatExpression = Currency2.Code;
                    AutoFormatType = 1;
                }
                column(VendBalanceDue_12__Control35; VendBalanceDue[12])
                {
                    AutoFormatExpression = Currency2.Code;
                    AutoFormatType = 1;
                }
                column(VendBalanceDue_11__Control35; VendBalanceDue[11])
                {
                    AutoFormatExpression = Currency2.Code;
                    AutoFormatType = 1;
                }
                column(VendBalanceDue_10__Control35; VendBalanceDue[10])
                {
                    AutoFormatExpression = Currency2.Code;
                    AutoFormatType = 1;
                }
                column(VendBalanceDue_9__Control35; VendBalanceDue[9])
                {
                    AutoFormatExpression = Currency2.Code;
                    AutoFormatType = 1;
                }
                column(VendBalanceDue_8__Control35; VendBalanceDue[8])
                {
                    AutoFormatExpression = Currency2.Code;
                    AutoFormatType = 1;
                }
                column(VendBalanceDue_7__Control35; VendBalanceDue[7])
                {
                    AutoFormatExpression = Currency2.Code;
                    AutoFormatType = 1;
                }
                column(VendBalanceDue_6__Control35; VendBalanceDue[6])
                {
                    AutoFormatExpression = Currency2.Code;
                    AutoFormatType = 1;
                }
                column(VendBalanceDue_5__Control35; VendBalanceDue[5])
                {
                    AutoFormatExpression = Currency2.Code;
                    AutoFormatType = 1;
                }
                column(VendBalanceDue_4__Control34; VendBalanceDue[4])
                {
                    AutoFormatExpression = Currency2.Code;
                    AutoFormatType = 1;
                }
                column(VendBalanceDue_3__Control33; VendBalanceDue[3])
                {
                    AutoFormatExpression = Currency2.Code;
                    AutoFormatType = 1;
                }
                column(VendBalanceDue_2__Control32; VendBalanceDue[2])
                {
                    AutoFormatExpression = Currency2.Code;
                    AutoFormatType = 1;
                }
                column(VendBalanceDue_1__Control31; VendBalanceDue[1])
                {
                    AutoFormatExpression = Currency2.Code;
                    AutoFormatType = 1;
                }
                column(Vendor_Name_Control30; Vendor.Name)
                {
                }
                column(Vendor__No___Control29; Vendor."No.")
                {
                }

                trigger OnAfterGetRecord()
                var
                    DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
                begin
                    if Number = 1 then
                        Currency2.Find('-')
                    else
                        if Currency2.Next = 0 then
                            CurrReport.Break;
                    Currency2.CalcFields("Vendor Ledg. Entries in Filter");
                    if not Currency2."Vendor Ledg. Entries in Filter" then
                        CurrReport.Skip;

                    PrintLine := false;
                    LineTotalVendAmountDue := 0;
                    for i := 1 to 14 do begin
                        DtldVendLedgEntry.SetCurrentKey("Vendor No.", "Initial Entry Due Date");
                        DtldVendLedgEntry.SetRange("Vendor No.", Vendor."No.");
                        DtldVendLedgEntry.SetRange("Initial Entry Due Date", PeriodStartDate[i], PeriodStartDate[i + 1] - 1);
                        DtldVendLedgEntry.SetRange("Currency Code", Currency2.Code);
                        DtldVendLedgEntry.CalcSums(Amount);
                        VendBalanceDue[i] := DtldVendLedgEntry.Amount;
                        InVendBalanceDueLCY[i] := InVendBalanceDueLCY2[i];
                        if VendBalanceDue[i] <> 0 then
                            PrintLine := true;
                        LineTotalVendAmountDue := LineTotalVendAmountDue + VendBalanceDue[i];
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    if PrintAmountsInLCY or not PrintLine then
                        CurrReport.Break;
                    Currency2.Reset;
                    Currency2.SetRange("Vendor Filter", Vendor."No.");
                    Vendor.CopyFilter("Currency Filter", Currency2.Code);
                    if (Vendor.GetFilter("Global Dimension 1 Filter") <> '') or
                       (Vendor.GetFilter("Global Dimension 2 Filter") <> '')
                    then begin
                        Vendor.CopyFilter("Global Dimension 1 Filter", Currency2."Global Dimension 1 Filter");
                        Vendor.CopyFilter("Global Dimension 2 Filter", Currency2."Global Dimension 2 Filter");
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            var
                DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
            begin
                Clear(VendBalanceDueLCY);
                TotalVendAmtDueLCY := 0;

                PrintLine := false;
                LineTotalVendAmountDue := 0;
                CopyFilter("Currency Filter", DtldVendLedgEntry."Currency Code");
                for i := 1 to 14 do begin
                    DtldVendLedgEntry.SetCurrentKey("Vendor No.", "Initial Entry Due Date");
                    DtldVendLedgEntry.SetRange("Vendor No.", "No.");
                    DtldVendLedgEntry.SetRange("Initial Entry Due Date", PeriodStartDate[i], PeriodStartDate[i + 1] - 1);
                    DtldVendLedgEntry.CalcSums("Amount (LCY)");
                    VendBalanceDue[i] := DtldVendLedgEntry."Amount (LCY)";
                    VendBalanceDueLCY[i] := DtldVendLedgEntry."Amount (LCY)";
                    if PrintAmountsInLCY then
                        InVendBalanceDueLCY[i] += DtldVendLedgEntry."Amount (LCY)"
                    else
                        InVendBalanceDueLCY2[i] += DtldVendLedgEntry."Amount (LCY)";
                    if VendBalanceDue[i] <> 0 then
                        PrintLine := true;
                    LineTotalVendAmountDue := LineTotalVendAmountDue + VendBalanceDueLCY[i];
                    TotalVendAmtDueLCY := TotalVendAmtDueLCY + VendBalanceDueLCY[i];
                end;
            end;

            trigger OnPreDataItem()
            begin
                Currency2.Code := '';
                Currency2.Insert;
                if Currency.Find('-') then
                    repeat
                        Currency2 := Currency;
                        Currency2.Insert;
                    until Currency.Next = 0;
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
                    field("PeriodStartDate[2]"; PeriodStartDate[2])
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Starting Date';
                        NotBlank = true;
                        ToolTip = 'Specifies the beginning of the period covered by the report that lists payables owed to each vendor.';
                    }
                    field(PeriodLength; PeriodLength)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Period Length';
                        ToolTip = 'Specifies the length of each of the three periods. For example, enter "1M" for one month.';
                    }
                    field(PrintAmountsInLCY; PrintAmountsInLCY)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Amounts in LCY';
                        ToolTip = 'Specifies if amounts in the report are displayed in LCY. If you leave the check box blank, amounts are shown in foreign currencies.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if PeriodStartDate[2] = 0D then
                PeriodStartDate[2] := WorkDate;
            if Format(PeriodLength) = '' then
                Evaluate(PeriodLength, '<1M>');
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        CaptionManagement: Codeunit CaptionManagement;
    begin
        VendFilter := CaptionManagement.GetRecordFiltersWithCaptions(Vendor);
        for i := 3 to 14 do
            PeriodStartDate[i] := CalcDate(PeriodLength, PeriodStartDate[i - 1]);
        PeriodStartDate[15] := DMY2Date(31, 12, 9999);
    end;

    var
        Currency: Record Currency;
        Currency2: Record Currency temporary;
        PrintAmountsInLCY: Boolean;
        VendFilter: Text;
        PeriodStartDate: array[15] of Date;
        LineTotalVendAmountDue: Decimal;
        TotalVendAmtDueLCY: Decimal;
        VendBalanceDue: array[14] of Decimal;
        VendBalanceDueLCY: array[14] of Decimal;
        PeriodLength: DateFormula;
        PrintLine: Boolean;
        i: Integer;
        InVendBalanceDueLCY: array[14] of Decimal;
        InVendBalanceDueLCY2: array[14] of Decimal;
        Vendor___Summary_AgingCaptionLbl: Label 'Vendor - Summary Aging';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        All_amounts_are_in_LCYCaptionLbl: Label 'All amounts are in LCY.';
        Balance_DueCaptionLbl: Label 'Balance Due';
        VendBalanceDue_1__Control31CaptionLbl: Label '...Before';
        VendBalanceDue_14__Control35CaptionLbl: Label 'After...';
        LineTotalVendAmountDue_Control36CaptionLbl: Label 'Balance';
        Total__LCY_CaptionLbl: Label 'Total (LCY)';

    procedure InitializeRequest(NewPeriodStartDate: Date; NewPeriodLength: Text[10]; NewPrintAmountsInLCY: Boolean)
    begin
        PeriodStartDate[2] := NewPeriodStartDate;
        Evaluate(PeriodLength, NewPeriodLength);
        PrintAmountsInLCY := NewPrintAmountsInLCY;
    end;
}

