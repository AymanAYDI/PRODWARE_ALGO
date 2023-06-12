xmlport 50012 "Vdoc - Import Reclassement"
{
    // 
    // //>>ALGO_01/03/2018 : CREATE
    // // XMLPORT servant à créer les RECLASSEMENTS des NON CONFORMES à partir des fichiers exportés de VDOC.
    // // 19/03/2018 : ajout du n° de scellé dans le n° doc externe
    // // PAGE 393 : Ajout la commande suivante : Actions / VDOC / Import Reclassement VDOC

    Caption = 'Vdoc - Import Reclassement';
    Direction = Import;
    FieldSeparator = ';';
    Format = VariableText;
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            tableelement(myitemjournalline; "Item Journal Line")
            {
                XmlName = 'ItemJournalLine';
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

                    MyItemJournalLine.INIT();
                    NewLineNo += 10000;
                    MyItemJournalLine."Line No." := NewLineNo;
                    MyItemJournalLine.VALIDATE("Journal Template Name", 'RECLASS');
                    MyItemJournalLine.VALIDATE("Journal Batch Name", 'VDOC');
                    MyItemJournalLine.VALIDATE("Item No.", NumArticle);
                    MyItemJournalLine."Location Code" := 'RCT-CONT';
                    MyItemJournalLine."New Location Code" := 'NONCONFORM';
                    MyItemJournalLine.VALIDATE("Source Code", 'FRECLASS');
                    MyItemJournalLine."Entry Type" := MyItemJournalLine."Entry Type"::Transfer;
                    MyItemJournalLine."Posting Date" := TODAY();
                    MyItemJournalLine."External Document No." := NumScelle;
                    MyItemJournalLine."Document No." := RefDCTL;
                    MyItemJournalLine."New Shortcut Dimension 1 Code" := MyItemJournalLine."New Shortcut Dimension 1 Code";
                    MyItemJournalLine."New Shortcut Dimension 2 Code" := MyItemJournalLine."Shortcut Dimension 2 Code";

                    IF EVALUATE(MyQuantity, QuScelle) THEN
                        MyItemJournalLine.VALIDATE(Quantity, MyQuantity);
                end;
            }
        }
    }

    trigger OnPostXmlPort()
    begin
        MESSAGE('Traitement terminé !');
    end;

    var
        NewLineNo: Integer;
        MyQuantity: Decimal;
}

