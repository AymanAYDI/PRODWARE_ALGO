pageextension 50083 "Posted Sales Credit Memo" extends "Posted Sales Credit Memo" //MyTargetPageId
{
    //p134
    layout
    {
        addafter("Sell-to")
        {
            field("Intranet Export"; Rec."Intranet Export")
            {
                ApplicationArea = ALL;
            }
        }
    }
    //>>Projet#410 : Avoir GSH
    actions
    {
        addafter("&Cr. Memo")
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
    //<<Projet#410 : Avoir GSH
}