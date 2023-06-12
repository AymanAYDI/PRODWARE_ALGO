pageextension 50101 "Reservation Entries" extends "Reservation Entries"
{
    //p497
    layout
    {
        addafter("Entry No.")
        {
            field("Export WMS"; Rec."Export WMS")
            {
                ApplicationArea = ALL;
            }
        }
    }
}

