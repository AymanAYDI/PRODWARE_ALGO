report 50040 "Items Barcode EAN13 LU"
{
    Caption = 'Etiquette articles LU EAN';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports/Rep50040.ItemsBarcodeEAN13 LU.rdl';
    ApplicationArea = Basic, Suite;
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.";

            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);

                column(No_; Item."No.")
                {
                }
                column(CustomerItemNo; Item."Customer Item No.")
                {
                }
                column(Description; Item.Description)
                {
                }
                column(Description2; Item."Description 2")
                {
                }
                column(VG_TEST_BarCode; VG_TEST_BarCode)
                {
                }
                column(Number; number)
                {
                }
                column(VGColor; VGColor)
                {
                }
                trigger OnPreDataItem()
                begin

                    NoOfCopies := 10;
                    NoOfLoops := ABS(NoOfCopies);
                    SETRANGE(Number, 1, NoOfLoops);
                    OutputNo := 1;

                end;

                trigger OnPostDataItem()
                begin
                    CurrReport.PAGENO := 1;
                end;
            }
            trigger OnAfterGetRecord()
            begin
                //>> Reprise migration 20190625-DSP
                //>> ALGO20190323 \ DSP:

                // FoundPos := RegExFind(SearchString,'([\.\-][0-9][0-9][^\d])|(.(NOI|ROU|GOL)$)');
                // VGcolor :=  copystr(Item."No.",FoundPos+1,

                VG_Item_Color := '';
                VGColor := '';

                // MESSAGE(Item."BarCode EAN13");
                IF (Item."BarCode EAN13") = '' THEN BEGIN
                    VG_TEST_BarCode := '';
                END ELSE BEGIN
                    VG_TEST_BarCode := BarCode.GenerateBarCode(Item."BarCode EAN13");
                END;

                FoundPos := STRLEN(Item."No.");
                VG_Item_Color := COPYSTR(Item."No.", FoundPos - 2, FoundPos);

                IF VG_Item_Color = '-01' THEN VGColor := 'Noir';
                IF VG_Item_Color = '-02' THEN VGColor := 'Rouge';
                IF VG_Item_Color = '-03' THEN VGColor := 'Black_Gold';
                IF VG_Item_Color = '-07' THEN VGColor := 'Orange';
                IF VG_Item_Color = '-08' THEN VGColor := 'Jaune';
                IF VG_Item_Color = '-09' THEN VGColor := 'Vert';
                IF VG_Item_Color = '-10' THEN VGColor := 'BleuCiel';
                IF VG_Item_Color = '-11' THEN VGColor := 'Turquoise';
                IF VG_Item_Color = '-12' THEN VGColor := 'BleuMarine';
                IF VG_Item_Color = '-33' THEN VGColor := 'Bordeau';
                IF VG_Item_Color = '-40' THEN VGColor := 'RoseClair';
                IF VG_Item_Color = '-50' THEN VGColor := 'Blanc';
                IF VG_Item_Color = '-51' THEN VGColor := 'Gris';

                IF VG_Item_Color = 'LLB' THEN VGColor := 'AllBlack';
                IF VG_Item_Color = 'BLA' THEN VGColor := 'FC_Blanc';
                IF VG_Item_Color = 'BLC' THEN VGColor := 'FC_BleuCiel';
                IF VG_Item_Color = 'BLM' THEN VGColor := 'FC_BleuMarine';
                IF VG_Item_Color = 'BOR' THEN VGColor := 'FC_Bordeau';
                IF VG_Item_Color = 'GOL' THEN VGColor := 'FC_Gold';
                IF VG_Item_Color = 'GRI' THEN VGColor := 'FC_Gris';
                IF VG_Item_Color = 'JAU' THEN VGColor := 'FC_Jaune';
                IF VG_Item_Color = 'NOI' THEN VGColor := 'FC_Noir';
                IF VG_Item_Color = 'ORA' THEN VGColor := 'FC_Orange';
                IF VG_Item_Color = 'ROU' THEN VGColor := 'FC_Rouge';
                IF VG_Item_Color = 'VER' THEN VGColor := 'FC_Vert';

                //>> ALGO20190426 \ DSP:
                IF VG_Item_Color = '01P' THEN VGColor := 'Noir';
                IF VG_Item_Color = '02P' THEN VGColor := 'Rouge';
                IF VG_Item_Color = '03P' THEN VGColor := 'Black_Gold';
                IF VG_Item_Color = '07P' THEN VGColor := 'Orange';
                IF VG_Item_Color = '08P' THEN VGColor := 'Jaune';
                IF VG_Item_Color = '09P' THEN VGColor := 'Vert';
                IF VG_Item_Color = '10P' THEN VGColor := 'BleuCiel';
                IF VG_Item_Color = '11P' THEN VGColor := 'Turquoise';
                IF VG_Item_Color = '12P' THEN VGColor := 'BleuMarine';
                IF VG_Item_Color = '33P' THEN VGColor := 'Bordeau';
                IF VG_Item_Color = '40P' THEN VGColor := 'RoseClair';
                IF VG_Item_Color = '50P' THEN VGColor := 'Blanc';
                IF VG_Item_Color = '51P' THEN VGColor := 'Gris';
                //>> ALGO20190426 \ DSP:

                //>> ALGO20190429 \ DSP:
                IF VG_Item_Color = '03O' THEN VGColor := 'Black_Gold';
                IF VG_Item_Color = '33O' THEN VGColor := 'Bordeau';
                //>> ALGO20190429 \ DSP:

                //>> ALGO20190516 -01 \ DSP:
                IF VG_Item_Color = 'ROS' THEN VGColor := 'FC_Lightpink';
                IF VG_Item_Color = 'BLT' THEN VGColor := 'FC_Turquoise';
                IF VG_Item_Color = '50E' THEN VGColor := 'Blanc';
                //>> ALGO20190516 -01 \ DSP:

                //>> ALGO20190516 -02 \ DSP:
                FoundPos := STRLEN(Item."No.");
                VG_Item_Color_Special5 := COPYSTR(Item."No.", FoundPos - 4, FoundPos);
                IF VG_Item_Color_Special5 = '11GOL' THEN VGColor := 'TurquoiseGold';
                //>> ALGO20190516 -02 \ DSP:

                //>> ALGO20190529 -01 \ DSP:
                IF VG_Item_Color = 'ENO' THEN VGColor := 'FC_Noir';
                IF VG_Item_Color = 'RDG' THEN VGColor := 'FC_Gris';
                //>> ALGO20190529 -01 \ DSP:
                //>> ALGO20190323 \ DSP:
                //>> Reprise migration 20190625-DSP
            end;
        }
    }

    requestpage
    {
        savevalues = true;
    }

    var
        VG_TEST_BarCode: Text[30];
        FoundPos: integer;
        VGColor: text[25];
        VG_Item_Color: text[3];
        VG_Item_Color_Special5: text[5];
        BarCode: Codeunit Barcode;
        NoOfLoops: Integer;
        NoOfCopies: Integer;
        OutputNo: Integer;
}