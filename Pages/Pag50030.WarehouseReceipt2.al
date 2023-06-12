page 50030 "Warehouse Receipt2"
{
    // version ALG2.00,MIG2009R2

    // ------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // ------------------------------------------------------------------------
    // //>>ALG2.00
    // FED-ALGO-20100222-ACHAT01.001:MA 01/04/2010  Page Planning Reception
    //                                                Create Table

    Caption = 'Warehouse Receipt';
    PageType = Card;
    PopulateAllFields = true;
    RefreshOnActivate = true;
    SourceTable = "Warehouse Receipt Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnAssistEdit()
                    begin
                        IF Rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE();
                    end;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        CurrPage.SAVERECORD();
                        Rec.LookupLocation(Rec);
                        CurrPage.UPDATE(TRUE);
                    end;
                }
                field("Zone Code"; Rec."Zone Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Document Status"; Rec."Document Status")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Vendor Shipment No."; Rec."Vendor Shipment No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Assigned User ID"; Rec."Assigned User ID")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Assignment Date"; Rec."Assignment Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Assignment Time"; Rec."Assignment Time")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Sorting Method"; Rec."Sorting Method")
                {
                    ApplicationArea = Basic, Suite;
                    OptionCaption = ' ,Item,Document,Shelf or Bin,Due Date ';

                    trigger OnValidate()
                    begin
                        SortingMethodOnAfterValidate();
                    end;
                }
            }
            part(WhseReceiptLines; "Whse. Receipt Subform2")
            {
                SubPageLink = "No." = FIELD("No.");
                SubPageView = SORTING("No.", "Sorting Sequence No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Receipt")
            {
                Caption = '&Receipt';
                action(List)
                {
                    Caption = 'List';
                    Image = Receipt;

                    trigger OnAction()
                    begin
                        LookupWhseRcptHeader(Rec);
                    end;
                }
                action("Co&mments")
                {
                    Caption = 'Comments';
                    Image = ViewComments;
                    RunObject = Page "Warehouse Comment Sheet";
                }
                action("Posted &Whse. Receipts")
                {
                    Caption = 'Posted &Whse. Receipts';
                    Image = PostedReceipts;


                    RunObject = Page "Posted Whse. Receipt";
                    RunPageView = SORTING("Whse. Receipt No.");
                }
            }
            group("&Line")
            {
                Caption = '&Line';
                action("Source &Document Line")
                {
                    Caption = 'Source &Document Line';
                    Image = SourceDocLine;

                    trigger OnAction()
                    begin
                        CurrPage.WhseReceiptLines.Page.ShowSourceLine();
                    end;
                }
                action("&Bin Contents List")
                {
                    Caption = '&Bin Contents List';
                    Image = BinContent;

                    trigger OnAction()
                    begin
                        CurrPage.WhseReceiptLines.Page.ShowBinContents();
                    end;
                }
                group("Item Availability by")
                {
                    Caption = 'Item Availability by';
                    action(Period)
                    {
                        Caption = 'Period';
                        Image = ItemAvailability;

                        trigger OnAction()
                        begin
                            CurrPage.WhseReceiptLines.Page.ItemAvailability(0);
                        end;
                    }
                    action(Variant)
                    {
                        Caption = 'Variant';
                        Image = ItemAvailability;

                        trigger OnAction()
                        begin
                            CurrPage.WhseReceiptLines.Page.ItemAvailability(1);
                        end;
                    }
                    action(Location)
                    {
                        Caption = 'Location';
                        Image = Warehouse;

                        trigger OnAction()
                        begin
                            CurrPage.WhseReceiptLines.Page.ItemAvailability(2);
                        end;
                    }
                }
                action("Item &Tracking Lines")
                {
                    Caption = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;

                    trigger OnAction()
                    begin
                        CurrPage.WhseReceiptLines.Page.OpenItemTrackingLines();
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Use Filters to Get Src. Docs.")
                {
                    Caption = 'Use Filters to Get Src. Docs.';
                    Ellipsis = true;
                    Image = UseFilters;

                    trigger OnAction()
                    var
                        GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";
                    begin
                        GetSourceDocInbound.GetInboundDocs(Rec);
                        Rec."Document Status" := Rec.GetHeaderStatus(0);
                        Rec.MODIFY();
                    end;
                }
                action("Get Source Documents")
                {
                    Caption = 'Get Source Documents';
                    Ellipsis = true;
                    Image = GetSourceDoc;

                    trigger OnAction()
                    var
                        GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";
                    begin
                        GetSourceDocInbound.GetSingleInboundDoc(Rec);
                        Rec."Document Status" := Rec.GetHeaderStatus(0);
                        Rec.MODIFY();
                    end;
                }
                separator(Separator1)
                {
                    Caption = '';
                }
                action("Autofill Qty. to Receive")
                {
                    Caption = 'Autofill Qty. to Receive';
                    Image = AutofillQtyToHandle;

                    trigger OnAction()
                    begin
                        CurrPage.WhseReceiptLines.Page.AutofillQtyToReceive();
                    end;
                }
                action("Delete Qty. to Receive")
                {
                    Caption = 'Delete Qty. to Receive';
                    Image = DeleteQtyToHandle;

                    trigger OnAction()
                    begin
                        CurrPage.WhseReceiptLines.Page.DeleteQtyToReceive();
                    end;
                }
                separator(Separator2)
                {
                }
                action("Calculate Cross-Dock")
                {
                    Caption = 'Calculate Cross-Dock';
                    Image = CalculateCrossDock;

                    trigger OnAction()
                    var
                        CrossDockOpp: Record "Whse. Cross-Dock Opportunity";
                        CrossDockMgt: Codeunit "Whse. Cross-Dock Management";
                    begin
                        CrossDockMgt.CalculateCrossDockLines(CrossDockOpp, '', Rec."No.", Rec."Location Code");
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                action("P&ost Receipt")
                {
                    Caption = 'P&ost Receipt';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        CurrPage.WhseReceiptLines.Page.WhsePostRcptYesNo2();
                        CurrPage.CLOSE();
                    end;
                }
                action("Post and &Print")
                {
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        CurrPage.WhseReceiptLines.Page.WhsePostRcptPrint();
                        CurrPage.CLOSE();
                    end;
                }
            }
            action("&Print")
            {
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    WhseDocPrint.PrintRcptHeader(Rec);
                end;
            }
        }
    }


    var
        WhseDocPrint: Codeunit "Warehouse Document-Print";

    local procedure SortingMethodOnAfterValidate()
    begin
        CurrPage.UPDATE();
    end;
}

