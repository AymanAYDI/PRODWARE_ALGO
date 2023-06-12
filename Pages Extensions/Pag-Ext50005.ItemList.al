pageextension 50005 "Item List" extends "Item List"
{
    //p31
    layout
    {
        addafter(Description)
        {
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = ALL;
            }
            field(Inventory2; Rec.Inventory)
            {
                ApplicationArea = ALL;
            }
            field("Units per Parcel"; Rec."Units per Parcel")
            {
                ApplicationArea = ALL;
            }
            field("Rounding Precision"; Rec."Rounding Precision")
            {
                ApplicationArea = ALL;
            }
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = ALL;
            }
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
                ApplicationArea = ALL;
            }
            field("Country/Region Purchased Code"; Rec."Country/Region Purchased Code")
            {
                ApplicationArea = ALL;
            }
            field("Include Inventory"; Rec."Include Inventory")
            {
                ApplicationArea = ALL;
            }
            field(Picture; Rec.Picture)
            {
                ApplicationArea = ALL;
            }
            field("Reserved Qty. on Sales Orders"; Rec."Reserved Qty. on Sales Orders")
            {
                ApplicationArea = ALL;
            }
            field("Inventory Value Zero"; Rec."Inventory Value Zero")
            {
                ApplicationArea = ALL;
            }
            field("Gross Weight"; Rec."Gross Weight")
            {
                ApplicationArea = ALL;
            }
            field("Trans. Ord. Shipment (Qty.)"; Rec."Trans. Ord. Shipment (Qty.)")
            {
                ApplicationArea = ALL;
            }
            field("Trans. Ord. Receipt (Qty.)"; Rec."Trans. Ord. Receipt (Qty.)")
            {
                ApplicationArea = ALL;
            }
            field("Planning Receipt (Qty.)"; Rec."Planning Receipt (Qty.)")
            {
                ApplicationArea = ALL;
            }
            field("Qty. in Transit"; Rec."Qty. in Transit")
            {
                ApplicationArea = ALL;
            }
            field("Qty. on Component Lines"; Rec."Qty. on Component Lines")
            {
                ApplicationArea = ALL;
            }
            field("Unit Volume"; Rec."Unit Volume")
            {
                ApplicationArea = ALL;
            }
            field("Country/Region of Origin Code"; Rec."Country/Region of Origin Code")
            {
                ApplicationArea = ALL;
            }
            field("Net Weight"; Rec."Net Weight")
            {
                ApplicationArea = ALL;
            }
            field("Reordering Policy"; Rec."Reordering Policy")
            {
                ApplicationArea = ALL;
            }
            field("Qty. on Purch. Order"; Rec."Qty. on Purch. Order")
            {
                ApplicationArea = ALL;
            }
            field("Qty. on Sales Order"; Rec."Qty. on Sales Order")
            {
                ApplicationArea = ALL;
            }
            field("Qty. on Prod. Order"; Rec."Qty. on Prod. Order")
            {
                ApplicationArea = ALL;
            }
            field("Rolled-up Material Cost"; Rec."Rolled-up Material Cost")
            {
                ApplicationArea = ALL;
            }
            field("Rolled-up Capacity Cost"; Rec."Rolled-up Capacity Cost")
            {
                ApplicationArea = ALL;
            }
            field("Rolled-up Subcontracted Cost"; Rec."Rolled-up Subcontracted Cost")
            {
                ApplicationArea = ALL;
            }
            field("Automatic Ext. Texts"; Rec."Automatic Ext. Texts")
            {
                ApplicationArea = ALL;
            }
            field("Safety Stock Quantity"; Rec."Safety Stock Quantity")
            {
                ApplicationArea = ALL;
            }
        }
        addafter("Default Deferral Template Code")
        {
            field("Height (cm)"; Rec."Height (cm)")
            {
                ApplicationArea = ALL;
            }
            field("Length (cm)"; Rec."Length (cm)")
            {
                ApplicationArea = ALL;
            }
            field("Width (cm)"; Rec."Width (cm)")
            {
                ApplicationArea = ALL;
            }
            field("Weight (Net/Gross)"; Rec."Weight (Net/Gross)")
            {
                ApplicationArea = ALL;
            }
            field("Volume (cm3)"; Rec."Volume (cm3)")
            {
                ApplicationArea = ALL;
            }
            field("Details / Fitting-out"; Rec."Details / Fitting-out")
            {
                ApplicationArea = ALL;
            }
            field("Details / Fitting-out 2"; Rec."Details / Fitting-out 2")
            {
                ApplicationArea = ALL;
            }
            field(Linning; Rec.Linning)
            {
                ApplicationArea = ALL;
            }
            field(Leather; Rec.Leather)
            {
                ApplicationArea = ALL;
            }
            field(Composition; Rec.Composition)
            {
                ApplicationArea = ALL;
            }
            field("Closed type"; Rec."Closed type")
            {
                ApplicationArea = ALL;
            }
            field("Function bag"; Rec."Function bag")
            {
                ApplicationArea = ALL;
            }
            field("Metal parts"; Rec."Metal parts")
            {
                ApplicationArea = ALL;
            }
            field("Freight Cost"; Rec."Freight Cost")
            {
                ApplicationArea = ALL;
            }
            field("Wood 1"; Rec."Wood 1")
            {
                ApplicationArea = ALL;
            }
            field("Wood 2"; Rec."Wood 2")
            {
                ApplicationArea = ALL;
            }
            field("Wood 1 Weight"; Rec."Wood 1 Weight")
            {
                ApplicationArea = ALL;
            }
            field("Wood 2 Weight"; Rec."Wood 2 Weight")
            {
                ApplicationArea = ALL;
            }
            field("Wood 3"; Rec."Wood 3")
            {
                ApplicationArea = ALL;
            }
            field("Wood 3 Weight"; Rec."Wood 3 Weight")
            {
                ApplicationArea = ALL;
            }
            field(Model; Rec.Model)
            {
                ApplicationArea = ALL;
            }
            field("Certificate of Origin"; Rec."Certificate of Origin")
            {
                ApplicationArea = ALL;
            }
            field("Percentage Composition 1"; Rec."Percentage Composition 1")
            {
                ApplicationArea = ALL;
            }
            field("Percentage Composition 2"; Rec."Percentage Composition 2")
            {
                ApplicationArea = ALL;
            }
            field("Last Reception Date"; Rec."Last Reception Date")
            {
                ApplicationArea = ALL;
            }
            field("BarCode EAN13"; Rec."BarCode EAN13")
            {
                ApplicationArea = ALL;
            }
            field("Customer Item No."; Rec."Customer Item No.")
            {
                ApplicationArea = ALL;
            }
            field("Life Cycle"; Rec."Life Cycle")
            {
                ApplicationArea = ALL;
            }
            field("Procurement Cycle"; Rec."Procurement Cycle")
            {
                ApplicationArea = ALL;
            }
            field("Model Size"; Rec."Model Size")
            {
                ApplicationArea = ALL;
            }
            field("Item Family"; Rec."Item Family")
            {
                ApplicationArea = ALL;
            }
            field("Collection"; Rec.Collection)
            {
                ApplicationArea = ALL;
            }
            field("Raw material family"; Rec."Raw material family")
            {
                ApplicationArea = All;
            }
            field("Customer"; Rec."Customer")
            {
                ApplicationArea = All;
            }

            field("CUB Unit Cost"; RecGBugetCost."Unit Cost")
            {
                Caption = 'CUB Unit Cost';
                trigger OnAssistEdit()
                begin
                    CurrPage.Update();
                end;
            }
            field("CUB Forecast Qty"; RecGBugetCost."Forecasted Quantity")
            {
                Caption = 'CUB Forecast Qty';
            }
            field("CUB Date Debut"; RecGBugetCost."Starting Date")
            {
                Caption = 'CUB Date Debut';
            }
            field("CUB Date Fin"; RecGBugetCost."Ending Date")
            {
                Caption = 'CUB Date Fin';
            }
            field("CUB Der Modif par"; RecGBugetCost."Last Modified by")
            {
                Caption = 'CUB Der Modif par';
            }
            field("CUB Date Der Modif"; RecGBugetCost."Last Modified Date")
            {
                Caption = 'CUB Date Der Modif';
            }
            field("CUR Unit Cost"; RecGBugetCost2."Unit Cost")
            {
                Caption = 'CUR Unit Cost';
            }
            field("CUR Date Debut"; RecGBugetCost2."Starting Date")
            {
                Caption = 'CUR Date Debut';
            }
            field("CUR Date Fin"; RecGBugetCost2."Ending Date")
            {
                Caption = 'CUR Date Fin';
            }
            field("CUR Der Modif par"; RecGBugetCost2."Last Modified by")
            {
                Caption = 'CUR Der Modif par';
            }
            field("CUR Date Der Modif"; RecGBugetCost2."Last Modified Date")
            {
                Caption = 'CUR Date Der Modif';
            }

            field("CUF Unit Cost"; RecGBugetCost3."Unit Cost")
            {
                Caption = 'C.U.F.', locked = true;
            }
            field("CUF Date Debut"; RecGBugetCost3."Starting Date")
            {
                Caption = 'C.U.F. Date Debut', locked = true;
            }

            field("CUFR Unit Cost"; RecGBugetCost4."Unit Cost")
            {
                Caption = 'C.U.F.R.', locked = true;
            }
            field("CUFR Date Debut"; RecGBugetCost4."Starting Date")
            {
                Caption = 'C.U.F.R. Date Debut', locked = true;
            }

        }
    }
    actions
    {
        addbefore(Item)
        {
            group(ALGO_)
            {
                Caption = 'ALGO', locked = true;
                Image = Customer;
                action(Dupliquer)
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = Segment;
                    PromotedCategory = New;

                    Caption = 'Dupliquer';

                    RunObject = Page "Duplicate Item";
                    RunPageLink = "No." = FIELD("No.");
                }
                action("Journal des modifications")
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Image = ChangeLog;

                    Caption = 'Journal des modifications';

                    RunObject = Page "Change Log Entries";
                    RunPageView = SORTING("Table No.", "Date and Time")
                                  ORDER(Ascending);
                    RunPageLink = "Table No." = FILTER(27),
                                  "Primary Key Field 1 Value" = FIELD("No.");

                }
                action("C.U.B.")
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Image = Cost;

                    Caption = 'C.U.B.';

                    RunObject = Page "Unit cost budget";
                    RunPageView = SORTING("Item No.", "Cost Type", "Starting Date", "Variant Code", "Unit of Measure Code")
                                  ORDER(Ascending);
                    RunPageLink = "Item No." = FIELD("No.");
                }

            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        RecGBugetCost."Unit Cost" := 0;
        RecGBugetCost."Forecasted Quantity" := 0;
        RecGBugetCost."Starting Date" := 0D;
        RecGBugetCost."Ending Date" := 0D;
        RecGBugetCost."Last Modified by" := '';
        RecGBugetCost."Last Modified Date" := 0DT;
        RecGBugetCost2."Unit Cost" := 0;
        RecGBugetCost2."Starting Date" := 0D;
        RecGBugetCost2."Ending Date" := 0D;
        RecGBugetCost2."Last Modified by" := '';
        RecGBugetCost2."Last Modified Date" := 0DT;
        RecGBugetCost3."Unit Cost" := 0;
        RecGBugetCost3."Starting Date" := 0D;
        RecGBugetCost3."Ending Date" := 0D;
        RecGBugetCost3."Last Modified by" := '';
        RecGBugetCost3."Last Modified Date" := 0DT;
        RecGBugetCost4."Unit Cost" := 0;
        RecGBugetCost4."Starting Date" := 0D;
        RecGBugetCost4."Ending Date" := 0D;
        RecGBugetCost4."Last Modified by" := '';
        RecGBugetCost4."Last Modified Date" := 0DT;

        // ----------- CUB ----------
        RecGBugetCost.RESET();
        RecGBugetCost.SETFILTER(RecGBugetCost."Item No.", Rec."No.");
        RecGBugetCost.SETFILTER(RecGBugetCost."Cost Type", 'C.U.B.');
        RecGBugetCost.SETFILTER(RecGBugetCost."Starting Date", '%1|<=%2', 0D, WORKDATE());
        RecGBugetCost.SETFILTER(RecGBugetCost."Ending Date", '%1|>=%2', 0D, WORKDATE());

        IF NOT RecGBugetCost.FINDSET() THEN;

        // ----------- CUR ----------
        RecGBugetCost2.RESET();
        RecGBugetCost2.SETFILTER(RecGBugetCost2."Item No.", Rec."No.");
        RecGBugetCost2.SETFILTER(RecGBugetCost2."Cost Type", 'C.U.R.');
        RecGBugetCost2.SETFILTER(RecGBugetCost2."Starting Date", '%1|<=%2', 0D, WORKDATE());
        RecGBugetCost2.SETFILTER(RecGBugetCost2."Ending Date", '%1|>=%2', 0D, WORKDATE());

        IF NOT RecGBugetCost2.FINDSET() THEN;

        // ----------- CUF ----------
        RecGBugetCost3.SETFILTER(RecGBugetCost3."Item No.", Rec."No.");
        RecGBugetCost3.SETFILTER(RecGBugetCost3."Cost Type", 'C.U.F.');
        RecGBugetCost3.SETFILTER(RecGBugetCost3."Starting Date", '%1|<=%2', 0D, WORKDATE());
        RecGBugetCost3.SETFILTER(RecGBugetCost3."Ending Date", '%1|>=%2', 0D, WORKDATE());
        IF NOT RecGBugetCost3.FINDLAST() THEN BEGIN
            // message(' Pas de CUF defini ');
        END;

        // ----------- CUFR ----------
        RecGBugetCost4.SETFILTER(RecGBugetCost4."Item No.", Rec."No.");
        RecGBugetCost4.SETFILTER(RecGBugetCost4."Cost Type", 'C.U.F.R.');
        RecGBugetCost4.SETFILTER(RecGBugetCost4."Starting Date", '%1|<=%2', 0D, WORKDATE());
        RecGBugetCost4.SETFILTER(RecGBugetCost4."Ending Date", '%1|>=%2', 0D, WORKDATE());
        IF NOT RecGBugetCost4.FINDLAST() THEN BEGIN
            // message(' Pas de CUFR defini ');
        END;

    end;

    var
        RecGBugetCost: Record "Unit Cost Budget";
        RecGBugetCost2: Record "Unit Cost Budget";
        RecGBugetCost3: Record "Unit Cost Budget";
        RecGBugetCost4: Record "Unit Cost Budget";
}
