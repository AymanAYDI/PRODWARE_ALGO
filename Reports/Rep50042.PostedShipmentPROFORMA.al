report 50042 "Posted Shipment PROFORMA"
{
    Caption = 'Posted Shipment PROFORMA';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports/Rep50042.PostedShipmentPROFORMA.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Posted Whse. Shipment Header"; "Posted Whse. Shipment Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";

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
            column(Document_Date; "Posting Date")
            {
            }
            column(Document_DateCaption; FieldCaption("Posting Date"))
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
            column(VAT_Registration_No_Caption; RecGCompanyInformation.FieldCaption("VAT Registration No."))
            {
            }
            column(TxtGCompanyInfFr; TxtGCompanyInfFr + TxtGCompanyInfFr3)
            {
            }
            // ALGO20200317 - ajout d'une nouvelle ligne de pied de page pour le siege social
            column(TxtGFooter02; STRSUBSTNO(TxtGFooter02, ' ' + RecGCompanyInformation.Name, ' ' + RecGCompanyInformation."Head Office"))
            {
            }
            dataitem("Posted Whse. Shipment Line"; "Posted Whse. Shipment Line")
            {
                DataItemTableView = SORTING("No.", "Line No.");
                DataItemLinkReference = "Posted Whse. Shipment Header";
                DataItemLink = "No." = FIELD("No.");

                column(Ship_to_Address_Caption; LocationDestin.FieldCaption(Address))
                {
                }
                column(Sell_to_Address_Caption; LocationDestin.FieldCaption(Address))
                {
                }
                column(Ship_to_Name; LocationDestin.Name)
                {
                }
                column(Ship_to_Address; LocationDestin.Address)
                {
                }
                column(Ship_to_Address_2; LocationDestin."Address 2")
                {
                }
                column(Ship_to_City; LocationDestin.City)
                {
                }
                column(Ship_to_Country_Region_Code; RecGCountryDest.Name)
                {
                }
                column(TxtGCustAddr1; LocationDestin.Name)
                {
                }
                column(TxtGCustAddr2; LocationDestin.Address)
                {
                }
                column(TxtGCustAddr3; LocationDestin."Address 2")
                {
                }
                column(TxtGCustAddr4; LocationDestin."Post Code" + '-' + LocationDestin.City)
                {
                }
                column(TxtGCustAddr5; RecGCountryDest.Name)
                {
                }
                column(TxtGCustAddr6; '')
                {
                }
                column(LineAmount; LineAmount)
                {
                }
                column(TxtLineAmount; TxtLineAmount)
                {
                }
                column(UnitCost; ProdCUB."Unit Cost")
                {
                }
                column(UnitCostCaption; ProdCUB.FieldCaption("Unit Cost"))
                {
                }
                dataitem("Posted Packing Line ALGO"; "Posted Packing Line ALGO")
                {
                    DataItemTableView = SORTING("Parcel No. Integer") ORDER(Ascending);
                    DataItemLinkReference = "Posted Whse. Shipment Line";
                    DataItemLink = "Whse.Posted Shipment No." = FIELD("No."), "Whse.Posted Shipment Line No." = FIELD("Whse Shipment Line No."), "Shipment Document No." = FIELD("Whse. Shipment No.");

                    column(Item_Caption; FieldName(Item))
                    {
                    }
                    column(Description_Caption; RecGItemTrans.Description)
                    {
                    }
                    column(Colum3_Caption; FieldCaption(PO) + '/' + RecGPostWhseShptLine.FieldCaption("Unit of Measure Code") + '/' + FieldCaption("Sales Shipment No."))
                    {
                    }
                    column(Quantity_Caption; FieldName(Quantity))
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
                    column(TxtItemDesc; TxtItemDesc)
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
                        IntGParcelNo := ElementFoundAt(TabGCountParcel, "Posted Packing Line ALGO"."Parcel No.");
                        IntGPalletNo := ElementFoundAt(TabGPalletCount, "Posted Packing Line ALGO".Pallet);
                        //>>FEVT004.001

                        RecGPostWhseShptLine.RESET();
                        // OL @TODO
                        //IF RecGPostWhseShptLine.FINDFIRST() THEN;
                        if (RecGPostWhseShptLine.Get("Posted Packing Line ALGO"."Whse.Posted Shipment No.")) then;
                        RecGItem.RESET();
                        IF RecGItem.GET("Posted Whse. Shipment Line"."Item No.") THEN BEGIN
                            TxtItemDesc := RecGItem.Description;
                            TxtGColor := RecGItem."Description 2";
                            //DecGNetWeight := Quantity * RecGItem."Weight (Net/Gross)";
                            DecGNetWeight := Quantity * RecGItem."Net Weight";
                            DecGVol := Quantity * RecGItem."Volume (cm3)";

                            //>>
                            CLEAR(RecGItemTrans.Description);
                            RecGItemTrans.RESET();
                            RecGItemTrans.SETRANGE("Item No.", RecGItem."No.");
                            RecGItemTrans.SETRANGE("Language Code", 'FR');
                            IF RecGItemTrans.FindSet() THEN
                                TxtGColor := RecGItemTrans."Description 2"
                            ELSE
                                TxtGColor := RecGItem."Description 2";
                            //<<

                            RecGCountry.RESET();
                            RecGCountry.SETRANGE(RecGCountry.Code, RecGItem."Country/Region of Origin Code");
                            IF (RecGCountry.FINDFIRST()) THEN
                                TxtGOriginCountryCode := RecGCountry.Name;

                        END;

                        DecGWeight += DecGNetWeight;
                        DecGVolume += DecGVol;

                        DatGOrderDate := 0D;
                        IF RecLShptHeader.GET("Posted Packing Line ALGO"."Sales Shipment No.") THEN
                            DatGOrderDate := RecLShptHeader."Order Date"
                        ELSE
                            DatGOrderDate := 0D;

                        IF PrintToExcel THEN
                            MakeExcelDataBody();


                        LineAmount := "Posted Packing Line ALGO".Quantity * ProdCUB."Unit Cost";
                    end;


                }
                trigger OnAfterGetRecord()
                begin

                    GetLocation("Location Code");

                    CodGPreviousPallet := '';
                    CodGPreviousParcel := '';

                    RecLPostPackLineALGO.Reset();
                    RecLPostPackLineALGO.SetRange("Whse.Posted Shipment No.", "Posted Whse. Shipment Header"."No.");
                    if RecLPostPackLineALGO.FindFirst() then
                        repeat
                            if (ElementFoundAt(TabGCountParcel, RecLPostPackLineALGO."Parcel No.") < 1) then begin
                                IntGParcelNbr += 1;
                                DecGParWeight += RecLPostPackLineALGO."Parcel Weight";
                                TabGCountParcel[IntGParcelNbr] := RecLPostPackLineALGO."Parcel No.";
                            end;
                            if (ElementFoundAt(TabGPalletCount, RecLPostPackLineALGO."Pallet") < 1) then begin
                                IntGPalletNbr += 1;
                                DecGPalWeight += RecLPostPackLineALGO."Pallet Weight";
                                DecGVol += RecLPostPackLineALGO."Pallet Weight";
                                TabGPalletCount[IntGPalletNbr] := RecLPostPackLineALGO.Pallet;
                            end;
                        until (RecLPostPackLineALGO.Next() = 0);

                    LocationDestin.GET("Posted Whse. Shipment Line"."Destination No.");
                    // Origine
                    RecGCountryDest.RESET();
                    RecGCountryDest.SETFILTER(Code, LocationDestin."Country/Region Code");
                    IF RecGCountryDest.FIND('-') THEN;
                    // End Origine



                    RecGItem.GET("Posted Whse. Shipment Line"."Item No.");

                    // Origine
                    RecGCountry.RESET();
                    RecGCountry.SETFILTER(Code, RecGItem."Country/Region of Origin Code");
                    IF RecGCountry.FINDFIRST() THEN;
                    // End Origine


                    //CUB
                    CLEAR(ProdCUB."Unit Cost");
                    ProdCUB.RESET();
                    ProdCUB.SETFILTER(ProdCUB."Item No.", "Posted Whse. Shipment Line"."Item No.");
                    ProdCUB.SETFILTER(ProdCUB."Cost Type", 'C.U.B.');
                    ProdCUB.SETFILTER(ProdCUB."Starting Date", '%1|..%2', 0D, "Posted Whse. Shipment Line"."Posting Date");
                    ProdCUB.SETFILTER(ProdCUB."Ending Date", '%1|%2..', 0D, "Posted Whse. Shipment Line"."Posting Date");
                    IF NOT ProdCUB.FindLast() THEN;
                    //MESSAGE('  Pas de CUB défini : impossible de générer le report   ');
                end;

            }

            trigger OnAfterGetRecord()
            var
                RecLCountry: Record Language;
            begin

                CurrReport.LANGUAGE := Language.GetLanguageID('FR');

                DecGWeight := 0;
                DecGVolume := 0;


                //FormatAddr.SalesShptBillTo(TxtGCustAddr, "Sales Shipment Header");

                //>>FLGR 14/03/07
                RecGSalesSetup.GET();
                RecGBankAccount.SETFILTER(RecGBankAccount."Currency Code", '%1', '');
                IF NOT RecGBankAccount.FindFirst() THEN BEGIN
                    RecGBankAccount.SETFILTER(RecGBankAccount."Currency Code", '%1', '');
                    IF RecGBankAccount.FindFirst() THEN;
                END;


                RecGCompanyInformation.FIND('-');

                IF (FORMAT(RecGCompanyInformation."Stock Capital") <> '') THEN
                    TxtGCompanyInfFr := RecGCompanyInformation."Legal Form" + ' au capital de ' + RecGCompanyInformation."Stock Capital";
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
        ExcelBuf.AddColumn(TxtItemDesc, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
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

    local procedure GetLocation(LocationCode: code[10])
    begin

        IF LocationCode = '' THEN
            Location.INIT()
        ELSE
            IF Location.Code <> LocationCode THEN
                Location.GET(LocationCode);
    end;

    var
        RecGPAckLineALGO: Record "Packing Line ALGO";
        RecLPostPackLineALGO: Record "Posted Packing Line ALGO";
        RecGCompanyInformation: Record "Company Information";
        RecGSalesShipmentHeader: Record "Sales Shipment Header";
        TxtGCompanyAdress: Text[150];
        TxtGCompanyPhoneFaxEmail: Text[150];
        TxtGCompanyInfFr: Text[1000];
        TxtGCompanyInfFr2: Text[1000];
        TxtGCompanyInfFr3: Text[1000];
        TxtGExtendedRight: Text[200];
        TxtItemDesc: Text[50];
        TxtGColor: Text[50];
        CodGTariffNo: Code[20];
        CodGOriginCountryCode: Code[10];
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
        CodGPreviousParcel: Code[20];
        CodGPreviousPallet: code[20];
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
        LineAmount: Decimal;
        intGLoopNo: Integer;
        RecGItemTrans: Record "Item Translation";
        Language: Record Language;
        FormatAddr: Codeunit "Format Address";
        DatGOrderDate: Date;
        RecGBankAccount: Record "Bank Account";
        RecGSalesSetup: Record "Sales & Receivables Setup";
        ExcelBuf: Record "Excel Buffer";
        Location: Record Location;
        LocationDestin: Record Location;
        ProdCUB: Record "Unit Cost Budget";
        RecGCountryDest: record "Country/Region";
        PrintToExcel: Boolean;
        Text013: Label 'Lignes Colisage';
        Text010: Label 'Désignation 2';
        Phone: Label 'Phone :';
        LLC: Label ' with capital of';
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
        TxtLineAmount: Label 'Line Amount';
        // ALGO20200317 - Modif pour la forme juridique  
        TxtGFooter01: Label '%6 with the Capital of %1 - Siret No. %2 -APE Code %3 - VAT Intracom. No. %4 - RC : %5';
        // ALGO201200317 - ajout ligne pied de page siege social
        TxtGFooter02: Label 'Siège social : %1 %2';
}