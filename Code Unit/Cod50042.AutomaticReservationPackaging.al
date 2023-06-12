codeunit 50042 "AutomaticReservation Packaging"
{
    // version ALGO
    // DEV-20221122 - Demande de JVE
    // C'est le meme codeunit que le Cod50040 - Automatic Reservation WMS mais avec des filtres differents.
    // DEV-20221122 - Demande de JVE


    trigger OnRun()
    begin
        FctALGOManualReservations();
    end;


    local procedure FctALGOManualReservations()
    var
        RecLSalesLines: Record "Sales Line";

    begin
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
        // RecLSalesLines.SETFILTER("No.", 'MDI*|MPAB*|MPAC*|MPAS*|MPARUB*|MPAAUTO*|MPAPAPIER*|MPAH*');
        RecLSalesLines.SETFILTER("No.", 'MDI*|MPAB*|MPAC*|MPAH*|MPAS*|MPARUB*|MPAAUTO*|MPAPAPIER*&<>MPAPAPIERSOIE*');
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
                RecNo += 1;
                IF GUIALLOWED() THEN
                    Window.UPDATE(1, ROUND(RecNo / TotalRecNo * 10000, 1));
                IF RecLSalesLines."Reserved Quantity" < RecLSalesLines."Outstanding Quantity" THEN
                    Reservation.SetSalesLine(RecLSalesLines, Res);
                IF GUIALLOWED() THEN
                    Window.UPDATE(2, Res);
            UNTIL RecLSalesLines.NEXT() = 0;


        // 20230306 - DSP - JVE
        // On desactive l''Export car il sera généré avec les reservations des PF qui se font en AUTO
        // ExportReservations.RUN;


        IF GUIALLOWED() THEN
            Window.CLOSE();


    end;


    var
        SalesLine: Record "Sales Line";
        RecGReservationEntries: Record "Reservation Entry";
        Reservation: Codeunit "Auto Reser Handler Packaging";
        ExportReservations: Codeunit "Export reservations";
        TotalRecNo: Integer;
        RecNo: Integer;
        Res: Integer;
        Window: Dialog;
        Text010Msg: Label 'Running Sales lines...\\';
        Text011Msg: Label 'Reservations Packaging : ';

        FilePath: Text[250];
        FileName: Text[80];

}

