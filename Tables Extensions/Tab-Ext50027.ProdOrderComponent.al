tableextension 50027 "Prod. Order Component" extends "Prod. Order Component"
{
    //t5407
    fields
    {
        field(50000; "PF to manufacture"; Code[20])
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Lookup("Prod. Order Line"."Routing No." WHERE(Status = FIELD(Status),
                                                                         "Prod. Order No." = FIELD("Prod. Order No.")));
            Caption = 'PF to manufacture';
        }
        field(50001; "Producted Qty"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Prod. Order Line"."Finished Quantity" WHERE(Status = FIELD(Status),
                                                                               "Prod. Order No." = FIELD("Prod. Order No."),
                                                                               "Line No." = FIELD("Prod. Order Line No.")));
            Caption = 'Quantité produite';
        }
        field(50002; "Purchase Order Line"; Code[20])
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Lookup("Purchase Line"."Document No." WHERE("Document Type" = CONST(Order),
                                                                       "Prod. Order No." = FIELD("Prod. Order No."),
                                                                       "Prod. Order Line No." = FIELD("Prod. Order Line No.")));
            Caption = 'N° Commande d''Achat';
        }

        field(50003; "Statut OF Date"; Date)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Lookup("Production Order"."Creation Date" WHERE("No." = FIELD("Prod. Order No.")));
            Caption = 'Date Statut OF';
        }

    }

}