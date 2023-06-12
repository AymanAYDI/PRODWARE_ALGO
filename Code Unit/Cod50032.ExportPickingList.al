codeunit 50032 "Export Picking List"
{
    // version ALGO,CLIC

    // ------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // ------------------------------------------------------------------------
    // 
    // //>>ALGO
    // ALGO:TO 28/05/205 : Création Interface
    // 
    // Depuis la livraison de l'entrpôt. Si lancé alors généré un fichier simple,
    // N°document origine. Nom fichier : Expe_No Expé.csv
    // directement sur \\vmnav\Partage\Picking\


    trigger OnRun()
    begin
    end;

    var
        ExcelBuf: Record "CSV Buffer" temporary;
        RecGWarehouseShipmentHeader: Record "Warehouse Shipment Header";
        RecGWarehouseShipmentLine: Record "Warehouse Shipment Line";
        Text001: Label 'Lignes Colisage', Locked = true;
        FileName: Text[80];
        FilePath: Text[250];
        SenderName: Text[100];
        SenderAddress: Text[100];
        Recipient: Text[100];
        Subject: Text[100];
        Body: Text[1024];
        CopyMail: Text[100];
        CodGPreviousNo: Code[10];
        CodGPreviousSourceNo: Code[10];

    procedure Export(var RecPWarehouseShipmentHeader: Record "Warehouse Shipment Header")
    begin
        IF COMPANYNAME() <> 'CLIC' THEN
            EXIT;
        RecGWarehouseShipmentHeader.RESET();
        RecGWarehouseShipmentHeader.COPY(RecPWarehouseShipmentHeader);

        RecGWarehouseShipmentLine.RESET();
        RecGWarehouseShipmentLine.SETCURRENTKEY("No.", "Source Document", "Source No.");
        RecGWarehouseShipmentLine.SETRANGE("No.", RecGWarehouseShipmentHeader."No.");
        RecGWarehouseShipmentLine.SETFILTER("Source Line No.", '%1', 1000);

        IF RecGWarehouseShipmentLine.FINDFIRST() THEN
            MakeExcelInfo();
        MakeExcelDataBody();
        SaveExcelbook();
    end;

    local procedure MakeExcelInfo()
    begin
        ExcelBuf.DeleteAll();
    end;

    local procedure MakeExcelDataHeader()
    begin
    end;

    local procedure MakeExcelDataBody()
    begin
        intGLineNo += 1;
        ExcelBuf.InsertEntry(intGLineNo, 1, RecGWarehouseShipmentLine."Source No.");
    end;

    local procedure SaveExcelbook()
    var
        CompanyInfo: Record "Company Information";
    begin
        CompanyInfo.get();
        CompanyInfo.TestField("Picking Path");
        FileName := STRSUBSTNO('Expe-%1.csv', FctShipNo(RecGWarehouseShipmentHeader."No."));
        FilePath := CompanyInfo."Picking Path" + '\' + FileName;
        ExcelBuf.SaveData(FilePath, ';');
    end;

    local procedure FctTime(Time: Time): Text[30]
    var
        TxtTime: Text[30];
    begin
        TxtTime := FORMAT(Time);

        REPEAT
            TxtTime := DELSTR(TxtTime, STRPOS(TxtTime, ':'), 1);
        UNTIL STRPOS(TxtTime, ':') = 0;

        EXIT(TxtTime);
    end;

    local procedure FctShipNo(CodPShipNo: Code[20]): Code[20]
    var
        CodLShipNo: Code[20];
    begin
        CodLShipNo := CodPShipNo;
        //Replace characters
        IF STRPOS(CodPShipNo, '/') > 0 THEN
            CodLShipNo := DELSTR(CodPShipNo, STRPOS(CodPShipNo, '/'), 1);

        EXIT(CodLShipNo);
    end;

    var
        intGLineNo: Integer;
}

