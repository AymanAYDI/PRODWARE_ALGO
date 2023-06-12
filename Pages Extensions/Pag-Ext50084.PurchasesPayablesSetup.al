pageextension 50084 "Purchases & Payables Setup" extends "Purchases & Payables Setup" //MyTargetPageId
{
    layout
    {
        addafter("Default Accounts")
        {
            group(ALGO)
            {
                Caption = 'ALGO', Locked = true;
                field("Intranet Directory"; Rec."Intranet Directory")
                {

                }
            }
        }

    }
}