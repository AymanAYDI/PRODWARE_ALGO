codeunit 50037 "Automatic Reservation LU"
{
    // version ALGO
    trigger OnRun()
    begin
        FctALGOManualReservations()
    end;


    procedure FctALGOManualReservations()
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
        RecLSalesLines.SETRANGE("Sell-to Customer No.", 'LUNIFORM');
        RecLSalesLines.SETFILTER("Outstanding Quantity", '>%1', 0);
        RecLSalesLines.SETFILTER("Location Code", 'BAT4');

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
        Reservation: Codeunit "Automatic Reservation Handler";
        TotalRecNo: Integer;
        RecNo: Integer;
        Res: Integer;
        Window: Dialog;
        Text010Msg: Label 'Running Sales lines...\\';
        Text011Msg: Label 'Reservations : ';
}

