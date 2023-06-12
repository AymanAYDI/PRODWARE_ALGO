pageextension 50043 "Posted Purchase Receipt" extends "Posted Purchase Receipt"
{
    //p136
    layout
    {
        addafter("Buy-from")
        {
            group(ALGO1)
            {
                Caption = 'ALGO', Locked = true;
                field("Intranet Export"; Rec."Intranet Export")
                {
                    ApplicationArea = ALL;
                }
            }
        }
        addafter(Shipping)
        {
            group(ALGO2)
            {
                Caption = 'ALGO', Locked = true;
                field("Development Order"; Rec."Development Order")
                {
                    ApplicationArea = ALL;
                }

            }
        }
    }
}
