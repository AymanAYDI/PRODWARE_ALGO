pageextension 50077 "Posted Whse. Shipment Subform" extends "Posted Whse. Shipment Subform"
{
    //p7338
    layout
    {
        addafter("Shipping Advice")
        {
            field("Initial Quantity"; Rec."Initial Quantity")
            {
                ApplicationArea = ALL;
            }
            field("Tracking No."; Rec."Tracking No.")
            {
                ApplicationArea = ALL;
            }
        }
    }
    actions
    {
        addafter("&Line")
        {
            group(ALGO_)
            {
                Caption = 'ALGO', locked = true;
                Image = Customer;
                action("Information Colisage")
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Image = Shipment;

                    Caption = 'Information Colisage';

                    trigger OnAction()
                    VAR
                        RecLPostedPackingLine: Record "Posted Packing Line ALGO";
                    BEGIN
                        RecLPostedPackingLine.RESET();
                        RecLPostedPackingLine.SETRANGE("Whse.Posted Shipment No.", Rec."No.");
                        RecLPostedPackingLine.SETRANGE("Shipment Document No.", Rec."Whse. Shipment No.");
                        RecLPostedPackingLine.SETRANGE("Shipment Line No.", Rec."Line No.");
                        Page.RUN(page::"Packing Line ALGO", RecLPostedPackingLine);
                    END;
                }
            }
        }
    }
}
