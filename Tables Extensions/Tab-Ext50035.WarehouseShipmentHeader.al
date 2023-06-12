tableextension 50035 "Warehouse Shipment Header" extends "Warehouse Shipment Header"
{
    //t7320
    fields
    {
        field(50000; "Picking List Exported"; Boolean)
        {
            Caption = 'Picking List Exported';
            DataClassification = CustomerContent;
        }

    }


    PROCEDURE OpenWhseShptHeader(VAR WhseShptHeader: Record "Warehouse Shipment Header");
    VAR
        WhseEmployee: Record "Warehouse Employee";
        WmsManagement: Codeunit "WMS Management";
        CurrentLocationCode: Code[10];
        Text002: Label 'You must first set up user %1 as a warehouse employee.';
    BEGIN
        IF USERID() <> '' THEN BEGIN
            WhseEmployee.SETRANGE("User ID", USERID());
            IF NOT WhseEmployee.FindSet() THEN
                ERROR(Text002, USERID());

            WhseEmployee.SETRANGE("Location Code", WhseShptHeader."Location Code");
            IF WhseEmployee.FindSet() THEN
                CurrentLocationCode := WhseShptHeader."Location Code"
            ELSE
                CurrentLocationCode := WmsManagement.GetDefaultLocation();
            WhseShptHeader.FILTERGROUP := 2;
            WhseShptHeader.SETRANGE("Location Code", CurrentLocationCode);
            WhseShptHeader.FILTERGROUP := 0;
        END;
    END;

}