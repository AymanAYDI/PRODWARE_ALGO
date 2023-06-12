page 50007 "Reservation Qty."
{
    // version ALG1.00,MIG2009R2

    Caption = 'Reservation Qty.';
    DataCaptionExpression = CaptionText;
    PageType = Card;
    SourceTable = "Entry Summary";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(ItemNo; ReservEntry."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Item No.';
                    Editable = false;
                }
                field(ShipmentDate; ReservEntry."Shipment Date")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Shipment Date';
                    Editable = false;
                }
                field(Description; ReservEntry.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Description';
                }
                field(DecGQtyToReserv; DecGQtyToReserv)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Quantity to Reserve';
                    DecimalPlaces = 0 : 5;

                    trigger OnValidate()
                    begin
                        QtyToReserve := DecGQtyToReserv + QtyReserved;
                    end;
                }
                field(QtyToReserve; QtyToReserve)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Total Quantity to Reserve';
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                }
                field(QtyReserved; QtyReserved)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Reserved Quantity';
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                }
                field(QtyToReserveQtyReserved; QtyToReserve - QtyReserved)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Unreserved Quantity';
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                }
            }
            repeater(Control1)
            {
                Editable = false;
                field("Summary Type"; Rec."Summary Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(TotalQuantity; ReservMgt.FormatQty(Rec."Total Quantity"))
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    Caption = 'Total Quantity';
                    DecimalPlaces = 0 : 5;
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        DrillDownTotalQuantity();
                    end;
                }
                field(TotalReservedQuantity; ReservMgt.FormatQty(Rec."Total Reserved Quantity"))
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    Caption = 'Total Reserved Quantity';
                    DecimalPlaces = 0 : 5;
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        DrillDownReservedQuantity();
                    end;
                }
                field(QtyAllocinWarehouse; ReservMgt.FormatQty(Rec."Qty. Alloc. in Warehouse"))
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Qty. Allocated in Warehouse';
                    Editable = false;
                }
                field(TotalAvailableQuantity; ReservMgt.FormatQty(Rec."Total Available Quantity"))
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Total Available Quantity';
                    Editable = false;
                }
                field(ReservedThisLine2; ReservMgt.FormatQty(ReservedThisLine(Rec)))
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Current Reserved Quantity';

                    trigger OnDrillDown()
                    begin
                        DrillDownReservedThisLine();
                    end;
                }
            }
            group(Filters)
            {
                Caption = 'Filters';
                field(VariantCode; ReservEntry."Variant Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Variant Code';
                    Editable = false;
                }
                field(LocationCode; ReservEntry."Location Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Location Code';
                    Editable = false;
                }
                field(SerialNo; ReservEntry."Serial No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Serial No.';
                    Editable = false;
                }
                field(LotNo; ReservEntry."Lot No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Lot No.';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                action("&Available to Reserve")
                {
                    Caption = '&Available to Reserve';
                    Image = ItemReservation;
                    ShortCutKey = 'Ctrl+F7';

                    trigger OnAction()
                    begin
                        DrillDownTotalQuantity();
                    end;
                }
                action("&Reservation Entries")
                {
                    Caption = '&Reservation Entries';
                    Image = ReservationLedger;

                    trigger OnAction()
                    begin
                        DrillDownReservedThisLine();
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("&Auto Reserve")
                {
                    Caption = '&Auto Reserve';
                    Image = AutoReserve;

                    trigger OnAction()
                    begin
                        IF ABS(QtyToReserve) - ABS(QtyReserved) = 0 THEN
                            ERROR(Text000Msg);

                        RemainingQtyToReserve := QtyToReserve - QtyReserved;
                        ReservMgt.AutoReserve(
                          FullAutoReservation, ReservEntry.Description,
                          ReservEntry."Shipment Date", RemainingQtyToReserve, RemainingQtyToReserve);
                        IF NOT FullAutoReservation THEN
                            MESSAGE(Text001Msg);
                        UpdateReservFrom();
                    end;
                }
                action("&Reserve from Current Line")
                {
                    Caption = '&Reserve from Current Line';
                    Image = LineReserve;

                    trigger OnAction()
                    begin
                        RemainingQtyToReserve := QtyToReserve - QtyReserved;
                        IF RemainingQtyToReserve = 0 THEN
                            ERROR(Text000Msg);
                        QtyReservedBefore := QtyReserved;
                        IF HandleItemTracking THEN
                            ReservMgt.SetItemTrackingHandling(2);
                        ReservMgt.AutoReserveOneLine(
                          Rec."Entry No.", RemainingQtyToReserve, RemainingQtyToReserve, ReservEntry.Description,
                          ReservEntry."Shipment Date");
                        UpdateReservFrom();
                        IF QtyReservedBefore = QtyReserved THEN
                            ERROR(Text002Msg);
                    end;
                }
                action("&Cancel Reservation from Current Line")
                {
                    Caption = '&Cancel Reservation from Current Line';
                    Image = Cancel;

                    trigger OnAction()
                    var
                        ReservEntry3: Record "Reservation Entry";
                        RecordsFound: Boolean;
                    begin
                        IF NOT CONFIRM(Text003Msg, FALSE, Rec."Summary Type") THEN
                            EXIT;
                        CLEAR(ReservEntry2);
                        ReservEntry2 := ReservEntry;
                        //ReservMgt.SetPointerFilter(ReservEntry2);
                        ReservEntry2.SETRANGE("Reservation Status", ReservEntry2."Reservation Status"::Reservation);
                        IF ReservEntry2.FIND('-') THEN
                            REPEAT
                                ReservEntry3.GET(ReservEntry2."Entry No.", NOT ReservEntry2.Positive);
                                IF RelatesToSummEntry(ReservEntry3, Rec) THEN
                                    RecordsFound := TRUE;
                            UNTIL ReservEntry2.NEXT() = 0;

                        IF RecordsFound THEN
                            UpdateReservFrom()
                        ELSE
                            ERROR(Text005Msg);
                    end;
                }
            }
        }
    }

    trigger OnFindRecord(Which: Text): Boolean
    begin
        ReservSummEntry := Rec;
        IF NOT ReservSummEntry.FIND(Which) THEN
            EXIT(FALSE);
        Rec := ReservSummEntry;
        EXIT(TRUE);
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        ReservSummEntry := Rec;
        CurrentSteps := ReservSummEntry.NEXT(Steps);
        IF CurrentSteps <> 0 THEN
            Rec := ReservSummEntry;
        EXIT(CurrentSteps);
    end;

    trigger OnOpenPage()
    begin
        FormIsOpen := TRUE;
    end;

    var
        ReservEntry: Record "Reservation Entry";
        ReservEntry2: Record "Reservation Entry";
        SalesLine: Record "Sales Line";
        PurchLine: Record "Purchase Line";
        ItemJnlLine: Record "Item Journal Line";
        ReqLine: Record "Requisition Line";
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderComp: Record "Prod. Order Component";
        PlanningComponent: Record "Planning Component";
        ServiceInvLine: Record "Service Line";
        TransLine: Record "Transfer Line";
        ReservSummEntry: Record "Entry Summary" temporary;
        ReservMgt: Codeunit "Reservation Management";
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        ReserveSalesLine: Codeunit "Sales Line-Reserve";
        ReserveReqLine: Codeunit "Req. Line-Reserve";
        ReservePurchLine: Codeunit "Purch. Line-Reserve";
        ReserveItemJnlLine: Codeunit "Item Jnl. Line-Reserve";
        ReserveProdOrderLine: Codeunit "Prod. Order Line-Reserve";
        ReserveProdOrderComp: Codeunit "Prod. Order Comp.-Reserve";
        ReservePlanningComponent: Codeunit "Plng. Component-Reserve";
        ReserveServiceInvLine: Codeunit "Service Line-Reserve";
        ReserveTransLine: Codeunit "Transfer Line-Reserve";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        AvailableSalesLines: Page "Available - Sales Lines";
        AvailablePurchLines: Page "Available - Purchase Lines";
        AvailableItemLedgEntries: Page "Available - Item Ledg. Entries";
        AvailableReqLines: Page "Available - Requisition Lines";
        AvailableProdOrderLines: Page "Available - Prod. Order Lines";
        AvailableProdOrderComps: Page "Available - Prod. Order Comp.";
        AvailablePlanningComponents: Page "Avail. - Planning Components";
        AvailableServiceInvLines: Page "Available - Service Lines";
        AvailableTransLines: Page "Available - Transfer Lines";
        AvailableItemTrackingLines: Page "Avail. - Item Tracking Lines";
        CurrentSteps: Integer;
        QtyToReserve: Decimal;
        QtyReserved: Decimal;
        ItemTrackingQtyToReserve: Decimal;
        RemainingQtyToReserve: Decimal;
        QtyReservedBefore: Decimal;
        DecGQtyToReserv: Decimal;
        CaptionText: Text[130];
        FullAutoReservation: Boolean;
        UnitOfMeasureCode: Code[10];
        FormIsOpen: Boolean;
        HandleItemTracking: Boolean;
        Text006Msg: Label 'Do you wish to reserve specific serial and/or lot numbers?';
        Text007Msg: Label ', %1 %2';
        Text008Msg: Label 'Action cancelled.';
        Text000Msg: Label 'Fully reserved.';
        Text001Msg: Label 'Full automatic Reservation not possible.\Reserve manually.';
        Text002Msg: Label 'There is nothing available to reserve.';
        Text003Msg: Label 'Do you want to cancel all reservations in the %1?';
        Text005Msg: Label 'There are no reservations to cancel.';

    procedure SetSalesLine(var CurrentSalesLine: Record "Sales Line")
    begin
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
        UnitOfMeasureCode := SalesLine."Unit of Measure Code";

        CaptionText := ReserveSalesLine.Caption(SalesLine);
        UpdateReservFrom();
    end;

    procedure SetReqLine(var CurrentReqLine: Record "Requisition Line")
    begin
        CurrentReqLine.TESTFIELD("Sales Order No.", '');
        CurrentReqLine.TESTFIELD("Sales Order Line No.", 0);
        CurrentReqLine.TESTFIELD("Sell-to Customer No.", '');
        CurrentReqLine.TESTFIELD(Type, CurrentReqLine.Type::Item);
        CurrentReqLine.TESTFIELD("Due Date");

        ReqLine := CurrentReqLine;

        ReservEntry."Source Type" := DATABASE::"Requisition Line";
        ReservEntry."Source ID" := ReqLine."Worksheet Template Name";
        ReservEntry."Source Batch Name" := ReqLine."Journal Batch Name";
        ReservEntry."Source Ref. No." := ReqLine."Line No.";

        ReservEntry."Item No." := ReqLine."No.";
        ReservEntry."Variant Code" := ReqLine."Variant Code";
        ReservEntry."Location Code" := ReqLine."Location Code";
        ReservEntry."Shipment Date" := ReqLine."Due Date";
        UnitOfMeasureCode := ReqLine."Unit of Measure Code";

        CaptionText := ReserveReqLine.Caption(ReqLine);
        UpdateReservFrom();
    end;

    procedure SetPurchLine(var CurrentPurchLine: Record "Purchase Line")
    begin
        CurrentPurchLine.TESTFIELD("Job No.", '');
        CurrentPurchLine.TESTFIELD("Drop Shipment", FALSE);
        CurrentPurchLine.TESTFIELD(Type, CurrentPurchLine.Type::Item);
        CurrentPurchLine.TESTFIELD("Expected Receipt Date");

        PurchLine := CurrentPurchLine;
        ReservEntry."Source Type" := DATABASE::"Purchase Line";
        ReservEntry."Source Subtype" := PurchLine."Document Type";
        ReservEntry."Source ID" := PurchLine."Document No.";
        ReservEntry."Source Ref. No." := PurchLine."Line No.";

        ReservEntry."Item No." := PurchLine."No.";
        ReservEntry."Variant Code" := PurchLine."Variant Code";
        ReservEntry."Location Code" := PurchLine."Location Code";
        ReservEntry."Shipment Date" := PurchLine."Expected Receipt Date";
        UnitOfMeasureCode := PurchLine."Unit of Measure Code";

        CaptionText := ReservePurchLine.Caption(PurchLine);
        UpdateReservFrom();
    end;

    procedure SetItemJnlLine(var CurrentItemJnlLine: Record "Item Journal Line")
    begin
        CurrentItemJnlLine.TESTFIELD("Drop Shipment", FALSE);
        CurrentItemJnlLine.TESTFIELD("Posting Date");

        ItemJnlLine := CurrentItemJnlLine;
        ReservEntry."Source Type" := DATABASE::"Item Journal Line";
        ReservEntry."Source Subtype" := ItemJnlLine."Entry Type";
        ReservEntry."Source ID" := ItemJnlLine."Journal Template Name";
        ReservEntry."Source Batch Name" := ItemJnlLine."Journal Batch Name";
        ReservEntry."Source Ref. No." := ItemJnlLine."Line No.";

        ReservEntry."Item No." := ItemJnlLine."Item No.";
        ReservEntry."Variant Code" := ItemJnlLine."Variant Code";
        ReservEntry."Location Code" := ItemJnlLine."Location Code";
        ReservEntry."Shipment Date" := ItemJnlLine."Posting Date";
        UnitOfMeasureCode := ItemJnlLine."Unit of Measure Code";

        CaptionText := ReserveItemJnlLine.Caption(ItemJnlLine);
        UpdateReservFrom();
    end;

    procedure SetProdOrderLine(var CurrentProdOrderLine: Record "Prod. Order Line")
    begin
        CurrentProdOrderLine.TESTFIELD("Due Date");

        ProdOrderLine := CurrentProdOrderLine;
        ReservEntry."Source Type" := DATABASE::"Prod. Order Line";
        ReservEntry."Source Subtype" := ProdOrderLine.Status;
        ReservEntry."Source ID" := ProdOrderLine."Prod. Order No.";
        ReservEntry."Source Prod. Order Line" := ProdOrderLine."Line No.";

        ReservEntry."Item No." := ProdOrderLine."Item No.";
        ReservEntry."Variant Code" := ProdOrderLine."Variant Code";
        ReservEntry."Location Code" := ProdOrderLine."Location Code";
        ReservEntry."Shipment Date" := ProdOrderLine."Due Date";
        UnitOfMeasureCode := ProdOrderLine."Unit of Measure Code";

        CaptionText := ReserveProdOrderLine.Caption(ProdOrderLine);
        UpdateReservFrom();
    end;

    procedure SetProdOrderComponent(var CurrentProdOrderComp: Record "Prod. Order Component")
    begin
        CurrentProdOrderComp.TESTFIELD("Due Date");

        ProdOrderComp := CurrentProdOrderComp;
        ReservEntry."Source Type" := DATABASE::"Prod. Order Component";
        ReservEntry."Source Subtype" := ProdOrderComp.Status;
        ReservEntry."Source ID" := ProdOrderComp."Prod. Order No.";
        ReservEntry."Source Prod. Order Line" := ProdOrderComp."Prod. Order Line No.";
        ReservEntry."Source Ref. No." := ProdOrderComp."Line No.";

        ReservEntry."Item No." := ProdOrderComp."Item No.";
        ReservEntry."Variant Code" := ProdOrderComp."Variant Code";
        ReservEntry."Location Code" := ProdOrderComp."Location Code";
        ReservEntry."Shipment Date" := ProdOrderComp."Due Date";
        UnitOfMeasureCode := ProdOrderComp."Unit of Measure Code";

        CaptionText := ReserveProdOrderComp.Caption(ProdOrderComp);
        UpdateReservFrom();
    end;

    procedure SetPlanningComponent(var CurrentPlanningComponent: Record "Planning Component")
    begin
        CurrentPlanningComponent.TESTFIELD("Due Date");

        PlanningComponent := CurrentPlanningComponent;
        ReservEntry."Source Type" := DATABASE::"Planning Component";
        ReservEntry."Source ID" := PlanningComponent."Worksheet Template Name";
        ReservEntry."Source Batch Name" := PlanningComponent."Worksheet Batch Name";
        ReservEntry."Source Prod. Order Line" := PlanningComponent."Worksheet Line No.";
        ReservEntry."Source Ref. No." := PlanningComponent."Line No.";

        ReservEntry."Item No." := PlanningComponent."Item No.";
        ReservEntry."Variant Code" := PlanningComponent."Variant Code";
        ReservEntry."Location Code" := PlanningComponent."Location Code";
        ReservEntry."Shipment Date" := PlanningComponent."Due Date";
        UnitOfMeasureCode := PlanningComponent."Unit of Measure Code";

        CaptionText := ReservePlanningComponent.Caption(PlanningComponent);
        UpdateReservFrom();
    end;

    procedure SetTransLine(CurrentTransLine: Record "Transfer Line"; Direction: Option Outbound,Inbound)
    begin
        CLEARALL();

        TransLine := CurrentTransLine;
        ReservEntry."Source Type" := DATABASE::"Transfer Line";
        ReservEntry."Source Subtype" := Direction;
        ReservEntry."Source ID" := CurrentTransLine."Document No.";
        ReservEntry."Source Prod. Order Line" := CurrentTransLine."Derived From Line No.";
        ReservEntry."Source Ref. No." := CurrentTransLine."Line No.";

        ReservEntry."Item No." := CurrentTransLine."Item No.";
        ReservEntry."Variant Code" := CurrentTransLine."Variant Code";
        CASE Direction OF
            Direction::Outbound:
                BEGIN
                    ReservEntry."Location Code" := CurrentTransLine."Transfer-from Code";
                    ReservEntry."Shipment Date" := CurrentTransLine."Shipment Date";
                END;
            Direction::Inbound:
                BEGIN
                    ReservEntry."Location Code" := CurrentTransLine."Transfer-to Code";
                    ReservEntry."Expected Receipt Date" := CurrentTransLine."Receipt Date";
                END;
        END;

        ReservEntry."Qty. per Unit of Measure" := CurrentTransLine."Qty. per Unit of Measure";

        CaptionText := ReserveTransLine.Caption(TransLine);
        UpdateReservFrom();
    end;

    procedure SetServiceInvLine(var CurrentServiceInvLine: Record "Service Line")
    begin
        CurrentServiceInvLine.TESTFIELD(Type, CurrentServiceInvLine.Type::Item);
        CurrentServiceInvLine.TESTFIELD("Posting Date");

        ServiceInvLine := CurrentServiceInvLine;
        ReservEntry."Source Type" := DATABASE::"Service Invoice Line";
        ReservEntry."Source Subtype" := ServiceInvLine."Document Type";
        ReservEntry."Source ID" := ServiceInvLine."Document No.";
        ReservEntry."Source Ref. No." := ServiceInvLine."Line No.";

        ReservEntry."Item No." := ServiceInvLine."No.";
        ReservEntry."Variant Code" := ServiceInvLine."Variant Code";
        ReservEntry."Location Code" := ServiceInvLine."Location Code";
        ReservEntry."Shipment Date" := ServiceInvLine."Posting Date";
        UnitOfMeasureCode := ServiceInvLine."Unit of Measure Code";

        CaptionText := ReserveServiceInvLine.Caption(ServiceInvLine);
        UpdateReservFrom();
    end;

    procedure SetReservEntry(ReservEntry2: Record "Reservation Entry")
    begin
        ReservEntry := ReservEntry2;
        UpdateReservMgt();
    end;

    procedure FilterReservEntry(var FilterReservEntry: Record "Reservation Entry"; FromReservSummEntry: Record "Entry Summary")
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
                BEGIN // Service Invoice Line
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

    procedure RelatesToSummEntry(var FilterReservEntry: Record "Reservation Entry"; FromReservSummEntry: Record "Entry Summary"): Boolean
    begin
        CASE FromReservSummEntry."Entry No." OF
            1: // Item Ledger Entry
                EXIT((FilterReservEntry."Source Type" = DATABASE::"Item Ledger Entry") AND
                  (FilterReservEntry."Source Subtype" = 0));
            11, 12, 13, 14, 15, 16: // Purchase Line
                EXIT((FilterReservEntry."Source Type" = DATABASE::"Purchase Line") AND
                  (FilterReservEntry."Source Subtype" = FromReservSummEntry."Entry No." - 11));
            21: // Requisition Line
                EXIT((FilterReservEntry."Source Type" = DATABASE::"Requisition Line") AND
                  (FilterReservEntry."Source Subtype" = 0));
            31, 32, 33, 34, 35, 36: // Sales Line
                EXIT((FilterReservEntry."Source Type" = DATABASE::"Sales Line") AND
                  (FilterReservEntry."Source Subtype" = FromReservSummEntry."Entry No." - 31));
            41, 42, 43, 44, 45: // Item Journal Line
                EXIT((FilterReservEntry."Source Type" = DATABASE::"Item Journal Line") AND
                  (FilterReservEntry."Source Subtype" = FromReservSummEntry."Entry No." - 41));
            61, 62, 63, 64: // Prod. Order
                EXIT((FilterReservEntry."Source Type" = DATABASE::"Prod. Order Line") AND
                  (FilterReservEntry."Source Subtype" = FromReservSummEntry."Entry No." - 61));
            71, 72, 73, 74: // Prod. Order Component
                EXIT((FilterReservEntry."Source Type" = DATABASE::"Prod. Order Component") AND
                  (FilterReservEntry."Source Subtype" = FromReservSummEntry."Entry No." - 71));
            91: // Planning Component
                EXIT((FilterReservEntry."Source Type" = DATABASE::"Planning Component") AND
                  (FilterReservEntry."Source Subtype" = 0));
            101, 102: // Transfer Line
                EXIT((FilterReservEntry."Source Type" = DATABASE::"Transfer Line") AND
                  (FilterReservEntry."Source Subtype" = FromReservSummEntry."Entry No." - 101));
            110: // Service Invoice Line
                EXIT((FilterReservEntry."Source Type" = DATABASE::"Service Line") AND
                  (FilterReservEntry."Source Subtype" = 0));
        END;
    end;

    procedure UpdateReservFrom()
    begin
        IF NOT FormIsOpen THEN
            GetSerialLotNo();

        CASE ReservEntry."Source Type" OF
            DATABASE::"Sales Line":
                BEGIN
                    SalesLine.FIND;
                    SalesLine.CALCFIELDS("Reserved Qty. (Base)");
                    IF SalesLine."Document Type" = SalesLine."Document Type"::"Return Order" THEN
                        SalesLine."Reserved Qty. (Base)" := -SalesLine."Reserved Qty. (Base)";
                    QtyReserved := SalesLine."Reserved Qty. (Base)";
                    QtyToReserve := SalesLine."Outstanding Qty. (Base)";
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
                    ServiceInvLine.FIND;
                    ServiceInvLine.CALCFIELDS("VAT Bus. Posting Group");
                    QtyReserved := ServiceInvLine."Reserved Qty. (Base)";
                    QtyToReserve := ServiceInvLine."Outstanding Qty. (Base)";
                END;
        END;

        UpdateReservMgt();
        ReservMgt.UpdateStatistics(
          ReservSummEntry, ReservEntry."Shipment Date", HandleItemTracking);

        IF HandleItemTracking THEN BEGIN
            QtyReserved := 0;
            IF ReservSummEntry.FIND('-') THEN
                REPEAT
                    QtyReserved += ReservedThisLine(ReservSummEntry);
                UNTIL ReservSummEntry.NEXT() = 0;
            QtyToReserve := ItemTrackingQtyToReserve;
        END;

        IF FormIsOpen THEN
            CurrPage.UPDATE();

        DecGQtyToReserv := 0;
    end;

    procedure UpdateReservMgt()
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
                ReservMgt.SetServLine(ServiceInvLine);
        END;
        ReservMgt.SetSerialLotNo(ReservEntry."Serial No.", ReservEntry."Lot No.");
    end;

    procedure DrillDownTotalQuantity()
    var
        Location: Record Location;
        CreatePick: Codeunit "Create Pick";
    begin
        IF HandleItemTracking AND (Rec."Entry No." <> 1) THEN BEGIN
            CLEAR(AvailableItemTrackingLines);
            AvailableItemTrackingLines.SetItemTrackingLine(Rec."Table ID", Rec."Source Subtype", ReservEntry,
              ReservMgt.IsPositive(), ReservEntry."Shipment Date");
            AvailableItemTrackingLines.RUNMODAL();
            EXIT;
        END;

        ReservEntry2 := ReservEntry;
        IF NOT Location.GET(ReservEntry2."Location Code") THEN
            CLEAR(Location);

        CASE Rec."Entry No." OF
            1:
                BEGIN // Item Ledger Entry
                    CLEAR(AvailableItemLedgEntries);
                    CASE ReservEntry2."Source Type" OF
                        DATABASE::"Sales Line":
                            BEGIN
                                AvailableItemLedgEntries.SetSalesLine(SalesLine, ReservEntry2);
                                IF (Location."Bin Mandatory") OR (Location."Require Pick") THEN
                                    AvailableItemLedgEntries.SetTotalAvailQty(
                                      Rec."Total Available Quantity" +
                                      CreatePick.CheckOutBound(
                                        ReservEntry2."Source Type", ReservEntry2."Source Subtype",
                                        ReservEntry2."Source ID", ReservEntry2."Source Ref. No.",
                                        ReservEntry2."Source Prod. Order Line"))
                                ELSE
                                    AvailableItemLedgEntries.SetTotalAvailQty(Rec."Total Available Quantity");
                                AvailableItemLedgEntries.SetMaxQtyToReserve(QtyToReserve - QtyReserved);
                                AvailableItemLedgEntries.RUNMODAL;
                            END;
                        DATABASE::"Requisition Line":
                            BEGIN
                                AvailableItemLedgEntries.SetReqLine(ReqLine, ReservEntry2);
                                AvailableItemLedgEntries.RUNMODAL;
                            END;
                        DATABASE::"Purchase Line":
                            BEGIN
                                AvailableItemLedgEntries.SetPurchLine(PurchLine, ReservEntry2);
                                IF (Location."Bin Mandatory") OR (Location."Require Pick") AND
                                   (PurchLine."Document Type" = PurchLine."Document Type"::"Return Order")
                                THEN
                                    AvailableItemLedgEntries.SetTotalAvailQty(
                                      Rec."Total Available Quantity" +
                                      CreatePick.CheckOutBound(
                                        ReservEntry2."Source Type", ReservEntry2."Source Subtype",
                                        ReservEntry2."Source ID", ReservEntry2."Source Ref. No.",
                                        ReservEntry2."Source Prod. Order Line"))
                                ELSE
                                    AvailableItemLedgEntries.SetTotalAvailQty(Rec."Total Available Quantity");
                                AvailableItemLedgEntries.RUNMODAL;
                            END;
                        DATABASE::"Prod. Order Line":
                            BEGIN
                                AvailableItemLedgEntries.SetProdOrderLine(ProdOrderLine, ReservEntry2);
                                AvailableItemLedgEntries.RUNMODAL;
                            END;
                        DATABASE::"Prod. Order Component":
                            BEGIN
                                AvailableItemLedgEntries.SetProdOrderComponent(ProdOrderComp, ReservEntry2);
                                IF (Location."Bin Mandatory") OR (Location."Require Pick") THEN
                                    AvailableItemLedgEntries.SetTotalAvailQty(
                                      Rec."Total Available Quantity" +
                                      CreatePick.CheckOutBound(
                                        ReservEntry2."Source Type", ReservEntry2."Source Subtype",
                                        ReservEntry2."Source ID", ReservEntry2."Source Ref. No.",
                                        ReservEntry2."Source Prod. Order Line"))
                                ELSE
                                    AvailableItemLedgEntries.SetTotalAvailQty(Rec."Total Available Quantity");
                                AvailableItemLedgEntries.RUNMODAL;
                            END;
                        DATABASE::"Planning Component":
                            BEGIN
                                AvailableItemLedgEntries.SetPlanningComponent(PlanningComponent, ReservEntry2);
                                AvailableItemLedgEntries.RUNMODAL;
                            END;
                        DATABASE::"Transfer Line":
                            BEGIN
                                AvailableItemLedgEntries.SetTransferLine(TransLine, ReservEntry2, ReservEntry."Source Subtype");
                                IF (Location."Bin Mandatory") OR (Location."Require Pick") THEN
                                    AvailableItemLedgEntries.SetTotalAvailQty(
                                      Rec."Total Available Quantity" +
                                      CreatePick.CheckOutBound(
                                        ReservEntry2."Source Type", ReservEntry2."Source Subtype",
                                        ReservEntry2."Source ID", ReservEntry2."Source Ref. No.",
                                        ReservEntry2."Source Prod. Order Line"))
                                ELSE
                                    AvailableItemLedgEntries.SetTotalAvailQty(Rec."Total Available Quantity");
                                AvailableItemLedgEntries.RUNMODAL;
                            END;
                        DATABASE::"Service Line":
                            BEGIN
                                AvailableItemLedgEntries.SetServiceLine(ServiceInvLine, ReservEntry2);
                                AvailableItemLedgEntries.RUNMODAL;
                            END;
                    END;
                END;
            11, 12, 13, 14, 15, 16:
                BEGIN // Purchase Line
                    CLEAR(AvailablePurchLines);
                    AvailablePurchLines.SetCurrentSubType(Rec."Entry No." - 11);
                    CASE ReservEntry2."Source Type" OF
                        DATABASE::"Sales Line":
                            BEGIN
                                AvailablePurchLines.SetSalesLine(SalesLine, ReservEntry2);
                                AvailablePurchLines.RUNMODAL;
                            END;
                        DATABASE::"Requisition Line":
                            BEGIN
                                AvailablePurchLines.SetReqLine(ReqLine, ReservEntry2);
                                AvailablePurchLines.RUNMODAL;
                            END;
                        DATABASE::"Purchase Line":
                            BEGIN
                                AvailablePurchLines.SetPurchLine(PurchLine, ReservEntry2);
                                AvailablePurchLines.RUNMODAL;
                            END;
                        DATABASE::"Prod. Order Line":
                            BEGIN
                                AvailablePurchLines.SetProdOrderLine(ProdOrderLine, ReservEntry2);
                                AvailablePurchLines.RUNMODAL;
                            END;
                        DATABASE::"Prod. Order Component":
                            BEGIN
                                AvailablePurchLines.SetProdOrderComponent(ProdOrderComp, ReservEntry2);
                                AvailablePurchLines.RUNMODAL;
                            END;
                        DATABASE::"Planning Component":
                            BEGIN
                                AvailablePurchLines.SetPlanningComponent(PlanningComponent, ReservEntry2);
                                AvailablePurchLines.RUNMODAL;
                            END;
                        DATABASE::"Transfer Line":
                            BEGIN
                                AvailablePurchLines.SetTransferLine(TransLine, ReservEntry2, ReservEntry."Source Subtype");
                                AvailablePurchLines.RUNMODAL;
                            END;
                        DATABASE::"Service Line":
                            BEGIN
                                AvailablePurchLines.SetServiceInvLine(ServiceInvLine, ReservEntry2);
                                AvailablePurchLines.RUNMODAL;
                            END;
                    END;
                END;
            21:
                BEGIN // Requisition Line
                    CLEAR(AvailableReqLines);
                    CASE ReservEntry2."Source Type" OF
                        DATABASE::"Sales Line":
                            BEGIN
                                AvailableReqLines.SetSalesLine(SalesLine, ReservEntry2);
                                AvailableReqLines.RUNMODAL;
                            END;
                        DATABASE::"Requisition Line":
                            BEGIN
                                AvailableReqLines.SetReqLine(ReqLine, ReservEntry2);
                                AvailableReqLines.RUNMODAL;
                            END;
                        DATABASE::"Purchase Line":
                            BEGIN
                                AvailableReqLines.SetPurchLine(PurchLine, ReservEntry2);
                                AvailableReqLines.RUNMODAL;
                            END;
                        DATABASE::"Prod. Order Line":
                            BEGIN
                                AvailableReqLines.SetProdOrderLine(ProdOrderLine, ReservEntry2);
                                AvailableReqLines.RUNMODAL;
                            END;
                        DATABASE::"Prod. Order Component":
                            BEGIN
                                AvailableReqLines.SetProdOrderComponent(ProdOrderComp, ReservEntry2);
                                AvailableReqLines.RUNMODAL;
                            END;
                        DATABASE::"Planning Component":
                            BEGIN
                                AvailableReqLines.SetPlanningComponent(PlanningComponent, ReservEntry2);
                                AvailableReqLines.RUNMODAL;
                            END;
                        DATABASE::"Transfer Line":
                            BEGIN
                                AvailableReqLines.SetTransferLine(TransLine, ReservEntry2, ReservEntry."Source Subtype");
                                AvailableReqLines.RUNMODAL;
                            END;
                        DATABASE::"Service Line":
                            BEGIN
                                AvailableReqLines.SetServiceInvLine(ServiceInvLine, ReservEntry2);
                                AvailableReqLines.RUNMODAL;
                            END;
                    END;
                END;
            31, 32, 33, 34, 35, 36:
                BEGIN // Sales Line
                    CLEAR(AvailableSalesLines);
                    AvailableSalesLines.SetCurrentSubType(Rec."Entry No." - 31);
                    CASE ReservEntry2."Source Type" OF
                        DATABASE::"Sales Line":
                            BEGIN
                                AvailableSalesLines.SetSalesLine(SalesLine, ReservEntry2);
                                AvailableSalesLines.RUNMODAL;
                            END;
                        DATABASE::"Requisition Line":
                            BEGIN
                                AvailableSalesLines.SetReqLine(ReqLine, ReservEntry2);
                                AvailableSalesLines.RUNMODAL;
                            END;
                        DATABASE::"Purchase Line":
                            BEGIN
                                AvailableSalesLines.SetPurchLine(PurchLine, ReservEntry2);
                                AvailableSalesLines.RUNMODAL;
                            END;
                        DATABASE::"Prod. Order Line":
                            BEGIN
                                AvailableSalesLines.SetProdOrderLine(ProdOrderLine, ReservEntry2);
                                AvailableSalesLines.RUNMODAL;
                            END;
                        DATABASE::"Prod. Order Component":
                            BEGIN
                                AvailableSalesLines.SetProdOrderComponent(ProdOrderComp, ReservEntry2);
                                AvailableSalesLines.RUNMODAL;
                            END;
                        DATABASE::"Planning Component":
                            BEGIN
                                AvailableSalesLines.SetPlanningComponent(PlanningComponent, ReservEntry2);
                                AvailableSalesLines.RUNMODAL;
                            END;
                        DATABASE::"Transfer Line":
                            BEGIN
                                AvailableSalesLines.SetTransferLine(TransLine, ReservEntry2, ReservEntry."Source Subtype");
                                AvailableSalesLines.RUNMODAL;
                            END;
                        DATABASE::"Service Line":
                            BEGIN
                                AvailableSalesLines.SetServiceInvLine(ServiceInvLine, ReservEntry2);
                                AvailableSalesLines.RUNMODAL;
                            END;
                    END;
                END;
            61, 62, 63, 64:
                BEGIN
                    CLEAR(AvailableProdOrderLines);
                    AvailableProdOrderLines.SetCurrentSubType(Rec."Entry No." - 61);
                    CASE ReservEntry2."Source Type" OF
                        DATABASE::"Sales Line":
                            BEGIN
                                AvailableProdOrderLines.SetSalesLine(SalesLine, ReservEntry2);
                                AvailableProdOrderLines.RUNMODAL;
                            END;
                        DATABASE::"Requisition Line":
                            BEGIN
                                AvailableProdOrderLines.SetReqLine(ReqLine, ReservEntry2);
                                AvailableProdOrderLines.RUNMODAL;
                            END;
                        DATABASE::"Purchase Line":
                            BEGIN
                                AvailableProdOrderLines.SetPurchLine(PurchLine, ReservEntry2);
                                AvailableProdOrderLines.RUNMODAL;
                            END;
                        DATABASE::"Prod. Order Line":
                            BEGIN
                                AvailableProdOrderLines.SetProdOrderLine(ProdOrderLine, ReservEntry2);
                                AvailableProdOrderLines.RUNMODAL;
                            END;
                        DATABASE::"Prod. Order Component":
                            BEGIN
                                AvailableProdOrderLines.SetProdOrderComponent(ProdOrderComp, ReservEntry2);
                                AvailableProdOrderLines.RUNMODAL;
                            END;
                        DATABASE::"Planning Component":
                            BEGIN
                                AvailableProdOrderLines.SetPlanningComponent(PlanningComponent, ReservEntry2);
                                AvailableProdOrderLines.RUNMODAL;
                            END;
                        DATABASE::"Transfer Line":
                            BEGIN
                                AvailableProdOrderLines.SetTransferLine(TransLine, ReservEntry2, ReservEntry."Source Subtype");
                                AvailableProdOrderLines.RUNMODAL;
                            END;
                        DATABASE::"Service Line":
                            BEGIN
                                AvailableProdOrderLines.SetServiceInvLine(ServiceInvLine, ReservEntry2);
                                AvailableProdOrderLines.RUNMODAL;
                            END;
                    END;
                END;
            71, 72, 73, 74:
                BEGIN
                    CLEAR(AvailableProdOrderComps);
                    AvailableProdOrderComps.SetCurrentSubType(Rec."Entry No." - 71);
                    CASE ReservEntry2."Source Type" OF
                        DATABASE::"Sales Line":
                            BEGIN
                                AvailableProdOrderComps.SetSalesLine(SalesLine, ReservEntry2);
                                AvailableProdOrderComps.RUNMODAL;
                            END;
                        DATABASE::"Requisition Line":
                            BEGIN
                                AvailableProdOrderComps.SetReqLine(ReqLine, ReservEntry2);
                                AvailableProdOrderComps.RUNMODAL;
                            END;
                        DATABASE::"Purchase Line":
                            BEGIN
                                AvailableProdOrderComps.SetPurchLine(PurchLine, ReservEntry2);
                                AvailableProdOrderComps.RUNMODAL;
                            END;
                        DATABASE::"Prod. Order Line":
                            BEGIN
                                AvailableProdOrderComps.SetProdOrderLine(ProdOrderLine, ReservEntry2);
                                AvailableProdOrderComps.RUNMODAL;
                            END;
                        DATABASE::"Prod. Order Component":
                            BEGIN
                                AvailableProdOrderComps.SetProdOrderComponent(ProdOrderComp, ReservEntry2);
                                AvailableProdOrderComps.RUNMODAL;
                            END;
                        DATABASE::"Planning Component":
                            BEGIN
                                AvailableProdOrderComps.SetPlanningComponent(PlanningComponent, ReservEntry2);
                                AvailableProdOrderComps.RUNMODAL;
                            END;
                        DATABASE::"Transfer Line":
                            BEGIN
                                AvailableProdOrderComps.SetTransferLine(TransLine, ReservEntry2, ReservEntry."Source Subtype");
                                AvailableProdOrderComps.RUNMODAL;
                            END;
                        DATABASE::"Service Line":
                            BEGIN
                                AvailableProdOrderComps.SetServiceInvLine(ServiceInvLine, ReservEntry2);
                                AvailableProdOrderComps.RUNMODAL;
                            END;
                    END;
                END;
            91:
                BEGIN
                    CLEAR(AvailablePlanningComponents);
                    CASE ReservEntry2."Source Type" OF
                        DATABASE::"Sales Line":
                            BEGIN
                                AvailablePlanningComponents.SetSalesLine(SalesLine, ReservEntry2);
                                AvailablePlanningComponents.RUNMODAL;
                            END;
                        DATABASE::"Requisition Line":
                            BEGIN
                                AvailablePlanningComponents.SetReqLine(ReqLine, ReservEntry2);
                                AvailablePlanningComponents.RUNMODAL;
                            END;
                        DATABASE::"Purchase Line":
                            BEGIN
                                AvailablePlanningComponents.SetPurchLine(PurchLine, ReservEntry2);
                                AvailablePlanningComponents.RUNMODAL;
                            END;
                        DATABASE::"Prod. Order Line":
                            BEGIN
                                AvailablePlanningComponents.SetProdOrderLine(ProdOrderLine, ReservEntry2);
                                AvailablePlanningComponents.RUNMODAL;
                            END;
                        DATABASE::"Prod. Order Component":
                            BEGIN
                                AvailablePlanningComponents.SetProdOrderComponent(ProdOrderComp, ReservEntry2);
                                AvailablePlanningComponents.RUNMODAL;
                            END;
                        DATABASE::"Planning Component":
                            BEGIN
                                AvailablePlanningComponents.SetPlanningComponent(PlanningComponent, ReservEntry2);
                                AvailablePlanningComponents.RUNMODAL;
                            END;
                        DATABASE::"Transfer Line":
                            BEGIN
                                AvailablePlanningComponents.SetTransferLine(TransLine, ReservEntry2, ReservEntry."Source Subtype");
                                AvailablePlanningComponents.RUNMODAL;
                            END;
                        DATABASE::"Service Line":
                            BEGIN
                                AvailablePlanningComponents.SetServiceInvLine(ServiceInvLine, ReservEntry2);
                                AvailablePlanningComponents.RUNMODAL;
                            END;
                    END;
                END;
            101, 102:
                BEGIN
                    CLEAR(AvailableTransLines);
                    CASE ReservEntry2."Source Type" OF
                        DATABASE::"Sales Line":
                            BEGIN
                                AvailableTransLines.SetSalesLine(SalesLine, ReservEntry2);
                                AvailableTransLines.RUNMODAL;
                            END;
                        DATABASE::"Requisition Line":
                            BEGIN
                                AvailableTransLines.SetReqLine(ReqLine, ReservEntry2);
                                AvailableTransLines.RUNMODAL;
                            END;
                        DATABASE::"Purchase Line":
                            BEGIN
                                AvailableTransLines.SetPurchLine(PurchLine, ReservEntry2);
                                AvailableTransLines.RUNMODAL;
                            END;
                        DATABASE::"Prod. Order Line":
                            BEGIN
                                AvailableTransLines.SetProdOrderLine(ProdOrderLine, ReservEntry2);
                                AvailableTransLines.RUNMODAL;
                            END;
                        DATABASE::"Prod. Order Component":
                            BEGIN
                                AvailableTransLines.SetProdOrderComponent(ProdOrderComp, ReservEntry2);
                                AvailableTransLines.RUNMODAL;
                            END;
                        DATABASE::"Planning Component":
                            BEGIN
                                AvailableTransLines.SetPlanningComponent(PlanningComponent, ReservEntry2);
                                AvailableTransLines.RUNMODAL;
                            END;
                        DATABASE::"Transfer Line":
                            BEGIN
                                AvailableTransLines.SetTransferLine(TransLine, ReservEntry2, ReservEntry."Source Subtype");
                                AvailableTransLines.RUNMODAL;
                            END;
                        DATABASE::"Service Line":
                            BEGIN
                                AvailableTransLines.SetServiceInvLine(ServiceInvLine, ReservEntry2);
                                AvailableTransLines.RUNMODAL;
                            END;
                    END;
                END;
            110:
                BEGIN // Service Invoice Line
                    CLEAR(AvailableServiceInvLines);
                    ReservEntry2."Source Subtype" := 0;
                    CASE ReservEntry2."Source Type" OF
                        DATABASE::"Sales Line":
                            BEGIN
                                AvailableServiceInvLines.SetSalesLine(SalesLine, ReservEntry2);
                                AvailableServiceInvLines.RUNMODAL;
                            END;
                        DATABASE::"Requisition Line":
                            BEGIN
                                AvailableServiceInvLines.SetReqLine(ReqLine, ReservEntry2);
                                AvailableServiceInvLines.RUNMODAL;
                            END;
                        DATABASE::"Purchase Line":
                            BEGIN
                                AvailableServiceInvLines.SetPurchLine(PurchLine, ReservEntry2);
                                AvailableServiceInvLines.RUNMODAL;
                            END;
                        DATABASE::"Prod. Order Line":
                            BEGIN
                                AvailableServiceInvLines.SetProdOrderLine(ProdOrderLine, ReservEntry2);
                                AvailableServiceInvLines.RUNMODAL;
                            END;
                        DATABASE::"Prod. Order Component":
                            BEGIN
                                AvailableServiceInvLines.SetProdOrderComponent(ProdOrderComp, ReservEntry2);
                                AvailableServiceInvLines.RUNMODAL;
                            END;
                        DATABASE::"Planning Component":
                            BEGIN
                                AvailableServiceInvLines.SetPlanningComponent(PlanningComponent, ReservEntry2);
                                AvailableServiceInvLines.RUNMODAL;
                            END;
                        DATABASE::"Transfer Line":
                            BEGIN
                                AvailableServiceInvLines.SetTransferLine(TransLine, ReservEntry2, ReservEntry."Source Subtype");
                                AvailableServiceInvLines.RUNMODAL;
                            END;
                        DATABASE::"Service Line":
                            BEGIN
                                AvailableServiceInvLines.SetServInvLine(ServiceInvLine, ReservEntry2);
                                AvailableServiceInvLines.RUNMODAL;
                            END;
                    END;
                END;
        END;

        UpdateReservFrom();
    end;

    procedure DrillDownReservedQuantity()
    begin
        ReservEntry2.RESET();

        ReservEntry2.SETCURRENTKEY(
          "Item No.", "Source Type", "Source Subtype", "Reservation Status", "Location Code", "Variant Code",
          "Shipment Date", "Expected Receipt Date", "Serial No.", "Lot No.");

        FilterReservEntry(ReservEntry2, Rec);
        PAGE.RUNMODAL(PAGE::"Reservation Entries", ReservEntry2);

        UpdateReservFrom();
    end;

    procedure DrillDownReservedThisLine()
    var
        ReservEntry3: Record "Reservation Entry";
        LotSNMatch: Boolean;
    begin
        CLEAR(ReservEntry2);

        ReservEntry2.SETCURRENTKEY(
          "Item No.", "Source Type", "Source Subtype", "Reservation Status", "Location Code", "Variant Code",
          "Shipment Date", "Expected Receipt Date", "Serial No.", "Lot No.");

        FilterReservEntry(ReservEntry2, Rec);
        IF ReservEntry2.FIND('-') THEN
            REPEAT
                ReservEntry3.GET(ReservEntry2."Entry No.", NOT ReservEntry2.Positive);

                IF (ReservEntry."Serial No." <> '') OR (ReservEntry."Lot No." <> '') THEN
                    LotSNMatch := (ReservEntry3."Serial No." = ReservEntry."Serial No.") AND
                                  (ReservEntry3."Lot No." = ReservEntry."Lot No.")
                ELSE
                    LotSNMatch := TRUE;

                ReservEntry2.MARK((ReservEntry3."Source Type" = ReservEntry."Source Type") AND
                                  (ReservEntry3."Source Subtype" = ReservEntry."Source Subtype") AND
                                  (ReservEntry3."Source ID" = ReservEntry."Source ID") AND
                                  (ReservEntry3."Source Batch Name" = ReservEntry."Source Batch Name") AND
                                  (ReservEntry3."Source Prod. Order Line" = ReservEntry."Source Prod. Order Line") AND
                                  (ReservEntry3."Source Ref. No." = ReservEntry."Source Ref. No.") AND
                                  ((LotSNMatch AND HandleItemTracking) OR
                                   NOT HandleItemTracking));
            UNTIL ReservEntry2.NEXT() = 0;

        ReservEntry2.MARKEDONLY(TRUE);
        PAGE.RUNMODAL(PAGE::"Reservation Entries", ReservEntry2);

        UpdateReservFrom();
    end;

    procedure ReservedThisLine(ReservSummEntry2: Record "Entry Summary" temporary) ReservedQuantity: Decimal
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

    procedure GetSerialLotNo()
    var
        Item: Record Item;
        ReservEntry2: Record "Reservation Entry";
        TempReservEntry: Record "Reservation Entry" temporary;
        TempTrackingSpecification: Record "Tracking Specification" temporary;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
    begin
        Item.GET(ReservEntry."Item No.");
        IF Item."Item Tracking Code" = '' THEN
            EXIT;
        ReservEntry2 := ReservEntry;
        ItemTrackingMgt.SumUpItemTracking(ReservEntry2, TempTrackingSpecification, TRUE, TRUE);

        IF TempTrackingSpecification.FIND('-') THEN BEGIN
            IF NOT CONFIRM(STRSUBSTNO(Text006Msg, ReservEntry2.FIELDCAPTION("Serial No."),
                           ReservEntry2.FIELDCAPTION("Lot No.")), TRUE) THEN
                EXIT;
            REPEAT
                TempReservEntry.TRANSFERFIELDS(TempTrackingSpecification);
                TempReservEntry.INSERT();
            UNTIL TempTrackingSpecification.NEXT() = 0;

            IF PAGE.RUNMODAL(PAGE::"Item Tracking List", TempReservEntry) = ACTION::LookupOK THEN BEGIN
                ReservEntry."Serial No." := TempReservEntry."Serial No.";
                ReservEntry."Lot No." := TempReservEntry."Lot No.";
                CaptionText += STRSUBSTNO(Text007Msg, ReservEntry."Serial No.", ReservEntry."Lot No.");
                ItemTrackingQtyToReserve :=
                  TempReservEntry."Quantity (Base)" * CreateReservEntry.SignFactor(TempReservEntry);
                HandleItemTracking := TRUE;
            END ELSE
                ERROR(Text008Msg);
        END;
    end;
}

