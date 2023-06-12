tableextension 50036 "Warehouse Shipment Line" extends "Warehouse Shipment Line"
{
    //t7321
    fields
    {
        field(50000; "Available Parcel Quantity"; Decimal)
        {
            Caption = 'Quanité colisée disponible';
            DataClassification = CustomerContent;
        }
        field(50001; "Parcel Quantity"; Decimal)
        {
            Caption = 'Quantité colisée';
            DataClassification = CustomerContent;
        }
        field(50002; "Promised Delivery Date"; Date)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Lookup("Sales Line"."Promised Delivery Date" WHERE("Document No." = FIELD("Source No."),
                                                                              "Line No." = FIELD("Line No.")));
            Caption = 'Date livraison confirmée';
        }
        field(50003; PO; Code[20])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup("Sales Line".PO WHERE("Document No." = FIELD("Source No."),
                                                        "Line No." = FIELD("Source Line No."),
                                                        "Document Type" = FILTER(Order)));
            Caption = 'PO';
        }
        field(50004; "Cust Ref."; Code[30])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup("Sales Line"."Cust Ref." WHERE("Document No." = FIELD("Source No."),
                                                                 "Line No." = FIELD("Source Line No."),
                                                                 "Document Type" = FILTER(Order)));
            Caption = 'Cust Ref';
        }
        field(50005; PO2; Code[20])
        {
            Caption = 'PO2';
            DataClassification = CustomerContent;
        }
        field(50006; Inventory; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("Item No."),
                                                                  "Location Code" = FIELD("Location Code")));
            Caption = 'Stock';
        }
        field(50007; "Bin Inventory"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Warehouse Entry".Quantity WHERE("Item No." = FIELD("Item No."),
                                                                "Location Code" = FIELD("Location Code"),
                                                                "Bin Code" = FIELD("Bin Code")));
            Caption = 'Contenu Emplacement';
        }
        field(50009; "Tracking No."; Text[100])
        {
            Caption = 'No. de Lot';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                TransferLine: Record "Transfer Line";
            begin
                IF ("Source Document" = "Source Document"::"Outbound Transfer") AND (COMPANYNAME() = 'ALGO PROD') THEN
                    //Transfert
                    TransferLine.GET("Source No.", "Source Line No.");
                TransferLine.VALIDATE("Tracking No.", "Tracking No.");
                TransferLine.MODIFY(TRUE);
            end;
        }
        field(50010; "In Parcel Qty"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Packing Line ALGO".Quantity WHERE("Shipment Document No." = FIELD("No."),
                                                                  "Shipment Line No." = FIELD("Line No."),
                                                                  Item = FIELD("Item No.")));
            Caption = 'Qté en colis';
        }

    }

    trigger OnModify()
    var
    begin
        FctTestPackingExistRaisedError();
    end;


    PROCEDURE ShowPackingInformation()
    VAR
        RecLPackingInfo: Record "Packing information ALGO";
        FrmLPackingInfo: Page "Packing Information ALGO";
        RecLItem: Record Item;
        RecLPackingHeaderAlgo: Record "Packing Header ALGO";
        RecLPackingLineAlgo: Record "Packing Line ALGO";
        RecLSalesLine: Record "Sales Line";
    BEGIN
        TESTFIELD("Source No.");
        TESTFIELD("Line No.");

        IF NOT FctTestPackingExist(RecLPackingHeaderAlgo) THEN
            FctInsertHeaderPacking(RecLPackingHeaderAlgo);

        RecLPackingLineAlgo.RESET();
        RecLPackingLineAlgo.SETFILTER("Packing Document No.", '%1', RecLPackingHeaderAlgo."No.");
        RecLPackingLineAlgo.SETFILTER("Shipment Document No.", '%1', "No.");
        RecLPackingLineAlgo.SETFILTER("Shipment Line No.", '%1', "Line No.");

        FrmLPackingInfo.SETTABLEVIEW(RecLPackingLineAlgo);
        FrmLPackingInfo.GetQty("Qty. to Ship");
        FrmLPackingInfo.GetItemNo("Item No.");
        FrmLPackingInfo.FctSetSourceLineNo("Source Line No.", "Source No.");
        IF RecLItem.GET("Item No.") THEN BEGIN
            FrmLPackingInfo.GetNetWeight(RecLItem."Net Weight");
            FrmLPackingInfo.GetGrossWeight(RecLItem."Gross Weight");
        END;

        COMMIT();
        FrmLPackingInfo.RUNMODAL();

    END;

    PROCEDURE FctInsertHeaderPacking(VAR RecPackingHeaderAlgo: Record "Packing Header ALGO")
    VAR
        RecLSalesReceivablesSetup: Record "Sales & Receivables Setup";
        SalesHeader: Record "Sales Header";
        TransferLine: Record "Transfer Line";
        CduLNoSeriesMgt: Codeunit NoSeriesManagement;
    BEGIN
        RecLSalesReceivablesSetup.GET();
        CduLNoSeriesMgt.InitSeries(RecLSalesReceivablesSetup."Packing List No.", RecPackingHeaderAlgo."Series No.", 0D,
                                                                  RecPackingHeaderAlgo."No.", RecPackingHeaderAlgo."Series No.");
        RecPackingHeaderAlgo.INSERT();
        RecPackingHeaderAlgo."Warehouse Shipment No." := "No.";
        //>>P18635_002.001
        CASE "Source Type" OF
            DATABASE::"Sales Line":
                BEGIN
                    SalesHeader.GET("Source Subtype", "Source No.");
                    RecPackingHeaderAlgo."Customer Code" := SalesHeader."Sell-to Customer No.";
                END;
        END;

        CASE "Source Type" OF
            DATABASE::"Transfer Line":
                BEGIN
                    TransferLine.GET("Source No.", "Source Line No.");
                    RecPackingHeaderAlgo."Customer Code" := TransferLine."Transfer-to Code";
                END;
        END;

        //<<P18635_002.001
        RecPackingHeaderAlgo.MODIFY();
    END;

    PROCEDURE FctTestPackingExist(VAR RecPackingHeaderAlgo: Record "Packing Header ALGO"): Boolean
    VAR
        RecLPackingHeaderALGO: Record "Packing Header ALGO";
    BEGIN
        RecPackingHeaderAlgo.RESET();
        RecPackingHeaderAlgo.SETCURRENTKEY("Warehouse Shipment No.");
        RecPackingHeaderAlgo.SETFILTER("Warehouse Shipment No.", '%1', "No.");
        EXIT(RecPackingHeaderAlgo.FINDFIRST());
    END;

    PROCEDURE FctTestPackingExistRaisedError()
    VAR
        RecLPackingLineAlgo: Record "Packing Line ALGO";
        Text038: Label 'Packing information exists for document No. %1, Lne No. %2.';
    BEGIN
        RecLPackingLineAlgo.RESET();
        RecLPackingLineAlgo.SETFILTER("Shipment Document No.", '%1', "No.");
        RecLPackingLineAlgo.SETFILTER("Shipment Line No.", '%1', "Line No.");
        IF RecLPackingLineAlgo.FINDFIRST() THEN
            ERROR(Text038, "No.", "Line No.");
    END;


}