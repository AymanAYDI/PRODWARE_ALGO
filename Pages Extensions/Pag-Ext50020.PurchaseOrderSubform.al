pageextension 50020 "Purchase Order Subform" extends "Purchase Order Subform"
{
    //p54
    layout
    {
        addafter("Line No.")
        {
            field("P.O."; Rec."P.O.")
            {
                ApplicationArea = ALL;
            }
            field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = ALL;
            }
            field("Vendor Item No."; Rec."Vendor Item No.")
            {
                ApplicationArea = ALL;
            }
            field("Posting Group"; Rec."Posting Group")
            {
                ApplicationArea = ALL;
            }
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = ALL;
            }
            field(Amount; Rec.Amount)
            {
                ApplicationArea = ALL;
            }
            field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
            {
                ApplicationArea = ALL;
            }
            field("Development Order"; Rec."Development Order")
            {
                ApplicationArea = ALL;
            }
            field("Vdoc Control No."; Rec."Vdoc Control No.")
            {
                ApplicationArea = ALL;
            }
            field("Vdoc Delivery Order No."; Rec."Vdoc Delivery Order No.")
            {
                ApplicationArea = ALL;
            }
            field("Safety Lead Time"; Rec."Safety Lead Time")
            {
                ApplicationArea = ALL;
            }
            field("Initial Quantity"; Rec."Initial Quantity")
            {
                ApplicationArea = ALL;
            }
            field("Initial Promised Date"; Rec."Initial Promised Date")
            {
                ApplicationArea = ALL;
            }
            field("Initial Planned Receipt Date"; Rec."Initial Planned Receipt Date")
            {
                ApplicationArea = ALL;
            }
            field("Rcpt Qty at Due Date"; Rec."Rcpt Qty at Due Date")
            {
                ApplicationArea = ALL;
            }
            field("Last Rcpt Date"; Rec."Last Rcpt Date")
            {
                ApplicationArea = ALL;
            }
            field("WMS No Imputation"; Rec."WMS No Imputation")
            {
                ApplicationArea = ALL;
            }
        }
    }
}