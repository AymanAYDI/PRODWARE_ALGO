pageextension 50073 "Posted Return Receipt" extends "Posted Return Receipt"
{
    //p6660
    layout
    {
        addafter(Shipping)
        {
            group(ALGO)
            {
                Caption = 'ALGO', Locked = true;
                field(PO; Rec.PO)
                {
                    ApplicationArea = ALL;
                }

            }
        }
    }
}
