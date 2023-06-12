page 50044 "Posted Return Shpt Lines"
{
    // version ALGO

    Caption = 'Posted Return Shpt Lines';
    PageType = List;
    SourceTable = "Return Shipment Line";
    SourceTableView = SORTING("Document No.", "Line No.", "Buy-from Vendor No.")
                      ORDER(Ascending)
                      WHERE(Type = FILTER(Item));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("P.O."; Rec."P.O.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Vdoc Control No."; Rec."Vdoc Control No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = ALL;
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    ApplicationArea = ALL;
                }
                field("Return Qty. Shipped Not Invd."; Rec."Return Qty. Shipped Not Invd.")
                {
                    ApplicationArea = ALL;
                }
            }
        }
    }
}

