pageextension 50060 "Released Production Order" extends "Released Production Order"
{
    //p99000831
    layout
    {
        addafter(Posting)
        {
            group(ALGO)
            {
                Caption = 'ALGO', Locked = true;
                field("Routing No."; Rec."Routing No.")
                {
                    ApplicationArea = ALL;
                }

                field("Routing Version Code"; Rec."Routing Version Code")
                {
                    ApplicationArea = ALL;
                }
            }
        }
    }
    actions
    {
        addafter("&Print")
        {
            group(ALGO_)
            {
                Caption = 'ALGO', Locked = true;
                Image = Customer;
                action("Journal Modification OF Entête")
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Image = ChangeLog;

                    Caption = 'Journal Modification OF Entête';

                    RunObject = Page "Change Log Entries";
                    RunpageView = SORTING("Table No.", "Date and Time")
                                ORDER(Ascending);
                    RunpageLink = "Table No." = FILTER(5405),
                                "Primary Key Field 2 Value" = FIELD("No.");

                }
                action("Journal Modification OF Ligne")
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Image = ChangeToLines;

                    Caption = 'Journal Modification OF Ligne';

                    RunObject = Page "Change Log Entries";
                    RunpageView = SORTING("Table No.", "Date and Time")
                                ORDER(Ascending);
                    RunpageLink = "Table No." = FILTER(5406),
                                "Primary Key Field 2 Value" = FIELD("No.");

                }
                action("Item barcode")
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Report;
                    Image = Report;

                    Caption = 'Item barcode';

                    trigger OnAction()
                    var
                        ManuPrintReport: Codeunit "Manu. Print Report";
                    BEGIN
                        ManuPrintReport.PrintProductionOrder(Rec, 1);
                    END;
                }

            }

        }
    }
}
