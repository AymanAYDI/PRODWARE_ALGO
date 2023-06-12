report 50008 "Preparation Checklist - ODT"
{
    Caption = 'Preparation Checklist - ODT';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports/Rep50008.PreparationChecklistODT.rdl';
    ApplicationArea = Basic, Suite;
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Transfer Header"; "Transfer Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "Already Shipped";

            column(No_; "No.")
            {
            }

            dataitem("Transfer Line"; "Transfer Line")
            {
                DataItemTableView = SORTING("Item No.") ORDER(Ascending) WHERE("Outstanding Quantity" = FILTER(<> 0), "Derived From Line No." = CONST(0));
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = "Transfer Header";
                RequestFilterFields = "Document No.", "Item No.", "Reserved Quantity Outbnd.", "Transfer-from Code", "Transfer-to Code", "Prod. Order Line No.";

                column(Document_No_; "Document No.")
                {
                }
                column(Line_No_; "Line No.")
                {
                }
                column(Item_No_; "Item No.")
                {
                }
                column(Outstanding_Quantity; "Outstanding Quantity")
                {
                }
                column(Unit_of_Measure; "Unit of Measure")
                {
                }
                column(PF_concerned; "PF concerned")
                {
                }
                column(Transfer_to_Code; "Transfer-to Code")
                {
                }
                column(TransferLineFilter; GETFILTERS())
                {
                }
                column(LblDocument_No_; fieldname("Document No."))
                {
                }
                column(LblItem_No_; fieldname("Item No."))
                {
                }
                column(LblOutstanding_Quantity; fieldname("Outstanding Quantity"))
                {
                }
                column(LblUnit_of_Measure; fieldname("Unit of Measure"))
                {
                }
                column(LblPF_concerned; fieldname("PF concerned"))
                {
                }
                column(LblTransfer_to_Code; fieldname("Transfer-to Code"))
                {
                }
                column(InventoryLannonlier; RecGItem.Inventory)
                {
                }

                dataitem(Item; Item)
                {
                    DataItemTableView = sorting("No.");
                    DataItemLinkReference = "Transfer Line";
                    DataItemLink = "No." = field("Item No."), "Location Filter" = FIELD("Transfer-to Code");
                    CalcFields = Inventory, "Qty. on Component Lines", "Qty. on Prod. Order";

                    column(Description; Description)
                    {
                    }
                    column(Qty__on_Component_Lines; "Qty. on Component Lines")
                    {
                    }
                    column(Qty__on_Prod__Order; "Qty. on Prod. Order")
                    {
                    }
                    column(Inventory; Inventory)
                    {
                    }
                    column(Qty_on_Transfer_Line; RecGItem."Qty on Transfer Line")
                    { }
                }
                trigger OnAfterGetRecord()
                begin

                    RecGItem.Reset();
                    IF RecGItem.GET("Transfer Line"."Item No.") THEN BEGIN
                        RecGItem.SETFILTER("Location Filter", 'LANNOLIER1');
                        RecGItem.CALCFIELDS(Inventory, "Qty on Transfer Line");
                    END;
                end;
            }
        }
    }

    var
        RecGItem: Record item;
}