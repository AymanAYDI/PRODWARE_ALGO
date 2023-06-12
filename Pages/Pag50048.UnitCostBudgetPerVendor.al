page 50048 "Unit Cost Budget perVendor"
{
    Caption = 'Unit Cost Budget per Vendor';
    Editable = true;
    PageType = List;
    SourceTable = "Unit Cost Budget Per Vendor";
    SourceTableView = SORTING("Item No.", "Vendor No.")
        ORDER(Ascending);
    UsageCategory = Lists;

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
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Market share"; Rec."Market Share")
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


}