report 50094 "PROD-Consumption follower"
{
    Caption = 'PROD-Consumption follower';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports/Rep50094.PRODConsumptionfollower.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            DataItemTableView = sorting(Status, "No.");
            RequestFilterFields = Status, "No.", "Source Type", "Source No.";

            column(CompagnyName; CompanyName())
            {
            }
            column(ProdOrder_Location_Code; "Location Code")
            {
            }
            column(ProdOrder_No_; "No.")
            {
            }
            column(ProdOrder_Status; Status)
            {

            }
            column(ProdOrder_Quantity; Quantity)
            {
            }

            dataitem("Prod. Order Line"; "Prod. Order Line")
            {
                DataItemTableView = SORTING(Status, "Prod. Order No.", "Line No.");
                DataItemLinkReference = "Production Order";
                DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("No.");
                RequestFilterFields = "Line No.", "Item No.";

                column(TxtCentreCharge; TxtCentreCharge)
                {
                }
                column(ProdOrderLine_Line_No_; "Line No.")
                {
                }
                column(ProdOrderLine_Item_No_; "Item No.")
                {
                }
                column(ProdOrderLine_Description; Description)
                {
                }
                column(ProdOrderLine_Description_2; "Description 2")
                {
                }
                column(ProdOrderLine_Quantity; Quantity)
                {
                }
                column(ProdOrderLine_Routing_No_; "Routing No.")
                {
                }
                column(ProdOrderLine_Routing_Version_Code; "Routing Version Code")
                {
                }
                column(ProdOrderLine_Production_BOM_No_; "Production BOM No.")
                {
                }
                column(ProdOrderLine_Production_BOM_Version_Code; "Production BOM Version Code")
                {
                }
                column(ProdOrderLine_Remaining_Quantity; "Remaining Quantity")
                {
                }
                column(Picture; MediaMgt.GetItemPictureToBase64String(RecGItem))
                {
                }

                dataitem("Prod. Order Component"; "Prod. Order Component")
                {
                    DataItemTableView = SORTING("Item No.", "Variant Code", "Location Code", Status, "Due Date") ORDER(Ascending) WHERE("Routing Link Code" = FILTER(<> ''));
                    DataItemLinkReference = "Prod. Order Line";
                    DataItemLink = "Prod. Order No." = FIELD("Prod. Order No."), "Prod. Order Line No." = FIELD("Line No.");
                    RequestFilterFields = "Location Code";

                    column(ProdOrderComp_Prod__Order_No_; "Prod. Order No.")
                    {
                    }
                    column(ProdOrderComp_Item_No_; "Item No.")
                    {
                    }
                    column(ProdOrderComp_Description; Description)
                    {
                    }
                    column(ProdOrderComp_Unit_of_Measure_Code; "Unit of Measure Code")
                    {
                    }
                    column(ProdOrderComp_Quantity_per; "Quantity per")
                    {
                    }
                    column(ProdOrderComp_Expected_Quantity; "Expected Quantity")
                    {
                    }
                    column(ProdOrderComp_Remaining_Quantity; "Remaining Quantity")
                    {
                    }

                    trigger OnPreDataItem()
                    begin
                        "Prod. Order Component".SETRANGE("Prod. Order Component"."Prod. Order No.", RecGProdNum);
                    end;

                    trigger OnAfterGetRecord()
                    begin
                        RecGItem2.GET("Prod. Order Component"."Item No.");
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    RecGProdNum := "Prod. Order Line"."Prod. Order No.";
                    TxtGItem := "Prod. Order Line"."Item No." + ' : ' + "Prod. Order Line".Description;
                    CdeGItem := "Prod. Order Line"."Item No.";
                    IntGQuantity := "Prod. Order Line".Quantity;
                    CdeGVersion := "Prod. Order Line"."Production BOM Version Code";
                    CdeGCodeUnity := "Prod. Order Line"."Unit of Measure Code";

                    RecGItem.RESET();
                    RecGRoutingHeader.RESET();
                    RecGVendor.RESET();
                    DecGQteTotal := "Prod. Order Line".Quantity;

                    IF RecGItem.GET("Prod. Order Line"."Item No.") THEN;
                    IF RecGRoutingHeader.GET("Prod. Order Line"."Routing No.") THEN
                        TxtRGRoutingHeaderDescp := "Prod. Order Line"."Routing No." + ':' + RecGRoutingHeader.Description;

                    RecGProdRoutingLine.RESET();
                    RecGProdRoutingLine.SETRANGE(RecGProdRoutingLine.Status, "Prod. Order Line".Status);
                    RecGProdRoutingLine.SETRANGE(RecGProdRoutingLine."Prod. Order No.", "Prod. Order Line"."Prod. Order No.");
                    RecGProdRoutingLine.SETRANGE(RecGProdRoutingLine."Routing No.", "Prod. Order Line"."Routing No.");

                    IF RecGProdRoutingLine.FIND('-') THEN
                        TxtCentreCharge := RecGProdRoutingLine."No."
                    ELSE
                        TxtCentreCharge := '';
                end;

                trigger OnPostDataItem()
                begin
                    BlnGViewHeader := FALSE;
                end;

            }
            trigger OnPreDataItem()
            begin

                CodGNumFrs := '';
                TxtGNameFrs := '';
            end;

            trigger OnAfterGetRecord()
            var
                RecLProdOrderComponent: Record "Prod. Order Component";
            begin
                RecLProdOrderComponent.RESET();
                RecLProdOrderComponent.SETRANGE(Status, Status);
                RecLProdOrderComponent.SETRANGE("Prod. Order No.", "No.");
                RecLProdOrderComponent.SETFILTER("Location Code", "Prod. Order Component".GETFILTER("Location Code"));
                IF RecLProdOrderComponent.COUNT() = 0 THEN
                    CurrReport.SKIP();
            end;
        }
    }
    trigger OnInitReport()
    begin

        OptGItemPicture := TRUE;
        BlnGNewOrderNum := FALSE;
        CdeGOldOrderNum := '-1';
    end;

    var
        MediaMgt: Codeunit "Media Mgt.";
        ProdOrderFilter: Text[250];
        InComponent: Boolean;
        RecGItem: Record Item;
        RecGWorkCenter: Record "Work Center";
        RecGVendor: Record Vendor;
        RecGtemJournalLine: Record "Item Journal Line";
        DecGQteTotal: Decimal;
        RecGRoutingHeader: Record "Routing Header";
        CodGNumFrs: Code[20];
        TxtGNameFrs: Text[30];
        OptGItemPicture: Boolean;
        BlnGViewHeader: Boolean;
        TxtGItem: Text[250];
        CdeGItem: Code[20];
        IntGQuantity: Integer;
        CdeGCodeUnity: Code[20];
        TxtRGRoutingHeaderDescp: Text[72];
        CdeGVersion: Code[20];
        BlnGNewOrderNum: Boolean;
        CdeGOldOrderNum: Code[10];
        RecGOldOrderNum: Code[20];
        RecGNewOrderNum: Code[20];
        RecGProdNum: Code[20];
        BooGComponment: Boolean;
        RecGItem2: Record Item;
        RecGProdRoutingLine: Record "Prod. Order Routing Line";
        TxtCentreCharge: Text[30];
}