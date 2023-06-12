pageextension 50006 "Item Ledger Entries" extends "Item Ledger Entries"
{
    //p38
    layout
    {
        addafter("Description")
        {
            field("IDescription"; RecItem.Description)
            {
                Caption = 'Item Description';
                ApplicationArea = ALL;
                Editable = false;
            }
            field("Description 2"; RecItem."Description 2")
            {
                Caption = 'Description 2';
                ApplicationArea = ALL;
                Editable = false;
            }
        }
        addafter("Posting Date")
        {
            //>> Ticket GLPI 3965
            field("Document Date"; Rec."Document Date")
            {
                ApplicationArea = ALL;
            }
            //<< Ticket GLPI 3965
            field("Transaction Type"; Rec."Transaction Type")
            {
                ApplicationArea = ALL;
            }
            field("Unit of Measure Code"; Rec."Unit of Measure Code")
            {
                ApplicationArea = ALL;
            }
            field("Cross-Reference No."; Rec."Cross-Reference No.")
            {
                ApplicationArea = ALL;
            }
        }
        addafter("Entry Type")
        {
            field("Source Type"; Rec."Source Type")
            {
                ApplicationArea = ALL;
            }
        }
        addafter("Document No.")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = ALL;
            }
            field("Source No."; Rec."Source No.")
            {
                ApplicationArea = ALL;
            }
        }
        addafter("Dimension Set ID")
        {
            field("Tracking No."; Rec."Tracking No.")
            {
                ApplicationArea = ALL;
            }
        }
    }
    var
        RecItem: Record Item;

    trigger OnAfterGetRecord()
    begin
        RecItem.Reset();
        RecItem.SetFilter(RecItem."No.", Rec."Item No.");
        RecItem.FindFirst();
    end;
}