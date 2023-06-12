codeunit 50008 "ADM - Controle des travaux"
{
    // //----------------------------------------------------------
    // // 02/12/2019 : test de l'execution du code manuellement
    // //----------------------------------------------------------
    // // Code unit créé pour checker les job queue entry et tester les statuts
    // // Si ERREUR ou EN ATTENTE un envoi de mail est généré
    // //----------------------------------------------------------

    Permissions = TableData 472 = r;

    trigger OnRun()
    begin
        ReadEntryJobErreur();
        ReadEntryJobEnAttente();
        IF (NbErreur + NbAttente) > 0 then
            EnvoiMail();
    end;

    var
        RecGEntryJob: Record "Job Queue Entry";
        RecGCompanyInfo: Record "Company Information";
        NbErreur: Integer;
        NbAttente: Integer;
        SMTP: Codeunit "SMTP Mail";
        SenderName: Text[100];
        SenderAddress: Text[100];
        Recipient: Text[100];
        Subject: Text[100];
        Body: Text[1024];
        CopyMail: Text[100];

    procedure ReadEntryJobErreur()
    begin
        CR := 13;
        LF := 10;
        RecGEntryJob.reset();
        NbErreur := 0;
        errorbody := '';

        RecGEntryJob.SETRANGE(Status, RecGEntryJob.Status::Error);
        IF RecGEntryJob.FINDSET() THEN
            REPEAT
                NbErreur := NbErreur + 1;
                errorbody := errorbody + '- ' + RecGEntryJob.Description + ' : ' + RecGEntryJob."Error Message" + Format(CR) + Format(LF);
            UNTIL RecGEntryJob.NEXT() = 0;
    end;

    procedure ReadEntryJobEnAttente()
    begin
        RecGEntryJob.reset();
        NbAttente := 0;
        waitbody := '';
        CR := 13;
        LF := 10;
        RecGEntryJob.SETRANGE(Status, RecGEntryJob.Status::"On Hold");
        IF RecGEntryJob.FINDSET() THEN
            REPEAT
                NbAttente := NbAttente + 1;
                waitbody := waitbody + '- ' + RecGEntryJob.Description + Format(CR) + Format(LF);
            UNTIL RecGEntryJob.NEXT() = 0;
    end;

    procedure Envoimail()
    begin
        CR := 13;
        LF := 10;
        CLEAR(SenderName);
        CLEAR(SenderAddress);
        CLEAR(Recipient);
        CLEAR(CopyMail);
        CLEAR(Body);
        CLEAR(Subject);
        SenderName := 'NAVBC';
        SenderAddress := 'server@manufacture-algo.com';
        Recipient := 'support@manufacture-algo.com';
        CopyMail := '';
        Subject := STRSUBSTNO(COMPANYNAME() + ' - Contrôle des JOBQUEUE - ' + format(NbErreur) + ' en ERREUR | ' + format(NbAttente) + ' en ATTENTE ');
        Body := format(NbErreur) + ' Erreurs - Intervenir :' + Format(CR) + Format(LF);
        Body := Body + errorbody;
        Body := Body + Format(CR) + Format(LF) + format(NbAttente) + ' En attente - Controler :' + Format(CR) + Format(LF);
        Body := Body + waitbody;

        SMTP.CreateMessage(SenderName, SenderAddress, Recipient, Subject, Body, FALSE);
        SMTP.Send();
    end;

    var
        errorbody: Text;

    var
        waitbody: Text;

    var
        CR: Char;

    var
        LF: Char;
}