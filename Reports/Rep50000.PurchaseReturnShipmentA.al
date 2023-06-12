report 50000 "Purchase - Return Shipment - A"
{
    // version NAVW113.00
    //Copy from R6636

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports/Rep50000.PurchaseReturnShipmentA.rdl';
    Caption = 'Purchase - Return Shipment';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Return Shipment Header"; "Return Shipment Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Buy-from Vendor No.", "No. Printed";
            RequestFilterHeading = 'Posted Return Shipment';
            column(No_ReturnShipmentHeader; "No.")
            {
            }
            //>>ALGO
            column(Ship_to_Address_Cap; FieldCaption("Ship-to Address"))
            {
            }
            column(Buy_from_Address_Cap; FieldCaption("Buy-from Address"))
            {
            }
            column(VendorShipmentNoCap; FieldCaption("Vendor Shipment No."))
            {
            }
            column(Pay_to_Country_Region_Code; "Pay-to Country/Region Code")
            {
            }
            //<<ALGO
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(PurchReturnShpCaption; StrSubstNo(Text002, CopyText))
                    {
                    }
                    column(CompanyAddr1; CompanyAddr[1])
                    {
                    }
                    column(CompanyAddr2; CompanyAddr[2])
                    {
                    }
                    column(CompanyAddr3; CompanyAddr[3])
                    {
                    }
                    column(CompanyAddr4; CompanyAddr[4])
                    {
                    }
                    column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
                    {
                    }
                    column(CompanyInfoHomePage; CompanyInfo."Home Page")
                    {
                    }
                    column(CompanyInfoEMail; CompanyInfo."E-Mail")
                    {
                    }
                    column(CompanyInfoVATRegNo; CompanyInfo."VAT Registration No.")
                    {
                    }
                    column(CompanyInfoGiroNo; CompanyInfo."Giro No.")
                    {
                    }
                    column(CompanyInfoBankName; CompanyInfo."Bank Name")
                    {
                    }
                    column(CompanyInfoBankAccountNo; CompanyInfo."Bank Account No.")
                    {
                    }
                    //>>ALGO
                    column(CompanyInfoFaxNo; CompanyInfo."Fax No.")
                    {
                    }
                    column(CompanyInfoStockCapital; CompanyInfo."Stock Capital")
                    {
                    }
                    column(CompanyInfoRegistrationNo; CompanyInfo."Registration No.")
                    {
                    }
                    column(CompanyInfoAPECode; CompanyInfo."APE Code")
                    {
                    }
                    column(CompanyInfoIBAN; CompanyInfo.IBAN)
                    {
                    }
                    column(CompanyInfoSWIFTCode; CompanyInfo."SWIFT Code")
                    {
                    }
                    column(TxtFooter01; STRSUBSTNO(TxtGFooter01, CompanyInfo."Stock Capital", CompanyInfo."Registration No.", CompanyInfo."APE Code", CompanyInfo."VAT Registration No.", CompanyInfo."Trade Register"))
                    {
                    }
                    column(TxtFooter02; STRSUBSTNO(TxtGFooter02, CompanyInfo."Bank Name" + ' ' + CompanyInfo."Bank Account No." + '/' + RecGBankInfo.Address, CompanyInfo.IBAN, CompanyInfo."SWIFT Code"))
                    {
                    }
                    column(TxtGFax; TxtGFax)
                    {
                    }
                    column(TxtGTotRef; TxtGTotRef)
                    {
                    }
                    //<<ALGO
                    column(DocDate_ReturnShpHeader; Format("Return Shipment Header"."Document Date", 0, 4))
                    {
                    }
                    column(PurchaserText; PurchaserText)
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                    }
                    column(ReferenceText; ReferenceText)
                    {
                    }
                    column(YourReference_ReturnShpHdr; "Return Shipment Header"."Your Reference")
                    {
                    }
                    column(CompanyAddr5; CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr6; CompanyAddr[6])
                    {
                    }
                    column(BuyfromVendNo_ReturnShpHdr; "Return Shipment Header"."Buy-from Vendor No.")
                    {
                    }
                    column(BuyfromVendNo_ReturnShpHdrCaption; "Return Shipment Header".FieldCaption("Buy-from Vendor No."))
                    {
                    }
                    column(ShptBuyFromAddr1; ShptBuyFromAddr[1])
                    {
                    }
                    column(ShptBuyFromAddr2; ShptBuyFromAddr[2])
                    {
                    }
                    column(ShptBuyFromAddr3; ShptBuyFromAddr[3])
                    {
                    }
                    column(ShptBuyFromAddr4; ShptBuyFromAddr[4])
                    {
                    }
                    column(ShptBuyFromAddr5; ShptBuyFromAddr[5])
                    {
                    }
                    column(ShptBuyFromAddr6; ShptBuyFromAddr[6])
                    {
                    }
                    column(ShptBuyFromAddr7; ShptBuyFromAddr[7])
                    {
                    }
                    column(ShptBuyFromAddr8; ShptBuyFromAddr[8])
                    {
                    }
                    //>>ALGO
                    column(ShptShipToAddr1; ShptShipToAddr[1])
                    {
                    }
                    column(ShptShipToAddr2; ShptShipToAddr[2])
                    {
                    }
                    column(ShptShipToAddr3; ShptShipToAddr[3])
                    {
                    }
                    column(ShptShipToAddr4; ShptShipToAddr[4])
                    {
                    }
                    column(ShptShipToAddr5; ShptShipToAddr[5])
                    {
                    }
                    column(ShptShipToAddr6; ShptShipToAddr[6])
                    {
                    }
                    column(ShptShipToAddr7; ShptShipToAddr[7])
                    {
                    }
                    column(ShptShipToAddr8; ShptShipToAddr[8])
                    {
                    }
                    column(PayToVendorNo; PayToVendorNo)
                    {
                    }
                    column(BuyFromVendorNo; BuyFromVendorNo)
                    {
                    }
                    column(PayToVendorNo_Total2; PayToCaption)
                    {
                    }
                    column(ShptShipToAddrCaption; ShptShipToAddrCaptionLbl)
                    {
                    }
                    //<<ALGO
                    column(PageCaption; StrSubstNo(Text003, ''))
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(CompanyInfoPhoneNoCaption; CompanyInfoPhoneNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoVATRegNoCaption; CompanyInfoVATRegNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoGiroNoCaption; CompanyInfoGiroNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoBankNameCaption; CompanyInfoBankNameCaptionLbl)
                    {
                    }
                    column(CompanyInfoBankAccountNoCaption; CompanyInfoBankAccountNoCaptionLbl)
                    {
                    }
                    column(ReturnShipmentHeaderNoCaption; ReturnShipmentHeaderNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoHomePageCaption; CompanyInfoHomePageCaptionLbl)
                    {
                    }
                    column(CompanyEmailCaption; CompanyEmailCaptionLbl)
                    {
                    }
                    column(DocumentDataCaption; DocumentDataCaptionLbl)
                    {
                    }
                    //>>ALGO
                    column(VendorVATRegistrationNo; "Return Shipment Header"."VAT Registration No.")
                    {
                    }
                    column(VendorShipmentNo; "Return Shipment Header"."Vendor Shipment No.")
                    {
                    }
                    //<<ALGO
                    dataitem(DimensionLoop1; "Integer")
                    {
                        DataItemLinkReference = "Return Shipment Header";
                        DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                        column(DimText; DimText)
                        {
                        }
                        column(Number_Integer; Number)
                        {
                        }
                        column(HeaderDimensionsCaption; HeaderDimensionsCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then begin
                                if not DimSetEntry1.FindSet() then
                                    CurrReport.Break();
                            end else
                                if not Continue then
                                    CurrReport.Break();

                            Clear(DimText);
                            Continue := false;
                            repeat
                                OldDimText := DimText;
                                if DimText = '' then
                                    DimText := StrSubstNo('%1 - %2', DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
                                else
                                    DimText :=
                                      StrSubstNo(
                                        '%1; %2 - %3', DimText,
                                        DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code");
                                if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                    DimText := OldDimText;
                                    Continue := true;
                                    exit;
                                end;
                            until DimSetEntry1.Next() = 0;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if not ShowInternalInfo then
                                CurrReport.Break();
                        end;
                    }
                    dataitem("Return Shipment Line"; "Return Shipment Line")
                    {
                        DataItemLink = "Document No." = FIELD("No.");
                        DataItemLinkReference = "Return Shipment Header";
                        DataItemTableView = SORTING("Document No.", "Line No.");
                        column(TypeInt; TypeInt)
                        {
                        }
                        column(ShowInternalInfo; ShowInternalInfo)
                        {
                        }
                        column(Description_ReturnShpLine; Description)
                        {
                        }
                        column(UOM_ReturnShpLine; "Unit of Measure Code")
                        {
                        }
                        column(Qty_ReturnShipmentLine; Quantity)
                        {
                        }
                        column(No_ReturnShipmentLine; "No.")
                        {
                        }
                        column(LineNo_ReturnShipmentLine; "Line No.")
                        {
                        }
                        //>>ALGO
                        column(P_O_; "P.O.")
                        {
                        }
                        column(Vdoc_Control_No_; "Vdoc Control No.")
                        {
                        }
                        column(Description_2; "Description 2")
                        {
                        }
                        column(Vendor_Shipment_No_; "Vendor Shipment No.")
                        {
                        }
                        column(Vendor_Shipment_No_Caption; FieldCaption("Vendor Shipment No."))
                        {
                        }
                        column(Direct_Unit_Cost; "Direct Unit Cost")
                        {
                        }
                        column(VAT__; "VAT %")
                        {
                        }
                        column(Direct_Unit_CostCaption; FieldCaption("Direct Unit Cost"))
                        {
                        }
                        column(TxtAmount; TxtAmount)
                        {
                        }
                        column(TxtSealedNo; TxtSealedNo)
                        {
                        }
                        column(TxtTotalAmout; TxtTotalAmoutCaption)
                        {
                        }
                        column(TxtVendorShipmentNo; TxtVendorShipmentNo)
                        {
                        }
                        column(TVACaption; StrSubstNo(TxtVAT, "VAT %"))
                        {
                        }
                        column(TxtTotalAmoutincVAT; TxtTotalAmoutincVATCaption)
                        {
                        }
                        //<<ALGO
                        column(UOM_ReturnShpLineCaption; FieldCaption("Unit of Measure"))
                        {
                        }
                        column(Qty_ReturnShipmentLineCaption; FieldCaption(Quantity))
                        {
                        }
                        column(Description_ReturnShpLineCaption; FieldCaption(Description))
                        {
                        }
                        column(No_ReturnShipmentLineCaption; FieldCaption("No."))
                        {
                        }
                        dataitem(DimensionLoop2; "Integer")
                        {
                            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));
                            column(DimText_DimensionLoop2; DimText)
                            {
                            }
                            column(Number_DimensionLoop2; Number)
                            {
                            }
                            column(LineDimensionsCaption; LineDimensionsCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then begin
                                    if not DimSetEntry2.FindSet() then
                                        CurrReport.Break();
                                end else
                                    if not Continue then
                                        CurrReport.Break();

                                Clear(DimText);
                                Continue := false;
                                repeat
                                    OldDimText := DimText;
                                    if DimText = '' then
                                        DimText := StrSubstNo('%1 - %2', DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                    else
                                        DimText :=
                                          StrSubstNo(
                                            '%1; %2 - %3', DimText,
                                            DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code");
                                    if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                        DimText := OldDimText;
                                        Continue := true;
                                        exit;
                                    end;
                                until DimSetEntry2.Next() = 0;
                            end;

                            trigger OnPreDataItem()
                            begin
                                if not ShowInternalInfo then
                                    CurrReport.Break();
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if (not ShowCorrectionLines) and Correction then
                                CurrReport.Skip();

                            DimSetEntry2.SetRange("Dimension Set ID", "Dimension Set ID");
                            TypeInt := Type;
                        end;

                        trigger OnPreDataItem()
                        begin
                            MoreLines := Find('+');
                            while MoreLines and (Description = '') and ("No." = '') and (Quantity = 0) do
                                MoreLines := Next(-1) <> 0;
                            if not MoreLines then
                                CurrReport.Break();
                            SetRange("Line No.", 0, "Line No.");
                        end;
                    }
                    dataitem(Total; "Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

                        trigger OnAfterGetRecord()
                        begin
                            PayToVendorNo := "Return Shipment Header"."Pay-to Vendor No.";
                            BuyFromVendorNo := "Return Shipment Header"."Buy-from Vendor No.";
                            PayToCaption := "Return Shipment Header".FieldCaption("Pay-to Vendor No.");
                        end;

                        trigger OnPreDataItem()
                        begin
                            if "Return Shipment Header"."Buy-from Vendor No." = "Return Shipment Header"."Pay-to Vendor No." then
                                CurrReport.Break();
                        end;
                    }
                    dataitem(Total2; "Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                        //>>ALGO
                        /*
                        column(ShptShipToAddr1; ShptShipToAddr[1])
                        {
                        }
                        column(ShptShipToAddr2; ShptShipToAddr[2])
                        {
                        }
                        column(ShptShipToAddr3; ShptShipToAddr[3])
                        {
                        }
                        column(ShptShipToAddr4; ShptShipToAddr[4])
                        {
                        }
                        column(ShptShipToAddr5; ShptShipToAddr[5])
                        {
                        }
                        column(ShptShipToAddr6; ShptShipToAddr[6])
                        {
                        }
                        column(ShptShipToAddr7; ShptShipToAddr[7])
                        {
                        }
                        column(ShptShipToAddr8; ShptShipToAddr[8])
                        {
                        }
                        column(PayToVendorNo; PayToVendorNo)
                        {
                        }
                        column(BuyFromVendorNo; BuyFromVendorNo)
                        {
                        }
                        column(PayToVendorNo_Total2; PayToCaption)
                        {
                        }
                        column(ShptShipToAddrCaption; ShptShipToAddrCaptionLbl)
                        {
                        }
                        */
                        //<<ALGO
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then begin
                        CopyText := FormatDocument.GetCOPYText();
                        OutputNo += 1;
                    end;
                    CurrReport.PageNo := 1;
                end;

                trigger OnPostDataItem()
                begin
                    if not IsReportInPreviewMode() then
                        CODEUNIT.Run(CODEUNIT::"Return Shipment - Printed", "Return Shipment Header");
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := Abs(NoOfCopies) + 1;
                    CopyText := '';
                    SetRange(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            var
                Language: Record Language;
            begin
                CurrReport.Language := Language.GetLanguageID("Language Code");

                FormatAddressFields("Return Shipment Header");
                FormatDocumentFields("Return Shipment Header");

                DimSetEntry1.SetRange("Dimension Set ID", "Dimension Set ID");
                //>>ALGO
                if "Currency Code" = '' then begin
                    GLSetup.get();
                    TxtTotalAmoutCaption := StrSubstNo(TxtTotalAmout, GLSetup."LCY Code");
                    TxtTotalAmoutincVATCaption := StrSubstNo(TxtTotalAmoutincVAT, GLSetup."LCY Code");
                end
                else begin
                    TxtTotalAmoutCaption := StrSubstNo(TxtTotalAmout, "Currency Code");
                    TxtTotalAmoutincVATCaption := StrSubstNo(TxtTotalAmoutincVAT, "Currency Code");
                end;

                //<<ALGO
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
                    field(NoOfCopies; NoOfCopies)
                    {
                        ApplicationArea = PurchReturnOrder;
                        Caption = 'No. of Copies';
                        ToolTip = 'Specifies how many copies of the document to print.';
                    }
                    field(ShowInternalInfo; ShowInternalInfo)
                    {
                        ApplicationArea = PurchReturnOrder;
                        Visible = false;
                        Caption = 'Show Internal Information';
                        ToolTip = 'Specifies if you want the printed report to show information that is only for internal use.';
                    }
                    field(ShowCorrectionLines; ShowCorrectionLines)
                    {
                        ApplicationArea = PurchReturnOrder;
                        Caption = 'Show Correction Lines';
                        ToolTip = 'Specifies if the correction lines of an undoing of quantity posting will be shown on the report.';
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = PurchReturnOrder;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Specifies if you want the program to log this interaction.';
                    }
                }
            }
        }

        trigger OnInit()
        begin
            LogInteractionEnable := true;
        end;

        trigger OnOpenPage()
        begin
            InitLogInteraction();
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        CompanyInfo.Get();
        //>>ALGO
        if not RecGBankInfo.GET(CompanyInfo."Bank Account No.") then
            RecGBankInfo.Init();
        //<<ALGO
    end;

    trigger OnPostReport()
    begin
        if LogInteraction and not IsReportInPreviewMode() then
            if "Return Shipment Header".FindSet() then
                repeat
                    SegManagement.LogDocument(21, "Return Shipment Header"."No.", 0, 0, DATABASE::Vendor,
                      "Return Shipment Header"."Buy-from Vendor No.", "Return Shipment Header"."Purchaser Code", '',
                      "Return Shipment Header"."Posting Description", '');
                until "Return Shipment Header".Next() = 0;
    end;

    trigger OnPreReport()
    begin
        if not CurrReport.UseRequestPage() then
            InitLogInteraction();
    end;

    var
        CompanyInfo: Record "Company Information";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        RespCenter: Record "Responsibility Center";
        //>>ALGO
        RecGBankInfo: Record "Bank Account";
        GLSetup: Record "General Ledger Setup";
        //<<ALGO
        FormatAddr: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        SegManagement: Codeunit SegManagement;
        ShptShipToAddr: array[8] of Text[50];
        ShptBuyFromAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        PurchaserText: Text[30];
        ReferenceText: Text[80];
        CopyText: Text[30];
        DimText: Text[120];
        OldDimText: Text[75];
        //>>ALGO
        TxtTotalAmoutCaption: Text[100];
        TxtTotalAmoutincVATCaption: Text[100];
        //<<ALGO
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        MoreLines: Boolean;
        ShowCorrectionLines: Boolean;
        LogInteraction: Boolean;
        OutputNo: Integer;
        TypeInt: Integer;
        PayToVendorNo: Code[20];
        BuyFromVendorNo: Code[20];
        PayToCaption: Text[30];
        [InDataSet]
        LogInteractionEnable: Boolean;
        Text002: Label 'Purchase - Credit memo %1', Comment = '%1 = Document No.';
        Text003: Label 'Page %1';
        CompanyInfoPhoneNoCaptionLbl: Label 'Phone No.';
        CompanyInfoVATRegNoCaptionLbl: Label 'VAT Reg. No.';
        CompanyInfoGiroNoCaptionLbl: Label 'Giro No.';
        CompanyInfoBankNameCaptionLbl: Label 'Bank';
        CompanyInfoBankAccountNoCaptionLbl: Label 'Account No.';
        ReturnShipmentHeaderNoCaptionLbl: Label 'Shipment No.';
        CompanyInfoHomePageCaptionLbl: Label 'Home Page';
        CompanyEmailCaptionLbl: Label 'Email';
        DocumentDataCaptionLbl: Label 'Document Date';
        HeaderDimensionsCaptionLbl: Label 'Header Dimensions';
        LineDimensionsCaptionLbl: Label 'Line Dimensions';
        ShptShipToAddrCaptionLbl: Label 'Ship-to Address';
        //>>ALGO
        TxtGFax: Label '-Fax :';
        TxtGTotRef: Label 'Reference Total :';
        TxtGFooter01: Label 'LLC with the Capital of %1 - Siret No. : %2 - APE Code : %3 - VAT Intracom. No. : %4 - TR : %5';
        TxtGFooter02: Label 'Bank : %1 - Iban number : %2 - Swift code : %3';
        TxtAmount: Label 'Amount';
        TxtTotalAmout: Label 'Total Amount %1 exc. VAT';
        TxtTotalAmoutincVAT: Label 'Total Amount %1 inc. VAT';
        TxtSealedNo: Label 'Sealed No.';
        TxtVendorShipmentNo: Label 'Vendor Shipment No. / Control No.';
        TxtVAT: Label 'VAT %1%';
    //<<ALGO

    procedure InitializeRequest(NewNoOfCopies: Decimal; NewShowInternalInfo: Boolean; NewShowCorrectionLines: Boolean; NewLogInteraction: Boolean)
    begin
        NoOfCopies := NewNoOfCopies;
        // Modification OL : alway show Internal Info
        //ShowInternalInfo := NewShowInternalInfo;
        ShowInternalInfo := true;
        ShowCorrectionLines := NewShowCorrectionLines;
        LogInteraction := NewLogInteraction;
    end;

    local procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractTmplCode(21) <> '';
    end;

    local procedure IsReportInPreviewMode(): Boolean
    var
        MailManagement: Codeunit "Mail Management";
    begin
        exit(CurrReport.Preview() or MailManagement.IsHandlingGetEmailBody());
    end;

    local procedure FormatAddressFields(var ReturnShipmentHeader: Record "Return Shipment Header")
    begin
        FormatAddr.GetCompanyAddr(ReturnShipmentHeader."Responsibility Center", RespCenter, CompanyInfo, CompanyAddr);
        FormatAddr.PurchShptBuyFrom(ShptBuyFromAddr, ReturnShipmentHeader);
        FormatAddr.PurchShptShipTo(ShptShipToAddr, ReturnShipmentHeader);
    end;

    local procedure FormatDocumentFields(ReturnShipmentHeader: Record "Return Shipment Header")
    begin
        FormatDocument.SetPurchaser(SalesPurchPerson, ReturnShipmentHeader."Purchaser Code", PurchaserText);

        ReferenceText := FormatDocument.SetText(ReturnShipmentHeader."Your Reference" <> '', ReturnShipmentHeader.FieldCaption("Your Reference"));
    end;
}

