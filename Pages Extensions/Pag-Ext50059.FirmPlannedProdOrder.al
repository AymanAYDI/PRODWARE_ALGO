pageextension 50059 "Firm Planned Prod. Order" extends "Firm Planned Prod. Order"
{
    //p99000829
    layout
    {
        addafter(Posting)
        {
            group(ALGO)
            {
                Caption = 'ALGO', Locked = true;
                field("Routing No."; Rec."Routing No.")
                {
                    ApplicationArea = ALL;
                }

                field("Routing Version Code"; Rec."Routing Version Code")
                {
                    ApplicationArea = ALL;
                }
            }
        }
    }
}
