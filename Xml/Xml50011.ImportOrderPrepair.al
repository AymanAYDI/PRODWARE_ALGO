xmlport 50011 "Import Order Prepair"
{
    Caption = 'Import Order Prepair';
    Direction = Import;
    FieldSeparator = ';';
    Format = VariableText;
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            tableelement(TempTreatmentSaleOrder; "Temp Treatment Sale Order")
            {
                fieldattribute(OrderNo; TempTreatmentSaleOrder."No.Order")
                {

                }
                fieldattribute(RequestDeliveryDate; TempTreatmentSaleOrder."Requested Delivery Date")
                {

                }
                fieldattribute(CustomerNo; TempTreatmentSaleOrder."No. Customer")
                {

                }
                fieldattribute(CustRef; TempTreatmentSaleOrder."Cust Ref.")
                {

                }
                fieldattribute(PO; TempTreatmentSaleOrder.PO)
                {

                }
                fieldattribute(ItemNo; TempTreatmentSaleOrder."No.Item")
                {

                }
                fieldattribute(Qyt; TempTreatmentSaleOrder.Quantity)
                {

                }
                trigger OnBeforeInsertRecord()
                var
                    RecLCustomer: Record Customer;
                begin
                    LineNo += 1;
                    TempTreatmentSaleOrder."Line No" := LineNo;
                    IF TempTreatmentSaleOrder."Order Date" = 0D THEN
                        TempTreatmentSaleOrder."Order Date" := TODAY();
                    IF TempTreatmentSaleOrder."Requested Delivery Date" = 0D THEN
                        IF RecLCustomer.GET(TempTreatmentSaleOrder."No. Customer") THEN
                            TempTreatmentSaleOrder."Requested Delivery Date" := CALCDATE(RecLCustomer."Shipping Time", TODAY())
                        ELSE
                            TempTreatmentSaleOrder."Requested Delivery Date" := TODAY();
                end;

            }
        }
    }
    trigger OnPostXmlPort()
    var
        CuLtreatmentorderssale: Codeunit "treatment orders sale";
        TxtLFile: Text[250];
    begin
        TxtLFile := CuLtreatmentorderssale.FormatPathFile(currXMLport.Filename());
        CuLtreatmentorderssale.Treatment(TxtLFile);
    end;

    var
        LineNo: Integer;
}