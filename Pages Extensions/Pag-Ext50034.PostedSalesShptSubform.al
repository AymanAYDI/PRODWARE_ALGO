pageextension 50034 "Posted Sales Shpt. Subform" extends "Posted Sales Shpt. Subform"
{
    //p131
    layout
    {
        addafter(Correction)
        {
            field(PO; Rec.PO)
            {
                ApplicationArea = ALL;
            }
            field(PROFORMA; Rec.PROFORMA)
            {
                ApplicationArea = ALL;
            }
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = ALL;
            }
            field("Cust Ref."; Rec."Cust Ref.")
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
                        RecLPostPackLine: Record "Posted Packing Line ALGO";
                        "RecLLinkPacking/Shipment": Record "Link Packing/Sales Ship.";
                        Txt001: label 'Il n''y a pas de ligne colisage', Locked = true;
                    BEGIN
                        "RecLLinkPacking/Shipment".RESET();
                        "RecLLinkPacking/Shipment".SETFILTER("Sales Shipment No.", Rec."Document No.");
                        IF "RecLLinkPacking/Shipment".FINDFIRST() THEN BEGIN
                            RecLPostPackLine.RESEt();
                            RecLPostPackLine.SETRANGE("Shipment Document No.", "RecLLinkPacking/Shipment"."Whse. Shipment No.");
                            RecLPostPackLine.SETRANGE("Shipment Line No.", Rec."Line No.");

                            page.RUN(page::"Packing Line ALGO", RecLPostPackLine);
                        END
                        ELSE
                            ERROR(Txt001);
                    END;

                }
            }
        }
    }
}
