report 50010 "Items Barcode LUNIFORM"
{
    Caption = 'Items Barcode LUNIFORM';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports/Rep50010.ItemsBarcodeLUNIFORM.rdl';
    ApplicationArea = Basic, Suite;
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;


    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.";
            column(No_; "No.")
            {
            }
            column(Barcode; '*' + "No." + '*')
            {
            }
            column(Description; Description)
            {
            }
            column(Description_2; "Description 2")
            {
            }
        }
    }
}