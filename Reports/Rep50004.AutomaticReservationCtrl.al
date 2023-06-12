report 50004 "Automatic Reservation Ctrl"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports/Rep50004.AutomaticReservationCtrl.rdl';
    Caption = 'Automatic Reservation Control';

    dataset
    {
        dataitem("Reservation Entry"; "Reservation Entry")
        {
            DataItemTableView = SORTING("Entry No.", "Positive") ORDER(Ascending) WHERE("Reservation Status" = FILTER("Reservation"),
                                                                                    "Source Type" = FILTER(37),
                                                                                    "Source Subtype" = FILTER(1),
                                                                                    "Location Code" = FILTER('LANNOLIER1'));
            RequestFilterFields = "Creation Date", "Created By";

            column(Filters; "Reservation Entry".TABLECAPTION() + ': ' + "Reservation Entry".GETFILTERS())
            {

            }
            column(Item_No_; "Item No.")
            {
                IncludeCaption = true;
            }
            column(Source_ID; "Source ID")
            {
                IncludeCaption = true;
            }
            column(Source_Ref__No_; "Source Ref. No.")
            {
                IncludeCaption = true;
            }
            column(Shipment_Date; "Shipment Date")
            {
                IncludeCaption = true;
            }
            column(Quantity; Quantity)
            {
                IncludeCaption = true;
            }
        }
    }

}