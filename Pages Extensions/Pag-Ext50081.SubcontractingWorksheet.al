pageextension 50081 "Subcontracting Worksheet" extends "Subcontracting Worksheet" //MyTargetPageId
{
    //p99000886
    actions
    {
        modify("Calculate Subcontracts")
        {
            Visible = false;
        }
        addafter("F&unctions")
        {
            group(ALGO)
            {
                Caption = 'ALGO', locked = true;
                Image = "Action";
                action("Calculate Subcontracts2")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Calculate Subcontracts';
                    Promoted = true;
                    Ellipsis = true;
                    Image = Calculate;

                    trigger OnAction()
                    var
                        CalculateSubContract: Report "Calculate Subcontracts-A";
                    begin
                        CalculateSubContract.SetWkShLine(Rec);
                        CalculateSubContract.RunModal();
                    end;
                }

            }
        }
    }
}