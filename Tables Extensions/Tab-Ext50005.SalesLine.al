tableextension 50005 "Sales Line" extends "Sales Line"
{
    //t37
    fields
    {
        field(50000; PO; Code[20])
        {
            Caption = 'PO';
            DataClassification = CustomerContent;
        }
        field(50001; PROFORMA; Boolean)
        {
            Caption = 'PROFORMA';
            Editable = true;
            DataClassification = CustomerContent;
        }


        field(50002; "Cust Ref."; Code[30])
        {
            Caption = 'Cust Ref';
            DataClassification = CustomerContent;
        }
        //>>#69_20211129
        //>> Activation lignes de code 202211 - DDE : JVE - EXEC : DSP
        field(50003; "MOQ"; Decimal)
        {
            Caption = 'MOQ';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50004; "Multiple"; Decimal)
        {
            Caption = 'Multiple';
            DataClassification = CustomerContent;
            Editable = false;
        }
        //>> Activation lignes de code 202211 - DDE : JVE - EXEC : DSP
        //<<#69_20211129         
    }

    //>>#69_20211129
    //>> Activation lignes de code 202211 - DDE : JVE - EXEC : DSP

    TRIGGER OnInsert()

    begin

        // Parcours des entetes CV pour récupérer la date de commande
        // Parcours des Sales Price pour récupérer le MOQ

        RecGSalesPrice.RESET();
        RecGSalesHeader.RESET();
        SalesPrice_MOQ := 0;
        SalesPrice_Multiple := 0;
        SalesHeaderDateOrder := 0D;

        RecGSalesHeader.SETFILTER(RecGSalesheader."No.", '%1', "Document No.");
        IF RecGSalesHeader.FINDSET() THEN BEGIN
            SalesHeaderDateOrder := RecGSalesheader."Order Date";
        END;

        RecGSalesPrice.SETFILTER(RecGSalesPrice."Item No.", '%1', "No.");
        RecGSalesPrice.SETFILTER(RecGSalesPrice."Unit Price", '%1', "Unit Price");
        RecGSalesPrice.SETFILTER(RecGSalesPrice."Starting Date", '%1|<=%2', 0D, SalesHeaderDateOrder);
        RecGSalesPrice.SETFILTER(RecGSalesPrice."Ending Date", '%1|>=%2', 0D, SalesHeaderDateOrder);
        IF RecGSalesPrice.FINDSET() THEN BEGIN
            MOQ := RecGSalesPrice.MOQ;
            Multiple := RecGSalesPrice.Multiple;
        END;

    end;
    //>> Activation lignes de code 202211 - DDE : JVE - EXEC : DSP
    //<<#69_20211129 

    local procedure ShowPackingInformation()
    var
        RecLPackingInfo: Record "Packing information ALGO";
        FrmLPackingInfo: Page "Packing Information ALGO";
    begin
        TESTFIELD("Document No.");
        TESTFIELD("Line No.");
        TESTFIELD(Type, Type::Item);
        RecLPackingInfo.SETRANGE("Document No.", "Document No.");
        RecLPackingInfo.SETRANGE("Document Type", "Document Type");
        RecLPackingInfo.SETRANGE("Line No.", "Line No.");
        RecLPackingInfo.SETRANGE(Item, "No.");
        RecLPackingInfo.SETRANGE(Status, RecLPackingInfo.Status::"In Progress");
        FrmLPackingInfo.SETTABLEVIEW(RecLPackingInfo);
        IF "Document Type" = "Document Type"::Invoice THEN
            FrmLPackingInfo.GetQty(Quantity)
        ELSE
            IF "Location Code" <> '' THEN
                FrmLPackingInfo.GetQty(Quantity)
            ELSE
                FrmLPackingInfo.GetQty("Qty. to Ship");

        FrmLPackingInfo.GetItemNo("No.");
        FrmLPackingInfo.GetNetWeight("Net Weight");
        FrmLPackingInfo.GetGrossWeight("Gross Weight");
        FrmLPackingInfo.RUNMODAL();
    end;

    procedure TestPackingExit(SaleLine: Record "Sales Line")
    var
        RecLPacking: Record "Packing information ALGO";
        Text038: Label 'You cannot change %1 when %2 is %3 and %4 is negative.';
    begin
        RecLPacking.RESET();
        RecLPacking.SETFILTER("Document No.", SaleLine."Document No.");
        RecLPacking.SETRANGE("Line No.", SaleLine."Line No.");
        RecLPacking.SETRANGE("Document Type", SaleLine."Document Type");
        IF RecLPacking.FINDFIRST() THEN
            ERROR(Text038, SaleLine."Document No.", SaleLine."Line No.");
    end;

    procedure FctShowReservationQty();
    var
        FrmGReservQty: Page "Reservation Qty.";
    begin
        TESTFIELD(Type, Type::Item);
        TESTFIELD("No.");
        TESTFIELD(Reserve);
        CLEAR(FrmGReservQty);
        FrmGReservQty.SetSalesLine(Rec);
        FrmGReservQty.RUNMODAL();
    end;

    //>> Activation lignes de code 202211 - DDE : JVE - EXEC : DSP
    //<<#69_20211129 
    VAR
        RecGSalesPrice: Record "Sales Price";
        RecGSalesHeader: Record "Sales header";
        SalesPrice_MOQ: Decimal;
        SalesPrice_Multiple: Decimal;
        SalesHeaderDateOrder: Date;
    //>> Activation lignes de code 202211 - DDE : JVE - EXEC : DSP
    //<<#69_20211129 

}
