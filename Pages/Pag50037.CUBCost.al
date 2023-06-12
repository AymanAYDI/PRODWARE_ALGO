page 50037 "CUB Cost"
{
    // version ALGO

    Caption = 'CUB Cost';
    Editable = false;
    PageType = List;
    SourceTable = "Unit Cost Budget";
    SourceTableView = SORTING("Item No.", "Cost Type", "Starting Date", "Variant Code", "Unit of Measure Code")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Cost Type"; Rec."Cost Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Forecasted Quantity"; Rec."Forecasted Quantity")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Last Modified by"; Rec."Last Modified by")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Last Modified Date"; Rec."Last Modified Date")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("<Action1000000017>")
            {
                Caption = 'Journal des modifications';
                RunObject = Page "Change Log Entries";
                RunPageLink = "Table No." = FILTER(50012),
                              "Primary Key Field 1 Value" = FIELD("Item No.");
                RunPageView = SORTING("Table No.", "Date and Time")
                              ORDER(Ascending);
            }
        }
    }
}

