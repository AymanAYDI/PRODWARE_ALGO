table 50020 "Temp Treatment Sale Order"
{
    // version ALG2.00,ALGO,CLIC2015-001

    // ------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // ------------------------------------------------------------------------
    // //>>ALG2.00
    // FED-Algo-20100224-Vente01:MA 22/03/2010  Data port:creation sales order
    //                                              Creation
    // 
    // 
    // //>>20/07/2015 EMAILHOL : Create new field 9 "Cust Ref."

    Caption = 'Temp traitement cde vente';

    fields
    {
        field(1; "No.Order"; Code[20])
        {
            Caption = 'No.Order';
            DataClassification = CustomerContent;
        }
        field(2; "No. Customer"; Code[20])
        {
            Caption = 'No. Customer';
            DataClassification = CustomerContent;
        }
        field(3; "No.Item"; Code[20])
        {
            Caption = 'No.Item';
            DataClassification = CustomerContent;
        }
        field(4; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        field(5; "Order Date"; Date)
        {
            Caption = 'Order Date';
            DataClassification = CustomerContent;
        }
        field(6; "Requested Delivery Date"; Date)
        {
            Caption = 'Requested Delivery Date';
            DataClassification = CustomerContent;
        }
        field(7; "Line No"; Integer)
        {
            Caption = 'Line No';
            DataClassification = CustomerContent;
        }
        field(8; PO; Code[20])
        {
            Caption = 'PO';
            DataClassification = CustomerContent;
        }
        field(9; "Cust Ref."; Code[30])
        {
            Caption = 'Cust Ref.';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "No.Order", "Line No")
        {
        }
    }

    fieldgroups
    {
    }
}

