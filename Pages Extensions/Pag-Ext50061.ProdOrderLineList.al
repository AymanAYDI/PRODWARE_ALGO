pageextension 50061 "Prod. Order Line List" extends "Prod. Order Line List"
{
    //p5406
    layout
    {
        addafter("Cost Amount")
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = ALL;
            }
            field("Routing No."; Rec."Routing No.")
            {
                ApplicationArea = ALL;
            }
            field("Routing Version Code"; Rec."Routing Version Code")
            {
                ApplicationArea = ALL;
            }
            field("Production BOM Version Code"; Rec."Production BOM Version Code")
            {
                ApplicationArea = ALL;
            }
            field("Work Center"; Rec."Work Center")
            {
                ApplicationArea = ALL;
            }
            field("Purchase Order Line"; Rec."Purchase Order Line")
            {
                ApplicationArea = ALL;
            }
            field("Last Reception Date"; Rec."Last Reception Date")
            {
                ApplicationArea = ALL;
            }
            field("Unit of Measure Code"; Rec."Unit of Measure Code")
            {
                ApplicationArea = ALL;
            }
            field("Assigned User ID"; Rec."Assigned User ID")
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
