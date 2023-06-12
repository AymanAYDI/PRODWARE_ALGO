pageextension 50052 "Bank Acc. Reconciliation Lines" extends "Bank Acc. Reconciliation Lines"
{
    //p380
    layout
    {
        addafter("Additional Transaction Info")
        {
            field(Checked; Rec.Checked)
            {
                ApplicationArea = ALL;
            }
        }
    }
}
