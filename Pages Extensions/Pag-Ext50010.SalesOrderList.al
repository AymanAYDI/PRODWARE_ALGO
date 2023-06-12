pageextension 50010 "Sales Order List" extends "Sales Order List"
{
    //p9305

    /* ================================
    Date 18/04/2023 >> ALGO : JVE / DSP
    >> Bouton Reservation Automatic GSH désactivé : les utilisateurs ne pourront plus lancer la réservation automatique manuellement Globale pour GSH
    >> Soit ils devront attendre le traitement planifié en JOBQ
    >> soit ils pourront executer des réservations auto depuis la fiche d'une commande de vente et pour une commande de vente.
    =================================== */

    layout
    {
        addafter("Posting Description")
        {
            field(PO; Rec.PO)
            {
                ApplicationArea = ALL;
            }
            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = ALL;
            }
            field("Promised Delivery Date"; Rec."Promised Delivery Date")
            {
                ApplicationArea = ALL;
            }

        }
    }

    actions
    {
        addbefore("F&unctions")
        {
            group(ALGO)
            {
                Caption = 'ALGO', Locked = true;
                Image = Customer;
                action("ImportALGO")
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = New;
                    Image = Import;

                    Caption = 'Import ALGO', Locked = true;

                    RunObject = XMLport "Import Sales Order";
                }

                action("ImportCLIC")
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Image = Import;

                    Caption = 'Import CLIC', Locked = true;

                    RunObject = XMLport "Import Order Prepair";
                }

                action("ResaGOYARD")
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Image = AutoReserve;
                    // 20230418 >> DDE JVE >> Bouton Action désactivé 
                    Visible = false;
                    // 20230418 >> DDE JVE >> Bouton Action désactivé 
                    Caption = 'Réservation automatique - GOYARD', Locked = true;
                    RunObject = codeunit "Automatic Reservation";
                }

                action("ResaLUNIFORM")
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Image = AutoReserve;

                    Caption = 'Réservation automatique - L/UNIFORM', Locked = true;

                    RunObject = codeunit "Automatic Reservation LU";
                }
                action("ResaSAV")
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Image = AutoReserve;

                    Caption = 'Réservation automatique - SAV', Locked = true;

                    RunObject = codeunit "Automatic Reservation SAV";
                }

            }
        }
    }
}