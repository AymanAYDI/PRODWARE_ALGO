table 50004 "Packing Line ALGO"
{
    // version ALG2.01,CLIC2015-001

    // ------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // ------------------------------------------------------------------------
    // 
    // //>>ALG1.00.00.00
    // 
    // FEVT004.001 CASC 10/02/2007 : Packing List
    // // FLGR 15/02/2007 : add key Item
    // 
    // //>>ALG1.04
    // CORRECTION TO 06/12/07 : Packing List
    //                         - Add field 32 "Parcel No. Integer"
    //                         - Update trigger Parcel No. - OnValidate
    // 
    // //>>ALG1.20
    // P18635_002.001 DO:ALMI 02/04/2013  : Fe-Gestion de colissage Prod'WIM
    //                                     - Add key Packing Document No.,Parcel No. Integer
    //                                     - Add C/AL code ONValidate qty
    //                                     - Add C/AL Code on Insert
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
    // 
    // //>>20180907 - DSPEYER : Ajout C/AL sur le champs PALLET WEIGHT :  Ajout de la replication de la valeur du poids de la palette
    // //  - c'est un code dupliqué du champs Poids à la base et modifié pour le poids palette
    // //  - également il a été modifié pour appliquer le poids palette au même numéro de Palette,
    // //    pour la même exp magasin et toutes ses lignes associées

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

            trigger OnValidate()
            begin
                //>>ALG1.04
                EVALUATE("Parcel No. Integer", "Parcel No.");
                //>>ALG1.04
            end;
        }
        field(10; "Parcel Line"; Integer)
        {
            Caption = 'Parcel Line';
            DataClassification = CustomerContent;
            Description = 'Parcel Line No.';
        }
        field(12; "Parcel Weight"; Decimal)
        {
            Caption = 'Weight';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                recLPackingLineALGO: Record "Packing Line ALGO";
                recLPackingParcelALGO: Record "Packing Parcel ALGO";
            begin
                recLPackingLineALGO.RESET();
                recLPackingLineALGO.SETRANGE("Packing Document No.", "Packing Document No.");
                recLPackingLineALGO.SETRANGE("Shipment Document No.", "Shipment Document No.");
                recLPackingLineALGO.SETRANGE("Parcel No.", "Parcel No.");
                recLPackingLineALGO.SETFILTER("Shipment Line No.", '<>%1', "Shipment Line No.");
                IF recLPackingLineALGO.FINDSET() THEN
                    REPEAT
                        recLPackingLineALGO."Parcel Weight" := "Parcel Weight";
                        recLPackingLineALGO.MODIFY();
                    UNTIL recLPackingLineALGO.NEXT() = 0;

                recLPackingParcelALGO.RESET();
                recLPackingParcelALGO.SETRANGE("Packing Document No.", "Packing Document No.");
                recLPackingParcelALGO.SETRANGE("Parcel No. Integer", "Parcel No. Integer");
                IF recLPackingParcelALGO.FINDFIRST() THEN BEGIN
                    recLPackingParcelALGO."Parcel Weight" := "Parcel Weight";
                    recLPackingParcelALGO.MODIFY();
                END;
            end;
        }
        field(13; "Parcel Quantity"; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
        }
        field(14; Pallet; Code[20])
        {
            Caption = 'Pallet';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                recLPackingLineALGO: Record "Packing Line ALGO";
                recLPackingParcelALGO: Record "Packing Parcel ALGO";
            begin
                recLPackingLineALGO.RESET();
                recLPackingLineALGO.SETRANGE("Packing Document No.", "Packing Document No.");
                recLPackingLineALGO.SETRANGE("Shipment Document No.", "Shipment Document No.");
                recLPackingLineALGO.SETRANGE("Parcel No.", "Parcel No.");
                recLPackingLineALGO.SETFILTER("Shipment Line No.", '<>%1', "Shipment Line No.");
                IF recLPackingLineALGO.FINDSET() THEN
                    REPEAT
                        recLPackingLineALGO.Pallet := Pallet;
                        recLPackingLineALGO.MODIFY();
                    UNTIL recLPackingLineALGO.NEXT() = 0;

                recLPackingParcelALGO.RESET();
                recLPackingParcelALGO.SETRANGE("Packing Document No.", "Packing Document No.");
                recLPackingParcelALGO.SETRANGE("Parcel No. Integer", "Parcel No. Integer");
                IF recLPackingParcelALGO.FINDFIRST() THEN BEGIN
                    recLPackingParcelALGO.Pallet := Pallet;
                    recLPackingParcelALGO.MODIFY();
                END;
            end;
        }
        field(15; "Pallet Weight"; Decimal)
        {
            Caption = 'Pallet Weight';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                recLPackingLineALGO: Record "Packing Line ALGO";
            begin

                //>>20180907 - Ajout de la replication de la valeur du poids de la palette

                recLPackingLineALGO.RESET();
                recLPackingLineALGO.SETRANGE("Packing Document No.", "Packing Document No.");
                recLPackingLineALGO.SETRANGE("Shipment Document No.", "Shipment Document No.");
                recLPackingLineALGO.SETRANGE(Pallet, Pallet);
                recLPackingLineALGO.SETFILTER("Shipment Line No.", '<>%1', "Shipment Line No.");
                IF recLPackingLineALGO.FINDSET() THEN
                    REPEAT
                        recLPackingLineALGO."Pallet Weight" := "Pallet Weight";
                        recLPackingLineALGO.MODIFY();
                    UNTIL recLPackingLineALGO.NEXT() = 0;
            end;
        }
        field(16; PO; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(17; Item; Code[20])
        {
            Caption = 'Item';
            DataClassification = CustomerContent;
        }
        field(18; "Document Type"; Option)
        {
            OptionCaption = 'Shipment,Invoice';
            DataClassification = CustomerContent;
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

            trigger OnValidate()
            var
                RecLWarHouseShipLine: Record "Warehouse Shipment Line";
            begin
                //>>P18635_002.001
                IF RecLWarHouseShipLine.GET("Shipment Document No.", "Shipment Line No.") THEN BEGIN
                    RecLWarHouseShipLine.VALIDATE("Available Parcel Quantity", RecLWarHouseShipLine."Available Parcel Quantity" - Quantity);
                    RecLWarHouseShipLine.MODIFY(FALSE);
                END;
                //<<P18635_002.001

            end;
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
        key(Key3; Item)
        {
        }
        key(Key4; Item, "Parcel No.", Pallet)
        {
        }
        key(Key5; "Packing Document No.", "Parcel No. Integer")
        {
            SumIndexFields = "Parcel Weight", "Parcel Quantity";
        }
        key(Key6; "Shipment Document No.", "Shipment Line No.", Item)
        {
            SumIndexFields = Quantity;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        LrecPackingParcelALGO: Record "Packing Parcel ALGO";
    begin
        //>>P18635_002.001
        IF NOT LrecPackingParcelALGO.GET("Packing Document No.", "Parcel No.") THEN BEGIN
            LrecPackingParcelALGO.INIT();
            LrecPackingParcelALGO."Packing Document No." := "Packing Document No.";
            LrecPackingParcelALGO."Parcel No. Integer" := "Parcel No. Integer";
            LrecPackingParcelALGO.INSERT();
        END;
        //<<P18635_002.001
    end;

}

