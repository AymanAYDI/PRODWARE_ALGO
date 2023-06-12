codeunit 50034 "Export Packing List NAS"
{
    // version ALGO,CLIC

    // ------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // ------------------------------------------------------------------------
    // 
    // //>>ALGO
    // ALGO:TO 10/05/2016 : Création Interface packing list, duplication du 50031
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
    // //>>TO 18/05/16 Creation/Duplication from CU50031
    //                 Add parameter "Job queue Entry" parmeter
    //                 Modify export remove Excel Automation

    Permissions = TableData 110 = rm;
    TableNo = 472;

    trigger OnRun()
    var
        TxtLParameterString: Text[250];
        Pos: Integer;
    begin
        //parameters
        //1-export directory
        //2-recipient

        //Export directory
        TESTFIELD("Parameter String");
        TxtLParameterString := "Parameter String";
        IF (STRPOS(TxtLParameterString, ';')) > 0 THEN
            ExportDirectory := COPYSTR(TxtLParameterString, 1, (STRPOS(TxtLParameterString, ';') - 1));


        //Remove 1st parameter
        TxtLParameterString := COPYSTR(TxtLParameterString, STRPOS(TxtLParameterString, ';') + 1, STRLEN(TxtLParameterString));
        //Recipient
        IF (STRPOS(TxtLParameterString, ';')) > 0 THEN
            ParamRecipient := COPYSTR(TxtLParameterString, 1, (STRPOS(TxtLParameterString, ';') - 1));


        //replace ',' per ';' for recipient.
        WHILE STRPOS(ParamRecipient, ',') <> 0 DO BEGIN
            Pos := STRPOS(ParamRecipient, ',');
            ParamRecipient := DELSTR(ParamRecipient, Pos, 1);
            ParamRecipient := INSSTR(ParamRecipient, ';', Pos);
        END;

        Export();
    end;

    var
        RecSalesShipment: Record "Sales Shipment Header";
        RecPacking: Record "Link Packing/Sales Ship.";
        RecPostedPackingLines: Record "Posted Packing Line ALGO";
        RecGSequence: Record "Logistics sequence";
        RecGItemTrans: Record "Item Translation";
        SMTP: Codeunit "SMTP Mail";
        FileName: Text[250];
        TxtGColor: Text[50];
        SenderName: Text[100];
        SenderAddress: Text[100];
        Recipient: Text[100];
        Subject: Text[100];
        Body: Text[1024];
        CopyMail: Text[100];
        ExportDirectory: Text[80];
        ParamRecipient: Text[100];
        FilePath: Text[250];
        Sequence: Integer;
        TxtBody: Label 'Bonjour, un nouveau fichier colisage concernant le BP n°: %3 pour votre client %2 est envoyé sur le site FTP, vous l''aurez à disposition dans les 15 minutes. L''expédition enregistrée est %1.', Locked = true;

    procedure Export()
    begin
        IF COMPANYNAME() <> 'CLIC' THEN
            EXIT;

        RecSalesShipment.RESET();
        RecSalesShipment.SETRANGE("Packing Exported", FALSE);

        IF RecSalesShipment.FINDSET(TRUE) THEN
            REPEAT
                RecPacking.RESET();
                RecPacking.SETRANGE("Sales Shipment No.", RecSalesShipment."No.");
                IF RecPacking.FINDSET() THEN BEGIN
                    RecPostedPackingLines.RESET();
                    RecPostedPackingLines.SETRANGE("Packing Document No.", RecPacking."Packing header No.");
                    IF RecPostedPackingLines.COUNT() > 0 THEN BEGIN
                        RecPostedPackingLines.FINDSET();

                        FileName := STRSUBSTNO('Packing_%2_%1.csv', FctShipNo(RecSalesShipment."No.")
                                                , RecSalesShipment."Order No.");
                        FilePath := ExportDirectory + FileName;

                        FctExportFile(FilePath);


                        CLEAR(SenderName);
                        CLEAR(SenderAddress);
                        CLEAR(Recipient);
                        CLEAR(CopyMail);
                        CLEAR(Body);
                        CLEAR(Subject);

                        SenderName := COMPANYNAME();
                        CopyMail := '';
                        SenderAddress := 'server@manufacture-algo.com';
                        Recipient := ParamRecipient;
                        //>>24/07/2015:
                        //Body:=STRSUBSTNO('Bonjour, Vous trouverez ci-joint un nouveau fichier colisage n° %1 pour votre client %2.'
                        //,RecSalesShipment."No.",RecSalesShipment."Sell-to Customer No.");

                        Body := STRSUBSTNO(TxtBody, RecSalesShipment."No.", RecSalesShipment."Sell-to Customer No.", RecSalesShipment."Order No.");
                        Subject := STRSUBSTNO('Colisage %1 pour %2-BP %3', RecSalesShipment."No."
                                            , RecSalesShipment."Sell-to Customer No.", RecSalesShipment."Order No.");
                        //<<24/07/2015

                        SMTP.CreateMessage(SenderName, SenderAddress, Recipient, Subject, Body, FALSE);
                        //>>24/07/2015:
                        //SMTP.AddAttachment(FileName);
                        //<<24/07/2015
                        SMTP.Send();
                    END;
                END;
                RecSalesShipment."Packing Exported" := TRUE;
                RecSalesShipment.MODIFY();

            UNTIL RecSalesShipment.NEXT() = 0;
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

    procedure FctExportFile(DOSFileName: Text[250])
    var
        CrLf: Text[2];
        Char: Char;
        DOSFile: File;
        OutStr: OutStream;
    begin
        Char := 13;
        CrLf := FORMAT(Char);
        Char := 10;
        CrLf += FORMAT(Char);


        DOSFile.CREATE(DOSFileName);
        DOSFile.CREATEOUTSTREAM(OutStr);
        RecPostedPackingLines.FINDSET();

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

            // OutStr.WRITETEXT(STRSUBSTNO('%1;%2;%3;%4;%5;%6;%7;%8;%9'
            //                                , RecPostedPackingLines.Item
            //                                , RecPostedPackingLines.PO
            //                                , FORMAT(RecPostedPackingLines.Quantity, 0, 1)
            //                                , RecPostedPackingLines."Parcel No."
            //                                , RecPostedPackingLines.Pallet
            //                                , RecPostedPackingLines."Source No."
            //                                , RecPostedPackingLines."Parcel Weight"
            //                                , RecPostedPackingLines."Pallet Weight"
            //                                , FORMAT(Sequence) + CrLf));

            // Modification du 13/09/2019 - ALGO - DSP : pour avoir des points en separateur de decimal
            //
            OutStr.WRITETEXT(STRSUBSTNO('%1;%2;%3;%4;%5;%6;%7;%8;%9'
                                            , RecPostedPackingLines.Item
                                            , RecPostedPackingLines.PO
                                            , FORMAT(RecPostedPackingLines.Quantity, 0, '<Integer><Decimals><Comma,.>')
                                            , RecPostedPackingLines."Parcel No."
                                            , RecPostedPackingLines.Pallet
                                            , RecPostedPackingLines."Source No."
                                            , FORMAT(RecPostedPackingLines."Parcel Weight", 0, '<Integer><Decimals><Comma,.>')
                                            , FORMAT(RecPostedPackingLines."Pallet Weight", 0, '<Integer><Decimals><Comma,.>')
                                            , FORMAT(Sequence) + CrLf));

        UNTIL RecPostedPackingLines.NEXT() = 0;

        DOSFile.CLOSE();
    end;
}

