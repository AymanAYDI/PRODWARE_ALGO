report 50019 "Transfer Shipment - ALGO"
{
    // version NAVW113.00
    // copy from R5704

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports/Rep50019.TransferShipmentALGO.rdl';
    Caption = 'Transfer Shipment';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Transfer Shipment Header"; "Transfer Shipment Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Transfer-from Code", "Transfer-to Code";
            RequestFilterHeading = 'Posted Transfer Shipment';
            column(No_TransShptHeader; "No.")
            {
            }
            // dataitem(CopyLoop; "Integer")
            // {
            //     DataItemTableView = SORTING (Number);
            //     dataitem(PageLoop; "Integer")
            //     {
            //         DataItemTableView = SORTING (Number) WHERE (Number = CONST (1));
            column(CopyTextCaption; StrSubstNo(Text001, CopyText))
            {
            }
            column(TransferToAddr1; TransferToAddr[1])
            {
            }
            column(TransferFromAddr1; TransferFromAddr[1])
            {
            }
            column(TransferToAddr2; TransferToAddr[2])
            {
            }
            column(TransferFromAddr2; TransferFromAddr[2])
            {
            }
            column(TransferToAddr3; TransferToAddr[3])
            {
            }
            column(TransferFromAddr3; TransferFromAddr[3])
            {
            }
            column(TransferToAddr4; TransferToAddr[4])
            {
            }
            column(TransferFromAddr4; TransferFromAddr[4])
            {
            }
            column(TransferToAddr5; TransferToAddr[5])
            {
            }
            column(TransferToAddr6; TransferToAddr[6])
            {
            }
            column(InTransit_TransShptHeader; "Transfer Shipment Header"."In-Transit Code")
            {
                IncludeCaption = true;
            }
            column(PostDate_TransShptHeader; Format("Transfer Shipment Header"."Posting Date", 0, 4))
            {
            }
            column(No2_TransShptHeader; "Transfer Shipment Header"."No.")
            {
            }
            column(TransferToAddr7; TransferToAddr[7])
            {
            }
            column(TransferToAddr8; TransferToAddr[8])
            {
            }
            column(TransferFromAddr5; TransferFromAddr[5])
            {
            }
            column(TransferFromAddr6; TransferFromAddr[6])
            {
            }
            column(ShiptDate_TransShptHeader; Format("Transfer Shipment Header"."Shipment Date"))
            {
            }
            column(TransferFromAddr7; TransferFromAddr[7])
            {
            }
            column(TransferFromAddr8; TransferFromAddr[8])
            {
            }
            column(PageCaption; StrSubstNo(Text002, ''))
            {
            }
            column(OutputNo; OutputNo)
            {
            }
            column(Desc_ShptMethod; ShipmentMethod.Description)
            {
            }
            column(TransShptHdrNoCaption; TransShptHdrNoCaptionLbl)
            {
            }
            column(TransShptShptDateCaption; TransShptShptDateCaptionLbl)
            {
            }
            column(ShipperCaption; ShipperCaptionLbl)
            {
            }
            column(ReceiverCaption; ReceiverCaptionLbl)
            {
            }
            column(Transfer_Shipment_Header___Transfer_Order_No__; "Transfer Shipment Header"."Transfer Order No.")
            {
            }
            column(Transfer_doc__No_Caption; Transfer_doc__No_CaptionLbl)
            {
            }
            column(USERID; USERID)
            {
            }
            column(Nom_Utilisateur__Caption; Nom_Utilisateur__CaptionLbl)
            {
            }

            dataitem("Transfer Shipment Line"; "Transfer Shipment Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemLinkReference = "Transfer Shipment Header";
                DataItemTableView = SORTING("Document No.", "Line No.")
                                            ORDER(ascending);
                column(ShowInternalInfo; ShowInternalInfo)
                {
                }
                column(NoOfCopies; NoOfCopies)
                {
                }
                column(PrintToExcel; PrintToExcel)
                {
                }
                column(ItemNo_TransShptLine; "Item No.")
                {
                    IncludeCaption = true;
                }
                column(Transfer_Shipment_Line__Description_; "Description")
                {
                }
                column(Transfer_Shipment_Line__Description_Caption; Transfer_Shipment_Line__Description_CaptionLbl)
                {
                }
                column(Qty_TransShptLine; Quantity)
                {
                    IncludeCaption = true;
                }
                column(Transfer_Shipment_Line__Unit_of_Measure_Code_; "Unit of Measure")
                {
                }
                column(Transfer_Shipment_Line__Unit_of_Measure_Code_Caption; Transfer_Shipment_Line__Unit_of_Measure_Code_CaptionLbl)
                {
                }
                column(LineNo_TransShptLine; "Line No.")
                {
                }
                column(Transfer_Shipment_Line__Description_2_; "Description 2")
                {
                }
                column(Transfer_Shipment_Line__Description_2_Caption; Transfer_Shipment_Line__Description_2_CaptionLbl)
                {
                }
                column(TxtGDescription; TxtGDescription)
                {
                }
                column(Transfer_Shipment_Line__PF_concerned_; "PF concerned")
                {
                }
                column(Transfer_Shipment_Line__PF_concerned_Caption; Transfer_Shipment_Line__PF_concerned_CaptionLbl)
                {
                }
                column(Transfer_Shipment_Line__Outstanding_qty_to_ship_; "Outstanding qty to ship")
                {
                }
                column(Transfer_Shipment_Line__Outstanding_qty_to_ship_Caption; Transfer_Shipment_Line__Outstanding_qty_to_ship_CaptionLbl)
                {
                }
                column(DocNo_TransShptLine; "Document No.")
                {
                }
                column(Transfer_Shipment_Line_Trakcing_no; "Tracking No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    //>>TO111016
                    IF RemoveRAL0 = TRUE THEN
                        IF Quantity = 0 THEN
                            CurrReport.SKIP;
                    //<<TO111016

                    DimSetEntry2.SetRange("Dimension Set ID", "Dimension Set ID");

                    ///
                    IF PrintToExcel THEN
                        MakeExcelDataBody;
                    TxtGDescription := "Transfer Shipment Line".Description + '   ' + "Transfer Shipment Line"."Description 2";
                end;

                trigger OnPreDataItem()
                begin
                    MoreLines := Find('+');
                    while MoreLines and (Description = '') and ("Item No." = '') and (Quantity = 0) do
                        MoreLines := Next(-1) <> 0;
                    if not MoreLines then
                        CurrReport.Break;
                    SetRange("Line No.", 0, "Line No.");

                    ///
                    TxtGDescription := "Transfer Shipment Line".Description + '   ' + "Transfer Shipment Line"."Description 2";
                end;
            }




            trigger OnAfterGetRecord()
            begin
                DimSetEntry1.SetRange("Dimension Set ID", "Dimension Set ID");

                FormatAddr.TransferShptTransferFrom(TransferFromAddr, "Transfer Shipment Header");
                FormatAddr.TransferShptTransferTo(TransferToAddr, "Transfer Shipment Header");

                if not ShipmentMethod.Get("Shipment Method Code") then
                    ShipmentMethod.Init;

                //>>MIGRATION2009R2
                TxtGUtilisateur := RecGExpeEnregist.GETFILTER(RecGExpeEnregist."Assigned User ID");
                //<<MIGRATION2009R2
            end;
        }

    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NoOfCopies; NoOfCopies)
                    {
                        ApplicationArea = Location;
                        Caption = 'No. of Copies';
                        ToolTip = 'Specifies how many copies of the document to print.';
                    }
                    field(ShowInternalInfo; ShowInternalInfo)
                    {
                        ApplicationArea = Dimensions;
                        Caption = 'Show Internal Information';
                        ToolTip = 'Specifies if you want all dimensions assigned to the line to be shown.';
                    }
                    field(PrintToExcel; PrintToExcel)
                    {
                    }
                    field(RemoveRAL0; RemoveRAL0)
                    {
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        PostingDateCaption = 'Posting Date';
        ShptMethodCaption = 'Shipment Method';
    }

    var
        Text000: Label 'COPY';
        Text001: Label 'Transfer Shipment %1';
        Text002: Label 'Page %1';
        ShipmentMethod: Record "Shipment Method";
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        FormatAddr: Codeunit "Format Address";
        TransferFromAddr: array[8] of Text[50];
        TransferToAddr: array[8] of Text[50];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        OutputNo: Integer;
        TransShptHdrNoCaptionLbl: Label 'Shipment No.';
        TransShptShptDateCaptionLbl: Label 'Shipment Date';
        HdrDimCaptionLbl: Label 'Header Dimensions';
        LineDimCaptionLbl: Label 'Line Dimensions';
        "-MIGRATIN2009R2-": Integer;
        TxtGUtilisateur: Text[30];
        RecGExpeEnregist: Record "Posted Whse. Shipment Header";
        TxtGDescription: text[200];
        ExcelBuf: Record "Excel Buffer" temporary;
        PrintToExcel: Boolean;
        Text013: Label 'ItemJournalLine';
        "-TO111016": Integer;
        RemoveRAL0: Boolean;
        ShipperCaptionLbl: Label 'Expéditeur :';
        ReceiverCaptionLbl: Label 'Destinataire :';
        Transfer_doc__No_CaptionLbl: Label 'N° Ordre de Transfert :';
        Nom_Utilisateur__CaptionLbl: Label 'Nom Utilisateur';
        Transfer_Shipment_Line__Outstanding_qty_to_ship_CaptionLbl: Label 'Qté restante à livrer';
        Transfer_Shipment_Line__Description_2_CaptionLbl: Label 'Désignation 2';
        Transfer_Shipment_Line__Description_CaptionLbl: Label 'Désignation';
        Transfer_Shipment_Line__PF_concerned_CaptionLbl: Label 'PF concerné';
        Transfer_Shipment_Line__Unit_of_Measure_Code_CaptionLbl: Label 'Code unité';

    trigger OnPreReport()
    begin
        IF PrintToExcel THEN
            MakeExcelInfo();
    END;

    trigger OnPostReport()
    begin
        IF PrintToExcel THEN
            CreateExcelbook();
    END;

    procedure MakeExcelInfo()
    begin
        ExcelBuf.SetUseInfoSheet();
        ExcelBuf.ClearNewRow();
        MakeExcelDataHeader();
    end;

    procedure MakeExcelDataHeader()
    begin
        ExcelBuf.NewRow();
        numligne := 0;
        ExcelBuf.AddColumn('Nom Feuille', FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Nom modŠle feuille', FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Transfer Shipment Line".FIELDCAPTION("Line No."), FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Type Ecriture', FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Transfer Shipment Header".FIELDCAPTION("Posting Date"), FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Transfer Shipment Line".FIELDCAPTION("Document No."), FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Nø doc Externe', FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Transfer Shipment Line".FIELDCAPTION("Item No."), FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Transfer Shipment Line".FIELDCAPTION(Description), FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Transfer Shipment Line".FIELDCAPTION(Quantity), FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Transfer Shipment Line".FIELDCAPTION("Unit of Measure Code"), FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Code Magasin', FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Tracking No.', FALSE, '', TRUE, FALSE, TRUE, '@', ExcelBuf."Cell Type"::Text);
    end;

    procedure MakeExcelDataBody()
    begin
        ExcelBuf.NewRow();
        numligne := numligne + 10000;
        ExcelBuf.AddColumn('ODTALGO', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('ARTICLE', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        //ExcelBuf.AddColumn("Transfer Shipment Line"."Line No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn(numligne, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn('Positif (ajust.)', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Transfer Shipment Header"."Posting Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Date);
        ExcelBuf.AddColumn("Transfer Shipment Line"."Document No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Transfer Shipment Line"."Transfer Order No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Transfer Shipment Line"."Item No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Transfer Shipment Line".Description, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Transfer Shipment Line".Quantity, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Number);
        ExcelBuf.AddColumn("Transfer Shipment Line"."Unit of Measure Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Transfer Shipment Line"."Transfer-to Code", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn("Transfer Shipment Line"."Tracking No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuf."Cell Type"::Text);
    end;

    procedure CreateExcelbook()
    begin
        ExcelBuf.CreateBookAndOpenExcel('', 'ODTALGO', '', '', USERID());
        // ExcelBuf.WriteSheet(Text013, COMPANYNAME(), USERID());
        // ERROR('');
    end;

    var
        numligne: Integer;
}

