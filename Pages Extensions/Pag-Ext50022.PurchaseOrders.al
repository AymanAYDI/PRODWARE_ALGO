pageextension 50022 "Purchase Orders" extends "Purchase Orders"
{
    //p56
    layout
    {
        addafter("Line Discount %")
        {
            field("Cross-Reference No."; Rec."Cross-Reference No.")
            {
                ApplicationArea = ALL;
            }
            field("Prod. Order No."; Rec."Prod. Order No.")
            {
                ApplicationArea = ALL;
            }
            field("Location Code"; Rec."Location Code")
            {
                ApplicationArea = ALL;
            }
            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = ALL;
            }
            field("Development Order"; Rec."Development Order")
            {
                ApplicationArea = ALL;
            }
        }
    }
}
