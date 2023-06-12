tableextension 50039 "Manufacturing Setup" extends "Manufacturing Setup"
{
    //t99000765

    // 20221209 - Projet Securisation des OF : Ajout d'un booleen pour activer/desactiver la sécurisation des OF

    fields
    {
        field(50000; "default consumption WorkCenter"; Code[20])
        {
            Caption = 'default consumption WorkCenter';
            DataClassification = CustomerContent;
            TableRelation = "Work Center"."No.";
        }

        // Projet Securisation des OF - 20221209
        Field(50001; "Securisation OF"; Boolean)
        {
            Caption = 'Securisation OF';
            Editable = true;
            DataClassification = CustomerContent;
        }
        // Projet Securisation des OF - 20221209

    }

}