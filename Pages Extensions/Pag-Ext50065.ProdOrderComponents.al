pageextension 50065 "Prod. Order Components" extends "Prod. Order Components"
{
    //p99000818
    layout
    {
        addafter("Substitution Available")
        {
            field("Remaining Qty. (Base)"; Rec."Remaining Qty. (Base)")
            {
                ApplicationArea = ALL;
            }
            field("Completely Picked"; Rec."Completely Picked")
            {
                ApplicationArea = ALL;
            }
            field("Expected Qty. (Base)"; Rec."Expected Qty. (Base)")
            {
                ApplicationArea = ALL;
            }
            field("Quantity (Base)"; Rec."Quantity (Base)")
            {
                ApplicationArea = ALL;
            }
            field("Prod. Order Line No."; Rec."Prod. Order Line No.")
            {
                ApplicationArea = ALL;
            }
            field("Prod. Order No."; Rec."Prod. Order No.")
            {
                ApplicationArea = ALL;
            }
            field("Act. Consumption (Qty)"; Rec."Act. Consumption (Qty)")
            {
                ApplicationArea = ALL;
            }
            field("Producted Qty"; Rec."Producted Qty")
            {
                ApplicationArea = ALL;
            }
            field("Statut OF Date"; Rec."Statut OF Date")
            {
                ApplicationArea = ALL;
            }
        }
    }
}
