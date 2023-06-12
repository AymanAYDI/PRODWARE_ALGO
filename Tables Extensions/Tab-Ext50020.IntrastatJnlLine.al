tableextension 50020 "Intrastat Jnl. Line" extends "Intrastat Jnl. Line"
{
    //t263
    fields
    {
        field(50000; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            DataClassification = CustomerContent;
            OptionCaption = 'Purchase,Sale,Positive Adjmt.,Negative Adjmt.,Transfer,Consumption,Output';
            OptionMembers = Purchase,Sale,"Positive Adjmt.","Negative Adjmt.",Transfer,Consumption,Output;
        }
        field(50001; "External Document No."; Code[20])
        {
            Caption = 'External Document No.';
            DataClassification = CustomerContent;
        }
        field(50002; "Receipt No."; Code[20])
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Lookup("Purch. Rcpt. Line"."Document No." WHERE("No." = field("Item No."),
                                                                           "Prod. Order No." = field("Document No."),
                                                                           "Posting Date" = field(Date),
                                                                           Quantity = field(Quantity),
                                                                           "Vendor Shipment No." = field("External Document No.")));
            Caption = 'Document No.';

        }

    }

}
