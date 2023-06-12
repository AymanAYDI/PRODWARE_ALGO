pageextension 50015 "Purchase Order" extends "Purchase Order"
{
    //p50
    layout
    {
        addafter(Prepayment)
        {
            group(ALGO)
            {
                Caption = 'ALGO', Locked = true;
                field(Ship; Rec.Ship)
                {
                    ApplicationArea = ALL;
                }
                field("Last Return Shipment No."; Rec."Last Return Shipment No.")
                {
                    ApplicationArea = ALL;
                }
                field("Development Order"; Rec."Development Order")
                {
                    ApplicationArea = ALL;
                    trigger OnValidate()
                    begin
                        //>>ALGO-20180328
                        RecGPurchaseLine.SETRANGE("Document Type", Rec."Document Type");
                        RecGPurchaseLine.SETRANGE("Document No.", Rec."No.");

                        IF RecGPurchaseLine.FIND('-') THEN
                            REPEAT
                                IF RecGPurchaseLine.Type > 0 THEN BEGIN
                                    RecGPurchaseLine."Development Order" := Rec."Development Order";
                                    RecGPurchaseLine.MODIFY();
                                END;
                            UNTIL RecGPurchaseLine.NEXT() = 0;
                        //<<ALGO-20180328
                    end;

                }
            }
        }
    }
    actions
    {
        addafter(Print)
        {
            group(ALGO_)
            {
                Caption = 'ALGO', locked = true;
                Image = Customer;
                action("Journal Modification CA Entête")
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Image = ChangeLog;

                    Caption = 'Journal Modification CA Entête';

                    RunObject = Page "Change Log Entries";
                    RunPageView = SORTING("Table No.", "Date and Time")
                                  ORDER(Ascending);
                    RunPageLink = "Table No." = FILTER(38),
                                  "Primary Key Field 1 Value" = FIELD("No.");
                }
                action("Journal Modification CA Lignes")
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Image = ChangeToLines;

                    Caption = 'Journal Modification CA Lignes';

                    RunObject = Page "Change Log Entries";
                    RunPageView = SORTING("Table No.", "Date and Time")
                                  ORDER(Ascending);
                    RunPageLink = "Table No." = FILTER(39),
                                  "Primary Key Field 1 Value" = FIELD("No.");
                }

                action("VDOC - Import RCA")
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Image = Import;

                    Caption = 'VDOC - Import RCA';

                    RunObject = XMLport "Vdoc - Import Commande (RCA)";
                }
            }
        }
    }

    // DSP 20191112 //     trigger OnAfterGetCurrRecord()
    /*
        trigger OnModifyRecord(): Boolean

        begin
            if CompanyName() = 'ALGO PROD' then
                if "Document Type" = "Document Type"::Order then begin
                    //"Posting Date" := Today();
                    Validate("Posting Date", Today());
                    Modify();
                end;
        end;
     */
    var
        RecGPurchaseLine: Record "Purchase Line";
}