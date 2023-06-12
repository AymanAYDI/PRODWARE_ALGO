page 50042 "Transfer Shipment Line"
{
    Caption = 'Transfer Shipment Line';
    Editable = false;
    PageType = List;
    SourceTable = "Transfer Shipment Line";
    SourceTableView = SORTING("Transfer Order No.", "Item No.", "Shipment Date")
                      ORDER(Ascending)
                      WHERE(Quantity = FILTER(<> 0));

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
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Inventory Posting Group"; Rec."Inventory Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Quantity (Base)"; Rec."Quantity (Base)")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Gross Weight"; Rec."Gross Weight")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Net Weight"; Rec."Net Weight")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Unit Volume"; Rec."Unit Volume")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Units per Parcel"; Rec."Units per Parcel")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Transfer Order No."; Rec."Transfer Order No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Shipping Agent Service Code"; Rec."Shipping Agent Service Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("In-Transit Code"; Rec."In-Transit Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Transfer-from Code"; Rec."Transfer-from Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Transfer-to Code"; Rec."Transfer-to Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Item Shpt. Entry No."; Rec."Item Shpt. Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Shipping Time"; Rec."Shipping Time")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Transfer-from Bin Code"; Rec."Transfer-from Bin Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("PF concerned"; Rec."PF concerned")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Outstanding qty to ship"; Rec."Outstanding qty to ship")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Initial Quantity"; Rec."Initial Quantity")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }
}

