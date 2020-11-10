page 50180 "Monobank API Setup"
{

    Caption = 'Monobank API Setup';
    PageType = Card;
    SourceTable = "Monobank API Setup";
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Personal Access Token"; Rec."Personal Access Token")
                {
                    ApplicationArea = All;
                    ToolTip = 'Get your token at https://api.monobank.ua/';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(OpenWebpage)
            {
                Caption = 'Open api.monobankua';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = LaunchWeb;

                trigger OnAction()
                begin
                    hyperlink('https://api.monobank.ua/');
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec."Primary Key" := '';
            Rec.Insert();
        end;
    end;

}
