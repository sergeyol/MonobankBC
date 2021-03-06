page 50182 "Monobank Statement"
{

    Caption = 'Monobank Statement';
    PageType = List;
    SourceTable = "Monobank Statement";
    SourceTableView = sorting("Date Time") order(descending);
    InsertAllowed = false;
    ModifyAllowed = false;
    ApplicationArea = All;
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Client Id"; Rec."Client Id")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Account Id"; Rec."Account Id")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Statement Id"; Rec."Statement Id")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Unix Time"; Rec."Unix Time")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Date Time"; Rec."Date Time")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Operation Amount"; Rec."Operation Amount")
                {
                    ApplicationArea = All;
                }
                field("Cashback Amount"; Rec."Cashback Amount")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Currency Id"; Rec."Currency Id")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Commission Rate"; Rec."Commission Rate")
                {
                    ApplicationArea = All;
                }
                field(Balance; Rec.Balance)
                {
                    ApplicationArea = All;
                }
                field(Hold; Rec.Hold)
                {
                    ApplicationArea = All;
                }
                field(MCC; Rec.MCC)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if Rec.FindFirst() then;
    end;

}
