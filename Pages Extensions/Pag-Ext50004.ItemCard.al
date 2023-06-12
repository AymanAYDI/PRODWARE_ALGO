pageextension 50004 "Item Card" extends "Item Card"
{
    //p30
    layout
    {
        addafter(Description)
        {
            field("Description 2"; Rec."Description 2")
            {
                // Caption = '*** Description 2';
                ApplicationArea = ALL;
            }
            field("Low-Level Code"; Rec."Low-Level Code")
            {
                ApplicationArea = ALL;
            }
            field(Blocked2; Rec.Blocked)
            {
                ApplicationArea = ALL;
            }
            field("Vendor Item No.2"; Rec."Vendor Item No.")
            {
                ApplicationArea = ALL;
            }
        }
        addafter("Last Date Modified")
        {
            field("Reserved Qty. on Sales Orders"; Rec."Reserved Qty. on Sales Orders")
            {
                ApplicationArea = ALL;
            }
            field("Disponibility Inventory "; Rec.Inventory - Rec."Reserved Qty. on Sales Orders")
            {
                ApplicationArea = ALL;
            }
            field("Trans. Ord. Shipment (Qty.)"; Rec."Trans. Ord. Shipment (Qty.)")
            {
                ApplicationArea = ALL;
            }
        }
        addafter("Cost is Adjusted")
        {
            field("Average Cost (LCY)"; AverageCostLCY)
            {
                ApplicationArea = ALL;
                trigger OnValidate()
                begin
                    ItemCostMgt.CalculateAverageCost(Rec, AverageCostLCY, AverageCostACY);
                end;

            }
        }
        addafter("Unit Price")
        {
            field("Standard cost with freight"; Rec."Standard Cost" + Rec."Freight Cost")
            {
                ApplicationArea = ALL;
            }
            field("Price Includes VAT2"; Rec."Price Includes VAT")
            {
                ApplicationArea = ALL;
            }
        }
        addafter("Sales Unit of Measure")
        {
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
        }
        addafter("Lead Time Calculation")
        {
            field("Inventory Value Zero"; Rec."Inventory Value Zero")
            {
                ApplicationArea = ALL;
            }
        }
        addafter("Order Multiple")
        {
            field("Units per Parcel"; Rec."Units per Parcel")
            {
                ApplicationArea = ALL;
            }
        }
        addafter(Item)
        {
            group(ALGO)
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
                field("Collection"; Rec."Collection")
                {
                    ApplicationArea = ALL;
                }
                field("Raw material family"; Rec."Raw material family")
                {
                    ApplicationArea = ALL;
                }
                field("Raw Item"; Rec."Raw item")
                {
                    ApplicationArea = ALL;
                }
                field("Customer"; Rec."Customer")
                {
                    ApplicationArea = ALL;
                }
            }
            group(Budget)
            {
                Caption = 'Couts Unitaires Budget';

                //  'C.U.B.'
                field("CUB Unit Cost"; RecGBugetCost."Unit Cost")
                {
                    Caption = 'CUB Unit Cost', locked = true;
                    trigger OnAssistEdit()
                    begin
                        CurrPage.Update();
                    end;
                }

                field("CUB Forecast Qty"; RecGBugetCost."Forecasted Quantity")
                {
                    Caption = 'CUB Quantité budgetée', locked = true;
                }
                field("CUB Date Debut"; RecGBugetCost."Starting Date")
                {
                    Caption = 'CUB Date Debut', locked = true;
                }
                field("CUB Date Fin"; RecGBugetCost."Ending Date")
                {
                    Caption = 'CUB Date Fin', locked = true;
                }
                field("CUB Der Modif par"; RecGBugetCost."Last Modified by")
                {
                    Caption = 'CUB Der Modif par', locked = true;
                }
                field("CUB Date Der Modif"; RecGBugetCost."Last Modified Date")
                {
                    Caption = 'CUB Date Der Modif', locked = true;
                }

                //  'C.U.R.'                
                field("CUR Unit Cost"; RecGBugetCost2."Unit Cost")
                {
                    Caption = 'CUR Unit Cost', locked = true;
                }
                field("CUR Date Debut"; RecGBugetCost2."Starting Date")
                {
                    Caption = 'CUR Date Debut', locked = true;
                }
                field("CUR Date Fin"; RecGBugetCost2."Ending Date")
                {
                    Caption = 'CUR Date Fin', locked = true;
                }
                field("CUR Der Modif par"; RecGBugetCost2."Last Modified by")
                {
                    Caption = 'CUR Der Modif par', locked = true;
                }
                field("CUR Date Der Modif"; RecGBugetCost2."Last Modified Date")
                {
                    Caption = 'CUR Date Der Modif', locked = true;
                }

                //  'C.U.F.'
                field("CUF Unit Cost"; RecGBugetCost3."Unit Cost")
                {
                    Caption = 'C.U.F.', locked = true;
                }
                field("CUF Date Debut"; RecGBugetCost3."Starting Date")
                {
                    Caption = 'CUF Date Debut', locked = true;
                }
                field("CUF Date Fin"; RecGBugetCost3."Ending Date")
                {
                    Caption = 'CUF Date Fin', locked = true;
                }
                field("CUF Der Modif par"; RecGBugetCost3."Last Modified by")
                {
                    Caption = 'CUF Modifié par', locked = true;
                }
                field("CUF Date Der Modif"; RecGBugetCost3."Last Modified Date")
                {
                    Caption = 'CUF Date derniere modification', locked = true;
                }


                //  'C.U.F.R.'
                field("CUFR Unit Cost"; RecGBugetCost4."Unit Cost")
                {
                    Caption = 'C.U.F.R.', locked = true;
                }
                field("CUFR Date Debut"; RecGBugetCost4."Starting Date")
                {
                    Caption = 'CUFR Date Debut', locked = true;
                }
                field("CUFR Date Fin"; RecGBugetCost4."Ending Date")
                {
                    Caption = 'CUFR Date Fin', locked = true;
                }
                field("CUFR Der Modif par"; RecGBugetCost4."Last Modified by")
                {
                    Caption = 'CUFR Modifié par', locked = true;
                }
                field("CUFR Date Der Modif"; RecGBugetCost4."Last Modified Date")
                {
                    Caption = 'CUFR Date derniere modification', locked = true;
                }
            }
        }
    }


    actions
    {
        addafter(Resources)
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
                    RunPageOnRec = False;
                    RunPageView = SORTING("Item No.", "Cost Type", "Starting Date", "Variant Code", "Unit of Measure Code")
                                  ORDER(Ascending);
                    RunPageLink = "Item No." = FIELD("No.");
                }

            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        MAJ_CUBCUR();
        // ----------- CUB ----------
        RecGBugetCost.SETFILTER(RecGBugetCost."Item No.", Rec."No.");
        RecGBugetCost.SETFILTER(RecGBugetCost."Cost Type", 'C.U.B.');
        RecGBugetCost.SETFILTER(RecGBugetCost."Starting Date", '%1|<=%2', 0D, WORKDATE());
        RecGBugetCost.SETFILTER(RecGBugetCost."Ending Date", '%1|>=%2', 0D, WORKDATE());

        IF NOT RecGBugetCost.FINDLAST() THEN BEGIN
            // message(' Pas de CUB defini ');
        END;

        // ----------- CUR ----------
        RecGBugetCost2.SETFILTER(RecGBugetCost2."Item No.", Rec."No.");
        RecGBugetCost2.SETFILTER(RecGBugetCost2."Cost Type", 'C.U.R.');
        RecGBugetCost2.SETFILTER(RecGBugetCost2."Starting Date", '%1|<=%2', 0D, WORKDATE());
        RecGBugetCost2.SETFILTER(RecGBugetCost2."Ending Date", '%1|>=%2', 0D, WORKDATE());

        IF NOT RecGBugetCost2.FINDLAST() THEN BEGIN
            // message(' Pas de CUR defini ');
        END;

    end;

    local procedure MAJ_CUBCUR()
    var
    begin

        RecGBugetCost.SETFILTER(RecGBugetCost."Item No.", Rec."No.");
        RecGBugetCost.SETFILTER(RecGBugetCost."Cost Type", 'C.U.B.');
        RecGBugetCost.SETFILTER(RecGBugetCost."Starting Date", '%1|<=%2', 0D, WORKDATE());
        RecGBugetCost.SETFILTER(RecGBugetCost."Ending Date", '%1|>=%2', 0D, WORKDATE());

        IF NOT RecGBugetCost.FINDLAST() THEN BEGIN
            // message(' Pas de CUB defini ');
        END;

        // ----------- CUR ----------

        RecGBugetCost2.SETFILTER(RecGBugetCost2."Item No.", Rec."No.");
        RecGBugetCost2.SETFILTER(RecGBugetCost2."Cost Type", 'C.U.R.');
        RecGBugetCost2.SETFILTER(RecGBugetCost2."Starting Date", '%1|<=%2', 0D, WORKDATE());
        RecGBugetCost2.SETFILTER(RecGBugetCost2."Ending Date", '%1|>=%2', 0D, WORKDATE());

        IF NOT RecGBugetCost2.FINDLAST() THEN BEGIN
            // message(' Pas de CUR defini ');
        END;

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
        AverageCostLCY: Decimal;
        AverageCostACY: Decimal;
        ItemCostMgt: Codeunit ItemCostManagement;
        RecGBugetCost: Record "Unit Cost Budget";
        RecGBugetCost2: Record "Unit Cost Budget";
        RecGBugetCost3: Record "Unit Cost Budget";
        RecGBugetCost4: Record "Unit Cost Budget";
}