table 50006 "Posted Packing Line ALGO"
{
    // version ALG2.01,CLIC2015-001

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
    // //>>FEVT004.002:SEBC 12/02/2007 : Add key
    //                                   Parcel No.
    // 
    // //>>ALG1.04
    // CORRECTION TO 06/12/07 : Packing List
    //                         - Add field 32 "Parcel No. Integer"
    //                         - Add key "Parcel No. Integer"
    // 
    // //>>20/07/2015 EMAILHOL : Create new field 50000 "Cust Ref."
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

    Caption = 'Packing Line ALGO';

    fields
    {
        field(1; "Packing Document No."; Code[20])
        {
            Caption = 'Packing Document No.';
            DataClassification = CustomerContent;
        }
        field(2; "Shipment Document No."; Code[20])
        {
            Caption = 'Shipment Document No.';
            DataClassification = CustomerContent;
        }
        field(3; "Shipment Line No."; Integer)
        {
            Caption = 'Shipment Line No.';
            DataClassification = CustomerContent;
        }
        field(4; "Parcel No."; Code[20])
        {
            Caption = 'Parcel';
            DataClassification = CustomerContent;
        }
        field(10; "Parcel Line"; Integer)
        {
            Caption = 'Parcel Line';
            DataClassification = CustomerContent;
        }
        field(12; "Parcel Weight"; Decimal)
        {
            Caption = 'Weight';
            DataClassification = CustomerContent;
        }
        field(13; "Parcel Quantity"; Decimal)
        {
            Caption = 'Parcel Quantity';
            DataClassification = CustomerContent;
        }
        field(14; Pallet; Code[20])
        {
            Caption = 'Pallet';
            DataClassification = CustomerContent;
        }
        field(15; "Pallet Weight"; Decimal)
        {
            Caption = 'Pallet Weight';
            DataClassification = CustomerContent;
        }
        field(16; PO; Code[20])
        {
            Caption = 'PO';
            DataClassification = CustomerContent;
        }
        field(17; Item; Code[20])
        {
            Caption = 'Item';
            DataClassification = CustomerContent;
        }
        field(18; "Document Type"; Option)
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
            OptionCaption = 'Shipment,Invoice';
            OptionMembers = Shipment,Invoice;
        }
        field(19; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
            TableRelation = "Sales Header"."No." WHERE("Document Type" = FIELD("Document Type"));
        }
        field(20; "Delivery No."; Code[20])
        {
            Caption = 'Delivery No.';
            DataClassification = CustomerContent;
        }
        field(21; "Invoice No."; Code[20])
        {
            Caption = 'Invoice No.';
            DataClassification = CustomerContent;
        }
        field(22; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
        }
        field(29; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            DataClassification = CustomerContent;
        }
        field(30; "Source Line No."; Integer)
        {
            Caption = 'Source Line No.';
            DataClassification = CustomerContent;
        }
        field(31; "Sales Shipment No."; Code[20])
        {
            Caption = 'Sales Shipment No.';
            DataClassification = CustomerContent;
        }
        field(32; "Parcel No. Integer"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(33; "Sales Shipment Line No."; Integer)
        {
            Caption = 'Sales Shipment Line No.';
            DataClassification = CustomerContent;
        }
        field(40; "Whse.Posted Shipment No."; Code[20])
        {
            Caption = 'Whse.Posted Shipment No.';
            DataClassification = CustomerContent;
        }
        field(41; "Whse.Posted Shipment Line No."; Integer)
        {
            Caption = 'Whse.Posted Shipment Line No.';
            DataClassification = CustomerContent;
        }
        field(50000; "Cust Ref."; Code[30])
        {
            Caption = 'Cust Ref';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Packing Document No.", "Shipment Document No.", "Shipment Line No.", "Parcel No.")
        {
        }
        key(Key2; "Parcel No.")
        {
        }
        key(Key3; Pallet)
        {
        }
        key(Key4; "Parcel No. Integer")
        {
        }
    }

    fieldgroups
    {
    }
}

