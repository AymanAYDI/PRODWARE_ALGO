pageextension 50087 "Prod. BOM Version List" extends "Prod. BOM Version List" //MyTargetPageId
{
    layout
    {
        addafter("Last Date Modified")
        {
            field(Status; Rec.Status)
            { }
        }
    }
}