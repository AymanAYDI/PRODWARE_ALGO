tableextension 50006 "Purchase Header" extends "Purchase Header"
{
    //t38
    fields
    {
        field(50011; "Vdoc Control No."; Text[50])
        {
            Caption = 'VDOC N°Controle';
            DataClassification = CustomerContent;
            Description = 'N° de contrôle VDOC - Cette donnée est importée de l''application VDOC';
        }
        field(50016; "Development Order"; Boolean)
        {
            Caption = 'Commande Développement';
            DataClassification = CustomerContent;
        }

        modify("Vendor Shipment No.")
        {
            trigger OnAfterValidate()
            begin
                if CompanyName() = 'ALGO PROD' then
                    if ("Posting Date") <> TODAY() then
                        if "Document Type" = "Document Type"::Order then begin
                            Validate("Posting Date", Today());
                            Modify();
                        end;
            end;
        }
    }
}
