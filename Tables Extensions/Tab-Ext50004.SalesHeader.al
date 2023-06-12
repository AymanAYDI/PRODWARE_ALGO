tableextension 50004 "Sales Header" extends "Sales Header"
{
    // #WMS20200221 - WMS - LOT 3 ###################################
    //t36
    fields
    {
        field(50000; PO; Code[20])
        {
            Caption = 'PO';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                SalesLine: Record "Sales Line";
            begin
                //>>FEVT003.001
                TestField(Status, Status::Open);
                IF (xRec.PO <> PO) THEN begin
                    SalesLine.SetRange("Document Type", "Document Type");
                    SalesLine.SetRange("Document No.", "No.");
                    SalesLine.ModifyAll(PO, PO, false);
                end;
                //<<FEVT003.001
            end;
        }
        field(50001; PROFORMA; Boolean)
        {
            Caption = 'PROFORMA';
            DataClassification = CustomerContent;
        }
        field(50002; "Packing Number"; Code[20])
        {
            Caption = 'Packing Number';
            DataClassification = CustomerContent;
        }

        // #WMS20200221 - WMS - LOT 3 ###################################
        field(50010; "NON_WMS"; Boolean)
        {
            Caption = 'NON_WMS', locked = true;
            DataClassification = CustomerContent;
        }
        field(50011; "TRANSFERER_VERS_WMS"; Boolean)
        {
            Caption = 'TRANSFERER_VERS_WMS', locked = true;
            DataClassification = CustomerContent;
        }
    }
}