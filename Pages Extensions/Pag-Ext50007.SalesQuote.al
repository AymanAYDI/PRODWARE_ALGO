pageextension 50007 "Sales Quote" extends "Sales Quote"
{
    //p41
    layout
    {
        addafter("Area")
        {
            field("Language Code"; Rec."Language Code")
            {
                ApplicationArea = ALL;
            }

        }
    }
}