pageextension 50036 "Posted Sales Invoice" extends "Posted Sales Invoice"
{
    //p132
    layout
    {
        addafter("Foreign Trade")
        {
            group(ALGO)
            {
                Caption = 'ALGO', Locked = true;
                field("Prices Including VAT"; Rec."Prices Including VAT")
                {
                    ApplicationArea = ALL;
                }
                field("Intranet Export"; Rec."Intranet Export")
                {
                    ApplicationArea = ALL;
                }
            }
        }
    }

    actions
    {
        addafter("&Invoice")
        {
            group(ALGO_)
            {
                Caption = 'ALGO', locked = true;
                Image = Customer;
                action("GSH Export")
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Image = Excel;

                    Caption = 'GSH Export';

                    trigger OnAction()
                    begin
                        Rec.ExportGSH();
                    end;

                }

            }
        }
    }
}
