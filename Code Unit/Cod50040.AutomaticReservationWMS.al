codeunit 50040 "Automatic Reservation WMS"
{
    // version ALGO

    // DDE JVE 20221122 AVANT --> RecLSalesLines.SETFILTER("No.", 'A*|MTO*|MDI*|KIT*|MCO*');
    // DDE JVE 20221122 APRES --> RecLSalesLines.SETFILTER("No.", 'A*|MTO*|MDI*|KIT*|MPAS*|MCO*|MPARUB*|MPAAUTO*|MPAPAPIER*');
    // DDE JVE 20221122 --> Ajout d'un controle de lecture pour traiter uniquement les CV à l'etat LANCE

    trigger OnRun()
    begin
        FctALGOManualReservations();
    end;


    local procedure FctALGOManualReservations()
    var
        RecLSalesLines: Record "Sales Line";
        RecLSalesHeader: record "Sales Header";
        chr13: Char;
        chr10: Char;


    begin
        chr13 := 13;
        chr10 := 10;
        IF GUIALLOWED() THEN
            Window.OPEN(
              Text010Msg +
              '@1@@@@@@@@@@@@@@@@@@@@@@@@@\\' +
              Text011Msg + '#2############');

        IF GUIALLOWED() THEN
            Window.UPDATE(1, 0);

        RecLSalesLines.SETCURRENTKEY("Document Type", "Promised Delivery Date", "No.");

        RecLSalesLines.SETRANGE("Document Type", RecLSalesLines."Document Type"::Order);
        RecLSalesLines.SETRANGE(Type, RecLSalesLines.Type::Item);

        // DDE JVE 20221122 --> RecLSalesLines.SETFILTER("No.", 'A*|MTO*|MDI*|KIT*|MPAS*|MCO*|MPARUB*|MPAAUTO*|MPAPAPIER*');
        RecLSalesLines.SETFILTER("No.", 'A*|MTO*|MDI*|KIT*|MCO*');
        // DDE JVE 20221122

        RecLSalesLines.SETRANGE("Sell-to Customer No.", 'GOYARD MONDE');
        RecLSalesLines.SETFILTER("Outstanding Quantity", '>%1', 0);
        RecLSalesLines.SETFILTER(PO, 'VDQ*');
        RecLSalesLines.SETFILTER("Location Code", 'LANNOLIER1');

        TotalRecNo := RecLSalesLines.COUNT();
        RecNo := 0;
        Res := 0;

        IF RecLSalesLines.FINDSET() THEN
            REPEAT

                // DDE JVE 20221123
                // Parcours de la table SALES HEADER pour traiter uniquement les commandes à l'état LANCE
                // RecLSalesHeader.Reset();
                RecLSalesHeader.SETRANGE("Status", RecLSalesHeader.Status::Released);
                RecLSalesHeader.SetFilter("No.", RecLSalesLines."Document No.");

                IF RecLSalesHeader.FindFirst() THEN BEGIN
                    // DDE JVE 20221123
                    /*
                    Message(' - CV LINE / Doc No : ' + Format(RecLSalesLines."Document No.") + FORMAT(chr13) + FORMAT(chr10)
                    + ' - CV LINE / No : ' + Format(RecLSalesLines."No.") + FORMAT(chr13) + FORMAT(chr10)
                    + ' - CV HEADER / No : ' + Format(RecLSalesHeader."No.") + FORMAT(chr13) + FORMAT(chr10)
                    + ' - CV HEADER / Status : ' + Format(RecLSalesHeader."Status") + FORMAT(chr13) + FORMAT(chr10)
                    + ' - Je reserve');
                    */

                    RecNo += 1;
                    IF GUIALLOWED() THEN
                        Window.UPDATE(1, ROUND(RecNo / TotalRecNo * 10000, 1));
                    IF RecLSalesLines."Reserved Quantity" < RecLSalesLines."Outstanding Quantity" THEN
                        Reservation.SetSalesLine(RecLSalesLines, Res);
                    IF GUIALLOWED() THEN
                        Window.UPDATE(2, Res);
                END;

            UNTIL RecLSalesLines.NEXT() = 0;

        ExportReservations.RUN;

        IF GUIALLOWED() THEN
            Window.CLOSE();

    end;


    var
        SalesLine: Record "Sales Line";

        RecGReservationEntries: Record "Reservation Entry";
        Reservation: Codeunit "Automatic Reservation Handler";
        ExportReservations: Codeunit "Export reservations";
        TotalRecNo: Integer;
        RecNo: Integer;
        Res: Integer;
        Window: Dialog;
        Text010Msg: Label 'Running Sales lines...\\';
        Text011Msg: Label 'Reservations : ';

        FilePath: Text[250];
        FileName: Text[80];

}

