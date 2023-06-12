pageextension 50035 "Posted Sales Shipment Lines" extends "Posted Sales Shipment Lines"
{
    //p525
    layout
    {
        addafter("Quantity Invoiced")
        {
            field("Qty. Shipped Not Invoiced"; Rec."Qty. Shipped Not Invoiced")
            {
                ApplicationArea = ALL;
            }
            field(PO; Rec.PO)
            {
                ApplicationArea = ALL;
            }
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = ALL;
            }

            // GLPI6173-JSTOUMEN
            field("Requested Delivery Date"; Rec."Requested Delivery Date")
            {
                ApplicationArea = ALL;
            }
            // GLPI6173-JSTOUMEN
        }
    }
}
