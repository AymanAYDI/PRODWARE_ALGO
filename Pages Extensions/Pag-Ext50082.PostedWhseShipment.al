pageextension 50082 "Posted Whse. Shipment" extends "Posted Whse. Shipment"
{
    //p7337
    actions
    {
        addafter("&Shipment")
        {
            group(ALGO)
            {
                Caption = 'ALGO', Locked = true;
                Image = Customer;
                action(PrintPROFORMA)
                {
                    Caption = 'Print Proforma';
                    Image = Invoice;
                    Promoted = true;

                    trigger OnAction()
                    var
                        RecLPosteWhseShipment: Record "Posted Whse. Shipment Header";

                    begin
                        RecLPosteWhseShipment.SETRANGE("No.", Rec."No.");
                        IF RecLPosteWhseShipment.FINDSET() THEN
                            REPORT.RUNMODAL(REPORT::"Posted Shipment PROFORMA", TRUE, TRUE, RecLPosteWhseShipment);
                    end;

                }
                action(PrintPacking)
                {
                    Caption = 'Print Packing';
                    Image = Shipment;
                    Promoted = true;
                    trigger OnAction()
                    var
                        RecLPosteWhseShipment: Record "Posted Whse. Shipment Header";
                    begin
                        RecLPosteWhseShipment.SETRANGE("No.", Rec."No.");
                        IF RecLPosteWhseShipment.FINDSET() THEN
                            REPORT.RUNMODAL(REPORT::"Posted Shipment PACKING", TRUE, TRUE, RecLPosteWhseShipment);
                    end;

                }
            }
        }
    }
}