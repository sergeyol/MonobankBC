page 50181 "Monobank Accounts"
{

    Caption = 'Monobank Accounts';
    PageType = List;
    SourceTable = "Monobank Account";
    InsertAllowed = false;
    ModifyAllowed = false;
    ApplicationArea = All;
    UsageCategory = Lists;
    PromotedActionCategories = 'New,Sync,Navigate';

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Card Number"; Rec."Card Number")
                {
                    ApplicationArea = All;
                }
                field("Account Id"; Rec."Account Id")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Width = 15;
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
                field("Balance"; Rec."Balance")
                {
                    ApplicationArea = All;
                }
                field("Credit Limit"; Rec."Credit Limit")
                {
                    ApplicationArea = All;
                }
                field(IBAN; Rec.IBAN)
                {
                    ApplicationArea = All;
                    Width = 40;
                }
                field("Cashback Type"; Rec."Cashback Type")
                {
                    ApplicationArea = All;
                    Width = 15;
                }
                field("Client Id"; Rec."Client Id")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Client Name"; Rec."Client Name")
                {
                    ApplicationArea = All;
                }
                field("Last Sync. DateTime"; Rec."Last Sync. DateTime")
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
            action(SyncAccounts)
            {
                Caption = 'Sync Accounts';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Refresh;

                trigger OnAction()
                var
                    MonobankApi: Codeunit "Monobank API";
                begin
                    MonobankApi.GetPersonalInfo();
                end;
            }

            action(SyncStatement)
            {
                Caption = 'Sync Statement';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = RefreshLines;

                trigger OnAction()
                var
                    MonobankApi: Codeunit "Monobank API";
                begin
                    MonobankApi.GetStatementForAccount(Rec);
                end;
            }

            action(ApiSetup)
            {
                Caption = 'API Setup';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Setup;

                RunObject = Page "Monobank API Setup";
            }
            action(Statement)
            {
                Caption = 'Statement';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = BankAccountStatement;

                RunObject = Page "Monobank Statement";
                RunPageLink = "Account Id" = field("Account Id");
            }
        }
    }

}
