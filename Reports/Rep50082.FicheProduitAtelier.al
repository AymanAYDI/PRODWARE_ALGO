report 50082 "Fiche Produit Atelier"
{
    Caption = 'Fiche Produit Atelier', Locked = true;
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports/Rep50082.FicheProduitAtelier.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;



    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING("Low-Level Code");

            column(Global_BooGGoyard; BooGGoyard)
            { }
            column(Global_BooGLUNIFORM; BooGLUNIFORM)
            { }
            column(Global_VGChoix; VGChoix)
            { }
            column(Global_CodGItemNo; CodGItemNo)
            { }
            column(Global_CodGRoutingVersion; CodGRoutingVersion)
            { }
            column(Global_CodGBomVersion; CodGBomVersion)
            { }

            column(Item_Calc_Date; "Calc.Date")
            { }
            column(Item_No_; "No.")
            { }
            column(Item_Description; Description)
            { }
            column(Item_Description_2; "Description 2")
            { }
            column(Item_Routing_No_; "Routing No.")
            { }
            column(Item_Production_BOM_No_; "Production BOM No.")
            { }
            column(Replenishment_System; "Replenishment System")
            { }
            column(Item_RtngVersionCode; RtngVersionCode)
            { }
            column(Item_PBOMVersionCode; PBOMVersionCode[1])
            { }
            column(Item_Picture; Picture)
            { }
            column(Item_Unit_Price; VgUnitPrice)
            { }

            dataitem("Routing Line"; "Routing Line")
            {
                DataItemTableView = SORTING("Routing No.", "Version Code", "Operation No.");
                DataItemLinkReference = "Item";

                column(RoutingLine_Tauxdemaj; (vCoefMajor - 1) * 100)
                { }
                column(RoutingLine_Operation_No_; "Operation No.")
                { }
                column(RoutingLine_Type; Type)
                { }
                column(RoutingLine_No_; "No.")
                { }
                column(RoutingLine_Description; Description)
                { }
                column(RoutingLine_Setup_Time; "Setup Time")
                { }
                column(RoutingLine_Run_Time; "Run Time")
                { }
                column(RoutingLine_CostTime; CostTime)
                { }
                column(RoutingLine_ProdUnitCost; ProdUnitCost)
                { }
                column(RoutingLine_CoutTotMaj; ProdTotalCost * vCoefMajor)
                { }

                trigger OnPreDataItem()
                begin

                    //>>TO 200416
                    SETRANGE("Routing No.", CodGRoutingCode);
                    //<<TO 200416
                    SETRANGE("Version Code", RtngVersionCode);

                    InRouting := TRUE;
                end;

                trigger OnAfterGetRecord()
                var
                    UnitCostCalculation: Option "Time","Unit";
                begin

                    ProdUnitCost := "Unit Cost per";

                    CostCalcMgt.RoutingCostPerUnit(
                      Type,
                      "No.",
                      DirectUnitCost,
                      IndirectCostPct,
                      OverheadRate, ProdUnitCost, UnitCostCalculation);
                    CostTime :=
                      CostCalcMgt.CalcCostTime(
                        CostCalcMgt.CalcQtyAdjdForBOMScrap(Item."Lot Size", Item."Scrap %"),
                        "Setup Time", "Setup Time Unit of Meas. Code",
                        "Run Time", "Run Time Unit of Meas. Code", "Lot Size",
                        "Scrap Factor % (Accumulated)", "Fixed Scrap Qty. (Accum.)",
                        "Work Center No.", UnitCostCalculation, MfgSetup."Cost Incl. Setup",
                        "Concurrent Capacities") /
                      Item."Lot Size";

                    TotalRunTime := CostTime;

                    ProdTotalCost := CostTime * ProdUnitCost;
                end;

                trigger OnPostDataItem()
                begin
                    InRouting := FALSE;
                end;
            }
            dataitem(BOMLoop; Integer)
            {
                DataItemTableView = SORTING(Number);
                DataItemLinkReference = "Item";

                column(BOMLoop_Tauxdemaj; (vCoefMajor - 1) * 100)
                { }
                column(BOMLoop_ProdBOMLineNo; ProdBOMLine[Level]."No.")
                { }
                column(BOMLoop_ProdBOMLineDesc; ProdBOMLine[Level].Description + ' - ' + CompItem."Description 2")
                { }
                column(BOMLoop_ProdBOMLineQty; ProdBOMLine[Level].Quantity)
                { }
                column(BOMLoop_UnitOfMeasure; CompItem."Base Unit of Measure")
                { }
                column(BOMLoop_CUBUnit; ProdCUB."Unit Cost")
                { }
                column(BOMLoop_CUBMaj; ProdBOMLine[Level].Quantity * ProdCUB."Unit Cost" * vCoefMajor)
                { }
                column(BOMLoop_CURUnit; ProdCUR."Unit Cost")
                { }
                column(BOMLoop_CURMaj; DecGCostLineCUR)
                { }

                dataitem(BOMComponentLine; Integer)
                {
                    DataItemTableView = SORTING(Number);
                    DataItemLinkReference = "BOMLoop";
                    MaxIteration = 1;
                }
                trigger OnPreDataItem()
                begin

                    DecGCostTotal := 0;

                    IF CodGBomCode = '' THEN
                        CurrReport.BREAK();

                    Level := 1;

                    ProdBOMHeader.GET(PBOMNoList[Level]);

                    CLEAR(ProdBOMLine);

                    ProdBOMLine[Level].SETRANGE("Production BOM No.", PBOMNoList[Level]);
                    ProdBOMLine[Level].SETRANGE("Version Code", PBOMVersionCode[Level]);
                    ProdBOMLine[Level].SETFILTER("Starting Date", '%1|..%2', 0D, "Calc.Date");
                    ProdBOMLine[Level].SETFILTER("Ending Date", '%1|%2..', 0D, "Calc.Date");

                    Quantity[Level] := CostCalcMgt.CalcQtyAdjdForBOMScrap(Item."Lot Size", Item."Scrap %");

                    InBOM := TRUE;

                    CLEAR(ProdCUB."Unit Cost");
                end;

                trigger OnAfterGetRecord()
                var
                    UOMFactor: Decimal;
                begin

                    WHILE ProdBOMLine[Level].NEXT() = 0 DO BEGIN
                        Level := Level - 1;
                        IF Level < 1 THEN
                            CurrReport.BREAK;
                        ProdBOMLine[Level].SETRANGE("Production BOM No.", PBOMNoList[Level]);
                        ProdBOMLine[Level].SETRANGE("Version Code", PBOMVersionCode[Level]);
                    END;

                    NextLevel := Level;
                    CLEAR(CompItem);

                    IF Level = 1 THEN
                        UOMFactor :=
                          UOMMgt.GetQtyPerUnitOfMeasure(Item, VersionMgt.GetBOMUnitOfMeasure(PBOMNoList[Level], PBOMVersionCode[Level]))
                    ELSE
                        UOMFactor := 1;


                    CompItemQtyBase :=
                      CostCalcMgt.CalcCompItemQtyBase(ProdBOMLine[Level], "Calc.Date", Quantity[Level], Item."Routing No.", Level = 1) /
                      UOMFactor;

                    CASE ProdBOMLine[Level].Type OF
                        ProdBOMLine[Level].Type::Item:
                            BEGIN
                                CompItem.GET(ProdBOMLine[Level]."No.");
                                //CompItem.CALCFIELDS(CompItem.Picture, CompItem."C.U.B.");
                                //CompItem.CALCFIELDS(CompItem.Picture);
                                ProdBOMLine[Level].Quantity := CompItemQtyBase / Item."Lot Size";
                                CostTotal := ProdBOMLine[Level].Quantity * CompItem."Unit Cost";
                            END;
                        ProdBOMLine[Level].Type::"Production BOM":
                            BEGIN
                                NextLevel := Level + 1;
                                CLEAR(ProdBOMLine[NextLevel]);
                                PBOMNoList[NextLevel] := ProdBOMLine[Level]."No.";
                                /*
                                PBOMVersionCode[NextLevel] :=
                                  VersionMgt.GetAndTestCertifiedBOMVersion(
                                    ProdBOMHeader, ProdBOMVersion, ProdBOMLine[Level]."No.", "Calc.Date", FALSE);
                                */
                                ProdBOMLine[NextLevel].SETRANGE("Production BOM No.", PBOMNoList[NextLevel]);
                                ProdBOMLine[NextLevel].SETRANGE("Version Code", PBOMVersionCode[NextLevel]);
                                ProdBOMLine[NextLevel].SETFILTER("Starting Date", '%1|..%2', 0D, "Calc.Date");
                                ProdBOMLine[NextLevel].SETFILTER("Ending Date", '%1|%2..', 0D, "Calc.Date");
                                Quantity[NextLevel] := CompItemQtyBase;
                                Level := NextLevel;
                            END;
                    END;


                    ProdCUB."Unit Cost" := 0;
                    ProdCUR."Unit Cost" := 0;


                    // ----------- CUB ----------

                    IF ProdBOMLine[Level]."No." <> '' THEN BEGIN

                        // ----------- CUB ----------
                        CLEAR(ProdCUB."Unit Cost");
                        ProdCUB.RESET();
                        ProdCUB.SETFILTER(ProdCUB."Item No.", ProdBOMLine[Level]."No.");
                        ProdCUB.SETFILTER(ProdCUB."Cost Type", 'C.U.B.');
                        ProdCUB.SETFILTER(ProdCUB."Starting Date", '%1|..%2', 0D, "Calc.Date");
                        ProdCUB.SETFILTER(ProdCUB."Ending Date", '%1|%2..', 0D, "Calc.Date");
                        //ProdCUB.FINDLAST;
                        IF NOT ProdCUB.FINDSET() THEN
                            vAlerteInformation :=
                            '( Attention ! Pas de CUB renseigné à la date de calcul saisie pour certains composants)';

                        // ----------- CUR ----------
                        CLEAR(ProdCUR."Unit Cost");
                        ProdCUR.RESET();
                        ProdCUR.SETFILTER(ProdCUR."Item No.", ProdBOMLine[Level]."No.");
                        ProdCUR.SETFILTER(ProdCUR."Cost Type", 'C.U.R.');
                        ProdCUR.SETFILTER(ProdCUR."Starting Date", '%1|..%2', 0D, "Calc.Date");
                        ProdCUR.SETFILTER(ProdCUR."Ending Date", '%1|%2..', 0D, "Calc.Date");
                        IF NOT ProdCUR.FINDSET() then;
                        // MESSAGE('  Pas de CUR défini : impossible de générer le report   ');
                    END;



                    IF BooGLUNIFORM = TRUE THEN BEGIN
                        vInformation := '';
                        DecGCostTotal += (ProdBOMLine[Level].Quantity * ProdCUB."Unit Cost");
                        IF ProdCUR."Unit Cost" <> 0 THEN BEGIN
                            DecGCostLineCUR := (ProdBOMLine[Level].Quantity * ProdCUR."Unit Cost") * vCoefMajor;
                            DecGCostTotalCUR += (ProdBOMLine[Level].Quantity * ProdCUR."Unit Cost");
                        END ELSE BEGIN
                            DecGCostTotalCUR += (ProdBOMLine[Level].Quantity * ProdCUB."Unit Cost");
                            DecGCostLineCUR := (ProdBOMLine[Level].Quantity * ProdCUB."Unit Cost") * vCoefMajor;
                            vInformation :=
                            '( Par défaut, dans Ratios, si un CUR Unitaire n est pas valorisé, c est le CUB unitaire qui sera pris en compte )';
                        END;
                    END;


                    IF BooGGoyard = TRUE THEN BEGIN
                        vInformation := '';

                        DecGCostTotal += (ProdBOMLine[Level].Quantity * ProdCUB."Unit Cost");
                        IF ProdCUR."Unit Cost" <> 0 THEN BEGIN
                            IF ProdCUR."Starting Date" < ProdCUB."Starting Date" THEN BEGIN
                                // MESSAGE('Date Cub > Date CUR : ' + ProdCUR."Item No.");
                                DecGCostTotalCUR += (ProdBOMLine[Level].Quantity * ProdCUB."Unit Cost");
                                DecGCostLineCUR := (ProdBOMLine[Level].Quantity * ProdCUB."Unit Cost") * vCoefMajor;
                            END ELSE BEGIN
                                DecGCostLineCUR := (ProdBOMLine[Level].Quantity * ProdCUR."Unit Cost") * vCoefMajor;
                                DecGCostTotalCUR += (ProdBOMLine[Level].Quantity * ProdCUR."Unit Cost");
                            END;
                        END ELSE BEGIN
                            DecGCostTotalCUR += (ProdBOMLine[Level].Quantity * ProdCUB."Unit Cost");
                            DecGCostLineCUR := (ProdBOMLine[Level].Quantity * ProdCUB."Unit Cost") * vCoefMajor;
                            vInformation :=
                            '( Par défaut, dans Ratios, si un CUR Unitaire n est pas valorisé, c est le CUB unitaire qui sera pris en compte )';
                        END;
                    END;
                end;

                trigger OnPostDataItem()
                begin
                    InBOM := FALSE;
                end;
            }
            dataitem(Footer; Integer)
            {
                DataItemTableView = SORTING(Number);
                DataItemLinkReference = "Item";
                MaxIteration = 1;

                column(Footer_DecGCostTotalMaj; DecGCostTotal * vCoefMajor)
                { }
                column(Footer_DecGCostTotalCURMaj; DecGCostTotalCUR * vCoefMajor)
                { }
                column(Footer_CostFreight; Item."Freight Cost" * vCoefMajor)
                { }
                column(Footer_DecGExworksLU; DecGExworksLU)
                { }
                column(Footer_DecGPRALU; DecGPRALU)
                { }
                column(Footer_DecGTotCostLU; DecGTotCostLU)
                { }
                column(Footer_DecGTotCostLUCUR; DecGTotCostLUCUR)
                { }
                column(Footer_DecGExworksLUCUR; DecGExworksLUCUR)
                { }
                column(Footer_DecGPRAGSH; DecGPRAGSH)
                { }
                column(Footer_DecGTQL; DecGTQL)
                { }
                column(Footer_DecGPRAGSHCUR; DecGPRAGSHCUR)
                { }
                column(Footer_DecGTQLCUR; DecGTQLCUR)
                { }
                column(Footer_vCoefExWorks; vCoefExWorks)
                { }
                column(Footer_vCoefTql; vCoefTql)
                { }
                column(Footer_DecGTotCostGSH; DecGTotCostGSH)
                { }
                column(Footer_DecGTotCostGSHCUR; DecGTotCostGSHCUR)
                { }
                column(Footer_DecGExworksGSH; DecGExworksGSH)
                { }
                column(Footer_DecGExworksGSHCUR; DecGExworksGSHCUR)
                { }
                column(Footer_vgMargeEwActifCUB; vgMargeEwActifCUB)
                { }
                column(Footer_vgMargeEwActifCUR; vgMargeEwActifCUR)
                { }
                column(Footer_vInformation; vInformation)
                { }
                column(Footer_vAlerteInformation; vAlerteInformation)
                { }
                trigger OnPreDataItem()
                begin
                    if BooGLUNIFORM then begin
                        DecGPRALU := (ProdTotalCost + DecGCostTotal) * vCoefMajor;
                        DecGTotCostLU := DecGPRALU + (DecGPRALU * (vCoefTql - 1));
                        DecGExworksLU := DecGTotCostLU * vCoefExWorks;

                        DecGPRALUCUR := (ProdTotalCost + DecGCostTotalCUR) * vCoefMajor;
                        DecGTotCostLUCUR := DecGPRALUCUR + (DecGPRALUCUR * (vCoefTql - 1));
                        DecGExworksLUCUR := DecGTotCostLUCUR * vCoefExWorks;
                    end;

                    if BooGGoyard then begin
                        DecGPRAGSH := (ProdTotalCost + DecGCostTotal) * vCoefMajor;
                        DecGTQL := DecGPRAGSH * (vCoefTql - 1);
                        DecGTotCostGSH := DecGPRAGSH + DecGTQL;
                        DecGExworksGSH := ROUND(DecGTotCostGSH * vCoefExWorks, 1);

                        DecGPRAGSHCUR := (ProdTotalCost + DecGCostTotalCUR) * vCoefMajor;
                        DecGTQLCUR := DecGPRAGSHCUR * (vCoefTql - 1);
                        DecGTotCostGSHCUR := DecGPRAGSHCUR + DecGTQLCUR;
                        DecGExworksGSHCUR := ROUND(DecGTotCostGSHCUR * vCoefExWorks, 1);

                        IF DecGTotCostGSH <> 0 THEN vgMargeEwActifCUB := VgUnitPrice / DecGTotCostGSH;
                        IF DecGTotCostGSHCUR <> 0 THEN vgMargeEwActifCUR := VgUnitPrice / DecGTotCostGSHCUR;
                    end;

                end;
            }
            dataitem("Sales Price"; "Sales Price")
            {
                DataItemTableView = SORTING("Item No.", "Sales Type", "Sales Code", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity") WHERE("Sales Code" = CONST('GOYARD ST HONORE'), "Ending Date" = FILTER(''));
                DataItemLinkReference = "Item";
                DataItemLink = "Item No." = FIELD("No.");
            }

            trigger OnPreDataItem()
            var
                ProdSalesPrice: Record "Sales Price";
            begin


                //vCoefMajor  :=0 ;
                //vCoefTql    :=0 ;
                //vCoefSouple :=1 ;
                //vCoefRigide :=1 ;
                //vCoefExWorks := 1;

                // ----------- Coef TQL ExWorks - GOYARD.
                IF BooGGoyard = TRUE THEN BEGIN
                    ProdTQL.RESET();
                    ProdTQL.SETFILTER(ProdTQL."Customer No.", 'GSH');
                    ProdTQL.SETFILTER(ProdTQL."Starting Date", '%1|..%2', 0D, "Calc.Date");
                    ProdTQL.SETFILTER(ProdTQL."Ending Date", '%1|%2..', 0D, "Calc.Date");

                    IF ProdTQL.FINDSET() THEN BEGIN
                        //ProdTQL.FINDLAST;
                        vCoefMajor := 1 + (ProdTQL.Coefmajoration / 100);
                        vCoefTql := 1 + (ProdTQL.CoefTQL / 100);
                        vCoefSouple := ProdTQL.CoefExworksSouple;
                        vCoefRigide := ProdTQL.CoefExworksRigide;
                        vCoefSoupleSpe := ProdTQL.CoefEWSoupleSpecial;
                        vCoefRigideSpe := ProdTQL.CoefEWRigideSpecial;
                    END;


                    //ALGO-DSP 20181121
                    ProdSalesPrice.RESET();
                    ProdSalesPrice.SETFILTER(ProdSalesPrice."Item No.", Item."No.");
                    ProdSalesPrice.SETFILTER(ProdSalesPrice."Sales Code", 'GOYARD MONDE');
                    ProdSalesPrice.SETFILTER(ProdSalesPrice."Starting Date", '%1|..%2', 0D, "Calc.Date");
                    ProdSalesPrice.SETFILTER(ProdSalesPrice."Ending Date", '%1|%2..', 0D, "Calc.Date");

                    IF NOT ProdSalesPrice.FINDSET() THEN
                        VgUnitPrice := 0
                    ELSE
                        VgUnitPrice := ProdSalesPrice."Unit Price";
                    //ALGO-DSP 20181121
                END;

                // ----------- Coef TQL ExWorks - LUNIFORM.

                IF BooGLUNIFORM = TRUE THEN BEGIN
                    ProdTQL.RESET();
                    ProdTQL.SETFILTER(ProdTQL."Customer No.", 'L/UNIFORM');
                    ProdTQL.SETFILTER(ProdTQL."Starting Date", '%1|..%2', 0D, "Calc.Date");
                    ProdTQL.SETFILTER(ProdTQL."Ending Date", '%1|%2..', 0D, "Calc.Date");
                    ProdTQL.FINDLAST();
                    IF ProdTQL.FINDSET() THEN BEGIN
                        //ProdTQL.FINDLAST;
                        vCoefMajor := 1 + (ProdTQL.Coefmajoration / 100);
                        vCoefTql := 1 + (ProdTQL.CoefTQL / 100);
                        vCoefSouple := ProdTQL.CoefExworksSouple;
                        vCoefRigide := ProdTQL.CoefExworksRigide;
                        vCoefSoupleSpe := ProdTQL.CoefEWSoupleSpecial;
                        vCoefRigideSpe := ProdTQL.CoefEWRigideSpecial
                    END;


                    //ALGO-DSP 20181121
                    ProdSalesPrice.RESET;
                    ProdSalesPrice.SETFILTER(ProdSalesPrice."Item No.", Item."No.");
                    ProdSalesPrice.SETFILTER(ProdSalesPrice."Sales Code", 'LUNIFORM');
                    ProdSalesPrice.SETFILTER(ProdSalesPrice."Starting Date", '%1|..%2', 0D, "Calc.Date");
                    ProdSalesPrice.SETFILTER(ProdSalesPrice."Ending Date", '%1|%2..', 0D, "Calc.Date");
                    ProdSalesPrice.SETFILTER(ProdSalesPrice."Minimum Quantity", '0.00|1.00');

                    IF NOT ProdSalesPrice.FINDSET() THEN
                        VgUnitPrice := 0
                    ELSE
                        VgUnitPrice := ProdSalesPrice."Unit Price";
                    //ALGO-DSP 20181121                    
                END;


                CASE VGChoix OF
                    VGChoix::"Souple":
                        vCoefExWorks := vCoefSouple;
                    VGChoix::"Rigide":
                        vCoefExWorks := vCoefRigide;
                    VGChoix::"Souple Commande Spéciale":
                        vCoefExWorks := vCoefSoupleSpe;
                    VGChoix::"Rigide Commande Spéciale":
                        vCoefExWorks := vCoefRigideSpe;

                END;

                Item.SETRANGE("No.", CodGItemNo);
                ItemFilter := Item.GETFILTERS();
            end;

            trigger OnAfterGetRecord()
            begin

                IF "Lot Size" = 0 THEN
                    "Lot Size" := 1;

                IF (CodGBomCode = '') AND
                   (CodGRoutingCode = '')
                THEN
                    CurrReport.SKIP();
                PBOMNoList[1] := CodGBomCode;

                IF CodGBomCode <> '' THEN
                    PBOMVersionCode[1] := CodGBomVersion;

                IF CodGRoutingCode <> '' THEN
                    RtngVersionCode := CodGRoutingVersion;

                SingleLevelMfgOvhd := Item."Single-Level Mfg. Ovhd Cost";
            end;

        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(CalcDate; "Calc.Date")
                    {
                        ApplicationArea = ALL;
                        Caption = 'Calculation Date';
                    }
                    field(PrintPhoto; BooGPicItem)
                    {
                        ApplicationArea = ALL;
                        Caption = 'Print Photo';
                    }
                    field(GoyardItem; BooGGoyard)
                    {
                        ApplicationArea = ALL;
                        Caption = 'GOYARD Item';
                    }
                    field(LuniformItem; BooGLUNIFORM)
                    {
                        ApplicationArea = ALL;
                        Caption = 'LUNIFORM Item';
                    }
                    field(Choise; VGChoix)
                    {
                        ApplicationArea = ALL;
                        Caption = 'Choise';
                    }
                    field(Item; CodGItemNo)
                    {
                        ApplicationArea = ALL;
                        Caption = 'Item';
                        TableRelation = Item;

                        trigger OnValidate()
                        begin

                            IF CodGItemNo <> '' THEN BEGIN
                                Item.GET(CodGItemNo);
                                CodGBomCode := Item."Production BOM No.";
                                CodGRoutingCode := Item."Routing No.";
                            end;
                        end;
                    }
                    field(RoutingVersion; CodGRoutingVersion)
                    {
                        ApplicationArea = ALL;
                        Caption = 'Routing Version';
                        TableRelation = "Routing Version"."Version Code";
                        trigger OnLookup(var Text: Text): Boolean
                        var
                            RecLRoutingVersion: Record "Routing Version";
                            FormLRoutingVersion: Page "Routing Version List";
                        begin

                            RecLRoutingVersion.SETRANGE("Routing No.", CodGRoutingCode);
                            IF NOT RecLRoutingVersion.FINDSET() THEN EXIT;

                            FormLRoutingVersion.SETTABLEVIEW(RecLRoutingVersion);
                            IF FormLRoutingVersion.RUNMODAL() = Action::OK THEN BEGIN
                                FormLRoutingVersion.GETRECORD(RecLRoutingVersion);
                                CodGRoutingVersion := RecLRoutingVersion."Version Code";
                                RequestOptionsPage.UPDATE();
                            END;
                        end;
                    }
                    field(BOMVersion; CodGBomVersion)
                    {
                        ApplicationArea = ALL;
                        Caption = 'BOM Version';
                        TableRelation = "Production BOM Version"."Version Code";

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            RecLBomVersion: Record "Production BOM Version";
                            FormLBOMVersion: Page "Prod. BOM Version List";
                        begin

                            RecLBomVersion.SETRANGE("Production BOM No.", CodGBomCode);
                            IF NOT RecLBomVersion.FINDSET() THEN EXIT;

                            FormLBOMVersion.SETTABLEVIEW(RecLBomVersion);
                            IF FormLBOMVersion.RUNMODAL() = ACTION::OK THEN BEGIN
                                FormLBOMVersion.GETRECORD(RecLBomVersion);
                                CodGBomVersion := RecLBomVersion."Version Code";
                                RequestOptionsPage.UPDATE();
                            END;
                        end;
                    }
                }
            }
        }
    }

    trigger OnInitReport()
    begin
        MfgSetup.GET();
    end;



    var
        ProdBOMLine: Array[99] of Record "Production BOM Line";
        MfgSetup: Record "Manufacturing Setup";
        CompItem: Record Item;
        ProdBOMHeader: Record "Production BOM Header";
        ProdBOMVersion: Record "Production BOM Version";
        RtngHeader: Record "Routing Header";
        RtngVersion: Record "Routing Version";
        ProdCUB: Record "Unit Cost Budget";
        ProdCUR: Record "Unit Cost Budget";
        ProdTQL: Record TQL;
        UOMMgt: Codeunit "Unit of Measure Management";
        CostCalcMgt: Codeunit "Cost Calculation Management";
        VersionMgt: Codeunit VersionManagement;
        RtngVersionCode: Code[10];
        ItemFilter: Text[250];
        PBOMNoList: Array[99] of Code[20];
        PBOMVersionCode: Array[99] of Code[10];
        CompItemQtyBase: Decimal;
        Quantity: Array[99] of Decimal;
        "Calc.Date": Date;
        TotalRunTime: Decimal;
        CostTotal: Decimal;
        ProdUnitCost: Decimal;
        ProdTotalCost: Decimal;
        CostTime: Decimal;
        InBOM: Boolean;
        InRouting: Boolean;
        Level: Integer;
        NextLevel: Integer;
        SingleLevelMfgOvhd: Decimal;
        DirectUnitCost: Decimal;
        IndirectCostPct: Decimal;
        OverheadRate: Decimal;
        BooGPicItem: Boolean;
        BooGPicComp: Boolean;
        BooGPictureExists: Boolean;
        DecGCostTotal: Decimal;
        DecGPri: Decimal;
        DecGPri2: Decimal;
        CoûtContrôle: Decimal;
        BooGLUNIFORM: Boolean;
        BooGGoyard: Boolean;
        DecGPRIDeux: Decimal;
        DecGTQL: Decimal;
        CodGBomCode: Code[20];
        CodGRoutingCode: Code[20];
        CodGItemNo: Code[20];
        CodGBomVersion: Code[10];
        CodGRoutingVersion: Code[10];
        DecGTotCostGSH: Decimal;
        DecGExworksGSH: Decimal;
        DecGTotCostLU: Decimal;
        DecGExworksLU: Decimal;
        DecGPRAGSH: Decimal;
        DecGCostTotalCUR: Decimal;
        DecGCostTotalCUB: Decimal;
        vCoefMajor: Decimal;
        vCoefSouple: Decimal;
        vCoefTql: Decimal;
        vCoefExWorks: Decimal;
        vCoefRigide: Decimal;
        MessagePublic: Text[30];
        DecGPRALUCUR: Decimal;
        DecGPRALU: Decimal;
        DecGTotCostLUCUR: Decimal;
        DecGExworksLUCUR: Decimal;
        DecGPRAGSHCUR: Decimal;
        DecGExworksGSHCUR: Decimal;
        DecGTotCostGSHCUR: Decimal;
        DecGTQLCUR: Decimal;
        VgUnitPrice: Decimal;
        vInformation: Text[250];
        DecGCostLineCUR: Decimal;
        VGChoix: Option "Souple","Rigide","Souple Commande Spéciale","Rigide Commande Spéciale";
        vCoefSoupleSpe: Decimal;
        vCoefRigideSpe: Decimal;
        vAlerteInformation: Text[250];
        vgMargeEwActifCUB: Decimal;
        vgMargeEwActifCUR: Decimal;
        Text000: Label 'As of';
        Text001: Label 'Pour impression COMMUNICATION, ne rien cocher dans les options suivantes. La marge de sécurité et le coût logistique sont déjà intégrés.';

}