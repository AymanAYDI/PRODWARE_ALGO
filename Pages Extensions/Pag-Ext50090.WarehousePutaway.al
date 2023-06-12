pageextension 50090 "Warehouse Put-away" extends "Warehouse Put-away"
{
    actions
    {
        modify("&Print")
        {
            Visible = false;
        }
        addafter("&Registering")
        {
            group(ALGO)
            {
                Caption = 'ALGO', Locked = true;
                action("&Print2")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Imprimer ALGO', Locked = true;
                    Ellipsis = true;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        WhseActivHeader: Record "Warehouse Activity Header";
                    begin

                        WhseActivHeader.SETRANGE("No.", Rec."No.");
                        Report.run(Report::"Put-away List - ALGO", true, true, WhseActivHeader);
                    end;
                }

            }
        }

    }
}