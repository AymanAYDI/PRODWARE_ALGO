codeunit 50039 "Auto Reser Handler Packaging"
{
    // version ALGO

    // Demande JVE 20230313 : on force la réservation sur les lignes de ventes en prenant en compte le conditionnement.
    // Essai non concluant actuellement.

    SingleInstance = true;


    procedure SetSalesLine(CurrentSalesLine: Record "Sales Line"; var Res: Integer)
    begin
        EntrySummary.Reset();
        ReservEntry.Reset();
        ReservEntry2.Reset();
        RecItem.Reset();
        RecBinContent.Reset();
        SalesLine.Reset();
        Clear(QtyReserved);
        Clear(QtyReservedBefore);
        Clear(QtyToReserve);
        Clear(ReservMgt);

        CurrentSalesLine.TESTFIELD("Job No.", '');
        CurrentSalesLine.TESTFIELD("Drop Shipment", FALSE);
        CurrentSalesLine.TESTFIELD(Type, CurrentSalesLine.Type::Item);
        CurrentSalesLine.TESTFIELD("Shipment Date");

        SalesLine := CurrentSalesLine;

        ReservEntry."Source Type" := DATABASE::"Sales Line";
        ReservEntry."Source Subtype" := SalesLine."Document Type";
        ReservEntry."Source ID" := SalesLine."Document No.";
        ReservEntry."Source Ref. No." := SalesLine."Line No.";

        ReservEntry."Item No." := SalesLine."No.";
        ReservEntry."Variant Code" := SalesLine."Variant Code";
        ReservEntry."Location Code" := SalesLine."Location Code";
        ReservEntry."Shipment Date" := SalesLine."Shipment Date";

        UpdateReservFrom();

        EntrySummary.SETFILTER("Total Available Quantity", '>%1', 0);
        IF EntrySummary.FINDSET() then begin
            Res += 1;
            ReserveFromSummaryEntry();
        end;

    end;

    local procedure UpdateReservFrom()
    begin

        CASE ReservEntry."Source Type" OF
            DATABASE::"Sales Line":
                BEGIN
                    SalesLine.FIND;
                    SalesLine.CALCFIELDS("Reserved Qty. (Base)");
                    IF SalesLine."Document Type" = SalesLine."Document Type"::"Return Order" THEN
                        SalesLine."Reserved Qty. (Base)" := -SalesLine."Reserved Qty. (Base)";
                    QtyReserved := SalesLine."Reserved Qty. (Base)";
                    QtyToReserve := SalesLine."Outstanding Qty. (Base)";

                    /*                  // DSP>JVE 20230313
                                        // TEST avec le conditionnement

                                        Recherche du stock dans la table Stock Par Emplacement
                                        RecBinContent.SetFilter(RecBinContent."Item No.", '%1', SalesLine."No.");
                                        RecBinContent.setfilter(RecBinContent."Location Code", '%1', SalesLine."Location Code");
                                        RecBinContent.setfilter(RecBinContent."Bin Code", '%1', SalesLine."Bin Code");

                                        IF RecBinContent.FindSet() then BEGIN
                                            RecBinContent.CalcFields(Quantity);
                                            vInventoryBinContent := RecBinContent.Quantity;
                                        END;

                                        // Recherche du conditionnement paramétré sur la fiche article
                                        RecItem.SetFilter(RecItem."No.", '%1', SalesLine."No.");
                                        IF RecItem.FindSet() then BEGIN
                                            vConditionnement := RecItem."Units per Parcel";
                                        END;

                                        QtyReserved := SalesLine."Reserved Qty. (Base)";
                                        QtyToReserve := ROUND((vInventoryBinContent / vConditionnement), 1, '<') * vConditionnement;
                                        // Message('StockBincontent :' + format(vInventoryBinContent) + ' |vconditionnement : ' + format(vConditionnement));
                                        // Message('QtyToReserve :' + format(QtyToReserve));
                                        // DSP>JVE 20230313
                    */

                END;
            DATABASE::"Requisition Line":
                BEGIN
                    ReqLine.FIND;
                    ReqLine.CALCFIELDS("Reserved Qty. (Base)");
                    QtyReserved := ReqLine."Reserved Qty. (Base)";
                    QtyToReserve := ReqLine."Quantity (Base)";
                END;
            DATABASE::"Purchase Line":
                BEGIN
                    PurchLine.FIND;
                    PurchLine.CALCFIELDS("Reserved Qty. (Base)");
                    IF PurchLine."Document Type" = PurchLine."Document Type"::"Return Order" THEN
                        PurchLine."Reserved Qty. (Base)" := -PurchLine."Reserved Qty. (Base)";
                    QtyReserved := PurchLine."Reserved Qty. (Base)";
                    QtyToReserve := PurchLine."Outstanding Qty. (Base)";
                END;
            DATABASE::"Item Journal Line":
                BEGIN
                    ItemJnlLine.FIND;
                    ItemJnlLine.CALCFIELDS("Reserved Qty. (Base)");
                    QtyReserved := ItemJnlLine."Reserved Qty. (Base)";
                    QtyToReserve := ItemJnlLine."Quantity (Base)";
                END;
            DATABASE::"Prod. Order Line":
                BEGIN
                    ProdOrderLine.FIND;
                    ProdOrderLine.CALCFIELDS("Reserved Qty. (Base)");
                    QtyReserved := ProdOrderLine."Reserved Qty. (Base)";
                    QtyToReserve := ProdOrderLine."Remaining Qty. (Base)";
                END;
            DATABASE::"Prod. Order Component":
                BEGIN
                    ProdOrderComp.FIND;
                    ProdOrderComp.CALCFIELDS("Reserved Qty. (Base)");
                    QtyReserved := ProdOrderComp."Reserved Qty. (Base)";
                    QtyToReserve := ProdOrderComp."Remaining Qty. (Base)";
                END;
            DATABASE::"Planning Component":
                BEGIN
                    PlanningComponent.FIND;
                    PlanningComponent.CALCFIELDS("Reserved Qty. (Base)");
                    QtyReserved := PlanningComponent."Reserved Qty. (Base)";
                    QtyToReserve := PlanningComponent."Quantity (Base)";
                END;
            DATABASE::"Transfer Line":
                BEGIN
                    TransLine.FIND;
                    IF ReservEntry."Source Subtype" = 0 THEN BEGIN // Outbound
                        TransLine.CALCFIELDS("Reserved Qty. Outbnd. (Base)");
                        QtyReserved := TransLine."Reserved Qty. Outbnd. (Base)";
                        QtyToReserve := TransLine."Outstanding Qty. (Base)";
                    END ELSE BEGIN // Inbound
                        TransLine.CALCFIELDS("Reserved Qty. Inbnd. (Base)");
                        QtyReserved := TransLine."Reserved Qty. Inbnd. (Base)";
                        QtyToReserve := TransLine."Outstanding Qty. (Base)";
                    END;
                END;
            DATABASE::"Service Line":
                BEGIN
                    ServiceLine.FIND;
                    ServiceLine.CALCFIELDS("Reserved Qty. (Base)");
                    QtyReserved := ServiceLine."Reserved Qty. (Base)";
                    QtyToReserve := ServiceLine."Outstanding Qty. (Base)";
                END;
        END;

        UpdateReservMgt();
        ReservMgt.UpdateStatistics(
          EntrySummary, ReservEntry."Shipment Date", HandleItemTracking);

        //Reservation on Item Ledger Entry
        EntrySummary.SetFilter("Table ID", '<>%1', 32);
        EntrySummary.DeleteAll();
        EntrySummary.SetRange("Table ID");

        IF HandleItemTracking THEN BEGIN
            QtyReserved := 0;
            IF EntrySummary.FINDSET() THEN
                REPEAT
                    QtyReserved += ReservedThisLine(EntrySummary);
                UNTIL EntrySummary.NEXT() = 0;
            QtyToReserve := ItemTrackingQtyToReserve;
        END;

        UpdateNonSpecific(); // Late Binding
    end;


    local procedure UpdateReservMgt()
    begin
        CLEAR(ReservMgt);
        CASE ReservEntry."Source Type" OF
            DATABASE::"Sales Line":
                ReservMgt.SetSalesLine(SalesLine);
            DATABASE::"Requisition Line":
                ReservMgt.SetReqLine(ReqLine);
            DATABASE::"Purchase Line":
                ReservMgt.SetPurchLine(PurchLine);
            DATABASE::"Item Journal Line":
                ReservMgt.SetItemJnlLine(ItemJnlLine);
            DATABASE::"Prod. Order Line":
                ReservMgt.SetProdOrderLine(ProdOrderLine);
            DATABASE::"Prod. Order Component":
                ReservMgt.SetProdOrderComponent(ProdOrderComp);
            DATABASE::"Planning Component":
                ReservMgt.SetPlanningComponent(PlanningComponent);
            DATABASE::"Transfer Line":
                ReservMgt.SetTransferLine(TransLine, ReservEntry."Source Subtype");
            DATABASE::"Service Line":
                ReservMgt.SetServLine(ServiceLine);
        END;
        ReservMgt.SetSerialLotNo(ReservEntry."Serial No.", ReservEntry."Lot No.");
    end;

    local procedure ReservedThisLine(ReservSummEntry2: Record "Entry Summary" temporary) ReservedQuantity: Decimal
    var
        ReservEntry3: Record "Reservation Entry";
    begin
        CLEAR(ReservEntry2);

        ReservEntry2.SETCURRENTKEY(
          "Item No.", "Source Type", "Source Subtype", "Reservation Status", "Location Code", "Variant Code",
          "Shipment Date", "Expected Receipt Date", "Serial No.", "Lot No.");
        ReservedQuantity := 0;

        FilterReservEntry(ReservEntry2, ReservSummEntry2);
        IF ReservEntry2.FIND('-') THEN
            REPEAT
                ReservEntry3.GET(ReservEntry2."Entry No.", NOT ReservEntry2.Positive);
                IF (ReservEntry3."Source Type" = ReservEntry."Source Type") AND
                   (ReservEntry3."Source Subtype" = ReservEntry."Source Subtype") AND
                   (ReservEntry3."Source ID" = ReservEntry."Source ID") AND
                   (ReservEntry3."Source Batch Name" = ReservEntry."Source Batch Name") AND
                   (ReservEntry3."Source Prod. Order Line" = ReservEntry."Source Prod. Order Line") AND
                   (ReservEntry3."Source Ref. No." = ReservEntry."Source Ref. No.") AND
                   (((ReservEntry3."Serial No." = ReservEntry."Serial No.") AND
                     (ReservEntry3."Lot No." = ReservEntry."Lot No.") AND
                     HandleItemTracking) OR
                     NOT HandleItemTracking)
                THEN
                    ReservedQuantity += ReservEntry2."Quantity (Base)" * CreateReservEntry.SignFactor(ReservEntry2);
            UNTIL ReservEntry2.NEXT() = 0;

        EXIT(ReservedQuantity);
    end;

    local procedure UpdateNonSpecific()
    begin
        EntrySummary.SETFILTER("Non-specific Reserved Qty.", '>%1', 0);
        NonSpecificQty := EntrySummary."Non-specific Reserved Qty.";
        EntrySummary.SETRANGE("Non-specific Reserved Qty.");
    end;

    local procedure FilterReservEntry(var FilterReservEntry: Record "Reservation Entry"; FromReservSummEntry: Record "Entry Summary")
    begin
        FilterReservEntry.SETRANGE("Item No.", ReservEntry."Item No.");

        CASE FromReservSummEntry."Entry No." OF
            1:
                BEGIN // Item Ledger Entry
                    FilterReservEntry.SETRANGE("Source Type", DATABASE::"Item Ledger Entry");
                    FilterReservEntry.SETRANGE("Source Subtype", 0);
                    FilterReservEntry.SETRANGE("Expected Receipt Date");
                END;
            11, 12, 13, 14, 15, 16:
                BEGIN // Purchase Line
                    FilterReservEntry.SETRANGE("Source Type", DATABASE::"Purchase Line");
                    FilterReservEntry.SETRANGE("Source Subtype", FromReservSummEntry."Entry No." - 11);
                END;
            21:
                BEGIN // Requisition Line
                    FilterReservEntry.SETRANGE("Source Type", DATABASE::"Requisition Line");
                    FilterReservEntry.SETRANGE("Source Subtype", 0);
                END;
            31, 32, 33, 34, 35, 36:
                BEGIN // Sales Line
                    FilterReservEntry.SETRANGE("Source Type", DATABASE::"Sales Line");
                    FilterReservEntry.SETRANGE("Source Subtype", FromReservSummEntry."Entry No." - 31);
                END;
            41, 42, 43, 44, 45:
                BEGIN // Item Journal Line
                    FilterReservEntry.SETRANGE("Source Type", DATABASE::"Item Journal Line");
                    FilterReservEntry.SETRANGE("Source Subtype", FromReservSummEntry."Entry No." - 41);
                END;
            61, 62, 63, 64:
                BEGIN // prod. order
                    FilterReservEntry.SETRANGE("Source Type", DATABASE::"Prod. Order Line");
                    FilterReservEntry.SETRANGE("Source Subtype", FromReservSummEntry."Entry No." - 61);
                END;
            71, 72, 73, 74:
                BEGIN // prod. order
                    FilterReservEntry.SETRANGE("Source Type", DATABASE::"Prod. Order Component");
                    FilterReservEntry.SETRANGE("Source Subtype", FromReservSummEntry."Entry No." - 71);
                END;
            91:
                BEGIN // Planning Component
                    FilterReservEntry.SETRANGE("Source Type", DATABASE::"Planning Component");
                    FilterReservEntry.SETRANGE("Source Subtype", 0);
                END;
            101, 102:
                BEGIN // Transfer Line
                    FilterReservEntry.SETRANGE("Source Type", DATABASE::"Transfer Line");
                    FilterReservEntry.SETRANGE("Source Subtype", FromReservSummEntry."Entry No." - 101);
                END;
            110:
                BEGIN // Service Line
                    FilterReservEntry.SETRANGE("Source Type", DATABASE::"Service Line");
                    FilterReservEntry.SETRANGE("Source Subtype", 0);
                END;
        END;

        FilterReservEntry.SETRANGE(
          "Reservation Status", FilterReservEntry."Reservation Status"::Reservation);
        FilterReservEntry.SETRANGE("Location Code", ReservEntry."Location Code");
        FilterReservEntry.SETRANGE("Variant Code", ReservEntry."Variant Code");
        IF (ReservEntry."Serial No." <> '') OR (ReservEntry."Lot No." <> '') THEN BEGIN
            FilterReservEntry.SETRANGE("Serial No.", ReservEntry."Serial No.");
            FilterReservEntry.SETRANGE("Lot No.", ReservEntry."Lot No.");
        END;
        FilterReservEntry.SETRANGE(Positive, ReservMgt.IsPositive());
    end;

    procedure ReserveFromSummaryEntry()
    var
        RemainingQtyBaseToReserve: Decimal;
    begin
        RemainingQtyToReserve := QtyToReserve - QtyReserved;
        //Message('RemainingQtyToReserve : ' + format(RemainingQtyToReserve));
        IF RemainingQtyToReserve = 0 THEN
            EXIT;

        QtyReservedBefore := QtyReserved;
        IF HandleItemTracking THEN
            ReservMgt.SetItemTrackingHandling(2);

        // ReservMgt.AutoReserve(FullAutoReservation, ReservEntry.Description,
        //     ReservEntry."Shipment Date", RemainingQtyToReserve, RemainingQtyToReserve);


        ReservMgt.CalculateRemainingQty(RemainingQtyToReserve, RemainingQtyBaseToReserve);
        ReservMgt.AutoReserveOneLine(1, RemainingQtyToReserve, RemainingQtyBaseToReserve, ReservEntry.Description,
        ReservEntry."Shipment Date");

        //UpdateReservFrom();
        // IF QtyReservedBefore = QtyReserved THEN
        //     IF GUIALLOWED() THEN
        //         ERROR(Text002Msg);
    end;


    var
        EntrySummary: Record "Entry Summary" temporary;
        ReservEntry: Record "Reservation Entry";
        ReservEntry2: Record "Reservation Entry";
        SalesLine: Record "Sales Line";
        PurchLine: Record "Purchase Line";
        ItemJnlLine: Record "Item Journal Line";
        ReqLine: Record "Requisition Line";
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderComp: Record "Prod. Order Component";
        PlanningComponent: Record "Planning Component";
        ServiceLine: Record "Service Line";
        TransLine: Record "Transfer Line";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        ReservMgt: Codeunit "Reservation Management";
        QtyToReserve: Decimal;
        QtyReserved: Decimal;
        ItemTrackingQtyToReserve: Decimal;
        RemainingQtyToReserve: Decimal;
        QtyReservedBefore: Decimal;
        NonSpecificQty: Decimal;
        HandleItemTracking: Boolean;
        Text002Msg: Label 'There is nothing available to reserve.';

        RecItem: Record "Item";
        vConditionnement: decimal;
        RecBinContent: record "Bin Content";
        vInventoryBinContent: Decimal;


}

