pageextension 50076 "Whse. Shipment Subform" extends "Whse. Shipment Subform"
{
    //p7336
    layout
    {
        addafter("Assemble to Order")
        {
            field(PO; Rec.PO)
            {
                ApplicationArea = ALL;
            }
            field("Cust Ref."; Rec."Cust Ref.")
            {
                ApplicationArea = ALL;
            }
            field(Inventory; Rec.Inventory)
            {
                ApplicationArea = ALL;
            }
            field("Bin Inventory"; Rec."Bin Inventory")
            {
                ApplicationArea = ALL;
            }
            field("Tracking No."; Rec."Tracking No.")
            {
                ApplicationArea = ALL;
            }
            field("In Parcel Qty"; Rec."In Parcel Qty")
            {
                ApplicationArea = ALL;
            }
        }
    }

    actions
    {
        addafter("&Line")
        {
            group(ALGO)
            {
                Caption = 'ALGO', Locked = true;
                Image = Customer;
                action(PackingInformation)
                {
                    caption = 'Packing Information';
                    Image = ShipmentLines;
                    ShortcutKey = F12;
                    trigger OnAction()
                    begin
                        Rec.ShowPackingInformation();
                    end;
                }
            }
        }

    }
    procedure ShowPackingInformation()
    var
        RecLItem: Record Item;
        RecLPackingHeaderAlgo: Record "Packing Header ALGO";
        RecLPackingLineAlgo: Record "Packing Line ALGO";

        FrmLPackingInfo: page "Packing Information ALGO";
    begin
        Rec.TESTFIELD("Source No.");
        Rec.TESTFIELD("Line No.");

        IF NOT Rec.FctTestPackingExist(RecLPackingHeaderAlgo) THEN
            Rec.FctInsertHeaderPacking(RecLPackingHeaderAlgo);

        RecLPackingLineAlgo.RESET();
        RecLPackingLineAlgo.SETFILTER("Packing Document No.", '%1', RecLPackingHeaderAlgo."No.");
        RecLPackingLineAlgo.SETFILTER("Shipment Document No.", '%1', Rec."No.");
        RecLPackingLineAlgo.SETFILTER("Shipment Line No.", '%1', Rec."Line No.");
        FrmLPackingInfo.SETTABLEVIEW(RecLPackingLineAlgo);
        FrmLPackingInfo.GetQty(Rec."Qty. to Ship");
        FrmLPackingInfo.GetItemNo(Rec."Item No.");
        FrmLPackingInfo.FctSetSourceLineNo(Rec."Source Line No.", Rec."Source No.");
        IF RecLItem.GET(Rec."Item No.") THEN BEGIN
            FrmLPackingInfo.GetNetWeight(RecLItem."Net Weight");
            FrmLPackingInfo.GetGrossWeight(RecLItem."Gross Weight");
        END;
        COMMIT();
        FrmLPackingInfo.RUNMODAL();
    end;

    procedure FctTestPackingExist(var RecPackingHeaderAlgo: Record "Packing Header ALGO"): Boolean
    begin
        RecPackingHeaderAlgo.RESET();
        RecPackingHeaderAlgo.SETCURRENTKEY("Warehouse Shipment No.");
        RecPackingHeaderAlgo.SETFILTER("Warehouse Shipment No.", '%1', Rec."No.");
        EXIT(RecPackingHeaderAlgo.FINDFIRST());
    end;

    procedure FctTestPackingExistRaisedError()
    var
        RecLPackingLineAlgo: Record "Packing Line ALGO";
        Text038: Label 'Packing information exists for document No. %1, Lne No. %2.';
    begin
        RecLPackingLineAlgo.RESET();
        RecLPackingLineAlgo.SETFILTER("Shipment Document No.", '%1', Rec."No.");
        RecLPackingLineAlgo.SETFILTER("Shipment Line No.", '%1', Rec."Line No.");
        IF RecLPackingLineAlgo.FINDFIRST() THEN
            ERROR(Text038, Rec."No.", Rec."Line No.");
    end;

    procedure FctInsertHeaderPacking(var RecPackingHeaderAlgo: Record "Packing Header ALGO")
    var
        RecLSalesReceivablesSetup: Record "Sales & Receivables Setup";
        SalesHeader: Record "Sales Header";
        TransferLine: Record "Transfer Line";
        CduLNoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        RecLSalesReceivablesSetup.GET();
        CduLNoSeriesMgt.InitSeries(RecLSalesReceivablesSetup."Packing List No.", RecPackingHeaderAlgo."Series No.", 0D,
                                                                  RecPackingHeaderAlgo."No.", RecPackingHeaderAlgo."Series No.");
        RecPackingHeaderAlgo.INSERT();
        RecPackingHeaderAlgo."Warehouse Shipment No." := Rec."No.";

        CASE Rec."Source Type" OF
            DATABASE::"Sales Line":
                BEGIN
                    SalesHeader.GET(Rec."Source Subtype", Rec."Source No.");
                    RecPackingHeaderAlgo."Customer Code" := SalesHeader."Sell-to Customer No.";
                END;
        END;

        CASE Rec."Source Type" OF
            DATABASE::"Transfer Line":
                BEGIN
                    TransferLine.GET(Rec."Source No.", Rec."Source Line No.");
                    RecPackingHeaderAlgo."Customer Code" := TransferLine."Transfer-to Code";
                END;
        END;

        RecPackingHeaderAlgo.MODIFY();
    end;

}
