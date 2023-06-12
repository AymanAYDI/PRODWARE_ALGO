page 50005 "Packing Line ALGO"
{
    // version ALG.1.0.0.0,MIG2009R2

    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Posted Packing Line ALGO";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                Editable = false;
                Enabled = true;
                field("Sales Shipment No."; Rec."Sales Shipment No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Parcel No."; Rec."Parcel No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Parcel Weight"; Rec."Parcel Weight")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Pallet; Rec.Pallet)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Pallet Weight"; Rec."Pallet Weight")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }
}

