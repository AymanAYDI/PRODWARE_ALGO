tableextension 50040 "Warehouse Source Filter" extends "Warehouse Source Filter"
{
    //t5771
    procedure SetFilters2(var GetSourceBatch: Report "Get Source Documents-ALGO"; LocationCode: Code[10])
    var
        WhseRequest: Record "Warehouse Request";
        SalesLine: Record "Sales Line";
        PurchLine: Record "Purchase Line";
        TransLine: Record "Transfer Line";
        SalesHeader: Record "Sales Header";
        ServiceHeader: Record "Service Header";
        ServiceLine: Record "Service Line";
    begin
        "Source Document" := '';

        if "Sales Orders" then begin
            WhseRequest."Source Document" := WhseRequest."Source Document"::"Sales Order";
            Addfilter("Source Document", Format(WhseRequest."Source Document"));
        end;

        if "Service Orders" then begin
            WhseRequest."Source Document" := WhseRequest."Source Document"::"Service Order";
            Addfilter("Source Document", Format(WhseRequest."Source Document"));
        end;

        if "Sales Return Orders" then begin
            WhseRequest."Source Document" := WhseRequest."Source Document"::"Sales Return Order";
            Addfilter("Source Document", Format(WhseRequest."Source Document"));
        end;

        if "Outbound Transfers" then begin
            WhseRequest."Source Document" := WhseRequest."Source Document"::"Outbound Transfer";
            Addfilter("Source Document", Format(WhseRequest."Source Document"));
        end;

        if "Purchase Orders" then begin
            WhseRequest."Source Document" := WhseRequest."Source Document"::"Purchase Order";
            Addfilter("Source Document", Format(WhseRequest."Source Document"));
        end;

        if "Purchase Return Orders" then begin
            WhseRequest."Source Document" := WhseRequest."Source Document"::"Purchase Return Order";
            Addfilter("Source Document", Format(WhseRequest."Source Document"));
        end;

        if "Inbound Transfers" then begin
            WhseRequest."Source Document" := WhseRequest."Source Document"::"Inbound Transfer";
            Addfilter("Source Document", Format(WhseRequest."Source Document"));
        end;

        if "Source Document" = '' then
            Error(Text000, FieldCaption("Source Document"));

        WhseRequest.SetFilter("Source Document", "Source Document");

        WhseRequest.SetFilter("Source No.", "Source No. Filter");
        WhseRequest.SetFilter("Shipment Method Code", "Shipment Method Code Filter");

        "Shipping Advice Filter" := '';

        if Partial then begin
            WhseRequest."Shipping Advice" := WhseRequest."Shipping Advice"::Partial;
            Addfilter("Shipping Advice Filter", Format(WhseRequest."Shipping Advice"));
        end;

        if Complete then begin
            WhseRequest."Shipping Advice" := WhseRequest."Shipping Advice"::Complete;
            Addfilter("Shipping Advice Filter", Format(WhseRequest."Shipping Advice"));
        end;

        WhseRequest.SetFilter("Shipping Advice", "Shipping Advice Filter");
        WhseRequest.SetRange("Location Code", LocationCode);

        SalesLine.SetFilter("No.", "Item No. Filter");
        SalesLine.SetFilter("Variant Code", "Variant Code Filter");
        SalesLine.SetFilter("Unit of Measure Code", "Unit of Measure Filter");

        ServiceLine.SetRange(Type, ServiceLine.Type::Item);
        ServiceLine.SetFilter("No.", "Item No. Filter");
        ServiceLine.SetFilter("Variant Code", "Variant Code Filter");
        ServiceLine.SetFilter("Unit of Measure Code", "Unit of Measure Filter");

        PurchLine.SetFilter("No.", "Item No. Filter");
        PurchLine.SetFilter("Variant Code", "Variant Code Filter");
        PurchLine.SetFilter("Unit of Measure Code", "Unit of Measure Filter");

        TransLine.SetFilter("Item No.", "Item No. Filter");
        TransLine.SetFilter("Variant Code", "Variant Code Filter");
        TransLine.SetFilter("Unit of Measure Code", "Unit of Measure Filter");

        SalesHeader.SetFilter("Sell-to Customer No.", "Sell-to Customer No. Filter");
        SalesLine.SetFilter("Planned Delivery Date", "Planned Delivery Date");
        SalesLine.SetFilter("Planned Shipment Date", "Planned Shipment Date");
        SalesLine.SetFilter("Shipment Date", "Sales Shipment Date");

        ServiceHeader.SetFilter("Customer No.", "Customer No. Filter");

        ServiceLine.SetFilter("Planned Delivery Date", "Planned Delivery Date");

        PurchLine.SetFilter("Buy-from Vendor No.", "Buy-from Vendor No. Filter");
        PurchLine.SetFilter("Expected Receipt Date", "Expected Receipt Date");
        PurchLine.SetFilter("Planned Receipt Date", "Planned Receipt Date");

        TransLine.SetFilter("In-Transit Code", "In-Transit Code Filter");
        TransLine.SetFilter("Transfer-from Code", "Transfer-from Code Filter");
        TransLine.SetFilter("Transfer-to Code", "Transfer-to Code Filter");
        TransLine.SetFilter("Shipment Date", "Shipment Date");
        TransLine.SetFilter("Receipt Date", "Receipt Date");

        SalesLine.SetFilter("Shipping Agent Code", "Shipping Agent Code Filter");
        SalesLine.SetFilter("Shipping Agent Service Code", "Shipping Agent Service Filter");

        ServiceLine.SetFilter("Shipping Agent Code", "Shipping Agent Code Filter");
        ServiceLine.SetFilter("Shipping Agent Service Code", "Shipping Agent Service Filter");

        TransLine.SetFilter("Shipping Agent Code", "Shipping Agent Code Filter");
        TransLine.SetFilter("Shipping Agent Service Code", "Shipping Agent Service Filter");

        GetSourceBatch.SetTableView(WhseRequest);
        GetSourceBatch.SetTableView(SalesHeader);
        GetSourceBatch.SetTableView(SalesLine);
        GetSourceBatch.SetTableView(PurchLine);
        GetSourceBatch.SetTableView(TransLine);
        GetSourceBatch.SetTableView(ServiceHeader);
        GetSourceBatch.SetTableView(ServiceLine);
        GetSourceBatch.SetDoNotFillQtytoHandle("Do Not Fill Qty. to Handle");
    end;

    local procedure Addfilter(var CodeField: Code[250]; NewFilter: Text[100])
    begin
        if CodeField = '' then
            CodeField := NewFilter
        else
            CodeField := CodeField + '|' + NewFilter;
    end;

    var
        Text000: Label '%1 must be chosen.';

}