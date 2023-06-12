pageextension 50075 "Warehouse Shipment" extends "Warehouse Shipment"
{
    //p7335
    layout
    {
        addafter(Shipping)
        {
            group(ALGO)
            {
                field("Picking List Exported"; Rec."Picking List Exported")
                {
                    ApplicationArea = ALL;
                }
            }
        }
    }

    actions
    {
        modify("Use Filters to Get Src. Docs.")
        {
            Visible = false;
        }

        addafter("&Shipment")
        {
            group(ALGO_)
            {
                Caption = 'ALGO', locked = true;
                Image = Customer;
                action("Mettre … jour PO2")
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = AdjustItemCost;
                    PromotedCategory = Process;

                    Caption = 'Mettre … jour PO2';

                    trigger OnAction()
                    VAR
                        RecLLines: Record "Warehouse Shipment Line";
                    BEGIN
                        RecLLines.SETRANGE("No.", Rec."No.");
                        IF RecLLines.FINDSET(TRUE, FALSE) THEN
                            REPEAT
                                RecLLines.CALCFIELDS(PO);
                                RecLLines.PO2 := RecLLines.PO;
                                RecLLines.MODIFY();
                            UNTIL RecLLines.NEXT() = 0;
                    END;
                }
                action("Information Colisage")
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    Image = Shipment;
                    PromotedCategory = Process;

                    Caption = 'Information Colisage';

                    RunObject = Page "Information Colisage";
                    RunpageView = SORTING("Parcel No.")
                                  ORDER(Ascending);
                    RunpageLink = "Shipment Document No." = FIELD("No.");
                }
                action("Filtrer pour extr. doc. orig. ALGO")
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Use Filters to Get Src. Docs.';
                    Ellipsis = true;
                    Image = UseFilters;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        WhseGetSourceFilterRec: Record "Warehouse Source Filter";
                        WhseSourceFilterSelection: Page "Filters to Get Source Docs.-A";
                    begin

                        WhseSourceFilterSelection.SetOneCreatedShptHeader(Rec);
                        WhseGetSourceFilterRec.FILTERGROUP(2);
                        WhseGetSourceFilterRec.SETRANGE(Type, WhseGetSourceFilterRec.Type::Outbound);
                        WhseGetSourceFilterRec.FILTERGROUP(0);
                        WhseSourceFilterSelection.SETTABLEVIEW(WhseGetSourceFilterRec);
                        WhseSourceFilterSelection.RUNMODAL();

                        Rec."Document Status" := rec.GetDocumentStatus(0);
                        Rec.Modify();
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.OpenWhseShptHeader(Rec);
    end;
}
