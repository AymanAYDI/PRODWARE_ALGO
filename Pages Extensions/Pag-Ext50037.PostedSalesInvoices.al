pageextension 50037 "Posted Sales Invoices" extends "Posted Sales Invoices"
{
    //p143
    layout
    {
        addafter("<Document Exchange Status>")
        {
            field("Currency Factor"; Rec."Currency Factor")
            {
                ApplicationArea = ALL;
            }
            field("Intranet Export"; Rec."Intranet Export")
            {
                ApplicationArea = ALL;
            }
        }
    }
}
