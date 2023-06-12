pageextension 50032 "Posted Sales Shipment" extends "Posted Sales Shipment"
{
    //p130
    layout
    {
        addafter(Billing)
        {
            group(ALGO)
            {
                Caption = 'ALGO', locked = true;
                field("Packing Exported"; Rec."Packing Exported")
                {
                    ApplicationArea = ALL;
                }
            }
        }
    }
    actions
    {
        addafter("&Navigate")
        {
            group(ALGO_)
            {
                Caption = 'ALGO', locked = true;
                Image = Customer;
                action("Export Packing List")
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Image = Export;

                    Caption = 'Export Packing List';

                    trigger OnAction()
                    VAR
                        CuLExportPackingList: Codeunit "Export Packing List";
                    BEGIN
                        CuLExportPackingList.Export(Rec);
                    END;
                }
            }
        }
    }
}
