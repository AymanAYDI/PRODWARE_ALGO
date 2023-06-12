codeunit 50035 "Automatic Reservation"
{
    // version ALGO
    // Demande GLPI : Ticket 5400 - 07/09/2022
    // Objet : C.FAVIER qui veut arrêter la réservation automatique pour  MPAPAPIERSOIE-GIR
    // Ligne Origine  = RecLSalesLines.SETFILTER("No.", 'A*|MTO*|MDI*|KIT*|MPAS*|MCO*|MPARUB*|MPAAUTO*|MPAPAPIER*');    
    // Ligne modifiée = RecLSalesLines.SETFILTER("No.", 'A*|MTO*|MDI*|KIT*|MPAS*|MCO*|MPARUB*|MPAAUTO*|MPAPAPIER*&<>MPAPAPIERSOIE*');
    // MET = jj/mm/aaaa |  MEP = jj/mm/aaaa
    // Demande GLPI : Ticket 5400 - C.FAVIER      

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

        //      Demande GLPI : Ticket 5400 - C.FAVIER        
        RecLSalesLines.SETFILTER("No.", 'A*|MTO*|MDI*|KIT*|MPAS*|MCO*|MPARUB*|MPAAUTO*|MPAPAPIER*&<>MPAPAPIERSOIE*');
        //      Demande GLPI : Ticket 5400 - C.FAVIER  

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

        IF GUIALLOWED() THEN
            Window.CLOSE();
    end;


    var
        SalesLine: Record "Sales Line";
        Reservation: Codeunit "Automatic Reservation Handler";
        TotalRecNo: Integer;
        RecNo: Integer;
        Res: Integer;
        Window: Dialog;
        Text010Msg: Label 'Running Sales lines...\\';
        Text011Msg: Label 'Reservations : ';
}

