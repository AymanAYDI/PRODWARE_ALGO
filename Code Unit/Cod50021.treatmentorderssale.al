codeunit 50021 "treatment orders sale"
{
    // version ALG2.00,MODIFHL,SU,ALGO,CLIC2015-001

    // ------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // ------------------------------------------------------------------------
    // //>>ALG2.00
    // FED-Algo-20100224-Vente01:MA 22/03/2010  Data port:creation sales order
    //                                              Creation
    // 
    // //>>MODIF HL
    // TI002602.001 DO.ALMI 26/07/10  : Add "Posting No. Series & "Shipping No. Series" to SalesHeader
    //                                  InsertOrder()
    // 
    // //>>MODIF HL
    // TI005996.001 DO.ALMI 26/08/10  : - Add import posting date
    // TI005996.002 DO.ALMI 02/09/10  : - Add validate posting date
    // 
    // //>> 20/09/2010 SU-DADE cf appel TI008738
    // //   InsertOrder()
    // //<< 20/09/2010 SU-DADE cf appel TI008738
    // 
    // -------------------------------------------------------------------------
    // //>>ALGO_01/04/2015 : Ajout champ PO
    //                       Ajout code pour réservation autmatique suivant option Réservation
    // ------------------------------------------------------------------------------


    trigger OnRun()
    begin
    end;

    var
        RecGTraitementVente: Record "Temp Treatment Sale Order";
        RecGLogImportSales: Record "Log Import Sales";
        RecGCustomer: Record Customer;
        RecGItem: Record Item;
        RecGorder: Record "Sales Header";
        RecGTraitementVente3: Record "Temp Treatment Sale Order";
        RecGTraitementVente2: Record "Temp Treatment Sale Order";
        RecGTraitementVente4: Record "Temp Treatment Sale Order";
        SalesSetup: Record "Sales & Receivables Setup";
        BoolGGlobalError: Boolean;
        BoolGError: Boolean;
        IntGNo: Integer;
        CodGCustomer: Code[20];
        TxtGNameFile: Text[250];
        DateGDCmdMin: Date;
        DateGDLivMin: Date;
        TxtG001: Label 'In the order n°: %1, line: %2, the customer %3  don''''t exist.';
        TxtG002: Label 'In the order n°: %1, line: %2, the Item %3  don''''t exist.';
        TxtG003: Label 'The order n°: %1, already exists.';
        TxtG004: Label 'The order n°: %1, has several Customers.';
        TxtG005: Label 'The order n°: %1, line: %2. The quantity must be > 0.';
        TxtG000: Label 'There were errors in the import, please check the Errors Log.';
        Txt006: Label 'The file was imported successfully.';

    procedure InsertLog(IntPLinNumb: Integer)
    begin
        //Customer don't exist
        IF NOT RecGCustomer.GET(RecGTraitementVente."No. Customer") THEN BEGIN
            RecGLogImportSales.Comment := STRSUBSTNO(TxtG001, RecGTraitementVente."No.Order", IntPLinNumb
              , RecGTraitementVente."No. Customer");
            RecGLogImportSales.No := IntGNo;
            RecGLogImportSales.File := TxtGNameFile;
            RecGLogImportSales.Date := TODAY();
            RecGLogImportSales.INSERT();
            COMMIT();
            IntGNo := IntGNo + 1;
            BoolGError := TRUE;
            BoolGGlobalError := TRUE;
        END;
        //Item don't exist
        IF NOT RecGItem.GET(RecGTraitementVente."No.Item") THEN BEGIN
            RecGLogImportSales.Comment := STRSUBSTNO(TxtG002, RecGTraitementVente."No.Order", IntPLinNumb
              , RecGTraitementVente."No.Item");
            RecGLogImportSales.No := IntGNo;
            RecGLogImportSales.File := TxtGNameFile;
            RecGLogImportSales.Date := TODAY();
            RecGLogImportSales.INSERT();
            COMMIT();
            IntGNo := IntGNo + 1;
            BoolGError := TRUE;
            BoolGGlobalError := TRUE;
        END;
        //order already exists
        IF RecGorder.GET(RecGorder."Document Type"::Order, RecGTraitementVente."No.Order") THEN BEGIN
            RecGLogImportSales.Comment := STRSUBSTNO(TxtG003, RecGTraitementVente."No.Order");
            RecGLogImportSales.No := IntGNo;
            RecGLogImportSales.File := TxtGNameFile;
            RecGLogImportSales.Date := TODAY();
            RecGLogImportSales.INSERT();
            COMMIT();
            IntGNo := IntGNo + 1;
            BoolGError := TRUE;
            BoolGGlobalError := TRUE;
        END;
        //quantity must be > 0
        IF RecGTraitementVente.Quantity <= 0 THEN BEGIN
            RecGLogImportSales.Comment := STRSUBSTNO(TxtG005, RecGTraitementVente."No.Order", IntPLinNumb);
            RecGLogImportSales.No := IntGNo;
            RecGLogImportSales.File := TxtGNameFile;
            RecGLogImportSales.Date := TODAY();
            RecGLogImportSales.INSERT();
            COMMIT();
            IntGNo := IntGNo + 1;
            BoolGError := TRUE;
            BoolGGlobalError := TRUE;
        END;
    end;

    procedure InsertOrder()
    var
        RecLSalesHeader: Record "Sales Header";
        RecLSalesLine: Record "Sales Line";
        IntLLineNo: Integer;
    begin
        RecGTraitementVente4.RESET();
        //>>TI002602.001
        SalesSetup.GET();
        //<<TI002602.001
        RecLSalesHeader.VALIDATE("Document Type", RecLSalesHeader."Document Type"::Order);
        RecLSalesHeader.VALIDATE("No.", RecGTraitementVente."No.Order");
        //>>TI005996.002
        RecLSalesHeader.VALIDATE("Posting Date", DateGDCmdMin);
        //<<TI005996.002
        RecLSalesHeader.VALIDATE("Sell-to Customer No.", RecGTraitementVente."No. Customer");
        RecLSalesHeader.VALIDATE("Order Date", DateGDCmdMin);
        RecLSalesHeader.VALIDATE("Requested Delivery Date", DateGDLivMin);
        //>>TI002602.001
        RecLSalesHeader.VALIDATE("Posting No. Series", SalesSetup."Posted Invoice Nos.");
        RecLSalesHeader.VALIDATE("Shipping No. Series", SalesSetup."Posted Shipment Nos.");
        //<<TI002602.001
        //>> 20/09/2010 SU-DADE cf appel TI008738
        RecLSalesHeader."Posting Description" := FORMAT(RecLSalesHeader."Document Type") + ' ' + RecGTraitementVente."No.Order";
        //<< 20/09/2010 SU-DADE cf appel TI008738E
        RecLSalesHeader.INSERT();
        COMMIT();
        RecGTraitementVente4.SETRANGE("No.Order", RecGTraitementVente."No.Order");
        IF RecGTraitementVente4.FINDFIRST() THEN
            IntLLineNo := 1000;
        REPEAT
            RecLSalesLine.VALIDATE("Line No.", IntLLineNo);
            RecLSalesLine.VALIDATE("Document Type", RecLSalesLine."Document Type"::Order);
            RecLSalesLine.VALIDATE("Document No.", RecGTraitementVente4."No.Order");
            RecLSalesLine.VALIDATE(Type, RecLSalesLine.Type::Item);
            RecLSalesLine.VALIDATE("No.", RecGTraitementVente4."No.Item");
            RecLSalesLine.VALIDATE(Quantity, RecGTraitementVente4.Quantity);
            RecLSalesLine.VALIDATE(RecLSalesLine."Requested Delivery Date", RecGTraitementVente4."Requested Delivery Date");
            RecLSalesLine.VALIDATE("Promised Delivery Date", RecGTraitementVente4."Requested Delivery Date");
            //>>ALGO_01/04/2015
            RecLSalesLine.VALIDATE(RecLSalesLine.PO, RecGTraitementVente4.PO);
            RecLSalesLine.VALIDATE("Cust Ref.", RecGTraitementVente4."Cust Ref.");

            //<<ALGO_01/04/2015
            RecLSalesLine.INSERT();
            IntLLineNo := IntLLineNo + 1000;
            //>>ALGO_01/04/2015
            IF RecLSalesLine.Reserve = RecLSalesLine.Reserve::Always THEN
                RecLSalesLine.AutoReserve();
        //<<ALGO_01/04/2015
        UNTIL RecGTraitementVente4.NEXT() = 0;
        COMMIT();
    end;

    procedure Treatment(TxtPFileName: Text[250])
    var
        IntLLinNumber: Integer;
    begin
        BoolGGlobalError := FALSE;
        TxtGNameFile := TxtPFileName;
        IF RecGLogImportSales.FINDLAST() THEN
            IntGNo := RecGLogImportSales.No + 1
        ELSE
            IntGNo := 1;
        IntLLinNumber := 1;
        IF RecGTraitementVente2.FINDFIRST() THEN
            REPEAT
                BoolGError := FALSE;
                IF RecGTraitementVente2.FINDFIRST() THEN;
                RecGTraitementVente.SETRANGE("No.Order", RecGTraitementVente2."No.Order");
                IF RecGTraitementVente.FINDFIRST() THEN BEGIN
                    DateGDCmdMin := RecGTraitementVente."Order Date";
                    DateGDLivMin := RecGTraitementVente."Requested Delivery Date";
                    REPEAT
                        //Error treatement
                        InsertLog(IntLLinNumber);
                        IntLLinNumber := IntLLinNumber + 1;
                        IF RecGTraitementVente."Order Date" < DateGDCmdMin THEN
                            DateGDCmdMin := RecGTraitementVente."Order Date";
                        IF RecGTraitementVente."Requested Delivery Date" < DateGDLivMin THEN
                            DateGDLivMin := RecGTraitementVente."Requested Delivery Date";
                    UNTIL RecGTraitementVente.NEXT() = 0;
                    VerifyClt();
                    //Insertion in sales order
                    IF BoolGError = FALSE THEN
                        InsertOrder();
                    DeleteLines();
                    IntLLinNumber := 1;
                END;
                RecGTraitementVente.RESET();

            UNTIL RecGTraitementVente2.NEXT() = 0;
        IF BoolGGlobalError = TRUE THEN
            MESSAGE(TxtG000)
        ELSE
            MESSAGE(Txt006);
    end;

    procedure FormatPathFile(TxtPFile: Text[250]): Text[250]
    var
        IntLPose: Integer;
        i: Integer;
    begin
        IntLPose := STRLEN(DELCHR(TxtPFile, '<=>', DELCHR(TxtPFile, '<=>', '\')));
        i := 0;
        REPEAT
            TxtPFile := COPYSTR(TxtPFile, STRPOS(TxtPFile, '\') + 1);
            i := i + 1;
        UNTIL i = IntLPose;
        TxtPFile := COPYSTR(TxtPFile, 1, STRPOS(TxtPFile, '.') - 1);
        EXIT(TxtPFile);
    end;

    procedure DeleteLines()
    begin
        RecGTraitementVente.SETRANGE("No.Order", RecGTraitementVente2."No.Order");
        IF RecGTraitementVente.FINDFIRST() THEN
            REPEAT
                RecGTraitementVente.DELETE();
            UNTIL RecGTraitementVente.NEXT() = 0;
        COMMIT();
    end;

    procedure VerifyClt()
    begin
        //several Customers in the same order
        RecGTraitementVente3.RESET();
        RecGTraitementVente3.SETRANGE("No.Order", RecGTraitementVente2."No.Order");
        IF RecGTraitementVente3.FINDFIRST() THEN;
        CodGCustomer := RecGTraitementVente3."No. Customer";
        REPEAT
            IF (CodGCustomer <> RecGTraitementVente3."No. Customer") THEN BEGIN
                RecGLogImportSales.Comment := STRSUBSTNO(TxtG004, RecGTraitementVente3."No.Order"
                  , RecGTraitementVente3."No. Customer");
                RecGLogImportSales.No := IntGNo;
                RecGLogImportSales.File := TxtGNameFile;
                RecGLogImportSales.Date := TODAY();
                RecGLogImportSales.INSERT();
                COMMIT();
                IntGNo := IntGNo + 1;
                BoolGGlobalError := TRUE;
                EXIT;
            END;
        UNTIL RecGTraitementVente3.NEXT() = 0;
    end;
}

