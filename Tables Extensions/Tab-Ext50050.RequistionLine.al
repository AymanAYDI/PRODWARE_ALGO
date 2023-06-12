tableextension 50050 "Requisition Line" extends "Requisition Line"
{
    //t124
    fields
    {
        field(50000; "Type Order Planning"; Option)
        {
            BlankNumbers = DontBlank;
            BlankZero = false;
            Caption = 'Type Ordre Planning';
            DataClassification = CustomerContent;
            InitValue = "Ferme";

            OptionMembers = "Ferme","Previsionnel";
            OptionCaption = 'Ferme, Previsionnel', Locked = true;
        }

    }

}