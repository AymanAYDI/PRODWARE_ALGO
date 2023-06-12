xmlport 50009 "Production Forecast"
{
    // version CLIC

    Caption = 'Import Prévisions de production', LOCKED = true;
    Direction = Import;
    FieldSeparator = ';';
    Format = VariableText;
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            tableelement(forecastentry; "Production Forecast Entry")
            {
                XmlName = 'ForecastEntry';
                fieldelement(DocNo; ForecastEntry."Production Forecast Name")
                {
                }
                fieldelement(ItemNo; ForecastEntry."Item No.")
                {
                }
                fieldelement(PostingDate; ForecastEntry."Forecast Date")
                {
                }
                fieldelement(QuantityString; ForecastEntry."Forecast Quantity (Base)")
                {
                }

                trigger OnBeforeInsertRecord()
                begin
                    ForecastEntry."Unit of Measure Code" := 'PCS';
                    ForecastEntry."Location Code" := 'RCT-CONT';
                    ForecastEntry."Component Forecast" := TRUE;
                    ForecastEntry."Qty. per Unit of Measure" := 1;
                end;
            }
        }
    }

    trigger OnPostXmlPort()
    begin
        MESSAGE('Importation OK');
    end;

    var
        MyForecastEntry: Record "Production Forecast Entry";
        NewLineNo: Integer;
        MyQuantity: Decimal;
        MyUnitCost: Decimal;
        MyPostingDate: Date;
}

