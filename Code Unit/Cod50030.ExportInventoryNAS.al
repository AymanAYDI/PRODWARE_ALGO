codeunit 50030 "Export Inventory NAS"
{
    // version ALGO,CLIC

    // ------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // ------------------------------------------------------------------------
    // 
    // //>>ALGO
    // ALGO:TO 27/05/205 : Création Interface Stock
    // 
    // Export les stock des magasins Qualité et CLIC
    // Envoie sur \\vmnav\Partage\Test\Inventory
    // 
    // //>>ALGO
    // ALGO:TO 18/05/2016 : - Prise en compte paramètre Répertoire d'export et MIDI/SOIR
    //                      - triatement exclusif avec la Packing
    // ALGO:DS 10/01/2020 : modification de l'export au niveau de la bouclier pour le magasin CLIC suite MEP WMS

    TableNo = 472;

    trigger OnRun()
    var
        TxtLParameterString: Text[250];
    begin
        //>>ALGO:TO 10/05/2016

        //parameters
        //1-export directory
        //2-MIDI/SOIR : 1/2

        TESTFIELD("Parameter String");
        TxtLParameterString := "Parameter String";
        IF (STRPOS(TxtLParameterString, ';')) > 0 THEN
            ExportDirectory := COPYSTR(TxtLParameterString, 1, (STRPOS(TxtLParameterString, ';') - 1));

        //Remove 1st parameter
        TxtLParameterString := COPYSTR(TxtLParameterString, STRPOS(TxtLParameterString, ';') + 1, STRLEN(TxtLParameterString));
        //MIDI/SOIR
        IF (STRPOS(TxtLParameterString, ';')) > 0 THEN
            MidiSoir := COPYSTR(TxtLParameterString, 1, (STRPOS(TxtLParameterString, ';') - 1));

        //<<ALGO:TO 10/05/2016
        FctExportStock();
    end;

    var
        RecGExportInventory: Record "Export Inventory CLIC";
        ExcelBuf: Record "Excel Buffer" temporary;
        RecGExportSequence: Record "Logistics sequence";
        RecGInsertSequence: Record "Logistics sequence";
        Text001: Label 'Export CLIC Stock', Locked = true;
        Sequence: Integer;
        FilePath: Text[250];
        FileName: Text[80];
        ExportDirectory: Text[80];
        MidiSoir: Text[1];

    procedure FctExportStock()
    var
        RecLItem: Record Item;
        RecLBinContent: Record "Bin Content";
        RecLShipment: Record "Sales Shipment Header";
        CodLPreviousZone: Code[10];
        CodLPreviousItem: Code[20];
        CodLPreviousLocation: Code[10];
    begin
        //traitement exclusif à la packing

        //n'exporte pas l'image si des packing en cours non exportées

        RecLShipment.SETRANGE("Packing Exported", FALSE);
        IF RecLShipment.FINDSET() THEN
            EXIT;

        //vérifie si l'export a déjà été réalisé.
        RecGExportSequence.SETRANGE(Date, TODAY());
        RecGExportSequence.SETRANGE(MidiSoir, MidiSoir);
        IF RecGExportSequence.FINDSET() THEN
            EXIT;

        //Export Sequence
        RecGExportSequence.RESET();
        IF RecGExportSequence.FINDLAST() THEN
            Sequence := RecGExportSequence."Sequence No." + 1;

        //nouvelle séquence
        RecGInsertSequence.INIT();
        RecGInsertSequence."Sequence No." := Sequence;
        RecGInsertSequence.Date := TODAY();
        RecGInsertSequence.MidiSoir := MidiSoir;
        RecGInsertSequence.INSERT();

        //export image
        RecGExportInventory.RESET();
        IF RecGExportInventory.FINDSET() THEN
            RecGExportInventory.DELETEALL();
        RecGExportInventory.RESET();

        //Inventory Qualité
        RecLItem.RESET();
        RecLItem.SETFILTER("Location Filter", 'QUALITE');
        RecLItem.CALCFIELDS(Inventory);
        RecLItem.SETFILTER(Inventory, '<>%1', 0);

        IF RecLItem.COUNT() > 0 THEN BEGIN
            RecLItem.FINDSET();

            REPEAT
                RecLItem.CALCFIELDS(Inventory);
                RecGExportInventory.INIT();
                RecGExportInventory."Item No." := RecLItem."No.";
                RecGExportInventory."Bar code" := RecLItem."BarCode EAN13";
                RecGExportInventory.Location := RecLItem.GETFILTER("Location Filter");
                RecGExportInventory."Zone Code" := ' ';
                RecGExportInventory.Quantity := RecLItem.Inventory;
                RecGExportInventory.INSERT();
            UNTIL RecLItem.NEXT() = 0;
        END;

        //Inventory KO-Qualité
        RecLItem.RESET();
        RecLItem.SETFILTER("Location Filter", 'KO-QUAL');
        RecLItem.CALCFIELDS(Inventory);
        RecLItem.SETFILTER(Inventory, '<>%1', 0);

        IF RecLItem.COUNT() > 0 THEN BEGIN
            RecLItem.FINDSET();

            REPEAT
                RecLItem.CALCFIELDS(Inventory);
                RecGExportInventory.INIT();
                RecGExportInventory."Item No." := RecLItem."No.";
                RecGExportInventory."Bar code" := RecLItem."BarCode EAN13";
                RecGExportInventory.Location := RecLItem.GETFILTER("Location Filter");
                RecGExportInventory."Zone Code" := ' ';
                RecGExportInventory.Quantity := RecLItem.Inventory;
                RecGExportInventory.INSERT();
            UNTIL RecLItem.NEXT() = 0;
        END;

        //Inventory Défectueux
        RecLItem.RESET();
        RecLItem.SETFILTER("Location Filter", 'DEFECTUEUX');
        RecLItem.CALCFIELDS(Inventory);
        RecLItem.SETFILTER(Inventory, '<>%1', 0);

        IF RecLItem.COUNT() > 0 THEN BEGIN
            RecLItem.FINDSET();

            REPEAT
                RecLItem.CALCFIELDS(Inventory);
                RecGExportInventory.INIT();
                RecGExportInventory."Item No." := RecLItem."No.";
                RecGExportInventory."Bar code" := RecLItem."BarCode EAN13";
                RecGExportInventory.Location := RecLItem.GETFILTER("Location Filter");
                RecGExportInventory."Zone Code" := ' ';
                RecGExportInventory.Quantity := RecLItem.Inventory;
                RecGExportInventory.INSERT();
            UNTIL RecLItem.NEXT() = 0;
        END;

        // >>ALGO - CLIC : WMS - version 10/01/2020 - 001
        //Inventory CLIC
        RecLItem.RESET();
        RecLItem.SETFILTER("Location Filter", 'CLIC');
        RecLItem.CALCFIELDS(Inventory);
        RecLItem.SETFILTER(Inventory, '<>%1', 0);
        IF RecLItem.COUNT() > 0 THEN BEGIN
            RecLItem.FINDSET();
            REPEAT
                RecLItem.CALCFIELDS(Inventory);
                RecGExportInventory.INIT();
                RecGExportInventory."Item No." := RecLItem."No.";
                RecGExportInventory."Bar code" := RecLItem."BarCode EAN13";
                RecGExportInventory.Location := RecLItem.GETFILTER("Location Filter");
                RecGExportInventory."Zone Code" := 'RGT';
                RecGExportInventory.Quantity := RecLItem.Inventory;
                RecGExportInventory.INSERT();
            UNTIL RecLItem.NEXT() = 0;
        END;

        /* >>ALGO - CLIC : WMS - version avant 10/01/2020 - 001
        //CLIC
        CLEAR(CodLPreviousZone);
        CLEAR(CodLPreviousItem);
        CLEAR(CodLPreviousLocation);

        RecLBinContent.SETCURRENTKEY("Location Code", "Zone Code", "Item No.", "Variant Code", "Unit of Measure Code");
        RecLBinContent.SETRANGE("Location Code", 'CLIC');
        RecLBinContent.SETFILTER(Quantity, '<>%1', 0);
        RecLBinContent.CALCFIELDS(Quantity);

        IF RecLBinContent.COUNT() > 0 THEN BEGIN
            RecLBinContent.FINDSET();
            REPEAT
                RecLBinContent.CALCFIELDS(Quantity);

                IF (RecLBinContent."Location Code" = CodLPreviousLocation) AND
                    (RecLBinContent."Item No." = CodLPreviousItem) AND
                    (RecLBinContent."Zone Code" = CodLPreviousZone) THEN BEGIN
                    RecGExportInventory.Quantity += RecLBinContent.Quantity;
                    RecGExportInventory.MODIFY();
                END
                ELSE BEGIN
                    RecLItem.RESET();
                    RecLItem.GET(RecLBinContent."Item No.");

                    RecGExportInventory.INIT();
                    RecGExportInventory."Item No." := RecLItem."No.";
                    RecGExportInventory."Bar code" := RecLItem."BarCode EAN13";
                    RecGExportInventory.Location := RecLBinContent."Location Code";
                    RecGExportInventory."Zone Code" := RecLBinContent."Zone Code";
                    RecGExportInventory.Quantity := RecLBinContent.Quantity;
                    RecGExportInventory.INSERT();
                END;

                //Previous
                CodLPreviousLocation := RecLBinContent."Location Code";
                CodLPreviousItem := RecLBinContent."Item No.";
                CodLPreviousZone := RecLBinContent."Zone Code";

            UNTIL RecLBinContent.NEXT() = 0;
        END;
        */
        // >>ALGO - CLIC : WMS - version avant 10/01/2020 - 001
        IF RecGExportInventory.FINDSET() THEN BEGIN
            FileName := STRSUBSTNO('Stock_%1-%2-%3_%4.csv', DATE2DMY(TODAY(), 3),
                                  DATE2DMY(TODAY(), 2), DATE2DMY(TODAY(), 1), MidiSoir);
            FilePath := ExportDirectory + FileName;
            FctExportFile(FilePath);
        END;
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

        DOSFile.CREATE(DOSFileName, TextEncoding::Windows);
        DOSFile.CREATEOUTSTREAM(OutStr);
        RecGExportInventory.FINDSET();
        REPEAT
            OutStr.WRITETEXT(STRSUBSTNO('%1;%2;%3;%4;%5;%6'
                                            , Sequence
                                            , RecGExportInventory."Item No."
                                            , RecGExportInventory."Bar code"
                                            , RecGExportInventory.Location
                                            , RecGExportInventory."Zone Code"
                                            , FORMAT(RecGExportInventory.Quantity, 0, 1)) + CrLf);

        UNTIL RecGExportInventory.NEXT() = 0;
        DOSFile.CLOSE();
    end;
}

