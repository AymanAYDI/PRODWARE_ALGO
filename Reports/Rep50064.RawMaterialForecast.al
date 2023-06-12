report 50064 "Raw Material Forecast"
{
    Caption = 'Prévisions MP', Locked = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports/Rep50064.RawMaterialForecast.rdl';

    dataset
    {
        dataitem("Production Forecast Entry"; "Production Forecast Entry")
        {
            DataItemTableView = SORTING("Production Forecast Name", "Item No.", "Component Forecast", "Forecast Date", "Location Code");
            RequestFilterFields = "Production Forecast Name", "Item No.", "Forecast Date", "Location Code";

            column(IntGDisplayDetail; IntGDisplayDetail)
            {
            }
            column(TxtGLocationFilter1; TxtGLocationFilter1)
            {
            }
            column(TxtGLocationFilter2; TxtGLocationFilter2)
            {
            }
            column(TxtGLocationFilter3; TxtGLocationFilter3)
            {
            }
            column(TxtGLocationFilter4; TxtGLocationFilter4)
            {
            }
            column(Item_No_; "Item No.")
            {
            }
            column(Forecast_Date; "Forecast Date")
            {
            }
            column(Forecast_Quantity; "Forecast Quantity")
            {
            }
            dataitem(Item; Item)
            {
                DataItemTableView = sorting("No.");
                DataItemLinkReference = "Production Forecast Entry";
                DataItemLink = "No." = FIELD("Item No.");

                dataitem("Production BOM Header"; "Production BOM Header")
                {
                    DataItemTableView = sorting("No.");
                    DataItemLinkReference = "Item";
                    DataItemLink = "No." = FIELD("Production BOM No.");
                    dataitem("Production BOM Line"; "Production BOM Line")
                    {
                        DataItemTableView = SORTING("Production BOM No.", "Version Code", "Line No.") ORDER(Ascending) WHERE("Type" = CONST("Item"));
                        DataItemLinkReference = "Production BOM Header";
                        DataItemLink = "Production BOM No." = FIELD("No.");
                        RequestFilterFields = "No.";

                        column(DecGInventory1; DecGInventory1)
                        {
                        }
                        column(DecGInventory2; DecGInventory2)
                        {
                        }
                        column(DecGInventory3; DecGInventory3)
                        {
                        }
                        column(DecGInventory4; DecGInventory4)
                        {
                        }
                        column(DecGPurchase; DecGPurchase)
                        {
                        }
                        column(DecGTransferLine; DecGTransferLine)
                        {
                        }
                        column(DecGSalesLine; DecGSalesLine)
                        {
                        }
                        column(No_; "No.")
                        {
                        }
                        column(Line_No_; "Line No.")
                        {
                        }
                        column(Quantity; Quantity)
                        {
                        }
                        column(Unit_of_Measure_Code; "Unit of Measure Code")
                        {
                        }
                        column(quantity_mp_par; Quantity)
                        {
                        }
                        column(quantity_mp; Quantity * "Production Forecast Entry"."Forecast Quantity")
                        {
                        }
                        column(VersionCode; VersionCode)
                        {
                        }
                        column(DecGPOCQU4; DecGPOCQU4)
                        {
                        }
                        column(DecGPOCQU3; DecGPOCQU3)
                        {
                        }
                        column(DecCub; DecCub)
                        {
                        }
                        column(DecCur; DecCur)
                        {
                        }
                        column(decUnitPrice; decUnitPrice)
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            // REPRISE MODIF PRE MIGRATION ALGO_20190327 appliquee le 20200303
                            // VersionCode := VersionMgt.GetBOMVersion("Production BOM Header"."No.", WORKDATE, TRUE);
                            // SETRANGE("Version Code", VersionCode);

                            "Production BOM Line".SETFILTER("Production BOM Line"."Version Code", '%1', '');
                            // REPRISE MODIF PRE MIGRATION ALGO_20190327 appliquee le 20200303
                        end;

                        trigger OnAfterGetRecord()
                        begin

                            CLEAR(DecGInventory1);
                            CLEAR(DecGInventory2);
                            CLEAR(DecGInventory3);
                            CLEAR(DecGInventory4);
                            CLEAR(DecGPOCQU4);
                            CLEAR(DecGPurchase);
                            CLEAR(DecGTransferLine);
                            CLEAR(DecGSalesLine);


                            //prise en compte de la date de fin de la nomenclature.
                            IF "Ending Date" <> 0D THEN
                                //date de fin inférieur à date de prévision
                                IF "Ending Date" <= "Production Forecast Entry"."Forecast Date" THEN
                                    CurrReport.SKIP();

                            //prise en compte de la date de début de la nomenclature.
                            IF "Starting Date" <> 0D THEN
                                //date de fin inférieur à date de prévision
                                IF "Starting Date" >= "Production Forecast Entry"."Forecast Date" THEN
                                    CurrReport.SKIP();


                            //info Article composant Données pour le STOCK 1 **********************************
                            RecGItem.RESET();
                            RecGItem.GET("No.");
                            RecGItem.SETFILTER("Location Filter", TxtGLocationFilter1);
                            //RecGItem.SETFILTER("Date Filter","Production Forecast Entry".GETFILTER("Forecast Date"));
                            RecGItem.CALCFIELDS(Inventory, "Qty. on Purch. Order", "Qty on Transfer Line", "Qty. on Sales Order", "Qty. on Prod. Order");

                            decUnitPrice := RecGItem."Unit Cost";

                            DecGInventory1 := RecGItem.Inventory;

                            DecCub := 0;
                            DecCur := 0;
                            // Ajout Cub / Cur
                            RecBudgetCost.SETFILTER("Item No.", RecGItem."No.");
                            RecBudgetCost.SETFILTER("Cost Type", 'C.U.B.');
                            RecBudgetCost.SETFILTER("Starting Date", '%1|<=%2', 0D, WORKDATE());
                            RecBudgetCost.SETFILTER("Ending Date", '%1|>=%2', 0D, WORKDATE());
                            if RecBudgetCost.FindSet() then
                                DecCub := RecBudgetCost."Unit Cost";

                            RecBudgetCost2.SETFILTER("Item No.", RecGItem."No.");
                            RecBudgetCost2.SETFILTER("Cost Type", 'C.U.R.');
                            RecBudgetCost2.SETFILTER("Starting Date", '%1|<=%2', 0D, WORKDATE());
                            RecBudgetCost2.SETFILTER("Ending Date", '%1|>=%2', 0D, WORKDATE());
                            if RecBudgetCost2.FindSet() then
                                DecCur := RecBudgetCost2."Unit Cost";

                            /*
                            Ajout d'une boucle dans la table Purchase Line pour calculer la qte sur ca pour les lignes sans n° d'OF
                            */
                            RecGPurchaseLine.Reset();
                            RecGPurchaseLine.SETFILTER(RecGPurchaseLine."Document Type", '=%1', RecGPurchaseLine."Document Type"::Order);
                            RecGPurchaseLine.SETFILTER(RecGPurchaseLine.Type, '=%1', RecGPurchaseLine.Type::Item);
                            RecGPurchaseLine.SETFILTER(RecGPurchaseLine."No.", '=%1', Recgitem."No.");
                            RecGPurchaseLine.SETFILTER(RecGPurchaseLine."Order No.", '=%1', '');
                            RecGPurchaseLine.SETFILTER(RecGPurchaseLine."Outstanding Quantity", '<>%1', 0);
                            DecQtyPurchLineWOF := 0;
                            if "RecGPurchaseLine".FindSet() then
                                repeat
                                    DecQtyPurchLineWOF += RecGPurchaseLine."Outstanding Qty. (Base)"

                                until ("RecGPurchaseLine".Next()) = 0;


                            // DecGPurchase := RecGItem."Qty. on Purch. Order" + RecGItem."Qty. on Prod. Order"; --> KO car Qte sur CA intégre aussi les Qte sur OF
                            // DecGPurchase := RecGItem."Qty. on Purch. Order" + RecGItem."Qty. on Prod. Order";
                            DecGPurchase := DecQtyPurchLineWOF + RecGItem."Qty. on Prod. Order";
                            DecGTransferLine := RecGItem."Qty on Transfer Line";
                            DecGSalesLine := RecGItem."Qty. on Sales Order";


                            // Données pour le STOCK 2 ******************************************************************

                            RecGItem.RESET();
                            RecGItem.GET("No.");
                            RecGItem.SETFILTER("Location Filter", TxtGLocationFilter2);

                            //RecGItem.SETFILTER("Date Filter","Production Forecast Entry".GETFILTER("Forecast Date"));
                            RecGItem.CALCFIELDS(Inventory, "Qty. on Purch. Order", "Qty on Transfer Line", "Qty. on Sales Order", "Qty. on Prod. Order");
                            DecGInventory2 := RecGItem.Inventory;
                            // DecGPurchase += RecGItem."Qty. on Purch. Order" + RecGItem."Qty. on Prod. Order";
                            // DecGTransferLine += RecGItem."Qty on Transfer Line";
                            // DecGSalesLine += RecGItem."Qty. on Sales Order";

                            // Données pour le STOCK 3 ******************************************************************

                            RecGItem2.RESET();
                            RecGItem2.GET("No.");
                            RecGItem2.SETFILTER("Location Filter", TxtGLocationFilter3);
                            //RecGItem.SETFILTER("Date Filter","Production Forecast Entry".GETFILTER("Forecast Date"));
                            RecGItem2.CALCFIELDS(Inventory, "Qty. on Purch. Order", "Qty on Transfer Line", "Qty. on Sales Order",
                                                "Qty. on Prod. Order", "Qty. on Component Lines");

                            DecGInventory3 := RecGItem2.Inventory;
                            DecGPOCQU3 := RecGItem2."Qty. on Component Lines";

                            // Données pour le STOCK 4 ******************************************************************

                            RecGItem4.RESET();
                            RecGItem4.GET("No.");
                            RecGItem4.SETFILTER("Location Filter", TxtGLocationFilter4);
                            //RecGItem.SETFILTER("Date Filter","Production Forecast Entry".GETFILTER("Forecast Date"));
                            RecGItem4.CALCFIELDS(Inventory,
                                                "Qty. on Purch. Order",
                                                "Qty on Transfer Line",
                                                "Qty. on Sales Order",
                                                "Qty. on Prod. Order",
                                                "Qty. on Component Lines");

                            DecGInventory4 := RecGItem4.Inventory;
                            DecGPOCQU4 := RecGItem4."Qty. on Component Lines";

                        end;

                    }
                }
            }
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
                    Caption = 'Options', Locked = true;
                    field(TxtGLocationFilter1; TxtGLocationFilter1)
                    {
                        Caption = 'Filtre 1 Magasin Stock/Achat', Locked = true;
                        TableRelation = Location;
                    }
                    field(TxtGLocationFilter2; TxtGLocationFilter2)
                    {
                        Caption = 'Filtre 2 Magasin Stock/Achat', Locked = true;
                        TableRelation = Location;
                    }
                    field(TxtGLocationFilter3; TxtGLocationFilter3)
                    {
                        Caption = 'Filtre 3 Magasin Stock/Achat', Locked = true;
                        // Ajout DSP - 20200316 - permette la saisie via une liste
                        TableRelation = Location;
                    }
                    field(TxtGLocationFilter4; TxtGLocationFilter4)
                    {
                        Caption = 'Filtre 4 Magasin Stock/Achat', Locked = true;
                        // Ajout DSP - 20200316 - permette la saisie via une liste
                        TableRelation = Location;
                    }
                    field(OptGDisplayDetail; OptGDisplayDetail)
                    {
                        Caption = 'Afficher le détail', Locked = true;
                        trigger OnValidate()
                        begin
                            IntGDisplayDetail := OptGDisplayDetail;
                        end;
                    }
                }
            }
        }
        // Ajout DSP - 20200316 - Force ces variables à une valeur par defaut
        trigger OnOpenPage();
        begin
            OptGDisplayDetail := 0;
            TxtGLocationFilter1 := 'LANNOLIER1';
            TxtGLocationFilter2 := 'RCT-CONT';
            TxtGLocationFilter3 := 'RIGIDE';
            TxtGLocationFilter4 := 'ART ET TRA';
            // Message('Details à NON par defaut')
        end;
        // Ajout DSP - 20200316
    }

    trigger OnInitReport()
    begin
        TxtGLocationFilter1 := 'LANNOLIER1';
        TxtGLocationFilter2 := 'RCT-CONT';
        TxtGLocationFilter3 := 'RIGIDE';
        TxtGLocationFilter4 := 'ART ET TRA';
    end;


    var
        RecGItem: Record Item;
        RecGItem2: Record Item;
        RecGItem4: Record Item;
        RecGPurchaseLine: record "Purchase Line";
        RecProdOrderCompo: Record "Prod. Order Component";
        RecBudgetCost: Record "Unit Cost Budget";
        RecBudgetCost2: Record "Unit Cost Budget";
        VersionMgt: Codeunit VersionManagement;
        VersionCode: Code[20];
        TxtGLocationFilter1: Text[50];
        TxtGLocationFilter2: Text[50];
        TxtGLocationFilter3: Text[50];
        TxtGLocationFilter4: Text[30];
        OptGDisplayDetail: Option Non,Oui;
        IntGDisplayDetail: Integer;
        DecGInventory1: Decimal;
        DecGInventory2: Decimal;
        DecGInventory3: Decimal;
        DecGInventory4: Decimal;
        DecGPurchase: Decimal;
        DatGEndingDate: Date;
        DecGTransferLine: Decimal;
        DecGSalesLine: Decimal;
        DecQtyPurchLineWOF: decimal;
        DecGPOCQU4: Decimal;
        DecGPOCQU3: Decimal;
        DecCub: Decimal;
        DecCur: Decimal;
        decUnitPrice: Decimal;
}