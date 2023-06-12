report 50035 "Preparation Checklist -ODT-V3"
{
    Caption = 'Liste de préparation ODT par famille MP';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports/Rep50035.PreparationChecklistODTv3.rdl';
    ApplicationArea = Basic, Suite;
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Transfer Header"; "Transfer Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "Already Shipped";
            column(TransferHeaderFilter; GETFILTERS())
            {
            }
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
                column(TransferLineFilter; GETFILTERS())
                {
                }
                dataitem(Item; Item)
                {
                    DataItemTableView = sorting("No.");
                    DataItemLinkReference = "Transfer Line";
                    DataItemLink = "No." = field("Item No."), "Location Filter" = FIELD("Transfer-to Code");
                    RequestFilterFields = "Raw material family";

                    column(Document_No_; "Transfer Line"."Document No.")
                    {
                    }
                    column(Line_No_; "Transfer Line"."Line No.")
                    {
                    }
                    column(Outstanding_Quantity; "Transfer Line"."Outstanding Quantity")
                    {
                    }
                    column(Unit_of_Measure; "Transfer Line"."Unit of Measure")
                    {
                    }
                    column(PF_concerned; "Transfer Line"."PF concerned")
                    {
                    }
                    column(Transfer_to_Code; "Transfer Line"."Transfer-to Code")
                    {
                    }

                    column(ItemFilter; GETFILTERS())
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
                    column(Item_No_; "No.")
                    {
                    }
                    column(Raw_material_family; "Raw material family")
                    {
                    }
                }

            }
        }
    }
}