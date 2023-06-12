pageextension 50096 "Transfer Order" extends "Transfer Order"
{
    layout
    {
        addafter("Posting Date")
        {
            //>>#79_mai2021
            field("Work Center"; Rec."Work Center")
            {
                ApplicationArea = ALL;
            }
            //<<#79_mai2021
        }
    }
}