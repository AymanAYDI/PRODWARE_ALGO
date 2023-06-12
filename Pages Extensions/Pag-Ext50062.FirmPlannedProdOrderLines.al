pageextension 50062 "Firm Planned Prod. Order Lines" extends "Firm Planned Prod. Order Lines"
{
    //p99000830
    layout
    {
        modify("Routing No.")
        {
            Visible = true;
        }
        addafter("ShortcutDimCode[8]")
        {
            field("Starting Date Routing Version"; Rec."Starting Date Routing Version")
            {
                ApplicationArea = ALL;
            }
            field("Starting Date ProdBOM Version"; Rec."Starting Date ProdBOM Version")
            {
                ApplicationArea = ALL;
            }
            field("No CV Customer"; Rec."No CV Customer")
            {
                ApplicationArea = ALL;
                Visible = true;
            }
            field("Cust. due date"; Rec."Cust. due date")
            {
                ApplicationArea = ALL;
                Visible = true;
            }
        }
    }
}
