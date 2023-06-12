page 50004 "Packing Header ALGO"
{
    // version ALG.1.0.0.0,MIG2009R2

    Caption = 'Packing Header ALGO';
    Editable = true;
    PageType = Card;
    SourceTable = "Packing Header ALGO";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Shipment Adress"; Rec."Shipment Adress")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Shipment Method"; Rec."Shipment Method")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
            }
            group(Detail)
            {
                Caption = 'Detail';
                part("Packing Line ALGO"; "Packing Line ALGO")
                {
                    SubPageLink = "Packing Document No." = FIELD("No.");
                }
            }
        }
    }
}

