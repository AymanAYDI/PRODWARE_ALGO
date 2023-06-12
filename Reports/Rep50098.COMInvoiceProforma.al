report 50098 "COM-Invoice Proforma"
{
    Caption = 'COM-Invoice Proforma';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports/Rep50098.COMInvoiceProforma.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Sales Shipment Header"; "Sales Shipment Header")
        {
            DataItemTableView = sorting("No.");
            column(RecGCompanyInformationName; RecGCompanyInformation.Name)
            {
            }
            column(TxtGCompanyAdress; TxtGCompanyAdress)
            {
            }
            column(TxtGCompanyPhoneFaxEmail; TxtGCompanyPhoneFaxEmail)
            {
            }
            column(TxtHeader; STRSUBSTNO(TxtGHeader, RecGCompanyInformation."EORI No.", RecGCompanyInformation."MID Code", RecGCompanyInformation."AEO Certificate No."))
            {
            }
            column(TxtTitle; TxtTitle)
            {
            }
            column(reference; "No.")
            {
            }
            column(referenceCap; fieldcaption("No."))
            {
            }
            column(Document_Date; "Document Date")
            {
            }
            column(Document_DateCaption; FieldCaption("Document Date"))
            {
            }
            column(Shipment_Method_Code; "Shipment Method Code")
            {
            }
            column(Shipment_Method_CodeCaption; FieldCaption("Shipment Method Code"))
            {
            }
            column(VAT_Registration_No_; RecGCompanyInformation."VAT Registration No.")
            {
            }
            column(VAT_Registration_No_Caption; FieldCaption("VAT Registration No."))
            {
            }
            column(Ship_to_Address_Caption; FieldCaption("Ship-to Address"))
            {
            }
            column(Sell_to_Address_Caption; FieldCaption("Sell-to Address"))
            {
            }
            column(Ship_to_Name; "Ship-to Name")
            {
            }
            column(Ship_to_Address; "Ship-to Address")
            {
            }
            column(Ship_to_Address_2; "Ship-to Address 2")
            {
            }
            column(Ship_to_City; "Ship-to City")
            {
            }
            column(Ship_to_Country_Region_Code; "Ship-to Country/Region Code")
            {
            }
            column(TxtGCustAddr1; TxtGCustAddr[1])
            {
            }
            column(TxtGCustAddr2; TxtGCustAddr[2])
            {
            }
            column(TxtGCustAddr3; TxtGCustAddr[3])
            {
            }
            column(TxtGCustAddr4; TxtGCustAddr[4])
            {
            }
            column(TxtGCustAddr5; TxtGCustAddr[5])
            {
            }
            column(TxtGCustAddr6; TxtGCustAddr[6])
            {
            }
            column(TxtGCompanyInfFr; TxtGCompanyInfFr + TxtGCompanyInfFr3)
            {
            }

            dataitem("Sales Shipment Line"; "Sales Shipment Line")
            {
                DataItemTableView = sorting("Document No.", "Line No.");
                DataItemLinkReference = "Sales Shipment Header";
                DataItemLink = "Document No." = FIELD("No.");
                column(SalesShipmentLine_Quantity; Quantity)
                {
                }
                column(Unit_Price; "Unit Price")
                {
                }
                column(VAT__; "VAT %")
                {
                }
                column(TxtUniPriceExcVAT; TxtUniPriceExcVAT)
                {
                }
                column(TxtAmountExcVAT; TxtAmountExcVAT)
                {
                }
                column(TxtTotalAmountExcVAT; TxtTotalAmountExcVAT)
                {
                }
                column(TxtTotalAmountIncVAT; TxtTotalAmountIncVAT)
                {
                }
                column(TxtVATAmount; TxtVATAmount)
                {
                }
                column(DecGAmount; DecGAmount)
                {
                }
                column(DecGVATAmount; DecGVATAmount)
                {
                }
                column(DecGTotalAmountIncVAT; DecGTotalAmountIncVAT)
                {
                }
                trigger OnAfterGetRecord()
                var
                begin

                    DecGAmount := 0;
                    IF (Type = Type::Item) OR
                      (Type = Type::"Fixed Asset") OR
                      ((Type = Type::"G/L Account")) THEN
                        IF NOT "Sales Shipment Header"."Prices Including VAT" THEN BEGIN
                            DecGAmount := Quantity * "Unit Price";
                            DecGVATAmount := DecGVATAmount + (DecGAmount * "Sales Shipment Line"."VAT %" / 100);
                            DecGTotalAmountIncVAT := DecGTotalAmountIncVAT + DecGAmount + (DecGAmount * "Sales Shipment Line"."VAT %" / 100);
                            DecGTotalAmount := DecGTotalAmount + DecGAmount;
                        END
                        ELSE BEGIN
                            DecGAmount := Quantity * "Unit Price";
                            DecGAmountExVAT := DecGAmount / (1 + ("Sales Shipment Line"."VAT %" / 100));
                            DecGVatAmountLine := DecGAmount - DecGAmountExVAT;

                            DecGVATAmount := DecGVATAmount + DecGVatAmountLine;
                            DecGTotalAmountExVAT := DecGTotalAmountExVAT + (DecGAmount - DecGVatAmountLine);
                            DecGTotalAmount := DecGTotalAmount + DecGAmount;
                        END
                end;

            }
            dataitem("Link Packing/Sales Ship."; "Link Packing/Sales Ship.")
            {
                DataItemLinkReference = "Sales Shipment Header";
                DataItemLink = "Sales Shipment No." = FIELD("No.");
                RequestFilterFields = "Packing header No.";
                dataitem("Posted Packing Header ALGO"; "Posted Packing Header ALGO")
                {
                    DataItemTableView = SORTING("Warehouse Shipment No.") ORDER(Ascending);
                    DataItemLinkReference = "Link Packing/Sales Ship.";
                    DataItemLink = "No." = FIELD("Packing header No.");
                    dataitem("Posted Packing Line ALGO"; "Posted Packing Line ALGO")
                    {
                        DataItemTableView = SORTING("Parcel No. Integer") ORDER(Ascending);
                        DataItemLinkReference = "Posted Packing Header ALGO";
                        DataItemLink = "Packing Document No." = FIELD("No."), "Document Type" = FIELD("Document Type");

                        column(Item_Caption; FieldName(Item))
                        {
                        }
                        column(Description_Caption; RecGItemTrans.Description)
                        {
                        }
                        column(Colum3_Caption; FieldCaption(PO) + '/' + RecGPostWhseShptLine.FieldCaption("Unit of Measure Code") + '/' + FieldCaption("Sales Shipment No."))
                        {
                        }
                        column(Quantity_Caption; Quantity)
                        {
                        }
                        column(TxtNetWeightTotal; TxtNetWeightTotal)
                        {
                        }
                        column(TxtGrssWeightTotal; TxtGrssWeightTotal)
                        {
                        }
                        column(TxtNetVolumeTotal; TxtNetVolumeTotal)
                        {
                        }
                        column(Parcel_No_Caption; FieldCaption("Parcel No."))
                        {
                        }
                        column(Pallet_Caption; FieldCaption(Pallet))
                        {
                        }
                        column(TxtQuantityTotal; TxtQuantityTotal)
                        {
                        }
                        column(Item; Item)
                        {
                        }
                        column(RecGItemTrans; RecGItemTrans.Description)
                        {
                        }
                        column(TxtGColor; TxtGColor)
                        {
                        }
                        column(Origin; Made + TxtGOriginCountryCode)
                        {
                        }
                        column(TariffNoValue; STRSUBSTNO(TxtHSCode, RecGItem."Tariff No."))
                        {
                        }
                        column(TxtNetWeightValue; STRSUBSTNO(TxtNetWeight, RecGItem."Net Weight"))
                        {
                        }
                        column(TxtNetVolumeValue; STRSUBSTNO(TxtNetVolume, RecGItem."Volume (cm3)"))
                        {
                        }
                        column(TxtOutsideCompositionValue; STRSUBSTNO(TxtOutsideComposition, RecGItem."Percentage Composition 1", RecGItem.Composition))
                        {
                        }
                        column(TxtLeatherTrimValue; STRSUBSTNO(TxtLeatherTrim, RecGItem."Percentage Composition 2", RecGItem.Leather))
                        {
                        }
                        column(TxtInsideLinningValue; STRSUBSTNO(TxtInsideLinning, Format(RecGItem.Linning)))
                        {
                        }
                        column(TxtMetalPartValue; STRSUBSTNO(TxtMetalPart, Format(RecGItem."Metal parts")))
                        {
                        }
                        column(TxtWood1Value; STRSUBSTNO(TxtWood1, Format(RecGItem."Wood 1")))
                        {
                        }
                        column(TxtWoddWeight1Value; STRSUBSTNO(TxtWoddWeight1, RecGItem."Wood 1 Weight"))
                        {
                        }
                        column(TxtWood2Value; STRSUBSTNO(TxtWood2, Format(RecGItem."Wood 2")))
                        {
                        }
                        column(TxtWoddWeight2Value; STRSUBSTNO(TxtWoddWeight2, RecGItem."Wood 2 Weight"))
                        {
                        }
                        column(TxtWood3Value; STRSUBSTNO(TxtWood3, Format(RecGItem."Wood 3")))
                        {
                        }
                        column(TxtWoddWeight3Value; STRSUBSTNO(TxtWoddWeight3, RecGItem."Wood 3 Weight"))
                        {
                        }
                        column(Source_No_; "Source No.")
                        {
                        }
                        column(RecGPostWhseShptLine_UnitOfMeasure; RecGPostWhseShptLine."Unit of Measure Code")
                        {
                        }
                        column(PO; PO)
                        {
                        }
                        column(Sales_Shipment_No_; "Sales Shipment No.")
                        {
                        }
                        column(Quantity; Quantity)
                        {
                        }
                        column(DecGNetWeight; DecGNetWeight)
                        {
                        }
                        column(DecGVol; DecGVol)
                        {
                        }
                        column(Parcel_No_; "Parcel No.")
                        {
                        }
                        column(Pallet; Pallet + '/' + Format(IntGPalletNbr))
                        {
                        }
                        column(GrossWeight; DecGPalWeight + DecGParWeight)
                        {
                        }

                        trigger OnAfterGetRecord()
                        var
                            RecLShptHeader: Record "Sales Shipment Header";
                        begin

                            RecGPostWhseShptLine.RESET();
                            IF RecGPostWhseShptLine.FINDFIRST() THEN;

                            RecGItem.RESET();
                            IF RecGItem.GET(RecGPostWhseShptLine."Item No.") THEN BEGIN
                                DecGNetWeight := Quantity * RecGItem."Weight (Net/Gross)";
                                DecGVol := Quantity * RecGItem."Volume (cm3)";

                                CLEAR(RecGItemTrans.Description);
                                RecGItemTrans.RESET();
                                RecGItemTrans.SETRANGE("Item No.", RecGItem."No.");
                                RecGItemTrans.SETRANGE("Language Code", "Sales Shipment Header"."Language Code");
                                IF RecGItemTrans.FindSet() THEN
                                    TxtGColor := RecGItemTrans."Description 2"
                                ELSE
                                    TxtGColor := '';

                                RecGCountry.RESET();
                                RecGCountry.SETRANGE(RecGCountry.Code, RecGItem."Country/Region of Origin Code");
                                IF (RecGCountry.FINDFIRST()) THEN
                                    TxtGOriginCountryCode := RecGCountry.Name;
                            END;

                            DecGWeight += DecGNetWeight;
                            DecGVolume += DecGVol;

                            IntGParcelNo := ElementFoundAt(TabGCountParcel, "Parcel No.");
                            IntGPalletNo := ElementFoundAt(TabGPalletCount, Pallet);

                            DatGOrderDate := 0D;
                            IF RecLShptHeader.GET("Posted Packing Line ALGO"."Sales Shipment No.") THEN
                                DatGOrderDate := RecLShptHeader."Order Date"
                            ELSE
                                DatGOrderDate := 0D;

                            IF PrintToExcel THEN
                                MakeExcelDataBody();

                        end;
                    }


                    trigger OnPreDataItem()
                    begin
                        DecGVol := 0;
                    end;

                    trigger OnAfterGetRecord()
                    var
                        RecLPostPackLineALGO: Record "Posted Packing Line ALGO";
                    begin

                        WHILE (IntGParcelNbr > 0) DO BEGIN
                            TabGCountParcel[IntGParcelNbr] := '';
                            IntGParcelNbr -= 1;
                        END;
                        WHILE (IntGPalletNbr > 0) DO BEGIN
                            TabGCountParcel[IntGPalletNbr] := '';
                            IntGPalletNbr -= 1;
                        END;

                        RecLPostPackLineALGO.RESET();
                        RecLPostPackLineALGO.SETRANGE("Packing Document No.", "No.");
                        RecLPostPackLineALGO.SETRANGE("Document Type", "Document Type");
                        IF RecLPostPackLineALGO.FINDFIRST() THEN
                            REPEAT
                            BEGIN
                                IF (ElementFoundAt(TabGCountParcel, RecLPostPackLineALGO."Parcel No.") < 1) THEN BEGIN
                                    IntGParcelNbr += 1;
                                    //>>FEVT002.002
                                    DecGParWeight += RecLPostPackLineALGO."Parcel Weight";
                                    //<<FEVT002.002
                                    TabGCountParcel[IntGParcelNbr] := RecLPostPackLineALGO."Parcel No.";
                                END;
                                IF (ElementFoundAt(TabGPalletCount, RecLPostPackLineALGO.Pallet) < 1) THEN BEGIN
                                    IntGPalletNbr += 1;
                                    //>>FEVT002.002
                                    DecGPalWeight += RecLPostPackLineALGO."Pallet Weight";
                                    //<<FEVT002.002

                                    DecGVol += RecLPostPackLineALGO."Pallet Weight";
                                    TabGPalletCount[IntGPalletNbr] := RecLPostPackLineALGO.Pallet;
                                END;

                            END;
                            UNTIL (RecLPostPackLineALGO.NEXT() = 0);

                    end;
                }

                trigger OnPreDataItem()
                begin
                    SETFILTER("Sales Shipment No.", '%1', "Sales Shipment Header".GETFILTER("No."));
                    intGLoopNo := 0;
                end;

                trigger OnAfterGetRecord()
                begin

                    RecGSalesShipmentHeader.GET("Sales Shipment No.");
                    IF intGLoopNo > 0 THEN
                        CurrReport.BREAK();
                    intGLoopNo += 1;
                end;

            }
            trigger OnAfterGetRecord()
            var
                RecLCountry: Record Language;
            begin

                CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

                FormatAddr.SalesShptShipTo(TxtGCustAddr, "Sales Shipment Header");
                //FormatAddr.SalesShptBillTo(TxtGCustAddr, "Sales Shipment Header");

                //>>FLGR 14/03/07
                RecGSalesSetup.GET();
                RecGBankAccount.SETFILTER(RecGBankAccount."Currency Code", '%1', "Currency Code");
                IF NOT RecGBankAccount.FindFirst() THEN BEGIN
                    RecGBankAccount.SETFILTER(RecGBankAccount."Currency Code", '%1', '');
                    IF RecGBankAccount.FindFirst() THEN;
                END;


                RecGCompanyInformation.FIND('-');

                IF (FORMAT(RecGCompanyInformation."Stock Capital") <> '') THEN
                    TxtGCompanyInfFr := LLC + RecGCompanyInformation."Stock Capital";
                IF (RecGCompanyInformation."Registration No." <> '') THEN
                    TxtGCompanyInfFr += "RegistrationNo." + RecGCompanyInformation."Registration No.";
                IF (RecGCompanyInformation."APE Code" <> '') THEN
                    TxtGCompanyInfFr += EPCode + RecGCompanyInformation."APE Code";
                IF (RecGCompanyInformation."EORI No." <> '') THEN
                    TxtGCompanyInfFr3 := EORI + RecGCompanyInformation."EORI No.";
                IF (RecGCompanyInformation."Trade Register" <> '') THEN
                    TxtGCompanyInfFr3 += TradeReg + RecGCompanyInformation."Trade Register";
                IF (RecGBankAccount.Name <> '') THEN
                    TxtGCompanyInfFr2 := Bank + RecGBankAccount.Name;
                IF (RecGBankAccount.IBAN <> '') THEN
                    TxtGCompanyInfFr2 += IBAN + RecGBankAccount.IBAN;
                IF (RecGBankAccount."SWIFT Code" <> '') THEN
                    TxtGCompanyInfFr2 += SWIFT + RecGBankAccount."SWIFT Code";



                IF (RecGCompanyInformation."Phone No." <> '') THEN
                    TxtGCompanyPhoneFaxEmail := Phone + RecGCompanyInformation."Phone No.";
                TxtGCompanyAdress := RecGCompanyInformation.Address;
                IF (RecGCompanyInformation."Address 2" <> '') THEN
                    TxtGCompanyAdress := TxtGCompanyAdress + ' - ' + RecGCompanyInformation."Address 2";
                IF (RecGCompanyInformation."Post Code" <> '') THEN
                    TxtGCompanyAdress := TxtGCompanyAdress + '  -  ' + RecGCompanyInformation."Post Code";
                IF (RecGCompanyInformation.City <> '') THEN
                    TxtGCompanyAdress := TxtGCompanyAdress + '  ' + RecGCompanyInformation.City;
                //<<VT004.001
                IF (RecGCompanyInformation.City <> '') THEN BEGIN
                    RecLCountry.SETRANGE(Code, RecGCompanyInformation."Country/Region Code");
                    IF RecLCountry.FINDFIRST() THEN
                        TxtGCompanyAdress := TxtGCompanyAdress + ' - ' + RecLCountry.Name;
                END;
                //<<VT004.001
                IF (RecGCompanyInformation."Phone No. 2" <> '') THEN
                    TxtGCompanyPhoneFaxEmail := TxtGCompanyPhoneFaxEmail + ' - ' + RecGCompanyInformation."Phone No. 2";
                IF (RecGCompanyInformation."Fax No." <> '') THEN
                    TxtGCompanyPhoneFaxEmail := TxtGCompanyPhoneFaxEmail + ' - Fax : ' + RecGCompanyInformation."Fax No.";
                IF (RecGCompanyInformation."E-Mail" <> '') THEN
                    TxtGCompanyPhoneFaxEmail := TxtGCompanyPhoneFaxEmail + ' - E-mail : ' + RecGCompanyInformation."E-Mail";

                //<<FLGR 14/03/07
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
                    field(Print2Excel; PrintToExcel)
                    {
                        Caption = 'Print to Excel';
                    }
                }
            }
        }
    }

    trigger OnInitReport()
    begin

        DecGPageNum := 1;
        IntGParcelNbr := 0;
        IntGPalletNbr := 0;
    end;

    trigger OnPreReport()
    begin

        IF PrintToExcel THEN
            MakeExcelInfo();
    end;

    trigger OnPostReport()
    begin

        IF PrintToExcel THEN
            CreateExcelbook();
    end;


    local procedure CreateExcelbook()
    begin

        ExcelBuf.CreateBook(Text013, Text013);
        ERROR('');
    end;

    local procedure MakeExcelDataBody()
    begin

        ExcelBuf.NewRow();
        ExcelBuf.AddColumn("Posted Packing Line ALGO".Item, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(RecGItemTrans.Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(TxtGColor, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Posted Packing Line ALGO".PO, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Posted Packing Line ALGO".Quantity, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Posted Packing Line ALGO"."Parcel No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Posted Packing Line ALGO".Pallet, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Posted Packing Line ALGO"."Sales Shipment No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Posted Packing Line ALGO"."Parcel Weight", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Posted Packing Line ALGO"."Pallet Weight", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
    end;

    local procedure MakeExcelDataHeader()
    begin

        ExcelBuf.NewRow();
        ExcelBuf.AddColumn("Posted Packing Line ALGO".FIELDCAPTION(Item), FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(RecGItemTrans.FIELDCAPTION(Description), FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(FORMAT(Text010), FALSE, '', TRUE, FALSE, TRUE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Posted Packing Line ALGO".FIELDCAPTION(PO), FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Posted Packing Line ALGO".FIELDCAPTION(Quantity), FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Posted Packing Line ALGO".FIELDCAPTION("Parcel No."), FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Posted Packing Line ALGO".FIELDCAPTION(Pallet), FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Posted Packing Line ALGO".FIELDCAPTION("Sales Shipment No."), FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Posted Packing Line ALGO".FIELDCAPTION("Parcel Weight"), FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Posted Packing Line ALGO".FIELDCAPTION("Pallet Weight"), FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
    end;

    local procedure MakeExcelInfo()
    begin

        //ExcelBuf.SetUseInfoSheed;


        ExcelBuf.ClearNewRow();
        MakeExcelDataHeader();
    end;

    local procedure ElementFoundAt(var CodLArray: array[1000] of code[20]; var CodLValue: code[20]): Integer
    var
        i: Integer;
    begin

        i := 1;
        WHILE ((i < 1000) AND (CodLArray[i] <> CodLValue)) DO
            i += 1;


        IF i < 1000 THEN
            EXIT(i)
        ELSE
            EXIT(-1);

    end;

    local procedure CalcValuePerUOM(RecLPackLine: Record "Packing Line ALGO"; IntOption: Integer)
    begin

    end;



    var
        RecGCompanyInformation: Record "Company Information";
        RecGSalesShipmentHeader: Record "Sales Shipment Header";
        TxtGCompanyAdress: Text[150];
        TxtGCompanyPhoneFaxEmail: Text[150];
        TxtGCompanyInfFr: Text[1000];
        TxtGCompanyInfFr2: Text[1000];
        TxtGCompanyInfFr3: Text[1000];
        TxtGExtendedRight: Text[200];
        TxtGColor: Text[50];
        CodGTariffNo: Code[20];
        CodGOriginCountryCode: Code[10];
        RecGLanguage: Record Language;
        RecGShipmentHeader: Record "Sales Shipment Header";
        DecGQuantity: Decimal;
        DecGWeight: Decimal;
        DecGVolume: Decimal;
        DecGPageNum: Integer;
        TxtGCustAddr: array[8] of Text[50];
        RecGCustomer: Record Customer;
        RecGInvoiceHeader: Record "Sales Invoice Header";
        CodGCustomer: code[20];
        RecGItem: Record Item;
        RecGCountry: Record "Country/Region";
        TxtGOriginCountryCode: Text[50];
        RecGExtendedTextHeader: Record "Extended Text Header";
        RecGExtendedTextLine: Record "Extended Text Line";
        CodGLanguage: code[20];
        RecGPackingLine: Record "Packing Line ALGO";
        IntGParcelNbr: Integer;
        IntGPalletNbr: Integer;
        CodGPrevieousParcel: Code[20];
        CodGPrevieousPallet: code[20];
        TabGCountParcel: array[1000] of code[20];
        TabGPalletCount: array[1000] of Code[20];
        DecGPalletWeight: Decimal;
        DecGParcelWeight: Decimal;
        IntGPalletNo: Integer;
        IntGParcelNo: Integer;
        RecGPackingLine2: Record "Packing Line ALGO";
        DecGPalWeight: Decimal;
        DecGParWeight: Decimal;
        CodGUnit: Code[20];
        CodGCountry: Code[20];
        RecGWhseShipLine: Record "Warehouse Shipment Header";
        RecGPostWhseShptLine: Record "Warehouse Shipment Line";
        DecGNetWeight: Decimal;
        DecGVol: Decimal;
        DecGAmount: Decimal;
        DecGVATAmount: Decimal;
        DecGTotalAmountIncVAT: Decimal;
        DecGTotalAmount: Decimal;
        DecGAmountExVAT: Decimal;
        DecGVatAmountLine: Decimal;
        DecGTotalAmountExVAT: Decimal;
        intGLoopNo: Integer;
        RecGItemTrans: Record "Item Translation";
        Language: Record Language;
        FormatAddr: Codeunit "Format Address";
        DatGOrderDate: Date;
        RecGBankAccount: Record "Bank Account";
        RecGSalesSetup: Record "Sales & Receivables Setup";
        ExcelBuf: Record "Excel Buffer";
        PrintToExcel: Boolean;
        Text013: Label 'Lignes Colisage';
        Text010: Label 'Désignation 2';
        Phone: Label 'Phone :';
        LLC: Label 'LLC with capital of';
        "RegistrationNo.": Label '- Registration No. :';
        EPCode: Label '- EP Code :';
        EORI: Label '- EORI No. :';
        TradeReg: Label '-TR :';
        Bank: Label 'Bank :';
        IBAN: Label '- IBAN No. :';
        SWIFT: Label '- SWIFT Code :';
        Made: Label 'Made in';
        TxtGHeader: Label 'EORI No. : %1 - MID Code : %2 - AEO Certificate No. : %3';
        TxtTitle: Label '-- PROFORMA INVOICE --';
        TxtHSCode: Label 'H.S. Code : %1';
        TxtNetWeight: Label 'Net Weight (kg.) : %1';
        TxtNetVolume: Label 'Net volume in cm3 : %1';
        TxtOutsideComposition: Label 'Outside Composition : %1% %2';
        TxtLeatherTrim: Label 'Leather trim : %1% %2';
        TxtInsideLinning: Label 'Inside Linning : %1';
        TxtMetalPart: Label 'Metal part : %1';
        TxtWood1: Label 'Wood 1 : %1';
        TxtWoddWeight1: Label 'Wood 1 Weight (kg.) : %1';
        TxtWood2: Label 'Wood 2 : %1';
        TxtWoddWeight2: Label 'Wood 2 Weight (kg.) : %1';
        TxtWood3: Label 'Wood 2 : %1';
        TxtWoddWeight3: Label 'Wood 2 Weight (kg.) : %1';
        TxtNetWeightTotal: Label 'Net weight Total (kg.)';
        TxtGrssWeightTotal: Label 'Gross weight Total (kg.)';
        TxtNetVolumeTotal: Label 'Net volume Total (cm3)';
        TxtQuantityTotal: Label 'Quantity Total';
        TxtUniPriceExcVAT: Label 'Unit Price Exc. VAT';
        TxtAmountExcVAT: Label 'Amount Exc. VAT';
        TxtVATAmount: Label 'VAT Amount : ';
        TxtTotalAmountExcVAT: Label 'Total Amount Exc. VAT : ';
        TxtTotalAmountIncVAT: Label 'Total Amount Inc. VAT : ';
}