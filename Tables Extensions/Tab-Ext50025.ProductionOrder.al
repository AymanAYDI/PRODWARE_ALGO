tableextension 50025 "Production Order" extends "Production Order"
{
    //t5405
    fields
    {
        field(50000; "Routing Version Code"; Code[10])
        {
            Caption = 'Routing Version Code';
            DataClassification = CustomerContent;
        }

        // Ajout du 2019930 - reactivation le 20191213
        // Désactivé car probleme de performance le 20191001

        field(50001; "Remaining Qty"; decimal)
        {
            Caption = 'Quantité restante';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Prod. Order Line"."Remaining Qty. (Base)" WHERE(Status = FIELD(status), "Prod. Order No." = FIELD("No.")));
        }

        field(50002; "Last Reception Date"; Date)
        {
            Caption = 'Date dernière réception';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = MAX("Prod. Order Line"."Last Reception Date" WHERE(Status = FIELD(status), "Prod. Order No." = FIELD("No.")));
        }

        field(50003; "WorkCenter"; code[20])
        {
            Caption = 'Centre de charge';
            FieldClass = FlowField;
            Editable = false;
            // Recalcul du centre de charge avec la gamme sur l'entete OF
            CalcFormula = lookup("Prod. Order Routing Line"."Work Center No." WHERE(Status = FIELD(status), "Prod. Order No." = FIELD("No."), "Routing Reference No." = FILTER(10000)));
            // Utiliser le workcenter de la ligne OF plante la page
            // Calcformula = Lookup ("Prod. Order Line"."Work Center" WHERE(Status = FIELD(Status), "Prod. Order No." = FIELD("No."), "Line No." = FILTER(10000)));
        }




    }

}