report 50091 "HA-Needs Materials/Wharehouse"
{
    Caption = 'Inventory needs';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports/Rep50091.HANeedsMaterialsWharehouse.rdl';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Search Description", "Inventory Posting Group", "Location Filter", "Bin Filter", "Shelf No.";
            CalcFields = "Qty. on Purch. Order";
            // ALGO du 20190916
            PrintOnlyIfDetail = true;

            column(CompanyName; CompanyName())
            {
            }
            column(No_; "No.")
            {
            }
            column(ItemFilter; Item.TABLECAPTION() + ': ' + ItemFilter)
            {
            }
            column(ComponentFilter; STRSUBSTNO(Text000, ComponentFilter))
            {
            }
            column(Qty__on_Component_Lines; "Qty. on Component Lines")
            {
            }
            column(Qty__on_Purch__Order; "Qty. on Purch. Order")
            {
            }
            column(Qty__on_Prod__Order; "Qty. on Prod. Order")
            {
            }
            column(Inventory; Inventory)
            {
            }
            column(Prod__Forecast_Quantity__Base_; "Prod. Forecast Quantity (Base)")
            {
            }

            dataitem("Prod. Order Component"; "Prod. Order Component")
            {
                DataItemTableView = SORTING("Item No.", "Prod. Order No.", "Variant Code", "Location Code", Status, "Due Date");
                DataItemLinkReference = Item;
                DataItemLink = "Item No." = FIELD("No."), "Variant Code" = FIELD("Variant Filter"), "Location Code" = FIELD("Location Filter"), "Bin Code" = FIELD("Bin Filter");
                RequestFilterFields = Status, "Due Date", "Prod. Order No.", "Location Code";
                // ALGO du 20190916
                PrintOnlyIfDetail = false;

                column(Item_No_; "Item No.")
                {
                }
                column(Prod__Order_No_; "Prod. Order No.")
                {
                }
                column(Unit_of_Measure_Code; "Unit of Measure Code")
                {
                }
                column(Remaining_Quantity; "Remaining Quantity")
                {
                }
                column(Location_Code; "Location Code")
                {
                }
                column(DecGTotStockLANNOLIER; DecGTotStockLANNOLIER)
                {
                }
                column(DecGTotStockRECEPTION; DecGTotStockRECEPTION)
                {
                }
                column(DecGStockST; DecGStockST)
                {
                }
                column(DecGRemainST; DecGRemainST)
                {
                }

                trigger OnPreDataItem()
                begin
                    SETFILTER("Remaining Quantity", '<>0');
                end;

                trigger OnAfterGetRecord()
                begin

                    DecGTotStockST := 0;
                    DecGTotRemainST := 0;

                    IF Status = Status::Finished THEN
                        CurrReport.SKIP();

                    IF RecGItem.GET("Prod. Order Component"."Item No.") THEN BEGIN
                        RecGItem.SETFILTER("Location Filter", "Prod. Order Component"."Location Code");
                        RecGItem.CALCFIELDS(Inventory, "Qty. on Component Lines");
                        DecGStockST := RecGItem.Inventory;
                        DecGRemainST := RecGItem."Qty. on Component Lines";
                        IF "Prod. Order Component"."Location Code" <> 'LANNOLIER1' THEN    // (06/11/2017 )
                            DecGTotStockST := DecGTotStockST + DecGStockST;
                        DecGTotRemainST := DecGTotRemainST + DecGRemainST;
                    END;

                    ProdOrder.GET(Status, "Prod. Order No.");

                    IF RecGItem.GET("Prod. Order Component"."Item No.") THEN BEGIN
                        RecGItem.SETFILTER("Location Filter", 'LANNOLIER1');
                        RecGItem.CALCFIELDS(Inventory);
                        DecGTotQtyPurchOrder := RecGItem."Qty. on Purch. Order";
                        DecGTotStockLANNOLIER := RecGItem.Inventory;
                    END;

                    IF RecGItem.GET("Prod. Order Component"."Item No.") THEN BEGIN
                        RecGItem.SETFILTER("Location Filter", 'RCT-CONT|CONTROLE');
                        RecGItem.CALCFIELDS(Inventory);
                        DecGTotQtyPurchOrder := RecGItem."Qty. on Purch. Order";
                        DecGTotStockRECEPTION := RecGItem.Inventory;
                    END;
                end;
            }
            trigger OnAfterGetRecord()
            begin

                DecGTotStockST := 0;
                DecGTotStockLANNOLIER := 0;
                DecGStockST := 0;
                DecGRemainST := 0;
                DecGTotRemainST := 0;
                DecGTotStockRECEPTION := 0;
            end;

        }
    }
    trigger OnPreReport()
    begin

        ItemFilter := Item.GETFILTERS();
        ComponentFilter := "Prod. Order Component".GETFILTERS();
    end;

    var
        ProdOrder: Record "Production Order";
        RecGItem: Record Item;
        ItemFilter: Text[250];
        ComponentFilter: Text[250];
        DecGTotStockST: Decimal;
        DecGTotStockLANNOLIER: Decimal;
        DecGTotStockRECEPTION: Decimal;
        DecGStockST: Decimal;
        DecGTotQtyPurchOrder: Decimal;
        DecGRemainST: Decimal;
        DecGTotRemainST: Decimal;
        Text000: Label 'Component Need : %1.';
}