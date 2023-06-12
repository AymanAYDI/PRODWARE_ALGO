table 50022 "Log Import Sales"
{
    // version ALG2.00

    // ------------------------------------------------------------------------
    // Prodware - www.prodware.fr
    // ------------------------------------------------------------------------
    // //>>ALG2.00
    // FED-Algo-20100224-Vente01:MA 22/03/2010  Data port:creation sales order
    //                                              Creation

    Caption = 'Log Import Sales';

    fields
    {
        field(1; No; Integer)
        {
            AutoIncrement = true;
            Caption = 'No';
            DataClassification = CustomerContent;
        }
        field(2; Comment; Text[100])
        {
            Caption = 'Comment';
            DataClassification = CustomerContent;
        }
        field(3; File; Text[150])
        {
            Caption = 'File';
            DataClassification = CustomerContent;
        }
        field(4; Date; Date)
        {
            Caption = 'Date';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; No)
        {
        }
    }

    fieldgroups
    {
    }
}

