pageextension 50094 "Change Production Order Status" extends "Change Production Order Status"
{
    //p99000914
    //ALGO du 20190930
    // Désactivé le 20191001 - Pb de performance
    // reactivé le 20191213 - test


    layout
    {
        addafter("Finished Date")
        {
            field("Quantite Restante"; Rec."Remaining Qty")
            {
                ApplicationArea = ALL;
            }

            field("Date Derniere Reception"; Rec."Last Reception Date")
            {
                ApplicationArea = ALL;
            }

            field("Centre de charge"; Rec.WorkCenter)
            {
                ApplicationArea = ALL;
            }

        }
    }

}
