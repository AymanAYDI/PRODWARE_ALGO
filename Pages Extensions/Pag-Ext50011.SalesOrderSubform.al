pageextension 50011 "Sales Order Subform" extends "Sales Order Subform"
{
    //p46
    layout
    {
        addafter("Line No.")
        {
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = ALL;
            }
            field(PO; Rec.PO)
            {
                ApplicationArea = ALL;
            }
            field("Currency Code"; Rec."Currency Code")
            {
                ApplicationArea = ALL;
            }
            field("Posting Group"; Rec."Posting Group")
            {
                ApplicationArea = ALL;
            }
            field(PROFORMA; Rec.PROFORMA)
            {
                ApplicationArea = ALL;
            }
            field("Cust Ref."; Rec."Cust Ref.")
            {
                ApplicationArea = ALL;
            }
            field("Outstanding Quantity"; Rec."Outstanding Quantity")
            {
                ApplicationArea = ALL;
            }
            field("MOQ"; Rec.MOQ)
            {
                ApplicationArea = ALL;
            }
            field("Multiple"; Rec.Multiple)
            {
                ApplicationArea = ALL;
            }
        }
    }
    actions
    {
        addafter("O&rder")
        {
            group(ALGO_)
            {
                Caption = 'ALGO', locked = true;
                Image = Customer;
                action("Reserve qty")
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Image = AutoReserve;

                    Caption = 'Reserve qty';

                    trigger OnAction()
                    begin
                        Rec.FctShowReservationQty();
                    end;

                }
            }
        }
    }
    var
        FrmGReservQty: Page "Reservation Qty.";
}
