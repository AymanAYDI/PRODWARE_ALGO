report 50072 "Inventory Picking List CLIC"
{
    Caption = 'Inventory Picking List CLIC';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports/Rep50072.InventoryPickingListCLIC.rdl';
    ApplicationArea = Basic, Suite;
    //PreviewMode = PrintLayout;
    PreviewMode = Normal;

    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Sales Line"; "Sales Line")
        {
            DataItemTableView = WHERE(Type = CONST(Item), "Document Type" = CONST(Order), "Outstanding Quantity" = FILTER(<> 0));
            RequestFilterFields = "Sell-to Customer No.", "Promised Delivery Date", "Location Code", "Document No.", "No.", "Reserved Quantity";

            column(SalesLineFilter; SalesLineFilter)
            {
            }
            column(Document_No_; "Document No.")
            {
            }
            column(Sell_to_Customer_No_; "Sell-to Customer No.")
            {
            }
            column(No_; "No.")
            {
            }
            column(Description; RecGItem.Description)
            {
            }
            column(Description2; RecGItem."Description 2")
            {
            }
            column(Promised_Delivery_Date; "Promised Delivery Date")
            {
            }
            column(PO; PO)
            {
            }
            column(Cust_Ref_; "Cust Ref.")
            {
            }
            column(External_Document_No_; RecGSalesHeader."External Document No.")
            {
            }
            column(Outstanding_Quantity; "Outstanding Quantity")
            {
            }
            column(Location_Code; "Location Code")
            {
            }
            column(Reserved_Quantity; "Reserved Quantity")
            {
            }
            column(Text000; Text000)
            {
            }
            column(Text001; Text001)
            {
            }
            column(Text002; Text002)
            {
            }


            trigger OnPreDataItem()
            begin

                DecGTotalOutQty := 0;
                DecGTotalReserv := 0;
            end;

            trigger OnAfterGetRecord()
            begin

                RecGSalesHeader.GET("Document Type", "Document No.");

                Cust.GET("Sell-to Customer No.");
                "Sales Line".CALCFIELDS("Reserved Qty. (Base)", "Reserved Quantity");

                RecGItem.GET("No.");

                RecGItemTrans.RESET();
                RecGItemTrans.SETRANGE("Item No.", "No.");
                RecGItemTrans.SETRANGE("Language Code", RecGSalesHeader."Language Code");
                IF RecGItemTrans.FindSet() THEN
                    TxtGColor := RecGItemTrans."Description 2"
                ELSE
                    TxtGColor := '';

                DecGTotalOutQty += "Outstanding Quantity";
                DecGTotalReserv += "Reserved Quantity";
            end;

        }
    }
    trigger OnPreReport()
    begin
        SalesLineFilter := "Sales Line".GETFILTERS;
    end;

    var
        Cust: Record Customer;
        ItemVariant: Record "Item Variant";
        ItemFilter: Text[250];
        SalesLineFilter: Text[250];
        GroupTotal: Boolean;
        TxtGColor: Text[50];
        RecGItemTrans: Record "Item Translation";
        RecGItem: Record Item;
        RecGSalesHeader: Record "Sales Header";
        DecGTotalOutQty: Decimal;
        DecGTotalReserv: Decimal;
        Text000: Label 'Sales Order Line: %1';
        Text001: Label 'Parcel No.';
        Text002: Label 'Pallet No.';
}