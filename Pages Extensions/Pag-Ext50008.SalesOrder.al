pageextension 50008 "Sales Order" extends "Sales Order"
{
    // #WMS20200221 - WMS - LOT 3 ###################################

    /* ========================================================
    #20230418 - ALGO : DSP - JVE
    --> Ajout d'un bouton action [Reservation Flux Pousse]
    --> desactivation de l'execution du CU ExportReservation
    =========================================================== 
    
    #20230427 - ALGO : DSP - EMA
    --> Le filtre article pour la reservation Flux Poussée est basée sur un paramétrage dynamique dans Infos Sociétés
    --> Objets Impactés : TAB-Ext50008 - Pag-Ext50026 - Pag-Ext50008 - COD50041
    ===========================================================     
    
    
    */


    //p42
    layout
    {
        addafter(Prepayment)
        {
            group(ALGO)
            {
                field(PO; Rec.PO)
                {
                    ApplicationArea = ALL;
                }
                field(PROFORMA; Rec.PROFORMA)
                {
                    ApplicationArea = ALL;
                    trigger OnValidate()
                    begin
                        //>>MIGRATION2009R2
                        //>>ALG1.00.00.00
                        RecGSalesLine.SETRANGE("Document Type", Rec."Document Type");
                        RecGSalesLine.SETRANGE("Document No.", Rec."No.");

                        IF RecGSalesLine.FIND('-') THEN
                            REPEAT
                                IF RecGSalesLine.Type > 0 THEN BEGIN
                                    RecGSalesLine.PROFORMA := Rec.PROFORMA;
                                    RecGSalesLine.MODIFY();
                                END;
                            UNTIL RecGSalesLine.NEXT() = 0;
                        //<<ALG1.00.00.00
                        //<<MIGRATION2009R2

                    end;
                }
                field("Completely Shipped"; Rec."Completely Shipped")
                {
                    ApplicationArea = ALL;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = ALL;
                }
                // #WMS20200221 - WMS - LOT 3
                field("NON_WMS"; Rec."NON_WMS")
                {
                    ApplicationArea = ALL;
                }
            }

        }
    }
    actions
    {
        addafter("&Order Confirmation")
        {
            group(ALGO_)
            {
                Caption = 'ALGO', locked = true;
                Image = Customer;
                action("Journal Modification CV Entête")
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Image = ChangeLog;

                    Caption = 'Journal Modification CV Entête';

                    RunObject = Page "Change Log Entries";
                    RunPageView = SORTING("Table No.", "Date and Time")
                                  ORDER(Ascending);
                    RunPageLink = "Table No." = FILTER(36),
                                  "Primary Key Field 1 Value" = FIELD("No.");

                }
                action("Journal Modification CV Ligne")
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Image = ChangeToLines;

                    Caption = 'Journal Modification CV Ligne';

                    RunObject = Page "Change Log Entries";
                    RunPageView = SORTING("Table No.", "Date and Time")
                                  ORDER(Ascending);
                    RunPageLink = "Table No." = FILTER(37),
                                  "Primary Key Field 1 Value" = FIELD("No.");

                }
                //>>#20230418
                action("Reservation Flux Poussé")
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Image = ChangeToLines;

                    Caption = 'Reservation Flux Poussé';
                    ToolTip = 'Filtre Articles : A*|MTO*|MDI*|KIT*|MCO*|MPAB*|MPAC*|MPAH*|MPAS*|MPARUB*|MPAAUTO*|MPAPAPIER*';

                    trigger OnAction()

                    var
                        CompanyInfo: Record "Company Information";
                        RecGSalesHeader: Record "Sales Header";
                        RecLSalesLines: Record "Sales Line";
                        SalesLine: Record "Sales Line";
                        RecGReservationEntry: Record "Reservation Entry";
                        RecGReservationEntries: Record "Reservation Entry";

                        TempReservationEntry: Record "Temp Reservation Entry";
                        ExcelBuf: Record "Excel Buffer" temporary;

                        Reservation: Codeunit "Automatic reservation handler";
                        // ExportReservations: Codeunit "Export reservations"; : Il sera généré par le CodeUnit 50041.
                        TotalRecNo: Integer;
                        RecNo: Integer;
                        Res: Integer;
                        Window: Dialog;
                        Text010Msg: Label 'Running Sales lines...\\';
                        Text011Msg: Label 'Reservation : ';

                    begin
                        // >> #20230427
                        CompanyInfo.Get();
                        CompanyInfo.TestField("Filter Flux Pousse");
                        If CompanyInfo."Filter Flux Pousse" = '' THEN ERROR('Pas de Filtres Articles définis pour la Réservation Flux Poussé !!!');
                        // << #20230427
                        IF GUIALLOWED() THEN
                            Window.OPEN(
                            Text010Msg +
                            '@1@@@@@@@@@@@@@@@@@@@@@@@@@\\' +
                            Text011Msg + '#2############');

                        IF GUIALLOWED() THEN
                            Window.UPDATE(1, 0);

                        RecLSalesLines.SETCURRENTKEY("Document Type", "Promised Delivery Date", "No.");
                        RecLSalesLines.SETRANGE("Document Type", RecLSalesLines."Document Type"::Order);
                        RecLSalesLines.SETFILTER("Document No.", Rec."No.");
                        RecLSalesLines.SETRANGE(Type, RecLSalesLines.Type::Item);

                        // >> #20230427
                        // RecLSalesLines.SETFILTER("No.", 'A*|MTO*|MDI*|KIT*|MCO*|MPAB*|MPAC*|MPAH*|MPAS*|MPARUB*|MPAAUTO*|MPAPAPIER*');
                        RecLSalesLines.SETFILTER("No.", CompanyInfo."Filter Flux Pousse");
                        // << #20230427

                        RecLSalesLines.SETRANGE("Sell-to Customer No.", 'GOYARD MONDE');
                        RecLSalesLines.SETFILTER("Outstanding Quantity", '>%1', 0);
                        RecLSalesLines.SETFILTER(PO, 'VDQ*');
                        RecLSalesLines.SETFILTER("Location Code", 'LANNOLIER1');

                        TotalRecNo := RecLSalesLines.COUNT();
                        RecNo := 0;
                        Res := 0;

                        CASE Rec.Status OF
                            Rec.Status::Released:
                                BEGIN
                                    IF RecLSalesLines.FINDSET() THEN
                                        REPEAT
                                            RecNo += 1;
                                            IF GUIALLOWED() THEN
                                                Window.UPDATE(1, ROUND(RecNo / TotalRecNo * 10000, 1));
                                            IF RecLSalesLines."Reserved Quantity" < RecLSalesLines."Outstanding Quantity" THEN
                                                Reservation.SetSalesLine(RecLSalesLines, Res);
                                            IF GUIALLOWED() THEN
                                                Window.UPDATE(2, Res);
                                        UNTIL RecLSalesLines.NEXT() = 0;

                                    // 20230418 - DSP - JVE
                                    // On desactive l''Export car il sera généré avec les reservations des PF qui se font en AUTO
                                    // ExportReservations.RUN; 
                                END;
                            ELSE
                                Message('La commande n''est pas en statut "Lancé" : Réservations impossibles');

                        END;
                        IF GUIALLOWED() THEN
                            Window.CLOSE();

                    end;

                }
                //>>#20230418
            }
        }
    }
    var
        RecGSalesHeader: Record 36;
        RecGSalesLine: Record 37;
}