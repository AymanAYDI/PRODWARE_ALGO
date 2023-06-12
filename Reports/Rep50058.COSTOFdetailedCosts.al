report 50058 "COST- OF detailed Costs"
{
    Caption = 'COST- OF detailed Costs';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports/Rep50058.COST-OFdetailedCosts.rdl';
    ApplicationArea = Basic, Suite;
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Prod. Order Line"; "Prod. Order Line")
        {
            DataItemTableView = SORTING(Status, "Prod. Order No.", "Line No.") ORDER(Ascending) WHERE(Status = FILTER(Finished));
            RequestFilterFields = "Item No.", "Remaining Quantity", "Creation Date";

            column(Prod__Order_No_; "Prod. Order No.")
            {
            }
            column(ProdOrderLine_Line_No_; "Line No.")
            {
            }
            column(Status; Status)
            {
            }
            column(Creation_Date; "Creation Date")
            {
            }
            column(Item_No_; "Item No.")
            {
            }
            column(Quantity; Quantity)
            {
            }
            column(Finished_Quantity; "Finished Quantity")
            {
            }
            column(Remaining_Quantity; "Remaining Quantity")
            {
            }
            column(Ending_Date; "Ending Date")
            {
            }
            dataitem("Prod. Order Component"; "Prod. Order Component")
            {
                DataItemTableView = SORTING(Status, "Prod. Order No.", "Prod. Order Line No.", "Line No.") ORDER(Ascending) WHERE("Line No." = FILTER(<> 0));
                DataItemLinkReference = "Prod. Order Line";
                DataItemLink = Status = FIELD(Status), "Prod. Order No." = FIELD("Prod. Order No."), "Prod. Order Line No." = FIELD("Line No.");

                column(ProdOrderComponent_Line_No_; "Line No.")
                {
                }
                column(Expected_Quantity; "Expected Quantity")
                {
                }
                column(Act__Consumption__Qty_; "Act. Consumption (Qty)")
                {
                }
                column(Unit_Cost; "Unit Cost")
                {
                }
                column(Cost_Amount; "Cost Amount")
                {
                }
                dataitem("Prod. Order Routing Line"; "Prod. Order Routing Line")
                {
                    DataItemTableView = SORTING(Status, "Prod. Order No.", "Routing Reference No.", "Routing No.", "Operation No.") ORDER(Ascending);
                    DataItemLinkReference = "Prod. Order Component";
                    DataItemLink = "Prod. Order No." = FIELD("Prod. Order No."), Status = FIELD(Status);

                    column(Routing_Reference_No_; "Routing Reference No.")
                    {
                    }
                    column(Routing_No_; "Routing No.")
                    {
                    }
                    column(Operation_No_; "Operation No.")
                    {
                    }
                    column(Type; Type)
                    {
                    }
                    column(No_; "No.")
                    {
                    }
                    column(Unit_Cost_per; "Unit Cost per")
                    {
                    }
                }
                dataitem("Item Ledger Entry"; "Item Ledger Entry")
                {
                    DataItemLinkReference = "Prod. Order Component";
                    DataItemLink = "Order No." = FIELD("Prod. Order No."), "Order Line No." = FIELD("Prod. Order Line No."), "Prod. Order Comp. Line No." = FIELD("Line No."), "Item No." = FIELD("Item No.");

                    column(Cost_Amount__Actual_; "Cost Amount (Actual)")
                    {
                    }
                    column(ItemLedgerEntry_Quantity; Quantity)
                    {
                    }

                }
            }

        }
    }
}