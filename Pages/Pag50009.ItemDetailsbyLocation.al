page 50009 "Item Details by Location"
{
    // version ALGO,MIG2009R2

    Caption = 'Item Details by Location';
    PageType = Card;
    SourceTable = Item;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Inventory; Rec.Inventory)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Qty. on Component Lines"; Rec."Qty. on Component Lines")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Qty. in Transit"; Rec."Qty. in Transit")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Scheduled Need (Qty.)"; Rec."Scheduled Need (Qty.)")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }
}

