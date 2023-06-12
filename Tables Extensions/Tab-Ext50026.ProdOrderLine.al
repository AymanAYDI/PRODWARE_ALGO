tableextension 50026 "Prod. Order Line" extends "Prod. Order Line"
{
    //t5406
    fields
    {
        field(50000; "Creation Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Production Order"."Creation Date" WHERE(Status = field(Status),
                                                                           "No." = field("Prod. Order No.")));
            Caption = 'Creation Date';
            Editable = false;
        }
        field(50001; "Work Center"; Code[20])
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Lookup("Prod. Order Routing Line"."Work Center No." WHERE(Status = field(Status),
                                                                                     "Prod. Order No." = field("Prod. Order No."),
                                                                                     "Routing Link Code" = FILTER(<> '')));
            Caption = 'Centre de charge';
        }
        field(50002; "Purchase Order Line"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Purchase Line"."Document No." WHERE("Document Type" = CONST(Order),
                                                                       "Prod. Order No." = field("Prod. Order No."),
                                                                       "Prod. Order Line No." = field("Line No.")));
            Caption = 'N° Commande Achat';
            Editable = false;
        }
        field(50003; "Starting Date Routing Version"; Date)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Lookup("Routing Version"."Starting Date" WHERE("Routing No." = field("Routing No."),
                                                                          "Version Code" = field("Routing Version Code")));
            Caption = 'Date de début version gamme';
        }
        field(50004; "Starting Date ProdBOM Version"; Date)
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Lookup("Production BOM Version"."Starting Date" WHERE("Production BOM No." = field("Production BOM No."),
                                                                                 "Version Code" = field("Production BOM Version Code")));
            Caption = 'Date de début version nomenclature';
        }
        /**
         * @see SQL Job
         */
        field(50005; "Last Reception Date"; Date)
        {
            Caption = 'Date dernière réception';
            DataClassification = CustomerContent;

        }

        field(50006; "Assigned User ID"; Code[20])
        {
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Lookup("Production Order"."Assigned User ID" WHERE(Status = FIELD(Status), "No." = FIELD("Prod. Order No.")));
            Caption = 'Code utilisateur affecté', locked = true;

        }

        field(50007; "No CV Customer"; Text[20])
        {
            Caption = 'N° CV Client';
            Editable = true;
        }

        field(50008; "Cust. due date"; Date)
        {
            Caption = 'Date d''échéance client';
            Editable = True;
        }

    }

    trigger OnInsert()
    begin
        "Planning Flexibility" := "Planning Flexibility"::None;
    end;

}