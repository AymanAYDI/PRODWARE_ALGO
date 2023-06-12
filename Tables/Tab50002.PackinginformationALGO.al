table 50002 "Packing information ALGO"
{
    // version ALG1.00.00.00

    // ------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // ------------------------------------------------------------------------
    // 
    // //>>ALG1.00.00.00
    // 
    // FEVT004.001 :16/01/2007:DSFT:Management The Packing List
    //                              - Show Form Packing Information to Size Parcel, Parcel/Palet Weight and quantity
    // FEVT004.002 :02/02/2007:JMCA: Manage Warehouse Shipment in Packing List

    Caption = 'Packing information';

    fields
    {
        field(1; Parcel; Code[20])
        {
            Caption = 'Parcel';
            DataClassification = CustomerContent;
        }
        field(2; Pallet; Code[20])
        {
            Caption = 'Pallet';
            DataClassification = CustomerContent;
        }
        field(3; "Parcel Weight"; Decimal)
        {
            Caption = 'Parcel Weight';
            DataClassification = CustomerContent;
        }
        field(4; "Pallet  Weight"; Decimal)
        {
            Caption = 'Pallet  Weight';
            DataClassification = CustomerContent;
        }
        field(5; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                RecLPackInfo: Record "Packing information ALGO";
                RecLLocation: Record Location;
                FrmLPackingInfo: Page "Packing Information ALGO";
                DecLOldQuantity: Decimal;
            begin
                //>> FEVT004
                DecGParcelQty := 0;
                DecGRemainingQty := 0;
                RecGSalesLine.RESET();
                RecGSalesLine.SETRANGE("Document No.", "Document No.");
                //CASC 0802/07 RecGSalesLine.SETRANGE("Line No.","Line No.");
                ////
                RecGSalesLine.SETRANGE(Type, RecGSalesLine.Type::Item);
                ////
                IF RecGSalesLine.FINDFIRST() THEN
                    IF "Document Type" = "Document Type"::Invoice THEN
                        DecGLineQty := RecGSalesLine.Quantity
                    ELSE
                        //>>FEVT004.002
                        //DecGLineQty:=RecGSalesLine."Qty. to Ship";
                        IF RecGSalesLine."Location Code" <> '' THEN BEGIN
                            RecLLocation.RESET();
                            RecLLocation.GET(RecGSalesLine."Location Code");
                            IF RecLLocation."Require Shipment" THEN
                                DecGLineQty := RecGSalesLine.Quantity
                            ELSE
                                DecGLineQty := RecGSalesLine."Qty. to Ship";
                        END
                        ELSE
                            DecGLineQty := RecGSalesLine."Qty. to Ship";
                //<<FEVT004.002


                RecLPackInfo.RESET();
                RecLPackInfo.SETRANGE("Document No.", "Document No.");
                RecLPackInfo.SETRANGE("Line No.", "Line No.");
                RecLPackInfo.SETRANGE(Status, Status::"In Progress");
                IF RecLPackInfo.FIND('-') THEN
                    REPEAT
                        DecGParcelQty := DecGParcelQty + RecLPackInfo.Quantity;
                    UNTIL RecLPackInfo.NEXT() = 0;
                RecLPackInfo.RESET();
                RecLPackInfo.SETRANGE("Document No.", "Document No.");
                RecLPackInfo.SETRANGE("Line No.", "Line No.");
                RecLPackInfo.SETRANGE(Status, Status::"In Progress");
                RecLPackInfo.SETRANGE("No.", "No.");
                IF RecLPackInfo.FIND('-') THEN BEGIN
                    DecLOldQuantity := RecLPackInfo.Quantity;
                    DecGRemainingQty := DecGLineQty - (DecGParcelQty + (Quantity - DecLOldQuantity));
                END
                ELSE
                    DecGRemainingQty := DecGLineQty - (DecGParcelQty + Quantity);

                FrmLPackingInfo.GetRemainingQty(DecGRemainingQty);
                IF DecGRemainingQty < 0 THEN ERROR(Text001);
                IF Quantity = 0 THEN ERROR(Text002);
                //<< FEVT004
            end;
        }
        field(6; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(7; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(8; "No."; Integer)
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(9; Status; Option)
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            OptionCaption = 'In Progress,Validate';
            OptionMembers = "In Progress",Validate;
        }
        field(10; "Delivery No."; Code[20])
        {
            Caption = 'Delivery No.';
            DataClassification = CustomerContent;
        }
        field(11; "Document Type"; Option)
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(12; "Series No."; Code[20])
        {
            Caption = 'Series No.';
            DataClassification = CustomerContent;
        }
        field(13; Item; Code[20])
        {
            Caption = 'Item';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.", "No.", "Document Type", Item)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        RecLPackInfo: Record "Packing information ALGO";
        RecLSalesLine: Record "Sales Line";
    begin
        DecGParcelQty := 0;
        DecGRemainingQty := 0;

        RecGSalesLine.RESET();
        RecGSalesLine.SETRANGE("Document No.", "Document No.");
        RecGSalesLine.SETRANGE("Line No.", "Line No.");
        IF RecGSalesLine.FINDFIRST() THEN
            //>>FEVT004.002
            IF RecLSalesLine."Location Code" <> '' THEN
                DecGLineQty := RecLSalesLine.Quantity
            ELSE
                //<<FEVT004.002
                DecGLineQty := RecGSalesLine."Qty. to Ship";

        RecLPackInfo.RESET();
        RecLPackInfo.SETRANGE("Document No.", "Document No.");
        RecLPackInfo.SETRANGE("Line No.", "Line No.");
        RecLPackInfo.SETRANGE(Status, Status::"In Progress");
        IF RecLPackInfo.FIND('-') THEN
            REPEAT
                DecGParcelQty := DecGParcelQty + RecLPackInfo.Quantity;
            UNTIL RecLPackInfo.NEXT() = 0;

        IF (DecGParcelQty + Quantity = 0) THEN
            ERROR(Text003);

        IF Quantity = 0 THEN
            ERROR(Text002);
    end;

    var
        RecGSalesLine: Record "Sales Line";
        DecGLineQty: Decimal;
        DecGParcelQty: Decimal;
        DecGRemainingQty: Decimal;
        Text001: Label 'You''ve Exceed The Total Quantity ';
        Text002: Label 'You Must Type a  Quantity ';
        Text003: Label 'The Sum Of Quantity Is Null';
}

