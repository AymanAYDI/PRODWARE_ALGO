pageextension 50064 "Prod. Order Comp. Line List" extends "Prod. Order Comp. Line List"
{
    //p5407
    layout
    {
        addafter("Lead-Time Offset")
        {
            field("Original Item No."; Rec."Original Item No.")
            {
                ApplicationArea = ALL;
            }
            field("Unit of Measure Code"; Rec."Unit of Measure Code")
            {
                ApplicationArea = ALL;
            }
            field("Act. Consumption (Qty)"; Rec."Act. Consumption (Qty)")
            {
                ApplicationArea = ALL;
            }
            field("PF to manufacture"; Rec."PF to manufacture")
            {
                ApplicationArea = ALL;
            }
            field("Reserved Quantity"; Rec."Reserved Quantity")
            {
                ApplicationArea = ALL;
            }
            field("Producted Qty"; Rec."Producted Qty")
            {
                ApplicationArea = ALL;
            }
            field("Purchase Order Line"; Rec."Purchase Order Line")
            {
                ApplicationArea = ALL;
            }
        }
    }
}
