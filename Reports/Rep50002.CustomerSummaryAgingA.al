report 50002 "Customer - Summary Aging - A"
{
    // version NAVW113.00
    // copy from R105

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports/Rep50002.CustomerSummaryAgingA.rdl';
    ApplicationArea = Basic, Suite;
    Caption = 'Customer - Summary Aging';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Search Name", "Customer Posting Group", "Currency Filter";
            column(COMPANYNAME; COMPANYPROPERTY.DisplayName())
            {
            }
            column(PrintAmountsInLCY; PrintAmountsInLCY)
            {
            }
            column(CustFilter; CustFilter)
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
            column(PeriodStartDate_3_1; Format(PeriodStartDate[3] - 1))
            {
            }
            column(PeriodStartDate_4_1; Format(PeriodStartDate[4] - 1))
            {
            }
            column(PeriodStartDate_5_1; Format(PeriodStartDate[5] - 1))
            {
            }
            column(PeriodStartDate_6_1; Format(PeriodStartDate[6] - 1))
            {
            }
            column(PeriodStartDate_7_1; Format(PeriodStartDate[7] - 1))
            {
            }
            column(PeriodStartDate_8_1; Format(PeriodStartDate[8] - 1))
            {
            }
            column(PeriodStartDate_9_1; Format(PeriodStartDate[9] - 1))
            {
            }
            column(PeriodStartDate_10_1; Format(PeriodStartDate[10] - 1))
            {
            }
            column(PeriodStartDate_11_1; Format(PeriodStartDate[11] - 1))
            {
            }
            column(PeriodStartDate_12_1; Format(PeriodStartDate[12] - 1))
            {
            }
            column(PeriodStartDate_13_1; Format(PeriodStartDate[13] - 1))
            {
            }
            column(PeriodStartDate_14_1; Format(PeriodStartDate[14] - 1))
            {
            }
            column(CustBalanceDueLCY_1_; CustBalanceDueLCY[1])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_2_; CustBalanceDueLCY[2])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_3_; CustBalanceDueLCY[3])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_4_; CustBalanceDueLCY[4])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_5_; CustBalanceDueLCY[5])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_6_; CustBalanceDueLCY[6])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_7_; CustBalanceDueLCY[7])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_8_; CustBalanceDueLCY[8])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_9_; CustBalanceDueLCY[9])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_10_; CustBalanceDueLCY[10])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_11_; CustBalanceDueLCY[11])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_12_; CustBalanceDueLCY[12])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_13_; CustBalanceDueLCY[13])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDueLCY_14_; CustBalanceDueLCY[14])
            {
                AutoFormatType = 1;
            }
            column(TotalCustBalanceLCY; TotalCustBalanceLCY)
            {
                AutoFormatType = 1;
            }
            column(LineTotalCustBalance; LineTotalCustBalance)
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDue_14_; CustBalanceDue[14])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDue_13_; CustBalanceDue[13])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDue_12_; CustBalanceDue[12])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDue_11_; CustBalanceDue[11])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDue_10_; CustBalanceDue[10])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDue_9_; CustBalanceDue[9])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDue_8_; CustBalanceDue[8])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDue_7_; CustBalanceDue[7])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDue_6_; CustBalanceDue[6])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDue_5_; CustBalanceDue[5])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDue_4_; CustBalanceDue[4])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDue_3_; CustBalanceDue[3])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDue_2_; CustBalanceDue[2])
            {
                AutoFormatType = 1;
            }
            column(CustBalanceDue_1_; CustBalanceDue[1])
            {
                AutoFormatType = 1;
            }
            column(Customer_Name; Name)
            {
            }
            column(Customer_No_; "No.")
            {
            }
            column(InCustBalanceDueLCY_1; InCustBalanceDueLCY[1])
            {
                AutoFormatType = 1;
            }
            column(InCustBalanceDueLCY_2; InCustBalanceDueLCY[2])
            {
                AutoFormatType = 1;
            }
            column(InCustBalanceDueLCY_3; InCustBalanceDueLCY[3])
            {
                AutoFormatType = 1;
            }
            column(InCustBalanceDueLCY_4; InCustBalanceDueLCY[4])
            {
                AutoFormatType = 1;
            }
            column(InCustBalanceDueLCY_5; InCustBalanceDueLCY[5])
            {
                AutoFormatType = 1;
            }
            column(InCustBalanceDueLCY_6; InCustBalanceDueLCY[6])
            {
                AutoFormatType = 1;
            }
            column(InCustBalanceDueLCY_7; InCustBalanceDueLCY[7])
            {
                AutoFormatType = 1;
            }
            column(InCustBalanceDueLCY_8; InCustBalanceDueLCY[8])
            {
                AutoFormatType = 1;
            }
            column(InCustBalanceDueLCY_9; InCustBalanceDueLCY[9])
            {
                AutoFormatType = 1;
            }
            column(InCustBalanceDueLCY_10; InCustBalanceDueLCY[10])
            {
                AutoFormatType = 1;
            }
            column(InCustBalanceDueLCY_11; InCustBalanceDueLCY[11])
            {
                AutoFormatType = 1;
            }
            column(InCustBalanceDueLCY_12; InCustBalanceDueLCY[12])
            {
                AutoFormatType = 1;
            }
            column(InCustBalanceDueLCY_13; InCustBalanceDueLCY[13])
            {
                AutoFormatType = 1;
            }
            column(InCustBalanceDueLCY_14; InCustBalanceDueLCY[14])
            {
                AutoFormatType = 1;
            }
            column(Customer_Summary_AgingCaption; Customer_Summary_AgingCaptionLbl)
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
            column(Customer_No_Caption; FieldCaption("No."))
            {
            }
            column(Customer_NameCaption; FieldCaption(Name))
            {
            }
            column(CustBalanceDue_1_Caption; CustBalanceDue_1_CaptionLbl)
            {
            }
            column(CustBalanceDue_14_Caption; CustBalanceDue_14_CaptionLbl)
            {
            }
            column(LineTotalCustBalanceCaption; LineTotalCustBalanceCaptionLbl)
            {
            }
            column(Total_LCY_Caption; Total_LCY_CaptionLbl)
            {
            }
            column(PrintLine; PrintLine)
            {
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                column(LineTotalCustBalance_Control67; LineTotalCustBalance)
                {
                    AutoFormatExpression = Currency2.Code;
                    AutoFormatType = 1;
                }
                column(CustBalanceDue_14_Control72; CustBalanceDue[14])
                {
                    AutoFormatExpression = Currency2.Code;
                    AutoFormatType = 1;
                }
                column(CustBalanceDue_13_Control72; CustBalanceDue[13])
                {
                    AutoFormatExpression = Currency2.Code;
                    AutoFormatType = 1;
                }
                column(CustBalanceDue_12_Control72; CustBalanceDue[12])
                {
                    AutoFormatExpression = Currency2.Code;
                    AutoFormatType = 1;
                }
                column(CustBalanceDue_11_Control72; CustBalanceDue[11])
                {
                    AutoFormatExpression = Currency2.Code;
                    AutoFormatType = 1;
                }
                column(CustBalanceDue_10_Control72; CustBalanceDue[10])
                {
                    AutoFormatExpression = Currency2.Code;
                    AutoFormatType = 1;
                }
                column(CustBalanceDue_9_Control72; CustBalanceDue[9])
                {
                    AutoFormatExpression = Currency2.Code;
                    AutoFormatType = 1;
                }
                column(CustBalanceDue_8_Control72; CustBalanceDue[8])
                {
                    AutoFormatExpression = Currency2.Code;
                    AutoFormatType = 1;
                }
                column(CustBalanceDue_7_Control72; CustBalanceDue[7])
                {
                    AutoFormatExpression = Currency2.Code;
                    AutoFormatType = 1;
                }
                column(CustBalanceDue_6_Control72; CustBalanceDue[6])
                {
                    AutoFormatExpression = Currency2.Code;
                    AutoFormatType = 1;
                }
                column(CustBalanceDue_5_Control68; CustBalanceDue[5])
                {
                    AutoFormatExpression = Currency2.Code;
                    AutoFormatType = 1;
                }
                column(CustBalanceDue_4_Control69; CustBalanceDue[4])
                {
                    AutoFormatExpression = Currency2.Code;
                    AutoFormatType = 1;
                }
                column(CustBalanceDue_3_Control70; CustBalanceDue[3])
                {
                    AutoFormatExpression = Currency2.Code;
                    AutoFormatType = 1;
                }
                column(CustBalanceDue_2_Control71; CustBalanceDue[2])
                {
                    AutoFormatExpression = Currency2.Code;
                    AutoFormatType = 1;
                }
                column(CustBalanceDue_1_Control72; CustBalanceDue[1])
                {
                    AutoFormatExpression = Currency2.Code;
                    AutoFormatType = 1;
                }
                column(Currency2_Code; Currency2.Code)
                {
                }
                column(Customer_Name_Control74; Customer.Name)
                {
                }
                column(Customer_No_Control75; Customer."No.")
                {
                }

                trigger OnAfterGetRecord()
                var
                    DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
                begin
                    if Number = 1 then
                        Currency2.Find('-')
                    else
                        if Currency2.Next = 0 then
                            CurrReport.Break;
                    Currency2.CalcFields("Cust. Ledg. Entries in Filter");
                    if not Currency2."Cust. Ledg. Entries in Filter" then
                        CurrReport.Skip;

                    PrintLine := false;
                    LineTotalCustBalance := 0;
                    for i := 1 to 14 do begin
                        DtldCustLedgEntry.SetCurrentKey("Customer No.", "Initial Entry Due Date");
                        DtldCustLedgEntry.SetRange("Customer No.", Customer."No.");
                        DtldCustLedgEntry.SetRange("Initial Entry Due Date", PeriodStartDate[i], PeriodStartDate[i + 1] - 1);
                        DtldCustLedgEntry.SetRange("Currency Code", Currency2.Code);
                        DtldCustLedgEntry.CalcSums(Amount);
                        CustBalanceDue[i] := DtldCustLedgEntry.Amount;
                        InCustBalanceDueLCY[i] := InCustBalanceDueLCY2[i];
                        if CustBalanceDue[i] <> 0 then
                            PrintLine := true;
                        LineTotalCustBalance := LineTotalCustBalance + CustBalanceDue[i];
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    if PrintAmountsInLCY or not PrintLine then
                        CurrReport.Break;
                    Currency2.Reset;
                    Currency2.SetRange("Customer Filter", Customer."No.");
                    Customer.CopyFilter("Currency Filter", Currency2.Code);
                    if (Customer.GetFilter("Global Dimension 1 Filter") <> '') or
                       (Customer.GetFilter("Global Dimension 2 Filter") <> '')
                    then begin
                        Customer.CopyFilter("Global Dimension 1 Filter", Currency2."Global Dimension 1 Filter");
                        Customer.CopyFilter("Global Dimension 2 Filter", Currency2."Global Dimension 2 Filter");
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            var
                DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
            begin
                PrintLine := false;
                LineTotalCustBalance := 0;
                CopyFilter("Currency Filter", DtldCustLedgEntry."Currency Code");
                for i := 1 to 14 do begin
                    DtldCustLedgEntry.SetCurrentKey("Customer No.", "Initial Entry Due Date");
                    DtldCustLedgEntry.SetRange("Customer No.", "No.");
                    DtldCustLedgEntry.SetRange("Initial Entry Due Date", PeriodStartDate[i], PeriodStartDate[i + 1] - 1);
                    DtldCustLedgEntry.CalcSums("Amount (LCY)");
                    CustBalanceDue[i] := DtldCustLedgEntry."Amount (LCY)";
                    CustBalanceDueLCY[i] := DtldCustLedgEntry."Amount (LCY)";
                    if PrintAmountsInLCY then
                        InCustBalanceDueLCY[i] += DtldCustLedgEntry."Amount (LCY)"
                    else
                        InCustBalanceDueLCY2[i] += DtldCustLedgEntry."Amount (LCY)";
                    if CustBalanceDue[i] <> 0 then
                        PrintLine := true;
                    LineTotalCustBalance := LineTotalCustBalance + CustBalanceDueLCY[i];
                    TotalCustBalanceLCY := TotalCustBalanceLCY + CustBalanceDueLCY[i];
                end;

                if not PrintLine then
                    CurrReport.Skip;
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
                    field(StartingDate; PeriodStartDate[2])
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Starting Date';
                        NotBlank = true;
                        ToolTip = 'Specifies the date for the beginning of the period covered by the report.';
                    }
                    field(PeriodLength; PeriodLength)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Period Length';
                        ToolTip = 'Specifies the length of each of the three periods. For example, enter "1M" for one month.';
                    }
                    field(ShowAmountsInLCY; PrintAmountsInLCY)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Amounts in LCY';
                        ToolTip = 'Specifies that you want amounts in the report to be displayed in LCY. Leave this field blank if you want to see amounts in foreign currencies.';
                    }
                }
            }
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
        CustFilter := CaptionManagement.GetRecordFiltersWithCaptions(Customer);
        for i := 3 to 14 do
            PeriodStartDate[i] := CalcDate(PeriodLength, PeriodStartDate[i - 1]);
        PeriodStartDate[15] := DMY2Date(31, 12, 9999);
    end;

    var
        Currency: Record Currency;
        Currency2: Record Currency temporary;
        CustFilter: Text;
        PrintAmountsInLCY: Boolean;
        PeriodLength: DateFormula;
        PeriodStartDate: array[15] of Date;
        CustBalanceDue: array[14] of Decimal;
        CustBalanceDueLCY: array[14] of Decimal;
        LineTotalCustBalance: Decimal;
        TotalCustBalanceLCY: Decimal;
        PrintLine: Boolean;
        i: Integer;
        InCustBalanceDueLCY: array[14] of Decimal;
        InCustBalanceDueLCY2: array[14] of Decimal;
        Customer_Summary_AgingCaptionLbl: Label 'Customer - Summary Aging';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        All_amounts_are_in_LCYCaptionLbl: Label 'All amounts are in LCY';
        Balance_DueCaptionLbl: Label 'Balance Due';
        CustBalanceDue_1_CaptionLbl: Label '...Before';
        CustBalanceDue_14_CaptionLbl: Label 'After...';
        LineTotalCustBalanceCaptionLbl: Label 'Balance';
        Total_LCY_CaptionLbl: Label 'Total (LCY)';

    procedure InitializeRequest(StartingDate: Date; SetPeriodLength: Text[1024]; ShowAmountInLCY: Boolean)
    begin
        PeriodStartDate[2] := StartingDate;
        Evaluate(PeriodLength, SetPeriodLength);
        PrintAmountsInLCY := ShowAmountInLCY;
    end;
}

