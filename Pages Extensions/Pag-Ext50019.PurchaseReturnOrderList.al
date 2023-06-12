pageextension 50019 "Purchase Return Order List" extends "Purchase Return Order List"
{
    //p9311
    actions
    {
        addafter("F&unctions")
        {
            group(ALGO)
            {
                Caption = 'ALGO', Locked = true;
                Image = Customer;
                action("Import Retour VDOC")
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Image = Import;

                    Caption = 'Import Retour VDOC';

                    RunObject = XMLport "Vdoc - Import Retour (EA)";
                }
            }
        }
    }
}

