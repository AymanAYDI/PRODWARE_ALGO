page 50041 "Information Colisage"
{
    // version ALGO

    Caption = 'Packing Information';
    PageType = List;
    SourceTable = "Packing Line ALGO";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Shipment Document No."; Rec."Shipment Document No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Item; Rec.Item)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Quantity; Rec.Quantity)
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
                field(Pallet; Rec.Pallet)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Pallet Weight"; Rec."Pallet Weight")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(PO; Rec.PO)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Cust Ref."; Rec."Cust Ref.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Packing Document No."; Rec."Packing Document No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Shipment Line No."; Rec."Shipment Line No.")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }
}

