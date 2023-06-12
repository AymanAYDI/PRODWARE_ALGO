pageextension 50085 "Warehouse Receipt" extends "Warehouse Receipt" //MyTargetPageId
{
    actions
    {
        addafter("F&unctions")
        {
            group(ALGO)
            {
                Caption = 'ALGO', Locked = true;

                action("Filtrer pour extr. doc. orig. 2")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Filtrer pour extr. doc. orig.', Locked = true;
                    Ellipsis = true;
                    Image = UseFilters;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        WhseGetSourceFilterRec: Record "Warehouse Source Filter";
                        WhseSourceFilterSelection: Page "Filters to Get Source Docs.-A";
                    begin
                        WhseSourceFilterSelection.SetOneCreatedReceiptHeader(Rec);
                        WhseGetSourceFilterRec.FILTERGROUP(2);
                        WhseGetSourceFilterRec.SETRANGE(Type, WhseGetSourceFilterRec.Type::Inbound);
                        WhseGetSourceFilterRec.FILTERGROUP(0);
                        WhseSourceFilterSelection.SETTABLEVIEW(WhseGetSourceFilterRec);
                        WhseSourceFilterSelection.RUNMODAL();

                        Rec."Document Status" := Rec.GetHeaderStatus(0);
                        Rec.Modify();

                    end;
                }
            }
        }
    }
}