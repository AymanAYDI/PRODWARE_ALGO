pageextension 50031 "Consumption Journal" extends "Consumption Journal"
{
    //p99000846
    layout
    {
        addbefore("Applies-from Entry")
        {
            field("Return Reason Code"; Rec."Return Reason Code")
            {
                ApplicationArea = ALL;
            }

            // Ajout des champs n° de Lot ( NAV et ALGO ) - 202302 - DSP
            field("N° Lot"; Rec."Lot No.")
            {
                ApplicationArea = ALL;
            }
            field("N° Lot ALGO"; Rec."Tracking No.")
            {
                ApplicationArea = ALL;
            }
            // Ajout des champs n° de Lot ( NAV et ALGO ) - 202302 - DSP
        }
    }
    actions
    {
        modify("Calc. Co&nsumption")
        {
            Visible = false;
        }
        addafter("F&unctions")
        {
            group(ALGO)
            {
                Caption = 'ALGO', Locked = true;
                Image = Customer;
                action("&Calc. consommation ALGO")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Calc. Co&nsumption';
                    Ellipsis = true;
                    Image = CalculateConsumption;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'ALGO: Use a batch job to help you fill the consumption journal with actual or expected consumption figures.';

                    trigger OnAction()
                    var
                        CalcConsumption: Report "Calc. Consumption - ALGO";
                    begin
                        CalcConsumption.SetTemplateAndBatchName(Rec."Journal Template Name", Rec."Journal Batch Name");
                        CalcConsumption.RunModal();
                    end;
                }
            }
        }
    }
}