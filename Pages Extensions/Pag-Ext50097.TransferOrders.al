pageextension 50097 "Transfer Orders" extends "Transfer Orders"
{
    layout
    {
        addafter("Transfer-to Code")
        {
            //>>#79_mai2021
            field("Work Center"; Rec."Work Center")
            {
                ApplicationArea = Basic, Suite;
            }
            //<<#79_mai2021
        }
    }
}