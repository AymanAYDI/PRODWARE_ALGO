codeunit 50031 "Export Packing List"
{
    // version ALGO,CLIC

    // ------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // ------------------------------------------------------------------------
    // 
    // //>>ALGO
    // ALGO:TO 27/05/205 : Création Interface packing list
    // 
    // Créer un envoie de mail avec en lien le fichier CSV des colisages
    // - Sur la validation de l'expédition.
    // - Peut se réimprimer depuis l'expédition.
    // 
    // -------------------------------------------------------------------------
    // //ALGO CLIC2015-002
    //    24/07/2015 : - Changement texte du message;
    //                 - Changement destiataires messages
    //                 - La pièce jointe n'est plus envoyée dans le mail.
    //                 - Enregistrement du fichier sur \\W7-INFO00\FTP\Packing
    // ----------------------------------------------------------------------------


    trigger OnRun()
    begin
    end;

    var
        ExcelBuf: Record "CSV Buffer" temporary;
        RecSalesShipment: Record "Sales Shipment Header";
        RecPacking: Record "Link Packing/Sales Ship.";
        RecPostedPackingLines: Record "Posted Packing Line ALGO";
        RecGItemTrans: Record "Item Translation";
        RecGSequence: Record "Logistics sequence";
        SMTP: Codeunit "SMTP Mail";
        FileName: Text[250];
        FileName2: Text[250];
        TxtGColor: Text[50];
        SenderName: Text[100];
        SenderAddress: Text[100];
        Recipient: Text[100];
        Subject: Text[100];
        Body: Text[1024];
        CopyMail: Text[100];
        Sequence: Integer;
        TxtBody: Label 'Bonjour, un nouveau fichier colisage concernant le BP n°: %3 pour votre client %2 est envoyé sur le site FTP, vous l''aurez à disposition dans les 15 minutes. L''expédition enregistrée est %1.', Locked = true;
        Text013: Label 'Lignes Colisage', Locked = true;
        Text010: Label 'Désignation 2', Locked = true;

    procedure Export(var RecPShipmentHeader: Record "Sales Shipment Header")
    var
        CompanyInfo: Record "Company Information";
    begin
        IF COMPANYNAME() <> 'CLIC' THEN
            EXIT;

        CompanyInfo.Get();
        CompanyInfo.TestField("Packing Mail Recipient");

        RecSalesShipment.RESET();
        RecSalesShipment.COPY(RecPShipmentHeader);

        RecPacking.SETRANGE("Sales Shipment No.", RecSalesShipment."No.");
        IF RecPacking.FINDSET() THEN BEGIN
            RecPostedPackingLines.RESET();
            RecPostedPackingLines.SETRANGE("Packing Document No.", RecPacking."Packing header No.");
            IF RecPostedPackingLines.COUNT() > 0 THEN BEGIN
                RecPostedPackingLines.FINDSET();
                MakeExcelInfo();
                REPEAT
                    CLEAR(RecGItemTrans.Description);
                    RecGItemTrans.RESET();
                    RecGItemTrans.SETRANGE("Item No.", RecPostedPackingLines.Item);
                    RecGItemTrans.SETRANGE("Language Code", RecSalesShipment."Language Code");
                    IF RecGItemTrans.FINDSET() THEN
                        TxtGColor := RecGItemTrans."Description 2"
                    ELSE
                        TxtGColor := '';

                    RecGSequence.GET();
                    IF RecGSequence.FINDLAST() THEN
                        Sequence := RecGSequence."Sequence No.";



                    MakeExcelDataBody();
                UNTIL RecPostedPackingLines.NEXT() = 0;
                SaveExcelbook();

                CLEAR(SenderName);
                CLEAR(SenderAddress);
                CLEAR(Recipient);
                CLEAR(CopyMail);
                CLEAR(Body);
                CLEAR(Subject);

                SenderName := COMPANYNAME();
                CopyMail := '';
                SenderAddress := 'server@manufacture-algo.com';
                Recipient := CompanyInfo."Packing Mail Recipient";

                Body := STRSUBSTNO(TxtBody, RecSalesShipment."No.", RecSalesShipment."Sell-to Customer No.", RecSalesShipment."Order No.");
                Subject := STRSUBSTNO('Colisage %1 pour %2-BP %3', RecSalesShipment."No."
                                    , RecSalesShipment."Sell-to Customer No.", RecSalesShipment."Order No.");

                SMTP.CreateMessage(SenderName, SenderAddress, Recipient, Subject, Body, FALSE);
                SMTP.Send();
            END;
        END;
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
        ExcelBuf.InsertEntry(intGLineNo, 1, RecPostedPackingLines.Item);
        ExcelBuf.InsertEntry(intGLineNo, 2, RecPostedPackingLines.PO);
        ExcelBuf.InsertEntry(intGLineNo, 3, FORMAT(RecPostedPackingLines.Quantity, 0, 1));
        ExcelBuf.InsertEntry(intGLineNo, 4, RecPostedPackingLines."Parcel No.");
        ExcelBuf.InsertEntry(intGLineNo, 5, RecPostedPackingLines.Pallet);
        ExcelBuf.InsertEntry(intGLineNo, 6, RecPostedPackingLines."Source No.");
        ExcelBuf.InsertEntry(intGLineNo, 7, FORMAT(RecPostedPackingLines."Parcel Weight"));
        ExcelBuf.InsertEntry(intGLineNo, 8, FORMAT(RecPostedPackingLines."Pallet Weight"));
        ExcelBuf.InsertEntry(intGLineNo, 9, FORMAT(Sequence));
    end;

    local procedure SaveExcelbook()
    var
        CompanyInfo: Record "Company Information";
    begin
        CompanyInfo.Get();
        CompanyInfo.TestField("Packing Path");
        FileName := STRSUBSTNO(CompanyInfo."Packing Path", FctShipNo(RecSalesShipment."No.")
                                , RecSalesShipment."Order No.");
        ExcelBuf.SaveData(FileName, ';');
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

