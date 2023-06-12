pageextension 50079 "Manufacturing Setup" extends "Manufacturing Setup"
{
    //p99000768

    // Projet Securisation des OF - 20221209 : Ajout du champs Securisation OF dans la page pour gerer l'activation/desactivation

    layout
    {
        addafter(Planning)
        {
            group(ALGO)
            {
                Caption = 'ALGO', Locked = true;
                field("default consumption WorkCenter"; Rec."default consumption WorkCenter")
                {
                    ApplicationArea = ALL;
                }
                // Projet Securisation des OF - 20221209
                Field("Securisation OF"; Rec."Securisation OF")
                {
                    ApplicationArea = ALL;
                }
                // Projet Securisation des OF - 20221209                  
            }
        }
    }
}
