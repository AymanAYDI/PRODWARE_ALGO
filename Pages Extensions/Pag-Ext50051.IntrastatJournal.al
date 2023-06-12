pageextension 50051 "Intrastat Journal" extends "Intrastat Journal"
{
    //p311
    layout
    {
        addafter("Internal Ref. No.")
        {
            field("Entry Type"; Rec."Entry Type")
            {
                ApplicationArea = ALL;
            }
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = ALL;
            }
            field("Receipt No."; Rec."Receipt No.")
            {
                ApplicationArea = ALL;
            }
        }
    }
}
