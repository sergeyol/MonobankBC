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
                field(Comment; Rec.Comment)
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
                field("Original MCC"; Rec."Original MCC")
                {
                    ApplicationArea = All;
                }
                field("MCC Description"; Rec."MCC Description")
                {
                    ApplicationArea = All;
                }
                field("MCC Group"; Rec."MCC Group")
                {
                    ApplicationArea = All;
                }
                field("Counter ERDPOU"; Rec."Counter ERDPOU")
                {
                    ApplicationArea = All;
                }
                field("Counter IBAN"; Rec."Counter IBAN")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CreateMapping)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.CreateMappingBasedOnStatement();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if Rec.FindFirst() then;
    end;

}
