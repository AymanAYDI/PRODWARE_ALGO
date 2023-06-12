page 50006 "Packing Header List ALGO"
{
    // version ALG.1.0.0.0,MIG2009R2

    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "Packing Header ALGO";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Posting Number"; Rec."Posting Number")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Shipment Adress"; Rec."Shipment Adress")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Shipment Method"; Rec."Shipment Method")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }
}

