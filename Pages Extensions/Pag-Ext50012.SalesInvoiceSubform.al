pageextension 50012 "Sales Invoice Subform" extends "Sales Invoice Subform"
{
    //p47
    layout
    {
        addafter("Line No.")
        {
            field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = ALL;
            }
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = ALL;
            }
            field(PO; Rec.PO)
            {
                ApplicationArea = ALL;
            }
            //>> ALGO 22062021
            field("Shipment No."; Rec."Shipment No.")
            {
                ApplicationArea = ALL;
            }
            field("Order No."; RecGOrderNo)
            {
                Caption = 'Commande Initiale';
                ApplicationArea = ALL;
                Editable = false;
            }
            //<< ALGO 22062021
        }
    }
    var
        FrmGReservQty: Page "Reservation Qty.";

        //>> ALGO 22062021

        RecGSalesShipmentLine: Record 111;
        RecGOrderNo: Code[20];

    trigger OnAfterGetRecord()
    begin
        RecGSalesShipmentLine.Reset();
        RecGSalesShipmentLine.SETFILTER(RecGSalesShipmentLine."Document No.", Rec."Shipment No.");
        RecGSalesShipmentLine.SetRange(RecGSalesShipmentLine."Line No.", Rec."Shipment Line No.");
        IF NOT RecGSalesShipmentLine.FindLast() THEN
            RecGOrderNo := ''
        else
            RecGOrderNo := RecGSalesShipmentLine."Order No.";
    end;
    //<< ALGO 22062021
}