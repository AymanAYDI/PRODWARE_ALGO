pageextension 50030 "Production Journal" extends "Production Journal"
{
    //p5510
    layout
    {
        addafter("External Document No.")
        {
            field("Tracking No."; Rec."Tracking No.")
            {
                ApplicationArea = ALL;
            }

            field("OpeCapaEntries"; "OpeCapaEntries")
            {
                ApplicationArea = ALL;
                Editable = false;
                caption = 'Qtés déjà déclarées';
                ToolTip = 'Quantités déjà déclarées : c''est la somme des quantités produites validées dans les écritures capacités pour l''opération et l''opération selectionnée';
            }
        }
        //Existing field
        modify("Output Quantity")
        {
            trigger Onaftervalidate()
            //-----------
            VAR
                // Tables utilisées
                RecManufacturingSetup: Record "Manufacturing Setup";
                RecLProdOrderLine: record "Prod. Order Line"; // Ligne OF
                RecLItmJnlLinePREV: Record "Item Journal Line"; // Journal ligne article ( feuille de prod )
                RecLItmJnlLineNEXT: Record "Item Journal Line";
                RecLCapLedgerEntry: Record "Capacity Ledger Entry"; // écriture comptable capacité
                RecLCapLedgerEntry2: Record "Capacity Ledger Entry";
                RecLCapLedgerEntry3: Record "Capacity Ledger Entry";
                RecLProdOrderRoutingLine: record "Prod. Order Routing Line"; // Ligne Gamme OF 

                // Variables 

                NumOFEncours: code[20];
                NumligneOFEncours: integer;
                NumOpeEncours: text[150];
                NumLigneOpeEncours: integer;
                NomOperationEncours: text[50];
                CodeArticleEncours: code[20];
                QteProduiteEncours: Decimal;
                QteproduiteEncoursXREC: Decimal;
                SomQteCapaEncours: decimal; // Quantité Saisie validée de l'opération sur laquelle l'utilisateur fait une nouvelle saisie    
                NumGammeOFEncours: code[20];

                NumOpePrecedente: text[150];
                NomOperationPrecedente: text[150];
                SomQteCapaOpePrecedente: decimal; // Quantité Saisie validée de l'opération précédente
                QteProduiteSaisieOpePrecedente: decimal;  // quantité à produire saisie par l'utilisateur sur l'opération precedente 

                NumOpeSuivante: text[150];
                NomOperationSuivante: Text[150];
                SomQteCapaOpeSuivante: decimal; // Quantité Saisie validée de l'opération suivante
                QteProduiteSaisieOpeSuivante: decimal;  // quantité à produire saisie par l'utilisateur sur l'opération suivante            

                QteTotaleAProduireOF: decimal; // Quantité Ligne OF
                QteRestanteAProduireOF: decimal; // Quantite Restante du Ligne OF

                QteParalleleSuivante: decimal;
                QteParalleleSuivanteSaisie: decimal;
                QteParallelePrecedente: decimal;
                QteParallelePrecedenteSaisie: decimal;

                NumOpeSuivanteReference: text[150];
                NumOpePrecedenteReference: text[150];

                CasOperation: Text[20];
                chr13: Char;
                chr10: Char;
                NumCommas: integer;
                i: integer;

            BEGIN // DEBUT TRIGGER


                RecManufacturingSetup.Get();

                // Message('Securisation OF Activée ' + Format(RecManufacturingSetup."Securisation OF"));
                // Si la sécurisation des OF est activée alors le trigger peut s'exectuer:
                If RecManufacturingSetup."Securisation OF" = true then BEGIN // DEBUT SI SECURISATION ACTIVEE

                    chr13 := 13;
                    chr10 := 10;
                    NumOFEncours := '';
                    NumLigneOFEncours := 0;
                    NumOpeEncours := '';
                    NumLigneOpeEncours := 0;
                    NomOperationEncours := '';
                    CodeArticleEncours := '';
                    QteProduiteEncours := 0;
                    QteproduiteEncoursXREC := 0;

                    NumOFEncours := Rec."Document No.";
                    NumLigneOFEncours := Rec."Order Line No.";
                    NumOpeEncours := Rec."Operation No.";
                    NomOperationEncours := Rec.Description;
                    NumLigneOpeEncours := Rec."Line No.";
                    CodeArticleEncours := Rec."Item No.";
                    QteProduiteEncours := Rec."Output Quantity";
                    QteproduiteEncoursXREC := XREC."Output Quantity";



                    // Parcours de la table : ligne OF afin de récupérer la quantité totale, la quantité restante et la gamme OF
                    RecLProdOrderLine.SETFILTER(RecLProdOrderLine."Item No.", CodeArticleEncours);
                    RecLProdOrderLine.SETFILTER(RecLProdOrderLine."Prod. Order No.", NumOFEncours);
                    RecLProdOrderLine.SETFILTER(RecLProdOrderLine."Line No.", '%1', NumLigneOFEncours);
                    IF RecLProdOrderLine.FINDSET() THEN BEGIN
                        QteTotaleAProduireOF := RecLProdOrderLine.Quantity;
                        QteRestanteAProduireOF := RecLProdOrderLine."Remaining Quantity";
                        NumGammeOFEncours := RecLProdOrderLine."Routing No.";
                    END;

                    // Parcours de la table : ligne gamme OF pour récupérer les informations sur les autres opérations
                    RecLProdOrderRoutingLine.setrange("Prod. Order No.", NumOFEncours);
                    RecLProdOrderRoutingLine.setrange("Operation No.", NumOpeEncours);
                    RecLProdOrderRoutingLine.setrange("Routing No.", NumGammeOFEncours);
                    If RecLProdOrderRoutingLine.FINDFIRST() THEN BEGIN
                        CasOperation := 'Intermediaire';
                        IF RecLProdOrderRoutingLine."Sequence No. (Forward)" = 1 then CasOperation := 'Premiere';
                        IF RecLProdOrderRoutingLine."Sequence No. (Backward)" = 1 then CasOperation := 'Derniere';
                        NumOpePrecedente := RecLProdOrderRoutingLine."Previous Operation No.";
                        NumOpeSuivante := RecLProdOrderRoutingLine."Next Operation No.";
                    END;

                    // Parcours de la table des écritures comptables capacité pour récupérer la QTE déjà déclarée pour les differentes opérations
                    // Encours - precedente - suivante
                    // Encours
                    RecLCapLedgerEntry.SETRANGE("Order Type", RecLCapLedgerEntry."Order Type"::Production);
                    RecLCapLedgerEntry.SETFILTER("Order No.", NumOFEncours);
                    RecLCapLedgerEntry.SETFILTER("Operation No.", NumOpeEncours);
                    SomQteCapaEncours := 0;
                    IF RecLCapLedgerEntry.Findset() THEN BEGIN
                        REPEAT
                            SomQteCapaEncours += RecLCapLedgerEntry."Output Quantity";
                        UNTIL RecLCapLedgerEntry.NEXT() = 0;
                    END;

                    // Suivante
                    SomQteCapaOpeSuivante := 0;
                    QteProduiteSaisieOpeSuivante := 0;
                    QteParalleleSuivante := 0;
                    QteParalleleSuivanteSaisie := 0;

                    IF NumOpeSuivante <> '' THEN BEGIN
                        NumCommas := STRLEN(NumOpeSuivante) - STRLEN(DELCHR(NumOpeSuivante, '=', '|'));
                        NumOpeSuivante := CONVERTSTR(NumOpeSuivante, '|', ',');

                        FOR i := 1 TO (NumCommas + 1) DO BEGIN
                            RecLCapLedgerEntry.SETRANGE("Order Type", RecLCapLedgerEntry."Order Type"::Production);
                            RecLCapLedgerEntry.SETFILTER("Order No.", NumOFEncours);
                            RecLCapLedgerEntry.SETFILTER("Operation No.", SELECTSTR(i, NumOpeSuivante));
                            QteParalleleSuivante := 0;
                            QteParalleleSuivanteSaisie := 0;

                            IF RecLCapLedgerEntry.Findset() THEN BEGIN
                                REPEAT
                                    QteParalleleSuivante += RecLCapLedgerEntry."Output Quantity";
                                UNTIL RecLCapLedgerEntry.NEXT() = 0;
                            END;

                            // Parcours de la feuille de production sur l'opération suivante
                            RecLItmJnlLineNEXT.SETRANGE(RecLItmJnlLineNEXT."Entry Type", RecLItmJnlLineNEXT."Entry Type"::Output);
                            // RecLItmJnlLineNEXT.SETRANGE("Journal Batch Name", RecLItmJnlLineNEXT."Journal Batch Name");
                            RecLItmJnlLineNEXT.setfilter(RecLItmJnlLineNEXT."Journal Template Name", 'O.F.');
                            RecLItmJnlLineNEXT.SetCurrentKey(RecLItmJnlLineNEXT."Order No.", "Line No.");
                            RecLItmJnlLineNEXT.setfilter(RecLItmJnlLineNEXT."Operation No.", SELECTSTR(i, NumOpeSuivante));
                            IF RecLItmJnlLineNEXT.FINDFIRST() THEN BEGIN
                                QteParalleleSuivanteSaisie := RecLItmJnlLineNEXT."Output Quantity";
                            end;

                            IF (SomQteCapaOpeSuivante + QteProduiteSaisieOpeSuivante) = 0 THEN BEGIN
                                NumOpeSuivanteReference := SELECTSTR(i, NumOpeSuivante);
                                QteProduiteSaisieOpeSuivante := QteParalleleSuivanteSaisie;
                                SomQteCapaOpeSuivante := QteParalleleSuivante;
                            END;

                            IF (SomQteCapaOpeSuivante + QteProduiteSaisieOpeSuivante) > (QteParalleleSuivante + QteParalleleSuivanteSaisie) THEN BEGIN
                                NumOpeSuivanteReference := SELECTSTR(i, NumOpeSuivante);
                                QteProduiteSaisieOpeSuivante := QteParalleleSuivanteSaisie;
                                SomQteCapaOpeSuivante := QteParalleleSuivante;
                            END;

                        END;
                    END;

                    // Precedente
                    SomQteCapaOpePrecedente := 0;
                    QteProduiteSaisieOpePrecedente := 0;
                    QteParallelePrecedente := 0;
                    QteParallelePrecedenteSaisie := 0;

                    IF NumOpePrecedente <> '' THEN BEGIN
                        NumCommas := STRLEN(NumOpePrecedente) - STRLEN(DELCHR(NumOpePrecedente, '=', '|'));
                        NumOpePrecedente := CONVERTSTR(NumOpePrecedente, '|', ',');

                        FOR i := 1 TO (NumCommas + 1) DO BEGIN
                            RecLCapLedgerEntry.SETRANGE("Order Type", RecLCapLedgerEntry."Order Type"::Production);
                            RecLCapLedgerEntry.SETFILTER("Order No.", NumOFEncours);
                            RecLCapLedgerEntry.SETFILTER("Operation No.", SELECTSTR(i, NumOpePrecedente));
                            QteParallelePrecedente := 0;

                            IF RecLCapLedgerEntry.Findset() THEN BEGIN
                                REPEAT
                                    QteParallelePrecedente += RecLCapLedgerEntry."Output Quantity";
                                UNTIL RecLCapLedgerEntry.NEXT() = 0;
                            END;

                            // Parcours de la feuille de production sur l'opération Precedente
                            RecLItmJnlLinePREV.SETRANGE(RecLItmJnlLinePREV."Entry Type", RecLItmJnlLinePREV."Entry Type"::Output);
                            // RecLItmJnlLinePREV.SETRANGE(RecLItmJnlLinePREV."Journal Batch Name", RecLItmJnlLinePREV."Journal Batch Name");
                            RecLItmJnlLinePREV.setfilter(RecLItmJnlLinePREV."Journal Template Name", 'O.F.');
                            RecLItmJnlLinePREV.setfilter(RecLItmJnlLinePREV."Item No.", CodeArticleEncours);
                            RecLItmJnlLinePREV.setfilter("Operation No.", SELECTSTR(i, NumOpePrecedente));
                            RecLItmJnlLinePREV.SetCurrentKey("Order No.", "Line No.");
                            IF RecLItmJnlLinePREV.FINDFIRST() THEN BEGIN
                                QteParallelePrecedenteSaisie := RecLItmJnlLinePREV."Output Quantity";
                            end;

                            IF (SomQteCapaOpePrecedente + QteProduiteSaisieOpePrecedente) = 0 THEN begin
                                NumOpePrecedenteReference := SELECTSTR(i, NumOpePrecedente);
                                SomQteCapaOpePrecedente := QteParallelePrecedente;
                                QteProduiteSaisieOpePrecedente := QteParallelePrecedenteSaisie;
                            end;

                            IF (SomQteCapaOpePrecedente + QteProduiteSaisieOpePrecedente) > (QteParallelePrecedente + QteParallelePrecedenteSaisie) THEN begin
                                NumOpePrecedenteReference := SELECTSTR(i, NumOpePrecedente);
                                SomQteCapaOpePrecedente := QteParallelePrecedente;
                                QteProduiteSaisieOpePrecedente := QteParallelePrecedenteSaisie;
                            end;

                        END;
                    END;

                    CASE CasOperation OF
                        'Premiere':
                            BEGIN

                                IF (QteProduiteEncours >= 0) THEN BEGIN
                                    IF QteRestanteAProduireOF = 0 THEN
                                        ERROR('(PRE001-POS) - Il n''y a plus rien à produire sur cet OF ! ');
                                    IF (SomQteCapaEncours > QteTotaleAProduireOF) then
                                        ERROR('(PRE002-POS) - Cette opération a été totalement produite ! ');
                                    IF (QteProduiteEncours > (QteTotaleAProduireOF - SomQteCapaEncours)) then
                                        ERROR('(PRE003-POS) - Vous ne pouvez pas produire plus que le restant à produire sur cette opération ! ' + FORMAT(chr13) + FORMAT(chr10)
                                        + '-> Maximum possible : ' + format(QteTotaleAProduireOF - SomQteCapaEncours));
                                    IF ((QteProduiteEncours + SomQteCapaEncours) < (SomQteCapaOpeSuivante + QteProduiteSaisieOpeSuivante)) then
                                        ERROR('(PRE004-POS) - Vous ne pouvez réduire la quantité produite de cette opération : la quantité à produire saisie de l''opération '
                                        + 'suivante + la quantité déjà produite sur l''opération suivante est supérieure aux quantités de l''opération actuelle '
                                        + 'Quantité Attendue : ' + Format((SomQteCapaOpeSuivante + QteProduiteSaisieOpeSuivante) - (SomQteCapaEncours)));
                                END;

                                IF (QteProduiteEncours < 0) THEN BEGIN
                                    IF ((QteProduiteEncours * -1) > QteTotaleAProduireOF) THEN
                                        ERROR('(PRE005-NEG) - La quantité saisie à annuler sur cette opération est supérieure à la quantité sur l''OF ');
                                    IF ((QteProduiteEncours * -1) > SomQteCapaEncours) THEN
                                        ERROR('(PRE006-NEG) - La quantité saisie à annuler sur cette opération est supérieure à la quantité déjà validée '
                                        + '-> Maximum possible : ' + format(SomQteCapaEncours));
                                    IF ((SomQteCapaEncours + QteProduiteEncours) < (SomQteCapaOpeSuivante + QteProduiteSaisieOpeSuivante)) then
                                        ERROR('(PRE007-NEG) - Les quantités sur l''opération suivante ne sont pas suffisantes pour annuler votre quantité sur l''opération encours'
                                        + ' Quantité possible : ' + format((SomQteCapaOpeSuivante + QteProduiteSaisieOpeSuivante) - SomQteCapaEncours));
                                END;

                            END;

                        'Intermediaire':
                            BEGIN

                                IF (QteProduiteEncours >= 0) THEN BEGIN
                                    IF ((QteProduiteEncours + SomQteCapaEncours) > (SomQteCapaOpePrecedente + QteProduiteSaisieOpePrecedente)) then
                                        ERROR('(INT001-POS) - La quantité saisie est supérieure à la quantité validée de la précédente opération  ' + FORMAT(chr13) + FORMAT(chr10)
                                        + '-> Maximum possible : ' + format(((SomQteCapaOpePrecedente + QteProduiteSaisieOpePrecedente) - (SomQteCapaEncours))));
                                    IF (QteProduiteEncours > (QteTotaleAProduireOF - SomQteCapaEncours)) then
                                        ERROR('(INT002-POS) - La quantité saisie est supérieure à la quantité déjà validée sur l''opération en cours' + FORMAT(chr13) + FORMAT(chr10)
                                        + '-> Maximum possible : ' + format((SomQteCapaOpePrecedente - SomQteCapaEncours)));
                                    IF (SomQteCapaOpePrecedente + QteProduiteSaisieOpePrecedente = 0) THEN
                                        ERROR('(INT003-POS) - Vous ne pouvez saisir de production pour cette opération : l''opération précédente n''est pas commencée ');
                                    IF ((QteProduiteEncours + SomQteCapaEncours) < (SomQteCapaOpeSuivante + QteProduiteSaisieOpeSuivante)) then begin
                                        ERROR('(INT004-POS) - La quantité saisie sur cette opération est incohérente avec la quantité saisie sur l''opération suivante ' + FORMAT(chr13) + FORMAT(chr10)
                                        + ' + la quantité déjà produite sur l''opération suivante qui est supérieure aux quantités de l''opération actuelle ' + FORMAT(chr13) + FORMAT(chr10)
                                        + 'Quantité Minimum : ' + Format((SomQteCapaOpeSuivante + QteProduiteSaisieOpeSuivante) - (SomQteCapaEncours)));
                                    end;

                                END;

                                IF (QteProduiteEncours < 0) THEN BEGIN
                                    IF (QteProduiteEncours > (SomQteCapaOpePrecedente - SomQteCapaEncours)) then
                                        ERROR('(INT001-NEG) - La quantité saisie est supérieure à la quantité validée de la précédente opération  ' + FORMAT(chr13) + FORMAT(chr10)
                                        + '-> Maximum possible : ' + format((SomQteCapaOpePrecedente - SomQteCapaEncours)));

                                    IF (SomQteCapaOpePrecedente = 0) THEN
                                        ERROR('(INT002-NEG) - Quantité pour annulation impossible : l''opération précédente n''est pas commencée ');
                                    IF (SomQteCapaEncours = 0) THEN
                                        ERROR('(INT002b-NEG) - Quantité pour annulation impossible : Rien n''a été déclaré pour l''opération encours ');

                                    IF ((QteProduiteEncours * -1) > QteTotaleAProduireOF) THEN
                                        ERROR('(INT003-NEG) - La quantité saisie à annuler sur cette opération est supérieure à la quantité sur l''OF ');

                                    IF ((QteProduiteEncours * -1) > SomQteCapaEncours) THEN
                                        ERROR('(INT004-NEG) - Vous ne pouvez pas annuler une quantité supérieure à la quantité validée pour cette même opération '
                                        + '-> Maximum possible : ' + format(SomQteCapaEncours));

                                    IF ((QteProduiteEncours) < ((SomQteCapaOpeSuivante - SomQteCapaEncours) + (QteProduiteSaisieOpeSuivante))) then begin
                                        ERROR('(INT005-NEG) - Vous ne pouvez faire d''annulation supérieure à la quantité de l''opération suivante'
                                        + '-> Maximum possible : ' + format((SomQteCapaOpeSuivante - SomQteCapaEncours) + QteProduiteSaisieOpeSuivante));
                                    end;
                                END;
                            END;

                        'Derniere':
                            BEGIN
                                IF (QteProduiteEncours >= 0) THEN BEGIN
                                    IF (QteProduiteEncours > ((SomQteCapaOpePrecedente - SomQteCapaEncours) + QteProduiteSaisieOpePrecedente)) then BEGIN
                                        ERROR('(DER001-POS) - La quantité saisie est supérieure à la quantité validée de la précédente opération ' + FORMAT(chr13) + FORMAT(chr10)
                                        + '-> Maximum possible : ' + format(((SomQteCapaOpePrecedente - SomQteCapaEncours) + QteProduiteSaisieOpePrecedente)));
                                    END;
                                END;

                                IF (QteProduiteEncours < 0) THEN BEGIN
                                    IF (SomQteCapaEncours = 0) then BEGIN
                                        ERROR('(DER001-NEG) - Vous ne pouvez saisir une annulation sur cette opération : cette opération n''a aucune quantité produite !');
                                    END;
                                    IF (QteProduiteEncours * -1) > (SomQteCapaEncours) then BEGIN
                                        ERROR('(DER002-NEG) - Quantité incorrecte pour annulation : La quantité saisie dépasse la quantité déjà déclarée !' + FORMAT(chr13) + FORMAT(chr10)
                                        + ' Max : ' + format(SomQteCapaEncours));
                                    END;


                                END;


                            END;

                    END; // Fin du CASE OF
                END; // FIN Si Securisation Activee
            END;


        }
    }
    actions
    {
        addafter("&Print")
        {
            group(ALGO_)
            {
                Caption = 'ALGO', locked = true;
                Image = Customer;
                action("Update Consummed Quantity")
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Image = ConsumptionJournal;

                    Caption = 'Update Consummed Quantity';

                    trigger onaction()
                    VAR
                        Item: Record Item;
                        RecLItmJnlLine: Record "Item Journal Line";
                        RecLManufacturingSetup: Record "Manufacturing Setup";
                        RecLBomHdr: Record "Production BOM Header";
                        RecLBomLine: Record "Production BOM Line";
                        DecLProdQty: Decimal;
                    begin
                        RecLManufacturingSetup.GET();
                        RecLManufacturingSetup.TESTFIELD("default consumption WorkCenter");

                        RecLItmJnlLine := Rec;

                        RecLItmJnlLine.SETRANGE("Entry Type", RecLItmJnlLine."Entry Type"::Output);
                        RecLItmJnlLine.SETRANGE(Type, RecLItmJnlLine.Type::"Work Center");
                        RecLItmJnlLine.SETFILTER("No.", RecLManufacturingSetup."default consumption WorkCenter");
                        IF RecLItmJnlLine.FIND('-') THEN
                            IF RecLItmJnlLine."Output Quantity" <> 0 THEN
                                IF Item.GET(RecLItmJnlLine."Item No.") THEN BEGIN
                                    DecLProdQty := RecLItmJnlLine."Output Quantity";
                                    IF Item."Production BOM No." <> '' THEN BEGIN
                                        RecLBomHdr.GET(Item."Production BOM No.");
                                        RecLBomLine.SETFILTER("Production BOM No.", RecLBomHdr."No.");
                                        RecLBomLine.SETRANGE(Type, RecLBomLine.Type::Item);
                                        RecLBomLine.SETFILTER("Version Code", RecLBomHdr."Version Nos.");
                                        IF RecLBomLine.FIND('-') THEN
                                            REPEAT
                                                //scroll BOM to affect qty to consumed Item
                                                RecLItmJnlLine.RESET();
                                                RecLItmJnlLine.SETFILTER("Journal Template Name", Rec."Journal Template Name");
                                                RecLItmJnlLine.SETFILTER("Journal Batch Name", Rec."Journal Batch Name");
                                                RecLItmJnlLine.SETFILTER("Source No.", Rec."Source No.");
                                                RecLItmJnlLine.SETFILTER("Document No.", Rec."Document No.");
                                                RecLItmJnlLine.SETRANGE("Entry Type", Rec."Entry Type"::Consumption);
                                                RecLItmJnlLine.SETFILTER("Item No.", RecLBomLine."No.");
                                                IF RecLItmJnlLine.FIND('-') THEN BEGIN
                                                    Rec.GET(Rec."Journal Template Name", Rec."Journal Batch Name", RecLItmJnlLine."Line No.");
                                                    Rec.VALIDATE(Quantity, RecLBomLine.Quantity * DecLProdQty);
                                                    Rec.MODIFY(TRUE);
                                                END;
                                            UNTIL RecLBomLine.NEXT() = 0;
                                    END;
                                END;
                    END;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        RecLCapLedgerEntries: Record "Capacity Ledger Entry";
        RecLIteLedgerEntries: Record "Item Ledger Entry";

    begin
        // Encours
        IF Rec."Entry Type" = Rec."Entry Type"::Output THEN BEGIN
            RecLCapLedgerEntries.SETRANGE("Order Type", RecLCapLedgerEntries."Order Type"::Production);
            RecLCapLedgerEntries.SETFILTER("Order No.", Rec."Order No.");
            RecLCapLedgerEntries.SETFILTER("Operation No.", Rec."Operation No.");
            OpeCapaEntries := 0;
            IF RecLCapLedgerEntries.Findset() THEN BEGIN
                REPEAT
                    OpeCapaEntries += RecLCapLedgerEntries."Output Quantity";
                UNTIL RecLCapLedgerEntries.NEXT() = 0;
            END;
        END;


        IF Rec."Entry Type" = Rec."Entry Type"::Consumption THEN BEGIN
            RecLIteLedgerEntries.SETRANGE("Entry Type", RecLIteLedgerEntries."Entry Type"::Consumption);
            RecLIteLedgerEntries.SETFILTER("Order No.", Rec."Order No.");
            RecLIteLedgerEntries.SETFILTER("Item No.", Rec."Item No.");
            OpeCapaEntries := 0;
            IF RecLIteLedgerEntries.Findset() THEN BEGIN
                REPEAT
                    OpeCapaEntries += RecLIteLedgerEntries.Quantity;
                UNTIL RecLIteLedgerEntries.NEXT() = 0;
            END;
        END;

    end;

    var
        OpeCapaEntries: decimal;
}
