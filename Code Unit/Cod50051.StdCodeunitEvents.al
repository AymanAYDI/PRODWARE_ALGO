codeunit 50051 "Std Codeunit Events"
{
    SingleInstance = true;

    //*****************************
    //Item Jnl.-Post Line Events
    //*****************************

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', true, true)]
    local procedure OnAfterInitItemLedgEntry(VAR NewItemLedgEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; VAR ItemLedgEntryNo: Integer)
    begin
        NewItemLedgEntry."Tracking No." := ItemJournalLine."Tracking No.";
    end;

    //*****************************
    //Sales-Post Events
    //*****************************
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostLines', '', true, true)]
    local procedure OnBeforePostLines(VAR SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean)
    begin
        if SalesHeader.Invoice then
            SalesLine.SetRange(PROFORMA, false);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterSalesShptLineInsert', '', true, true)]
    local procedure "Sales-Post_OnAfterSalesShptLineInsert"
    (
        var SalesShipmentLine: Record "Sales Shipment Line";
        SalesLine: Record "Sales Line";
        ItemShptLedEntryNo: Integer;
        WhseShip: Boolean;
        WhseReceive: Boolean;
        CommitIsSuppressed: Boolean
    )
    var
        RecLPostedPackingLine: Record "Posted Packing Line ALGO";
    begin
        RecLPostedPackingLine.Setrange("Source No.", SalesShipmentLine."Order No.");
        RecLPostedPackingLine.SetRange("Source Line No.", SalesShipmentLine."Order Line No.");
        RecLPostedPackingLine.SetRange("Sales Shipment No.", '');
        if RecLPostedPackingLine.FindLast() then begin
            RecLPostedPackingLine."Sales Shipment No." := SalesShipmentLine."Document No.";
            RecLPostedPackingLine."Sales Shipment Line No." := SalesShipmentLine."Line No.";
            RecLPostedPackingLine.Modify();
        end;

    end;



    //    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesLines', '', true, true)]
    //    local procedure "Sales-Post_OnAfterPostSalesLines"
    //    (
    //       var SalesHeader: Record "Sales Header";
    //       var SalesShipmentHeader: Record "Sales Shipment Header";
    //       var SalesInvoiceHeader: Record "Sales Invoice Header";
    //        var SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    //        var ReturnReceiptHeader: Record "Return Receipt Header";
    //        WhseShip: Boolean;
    //        WhseReceive: Boolean;
    //        var SalesLinesProcessed: Boolean;
    //        CommitIsSuppressed: Boolean
    //    )
    //    var
    //        CuExportPackingList: Codeunit "Export Packing List";
    //    begin
    //       if WhseShip then
    //            CuExportPackingList.Export(SalesShipmentHeader);
    //    end;


    //*****************************
    //Sales-Post (Yes/No) Events
    //*****************************
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post (Yes/No)", 'OnAfterConfirmPost', '', true, true)]
    local procedure OnAfterConfirmPost(SalesHeader: Record "Sales Header")
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then
            SalesHeader.TestField(PROFORMA, false);
    end;

    //*****************************
    //Sales-Post + Print Events
    //*****************************
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post + Print", 'OnAfterConfirmPost', '', true, true)]
    local procedure OnAfterConfirmPost2(SalesHeader: Record "Sales Header")
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Order then
            SalesHeader.TestField(PROFORMA, false);
    end;

    //*****************************
    //Purch.-Post Events
    //*****************************
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterReturnShptLineInsert', '', true, true)]
    local procedure "Purch.-Post_OnAfterReturnShptLineInsert"
    (
        var ReturnShptLine: Record "Return Shipment Line";
        ReturnShptHeader: Record "Return Shipment Header";
        PurchLine: Record "Purchase Line";
        ItemLedgShptEntryNo: Integer;
        WhseShip: Boolean;
        WhseReceive: Boolean;
        CommitIsSupressed: Boolean;
        var TempWhseShptHeader: Record "Warehouse Shipment Header"
    )
    var
        RecLPostedPackingLine: Record "Posted Packing Line ALGO";
    begin
        //A tester pour l'expédition retour et le packing.
        RecLPostedPackingLine.Setrange("Source No.", PurchLine."Order No.");
        RecLPostedPackingLine.SetRange("Source Line No.", PurchLine."Order Line No.");
        RecLPostedPackingLine.SetRange("Sales Shipment No.", '');
        if RecLPostedPackingLine.FindLast() then begin
            RecLPostedPackingLine."Sales Shipment No." := ReturnShptLine."Document No.";
            RecLPostedPackingLine."Sales Shipment Line No." := ReturnShptLine."Line No.";
            RecLPostedPackingLine.Modify();
        end;
    end;

    //*****************************
    //Whse.-Post Shipment Events
    //*****************************
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnBeforePostedWhseShptHeaderInsert', '', true, true)]
    local procedure OnBeforePostedWhseShptHeaderInsert(VAR PostedWhseShipmentHeader: Record "Posted Whse. Shipment Header"; WarehouseShipmentHeader: Record "Warehouse Shipment Header")
    var
        RecLPackingHeaderAlgo: Record "Packing Header ALGO";
        RecLLinkPackingShip: Record "Link Packing/Sales Ship.";
        RecLPostedPackingHeader: Record "Posted Packing Header ALGO";
        RecLWhsShipmentLine: Record "Warehouse Shipment Line";
        RecLTransShpHeader: Record "Transfer Shipment Header";
        RecLSalesShipHeader: Record "Sales Shipment Header";
        RecLReturnShpHeader: Record "Return Shipment Header";
        CodSourceNo: Code[20];
        CodSalesShipmentNo: code[20];
    begin

        RecLPackingHeaderAlgo.SETRANGE("Warehouse Shipment No.", WarehouseShipmentHeader."No.");
        IF RecLPackingHeaderAlgo.FINDFIRST() THEN BEGIN

            //get first line for source No.
            RecLWhsShipmentLine.SetRange("No.", WarehouseShipmentHeader."No.");
            if RecLWhsShipmentLine.FindFirst() then
                CodSourceNo := RecLWhsShipmentLine."Source No.";

            //transfer
            if RecLWhsShipmentLine."Source Document" = RecLWhsShipmentLine."Source Document"::"Outbound Transfer" then begin
                RecLTransShpHeader.SETRANGE("Transfer Order No.", CodSourceNo);
                if RecLTransShpHeader.FindLast() then
                    CodSalesShipmentNo := RecLTransShpHeader."No.";
            end;

            //sales
            if RecLWhsShipmentLine."Source Document" = RecLWhsShipmentLine."Source Document"::"Sales Order" then begin
                RecLSalesShipHeader.SETRANGE("Order No.", CodSourceNo);
                if RecLSalesShipHeader.FindLast() then
                    CodSalesShipmentNo := RecLSalesShipHeader."No.";
            end;

            //purchase
            if RecLWhsShipmentLine."Source Document" = RecLWhsShipmentLine."Source Document"::"Purchase Return Order" then begin
                RecLReturnShpHeader.SETRANGE("Return Order No.", CodSourceNo);
                if RecLReturnShpHeader.FindLast() then
                    CodSalesShipmentNo := RecLReturnShpHeader."No.";
            end;

            //Insert Link Packing Ship
            RecLLinkPackingShip.INIT();
            RecLLinkPackingShip."Packing header No." := RecLPackingHeaderAlgo."No.";
            RecLLinkPackingShip."Source No." := CodSourceNo;
            RecLLinkPackingShip."Sales Shipment No." := CodSalesShipmentNo;
            RecLLinkPackingShip."Whse. Shipment No." := WarehouseShipmentHeader."No.";
            RecLLinkPackingShip."Whse.Posted Shipment No." := PostedWhseShipmentHeader."No.";
            RecLLinkPackingShip.INSERT();

            //Insert Post Packing Header
            RecLPostedPackingHeader.INIT();
            RecLPostedPackingHeader.TRANSFERFIELDS(RecLPackingHeaderAlgo);
            RecLPostedPackingHeader.INSERT();
            RecLPackingHeaderAlgo.DELETE();
        END;

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnAfterPostWhseJnlLine', '', true, true)]
    local procedure "Whse.-Post Shipment_OnAfterPostWhseJnlLine"(var WarehouseShipmentLine: Record "Warehouse Shipment Line")
    var
        RecLPackingLineAlgo: Record "Packing Line ALGO";
        RecLPostedPackingLine: Record "Posted Packing Line ALGO";
        PostedWhseShptLine: Record "Posted Whse. Shipment Line";
    begin
        PostedWhseShptLine.SetRange("Whse. Shipment No.", WarehouseShipmentLine."No.");
        PostedWhseShptLine.SetRange("Whse Shipment Line No.", WarehouseShipmentLine."Line No.");
        if PostedWhseShptLine.FindFirst() then;

        //>>ALG2.01
        RecLPackingLineAlgo.RESET();
        RecLPackingLineAlgo.SETRANGE("Shipment Document No.", WarehouseShipmentLine."No.");
        RecLPackingLineAlgo.SETRANGE("Shipment Line No.", WarehouseShipmentLine."Line No.");
        IF NOT RecLPackingLineAlgo.ISEMPTY() THEN BEGIN
            RecLPackingLineAlgo.FINDSET();
            REPEAT
                RecLPostedPackingLine.INIT();
                RecLPostedPackingLine.TRANSFERFIELDS(RecLPackingLineAlgo);
                RecLPostedPackingLine."Source No." := WarehouseShipmentLine."Source No.";
                RecLPostedPackingLine."Source Line No." := WarehouseShipmentLine."Source Line No.";
                //Transfer Shipment line not created.
                //Sales Shipement not created
                //                RecLPostedPackingLine."Sales Shipment No." := TransShptLine."Document No.";
                //                RecLPostedPackingLine."Sales Shipment Line No." := TransShptLine."Line No.";
                RecLPostedPackingLine."Whse.Posted Shipment No." := PostedWhseShptLine."No.";
                RecLPostedPackingLine."Whse.Posted Shipment Line No." := PostedWhseShptLine."Line No.";
                RecLPostedPackingLine.INSERT();
                RecLPackingLineAlgo.DELETE();
            UNTIL RecLPackingLineAlgo.NEXT() = 0;
        END;
        //<<ALG2.01
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Whse.-Post Shipment", 'OnAfterPostUpdateWhseShptLine', '', true, true)]
    local procedure DeleteWhseShpLineAfterPost(var WarehouseShipmentLine: record "Warehouse Shipment Line");
    var
    begin
        WarehouseShipmentLine.Delete(false);
    end;


    //*****************************
    //TransferOrder-Post Shipment Events
    //*****************************

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnAfterInsertTransShptLine', '', true, true)]
    local procedure "TransferOrder-Post Shipment_OnAfterInsertTransShptLine"
    (
        var TransShptLine: Record "Transfer Shipment Line";
        TransLine: Record "Transfer Line";
        CommitIsSuppressed: Boolean
    )
    var
        RecLPostedPackingLine: Record "Posted Packing Line ALGO";
    begin
        //modify the posted shipment document
        RecLPostedPackingLine.Setrange("Source No.", TransShptLine."Transfer Order No.");
        RecLPostedPackingLine.SetRange("Source Line No.", TransShptLine."Line No.");
        RecLPostedPackingLine.SetRange("Sales Shipment No.", '');
        if RecLPostedPackingLine.FindLast() then begin
            RecLPostedPackingLine."Sales Shipment No." := TransShptLine."Document No.";
            RecLPostedPackingLine."Sales Shipment Line No." := TransShptLine."Line No.";
            RecLPostedPackingLine.Modify();
        end;
    end;

    //*****************************
    //Whse.-Post Receipt Events
    //*****************************

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnBeforePostUpdateWhseRcptLine', '', true, true)]
    local procedure "Whse.-Post Receipt_OnBeforePostUpdateWhseRcptLine"
    (
        var WarehouseReceiptLine: Record "Warehouse Receipt Line";
        var WarehouseReceiptLineBuf: Record "Warehouse Receipt Line";
        var DeleteWhseRcptLine: Boolean
    )
    begin
        DeleteWhseRcptLine := true;
    end;


    //*****************************
    //TransferOrder-Post Shipment Events
    //*****************************
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnBeforeInsertTransShptLine', '', true, true)]
    local procedure OnBeforeInsertTransShptLine(VAR TransShptLine: Record "Transfer Shipment Line"; TransLine: Record "Transfer Line"; CommitIsSuppressed: Boolean)
    begin
        TransShptLine."PF concerned" := TransLine."PF concerned";
        TransShptLine."Tracking No." := TransLine."Tracking No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnBeforePostItemJournalLine', '', true, true)]
    local procedure OnBeforePostItemJournalLineShipment(VAR ItemJournalLine: Record "Item Journal Line"; TransferLine: Record "Transfer Line"; TransferShipmentHeader: Record "Transfer Shipment Header"; TransferShipmentLine: Record "Transfer Shipment Line"; CommitIsSuppressed: Boolean)
    begin
        ItemJournalLine."Tracking No." := TransferLine."Tracking No.";
    end;

    //*****************************
    //TransferOrder-Post Receipt Events
    //*****************************

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnBeforePostItemJournalLine', '', true, true)]
    local procedure OnBeforePostItemJournalLineReceipt(VAR ItemJournalLine: Record "Item Journal Line"; TransferLine: Record "Transfer Line"; TransferReceiptHeader: Record "Transfer Receipt Header"; TransferReceiptLine: Record "Transfer Receipt Line"; CommitIsSuppressed: Boolean)
    begin
        ItemJournalLine."Tracking No." := TransferLine."Tracking No.";
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnBeforeInsertTransRcptLine', '', true, true)]
    local procedure "TransferOrder-Post Receipt_OnBeforeInsertTransRcptLine"
    (
        var TransRcptLine: Record "Transfer Receipt Line";
        TransLine: Record "Transfer Line";
        CommitIsSuppressed: Boolean
    )
    begin
        TransRcptLine."Tracking No." := TransLine."Tracking No.";
    end;


    //*****************************
    //Whse.-Shipment Release Events
    //*****************************

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Shipment Release", 'OnAfterRelease', '', true, true)]
    local procedure OnAfterReleaseWhseShipRelease(VAR WarehouseShipmentHeader: Record "Warehouse Shipment Header"; VAR WarehouseShipmentLine: Record "Warehouse Shipment Line")
    var
        CuLExportColisage: Codeunit "Export Picking List";
    begin
        IF WarehouseShipmentHeader."Picking List Exported" = FALSE THEN BEGIN
            CuLExportColisage.Export(WarehouseShipmentHeader);
            WarehouseShipmentHeader."Picking List Exported" := TRUE;
            WarehouseShipmentHeader.MODIFY();
        END;
    end;

    //*****************************
    //Planning Line Management Events
    //*****************************

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Planning Line Management", 'OnBeforeInsertPlanningComponent', '', true, true)]
    local procedure OnBeforeInsertPlanningComponent(VAR ReqLine: Record "Requisition Line"; VAR ProductionBOMLine: Record "Production BOM Line"; VAR PlanningComponent: Record "Planning Component")
    var
        RecLRoutingLine: Record "Routing Line";
        RecLWorkCenter: Record "Work Center";
    begin
        RecLRoutingLine.SETRANGE("Routing No.", ReqLine."Routing No.");
        RecLRoutingLine.SETRANGE("Version Code", ReqLine."Routing Version Code");
        RecLRoutingLine.SETRANGE(Type, RecLRoutingLine.Type::"Work Center");
        IF RecLRoutingLine.FINDFIRST() THEN
            IF RecLWorkCenter.GET(RecLRoutingLine."Work Center No.") THEN
                IF RecLWorkCenter."Consumption Location" <> '' THEN
                    PlanningComponent."Location Code" := RecLWorkCenter."Consumption Location";
    end;

    //*****************************
    //Whse.-Create Source Document Events
    //*****************************

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Create Source Document", 'OnAfterCreateShptLineFromSalesLine', '', true, true)]
    local procedure "Whse.-Create Source Document_OnAfterCreateShptLineFromSalesLine"
    (
        var WarehouseShipmentLine: Record "Warehouse Shipment Line";
        WarehouseShipmentHeader: Record "Warehouse Shipment Header";
        SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header"
    )
    var
        qty: Decimal;
    begin
        SalesLine.CalcFields("Reserved Quantity");
        qty := SalesLine."Reserved Quantity";
        WarehouseShipmentLine.Validate(Quantity, qty);
        WarehouseShipmentLine.Modify();
    end;



    //*****************************
    //Calculate Prod. Order Evenets
    //*****************************


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Calculate Prod. Order", 'OnTransferBOMOnAfterSetFiltersProdBOMLine', '', true, true)]
    local procedure "Calculate Prod. Order_OnTransferBOMOnAfterSetFiltersProdBOMLine"
    (
        var ProdBOMLine: Record "Production BOM Line";
        ProdOrderLine: Record "Prod. Order Line"
    )

    begin

        ProdBOMLine.SETFILTER("Raw Material sale", 'FALSE');

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Calculate Prod. Order", 'OnAfterTransferBOMComponent', '', true, true)]
    local procedure "Calculate Prod. Order_OnAfterTransferBOMComponent"
    (
        var ProdOrderLine: Record "Prod. Order Line";
        var ProductionBOMLine: Record "Production BOM Line";
        var ProdOrderComponent: Record "Prod. Order Component"
    )
    var
        RecLProdOrderRtngLine: Record "Prod. Order Routing Line";
        RecLWorkCenter: Record "Work Center";
        RecLMachineCenter: Record "Machine Center";
    begin
        //RecLProdOrderRtngLine.SETRANGE(Status, ProdOrderLine.Status);
        //RecLProdOrderRtngLine.SETRANGE("Prod. Order No.", ProdOrderLine."Prod. Order No.");
        //RecLProdOrderRtngLine.SETRANGE("Routing Reference No.", ProdOrderLine."Routing Reference No.");
        //RecLProdOrderRtngLine.SETRANGE("Routing No.", ProdOrderLine."Routing No.");
        //RecLProdOrderRtngLine.SetRange("Routing Link Code", ProductionBOMLine."Routing Link Code");
        //RecLProdOrderRtngLine.SetRange(Type, RecLProdOrderRtngLine.Type::"Work center");
        //RecLProdOrderRtngLine.SetRange(Type, RecLProdOrderRtngLine.Type::"Machine Center");
        //IF RecLProdOrderRtngLine.FindFirst() then
        //    IF RecLWorkCenter.GET(RecLProdOrderRtngLine."Work Center No.") then
        //       ProdOrderComponent."Location Code" := RecLWorkCenter."Consumption Location"

        //>>CBN_EMAILHOL_14042022_
        IF RecLProdOrderRtngLine.Type = RecLProdOrderRtngLine.Type::"Work center" THEN
            RecLProdOrderRtngLine.SETRANGE(Status, ProdOrderLine.Status);
        RecLProdOrderRtngLine.SETRANGE("Prod. Order No.", ProdOrderLine."Prod. Order No.");
        RecLProdOrderRtngLine.SETRANGE("Routing Reference No.", ProdOrderLine."Routing Reference No.");
        RecLProdOrderRtngLine.SETRANGE("Routing No.", ProdOrderLine."Routing No.");
        RecLProdOrderRtngLine.SetRange("Routing Link Code", ProductionBOMLine."Routing Link Code");
        RecLProdOrderRtngLine.SetRange(Type, RecLProdOrderRtngLine.Type::"Work center");
        IF RecLProdOrderRtngLine.FindFirst() then
            IF RecLWorkCenter.GET(RecLProdOrderRtngLine."Work Center No.") then
                ProdOrderComponent."Location Code" := RecLWorkCenter."Consumption Location";

        IF RecLProdOrderRtngLine.Type = RecLProdOrderRtngLine.Type::"Machine center" THEN
            RecLProdOrderRtngLine.SETRANGE(Status, ProdOrderLine.Status);
        RecLProdOrderRtngLine.SETRANGE("Prod. Order No.", ProdOrderLine."Prod. Order No.");
        RecLProdOrderRtngLine.SETRANGE("Routing Reference No.", ProdOrderLine."Routing Reference No.");
        RecLProdOrderRtngLine.SETRANGE("Routing No.", ProdOrderLine."Routing No.");
        RecLProdOrderRtngLine.SetRange("Routing Link Code", ProductionBOMLine."Routing Link Code");
        RecLProdOrderRtngLine.SetRange(Type, RecLProdOrderRtngLine.Type::"Machine center");
        IF RecLProdOrderRtngLine.FindFirst() then
            IF RecLMachineCenter.GET(RecLProdOrderRtngLine."No.") then
                ProdOrderComponent."Location Code" := RecLMachineCenter."Consumption Location";




        //<<CBN_EMAILHOL_14042022_
    end;




    //*****************************
    //Whse.-Purch. Release Events
    //*****************************

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Purch. Release", 'OnAfterReleaseSetFilters', '', true, true)]
    local procedure "Whse.-Purch. Release_OnAfterReleaseSetFilters"
    (
        var PurchaseLine: Record "Purchase Line";
        PurchaseHeader: Record "Purchase Header"
    )
    begin
        //unfilter "Work Center No."
        PurchaseLine.SetRange("Work Center No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnBeforeDeleteOneTransferHeader', '', true, true)]
    local procedure TransfertOrderPostReceipt_OnBeforeDeleteOneTransferHeader(TransferHeader: Record "Transfer Header"; var DeleteOne: Boolean)
    begin
        DeleteOne := false;
    end;
}
