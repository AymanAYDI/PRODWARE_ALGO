page 50032 "Whse. Receipt Lines2"
{
    // version ALG2.00,MIG2009R2

    // ------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // ------------------------------------------------------------------------
    // //>>ALG2.00
    // FED-ALGO-20100222-ACHAT01.001:MA 22/04/2010  Form Planning Reception
    //                                                Create Form( copie of form 7342)

    Caption = 'Whse. Receipt Lines';
    Editable = false;
    PageType = Card;
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
                    Visible = false;
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Source Line No."; Rec."Source Line No.")
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
                }
                field("Shelf No."; Rec."Shelf No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = Basic, Suite;
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
                field("Qty. Outstanding"; Rec."Qty. Outstanding")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Qty. Outstanding (Base)"; Rec."Qty. Outstanding (Base)")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Qty. Received"; Rec."Qty. Received")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Qty. Received (Base)"; Rec."Qty. Received (Base)")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic, Suite;
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
                action("Show &Whse. Document")
                {
                    Caption = 'Show &Whse. Document';
                    ShortCutKey = 'Shift+F5';
                    Image = Warehouse;

                    trigger OnAction()
                    var
                        WhseRcptHeader: Record "Warehouse Receipt Header";
                    begin
                        WhseRcptHeader.GET(Rec."No.");
                        PAGE.RUN(PAGE::"Warehouse Receipt2", WhseRcptHeader);
                    end;
                }
            }
        }
    }
}

