report 50025 "MP consumption for NC"
{
    Caption = 'MP consumption for NC';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports/Rep50025.MPconsumptionforNC.rdl';
    //ApplicationArea = Basic, Suite;
    PreviewMode = PrintLayout;
    //UsageCategory = ReportsAndAnalysis;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") ORDER(Ascending) WHERE("Document Type" = CONST(Order), "No." = FILTER('RCA*'));
            RequestFilterFields = "No.";

            column(No_; "No.")
            {
            }
            column(Order_Date; "Order Date")
            {
            }
            column(Vendor_Shipment_No_; "Vendor Shipment No.")
            {
            }
            column(Last_Return_Shipment_No; "Last Return Shipment No.")
            {
            }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemTableView = SORTING("Type", "No.", "Variant Code", "Drop Shipment", "Location Code", "Document Type", "Expected Receipt Date") ORDER(Ascending) WHERE("Type" = CONST(Item));
                DataItemLinkReference = "Purchase Header";
                DataItemLink = "Document No." = FIELD("No.");

                column(Buy_from_Vendor_No_; "Buy-from Vendor No.")
                {
                }
                column(ItemNo; "No.")
                {
                }
                column(Description; Description)
                {
                }
                column(Description_2; "Description 2")
                {
                }
                column(Quantity; Quantity)
                {
                }
                column(TxtPO; TxtPO)
                {
                }
                column(DecGQuantity; DecGQuantity)
                {
                }

                dataitem("Production BOM Line"; "Production BOM Line")
                {
                    DataItemTableView = SORTING("Production BOM No.", "Version Code", "Line No.") ORDER(Ascending) WHERE("Version Code" = FILTER(''), "Line No." = FILTER(> 0), "Ending Date" = FILTER(''));
                    DataItemLinkReference = "Purchase Line";
                    DataItemLink = "Production BOM No." = FIELD("No.");

                    column(ProductionBOMNo; "No.")
                    {
                    }
                    column(ProdBomDescription; Description)
                    {
                    }
                    column(Unit_of_Measure_Code; "Unit of Measure Code")
                    {
                    }
                    column(ItemPicture; RecGItem.Picture)
                    {
                    }
                }
                trigger OnPreDataItem()
                begin
                    DecGQuantity := 0;
                end;

                trigger OnAfterGetRecord()
                var
                    RecLPurchaseLine: Record "Purchase Line";
                begin

                    IF RecGItem.GET("Purchase Line"."No.") THEN;// RecGItem.CALCFIELDS(RecGItem.Picture);

                    TxtPO := '';
                    RecLPurchaseLine.RESET();
                    RecLPurchaseLine.SETRANGE("Document No.", "Document No.");
                    RecLPurchaseLine.SETRANGE("No.", "No.");
                    RecLPurchaseLine.SETFILTER("P.O.", '<>%1', '');
                    IF RecLPurchaseLine.FindSet() THEN
                        REPEAT
                            TxtPO += RecLPurchaseLine."P.O." + ' / ';
                        UNTIL RecLPurchaseLine.NEXT() = 0;
                    IF STRLEN(TxtPO) > 0 THEN
                        TxtPO := COPYSTR(TxtPO, 1, STRLEN(TxtPO) - 3);

                    DecGQuantity := 0;
                    RecLPurchaseLine.RESET();
                    RecLPurchaseLine.SETRANGE("Document No.", "Document No.");
                    RecLPurchaseLine.SETRANGE("No.", "No.");
                    IF RecLPurchaseLine.FindSet() THEN
                        REPEAT
                            DecGQuantity += RecLPurchaseLine.Quantity;
                        UNTIL RecLPurchaseLine.NEXT() = 0;

                end;
            }
        }
    }
    var
        RecGItem: Record Item;
        TxtPO: Text[500];
        DecGQuantity: Decimal;

}