pageextension 50026 "Company Information" extends "Company Information"
{
    //p1


    // // #20230427 - ALGO : DSP - EMA
    // //--> Le filtre article pour la reservation Flux Poussée est basée sur un paramétrage dynamique dans Infos Sociétés
    // //--> Objets Impactés : TAB-Ext50008 - Pag-Ext50026 - Pag-Ext50008 - COD50041
    // //===========================================================       
    layout
    {
        addafter("User Experience")
        {
            group(ALGO)
            {
                Caption = 'ALGO', Locked = true;
                field("EORI No."; Rec."EORI No.")
                {
                    ApplicationArea = ALL;
                }
                // ALGO 20200318 - Ajout du champs Siege Social dans la page
                field("Head Office"; Rec."Head Office")
                {
                    ApplicationArea = ALL;
                }
                // ALGO 20200318 - Ajout du champs Siege Social dans la page                
                field("MID Code"; Rec."MID Code")
                {
                    ApplicationArea = ALL;
                }
                field("AEO Certificate No."; Rec."AEO Certificate No.")
                {
                    ApplicationArea = ALL;
                }
                field("VDOC Path"; Rec."VDOC Path")
                {
                    ApplicationArea = ALL;
                }
                field("VDOC Backup Path"; Rec."VDOC Backup Path")
                {
                    ApplicationArea = ALL;
                }
                field("VDOC process"; Rec."VDOC process")
                {
                    ApplicationArea = ALL;
                }
                field("Packing Mail Recipient"; Rec."Packing Mail Recipient")
                {
                    ApplicationArea = ALL;
                }
                field("Packing Path"; Rec."Packing Path")
                {
                    ApplicationArea = ALL;
                }
                field("Picking Path"; Rec."Picking Path")
                {
                    ApplicationArea = ALL;
                }
                field("GSH Invoice Path"; Rec."GSH Invoice Path")
                {
                    ApplicationArea = ALL;
                }
                field("GSH Invoice Backup Path"; Rec."GSH Invoice Backup Path")
                {
                    ApplicationArea = ALL;
                }
                field("Invoice Mail Recipient"; Rec."Invoice Mail Recipient")
                {
                    ApplicationArea = ALL;
                }
                field("LU Invoice Path"; Rec."LU Invoice Path")
                {
                    ApplicationArea = ALL;
                }
                //>> Demande JVENANT du 202001
                field("WMS Path"; Rec."WMS Path")
                {
                    ApplicationArea = ALL;
                }
                //>> Demande JVENANT du 20200331
                field("MODULA Path"; Rec."MODULA Path")
                {
                    ApplicationArea = ALL;
                }
                //>> Export Reservation CLIG - juillet 2022
                field("Export Reservation"; Rec."Export Reservation")
                {
                    ApplicationArea = ALL;
                }
                //>> Projet#410 : Avoir GSH
                Field("GSH Credit Memo Path"; Rec."GSH Credit Memo Path")
                {
                    ApplicationArea = ALL;
                }
                Field("GSH Credit Memo Backup Path"; Rec."GSH Credit Memo Backup Path")
                {
                    ApplicationArea = ALL;
                }
                Field("LU Credit Memo Path"; Rec."LU Credit Memo Path")
                {
                    ApplicationArea = ALL;
                }
                //<<Projet#410 : Avoir GSH

                // Projet FeuillePlanning Fev2023
                Field("Export Planification Path"; Rec."Export Planificiation Path")
                {
                    ApplicationArea = ALL;
                }

                // >> #20230427
                Field("Filter Reservation Auto WMS"; Rec."Filter Reservation Auto WMS")
                {
                    ApplicationArea = ALL;
                    visible = false;
                    ToolTip = 'Filtre Article utilisé pour le CU50040 - Auto Reservation WMS';
                }
                Field("Filter Flux Pousse"; Rec."Filter Flux Pousse")
                {
                    ApplicationArea = ALL;
                    ToolTip = 'Filtre Articles utilisé pour la Reservation Flux Poussé et Export Reservation';

                }
                // << #20230427
            }
        }
    }
    actions
    {
        addafter(Codes)
        {
            group(ALGO1)
            {
                Caption = 'ALGO', Locked = true;
                Image = Customer;
                action(VDOC)
                {
                    Caption = 'Export VDOC', Locked = true;
                    Image = Excel;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Codeunit.run(Codeunit::"VDOC - Export Xls Multifichier");
                    end;

                }

                action(VDOCMANUEL)
                {
                    Caption = 'Export VDOC Manuel', Locked = true;
                    Image = Excel;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Codeunit.run(Codeunit::"VDOC - Manuel Export Xls Multi");
                    end;

                }
                action(WMSEDI)
                {
                    Caption = 'Export WMSEDI', Locked = true;
                    Image = Excel;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Codeunit.run(Codeunit::"WMS - EDI Transfert");
                    end;

                }
                action(MODULAEDI)
                {
                    Caption = 'Export MODULAEDI', Locked = true;
                    Image = Excel;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Codeunit.run(Codeunit::"MODULA - EDI Transfert");
                    end;

                }
                action(IntranetExport)
                {
                    Caption = 'Intranet Export';
                    Image = Web;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;

                    RunObject = report "Export2Intranet Manual";
                }
                // DDE JVE 20221123
                action(AUTORESAWMS)
                {
                    Caption = 'Resa Auto WMS', Locked = true;
                    Image = Workflow;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Codeunit.run(Codeunit::"Automatic Reservation WMS");
                    end;

                }
                // DDE JVE 20221123  


                action(AUTOEXPORTRESA)
                {
                    Caption = 'Export Reservation', Locked = true;
                    Image = ExportToExcel;
                    ToolTip = 'Execution manuelle du CU50041';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Codeunit.run(Codeunit::"Export Reservations");
                    end;

                }

            }
        }
    }

}
