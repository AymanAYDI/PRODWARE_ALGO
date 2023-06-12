pageextension 50000 "Customer Card" extends "Customer Card"
{
    //p21
    layout
    {
        addafter(General)
        {
            group(ALGO)
            {
                Caption = 'ALGO', Locked = true;
                field("Bank Account n°"; Rec."Bank Account n°")
                {
                    ApplicationArea = ALL;
                }
                field("Customer Class"; Rec."Customer Class")
                {
                    ApplicationArea = ALL;
                }
            }
        }
    }

}