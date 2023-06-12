pageextension 50029 "Item Reclass. Journal" extends "Item Reclass. Journal"
{
    //p393
    layout
    {
        addafter("Reason Code")
        {
            field("Return Reason Code"; Rec."Return Reason Code")
            {
                ApplicationArea = ALL;
            }
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = ALL;
            }
        }
    }
    actions
    {
        addafter("&Print")
        {
            group(ALGO_)
            {
                Caption = 'ALGO', locked = true;
                Image = Customer;
                action("VDOC - Importation du Reclassement")
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Image = Journal;

                    Caption = 'VDOC - Importation du Reclassement';

                    RunObject = XMLport "Vdoc - Import Reclassement";
                }
                action("Importer lignes Scannette")
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Image = Inventory;

                    Caption = 'Importer lignes Scannette';

                    //RunObject = XMLport "Import Reclassification SCAN";
                    trigger OnAction()
                    var
                        XImportReclaScan: XmlPort "Import Reclassification SCAN";
                    begin
                        XImportReclaScan.Run();
                        CurrPage.Update(true);
                    end;
                }
            }
        }
    }
}
