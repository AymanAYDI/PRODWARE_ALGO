xmlport 50001 "Import Purchase Line ALGO"
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
                textelement(PostingDate)
                {
                }
                textelement(VendorNo)
                {
                }
                textelement(PO)
                {
                }
                textelement(ItemNo)
                {
                }
                textelement(Decription)
                {
                }
                textelement(Description2)
                {
                }
                textelement(QuantityString)
                {
                }
                textelement(Unit)
                {
                }
                textelement(UnitCost)
                {
                }
                textelement(Amount)
                {
                }
                textelement(Ship)
                {
                }
                textelement(OrderVendor)
                {
                }
                //textelement(LocationCode)
                //{
                //    MinOccurs = Zero;
                //}

                trigger OnBeforeInsertRecord()
                begin
                    if DocNo = '#TOTAL#' then currXMLport.Skip();

                    IF NOT (MyPurchaseHeader."No." = DocNo) THEN BEGIN
                        MyPurchaseHeader.INIT();
                        MyPurchaseHeader."Document Type" := MyPurchaseHeader."Document Type"::Order;
                        MyPurchaseHeader."No." := DocNo;
                        MyPurchaseHeader.VALIDATE("Buy-from Vendor No.", 'ALGO');
                        MyPurchaseHeader."Vendor Invoice No." := DocNo;
                        MyPurchaseHeader."Vendor Order No." := OrderVendor;

                        IF EVALUATE(MyPostingDate, PostingDate) THEN
                            MyPurchaseHeader.VALIDATE("Posting Date", MyPostingDate);

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
                    MyPurchaseLine.Description := Decription;
                    MyPurchaseLine."Description 2" := Description2;
                    MyPurchaseLine."Unit of Measure" := Unit;
                    MyPurchaseLine."P.O." := PO;
                    MyPurchaseLine."Location Code" := 'CLIC';


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

