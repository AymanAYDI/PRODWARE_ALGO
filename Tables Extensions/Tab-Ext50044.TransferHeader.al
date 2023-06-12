tableextension 50044 "Transfer Header" extends "Transfer Header" //MyTargetTableId
{
    fields
    {
        field(50002; "Already Shipped"; Boolean)
        {
            Caption = 'Déjà Expédiée', locked = true;
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Exist("Transfer Line" WHERE("Document No." = FIELD("No.")
                                                    , "Shipment Date" = FIELD("Date Filter")
                                                    , "Transfer-from Code" = FIELD("Location Filter")
                                                    , "Quantity Shipped" = FILTER(<> 0)));
        }

        field(50003; "Work Center"; Code[20])
        {
            Caption = 'N° Centre de charge', locked = true;
            TableRelation = "Work Center";
            DataClassification = CustomerContent;
        }

    }

}