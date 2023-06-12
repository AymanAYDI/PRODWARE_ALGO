pageextension 50092 "Bank Account List" extends "Bank Account List"
{
    layout
    {
        addafter("Phone No.")
        {
            field("Balance"; Rec."Balance")
            {
                ApplicationArea = ALL;
            }
        }
    }
}