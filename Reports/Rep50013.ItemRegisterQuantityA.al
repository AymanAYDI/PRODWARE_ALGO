report 50013 "Item Register - Quantity - A"
{
    // version NAVW113.00
    // copy from R703

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports/Rep50013.ItemRegisterQuantityA.rdl';
    ApplicationArea = Basic, Suite;
    Caption = 'Item Register - Quantity';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Item Register"; "Item Register")
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Source Code", "Journal Batch Name", "User ID";
            column(CompanyName; COMPANYPROPERTY.DisplayName)
            {
            }
            column(ItemRegFilterCopyText; "Item Register".TABLECAPTION + ': ' + ItemRegFilter)
            {
            }
            column(No_ItemRegister; "No.")
            {
            }
            column(ItemRegQtyCaption; ItemRegQtyCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
            {
            }
            column(PostingDateCaption; PostingDateCaptionLbl)
            {
            }
            column(ItemDescriptionCaption; ItemDescriptionCaptionLbl)
            {
            }
            column(No_ItemRegisterCaption; No_ItemRegisterCaptionLbl)
            {
            }
            column(Qty_ItemRegisterCaption; Qty_ItemRegisterCaptionbl)
            {
            }
            column(UnitOfMes_ItemLedgEntryCaption; UnitOfMes_ItemLedgEntryCaptionLbl)
            {
            }
            column(LocationCode_ItemLedgEntryCaption; LocationCode_ItemLedgEntrybl)
            {
            }
            column(ExtDocNo_ItemLedgEntryCaption; ExtDocNo_ItemLedgEntryCaptionbl)
            {
            }
            Column(ReturReasonCode_ItemLedgEntryCaption; ReturReasonCode_ItemLedgEntryCaptionbl)
            {
            }
            column(CompanyInfo_Name; CompanyInfo.Name)
            {
            }
            column(CompanyInfo_Address; CompanyInfo.Address + ' - ' + CompanyInfo."Address 2" + ' - ' + CompanyInfo."Post Code" + ' ' + CompanyInfo.City)
            {
            }
            column(CompanyInfo_Phone; 'T‚l : ' + CompanyInfo."Phone No.")
            {
            }
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {

                DataItemTableView = SORTING("Entry No.");
                RequestFilterFields = "Source No.", "Entry Type", "Item No.", "Posting Date", "Source Type", "Location Code";


                column(PostingDate_ItemLedgEntry; Format("Posting Date"))
                {
                }
                column(EntryType_ItemLedgEntry; "Entry Type")
                {
                    IncludeCaption = true;
                }
                column(ItemNo_ItemLedgEntry; "Item No.")
                {
                    IncludeCaption = true;
                }
                column(ItemDescription; ItemDescription)
                {
                }
                column(Quantity_ItemLedgEntry; Quantity / "Item Ledger Entry"."Qty. per Unit of Measure")
                {
                    // IncludeCaption = true;
                }
                // column(EntryNo_ItemLedgEntry; "Entry No.")
                // {
                //     IncludeCaption = true;
                // }
                column(DocNo_ItemLedgEntry; "Document No.")
                {
                    IncludeCaption = true;
                }
                column(LocationCode_ItemLedgEntry; "Location Code")
                {
                    IncludeCaption = true;
                }
                column(UnitOfMes_ItemLedgEntry; "Unit of Measure Code")
                {
                    IncludeCaption = true;
                }
                column(ExtDocNo_ItemLedgEntry; "External Document No.")
                {
                    IncludeCaption = true;
                }
                column(ReturReasonCode_ItemLedgEntry; "Return Reason Code")
                {
                    IncludeCaption = true;
                }
                column(DecGTotQty_; "DecGTotQty")
                {
                }


                trigger OnAfterGetRecord()
                begin
                    ItemDescription := Description;
                    if ItemDescription = '' then begin
                        if not Item.Get("Item No.") then
                            Item.Init;
                        ItemDescription := Item.Description;
                        DecGTotQty += "Item Ledger Entry".Quantity / "Item Ledger Entry"."Qty. per Unit of Measure";
                    end;

                end;

                trigger OnPreDataItem()
                begin
                    SetRange("Entry No.", "Item Register"."From Entry No.", "Item Register"."To Entry No.");

                    ///
                    DecGTotQty := 0;
                    ///
                end;
            }
            trigger OnPreDataItem()
            begin
                CompanyInfo.Get;
            end;
        }
    }

    requestpage
    {

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

    trigger OnPreReport()
    begin
        ItemRegFilter := "Item Register".GetFilters;
    end;

    var
        Item: Record Item;
        ItemRegFilter: Text[250];
        ItemDescription: Text[50];
        ItemRegQtyCaptionLbl: Label 'Item Register - Quantity / Mouvement de stock';
        CurrReportPageNoCaptionLbl: Label 'Page';
        PostingDateCaptionLbl: Label 'Posting Date';
        ItemDescriptionCaptionLbl: Label 'Description';
        No_ItemRegisterCaptionLbl: Label 'Register No.';
        Qty_ItemRegisterCaptionbl: Label 'Quantité';
        UnitOfMes_ItemLedgEntryCaptionLbl: Label 'Code unité';
        LocationCode_ItemLedgEntrybl: Label 'Code magasin';
        ExtDocNo_ItemLedgEntryCaptionbl: Label 'No. doc. externe';
        ReturReasonCode_ItemLedgEntryCaptionbl: Label 'Code motif retour';
        DecGTotQty: Decimal;
        CompanyInfo: Record "Company Information";
}

