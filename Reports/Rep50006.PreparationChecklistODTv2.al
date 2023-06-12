report 50006 "Preparation Checklist -ODT-V2"
{
    Caption = 'Liste de préparation - ODT - V2';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports/Rep50006.PreparationChecklistODTv2.rdl';
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
            // >> Ajout du n° de doc externe pour affichage dans le report
            column(External_Document_No_; "External Document No.")
            {
            }

            dataitem("Transfer Line"; "Transfer Line")
            {
                DataItemTableView = SORTING("Item No.") ORDER(Ascending) WHERE("Outstanding Quantity" = FILTER(<> 0), "Derived From Line No." = CONST(0));
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = "Transfer Header";
                RequestFilterFields = "Document No.", "Item No.", "Reserved Quantity Outbnd.", "Transfer-from Code", "Transfer-to Code", "Prod. Order No.";

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
                column(LblDocument_No_; 'N° Document')
                {
                }
                column(LblItem_No_; 'N° Article')
                {
                }
                column(LblOutstanding_Quantity; 'Quantité Restante')
                {
                }
                column(LblUnit_of_Measure; 'Unité de mesure')
                {
                }
                column(LblPF_concerned; 'PF Concerné')
                {
                }
                column(LblTransfer_to_Code; 'Code Dest. Transfert')
                {
                }
                column(InventoryLannonlier; RecGItem.Inventory)
                {
                }
                column(Prod__Order_No_; "Prod. Order No.")
                {
                }
                column(LibProdOrderNo; 'N° Ordre de fabrication')
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
                    {
                    }
                    column(Raw_material_family; "Raw material family")
                    {
                    }
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