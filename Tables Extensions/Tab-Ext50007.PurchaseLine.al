tableextension 50007 "Purchase Line" extends "Purchase Line"
{
    //t39
    fields
    {
        field(50000; "P.O."; Text[20])
        {
            Caption = 'P.O.';
            DataClassification = CustomerContent;
        }
        field(50011; "Vdoc Control No."; Text[50])
        {
            Caption = 'VDOC N°Controle';
            DataClassification = CustomerContent;
            Description = 'N° de contrôle VDOC - Cette donnée est importée de l''application VDOC';
        }
        field(50012; "Vdoc Delivery Order No."; Text[50])
        {
            Caption = 'VDOC N° BL';
            DataClassification = CustomerContent;
            Description = 'N° de BL repris de VDOC - Cette donnée NAV est importée de l''application VDOC';
        }
        field(50013; "Initial Quantity"; Decimal)
        {
            Caption = 'Quantité initiale';
            DataClassification = CustomerContent;
        }
        field(50014; "Initial Promised Date"; Date)
        {
            Caption = 'Date Confirmée Initiale';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                PurchHeader: Record "Purchase Header";
                Text046Lbl: Label 'Voulez-vous modifier la date confirmée initiale?';
            begin
                //>>ALGO-P0039
                IF (CompanyName() = 'ALGO PROD') AND ("Document Type" = "Document Type"::Order) AND (PurchHeader."No. Series" = 'A-CDE3') AND (xRec."Initial Promised Date" <> 0D) THEN
                    IF DIALOG.CONFIRM(Text046Lbl, TRUE) THEN
                        MODIFY(TRUE)
                    ELSE
                        "Initial Promised Date" := xRec."Initial Promised Date";
                //<<ALGO-P0039
            end;
        }
        field(50015; "Initial Planned Receipt Date"; Date)
        {
            Caption = 'Date Planifiée Initiale Calculée';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50016; "Development Order"; Boolean)
        {
            Caption = 'Commande Développement';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                RecLPurchaseHeader: record "Purchase Header";
            begin
                //>>ALGO-20180328
                RecLPurchaseHeader.RESET();
                RecLPurchaseHeader.SETRANGE("Document Type", "Document Type");
                RecLPurchaseHeader.SETRANGE("No.", "Document No.");
                IF RecLPurchaseHeader.FindFirst() THEN
                    IF NOT RecLPurchaseHeader."Development Order" THEN
                        "Development Order" := FALSE
                    ELSE
                        "Development Order" := TRUE;
                //<<ALGO-20180328
            end;
        }

        field(50017; "Rcpt Qty at Due Date"; Decimal)
        {
            Caption = 'Rcpt Qty at Due Date';
            DataClassification = CustomerContent;
        }

        /**
         * @see SQL job
         */
        field(50018; "Last Rcpt Date"; Date)
        {
            Caption = 'Last Rcpt Date';
            /*
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Max ("Purch. Rcpt. Line"."Posting Date" WHERE
                                                        ("Buy-from Vendor No." = FIELD ("Buy-from Vendor No."),
                                                        "Order No." = FIELD ("Document No."),
                                                        "Order Line No." = FIELD ("Line No."),
                                                        Quantity = FILTER (<> 0)));
                                                        */
            DataClassification = CustomerContent;
        }
        // WMS202001 - n°Imputation WMS
        field(50020; "WMS No Imputation"; Text[100])
        {
            Caption = 'No Imputation WMS', Locked = TRUE;
            DataClassification = CustomerContent;
            Description = 'N° imputation - Cette donnée est fournie par l''application WMS';
        }
    }
}