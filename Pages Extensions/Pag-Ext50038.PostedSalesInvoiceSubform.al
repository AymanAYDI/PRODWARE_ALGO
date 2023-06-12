pageextension 50038 "Posted Sales Invoice Subform" extends "Posted Sales Invoice Subform"
{
    //p133
    layout
    {
        addafter("Shortcut Dimension 2 Code")
        {
            field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = ALL;
            }
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = ALL;
            }
            field("Amount Including VAT"; Rec."Amount Including VAT")
            {
                ApplicationArea = ALL;
            }
            field(PO; Rec.PO)
            {
                ApplicationArea = ALL;
            }
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = ALL;
            }
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = ALL;
            }
        }
    }
    actions
    {
        addafter("&Invoice")
        {
            group(ALGO_)
            {
                Caption = 'ALGO', locked = true;
                Image = Customer;
                action("Activate Line")
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Image = Shipment;

                    Caption = 'Activate Line';

                    trigger OnAction()
                    var
                        RecLPackingInformation: Record "Packing Line ALGO";
                    BEGIN
                        RecLPackingInformation.SETRANGE(Pallet, Rec."No.");
                        page.RUN(page::"Packing Line ALGO", RecLPackingInformation);
                    END;
                }
            }
        }
    }
}
