pageextension 50053 "Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    //p459
    layout
    {
        addafter("Dynamics 365 for Sales")
        {
            group(ALGO)
            {
                Caption = 'ALGO', Locked = true;
                field("Packing List No."; Rec."Packing List No.")
                {
                    ApplicationArea = ALL;
                }
                field("Intranet Directory"; Rec."Intranet Directory")
                {

                }
            }
        }
    }
}
