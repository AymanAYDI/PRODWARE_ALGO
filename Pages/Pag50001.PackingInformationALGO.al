page 50001 "Packing Information ALGO"
{
    // version ALG.1.0.0.0,ALG1.21,ALGO,CLIC2015-001

    // ------------------------------------------------------------------------
    // 
    // Prodware - www.prodware.fr
    // 
    // ------------------------------------------------------------------------
    // 
    // 
    // //>>ALG1.00.00.00
    // 
    // FEVT004.001 :16/01/2007:DSFT:Management The Packing List
    //                              - Show Form Packing Information to Size Parcel, Parcel/Palet Weight and quantity
    // 
    // FEVT004.002:02/02/2007 JMCA : - Update Form
    //                                 Add Packaging in Caption of Parcel Weight
    // 
    // //>>ALG1.21
    // P18635_002.001 DO:ALMI 18/11/2013  : Insert Po From Order Line
    // 
    // //>>20/07/2015 EMAILHOL : Add Field "Cust Ref."
    // 
    // -------------------------------------------------------------------------

    Caption = 'Packing Information ALGO';
    DelayedInsert = true;
    PageType = Card;
    PopulateAllFields = true;
    SourceTable = "Packing Line ALGO";

    layout
    {
        area(content)
        {
            group("Sub Form Packing Info ALGO")
            {
                field(PackingDocumentNo2; Rec."Packing Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Enabled = true;
                }
                field(ShipmentDocumentNo2; Rec."Shipment Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Shipment Line No."; Rec."Shipment Line No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(DecGLineQty; DecGLineQty)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Total Quantity';
                    Editable = false;
                }
                field(DecGParcelQty; DecGParcelQty)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Parcel Total Quantity';
                    Editable = false;
                }
                field(DecGRemainingQty; DecGRemainingQty)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Remaining Quantity';
                    Editable = false;
                }
                field(CodGLineItem; CodGLineItem)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Item';
                    Editable = false;
                }
                field(DecGNetWeight; DecGNetWeight)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Net Weight';
                    Editable = false;
                }
                field(DecGGrossWeight; DecGGrossWeight)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Gross Weight';
                    Editable = false;
                }
            }
            repeater(Control1)
            {
                field("Packing Document No."; Rec."Packing Document No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Shipment Document No."; Rec."Shipment Document No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Item; Rec.Item)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(PO; Rec.PO)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Parcel No."; Rec."Parcel No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Parcel Weight"; Rec."Parcel Weight")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Parcel Weight (Packaging)';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnValidate()
                    begin
                        //>> FEVT004

                        //InitQty(FALSE,FALSE);
                        //

                        //<< FEVT004;
                        QuantityOnAfterValidate();
                    end;
                }
                field(Pallet; Rec.Pallet)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Pallet Weight"; Rec."Pallet Weight")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Cust Ref."; Rec."Cust Ref.")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        recLSalesLine: Record "Sales Line";
    begin
        Rec."Source Line No." := IntGSourceLineNo;
        Rec."Source No." := CodGSourceDocNo;
        Rec.Item := CodGLineItem;

        //>>ALG1.21
        IF recLSalesLine.GET(recLSalesLine."Document Type"::Order, CodGSourceDocNo, IntGSourceLineNo) THEN
            Rec.PO := recLSalesLine.PO;
        Rec."Cust Ref." := recLSalesLine."Cust Ref.";
        //<<ALG1.21
    end;

    trigger OnOpenPage()
    begin
        OnActivateForm();
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        IF DecGParcelQty > DecGLineQty THEN
            ERROR(Text001, DecGLineQty);
    end;

    var
        DecGLineQty: Decimal;
        DecGParcelQty: Decimal;
        DecGRemainingQty: Decimal;
        DecGNetWeight: Decimal;
        DecGGrossWeight: Decimal;
        IntGNumLine: Integer;
        IntGSourceLineNo: Integer;
        CodGSourceDocNo: Code[20];
        CodGLineItem: Code[20];
        Text001: Label 'You''ve Exceed The Total Quantity  ( %1 )';

    local procedure QuantityOnAfterValidate()
    begin
        //>> FEVT004
        CurrPage.UPDATE(TRUE);
        InitQty(FALSE, FALSE);
        //<< FEVT004
    end;

    local procedure OnActivateForm()
    begin
        //>> FEVT004
        InitQty(FALSE, TRUE);
        CurrPage.UPDATE();
        //<< FEVT004
    end;

    procedure "---MIGRATION2009R2---"()
    begin
    end;

    procedure "---FEVT004--"()
    begin
    end;

    procedure GetQty(Qty: Decimal)
    begin
        //>> FEVT004
        DecGLineQty := Qty;
        //<< FEVT004
    end;

    procedure InitQty(BlnGIsNew: Boolean; OnOpenForm: Boolean)
    var
        RecLPackingLineAlgo: Record "Packing Line ALGO";
    begin
        //>> FEVT004
        DecGParcelQty := 0;
        RecLPackingLineAlgo.RESET();
        RecLPackingLineAlgo.COPY(Rec);
        IF RecLPackingLineAlgo.FINDFIRST() THEN
            REPEAT
                DecGParcelQty += RecLPackingLineAlgo.Quantity;
            UNTIL RecLPackingLineAlgo.NEXT() = 0;

        DecGRemainingQty := DecGLineQty - DecGParcelQty;



    end;

    procedure GetItemNo(CodeItem: Code[20])
    begin
        //>> FEVT004

        CodGLineItem := CodeItem;

        ///<< FEVT004
    end;

    procedure GetNetWeight(WeightParcel: Decimal)
    begin
        //>> FEVT004

        DecGNetWeight := WeightParcel;

        ///<< FEVT004
    end;

    procedure GetGrossWeight(WeightPalett: Decimal)
    begin
        //>> FEVT004

        DecGGrossWeight := WeightPalett;

        ///<< FEVT004
    end;

    procedure GetRemainingQty(RemainingQty: Decimal)
    begin

        //>> FEVT004

        DecGRemainingQty := RemainingQty;

        ///<< FEVT004
    end;

    procedure FctSetSourceLineNo(IntSourceLineNo: Integer; CodSourceDocNo: Code[20])
    begin
        IntGSourceLineNo := IntSourceLineNo;
        CodGSourceDocNo := CodSourceDocNo;
    end;
}

