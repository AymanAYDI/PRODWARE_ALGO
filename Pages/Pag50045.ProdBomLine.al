page 50045 "ProdBOMLine"
{
    // version GOY

    Caption = 'Prod BOM Lines';
    PageType = List;
    SourceTable = "Production BOM Line";
    SourceTableView = SORTING("Production BOM No.", "Line No.")
                      ORDER(Ascending)
                      ;
    UsageCategory = Lists;

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
                field("Type"; Rec."Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Quantity"; Rec."Quantity")
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
                field("Position"; Rec."Position")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Position2"; Rec."Position 2")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Position3"; Rec."Position 3")
                {
                    ApplicationArea = Basic, Suite;
                }

                field("Statut"; "VG_statut")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }

                field("Raw Material sale"; Rec."Raw material sale")
                {
                    ApplicationArea = BAsic, Suite;
                    Editable = false;
                }

            }
        }
    }

    trigger OnAfterGetRecord()
    BEGIN

        // Récupération du statut de la Prod BOM Header
        // Création en cours,Validée,Modification en cours,Clôturée

        RecGProdBOMversion.RESET();
        VG_statut := '';

        RecGProdBOMversion.SETFILTER(RecGProdBOMversion."Production BOM No.", '%1', Rec."Production BOM No.");
        RecGProdBOMversion.SETFILTER(RecGProdBOMversion."Version Code", '%1', Rec."Version Code");

        IF RecGProdBOMversion.FINDSET() THEN
            CASE RecGProdBOMversion.Status OF
                RecGProdBOMversion.Status::Certified:
                    VG_statut := 'Validee';

                RecGProdBOMversion.Status::Closed:
                    VG_statut := 'Cloturee';

                RecGProdBOMversion.Status::New:
                    VG_statut := 'Création en cours';

                RecGProdBOMversion.Status::"Under Development":
                    VG_statut := 'Modification en cours';
            END;

    END;

    VAR
        RecGProdBOMversion: Record "Production BOM Version";
        VG_statut: text;

}

