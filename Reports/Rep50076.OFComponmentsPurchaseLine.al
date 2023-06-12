report 50076 "O.F. Componments-PurchaseLine"
{
    Caption = 'O.F. Componments-PurchaseLine';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports/Rep50076.OFComponmentsPurchaseLine.rdl';
    ApplicationArea = Basic, Suite;
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;


    dataset
    {
        dataitem("Purchase Line"; "Purchase Line")
        {
            DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") ORDER(Ascending) WHERE("Document Type" = FILTER(Order), "Prod. Order No." = FILTER(<> ''));
            RequestFilterFields = "Document No.", "Prod. Order No.";

            column(Document_No_; "Document No.")
            {
            }

            dataitem("Prod. Order Component"; "Prod. Order Component")
            {
                DataItemTableView = SORTING(Status, "Prod. Order No.", "Prod. Order Line No.", "Line No.") ORDER(Ascending) WHERE(Status = FILTER(Released));
                DataItemLinkReference = "Purchase Line";
                DataItemLink = "Prod. Order No." = FIELD("Prod. Order No."), "Prod. Order Line No." = FIELD("Prod. Order Line No.");
                RequestFilterFields = Status, "Prod. Order No.", "Item No.", "Line No.";

                column(Status; Status)
                {
                }
                column(Prod__Order_No_; "Prod. Order No.")
                {
                }
                column(Prod__Order_Line_No_; "Prod. Order Line No.")
                {
                }
                column(Line_No_; "Line No.")
                {
                }
                column(Position; Position)
                {
                }
                column(Item_No_; "Item No.")
                {
                }
                column(Remaining_Quantity; "Remaining Quantity")
                {
                }
                column(Unit_of_Measure_Code; "Unit of Measure Code")
                {
                }
                column(Location_Code; "Location Code")
                {
                }
                column(PF_to_manufacture; "PF to manufacture")
                {
                }
            }
        }
    }
}