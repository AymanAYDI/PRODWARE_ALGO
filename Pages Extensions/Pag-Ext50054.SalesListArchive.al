pageextension 50054 "Sales List Archive" extends "Sales List Archive"
{
    //p5161
    layout
    {
        addafter("Currency Code")
        {
            field("Completely Shipped"; Rec."Completely Shipped")
            {
                ApplicationArea = ALL;
            }
            field("Promised Delivery Date"; Rec."Promised Delivery Date")
            {
                ApplicationArea = ALL;
            }
        }
    }
}
