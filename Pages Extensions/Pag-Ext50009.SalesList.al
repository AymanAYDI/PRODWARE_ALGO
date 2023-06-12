pageextension 50009 "Sales List" extends "Sales List"
{
    //p45
    layout
    {
        addafter(Status)
        {
            field("Promised Delivery Date"; Rec."Promised Delivery Date")
            {
                ApplicationArea = ALL;
            }
            field(Ship; Rec.Ship)
            {
                ApplicationArea = ALL;
            }
            field(PROFORMA; Rec.PROFORMA)
            {
                ApplicationArea = ALL;
            }
        }
    }
}