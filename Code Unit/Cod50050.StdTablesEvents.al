codeunit 50050 "Std Tables Events"
{
    SingleInstance = true;

    //*****************************
    //Sales Line Events
    //*****************************

    [EventSubscriber(ObjectType::Table, 37, 'OnBeforeDeleteEvent', '', true, true)]
    local procedure t37OnBeforeDeleteEvent(VAR Rec: Record "Sales Line"; RunTrigger: Boolean)
    begin
        Rec.TestPackingExit(Rec);
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnBeforeValidateEvent', 'Type', true, true)]
    local procedure t37OnBeforeValidateType(VAR Rec: Record "Sales Line"; VAR xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        Rec.TestPackingExit(Rec);
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnBeforeValidateEvent', 'No.', true, true)]
    local procedure t37OnBeforeValidateNo(VAR Rec: Record "Sales Line"; VAR xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        if Rec.Type = Rec.Type::Item then
            Rec.TestPackingExit(Rec);
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'No.', true, true)]
    local procedure t37OnAfterValidateNo(VAR Rec: Record "Sales Line"; VAR xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.get(Rec."Document Type", Rec."Document No.");
        Rec.PO := SalesHeader.PO;
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnBeforeValidateEvent', 'Location Code', true, true)]
    local procedure t37OnBeforeValidateLocationCode(VAR Rec: Record "Sales Line"; VAR xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        if Rec.Type = Rec.Type::Item then
            Rec.TestPackingExit(Rec);
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnBeforeValidateEvent', 'Unit of Measure Code', true, true)]
    local procedure t37OnBeforeValidateUOMCode(VAR Rec: Record "Sales Line"; VAR xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        if Rec.Type = Rec.Type::Item then
            Rec.TestPackingExit(Rec);
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnBeforeValidateEvent', 'Quantity', true, true)]
    local procedure t37OnBeforeValidateQuantity(VAR Rec: Record "Sales Line"; VAR xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        if Rec.Type = Rec.Type::Item then
            Rec.TestPackingExit(Rec);
    end;


    //*****************************
    //Purchase Line Events
    //*****************************

    [EventSubscriber(ObjectType::Table, 39, 'OnAfterInsertEvent', '', true, true)]
    local procedure t39OnAfterInsert(VAR Rec: Record "Purchase Line"; RunTrigger: Boolean)
    var
        RecGPurchHeader: Record "Purchase Header";
    begin

        //>>ALGO-20180328
        RecGPurchHeader.RESET();
        RecGPurchHeader.SETRANGE("Document Type", Rec."Document Type");
        RecGPurchHeader.SETRANGE("No.", Rec."Document No.");
        IF RecGPurchHeader.FindSet() THEN
            IF NOT RecGPurchHeader."Development Order" THEN
                rec."Development Order" := FALSE
            ELSE
                REc."Development Order" := TRUE;
        //<<ALGO-20180328        
    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnAfterValidateEvent', 'Quantity', true, true)]
    local procedure t39OnAfterValidateQty(VAR Rec: Record "Purchase Line"; VAR xRec: Record "Purchase Line"; CurrFieldNo: Integer)
    var
        PurchHeader: Record "Purchase Header";
    begin
        PurchHeader.GET(Rec."Document Type", Rec."Document No.");
        //>>ALGO-P0039
        IF (COMPANYNAME() = 'ALGO PROD') AND (Rec."Document Type" = Rec."Document Type"::Order)
          AND (CurrFieldNo <> 0) AND (Rec."Initial Quantity" = 0) THEN
            Rec."Initial Quantity" := Rec.Quantity;

        IF (COMPANYNAME() = 'L''ATELIER') AND (Rec."Document Type" = Rec."Document Type"::Order)
          AND (CurrFieldNo <> 0) AND (Rec."Initial Quantity" = 0) THEN
            Rec."Initial Quantity" := Rec.Quantity;

        IF (COMPANYNAME() = 'ALGO PROD') AND (Rec."Document Type" = Rec."Document Type"::Order)
            AND (CurrFieldNo <> 0) AND (Rec."Initial Planned Receipt Date" = 0D) THEN
            Rec."Initial Planned Receipt Date" := Rec."Planned Receipt Date";
        //<<ALGO-P0039        
    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnBeforeValidateEvent', 'Planned Receipt Date', true, true)]
    local procedure t39OnBeforeValidatePlannedReceiptDate(VAR Rec: Record "Purchase Line"; VAR xRec: Record "Purchase Line"; CurrFieldNo: Integer)
    begin
        Rec.SuspendStatusCheck(true);
    end;

    //*****************************
    //Sales Invoice Line Events
    //*****************************
    [EventSubscriber(ObjectType::Table, 113, 'OnAfterInitFromSalesLine', '', true, true)]
    local procedure OnAfterInitFromSalesLine(VAR SalesInvLine: Record "Sales Invoice Line"; SalesInvHeader: Record "Sales Invoice Header"; SalesLine: Record "Sales Line")
    begin
        SalesInvLine."Order No." := SalesLine."Document No.";
        SalesInvLine."Order Qty" := SalesLine.Quantity;
        SalesInvLine."Promised Delivery Date" := SalesLine."Promised Delivery Date";
    end;

    //*****************************
    //Transfer Line Events
    //*****************************
    [EventSubscriber(ObjectType::table, 5741, 'OnAfterValidateEvent', 'Quantity', true, true)]
    local procedure t5741OnAferValidateQty(VAR Rec: Record "Transfer Line"; VAR xRec: Record "Transfer Line"; CurrFieldNo: Integer)
    begin
        IF (CurrFieldNo <> 0) AND (Rec."Initial Quantity" = 0) THEN
            Rec."Initial Quantity" := Rec.Quantity;
    end;


    //*****************************
    //Warehouse Shipment Line Events
    //*****************************
    [EventSubscriber(ObjectType::table, 7321, 'OnAfterValidateEvent', 'Quantity', true, true)]
    local procedure t7321OnAferValidateQty(VAR Rec: Record "Warehouse Shipment Line"; VAR xRec: Record "Warehouse Shipment Line"; CurrFieldNo: Integer)
    begin
        Rec."Available Parcel Quantity" := Rec.Quantity - Rec."Parcel Quantity";
    end;

    [EventSubscriber(ObjectType::table, 7321, 'OnBeforeValidateEvent', 'Qty. to Ship', true, true)]
    local procedure t7321OnBeforeValidateQty2Ship(VAR Rec: Record "Warehouse Shipment Line"; VAR xRec: Record "Warehouse Shipment Line"; CurrFieldNo: Integer)
    var
        TransferLine: Record "Transfer Line";
        Txt039: Label 'Voulez-vous expédier plus?';
        Txt040: Label 'Voulez-vous solder le RAL?';
    begin
        //>>ALGO APPRO2016-01
        IF (Rec."Source Document" = Rec."Source Document"::"Outbound Transfer") AND (COMPANYNAME() = 'ALGO PROD') THEN
            IF Rec."Qty. to Ship" > Rec."Qty. Outstanding" THEN
                IF DIALOG.CONFIRM(Txt039, TRUE) THEN BEGIN
                    //Transfert
                    TransferLine.GET(Rec."Source No.", Rec."Source Line No.");
                    //TransferLine.VALIDATE(Quantity, Rec."Qty. to Ship" + TransferLine."Quantity Shipped");
                    TransferLine.Quantity := Rec."Qty. to Ship" + TransferLine."Quantity Shipped";
                    TransferLine."Quantity (Base)" := ROUND(TransferLine.Quantity * TransferLine."Qty. per Unit of Measure", 0.00001);
                    //InitQtyInTransit
                    IF TransferLine."In-Transit Code" <> '' THEN BEGIN
                        TransferLine."Qty. in Transit" := TransferLine."Quantity Shipped" - TransferLine."Quantity Received";
                        TransferLine."Qty. in Transit (Base)" := TransferLine."Qty. Shipped (Base)" - TransferLine."Qty. Received (Base)";
                    END ELSE BEGIN
                        TransferLine."Qty. in Transit" := 0;
                        TransferLine."Qty. in Transit (Base)" := 0;
                    END;
                    TransferLine."Completely Received" := (TransferLine.Quantity <> 0) AND (TransferLine.Quantity = TransferLine."Quantity Received");
                    //InitOutstandingQty
                    TransferLine."Outstanding Quantity" := TransferLine.Quantity - TransferLine."Quantity Shipped";
                    TransferLine."Outstanding Qty. (Base)" := TransferLine."Quantity (Base)" - TransferLine."Qty. Shipped (Base)";
                    TransferLine."Completely Shipped" := (TransferLine.Quantity <> 0) AND (TransferLine."Outstanding Quantity" = 0);
                    //InitQtyToShip
                    TransferLine."Qty. to Ship" := TransferLine."Outstanding Quantity";
                    TransferLine."Qty. to Ship (Base)" := TransferLine."Outstanding Qty. (Base)";
                    //InitQtyToReceive
                    IF TransferLine."In-Transit Code" <> '' THEN BEGIN
                        TransferLine."Qty. to Receive" := TransferLine."Qty. in Transit";
                        TransferLine."Qty. to Receive (Base)" := TransferLine."Qty. in Transit (Base)";
                    END;
                    IF (TransferLine."In-Transit Code" = '') AND (TransferLine."Quantity Shipped" = TransferLine."Quantity Received") THEN BEGIN
                        TransferLine."Qty. to Receive" := TransferLine."Qty. to Ship";
                        TransferLine."Qty. to Receive (Base)" := TransferLine."Qty. to Ship (Base)";
                    END;

                    TransferLine.UpdateWithWarehouseShipReceive();

                    TransferLine.MODIFY(TRUE);
                    //Warehouse Shipment
                    Rec.VALIDATE(Quantity, Rec."Qty. to Ship" + Rec."Qty. Shipped");
                END;
        //<<ALGO APPRO2016-01


        //>>ALGO APPRO2017-03
        IF (Rec."Source Document" = Rec."Source Document"::"Outbound Transfer") AND (COMPANYNAME() = 'ALGO PROD') THEN
            IF Rec."Qty. to Ship" < Rec."Qty. Outstanding" THEN
                IF DIALOG.CONFIRM(Txt040, TRUE) THEN BEGIN
                    //Transfert
                    TransferLine.GET(Rec."Source No.", Rec."Source Line No.");
                    //TransferLine.VALIDATE(Quantity, Rec."Qty. to Ship" + TransferLine."Quantity Shipped");

                    TransferLine.Quantity := Rec."Qty. to Ship" + TransferLine."Quantity Shipped";
                    TransferLine."Quantity (Base)" := ROUND(TransferLine.Quantity * TransferLine."Qty. per Unit of Measure", 0.00001);
                    //InitQtyInTransit
                    IF TransferLine."In-Transit Code" <> '' THEN BEGIN
                        TransferLine."Qty. in Transit" := TransferLine."Quantity Shipped" - TransferLine."Quantity Received";
                        TransferLine."Qty. in Transit (Base)" := TransferLine."Qty. Shipped (Base)" - TransferLine."Qty. Received (Base)";
                    END ELSE BEGIN
                        TransferLine."Qty. in Transit" := 0;
                        TransferLine."Qty. in Transit (Base)" := 0;
                    END;
                    TransferLine."Completely Received" := (TransferLine.Quantity <> 0) AND (TransferLine.Quantity = TransferLine."Quantity Received");
                    //InitOutstandingQty
                    TransferLine."Outstanding Quantity" := TransferLine.Quantity - TransferLine."Quantity Shipped";
                    TransferLine."Outstanding Qty. (Base)" := TransferLine."Quantity (Base)" - TransferLine."Qty. Shipped (Base)";
                    TransferLine."Completely Shipped" := (TransferLine.Quantity <> 0) AND (TransferLine."Outstanding Quantity" = 0);
                    //InitQtyToShip
                    TransferLine."Qty. to Ship" := TransferLine."Outstanding Quantity";
                    TransferLine."Qty. to Ship (Base)" := TransferLine."Outstanding Qty. (Base)";
                    //InitQtyToReceive
                    IF TransferLine."In-Transit Code" <> '' THEN BEGIN
                        TransferLine."Qty. to Receive" := TransferLine."Qty. in Transit";
                        TransferLine."Qty. to Receive (Base)" := TransferLine."Qty. in Transit (Base)";
                    END;
                    IF (TransferLine."In-Transit Code" = '') AND (TransferLine."Quantity Shipped" = TransferLine."Quantity Received") THEN BEGIN
                        TransferLine."Qty. to Receive" := TransferLine."Qty. to Ship";
                        TransferLine."Qty. to Receive (Base)" := TransferLine."Qty. to Ship (Base)";
                    END;

                    TransferLine.UpdateWithWarehouseShipReceive();

                    TransferLine.MODIFY(TRUE);
                    //Warehouse Shipment
                    IF Rec."Qty. to Ship" > 0 THEN begin
                        Rec."Qty. (Base)" := 0;
                        Rec.VALIDATE(Quantity, Rec."Qty. to Ship" + Rec."Qty. Shipped");
                    end;
                END;
        //<<ALGO APPRO2017-03

    end;

}