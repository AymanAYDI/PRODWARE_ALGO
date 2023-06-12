report 50026 "Whse. - Posted Receipt - ALGO"
{
    // version NAVW113.00
    // copy from R7308

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports/Rep50026.WhsePostedReceiptALGO.rdl';
    ApplicationArea = Warehouse;
    Caption = 'Warehouse Posted Receipt';
    UsageCategory = Documents;

    dataset
    {
        dataitem("Posted Whse. Receipt Header"; "Posted Whse. Receipt Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                column(CompanyName; COMPANYPROPERTY.DisplayName)
                {
                }
                column(TodayFormatted; Format(Today, 0, 4))
                {
                }
                // column(Assgnd_PostedWhseRcpHeader; "Posted Whse. Receipt Header"."Assigned User ID")
                // {
                //     IncludeCaption = true;
                // }
                column(LocCode_PostedWhseRcpHeader; "Posted Whse. Receipt Header"."Location Code")
                {
                    IncludeCaption = true;
                }
                column(No_PostedWhseRcpHeader; "Posted Whse. Receipt Header"."No.")
                {
                    IncludeCaption = true;
                }
                column(BinMandatoryShow1; not Location."Bin Mandatory")
                {
                }
                column(BinMandatoryShow2; Location."Bin Mandatory")
                {
                }
                column(RecGLoc_Name; RecGLoc."Name")
                {
                }
                column(RecGLoc_Address; RecGLoc.Address)
                {
                }
                column(RecGLoc_Address_2; RecGLoc."Address 2")
                {
                }
                column(STRSUBSTNO_Text001_RecGLoc__Post_Code__RecGLoc_City_; STRSUBSTNO(Text001, RecGLoc."Post Code", RecGLoc.City))
                {
                }
                column(Posted_Whse__Receipt_Header___Posting_Date_; "Posted Whse. Receipt Header"."Posting Date")
                {
                }
                column(Posted_Whse_Receipt_Header_Whse_Receipt_No; "Posted Whse. Receipt Header"."Whse. Receipt No.")
                {
                }
                column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
                {
                }
                column(WarehousePostedReceiptCaption; WarehousePostedReceiptCaptionLbl)
                {
                }
                column(Desc_2_PostedWhseRcptLineCaption; Posted_Whse__Receipt_Line__Description_2_Captionbl)
                {
                }
                column(Num_PreparationCaption; Num_PreparationCaptionbl)
                {
                }

                dataitem("Posted Whse. Receipt Line"; "Posted Whse. Receipt Line")
                {
                    DataItemLink = "No." = FIELD("No.");
                    DataItemLinkReference = "Posted Whse. Receipt Header";
                    DataItemTableView = SORTING("Item No.", "Source No.")
                                        ORDER(ascending);
                    column(ShelfNo_PostedWhseRcpLine; "Shelf No.")
                    {
                        IncludeCaption = true;
                    }
                    column(ItemNo_PostedWhseRcpLine; "Item No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Desc_PostedWhseRcptLine; Description)
                    {
                        IncludeCaption = true;
                    }
                    column(UOM_PostedWhseRcpLine; "Unit of Measure Code")
                    {
                        IncludeCaption = true;
                    }
                    column(LocCode_PostedWhseRcpLine; "Location Code")
                    {
                        IncludeCaption = true;
                    }
                    column(Qty_PostedWhseRcpLine; Quantity)
                    {
                        IncludeCaption = true;
                    }
                    column(SourceNo_PostedWhseRcpLine; "Source No.")
                    {
                        IncludeCaption = true;
                    }
                    column(SourceDoc_PostedWhseRcpLine; "Source Document")
                    {
                        IncludeCaption = true;
                    }
                    // column(ZoneCode_PostedWhseRcpLine; "Zone Code")
                    // {
                    //     IncludeCaption = true;
                    // }
                    // column(BinCode_PostedWhseRcpLine; "Bin Code")
                    // {
                    //     IncludeCaption = true;
                    // }
                    column(Posted_Whse__Receipt_Line__Description_2__; "Description 2")
                    {
                        IncludeCaption = true;
                    }
                    column(Posted_Whse__Receipt_Line__Tracking_No; RecGTransferRcptLine."Tracking No.")
                    {
                        IncludeCaption = true;
                    }


                    trigger OnAfterGetRecord()
                    begin
                        GetLocation("Location Code");
                        ///
                        IF ("Source Document" = "Source Document"::"Inbound Transfer") THEN
                            RecGTransferRcptLine.GET("Posted Source No.", "Source Line No.");
                        RecGTransferRcptLine.SETFILTER("Document No.", "Posted Source No.");
                        RecGTransferRcptLine.SETRANGE("Line No.", "Source Line No.");
                        RecGTransferRcptLine.SETFILTER("Transfer Order No.", "Source No.");
                        ///
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                GetLocation("Location Code");
                ///
                RecGLoc.GET("Location Code");
                ///

            end;
        }
    }

    requestpage
    {
        Caption = 'Warehouse Posted Receipt';

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Location: Record Location;
        CurrReportPageNoCaptionLbl: Label 'Page';
        WarehousePostedReceiptCaptionLbl: Label 'Warehouse - Posted Receipt';
        Posted_Whse__Receipt_Line__Description_2_Captionbl: Label 'Desccription 2';
        Num_PreparationCaptionbl: Label 'No. Préparation';
        Text001: Label '%1 %2';
        RecGLoc: Record Location;
        RecGTransferRcptLine: Record "Transfer Receipt Line";


    local procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
            Location.Init
        else
            if Location.Code <> LocationCode then
                Location.Get(LocationCode);
    end;
}

