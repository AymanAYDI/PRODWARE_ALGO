pageextension 50093 "DemandForecastNames" extends "Demand Forecast Names"
{
    actions
    {
        addafter("Edit Production Forecast")
        {
            group(ALGO_)
            {
                Caption = 'ALGO', locked = true;
                Image = Customer;

                action("Import Prévision de Production")
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Image = Import;

                    Caption = 'Import Prévision de Production', LOCKED = true;

                    RunObject = XMLport "Production Forecast";
                }
                action("Détails Prévision de Production")
                {
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Image = ListPage;

                    Caption = 'Détails Prévision Production', LOCKED = true;

                    RunObject = page "ForeCastEntryDetails";
                }
            }
        }
    }
}