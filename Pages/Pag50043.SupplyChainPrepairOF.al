page 50043 "SupplyChain - Prepair OF"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Item;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Inventory; Rec.Inventory)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Qty. on Sales Order"; Rec."Qty. on Sales Order")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Qty. on Purch. Order"; Rec."Qty. on Purch. Order")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Qty. on Prod. Order"; Rec."Qty. on Prod. Order")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(VG_OF_A_LANCER; VG_OF_A_LANCER)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'OF A Lancer', Locked = true;
                    Editable = false;
                }
                field(VG_QuCA_CDEV; VG_QuCA_CDEV)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Qu. sur CA (Cde DEV)', Locked = true;
                    Editable = false;
                }
                field(VG_OF_A_LANCER_CDEV_Inc; VG_OF_A_LANCER_CDEV_Inc)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'OF A LANCER (hors Cde DEV)', Locked = true;
                    Editable = false;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin

        // Récupération des Qty CA de type Commande Spéciale dans Purchase Line

        RecGPurchaseLine.RESET();
        VG_QuCA_CDEV := 0;
        VG_OF_A_LANCER := 0;
        VG_OF_A_LANCER_CDEV_Inc := 0;

        RecGPurchaseLine.SETFILTER(RecGPurchaseLine."Document Type", '%1', RecGPurchaseLine."Document Type"::Order);
        RecGPurchaseLine.SETFILTER(RecGPurchaseLine.Type, '%1', RecGPurchaseLine.Type::Item);
        RecGPurchaseLine.SETFILTER(RecGPurchaseLine."No.", Rec."No.");
        RecGPurchaseLine.SETFILTER(RecGPurchaseLine."Development Order", '%1', TRUE);

        IF RecGPurchaseLine.FINDSET() THEN
            REPEAT
                VG_QuCA_CDEV := VG_QuCA_CDEV + RecGPurchaseLine."Outstanding Qty. (Base)";
            UNTIL RecGPurchaseLine.NEXT() = 0;

        VG_OF_A_LANCER := Rec."Qty. on Sales Order" - (Rec.Inventory) - Rec."Qty. on Prod. Order" - Rec."Qty. on Purch. Order";
        VG_OF_A_LANCER_CDEV_Inc := Rec."Qty. on Sales Order" - (Rec.Inventory) - Rec."Qty. on Prod. Order" - (Rec."Qty. on Purch. Order" - VG_QuCA_CDEV);
    end;

    var
        RecGPurchaseLine: Record "Purchase Line";
        VG_QuCA_CDEV: Decimal;
        VG_OF_A_LANCER: Decimal;
        VG_OF_A_LANCER_CDEV_Inc: Decimal;
}

