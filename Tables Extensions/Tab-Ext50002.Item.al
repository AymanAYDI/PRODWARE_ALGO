tableextension 50002 "Item" extends Item
{
    //t27
    fields
    {
        field(50000; "Height (cm)"; Decimal)
        {
            Caption = 'Height(cm)';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                //>>FEPR002.001
                "Volume (cm3)" := "Height (cm)" * "Length (cm)" * "Width (cm)";
                //<<FEPR002.001
            end;
        }
        field(50001; "Length (cm)"; Decimal)
        {
            Caption = 'Length (cm)';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                //>>FEPR002.001
                "Volume (cm3)" := "Height (cm)" * "Length (cm)" * "Width (cm)";
                //<<FEPR002.001
            end;
        }
        field(50002; "Width (cm)"; Decimal)
        {
            Caption = 'Width (cm)';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                //>>FEPR002.001
                "Volume (cm3)" := "Height (cm)" * "Length (cm)" * "Width (cm)";
                //<<FEPR002.001
            end;
        }
        field(50003; "Weight (Net/Gross)"; Decimal)
        {
            Caption = 'Weight (Net/Gross)';
            DataClassification = CustomerContent;
        }
        field(50004; "Volume (cm3)"; Decimal)
        {
            Caption = 'Volume (cm3)';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50005; "Details / Fitting-out"; Text[50])
        {
            Caption = 'Details / Fitting-out';
            DataClassification = CustomerContent;
        }
        field(50006; "Details / Fitting-out 2"; Text[50])
        {
            Caption = 'Details / Fitting-out 2';
            DataClassification = CustomerContent;
        }
        field(50007; Linning; Option)
        {
            BlankNumbers = DontBlank;
            BlankZero = false;
            Caption = 'Linning';
            DataClassification = CustomerContent;
            OptionCaption = ' ,None,Cotton,Goatskin/Farmed Capra Hircus (origin : India),Satin,Velvet,CalfSkin /Vitulus, Lamb/Ovin,Cowskin /BosTaurus,Boxcalf /Bostaurus, Bullcalf /Bovinae,Cotton-Linen,Canvas: 60% Cotton-40% Linen';
            OptionMembers = " ","None",Cotton,"Goatskin/Farmed Capra Hircus (origin : India)",Satin,Velvet,"CalfSkin /Vitulus"," Lamb/Ovin","Cowskin /BosTaurus","Boxcalf /Bostaurus"," Bullcalf /Bovinae","Cotton-Linen","Canvas: 60% Cotton-40% Linen";
        }
        field(50008; Leather; Option)
        {
            Caption = 'LEATHER';
            DataClassification = CustomerContent;
            OptionCaption = ' ,None,Cowskin/BOS TAURUS,GoatSkin/Farmed Capra Hircus (origin : India),Calfskin /VITULUS,Bullcalf /BOVINAE,Boxcalf /BOSTAURUS,Lamb/ovin,POROSUS/Alligator,Canvas(60% cotton-40% Linen)+Cowskin/BOS TAURUS';
            OptionMembers = " ","None","Cowskin/BOS TAURUS","GoatSkin/Farmed Capra Hircus (origin : India)","Calfskin /VITULUS","Bullcalf /BOVINAE","Boxcalf /BOSTAURUS","Lamb/ovin","POROSUS/Alligator","Canvas(60% cotton-40% Linen)+Cowskin/BOS TAURUS";
        }
        field(50009; Composition; Option)
        {
            Caption = 'Ext. Composition';
            DataClassification = CustomerContent;
            OptionCaption = ' ,All leather,Canvas (32% Coating-40% Cotton-28% Linen), Canvas (59% Cotton-41% Polyamide), Canvas (100% Cotton), Crocodile /Crocodilus Porosus,Crocodile /Crocodilus Niloticus,Aligator/Alligator Mississipiensis, Lezardskin /Varanus Niloticus,Lezardskin /varanus Salvator,Ostrich/Strithio Camelus, Cowskin/BOS TAURUS, Calfskin/VITULUS, Bullcalf/BOVINAE, Boxcalf/BOSTAURUS, Brass + Nickel + Palladium,Cotton + Brass - Nickel - Palladium,Paper,Aluminium,Stainless, Wood,Cotton,Silk,Steel,Polypropylene,Polycarbonate,Zinc,Polyane,Cork + Salpa,Bronze and Brass,Bronze and Glass,µResin,Python,Polyester';
            OptionMembers = " ","All leather","Canvas (32% Coating-40% Cotton-28% Linen)"," Canvas (59% Cotton-41% Polyamide)"," Canvas (100% Cotton)"," Crocodile /Crocodilus Porosus","Crocodile /Crocodilus Niloticus","Aligator/Alligator Mississipiensis"," Lezardskin /Varanus Niloticus","Lezardskin /varanus Salvator","Ostrich/Strithio Camelus"," Cowskin/BOS TAURUS"," Calfskin/VITULUS"," Bullcalf/BOVINAE"," Boxcalf/BOSTAURUS"," Brass + Nickel + Palladium","Cotton + Brass - Nickel - Palladium",Paper,Aluminium,Stainless," Wood",Cotton,Silk,Steel,Polypropylene,Polycarbonate,Zinc,Polyane,"Cork + Salpa","Bronze and Brass","Bronze and Glass","µResin",Python,Polyester;
        }
        field(50010; "Closed type"; Option)
        {
            Caption = 'Closed Type';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Zipper,Buckle,Snap,None,Lock,Leather Tongue,Collar Button,Toad';
            OptionMembers = " ",Zipper,Buckle,Snap,"None",Lock,"Leather Tongue","Collar Button",Toad;
        }
        field(50011; "Function bag"; Option)
        {
            Caption = 'Function Bag';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Handbag,Travel bag,Cosmetic bag,Briefcase,Small leather good,Trunk,Dogs goods,Office Items,Accessory,Display,Packaging,Jewerly,Component,School';
            OptionMembers = " ",Handbag,"Travel bag","Cosmetic bag",Briefcase,"Small leather good",Trunk,"Dogs goods","Office Items",Accessory,Display,Packaging,Jewerly,Component,School;
        }
        field(50012; "Metal parts"; Option)
        {
            Caption = 'Metal Parts';
            DataClassification = CustomerContent;
            OptionCaption = 'None,Palladium,Gold,Silver';
            OptionMembers = "None",Palladium,Gold,Silver;
        }
        field(50014; "Freight Cost"; Decimal)
        {
            Caption = 'Freight Cost';
            DataClassification = CustomerContent;
        }
        field(50015; "Wood 1"; Option)
        {
            Caption = 'Wood 1';
            DataClassification = CustomerContent;
            OptionCaption = 'None,Beech/Fagus sylvatica (Made in France), Spruce/Picea Excelsa (Made in Sweden), Poplar/Populus Nigra(Made in France/CEE),Plywood/Aukoumea Klaineana (Made in Africa)';
            OptionMembers = "None","Beech/Fagus sylvatica (Made in France)"," Spruce/Picea Excelsa (Made in Sweden)"," Poplar/Populus Nigra(Made in France/CEE)","Plywood/Aukoumea Klaineana (Made in Africa)";
        }
        field(50016; "Wood 2"; Option)
        {
            Caption = 'Wood 2';
            DataClassification = CustomerContent;
            OptionCaption = 'None,Beech/Fagus sylvatica (Made in France), Spruce/Picea Excelsa (Made in Sweden), Poplar/Populus Nigra(Made in France/CEE),Plywood/Aukoumea Klaineana (Made in Africa)';
            OptionMembers = "None","Beech/Fagus sylvatica (Made in France)"," Spruce/Picea Excelsa (Made in Sweden)"," Poplar/Populus Nigra(Made in France/CEE)","Plywood/Aukoumea Klaineana (Made in Africa)";
        }
        field(50017; "Wood 1 Weight"; Text[10])
        {
            Caption = 'Wood 1 Weight';
            DataClassification = CustomerContent;
        }
        field(50018; "Wood 2 Weight"; Text[10])
        {
            Caption = 'Wood 2  Weight';
            DataClassification = CustomerContent;
        }
        field(50019; "Wood 3"; Option)
        {
            Caption = 'Wood 3';
            DataClassification = CustomerContent;
            OptionCaption = 'None,Beech/Fagus sylvatica (Made in France), Spruce/Picea Excelsa (Made in Sweden), Poplar/Populus Nigra(Made in France/CEE),Plywood/Aukoumea Klaineana (Made in Africa)';
            OptionMembers = "None","Beech/Fagus sylvatica (Made in France)"," Spruce/Picea Excelsa (Made in Sweden)"," Poplar/Populus Nigra(Made in France/CEE)","Plywood/Aukoumea Klaineana (Made in Africa)";
        }
        field(50020; "Wood 3 Weight"; Text[10])
        {
            Caption = 'Wood 3 Weight';
            DataClassification = CustomerContent;
        }
        field(50022; Model; Code[20])
        {
            Caption = 'Template';
            DataClassification = CustomerContent;
        }
        field(50023; "Certificate of Origin"; Text[100])
        {
            Caption = 'Certificate of Origin';
            DataClassification = CustomerContent;
        }
        field(50024; "Percentage Composition 1"; Decimal)
        {
            Caption = 'Percentage Composition';
            DataClassification = CustomerContent;
        }
        field(50025; "Percentage Composition 2"; Decimal)
        {
            Caption = 'Cmpounding % 2';
            DataClassification = CustomerContent;
        }
        field(50026; "Last Reception Date"; date)
        {
            FieldClass = FlowField;
            CalcFormula = Max("Item Ledger Entry"."Posting Date" where("Item No." = FIELD("No."),
                                                                   "Entry Type" = CONST("Positive Adjmt.")));
            Editable = false;
        }
        field(50031; "BarCode EAN13"; Text[13])
        {
            Caption = 'Code barre EAN13';
            DataClassification = CustomerContent;
        }
        field(50032; "Customer Item No."; Text[18])
        {
            Caption = 'Référence Client';
            DataClassification = CustomerContent;
        }
        field(50033; "Life Cycle"; Option)
        {
            Caption = 'Cycle de vie';
            DataClassification = CustomerContent;
            OptionMembers = ,Active,ALAS,Dead,"Make to Order",NOORDER,"Special order",NOVELTIESHQ,"Reedition",Developpement;
        }
        field(50034; "Procurement Cycle"; Option)
        {
            Caption = 'Cycle d''appro';
            DataClassification = CustomerContent;
            OptionMembers = ,"Best seller","Good seller","Slow mover","Cde spe",Purchase;
            OptionCaption = ' ,Best seller,Good seller,Slow mover,Cde Spe,Achat', Locked = true;
        }
        field(50035; "Model Size"; Code[20])
        {
            Caption = 'Modèle Taille', locked = true;
            DataClassification = CustomerContent;
        }
        field(50036; "Item Family"; Option)
        {
            Caption = 'Famille d''article';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Accessories,Trunk,Travel Bags,Office,Belts,Pets,Leather goods,Small leather goods,Textile';
            OptionMembers = " ",Accessories,Trunk,"Travel Bags",Office,Belts,Pets,"Leather goods","Small leather goods",Textile;
        }
        field(50056; "Qty on Transfer Line"; Decimal)
        {
            Caption = 'Qty on Transfer Line';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Transfer Line"."Outstanding Qty. (Base)"
                        where("Item No." = field("No."),
                        "Transfer-from Code" = field("Location Filter"),
                        "Derived From Line No." = filter(0)));
        }

        field(50057; "Collection"; Text[100])
        {
            Caption = 'Collection';
            DataClassification = CustomerContent;
        }

        field(50058; "Raw item"; Boolean)
        {
            Caption = 'Raw Item';
            Editable = true;
            DataClassification = CustomerContent;
        }

        field(50059; "Raw material family"; Option)
        {
            Caption = 'Raw material family';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Leather,Canvas,Jewelry,Packaging,Wood';
            OptionMembers = " ",Leather,Canvas,Jewelry,Packaging,Wood;
        }
        Field(50060; "Customer"; Option)
        {
            Caption = 'Customer Code';
            DataClassification = CustomerContent;
            OptionCaption = ' ,GOYARD,LUNIFORM';
            OptionMembers = " ",GOYARD,LUNIFORM;
        }
    }
}
