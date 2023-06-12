codeunit 50041 "Export Reservations"
{
    // //----------------------------------------------------------
    // // 11/07/2022 :  codeunit developpé pour WMS - CLIG
    // // - Création d'une table temporaire 50030 - TempReservationEntry
    // // - Il va exporter dans un fichier csv les données de réservations pour le stock LANNOLIER1
    // // - Il va mettre un flag à jour dans la table 337 lorsqu'une ligne sera exportée
    // //----------------------------------------------------------
    // //----------------------------------------------------------

    // //----------------------------------------------------------
    // // MODIF-20221025 :  DDE JVE > EXEC DSP
    // // - Ajout des Heures-Minutes-Secondes dans le nom du fichier
    // //----------------------------------------------------------

    // // #20230418 - Modifications du Filtres article pour l'export reservations

    // // #20230427 - ALGO : DSP - EMA
    // //--> Le filtre article pour la reservation Flux Poussée est basée sur un paramétrage dynamique dans Infos Sociétés
    // //--> Objets Impactés : TAB-Ext50008 - Pag-Ext50026 - Pag-Ext50008 - COD50041
    // //===========================================================   

    // Permissions = TableData 337 = rm;

    trigger OnRun()
    begin

        Nav_Import_ReservationEntry();
        Nav_Lecture_TblTmp();
    end;

    var
        CompanyInfo: Record "Company Information";
        RecGReservationEntry: Record "Reservation Entry";
        RecGSalesHeader: Record "Sales Header";
        TempReservationEntry: Record "Temp Reservation Entry";
        ExcelBuf: Record "Excel Buffer" temporary;
        //SMAIL: Codeunit "SMTP Mail";
        FileName: Text[250];
        FilePath: Text[250];
        ExportDirectory: Text[80];
        "Count": Integer;
        Selection: Integer;
        CountLine: Integer;
        i: Integer;
        IndiceBoucleDeSortie: Integer;
        Customer: Code[20];
        // MODIF-20221025 - DDE : JVE - Exec : DSP
        timeText: text[250];
        myTime: Time;
    // MODIF-20221025 - DDE : JVE - Exec : DSP

    procedure Nav_Import_ReservationEntry()
    begin
        // >> #20230427
        CompanyInfo.Get();
        CompanyInfo.TestField("Filter Flux Pousse");
        If CompanyInfo."Filter Flux Pousse" = '' THEN ERROR('Pas de Filtres Articles définis pour la Réservation Flux Poussé !!!');
        // << #20230427


        RecGReservationEntry.RESET();
        TempReservationEntry.DELETEALL();



        RecGReservationEntry.SETCURRENTKEY("Source ID", "Source Ref. No.");
        RecGReservationEntry.SETRANGE("Reservation Status", RecGReservationEntry."Reservation Status"::Reservation);
        RecGReservationEntry.SETFILTER("Source Type", '%1', 37);
        RecGReservationEntry.SETFILTER("Source subtype", '%1', 1);
        RecGReservationEntry.SETFILTER("Location Code", 'LANNOLIER1');
        RecGReservationEntry.SETRANGE("Export WMS", FALSE);
        RecGReservationEntry.SETFILTER("Transferred from Entry No.", '%1', 0);

        // >> #20230418 
        // RecGReservationEntry.SETFILTER("Item No.", 'A*|MTO*|MDI*|KIT*|MCO*|MPAB*|MPAC*|MPAH*|MPAS*|MPARUB*|MPAAUTO*|MPAPAPIER*&<>MPAPAPIERSOIE*');
        // << #20230418             

        // >> #20230427
        RecGReservationEntry.SETFILTER("Item No.", CompanyInfo."Filter Flux Pousse");
        // << #20230427

        //========================== Lecture de la table Reservation Entry / Alimentation de la table tempo ===

        IF RecGReservationENtry.FINDSET() THEN
            REPEAT
                TempReservationEntry."Entry No." := RecGReservationEntry."Entry No.";
                TempReservationEntry."Item No." := RecGReservationEntry."Item No.";
                TempReservationEntry."Create Date" := RecGReservationEntry."Creation Date";
                TempReservationEntry."Quantity" := RecGReservationEntry.Quantity * -1;
                TempReservationEntry."Order No." := RecGReservationEntry."Source ID";
                TempReservationEntry."Export WMS" := RecGReservationEntry."Export WMS";
                RecGSalesHeader.RESET();
                RecGSalesHeader.SETCURRENTKEY("Document Type", "No.");
                RecGSalesHeader.SETRANGE("document type", RecGSalesHeader."Document Type"::Order);
                RecGSalesHeader.SETFILTER("No.", RecGReservationentry."Source ID");
                IF RecGSalesHeader.FINDSET() then
                    Customer := RecGSalesHeader."Sell-to Customer No."
                else
                    Customer := '';


                TempReservationEntry."Customer No." := RecGSalesHeader."Sell-to Customer No.";
                TempReservationEntry.INSERT();
            UNTIL RecGReservationEntry.NEXT() = 0;
    end;

    procedure Nav_Lecture_TblTmp()
    var
        CompanyInfo: Record "Company Information";
    begin
        CompanyInfo.Get();
        CompanyInfo.TestField("Export Reservation");


        TempReservationEntry.RESET();
        TempReservationEntry.SETCURRENTKEY("Item No.");
        TempReservationEntry.SETRANGE("Export WMS", FALSE);
        TempReservationEntry.SETFILTER("Customer No.", 'Goyard MONDE');

        /* >> MODIF-20221025 - DDE : JVE - Exec : DSP
        IF TempReservationEntry.FINDSET() THEN BEGIN
            FileName := STRSUBSTNO('Reservation_%1-%2-%3.csv', DATE2DMY(TODAY(), 3),
                                  DATE2DMY(TODAY(), 2), DATE2DMY(TODAY(), 1));
            FilePath := CompanyInfo."Export Reservation" + FileName;
            FctExportFile(FilePath);
        END;
        */

        IF TempReservationEntry.FINDSET() THEN BEGIN
            myTime := TIME();
            timeText := FORMAT(TODAY(), 0, '<Day>-<Month>-<Year4>');
            timeText += FORMAT(mytime, 0, '_<Hours24,2>-<Minutes,2>-<Seconds,2>');
            FileName := STRSUBSTNO('Reservation_%1.csv', Timetext);
            FilePath := CompanyInfo."Export Reservation" + FileName;
            FctExportFile(FilePath);
        END;
        // << MODIF-20221025 - DDE : JVE - Exec : DSP 

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
        TempReservationEntry.FINDSET();
        REPEAT
            OutStr.WRITETEXT(STRSUBSTNO('%1;%2;%3;%4;%5;%6'
                                            , TempReservationEntry."Entry No."
                                            , TempReservationEntry."Item No."
                                            , TempReservationEntry."Create Date"
                                            , TempReservationEntry."Customer No."
                                            , TempReservationEntry."Order No."
                                            , FORMAT(TempReservationEntry.Quantity, 0, 1)) + CrLf);

            IF RecGReservationEntry.GET(TempReservationEntry."Entry No.") THEN BEGIN
                RecGReservationEntry."Export WMS" := TRUE;
                RecGReservationEntry.MODIFY();
            END;

        UNTIL TempReservationEntry.NEXT() = 0;
        DOSFile.CLOSE();
    end;

}