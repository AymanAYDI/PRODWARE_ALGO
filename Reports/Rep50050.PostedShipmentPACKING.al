report 50050 "Posted Shipment PACKING"
{
    Caption = 'Impression COLISAGE';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports/Rep50050.PostedShipmentPACKING.rdl';
    ApplicationArea = Basic, Suite;
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Posted Whse. Shipment Header"; "Posted Whse. Shipment Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            dataitem(Integer; Integer)
            {
                DataItemLinkReference = "Posted Whse. Shipment Header";
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                dataitem("Posted Whse. Shipment Line"; "Posted Whse. Shipment Line")
                {
                    DataItemLink = "No." = FIELD("No.");
                    DataItemLinkReference = "Posted Whse. Shipment Header";
                    DataItemTableView = SORTING("No.", "Line No.");
                    dataitem("Posted Packing Line ALGO"; "Posted Packing Line ALGO")
                    {
                        DataItemLink = "Whse.Posted Shipment No." = FIELD("No."), "Whse.Posted Shipment Line No." = FIELD("Whse Shipment Line No."), "Shipment Document No." = FIELD("Whse. Shipment No.");
                        DataItemLinkReference = "Posted Whse. Shipment Line";

                        column(RecGCompanyInf_Name; RecGCompanyInf.Name)
                        {
                        }
                        column(RecGCompanyInf_AddressComplet; RecGCompanyInf.Address + '   -     ' + RecGCompanyInf."Address 2" + '  -  ' + RecGCompanyInf."Post Code" + '  ' + RecGCompanyInf.City + ' - France')
                        {
                        }
                        column(RecGCompanyInf_Phone_Fax; 'Tel : ' + RecGCompanyInf."Phone No." + ' - Fax : ' + RecGCompanyInf."Fax No.")
                        {
                        }
                        column(TxtGHeader; STRSUBSTNO(TxtGHeader, RecGCompanyInf."EORI No.", RecGCompanyInf."MID Code", RecGCompanyInf."AEO Certificate No."))
                        {
                        }
                        column(PostedWhseShipmentHeader_No; "Posted Whse. Shipment Header"."No.")
                        {
                        }
                        column(PostedWhseShipmentHeader_PostingDate; "Posted Whse. Shipment Header"."Posting Date")
                        {
                        }
                        column(RecGCompanyInf_VATRegistrationNo; RecGCompanyInf."VAT Registration No.")
                        {
                        }
                        column(LocationDestin_Name; LocationDestin.Name)
                        {
                        }
                        column(LocationDestin_Address; LocationDestin.Address)
                        {
                        }
                        column(LocationDestin_Address2; LocationDestin."Address 2")
                        {
                        }
                        column(LocationDestin_PostCodeCity; LocationDestin."Post Code" + ' - ' + LocationDestin.City)
                        {
                        }
                        column(RecGCountryDest_Name; RecGCountryDest.Name)
                        {
                        }
                        column(PostedWhseShipmentLine_ItemNo; "Posted Whse. Shipment Line"."Item No.")
                        {
                        }
                        column(RecGItem_Description; RecGItem.Description)
                        {
                        }
                        column(RecGItem_Description2; RecGItem."Description 2")
                        {
                        }
                        column(TxtGOrigin; STRSUBSTNO(TxtGOrigin, RecGCountry.Name))
                        {
                        }
                        column(TxtG0012; TxtG0012)
                        {
                        }
                        column(RecGItem_TariffNo; RecGItem."Tariff No.")
                        {
                        }
                        column(RecGItem_WeightNetGross; RecGItem."Weight (Net/Gross)")
                        {
                        }
                        column(RecGItem_VolumeCm3; RecGItem."Volume (cm3)")
                        {
                        }
                        column(RecGItem_HeightCm; RecGItem."Height (cm)")
                        {
                        }
                        column(RecGItem_LengthCm; RecGItem."Length (cm)")
                        {
                        }
                        column(RecGItem_WidthCm; RecGItem."Width (cm)")
                        {
                        }
                        column(RecGItem_PercentageComposition1; RecGItem."Percentage Composition 1")
                        {
                        }
                        column(RecGItem_Composition; FORMAT(RecGItem.Composition))
                        {
                        }
                        column(RecGCountry_Name; RecGCountry.Name)
                        {
                        }
                        column(RecGItem_MetalParts; FORMAT(RecGItem."Metal parts"))
                        {
                        }
                        column(PostedWhseShipmentLine_UnitOfMeasureCode; "Posted Whse. Shipment Line"."Unit of Measure Code")
                        {
                        }
                        column(SourceNo; "Source No.")
                        {
                        }
                        column(PostedWhseShipmenLin_QuantityXRecGItem_WeightNetGross; "Posted Whse. Shipment Line".Quantity * RecGItem."Weight (Net/Gross)")
                        {
                        }
                        column(Quantity; Quantity)
                        {
                        }
                        column(ProdCUB_UnitCost; ProdCUB."Unit Cost")
                        {
                        }
                        column(LineAmount; LineAmount)
                        {
                        }
                        column(ParcelNoIntGParcelNbr; "Parcel No." + '/' + FORMAT(IntGParcelNbr))
                        {
                        }
                        column(PalletIntGPalletNbr; Pallet + '/' + FORMAT(IntGPalletNbr))
                        {
                        }
                        column(ParcelWeight; "Parcel Weight")
                        {
                        }
                        column(PalletWeight; "Pallet Weight")
                        {
                        }
                        column(DecGPalWeightPlusDecGParWeight; DecGPalWeight + DecGParWeight)
                        {
                        }
                        column(Packing_Document_No_; "Packing Document No.")
                        {
                        }
                        column(Shipment_Document_No_; "Shipment Document No.")
                        {
                        }
                        column(Shipment_Line_No_; "Shipment Line No.")
                        {
                        }
                        column(Parcel_No_; "Parcel No.")
                        {
                        }
                        trigger OnAfterGetRecord()
                        begin
                            LineAmount := "Posted Packing Line ALGO".Quantity * ProdCUB."Unit Cost";
                            IntGParcelNo := ElementFoundAt(TabGCountParcel, "Posted Packing Line ALGO"."Parcel No.");
                            IntGPalletNo := ElementFoundAt(TabGPalletCount, "Posted Packing Line ALGO".Pallet);
                        end;

                    }
                    trigger onaftergetrecord()
                    begin
                        GetLocation("Location Code");
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
                        IF RecGCountry.FIND('-') THEN;
                        // End Origine
                        //CUB
                        CLEAR(ProdCUB."Unit Cost");
                        ProdCUB.RESET();
                        ProdCUB.SETFILTER(ProdCUB."Item No.", "Posted Whse. Shipment Line"."Item No.");
                        ProdCUB.SETFILTER(ProdCUB."Cost Type", 'C.U.B.');
                        ProdCUB.SETFILTER(ProdCUB."Starting Date", '%1|..%2', 0D, "Posted Whse. Shipment Line"."Posting Date");
                        ProdCUB.SETFILTER(ProdCUB."Ending Date", '%1|%2..', 0D, "Posted Whse. Shipment Line"."Posting Date");
                        IF NOT ProdCUB.FIND('+') THEN BEGIN
                            // MESSAGE('  Pas de CUR défini : impossible de générer le report   ');
                        END;
                    end;

                }
            }
            trigger OnAfterGetRecord()
            var
                RecLPostPackLineALGO: Record "Posted Packing Line ALGO";
            begin

                Language.SETFILTER(Code, 'ENU');
                CurrReport.LANGUAGE := Language.GetLanguageID('enu');
                RecGCompanyInf.GET();


                GetLocation("Location Code");


                DecGPalletWeight := 0;
                DecGParcelWeight := 0;
                CodGPrevieousParcel := '';
                CodGPrevieousPallet := '';

                //Number Of Parcel and Pallet

                WHILE (IntGParcelNbr > 0) DO BEGIN
                    TabGCountParcel[IntGParcelNbr] := '';
                    IntGParcelNbr -= 1;
                END;
                WHILE (IntGPalletNbr > 0) DO BEGIN
                    TabGCountParcel[IntGPalletNbr] := '';
                    IntGPalletNbr -= 1;
                END;

                RecLPostPackLineALGO.RESET();
                RecLPostPackLineALGO.SETRANGE("Whse.Posted Shipment No.", "Posted Whse. Shipment Header"."No.");
                IF RecLPostPackLineALGO.FINDFIRST() THEN
                    REPEAT
                        IF (ElementFoundAt(TabGCountParcel, RecLPostPackLineALGO."Parcel No.") < 1) THEN BEGIN
                            IntGParcelNbr += 1;
                            DecGParWeight += RecLPostPackLineALGO."Parcel Weight";
                            TabGCountParcel[IntGParcelNbr] := RecLPostPackLineALGO."Parcel No.";
                        END;
                        IF (ElementFoundAt(TabGPalletCount, RecLPostPackLineALGO.Pallet) < 1) THEN BEGIN
                            IntGPalletNbr += 1;
                            DecGPalWeight += RecLPostPackLineALGO."Pallet Weight";

                            DecGVol += RecLPostPackLineALGO."Pallet Weight";
                            TabGPalletCount[IntGPalletNbr] := RecLPostPackLineALGO.Pallet;
                        END;
                    UNTIL (RecLPostPackLineALGO.NEXT() = 0);
            end;
        }
    }
    labels
    {
        FabricantLbl = 'Actual  Manufacturer ';
        ListeColisageLbl = '-- PACKING LIST --';
        ReferenceLbl = 'Reference :';
        DateLbl = 'Date :';
        VAT_RegistrationNoLbl = 'VAT Registration No. :';
        LivreALbl = 'Ship to:';
        FactureALbl = 'Sold to :';
        ReferenceTableauLbl = 'Reference';
        DescriptionLbl = 'Description';
        UnitLbl = 'UOM / Order No.';
        QuantiteLbl = 'Quantity';
        PrixUnitaireLbl = 'Unit Price';
        TotalLigneLbl = 'Line Amount';
        ColisLbl = 'Parcel';
        PalletteLbl = 'Pallet';
        PoidsNetKgLbl = 'Net Weight in Kg.';
        VolumeNetLbl = 'Net Volume in cm3.';
        DimensionCmLbl = 'Dimensions in cm :';
        HeightLbl = 'Height';
        LenghtLbl = 'Lenght';
        WidthLbl = 'Width';
        CompositionExtLbl = 'Outside Composition :';
        PourcentLbl = '%';
        BijouterieLbl = 'Metal Parts :';
        PoidsNetTotalKgLbl = 'Total Net Weight in Kg :';
        PoidsLbl = 'Poids';
        PoidsPaletteLbl = 'Poids Palette';
    }

    trigger OnInitReport()
    begin
        IntGParcelNbr := 0;
        IntGPalletNbr := 0;
    end;

    var
        RecGPAckLineALGO: Record "Packing Line ALGO";
        Location: Record "Location";
        RecGCompanyInf: Record "Company Information";
        LocationDestin: Record "Location";
        RecGItem: Record "Item";
        RecGCountry: Record "Country/Region";
        ProdCUB: Record "Unit Cost Budget";
        Language: Record "Language";
        RecGCountryDest: Record "Country/Region";
        RecGPackingLine: Record "Packing Line ALGO";
        vAlerteInformation: Text[250];
        CodGPrevieousParcel: Code[20];
        CodGPrevieousPallet: code[20];
        TabGCountParcel: array[1000] of code[20];
        TabGPalletCount: array[1000] of code[20];
        LineAmount: decimal;
        DecGPalletWeight: decimal;
        DecGParcelWeight: decimal;
        DecGParWeight: decimal;
        DecGPalWeight: decimal;
        DecGVol: decimal;
        IntGParcelNbr: Integer;
        IntGPalletNbr: Integer;
        IntGPalletNo: Integer;
        IntGParcelNo: Integer;
        TxtGHeader: Label 'EORI No. : %1 - MID Code : %2 - AEO Certificate No. : %3';
        Text005: Label 'Page %1';
        TxtG0012: Label 'H.S. Code :';
        TxtGOrigin: Label 'Made in  %1';

    local procedure GetLocation(LocationCode: Code[10])
    begin
        IF LocationCode = '' THEN
            Location.INIT
        ELSE
            IF Location.Code <> LocationCode THEN
                Location.GET(LocationCode);
    end;

    procedure ElementFoundAt(var CodLArray: array[1000] of code[20]; var CodLValue: code[20]) index: Integer
    var
        i: Integer;
    begin
        i := 1;
        WHILE ((i < 1000) AND (CodLArray[i] <> CodLValue)) DO BEGIN
            i += 1;
        END;
        IF i < 1000 THEN
            EXIT(i)
        ELSE
            EXIT(-1);
    end;

    local procedure MyProcedure()
    var
        myInt: Integer;
    begin

    end;
}