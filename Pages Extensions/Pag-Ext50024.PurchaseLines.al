pageextension 50024 "Purchase Lines" extends "Purchase Lines"
{
    //p518
    layout
    {
        modify(Type)
        {
            Visible = false;
        }
        modify(Description)
        {
            Visible = false;
        }
        modify("Line Amount")
        {
            Visible = false;
        }
        modify("Expected Receipt Date")
        {
            Visible = false;
        }
        addafter("Amt. Rcd. Not Invoiced (LCY)")
        {
            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = ALL;
            }
            field("P.O."; Rec."P.O.")
            {
                ApplicationArea = ALL;
            }
            field("Planned Receipt Date"; Rec."Planned Receipt Date")
            {
                ApplicationArea = ALL;
            }
            field("Planning Flexibility"; Rec."Planning Flexibility")
            {
                ApplicationArea = ALL;
            }
            field("MPS Order"; Rec."MPS Order")
            {
                ApplicationArea = ALL;
            }
            field("Prod. Order No."; Rec."Prod. Order No.")
            {
                ApplicationArea = ALL;
            }
            field("Qty. to Invoice"; Rec."Qty. to Invoice")
            {
                ApplicationArea = ALL;
            }
            field("Amt. Rcd. Not Invoiced"; Rec."Amt. Rcd. Not Invoiced")
            {
                ApplicationArea = ALL;
            }
            field("Promised Receipt Date"; Rec."Promised Receipt Date")
            {
                ApplicationArea = ALL;
            }
        }
    }
}