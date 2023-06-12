pageextension 50058 "Production Order List" extends "Production Order List"
{
    //p99000815
    layout
    {
        addafter("Search Description")
        {
            field("Routing Version Code"; Rec."Routing Version Code")
            {
                ApplicationArea = ALL;
            }
            field(Blocked; Rec.Blocked)
            {
                ApplicationArea = ALL;
            }
        }
    }
}
