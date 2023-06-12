pageextension 50016 "Purchase List" extends "Purchase List"
{
    //p53
    layout
    {
        addafter("Currency Code")
        {
            field("Vendor Order No."; Rec."Vendor Order No.")
            {
                ApplicationArea = ALL;
            }
            field(Ship; Rec.Ship)
            {
                ApplicationArea = ALL;
            }
            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = ALL;
            }
            field("Document Date"; Rec."Document Date")
            {
                ApplicationArea = ALL;
            }
        }
    }
}