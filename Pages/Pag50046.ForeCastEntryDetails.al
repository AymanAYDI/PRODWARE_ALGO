page 50046 "ForeCastEntryDetails"
{
    // Recup P50012 ancien Nav2009
    // 20190726 Debranchement de la page du departement ALGO pour branchement direct dans la page Prevision de Production


    Caption = 'Détails Prévision Production', LOCKED = true;
    PageType = List;
    SourceTable = "Production Forecast Entry";
    // UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Production ForeCast Name"; Rec."Production Forecast Name")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Forecast Date"; Rec."Forecast Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Forecast Quantity (Base)"; Rec."Forecast Quantity (Base)")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Component Forecast"; Rec."Component Forecast")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = Basic, Suite;
                }

                /* Champs 50000 Nav2009 non repris datant du 12/07/2016
                 field("Planning Imported";"Planning Imported")
                {
                    ApplicationArea = Basic, Suite;
                }    
                */

                field("Modele"; RecGItem.Model)
                {
                    ApplicationArea = Basic, Suite;
                }

                field("Modele/Taille"; RecGItem."Model Size")
                {
                    ApplicationArea = Basic, Suite;
                }

            }
        }
    }

    Trigger OnAfterGetRecord()
    BEGIN
        RecGItem.GET(Rec."Item No.");
    END;

    VAR
        RecGItem: Record Item;
}

