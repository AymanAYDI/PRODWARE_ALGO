pageextension 50018 "Purchase Order List" extends "Purchase Order List"
{
    //p9307
    layout
    {
        addafter("Posting Description")
        {
            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = ALL;
            }
            field("No. of Archived Versions"; Rec."No. of Archived Versions")
            {
                ApplicationArea = ALL;
            }
            field("Vdoc Control No."; Rec."Vdoc Control No.")
            {
                ApplicationArea = ALL;
            }
        }
    }
    actions
    {
        addafter("P&osting")
        {
            group(ALGO_)
            {
                Caption = 'ALGO', locked = true;
                Image = Customer;
                action("VDOC - Import Retour Commande Achat")
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Image = Import;

                    Caption = 'VDOC - Import Retour Commande Achat';

                    RunObject = XMLport "Vdoc - Import Commande (RCA)";
                }
                action("VDOC - Imprimer RCA")
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Image = Print;

                    Caption = 'VDOC - Imprimer RCA';

                    trigger OnAction()
                    var
                        ReportPrint: Codeunit "Test Report-Print";
                    BEGIN
                        ReportPrint.PrintPurchHeader(Rec);
                    END;

                }
                action("Import Lignes Commande ALGO")
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Image = Import;

                    Caption = 'Import Lignes Commande ALGO';

                    RunObject = XMLport "Import Purchase Line ALGO";
                }
                action("Import Lignes Commande GAPP")
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Image = Import;

                    Caption = 'Import Lignes Commande GAPP';

                    RunObject = XMLport "Import Purchase Line GAPP";
                }
            }
        }
    }
}

