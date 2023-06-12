report 50090 "LOG - O.F. Componments"
{
    Caption = 'LOG - O.F. Componments';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports/Rep50090.LOGOFComponments.rdl';
    ApplicationArea = Basic, Suite;
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;


    dataset
    {
        dataitem("Prod. Order Component"; "Prod. Order Component")
        {
            DataItemTableView = SORTING(Status, "Prod. Order No.", "Prod. Order Line No.", "Line No.") ORDER(Ascending) WHERE(Status = FILTER(Released));
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