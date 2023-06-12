pageextension 50057 "Released Production Orders" extends "Released Production Orders"
{
    //p9326
    layout
    {
        addafter("Bin Code")
        {
            field("Routing Version Code"; Rec."Routing Version Code")
            {
                ApplicationArea = ALL;
            }
        }
    }
    actions
    {
        addafter("Production Order Statistics")
        {
            group(ALGO_)
            {
                Caption = 'ALGO', locked = true;
                Image = Customer;
                action("Etiquettes codes barres")
                {
                    RunObject = Report "Automatic Reservation Ctrl";
                    Promoted = true;
                    Image = Report;
                    PromotedCategory = Report;

                    Caption = 'Etiquettes codes barres';
                }
            }
        }
    }
}
