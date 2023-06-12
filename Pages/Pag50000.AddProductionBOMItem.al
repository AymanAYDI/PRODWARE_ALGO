page 50000 "Add Production BOM Item"
{
    // version ALG.1.0.0.0,MIG2009R2

    //    ------------------------------------------------------
    //    Prodware-www.prodware.fr
    //    ------------------------------------------------------
    //    //>> ALG.1.0.0.0
    //    FEPRO010.001:DSFT 15/12/2006:Create Form To Permit Add New Item To BOOM
    //                                 - This Form Permit Adding a new Item To a Group Of Boom With
    //                                   Criteria caracter

    Caption = 'Add Production BOM Item';
    PageType = Card;

    layout
    {
        area(content)
        {
            group(Option)
            {
                Caption = 'Option';
                field(Text19016853; '')
                {
                    CaptionClass = Text19016853;
                    ApplicationArea = All;
                }
                field(Text19052420; '')
                {
                    CaptionClass = Text19052420;
                    ApplicationArea = All;
                }
                field(TpeGType1; TpeGType[1])
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                    Enabled = false;
                    OptionCaption = ' ,Item,Production BOM';

                    trigger OnValidate()
                    begin
                        //>>FEPRO010.001

                        CodGNo[1] := '';

                        //<<FEPRO010.001
                    end;
                }
                field(CodGNo1; CodGNo[1])
                {
                    ApplicationArea = All;
                    Caption = 'No.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        //>>FEPRO010.001

                        IF PAGE.RUNMODAL(0, RecGItem) = ACTION::LookupOK THEN BEGIN
                            Text := RecGItem."No.";
                            EXIT(TRUE);
                        END;

                        //<<FEPRO010.001
                    end;

                    trigger OnValidate()
                    begin
                        RecGItem.GET(CodGNo[1]);
                    end;
                }
                field(Text19013224; '')
                {
                    ApplicationArea = All;
                    CaptionClass = Text19013224;
                }
                field(Text19080001; '')
                {
                    ApplicationArea = All;
                    CaptionClass = Text19080001;
                }
                field(TpeGType2; TpeGType[2])
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                    Enabled = false;
                    OptionCaption = ' ,Item,Production BOM';

                    trigger OnValidate()
                    begin
                        //>>FEPRO010.001

                        CodGNo[2] := '';

                        //>>FEPRO010.001
                    end;
                }
                field(CodGNo2; CodGNo[2])
                {
                    ApplicationArea = All;
                    Caption = 'No.';
                    Enabled = true;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        //>>FEPRO010.001

                        IF PAGE.RUNMODAL(0, RecGProdBOMHeader) = ACTION::LookupOK THEN BEGIN
                            Text := RecGProdBOMHeader."No.";
                            EXIT(TRUE);
                        END;

                        //<<FEPRO010.001}
                    end;
                }
                field("Create New Version"; BlnGCreateNewVersion)
                {
                    ApplicationArea = All;
                    Caption = 'Create New Version';
                }
                field(DecGQtyMultiply; DecGQtyMultiply)
                {
                    ApplicationArea = All;
                    Caption = 'Multiply Qty. with';
                    DecimalPlaces = 0 : 5;
                }
                field(DatGStartingDate; DatGStartingDate)
                {
                    ApplicationArea = All;
                    Caption = 'Starting Date';
                }
                field(BlnGRecertify; BlnGRecertify)
                {
                    ApplicationArea = All;
                    Caption = 'Recertify';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(ALGO)
            {
                Caption = 'ALGO', Locked = true;
                Image = Customer;
                action(OK)
                {
                    Caption = 'OK';
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        //>>FEPRO010.001
                        IF DatGStartingDate = 0D THEN ERROR(CstG000);
                        IF TpeGType[1] = TpeGType[1] ::" " THEN ERROR(CstG001);
                        IF CodGNo[1] = '' THEN ERROR(CstG002);
                        IF CodGNo[2] = '' THEN ERROR(CstG002);
                        RecGProdBOMHeader.RESET();
                        RecGProdBOMLine.RESET();
                        RecGItem.GET(CodGNo[1]);
                        RecGProdBOMHeader.SETFILTER("No.", CodGNo[2]);
                        IF RecGProdBOMHeader.FIND('-') THEN
                            REPEAT
                                IF NOT BlnGCreateNewVersion THEN
                                    GNotNewVersion()
                                ELSE
                                    GNewVersion();

                                IF BlnGRecertify THEN GRevalider();
                            UNTIL RecGProdBOMHeader.Next() = 0;
                        RecGProdBOMHeader.RESET();
                        MESSAGE(CstG010);

                        //<<FEPRO010.001
                    end;
                }
            }

        }
    }

    trigger OnInit()
    begin
        //>>FEPRO010.001

        BlnGRecertify := TRUE;
        TpeGType[1] := 1;
        TpeGType[2] := 2;
        BlnGCreateNewVersion := TRUE;
        DecGQtyMultiply := 1;
        DatGStartingDate := WORKDATE();

        //<<FEPRO010.001
    end;

    var
        RecGItem: Record Item;
        RecGProdBOMHeader: Record "Production BOM Header";
        RecGProdBOMVersionList: Record "Production BOM Version";
        RecGProdBOMLine: Record "Production BOM Line";
        RecGProdBOMLine2: Record "Production BOM Line";
        RecGProdBOMLine3: Record "Production BOM Line";
        "RecGProductionBOM-Copy": Codeunit "Production BOM-Copy";
        DlgGWindow: Dialog;
        TpeGType: array[2] of Option " ",Item,"Production BOM";
        CodGNo: array[2] of Code[20];
        DecGQtyMultiply: Decimal;
        BlnGCreateNewVersion: Boolean;
        DatGStartingDate: Date;
        BlnGRecertify: Boolean;
        CstG000: Label 'You must enter a Starting Date.';
        CstG001: Label 'You must enter the Type to Add.';
        CstG002: Label 'You must enter the No. to Add.';
        CstG003: Label 'You cannot Add  The Item N° %1 To The Boom N°  %2 Because Its Used ';
        CstG004: Label 'Exchanging #1########## #2############\';
        CstG005: Label 'Production BOM No.      #3############';
        CstG006: Label 'Type must be entered.';
        CstG007: Label ' ,Item,Production BOM';
        CstG008: Label 'You must enter the No. Of BOOM to Add.';
        CstG009: Label 'You must enter the No. Of BOOM to Add.';
        CstG010: Label 'BOOM Added With Succees';
        Text19016853: Label 'Add';
        Text19052420: Label 'Type';
        Text19013224: Label 'In BOOM';
        Text19080001: Label 'Type';

    procedure "---FEPRR010---"()
    begin
    end;

    procedure GRevalider()
    begin
        //>>FEPRO010.001

        RecGProdBOMHeader.VALIDATE(Status, RecGProdBOMHeader.Status::Certified);
        RecGProdBOMHeader.MODIFY();
        RecGProdBOMVersionList.RESET();
        RecGProdBOMVersionList.SETRANGE("Production BOM No.", RecGProdBOMHeader."No.");
        IF RecGProdBOMVersionList.FINDSET() THEN
            REPEAT
                RecGProdBOMVersionList.VALIDATE(Status, RecGProdBOMVersionList.Status::Certified);
                RecGProdBOMVersionList.MODIFY();
            UNTIL RecGProdBOMVersionList.NEXT() = 0;

        //<<FEPRO010.001
    end;

    procedure GNotNewVersion()
    var
        IntLNumLin: Integer;
    begin
        //>>FEPRO010.001

        RecGProdBOMLine2.RESET();
        RecGProdBOMLine2.SETRANGE("Production BOM No.", RecGProdBOMHeader."No.");
        RecGProdBOMLine2.SETRANGE(RecGProdBOMLine2."Version Code", '');
        IntLNumLin := 10000;
        IF RecGProdBOMLine2.FIND('+') THEN IntLNumLin := RecGProdBOMLine2."Line No." + 10000;
        RecGProdBOMLine2.INIT();
        RecGProdBOMLine."Production BOM No." := RecGProdBOMHeader."No.";
        RecGProdBOMLine."No." := CodGNo[1];
        RecGProdBOMLine."Version Code" := '';
        RecGProdBOMLine."Line No." := IntLNumLin;
        RecGProdBOMLine.Type := RecGProdBOMLine.Type::Item;
        RecGProdBOMLine.Description := RecGItem.Description;
        RecGProdBOMLine."Unit of Measure Code" := RecGProdBOMHeader."Unit of Measure Code";
        RecGProdBOMLine.Quantity := 1;
        RecGProdBOMLine."Quantity per" := DecGQtyMultiply;
        RecGProdBOMLine."Starting Date" := DatGStartingDate;
        RecGProdBOMLine.Length := RecGItem."Length (cm)";
        RecGProdBOMLine.Width := RecGItem."Width (cm)";
        RecGProdBOMLine.Weight := RecGItem."Weight (Net/Gross)";
        RecGProdBOMLine.Depth := RecGItem."Volume (cm3)";
        RecGProdBOMLine3.RESET();
        RecGProdBOMLine3.SETRANGE(Type, RecGProdBOMLine.Type::Item);
        RecGProdBOMLine3.SETRANGE("No.", CodGNo[1]);
        RecGProdBOMLine3.SETRANGE(RecGProdBOMLine3."Version Code", '');
        RecGProdBOMLine3.SETRANGE("Production BOM No.", RecGProdBOMHeader."No.");
        IF NOT RecGProdBOMLine3.FIND('-') THEN
            RecGProdBOMLine.INSERT();


        //<<FEPRO010.001
    end;

    procedure GNewVersion()
    var
        CduLNoSeriesMgt: Codeunit NoSeriesManagement;
        IntLNumLin: Integer;
    begin

        //>>FEPRO010.001


        IF RecGProdBOMHeader."Version Nos." = '' THEN ERROR(CstG009, RecGProdBOMHeader."No.");
        RecGProdBOMVersionList.RESET();
        RecGProdBOMVersionList.INIT();
        RecGProdBOMVersionList."Production BOM No." := RecGProdBOMHeader."No.";
        RecGProdBOMVersionList."No. Series" := RecGProdBOMHeader."Version Nos.";
        RecGProdBOMVersionList."Version Code" := '';
        RecGProdBOMVersionList.Description := '';
        RecGProdBOMVersionList."Unit of Measure Code" := RecGProdBOMHeader."Unit of Measure Code";
        RecGProdBOMVersionList."Starting Date" := DatGStartingDate;
        CduLNoSeriesMgt.InitSeries(RecGProdBOMHeader."Version Nos.", RecGProdBOMHeader."No. Series", 0D,
                                   RecGProdBOMVersionList."Version Code", RecGProdBOMVersionList."No. Series");
        RecGProdBOMVersionList.Status := RecGProdBOMVersionList.Status::"Under Development";
        RecGProdBOMVersionList.INSERT();
        COMMIT();
        "RecGProductionBOM-Copy".CopyBOM(RecGProdBOMHeader."No.", '', RecGProdBOMHeader, RecGProdBOMVersionList."Version Code");
        RecGProdBOMLine2.RESET();
        RecGProdBOMLine2.SETRANGE("Production BOM No.", RecGProdBOMHeader."No.");
        RecGProdBOMLine2.SETRANGE(RecGProdBOMLine2."Version Code", '');
        IntLNumLin := 10000;
        IF RecGProdBOMLine2.FIND('+') THEN IntLNumLin := RecGProdBOMLine2."Line No." + 10000;
        RecGProdBOMLine.INIT();
        RecGProdBOMLine."Production BOM No." := RecGProdBOMHeader."No.";
        RecGProdBOMLine."No." := CodGNo[1];
        RecGProdBOMLine."Version Code" := RecGProdBOMVersionList."Version Code";
        RecGProdBOMLine."Line No." := IntLNumLin;
        RecGProdBOMLine.Type := RecGProdBOMLine.Type::Item;
        RecGProdBOMLine.Description := RecGItem.Description;
        RecGProdBOMLine."Unit of Measure Code" := RecGProdBOMHeader."Unit of Measure Code";
        RecGProdBOMLine.Quantity := 1;
        RecGProdBOMLine."Quantity per" := DecGQtyMultiply;
        RecGProdBOMLine."Starting Date" := DatGStartingDate;
        RecGProdBOMLine.Length := RecGItem."Length (cm)";
        RecGProdBOMLine.Width := RecGItem."Width (cm)";
        RecGProdBOMLine.Weight := RecGItem."Weight (Net/Gross)";
        RecGProdBOMLine.Depth := RecGItem."Volume (cm3)";
        RecGProdBOMLine3.RESET();
        RecGProdBOMLine3.SETRANGE(Type, RecGProdBOMLine.Type::Item);
        RecGProdBOMLine3.SETRANGE("No.", CodGNo[1]);
        RecGProdBOMLine3.SETRANGE(RecGProdBOMLine3."Version Code", '');
        RecGProdBOMLine3.SETRANGE("Production BOM No.", RecGProdBOMHeader."No.");
        RecGProdBOMLine.INSERT();


        //<<FEPRO010.001
    end;
}

