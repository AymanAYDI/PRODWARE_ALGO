pageextension 50066 "Transfer Order Subform" extends "Transfer Order Subform"
{
    //p5741
    layout
    {
        addafter("ShortcutDimCode[8]")
        {
            field("Inventory Posting Group"; Rec."Inventory Posting Group")
            {
                ApplicationArea = ALL;
            }
            field("PF concerned"; Rec."PF concerned")
            {
                ApplicationArea = ALL;
            }
            field("Prod. Order Line No."; Rec."Prod. Order Line No.")
            {
                ApplicationArea = ALL;
            }
            field("Outstanding Quantity"; Rec."Outstanding Quantity")
            {
                ApplicationArea = ALL;
            }
            field("Transfer-from Code"; Rec."Transfer-from Code")
            {
                ApplicationArea = ALL;
            }
            field("Transfer-to Code"; Rec."Transfer-to Code")
            {
                ApplicationArea = ALL;
            }
            field("Initial Quantity"; Rec."Initial Quantity")
            {
                ApplicationArea = ALL;
            }
            field("Tracking No."; Rec."Tracking No.")
            {
                ApplicationArea = ALL;
            }
            field("Purch. Order No."; Rec."Purch. Order No.")
            {
                ApplicationArea = ALL;
            }
        }
    }
}
