pageextension 50063 "Released Prod. Order Lines" extends "Released Prod. Order Lines"
{
    //p99000832
    layout
    {
        modify("Production BOM No.")
        {
            Visible = true;
        }
        modify("Routing No.")
        {
            Visible = true;
        }
        addafter("ShortcutDimCode[8]")
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = ALL;
            }
            field("Starting Date Routing Version"; Rec."Starting Date Routing Version")
            {
                ApplicationArea = ALL;
            }
            field("Starting Date ProdBOM Version"; Rec."Starting Date ProdBOM Version")
            {
                ApplicationArea = ALL;
            }
            field("Purchase Order Line"; Rec."Purchase Order Line")
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
