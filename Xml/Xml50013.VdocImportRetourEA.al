xmlport 50013 "Vdoc - Import Retour (EA)"
{
    // //>>ALGO_01/03/2018 : CREATE
    // // XMLPORT servant à créer les RETOUR des NON CONFORMES à partir des fichiers CSV exportés de VDOC.
    // // OJBETS concernés : T38 - T39 - P9311 - X500013
    // // T39 : Creation du champs 50011 : Vdoc Control No.
    // // T39 : Creation du champs 50012 : VDOC Delivery Order No
    // // P9311 : Ajout de la commande : Import Retour Achat dans Fonction
    // 
    // //>>ALGO_19/03/2018 : CREATE
    // //
    // // P9311 : modification de l'accès à la commande Import Retour Achat dans Actions\VDOC\Import Retour Achat

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
                        CLEAR(MyPurchaseHeader);

                        MyPurchaseHeader."No." := RefDCTL;
                        MyPurchaseHeader."Document Type" := MyPurchaseHeader."Document Type"::"Return Order";
                        MyPurchaseHeader.VALIDATE("Buy-from Vendor No.", Atelier);
                        MyPurchaseHeader."Posting Date" := TODAY();
                        MyPurchaseHeader."Order Date" := TODAY();
                        MyPurchaseHeader.VALIDATE("Location Code", 'NONCONFORM');

                        MyPurchaseHeader.INSERT(TRUE);
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
                    MyPurchaseLine.VALIDATE("Location Code", 'NONCONFORM');
                    MyPurchaseLine."Vdoc Control No." := RefDCTL;
                    MyPurchaseLine."Vdoc Delivery Order No." := NumBL;
                    MyPurchaseLine.VALIDATE("Return Reason Code", 'QUALITE');

                    IF EVALUATE(MyQuantity, QuScelle) THEN BEGIN
                        MyPurchaseLine.VALIDATE(Quantity, MyQuantity);
                        MyPurchaseLine.VALIDATE(MyPurchaseLine."Return Qty. to Ship", MyQuantity);
                    END;

                    // >> Il est important que le prix soit valorisé apres
                    // >> après la quantité, sinon il va rechercher le prix
                    // >> d'achat sur l'article concerné

                    IF EVALUATE(MyUnitCost, PrixUnitaire) THEN
                        MyPurchaseLine.VALIDATE("Direct Unit Cost", MyUnitCost);

                    // 20190711 : Message d'informations
                    if MyUnitCost = 0 then
                        message('Commande Achat : ' + MyPurchaseHeader."No." + ' - Probleme Prix sur article : ' + NumArticle + ' - Le cout unitaire HT sera alimenté par le prix indiqué dans la fiche article');
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
        NewLineNo: Integer;
        MyQuantity: Decimal;
        MyUnitCost: Decimal;
        MyPostingDate: Date;
        MyAtelier: Text[30];
        MyRefDCTL: Text[30];
}

