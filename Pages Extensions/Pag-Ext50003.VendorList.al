pageextension 50003 "Vendor List" extends "Vendor List"
{
    //p27
    layout
    {
        addafter("Balance Due (LCY)")
        {
            field("Net Change (LCY)"; Rec."Net Change (LCY)")
            {
                ApplicationArea = ALL;
            }
            field("E-Mail"; Rec."E-Mail")
            {
                ApplicationArea = ALL;
            }
            field("Net Change"; Rec."Net Change")
            {
                ApplicationArea = ALL;
            }
            field(Balance; Rec.Balance)
            {
                ApplicationArea = ALL;
            }
            Field("Name 2"; Rec."Name 2")
            {
                ApplicationArea = ALL;
            }
            field(Address; Rec.Address)
            {
                ApplicationArea = ALL;
            }
            field("Address 2"; Rec."Address 2")
            {
                ApplicationArea = ALL;
            }
            field(City; Rec.City)
            {
                ApplicationArea = ALL;
            }
            field("Credit Amount (LCY)"; Rec."Credit Amount (LCY)")
            {
                ApplicationArea = ALL;
            }
            field("Debit Amount (LCY)"; Rec."Debit Amount (LCY)")
            {
                ApplicationArea = ALL;
            }
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = ALL;
            }

        }

    }
}