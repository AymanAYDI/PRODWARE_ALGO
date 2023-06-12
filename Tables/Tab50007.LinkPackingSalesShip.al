
table 50007 "Link Packing/Sales Ship."
{
    // version ALG2.01

    // ------------------------------------------------------------------------
    // 
    // Prodware - www.prodware.fr
    // 
    // ------------------------------------------------------------------------
    // 
    // 
    // //>>ALG1.00.00.00
    // 
    // //>>FEVT004.001:PHDA 10/02/2007 : Creation
    // 
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - ALGO                                                                                                |
    // | http://www.prodware.fr                                                                                         |
    // |                                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // //>>ALG2.01
    // 
    //       - ALG2.01 : Colisage pour les expéditions entrepôt depuis les documents
    //                  - Add New Field : "Whse.Posted Shipment No."
    // +----------------------------------------------------------------------------------------------------------------+


    fields
    {
        field(1; "Packing header No."; Code[20])
        {
            Caption = 'Packing header No.';
            DataClassification = CustomerContent;
        }
        field(2; "Sales Shipment No."; Code[20])
        {
            Caption = 'Sales Shipment No.';
            DataClassification = CustomerContent;
        }
        field(10; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            DataClassification = CustomerContent;
        }
        field(11; "Whse. Shipment No."; Code[20])
        {
            Caption = 'Whse. Shipment No.';
            DataClassification = CustomerContent;
        }
        field(12; "Sales invoice No."; Code[20])
        {
            Caption = 'Sales invoice No.';
            DataClassification = CustomerContent;
        }
        field(30; "Whse.Posted Shipment No."; Code[20])
        {
            Caption = 'Whse.Posted Shipment No.';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Packing header No.", "Sales Shipment No.")
        {
        }
    }

    fieldgroups
    {
    }
}

