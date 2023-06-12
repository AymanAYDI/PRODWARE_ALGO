xmlport 50003 "Import Purchase Line GAPP"
{
    // version CLIC

    Caption = 'Import Purchase Line';
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
                textelement(DocNo)
                {
                }
                textelement(LineNo)
                {
                }
                textelement(ItemNo)
                {
                }
                textelement(RefGoyard)
                {
                }
                textelement(Codebarre)
                {
                }
                textelement(QuantityString)
                {
                }
                textelement(UnitCost)
                {
                }
                textelement(Devise)
                {
                }

                trigger OnBeforeInsertRecord()
                begin
                    IF NOT (MyPurchaseHeader."No." = DocNo) THEN BEGIN
                        MyPurchaseHeader.INIT();
                        MyPurchaseHeader."Document Type" := MyPurchaseHeader."Document Type"::Order;
                        MyPurchaseHeader."No." := DocNo;
                        MyPurchaseHeader.VALIDATE("Buy-from Vendor No.", 'G.A.P.P');
                        MyPurchaseHeader."Vendor Invoice No." := DocNo;



                        MyPurchaseHeader.INSERT(TRUE);
                        NewLineNo := 0;
                    END;



                    MyPurchaseLine.INIT();
                    MyPurchaseLine."Document Type" := MyPurchaseHeader."Document Type";
                    MyPurchaseLine."Document No." := MyPurchaseHeader."No.";
                    NewLineNo += 10000;
                    MyPurchaseLine."Line No." := NewLineNo;
                    MyPurchaseLine.Type := MyPurchaseLine.Type::Item;
                    MyPurchaseLine.VALIDATE("No.", ItemNo);
                    MyPurchaseLine."Unit of Measure" := 'PCS';
                    MyPurchaseLine."Location Code" := 'QUALITE';


                    IF EVALUATE(MyUnitCost, UnitCost) THEN
                        MyPurchaseLine.VALIDATE("Direct Unit Cost", MyUnitCost);

                    IF EVALUATE(MyQuantity, QuantityString) THEN
                        MyPurchaseLine.VALIDATE(Quantity, MyQuantity);
                end;
            }
        }
    }

    var
        MyPurchaseHeader: Record "Purchase Header";
        NewLineNo: Integer;
        MyQuantity: Decimal;
        MyUnitCost: Decimal;
        MyPostingDate: Date;
}

