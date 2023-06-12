pageextension 50086 "Session List" extends "Session List" //MyTargetPageId
{
    actions
    {
        addafter(Session)
        {
            group(ALGO)
            {
                Caption = 'ALGO', Locked = true;
                action(KillSession)
                {
                    Caption = 'Tuer la Session', Locked = true;
                    Image = Delete;
                    Ellipsis = true;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        Txtl001: Label 'Tuer cette session?', Locked = true;
                    begin
                        if Confirm(Txtl001) then
                            StopSession("Session ID");
                    end;
                }
            }
        }
    }
}