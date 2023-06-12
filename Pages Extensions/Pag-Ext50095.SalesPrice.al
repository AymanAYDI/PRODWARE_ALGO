pageextension 50095 "Sales Price" extends "Sales Prices"
{
    layout
    {
        addafter("Ending Date")
        {
            field("Last Modified by"; Rec."Last Modified by")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Last Modified Date"; Rec."Last Modified Date")
            {
                ApplicationArea = Basic, Suite;
            }
            //>> #69_20211129
            field("MOQ"; Rec."MOQ")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Multiple"; Rec."Multiple")
            {
                ApplicationArea = Basic, Suite;
            }
            //<< #69_20211129            
        }
    }
}