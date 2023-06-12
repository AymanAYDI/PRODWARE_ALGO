pageextension 50001 "Customer List" extends "Customer List"
{
    //p22
    layout
    {
        addafter("Sales (LCY)")
        {
            field("Bank Account n°"; Rec."Bank Account n°")
            {
                ApplicationArea = ALL;
            }
            field("Customer Class"; Rec."Customer Class")
            {
                ApplicationArea = ALL;
            }
            field("Net Change"; Rec."Net Change")
            {
                ApplicationArea = ALL;
            }
            field(Balance; Rec.Balance)
            {
                ApplicationArea = ALL;
            }
        }
    }
}