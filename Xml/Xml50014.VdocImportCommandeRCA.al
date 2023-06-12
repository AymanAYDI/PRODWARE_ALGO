xmlport 50014 "Vdoc - Import Commande (RCA)"
{
    // //>>ALGO_01/03/2018 : CREATE
    // // XMLPORT servant à créer les RCA des NON CONFORMES à partir des fichiers CSV exportés de VDOC.
    // // OJBETS concernés : T38 - T38 - T39 - P9307 - X500014
    // // T38 : Creation du champs 50011 : Vdoc Control No.
    // // T39 : Creation du champs 50011 : Vdoc Control No.
    // // T39 : Creation du champs 50012 : VDOC Delivery Order No
    // // P9307 : Ajout de la commande : Import des RCA dans Fonction

    Direction = Import;
    FieldSeparator = ';';
    Format = VariableText;
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            tableelement(mypurchaseline; "Purchase Line")
            {
                XmlName = 'PurchaseLine';
                textelement(Atelier)
                {
                }
                textelement(DateSaisieRecptNav)
                {
                }
                textelement(NumBL)
                {
                }
                textelement(NumArticle)
                {
                }
                textelement(NumScelle)
                {
                }
                textelement(QuScelle)
                {
                }
                textelement(QuRecue)
                {
                }
                textelement(DateFinCtrl)
                {
                }
                textelement(RefDCTL)
                {
                }
                textelement(PrixUnitaire)
                {
                }

                trigger OnBeforeInsertRecord()
                begin

                    IF MyRefDCTL <> RefDCTL THEN BEGIN

                        // Recherche du dernier n° de commande commencant par RCA *
                        NumCommande := NoSeriesMgt.GetNextNo('A-CDE1', 0D, TRUE);
                        // =======================================================

                        // MESSAGE('N°commande : ' + NumCommande );

                        CLEAR(MyPurchaseHeader);
                        MyPurchaseHeader."No." := NumCommande;
                        MyPurchaseHeader."Document Type" := MyPurchaseHeader."Document Type"::Order;
                        MyPurchaseHeader.VALIDATE("Buy-from Vendor No.", Atelier);
                        MyPurchaseHeader."Posting Date" := TODAY();
                        MyPurchaseHeader."Vdoc Control No." := RefDCTL;
                        MyPurchaseHeader."Order Date" := TODAY();
                        MyPurchaseHeader.INSERT(TRUE);

                        MyPurchaseHeader.SETFILTER(MyPurchaseHeader."No.", NumCommande);
                        MyPurchaseHeader.VALIDATE("Location Code", 'RCT-CONT');
                        MyPurchaseHeader.MODIFY();

                        MyRefDCTL := RefDCTL;
                        NewLineNo := 0;

                    END;

                    CLEAR(MyPurchaseLine);

                    NewLineNo += 10000;
                    MyPurchaseLine."Document Type" := MyPurchaseHeader."Document Type";
                    MyPurchaseLine."Document No." := MyPurchaseHeader."No.";
                    MyPurchaseLine."Line No." := NewLineNo;
                    MyPurchaseLine.Type := MyPurchaseLine.Type::Item;
                    MyPurchaseLine.VALIDATE("No.", NumArticle);
                    MyPurchaseLine."P.O." := NumScelle;
                    MyPurchaseLine.VALIDATE("Location Code", 'RCT-CONT');
                    MyPurchaseLine."Vdoc Control No." := RefDCTL;
                    MyPurchaseLine."Vdoc Delivery Order No." := NumBL;



                    IF EVALUATE(MyQuantity, QuScelle) THEN
                        MyPurchaseLine.VALIDATE(Quantity, MyQuantity);

                    // >> Il est important que le prix soit valorisé apres
                    // >> après la quantité, sinon il va rechercher le prix
                    // >> d'achat sur l'article concerné

                    IF EVALUATE(MyUnitCost, PrixUnitaire) THEN
                        MyPurchaseLine.VALIDATE("Direct Unit Cost", MyUnitCost);

                    // 20190711 : Message d'informations
                    if MyUnitCost = 0 then
                        message('Retour Achat : ' + MyPurchaseHeader."No." + ' - Probleme Prix sur article : ' + NumArticle + ' - Le cout unitaire HT sera alimenté par le prix indiqué dans la fiche article');

                end;
            }
        }
    }

    trigger OnPostXmlPort()
    begin
        MESSAGE('Traitement terminé !');
    end;

    var
        MyPurchaseHeader: Record "Purchase Header";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NewLineNo: Integer;
        NumCommande: Code[20];
        MyQuantity: Decimal;
        MyUnitCost: Decimal;
        MyPostingDate: Date;
        MyAtelier: Text[30];
        MyRefDCTL: Text[30];
}

