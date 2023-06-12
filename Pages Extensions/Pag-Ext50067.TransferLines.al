pageextension 50067 "Transfer Lines" extends "Transfer Lines"
{
    //p5749
    layout
    {
        addafter("Unit of Measure")
        {
            field("PF concerned"; Rec."PF concerned")
            {
                ApplicationArea = ALL;
            }
            field("Prod. Order Line No."; Rec."Prod. Order Line No.")
            {
                ApplicationArea = ALL;
            }
            field("Initial Quantity"; Rec."Initial Quantity")
            {
                ApplicationArea = ALL;
            }
            field("Tracking No."; Rec."Tracking No.")
            {
                ApplicationArea = ALL;
            }
            field("Purch. Order No."; Rec."Purch. Order No.")
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
                action("Show Document_")
                {
                    ShortCutKey = "Shift+F7";
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = View;
                    PromotedCategory = Process;

                    Caption = 'Show Document';

                    trigger OnAction()
                    VAR
                        Header: Record "Transfer Header";
                    BEGIN
                        Header.GET(Rec."Document No.");
                        page.RUN(Page::"Transfer Order", Header);
                    END;
                }
            }
        }
    }
}
