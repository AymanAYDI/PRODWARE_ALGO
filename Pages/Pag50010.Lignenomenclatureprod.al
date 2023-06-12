page 50010 "Ligne nomenclature prod."
{
    Caption = 'Ligne nomenclature prod.';
    PageType = List;
    SourceTable = "Production BOM Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Production BOM No."; Rec."Production BOM No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Version Code"; Rec."Version Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Routing Link Code"; Rec."Routing Link Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Quantity per"; Rec."Quantity per")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }
}

