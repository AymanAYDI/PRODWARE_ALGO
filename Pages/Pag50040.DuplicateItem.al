page 50040 "Duplicate Item"
{
    // version ALG2.00

    // // Modificaiton du 20180629_1022 ==================================
    // // Lignes de code ajoutée suite GLPI Projet 00049
    // // pour eviter la duplication des codes et reference client
    // // RecLItem."BarCode EAN13" :='';
    // // RecLItem."Customer Item No." := '';
    // // Modificaiton du 20180629_1022 ==================================

    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = Item;

    layout
    {
        area(content)
        {
            group(Options)
            {
                field(NewItemNo; NewItemNo)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'New No.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("<Action1906587504>")
            {
                Caption = 'F&unctions';
                action("<Action1100267021>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Duplicate';
                    Image = Confirm;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        RecLItem: Record Item;
                        RecLItemUnitOfMeasure: Record "Item Unit of Measure";
                        RecLNewItemUnitOfMeasure: Record "Item Unit of Measure";
                    begin
                        IF RecLItem.GET(NewItemNo) THEN
                            MESSAGE(Text001, NewItemNo);

                        RecLItem.INIT();
                        RecLItem.COPY(Rec);
                        RecLItem."No." := NewItemNo;

                        // 20180629_1022 - Lignes de code ajoutée suite GLPI Projet 00049
                        RecLItem."BarCode EAN13" := '';
                        RecLItem."Customer Item No." := '';
                        RecLItem."Last Date Modified" := 0D;

                        RecLItem.INSERT(TRUE);

                        RecLItemUnitOfMeasure.SETRANGE("Item No.", Rec."No.");
                        IF RecLItemUnitOfMeasure.FINDSET() THEN
                            REPEAT
                                RecLNewItemUnitOfMeasure.INIT();
                                RecLNewItemUnitOfMeasure.COPY(RecLItemUnitOfMeasure);
                                RecLNewItemUnitOfMeasure."Item No." := NewItemNo;
                                RecLNewItemUnitOfMeasure.INSERT(TRUE);
                            UNTIL RecLItemUnitOfMeasure.NEXT() = 0;

                        COMMIT();
                        RecLItem.RESET();
                        RecLItem.GET(NewItemNo);
                        PAGE.RUN(PAGE::"Item Card", RecLItem);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        NewItemNo := Rec."No.";
    end;

    var
        NewItemNo: Code[20];
        Text001: Label 'L''article %1 existe déjà';
}

