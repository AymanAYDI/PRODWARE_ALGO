tableextension 50001 "Vendor" extends Vendor
{
    //t23
    fields
    {
        field(50000; "Vendor Class"; Option)
        {
            Caption = 'Type Fournisseur';
            OptionCaption = ',Honoraries,Raw materials Manufacturer,End Product Manufacturer,raw materials,End Products,Packaging,Studies,Recipient';
            OptionMembers = ,Honoraires,"ST MP","ST PF",MP,PF,Emballages,Etudes,Prestataire;
            DataClassification = CustomerContent;
        }
        field(50001; "GED Class"; Option)
        {
            Caption = 'Type GED';
            OptionCaption = ' ,PF,MP,FG Info.,FG Stock,FG,FG Malleterie,FG Dev,FG Stock2 (Pierre),FG Ressources humaines,FG Securite,PF L/UNIFORM,FG La Manufacture,MP La Manufacture';
            OptionMembers = ,PF,MP,"FG Info.","FG Stock",FG,"FG Malleterie","FG Dev","FG Stock2 (Pierre)","FG Ressources humaines","FG Securite","PF L/UNIFORM","FG La Manufacture","MP La Manufacture";
            DataClassification = CustomerContent;
        }

    }
}
