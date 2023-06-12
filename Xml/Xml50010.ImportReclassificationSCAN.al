xmlport 50010 "Import Reclassification SCAN"
{
    // version CLIC

    // 
    // //>>ALGO_16/01/2018 : CREATE

    Caption = 'Import Sheet Reclassification SCAN';
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
                textelement(ItemNo)
                {
                }
                textelement(QuantityString)
                {
                }
                textelement(LocationCode)
                {
                }
                textelement(BinCode)
                {
                }
                textelement(NewLocationCode)
                {
                }
                textelement(NewBinCode)
                {
                }

                trigger OnBeforeInsertRecord()
                begin

                    MyItemJournalLine.INIT;
                    NewLineNo += 10000;
                    MyItemJournalLine."Line No." := NewLineNo;
                    MyItemJournalLine.VALIDATE("Journal Template Name", 'RECLASS');
                    MyItemJournalLine.VALIDATE("Journal Batch Name", 'SCAN');
                    MyItemJournalLine.VALIDATE("Item No.", ItemNo);
                    MyItemJournalLine."Location Code" := LocationCode;
                    MyItemJournalLine."Bin Code" := BinCode;
                    MyItemJournalLine."New Location Code" := NewLocationCode;
                    MyItemJournalLine."New Bin Code" := NewBinCode;
                    MyItemJournalLine.VALIDATE("Source Code", 'FRECLASS');
                    MyItemJournalLine."Entry Type" := MyItemJournalLine."Entry Type"::Transfer;
                    MyItemJournalLine."Posting Date" := TODAY;
                    MyItemJournalLine."Document No." := STRSUBSTNO(Txt001, TODAY);
                    MyItemJournalLine."New Shortcut Dimension 1 Code" := MyItemJournalLine."New Shortcut Dimension 1 Code";
                    MyItemJournalLine."New Shortcut Dimension 2 Code" := MyItemJournalLine."Shortcut Dimension 2 Code";

                    IF EVALUATE(MyQuantity, QuantityString) THEN BEGIN
                        MyItemJournalLine.VALIDATE(Quantity, MyQuantity);
                    END;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    var
        NewLineNo: Integer;
        MyQuantity: Decimal;
        Txt001: Label 'SCAN-%1', Locked = true;
}

