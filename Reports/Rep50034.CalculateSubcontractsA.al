report 50034 "Calculate Subcontracts-A"
{
    // version NAVW111.00
    // copy from R99001015
    // algo modification

    Caption = 'Calculate Subcontracts';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Work Center"; "Work Center")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Subcontractor No.";
            dataitem("Prod. Order Routing Line"; "Prod. Order Routing Line")
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemTableView = SORTING(Type, "No.") WHERE(Status = CONST(Released), Type = CONST("Work Center"), "Routing Status" = FILTER(< Finished));
                RequestFilterFields = "Prod. Order No.", "Starting Date";

                trigger OnAfterGetRecord()
                begin
                    Window.Update(2, "Prod. Order No.");

                    ProdOrderLine.SetCurrentKey(Status, "Prod. Order No.", "Routing No.", "Routing Reference No.");
                    ProdOrderLine.SetRange(Status, Status);
                    ProdOrderLine.SetRange("Prod. Order No.", "Prod. Order No.");
                    ProdOrderLine.SetRange("Routing No.", "Routing No.");
                    ProdOrderLine.SetRange("Routing Reference No.", "Routing Reference No.");
                    if ProdOrderLine.Find('-') then begin
                        DeleteRepeatedReqLines();
                        repeat
                            BaseQtyToPurch :=
                              CostCalcMgt.CalcQtyAdjdForRoutingScrap(
                                CostCalcMgt.CalcQtyAdjdForBOMScrap(
                                  ProdOrderLine."Quantity (Base)", ProdOrderLine."Scrap %"),
                                "Scrap Factor % (Accumulated)", "Fixed Scrap Qty. (Accum.)") -
                              (CostCalcMgt.CalcOutputQtyBaseOnPurchOrder(ProdOrderLine, "Prod. Order Routing Line") +
                               CostCalcMgt.CalcActOutputQtyBase(ProdOrderLine, "Prod. Order Routing Line"));
                            QtyToPurch := Round(BaseQtyToPurch / ProdOrderLine."Qty. per Unit of Measure", 0.00001);
                            if QtyToPurch > 0 then
                                InsertReqWkshLine();
                        until ProdOrderLine.Next() = 0;
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if "Subcontractor No." = '' then
                    CurrReport.Skip();

                Window.Update(1, "No.");
            end;

            trigger OnPreDataItem()
            begin
                ReqLine.SetRange("Worksheet Template Name", ReqLine."Worksheet Template Name");
                ReqLine.SetRange("Journal Batch Name", ReqLine."Journal Batch Name");
                ReqLine.DeleteAll();
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        MfgSetup.Get();
    end;

    trigger OnPreReport()
    begin
        ReqWkshTmpl.Get(ReqLine."Worksheet Template Name");
        ReqWkShName.Get(ReqLine."Worksheet Template Name", ReqLine."Journal Batch Name");
        ReqLine.SetRange("Worksheet Template Name", ReqLine."Worksheet Template Name");
        ReqLine.SetRange("Journal Batch Name", ReqLine."Journal Batch Name");
        ReqLine.LockTable();

        if ReqLine.FindLast() then
            ReqLine.Init();
        Window.Open(Text000 + Text001);
    end;

    var
        Text000: Label 'Processing Work Centers   #1##########\';
        Text001: Label 'Processing Orders         #2########## ';
        MfgSetup: Record "Manufacturing Setup";
        ReqWkshTmpl: Record "Req. Wksh. Template";
        ReqWkShName: Record "Requisition Wksh. Name";
        ReqLine: Record "Requisition Line";
        ProdOrderLine: Record "Prod. Order Line";
        GLSetup: Record "General Ledger Setup";
        PurchLine: Record "Purchase Line";
        CostCalcMgt: Codeunit "Cost Calculation Management";
        Window: Dialog;
        BaseQtyToPurch: Decimal;
        QtyToPurch: Decimal;
        GLSetupRead: Boolean;


    procedure SetWkShLine(NewReqLine: Record "Requisition Line")
    begin
        ReqLine := NewReqLine;
    end;

    local procedure InsertReqWkshLine()
    begin
        ProdOrderLine.CalcFields("Total Exp. Oper. Output (Qty.)");

        ReqLine.SetSubcontracting(true);
        ReqLine.BlockDynamicTracking(true);

        ReqLine.Init;
        ReqLine."Line No." := ReqLine."Line No." + 10000;
        ReqLine.Validate(Type, ReqLine.Type::Item);
        ReqLine.Validate("No.", ProdOrderLine."Item No.");
        ReqLine.Validate("Variant Code", ProdOrderLine."Variant Code");
        ReqLine.Validate("Unit of Measure Code", ProdOrderLine."Unit of Measure Code");
        ReqLine.Validate(Quantity, QtyToPurch);
        GetGLSetup;
        if ReqLine.Quantity <> 0 then begin
            if "Work Center"."Unit Cost Calculation" = "Work Center"."Unit Cost Calculation"::Units then
                ReqLine.Validate(
                  "Direct Unit Cost",
                  Round(
                    "Prod. Order Routing Line"."Direct Unit Cost" *
                    ProdOrderLine."Qty. per Unit of Measure",
                    GLSetup."Unit-Amount Rounding Precision"))
            else
                ReqLine.Validate(
                  "Direct Unit Cost",
                  Round(
                    ("Prod. Order Routing Line"."Expected Operation Cost Amt." -
                     "Prod. Order Routing Line"."Expected Capacity Ovhd. Cost") /
                    ProdOrderLine."Total Exp. Oper. Output (Qty.)",
                    GLSetup."Unit-Amount Rounding Precision"));
        end else
            ReqLine.Validate("Direct Unit Cost", 0);
        //>>algo
        //"Qty. per Unit of Measure" := 0;
        //"Quantity (Base)" := 0;
        ReqLine."Qty. per Unit of Measure" := ProdOrderLine."Qty. per Unit of Measure";
        ReqLine."Quantity (Base)" := ProdOrderLine."Quantity (Base)";
        //<<algo
        ReqLine."Prod. Order No." := ProdOrderLine."Prod. Order No.";
        ReqLine."Prod. Order Line No." := ProdOrderLine."Line No.";
        ReqLine."Due Date" := "Prod. Order Routing Line"."Ending Date";
        ReqLine."Requester ID" := UserId;
        ReqLine."Location Code" := ProdOrderLine."Location Code";
        ReqLine."Bin Code" := ProdOrderLine."Bin Code";
        ReqLine."Routing Reference No." := "Prod. Order Routing Line"."Routing Reference No.";
        ReqLine."Routing No." := "Prod. Order Routing Line"."Routing No.";
        ReqLine."Operation No." := "Prod. Order Routing Line"."Operation No.";
        ReqLine."Work Center No." := "Prod. Order Routing Line"."Work Center No.";
        ReqLine.Validate("Vendor No.", "Work Center"."Subcontractor No.");
        // Description := "Prod. Order Routing Line".Description;
        ReqLine.Description := ProdorderLine.Description;

        // If purchase order already exist we will change this if possible
        PurchLine.Reset();
        PurchLine.SetCurrentKey("Document Type", Type, "Prod. Order No.", "Prod. Order Line No.", "Routing No.", "Operation No.");
        PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
        PurchLine.SetRange(Type, PurchLine.Type::Item);
        PurchLine.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
        PurchLine.SetRange("Prod. Order Line No.", ProdOrderLine."Line No.");
        PurchLine.SetRange("Routing No.", "Prod. Order Routing Line"."Routing No.");
        PurchLine.SetRange("Operation No.", "Prod. Order Routing Line"."Operation No.");
        PurchLine.SetRange("Planning Flexibility", PurchLine."Planning Flexibility"::Unlimited);
        PurchLine.SetRange("Quantity Received", 0);
        if PurchLine.FindFirst() then begin
            ReqLine.Validate(Quantity, ReqLine.Quantity + PurchLine."Outstanding Quantity");
            ReqLine."Quantity (Base)" := 0;
            ReqLine."Replenishment System" := ReqLine."Replenishment System"::Purchase;
            ReqLine."Ref. Order No." := PurchLine."Document No.";
            ReqLine."Ref. Order Type" := ReqLine."Ref. Order Type"::Purchase;
            ReqLine."Ref. Line No." := PurchLine."Line No.";
            if PurchLine."Expected Receipt Date" = ReqLine."Due Date" then
                ReqLine."Action Message" := ReqLine."Action Message"::"Change Qty."
            else
                ReqLine."Action Message" := ReqLine."Action Message"::"Resched. & Chg. Qty.";
            ReqLine."Accept Action Message" := true;
        end else begin
            ReqLine."Ref. Order No." := ProdOrderLine."Prod. Order No.";
            ReqLine."Ref. Order Type" := ReqLine."Ref. Order Type"::"Prod. Order";
            ReqLine."Ref. Order Status" := ProdOrderLine.Status;
            ReqLine."Ref. Line No." := ProdOrderLine."Line No.";
            ReqLine."Action Message" := ReqLine."Action Message"::New;
            ReqLine."Accept Action Message" := true;
        end;

        if ReqLine."Ref. Order No." <> '' then
            ReqLine.GetDimFromRefOrderLine(true);

        ReqLine.Insert;
    end;

    local procedure GetGLSetup()
    begin
        if not GLSetupRead then
            GLSetup.Get;
        GLSetupRead := true;
    end;

    local procedure DeleteRepeatedReqLines()
    var
        RequisitionLine: Record "Requisition Line";
    begin
        RequisitionLine.SetRange(Type, RequisitionLine.Type::Item);
        RequisitionLine.SetRange("No.", ProdOrderLine."Item No.");
        RequisitionLine.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
        RequisitionLine.SetRange("Prod. Order Line No.", ProdOrderLine."Line No.");
        RequisitionLine.SetRange("Operation No.", "Prod. Order Routing Line"."Operation No.");
        RequisitionLine.DeleteAll(true);
    end;
}

