pageextension 50088 "Posted Transfer Shipments" extends "Posted Transfer Shipments"
{
    layout
    {
        addafter("Receipt Date")
        {
            field("Transfer Order No."; Rec."Transfer Order No.")
            {

            }
        }
    }
}