codeunit 50060 "PostWS"
{
    SingleInstance = true;

    trigger OnRun()
    begin
    end;


    procedure PostReceipt(pRecPurchaseHeader: Record "Purchase Header")
    begin
        pRecPurchaseHeader.Receive := true;
        CODEUNIT.Run(CODEUNIT::"Purch.-Post", pRecPurchaseHeader);
    end;
    //MODIF-202210 - DDE : JVE - DEV : DSP

    procedure PostSalesInvoice(pRecSalesInvoice: Record "Sales Header")
    begin
        pRecSalesInvoice.Invoice := true;
        CODEUNIT.Run(CODEUNIT::"Sales-Post", pRecSalesInvoice);
    end;
    //MODIF-202210 - DDE : JVE - DEV : DSP


    procedure PostReclassement(pRecItemJournalLine: Record "Item Journal Line")
    begin
        //CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post",pRecItemJournalLine);
        CODEUNIT.Run(CODEUNIT::"Item Jnl.-Post Batch", pRecItemJournalLine);
    end;


    procedure PostShipment(pRecSalesHeader: Record "Sales Header")
    begin
        pRecSalesHeader.Ship := true;
        CODEUNIT.Run(CODEUNIT::"Sales-Post", pRecSalesHeader);
    end;

    // WebService Approbation CA


    procedure WSAPPROVENTRY(PrecApprovalEntry: Record "Approval Entry")
    var
        WSACTIONAPPROV: Codeunit "Approvals Mgmt.";
    begin
        WSACTIONAPPROV.ApproveRecordApprovalRequest(PrecApprovalEntry."Record ID to Approve");
    end;


    procedure WSREJECTENTRY(PrecApprovalEntry: Record "Approval Entry")
    var
        WSACTIONREJECT: Codeunit "Approvals Mgmt.";
    begin
        WSACTIONREJECT.RejectRecordApprovalRequest(PrecApprovalEntry."Record ID to Approve");
    end;

    // WebService Approbation CA


    procedure PostShipmentWhse(WarehouseShipmentHeader: Record "Warehouse Shipment Header")
    var
        WhseShptLine: Record "Warehouse Shipment Line";

    begin
        HideconfirmwhseShipmentWMS := true;
        WhseShptLine.SetRange("No.", WarehouseShipmentHeader."No.");
        IF WhseShptLine.FindSet() then
            CODEUNIT.Run(CODEUNIT::"Whse.-Post Shipment (Yes/No)", WhseShptLine);
    end;

    [EventSubscriber(ObjectType::Codeunit, 5764, 'OnBeforeConfirmWhseShipmentPost', '', true, true)]
    local procedure OnBeforeConfirmWhseShipment(var WhseShptLine: Record "Warehouse Shipment Line"; var HideDialog: Boolean; var Invoice: Boolean; var IsPosted: Boolean)
    begin
        if HideconfirmwhseShipmentWMS then
            HideDialog := true;
        HideconfirmwhseShipmentWMS := false;

    end;

    procedure ReOpenPurchaseOrder(PurchaseHeader: Record "Purchase Header")
    var
        ReleasePurchas: Codeunit "Release Purchase Document";
    begin
        ReleasePurchas.PerformManualReopen(PurchaseHeader);
    end;

    procedure ReleasePurchaseOrder(PurchaseHeader: Record "Purchase Header")
    var
        ReleasePurchas: Codeunit "Release Purchase Document";
    begin
        ReleasePurchas.PerformManualRelease(PurchaseHeader);
    end;

    procedure PostWhseReceipt(WhseReceiptHeader: Record "Warehouse Receipt Header")
    var
        WhseRcptLine: Record "Warehouse Receipt Line";
    begin
        WhseRcptLine.SetRange("No.", WhseReceiptHeader."No.");
        if WhseRcptLine.FindSet() then
            codeunit.Run(Codeunit::"Whse.-Post Receipt", WhseRcptLine);
    end;

    procedure CreateWhseReceipt(TransferHeader: Record "Transfer Header"): Code[20];
    var
        WhseRqst: Record "Warehouse Request";
    begin
        TransferHeader.TESTFIELD(Status, TransferHeader.Status::Released);
        WhseRqst.SETRANGE(Type, WhseRqst.Type::Inbound);
        WhseRqst.SETRANGE("Source Type", DATABASE::"Transfer Line");
        WhseRqst.SETRANGE("Source Subtype", 1);
        WhseRqst.SETRANGE("Source No.", TransferHeader."No.");
        WhseRqst.SETRANGE("Document Status", WhseRqst."Document Status"::Released);
        GetRequireReceiveRqst(WhseRqst);
        EXIT(CreateWhseReceiptHeaderFromWhseRequest(WhseRqst));
    end;

    local procedure GetRequireReceiveRqst(VAR WhseRqst: Record "Warehouse Request")
    var
        Location: Record Location;
        LocationCode: Code[20];
    begin
        IF WhseRqst.FINDSET() THEN BEGIN
            REPEAT
                IF Location.RequireReceive(WhseRqst."Location Code") THEN
                    LocationCode += WhseRqst."Location Code" + '|';
            UNTIL WhseRqst.NEXT() = 0;
            IF LocationCode <> '' THEN BEGIN
                LocationCode := COPYSTR(LocationCode, 1, STRLEN(LocationCode) - 1);
                IF LocationCode[1] = '|' THEN
                    LocationCode := '''''' + LocationCode;
            END;
            WhseRqst.SETFILTER("Location Code", LocationCode);
        END;
    end;

    local procedure CreateWhseReceiptHeaderFromWhseRequest(VAR WarehouseRequest: Record "Warehouse Request"): Code[20];
    var
        WarehouseReceiptHeader: Record "Warehouse Receipt Header";
        GetSourceDocuments: Report "Get Source Documents";
    begin
        CLEAR(GetSourceDocuments);

        GetSourceDocuments.UseRequestPage(false);
        GetSourceDocuments.SetTableView(WarehouseRequest);
        GetSourceDocuments.SetHideDialog(true);
        GetSourceDocuments.RunModal();
        GetSourceDocuments.GetLastReceiptHeader(WarehouseReceiptHeader);
        Exit(WarehouseReceiptHeader."No.");
    end;

    procedure SalesOrderCancelReservation(SalesHeader: record "Sales Header")
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.Setfilter("Outstanding Qty. (Base)", '<>%1', 0);
        if SalesLine.FindSet() then
            repeat
                SetSalesLine(SalesLine);
                CancelReservationCurrentLine();
            until SalesLine.Next() = 0
    end;

    local procedure SetSalesLine(VAR CurrentSalesLine: Record "Sales Line")
    begin
        CurrentSalesLine.TESTFIELD("Job No.", '');
        CurrentSalesLine.TESTFIELD("Drop Shipment", FALSE);
        CurrentSalesLine.TESTFIELD(Type, CurrentSalesLine.Type::Item);
        CurrentSalesLine.TESTFIELD("Shipment Date");

        ReservEntry.SetSource(
        DATABASE::"Sales Line", CurrentSalesLine."Document Type", CurrentSalesLine."Document No.", CurrentSalesLine."Line No.", '', 0);
        ReservEntry."Item No." := CurrentSalesLine."No.";
        ReservEntry."Variant Code" := CurrentSalesLine."Variant Code";
        ReservEntry."Location Code" := CurrentSalesLine."Location Code";
        ReservEntry."Shipment Date" := CurrentSalesLine."Shipment Date";

    end;

    local procedure CancelReservationCurrentLine()
    var
        ReservEntry2: Record "Reservation Entry";
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
    begin
        CLEAR(ReservEntry2);
        ReservEntry2 := ReservEntry;
        ReservEntry2.SetPointerFilter();
        ReservEntry2.SETRANGE("Reservation Status", ReservEntry2."Reservation Status"::Reservation);
        ReservEntry2.SETRANGE("Disallow Cancellation", FALSE);
        IF ReservEntry2.FINDSET() THEN
            REPEAT
                ReservEngineMgt.CancelReservation(ReservEntry2);
            UNTIL ReservEntry2.NEXT() = 0;
    end;


    procedure RefreshProductiontionOrder(ProdOrder: Record "Production Order")
    var
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderComp: Record "Prod. Order Component";
        ProdOrderRtngLine: Record "Prod. Order Routing Line";
        CalcProdOrder: Codeunit "Calculate Prod. Order";
        Direction: Option Forward,Backward;
        ErrorOccured: Boolean;
    begin
        ProdOrderLine.SetRange(Status, ProdOrder."Status");
        ProdOrderLine.SetRange("Prod. Order No.", ProdOrder."No.");
        if ProdOrderLine.Find('-') then
            repeat
                ProdOrderRtngLine.SetRange(Status, ProdOrder."Status");
                ProdOrderRtngLine.SetRange("Prod. Order No.", ProdOrder."No.");
                ProdOrderRtngLine.SetRange("Routing Reference No.", ProdOrderLine."Routing Reference No.");
                ProdOrderRtngLine.SetRange("Routing No.", ProdOrderLine."Routing No.");
                if ProdOrderRtngLine.FindSet(true) then
                    repeat
                        ProdOrderRtngLine.SetSkipUpdateOfCompBinCodes(true);
                        ProdOrderRtngLine.Delete(true);
                    until ProdOrderRtngLine.Next = 0;
                ProdOrderComp.SetRange("Prod. Order No.", ProdOrder."No.");
                ProdOrderComp.SetRange("Prod. Order Line No.", ProdOrderLine."Line No.");
                ProdOrderComp.DeleteAll(true);
            until ProdOrderLine.Next = 0;
        if ProdOrderLine.Find('-') then
            repeat
                CheckProductionBOMStatus(ProdOrderLine."Production BOM No.", ProdOrderLine."Production BOM Version Code");
                CheckRoutingStatus(ProdOrderLine."Routing No.", ProdOrderLine."Routing Version Code");
                ProdOrderLine."Due Date" := ProdOrder."Due Date";
                if not CalcProdOrder.Calculate(ProdOrderLine, Direction::Backward, true, true, false, false) then
                    ErrorOccured := true;
            until ProdOrderLine.Next = 0;
    end;


    procedure UpdateUnitCost(ProdOrder: Record "Production Order")
    var
        prodOrderLine: Record "Prod. Order Line";
        Item: Record Item;
        UpdateProdOrderCost: Codeunit "Update Prod. Order Cost";
        CalcMethod: Option "One Level","All Levels";
        UpdateReservations: Boolean;
    begin
        UpdateReservations := false;
        prodOrderLine.SetRange("Prod. Order No.", ProdOrder."No.");
        If prodOrderLine.FindSet(true) then
            repeat
                UpdateProdOrderCost.UpdateUnitCostOnProdOrder(prodOrderLine, CalcMethod = CalcMethod::"One Level", UpdateReservations);
            until prodOrderLine.Next = 0;
    end;


    local procedure CheckProductionBOMStatus(ProdBOMNo: Code[20]; ProdBOMVersionNo: Code[20])
    var
        ProductionBOMHeader: Record "Production BOM Header";
        ProductionBOMVersion: Record "Production BOM Version";
    begin
        if ProdBOMNo = '' then
            exit;

        if ProdBOMVersionNo = '' then begin
            ProductionBOMHeader.Get(ProdBOMNo);
            ProductionBOMHeader.TestField(Status, ProductionBOMHeader.Status::Certified);
        end else begin
            ProductionBOMVersion.Get(ProdBOMNo, ProdBOMVersionNo);
            ProductionBOMVersion.TestField(Status, ProductionBOMVersion.Status::Certified);
        end;
    end;

    local procedure CheckRoutingStatus(RoutingNo: Code[20]; RoutingVersionNo: Code[20])
    var
        RoutingHeader: Record "Routing Header";
        RoutingVersion: Record "Routing Version";
    begin
        if RoutingNo = '' then
            exit;

        if RoutingVersionNo = '' then begin
            RoutingHeader.Get(RoutingNo);
            RoutingHeader.TestField(Status, RoutingHeader.Status::Certified);
        end else begin
            RoutingVersion.Get(RoutingNo, RoutingVersionNo);
            RoutingVersion.TestField(Status, RoutingVersion.Status::Certified);
        end;
    end;

    /*local procedure WhsePostRecptYesNo()
        begin
        CurrPage.WhseReceiptLines.PAGE.WhsePostRcptYesNo;
    end;*/

    var
        ReservEntry: Record "Reservation Entry";
        HideconfirmwhseShipmentWMS: Boolean;
}

