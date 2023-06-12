pageextension 50103 "Planning Worksheet" extends "Planning Worksheet"
{
    //p99000852

    // DSP : Dev sur la feuille planning pour DSCP - 202301-202303


    layout
    {
        addafter("Accept Action Message")
        {
            field("Type Order Planning"; Rec."Type Order Planning")
            {
                ApplicationArea = ALL;
            }
            field("Untracked Quantity"; "QuantiteNonChainee")
            {
                ApplicationArea = ALL;
                Enabled = False;
                caption = 'Qté non chainée';
                ToolTip = 'Untracked Quantity / Quantité Non Chainée / Effet d''avance';
            }
        }
    }


    actions
    {
        addafter("Get &Action Messages")
        {
            action("Export Previsionnel")
            {
                Caption = 'Export Previsionnel', Locked = true;
                Image = Excel;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                visible = True;

                trigger OnAction()
                var
                    RecGRequisitionLine: Record "Requisition Line";
                    RecBCKRequisitionLine: Record "Backup Requisition Line";
                    RecUntrackedPlanningElement: Record "Untracked Planning Element";
                    CompanyInfo: Record "Company Information";
                    TempCSVBuffer: Record "CSV Buffer" temporary;
                    LineNo: Integer;
                    FileName: Text[250];
                    timeText: text[250];
                    myTime: Time;
                    numsequence: integer;

                begin
                    CompanyInfo.Get();
                    CompanyInfo.TestField("Export Planificiation Path");

                    // Export des lignes PREVISIONNEL
                    RecGRequisitionLine.setfilter("Worksheet Template Name", 'PLANNING');
                    RecGRequisitionLine.setfilter("Journal Batch Name", 'DEFAUT');
                    RecGRequisitionLine.SETFILTER(RecGRequisitionLine."type order planning", ' Previsionnel');
                    RecGRequisitionLine.SETRANGE(RecGRequisitionLine."Ref. Order Type", RecGRequisitionLine."Ref. Order Type"::Purchase);
                    RecGRequisitionLine.SETRANGE(RecGRequisitionLine."Action Message", RecGRequisitionLine."Action Message"::New);

                    // Export CSV
                    LineNo := 1;
                    TempCSVBuffer.InsertEntry(LineNo, 1, 'WorkSheet Name');
                    TempCSVBuffer.InsertEntry(LineNo, 2, 'Journal Batch Name');
                    TempCSVBuffer.InsertEntry(LineNo, 3, 'No');
                    TempCSVBuffer.InsertEntry(LineNo, 4, 'Societe');
                    TempCSVBuffer.InsertEntry(LineNo, 5, 'Vendor No.');
                    TempCSVBuffer.InsertEntry(LineNo, 6, 'RefOrderType');
                    TempCSVBuffer.InsertEntry(LineNo, 7, 'TypeorderPlanning');
                    TempCSVBuffer.InsertEntry(LineNo, 8, 'Due Date');
                    TempCSVBuffer.InsertEntry(LineNo, 9, 'Demand Date');
                    TempCSVBuffer.InsertEntry(LineNo, 10, 'Prod Posting Group');
                    TempCSVBuffer.InsertEntry(LineNo, 11, 'Unite');
                    TempCSVBuffer.InsertEntry(LineNo, 12, 'quantity');
                    TempCSVBuffer.InsertEntry(LineNo, 13, 'Effet Avance');
                    TempCSVBuffer.InsertEntry(LineNo, 14, 'Replenshiment Planning');
                    TempCSVBuffer.InsertEntry(LineNo, 15, 'user id');
                    TempCSVBuffer.InsertEntry(LineNo, 16, 'dateheure');
                    if RecGRequisitionLine.FindSet() then
                        repeat

                            // On va alimenter la variable QuantiteNonChainee --> Effet d'avance
                            RecUntrackedPlanningElement.Reset();
                            RecUntrackedPlanningElement.SETRANGE(RecUntrackedPlanningElement."Worksheet Template Name", RecGRequisitionLine."Worksheet Template Name");
                            RecUntrackedPlanningElement.SETRANGE(RecUntrackedPlanningElement."Worksheet Batch Name", RecGRequisitionLine."Journal Batch Name");
                            RecUntrackedPlanningElement.SETRANGE(RecUntrackedPlanningElement."Worksheet Line No.", RecGRequisitionLine."Line No.");
                            RecUntrackedPlanningElement.SETFILTER(RecUntrackedPlanningElement."Location Code", '%1', RecGRequisitionLine."Location Code");
                            RecUntrackedPlanningElement.SETFILTER(RecUntrackedPlanningElement."Item No.", '%1', RecGRequisitionLine."No.");
                            QuantiteNonChainee := 0;
                            IF RecUntrackedPlanningElement.Findset() THEN BEGIN
                                REPEAT
                                    QuantiteNonChainee += RecUntrackedPlanningElement."Untracked Quantity";
                                UNTIL RecUntrackedPlanningElement.NEXT() = 0;
                            END;

                            // Export CSV
                            LineNo += 1;

                            TempCSVBuffer.InsertEntry(LineNo, 1, RecGRequisitionLine."Worksheet Template Name");
                            TempCSVBuffer.InsertEntry(LineNo, 2, RecGRequisitionLine."Journal Batch Name");
                            TempCSVBuffer.InsertEntry(LineNo, 3, RecGRequisitionLine."No.");
                            TempCSVBuffer.InsertEntry(LineNo, 4, CompanyInfo.Name);
                            TempCSVBuffer.InsertEntry(LineNo, 5, RecGRequisitionLine."Vendor No.");
                            TempCSVBuffer.InsertEntry(LineNo, 6, format(RecGRequisitionLine."Ref. Order Type"));
                            TempCSVBuffer.InsertEntry(LineNo, 7, format(RecGRequisitionLine."Type Order Planning"));
                            TempCSVBuffer.InsertEntry(LineNo, 8, format(RecGRequisitionLine."Due Date"));
                            TempCSVBuffer.InsertEntry(LineNo, 9, format(RecGRequisitionLine."Demand Date"));
                            TempCSVBuffer.InsertEntry(LineNo, 10, RecGRequisitionLine."Gen. Prod. Posting Group");
                            TempCSVBuffer.InsertEntry(LineNo, 11, RecGRequisitionLine."Unit of Measure Code");
                            TempCSVBuffer.InsertEntry(LineNo, 12, format(RecGRequisitionLine.Quantity));
                            TempCSVBuffer.InsertEntry(LineNo, 13, format(QuantiteNonChainee));
                            TempCSVBuffer.InsertEntry(LineNo, 14, format(RecGRequisitionLine."Replenishment System"));
                            TempCSVBuffer.InsertEntry(LineNo, 15, UserId());
                            TempCSVBuffer.InsertEntry(LineNo, 16, format(CurrentDateTime()));

                            // Copie des lignes PREVISIONNEL avant suppression dans la table BCKREQUSITION LINE
                            IF RecBCKRequisitionLine.FindLast() then numsequence := RecBCKRequisitionLine."BCK Line No.";
                            numsequence += 1;

                            RecBCKRequisitionLine."BCK Worksheet Template Name" := RecGRequisitionLine."Worksheet Template Name";
                            RecBCKRequisitionLine."BCK Journal Batch Name" := RecGRequisitionLine."Journal Batch Name";
                            RecBCKRequisitionLine."BCK Line No." := numsequence;
                            RecBCKRequisitionLine."BCK Type" := format(RecGRequisitionLine.Type);
                            RecBCKRequisitionLine."BCK No." := RecGRequisitionLine."No.";
                            RecBCKRequisitionLine."BCK Description" := RecGRequisitionLine."Description";
                            RecBCKRequisitionLine."BCK Description 2" := RecGRequisitionLine."Description 2";
                            RecBCKRequisitionLine."BCK Quantity" := RecGRequisitionLine."Quantity";
                            RecBCKRequisitionLine."BCK Vendor No." := RecGRequisitionLine."Vendor No.";
                            RecBCKRequisitionLine."BCK Direct Unit Cost" := RecGRequisitionLine."Direct Unit Cost";
                            RecBCKRequisitionLine."BCK Due Date" := RecGRequisitionLine."Due Date";
                            RecBCKRequisitionLine."BCK Confirmed" := Format(RecGRequisitionLine.Confirmed);
                            RecBCKRequisitionLine."BCK Location Code" := RecGRequisitionLine."Location Code";
                            RecBCKRequisitionLine."BCK Order Date" := RecGRequisitionLine."Order Date";
                            RecBCKRequisitionLine."BCK Supply From" := RecGRequisitionLine."Supply From";
                            RecBCKRequisitionLine."BCK User ID" := UserId();
                            RecBCKRequisitionLine."BCK Transfer-from Code" := RecGRequisitionLine."Transfer-from Code";
                            RecBCKRequisitionLine."BCK Transfer Shipment Date" := RecGRequisitionLine."Transfer Shipment Date";
                            RecBCKRequisitionLine."BCK Type Order Planning" := Format(RecGRequisitionLine."Type Order Planning");
                            RecBCKRequisitionLine."BCK MPS Order" := Format(RecGRequisitionLine."MPS Order");
                            RecBCKRequisitionLine."BCK Planning Flexibility" := Format(RecGRequisitionLine."Planning Flexibility");
                            RecBCKRequisitionLine."BCK Gen. Prod. Posting Group" := RecGRequisitionLine."Gen. Prod. Posting Group";
                            RecBCKRequisitionLine."BCK Remaining Quantity" := RecGRequisitionLine."Remaining Quantity";
                            RecBCKRequisitionLine."BCK Ref. Order Type" := Format(RecGRequisitionLine."Ref. Order Type");
                            RecBCKRequisitionLine."BCK Action Message" := Format(RecGRequisitionLine."Action Message");
                            RecBCKRequisitionLine."BCK Accept Action Message" := Format(RecGRequisitionLine."Accept Action Message");
                            RecBCKRequisitionLine."BCK Replenishment System" := Format(RecGRequisitionLine."Replenishment System");
                            RecBCKRequisitionLine."BCK Insert Date" := format(CurrentDateTime());
                            RecBCKRequisitionLine.INSERT();

                            // Suppression des lignes PREVISIONNEL et de type ACHAT de la table REQUISITON LINE
                            RecGRequisitionLine.Delete()
                        until RecGRequisitionLine.Next() = 0;

                    myTime := TIME();
                    timeText := FORMAT(TODAY(), 0, '<Day>-<Month>-<Year4>');
                    timeText += FORMAT(mytime, 0, '_<Hours24,2>-<Minutes,2>-<Seconds,2>');
                    TempCSVBuffer.SaveData(CompanyInfo."Export Planificiation Path" + STRSUBSTNO(CompanyInfo.Name + '_Export Previsionnel_%1.csv', Timetext), ';');

                END;
            }
        }
    }

    // Ce trigger permet d'afficher (uniquement) la quantité non chainée (Effet d''avance) pour chaque ligne de la feuille planning.
    trigger OnAfterGetRecord()
    var
        RecUntrackedPlanningElement: Record "Untracked Planning Element";
    BEGIN

        RecUntrackedPlanningElement.SETRANGE(RecUntrackedPlanningElement."Worksheet Template Name", Rec."Worksheet Template Name");
        RecUntrackedPlanningElement.SETRANGE(RecUntrackedPlanningElement."Worksheet Batch Name", Rec."Journal Batch Name");
        RecUntrackedPlanningElement.SETRANGE(RecUntrackedPlanningElement."Worksheet Line No.", Rec."Line No.");
        RecUntrackedPlanningElement.SETFILTER(RecUntrackedPlanningElement."Location Code", '%1', Rec."Location Code");
        RecUntrackedPlanningElement.SETFILTER(RecUntrackedPlanningElement."Item No.", '%1', Rec."No.");

        QuantiteNonChainee := 0;
        IF RecUntrackedPlanningElement.Findset() THEN BEGIN

            REPEAT
                QuantiteNonChainee += RecUntrackedPlanningElement."Untracked Quantity";
            UNTIL RecUntrackedPlanningElement.NEXT() = 0;
        END;
    END;

    var
        QuantiteNonChainee: decimal;
}
