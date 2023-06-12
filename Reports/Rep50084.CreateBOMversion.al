report 50084 "Create BOM version"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Create BOM version';
    UsageCategory = Administration;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Production BOM Header"; "Production BOM Header")
        {
            DataItemTableView = SORTING("No.") ORDER(Ascending);
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            var
                ProductionBOLine: Record "Production BOM Line";
            begin

                IF NoVersion = '' THEN
                    ERROR(TxtG001);

                //skip if version already exists!
                IF RecGBOMVersion.GET("No.", NoVersion) THEN
                    CurrReport.SKIP;

                //create BOM version
                RecGBOMVersion.RESET();
                RecGBOMVersion.INIT();
                RecGBOMVersion.VALIDATE("Production BOM No.", "No.");
                RecGBOMVersion.VALIDATE("Version Code", NoVersion);
                RecGBOMVersion.VALIDATE("Starting Date", WORKDATE());
                RecGBOMVersion.VALIDATE("Unit of Measure Code", "Unit of Measure Code");
                RecGBOMVersion.INSERT();

                ProductionBOMCopy.CopyBOM(RecGBOMVersion."Production BOM No.", '', "Production BOM Header", RecGBOMVersion."Version Code");

                //Remove obsolete BOM Line
                IF BooGNoOslolete THEN begin
                    ProductionBOLine.Setrange("No.", "No.");
                    ProductionBOLine.Setrange("Version Code", NoVersion);
                    ProductionBOLine.SetFilter("Ending Date", '<>%1', 0D);
                    ProductionBOLine.DeleteAll();
                end;


                IF BooGValidate THEN BEGIN
                    RecGBOMVersion.VALIDATE(Status, RecGBOMVersion.Status::Certified);
                    RecGBOMVersion.MODIFY(TRUE);
                END;

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
                    field(NoOfVersion; NoVersion)
                    {
                        ApplicationArea = ALL;
                        Caption = 'Version No.';
                    }
                    field(RemoveObsolete; BooGNoOslolete)
                    {
                        ApplicationArea = ALL;
                        Caption = 'Remove obsolete lines';
                    }
                    field(ValidateBOM; BooGValidate)
                    {
                        ApplicationArea = ALL;
                        Caption = 'Validate BOM version';
                    }
                }
            }
        }
    }


    var
        NoVersion: Code[10];
        RecGBOMVersion: Record "Production BOM Version";
        ProductionBOMCopy: Codeunit "Production BOM-Copy";
        BooGNoOslolete: Boolean;
        BooGValidate: Boolean;
        TxtG001: Label 'N° de version ne peut être vide';
}