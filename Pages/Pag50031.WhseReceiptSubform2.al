page 50031 "Whse. Receipt Subform2"
{
    // version ALG2.00,MIG2009R2

    // ------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // ------------------------------------------------------------------------
    // //>>ALG2.00
    // FED-ALGO-20100222-ACHAT01.001:MA 01/04/2010  Form Planning Reception
    //                                                Create Table

    AutoSplitKey = true;
    Caption = 'Whse. Receipt Subform';
    DelayedInsert = true;
    InsertAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Warehouse Receipt Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Source Document"; Rec."Source Document")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Zone Code"; Rec."Zone Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        BinCodeOnAfterValidate();
                    end;
                }
                field("Cross-Dock Zone Code"; Rec."Cross-Dock Zone Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Cross-Dock Bin Code"; Rec."Cross-Dock Bin Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Shelf No."; Rec."Shelf No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Qty. (Base)"; Rec."Qty. (Base)")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Qty. to Receive"; Rec."Qty. to Receive")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;

                    trigger OnValidate()
                    begin
                        QtytoReceiveOnAfterValidate();
                    end;
                }
                field("Qty. to Cross-Dock"; Rec."Qty. to Cross-Dock")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        ShowCrossDockOpp(CrossDockOpp2);
                        CurrPage.UPDATE();
                    end;
                }
                field("Qty. Received"; Rec."Qty. Received")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = true;
                }
                field("Qty. to Receive (Base)"; Rec."Qty. to Receive (Base)")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Qty. to Cross-Dock (Base)"; Rec."Qty. to Cross-Dock (Base)")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        ShowCrossDockOpp(CrossDockOpp2);
                        CurrPage.UPDATE();
                    end;
                }
                field("Qty. Received (Base)"; Rec."Qty. Received (Base)")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Qty. Outstanding"; Rec."Qty. Outstanding")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = true;
                }
                field("Qty. Outstanding (Base)"; Rec."Qty. Outstanding (Base)")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    var
        CrossDockOpp2: Record "Whse. Cross-Dock Opportunity";
        Text001: Label 'Cross-Docking has been disabled for %1 %3 and/or %2 %4.';

    procedure ShowSourceLine()
    var
        WMSMgt: Codeunit "WMS Management";
    begin
        WMSMgt.ShowSourceDocLine(
          Rec."Source Type", Rec."Source Subtype", Rec."Source No.", Rec."Source Line No.", 0);
    end;

    procedure ShowBinContents()
    var
        BinContent: Record "Bin Content";
    begin
        BinContent.ShowBinContents(Rec."Location Code", Rec."Item No.", Rec."Variant Code", Rec."Bin Code");
    end;

    procedure ItemAvailability(AvailabilityType: Option Date,Variant,Location)
    begin
        Message('todo');
        //Rec.ItemAvailability(AvailabilityType);
    end;

    procedure WhsePostRcptPrint()
    var
        WhseRcptLine: Record "Warehouse Receipt Line";
        WhsePostReceiptPrint: Codeunit "Whse.-Post Receipt + Print";
    begin
        WhseRcptLine.COPY(Rec);
        WhsePostReceiptPrint.RUN(WhseRcptLine);
        Rec.RESET();
        Rec.SETCURRENTKEY("No.", "Sorting Sequence No.");
        CurrPage.UPDATE(FALSE);
    end;

    procedure AutofillQtyToReceive()
    var
        WhseRcptLine: Record "Warehouse Receipt Line";
    begin
        WhseRcptLine.COPY(Rec);
        Rec.AutofillQtyToReceive(WhseRcptLine);
    end;

    procedure DeleteQtyToReceive()
    var
        WhseRcptLine: Record "Warehouse Receipt Line";
    begin
        WhseRcptLine.COPY(Rec);
        Rec.DeleteQtyToReceive(WhseRcptLine);
    end;

    procedure OpenItemTrackingLines()
    begin
        Rec.OpenItemTrackingLines();
    end;

    procedure ShowCrossDockOpp(var CrossDockOpp: Record "Whse. Cross-Dock Opportunity" temporary)
    var
        Item: Record Item;
        Location: Record Location;
        CrossDockMgt: Codeunit "Whse. Cross-Dock Management";
        UseCrossDock: Boolean;
    begin
        CrossDockMgt.GetUseCrossDock(UseCrossDock, Rec."Location Code", Rec."Item No.");
        IF NOT UseCrossDock THEN
            ERROR(Text001, Item.TABLECAPTION(), Location.TABLECAPTION(), Rec."Item No.", Rec."Location Code");
        CrossDockMgt.ShowCrossDock(CrossDockOpp, '', Rec."No.", Rec."Line No.", Rec."Location Code", Rec."Item No.", Rec."Variant Code");
    end;

    procedure WhsePostRcptYesNo2()
    var
        WhseRcptLine: Record "Warehouse Receipt Line";
        WhseRcptLine2: Record "Warehouse Receipt Line";
        WhsePostReceiptYesNo: Codeunit "Whse.-Post Receipt (Yes/No)";
    begin
        WhseRcptLine.COPY(Rec);
        WhsePostReceiptYesNo.RUN(WhseRcptLine);
        Rec.RESET();
        Rec.SETCURRENTKEY("No.", "Sorting Sequence No.");
        CurrPage.UPDATE(FALSE);
        WhseRcptLine2.COPY(WhseRcptLine);
        Message('todo');
        //WhseRcptLine2.ToDelete(WhseRcptLine);
    end;

    local procedure BinCodeOnAfterValidate()
    begin
        CurrPage.UPDATE();
    end;

    local procedure QtytoReceiveOnAfterValidate()
    begin
        CurrPage.SAVERECORD();
    end;
}

