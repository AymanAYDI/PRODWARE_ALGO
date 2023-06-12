tableextension 50008 "Company Information" extends "Company Information"
{
    //t79
    fields
    {
        field(50003; "EORI No."; Text[30])
        {
            Caption = 'EORI No.';
            DataClassification = CustomerContent;
        }
        field(50004; "MID Code"; Text[30])
        {
            Caption = 'MID Code';
            DataClassification = CustomerContent;
        }
        field(50005; "AEO Certificate No."; Text[30])
        {
            Caption = 'AEO Certificate No.';
            DataClassification = CustomerContent;
        }
        field(50006; "VDOC Path"; Text[250])
        {
            Caption = 'VDOC Path';
            DataClassification = CustomerContent;
        }
        field(50007; "VDOC Backup Path"; Text[250])
        {
            Caption = 'VDOC Backup Path';
            DataClassification = CustomerContent;
        }
        field(50008; "Packing Mail Recipient"; Text[250])
        {
            Caption = 'Packing Mail Recipient';
            DataClassification = CustomerContent;
        }
        field(50009; "Packing Path"; Text[250])
        {
            Caption = 'Packing Path';
            DataClassification = CustomerContent;
        }
        field(50010; "Picking Path"; Text[250])
        {
            Caption = 'Picking Path';
            DataClassification = CustomerContent;
        }
        field(50011; "GSH Invoice Path"; Text[250])
        {
            Caption = 'GSH Invoice Path';
            DataClassification = CustomerContent;
        }
        field(50012; "GSH Invoice Backup Path"; Text[250])
        {
            Caption = 'GSH Invoice Backup Path';
            DataClassification = CustomerContent;
        }
        field(50013; "Invoice Mail Recipient"; Text[250])
        {
            Caption = 'Invoice Mail Recipient';
            DataClassification = CustomerContent;
        }
        field(50014; "LU Invoice Path"; Text[250])
        {
            Caption = 'LU Invoice Path';
            DataClassification = CustomerContent;
        }
        field(50015; "WMS Path"; Text[250])
        {
            Caption = 'WMS Path';
            DataClassification = CustomerContent;
        }
        //>> 20200318 - Ticket 2486 - Ajout champs pour stock adresse du siege social et utilisation dans les reports
        field(50016; "Head Office"; Text[250])
        {
            Caption = 'Head Office';
            DataClassification = CustomerContent;
        }
        //>> Demande JVENANT du 20200331 pour un EDI Modula
        field(50017; "Modula Path"; Text[250])
        {
            Caption = 'Modula Path';
            DataClassification = CustomerContent;
        }
        //>> Projet#410 : Avoir GSH
        Field(50018; "GSH Credit Memo Path"; Text[250])
        {
            Caption = 'GSH Credit Memo Path';
            DataClassification = CustomerContent;
        }
        Field(50019; "GSH Credit Memo Backup Path"; Text[250])
        {
            Caption = 'GSH Credit Memo Backup Path';
            DataClassification = CustomerContent;
        }
        Field(50020; "LU Credit Memo Path"; Text[250])
        {
            Caption = 'LU Credit Memo Path';
            DataClassification = CustomerContent;
        }
        //<< Projet#410 : Avoir GSH
        Field(50021; "VDOC process"; Text[250])
        {
            Caption = 'VDOC process';
            DataClassification = CustomerContent;
        }
        Field(50022; "Export Reservation"; Text[250])
        {
            Caption = 'Export Reservation';
            DataClassification = CustomerContent;
        }

        Field(50023; "Export Planificiation Path"; Text[250])
        {
            Caption = 'Export Planificiation Path';
            DataClassification = CustomerContent;
        }

        // >> ALGO-DSP - 20230427 - Création d'un champs pour indiquer les Filtres sur les articles 
        Field(50024; "Filter Reservation Auto WMS"; TEXT[250])
        {
            Caption = 'Filtres Articles - Reservation Auto WMS';
            DataClassification = CustomerContent;
        }

        Field(50025; "Filter Flux Pousse"; TEXT[250])
        {
            Caption = 'Filtres Articles - Flux Poussé';
            DataClassification = CustomerContent;
        }
    }
}
