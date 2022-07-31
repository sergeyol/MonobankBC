page 50183 "Merchant Category Codes"
{
    ApplicationArea = All;
    Caption = 'Merchant Category Codes';
    PageType = List;
    SourceTable = "Merchant Category Code";
    UsageCategory = Lists;
    InsertAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                }
                field("Short Description UA"; Rec."Short Description UA")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Group Code"; Rec."Group Code")
                {
                    ApplicationArea = All;
                }
                field("Group Description UA"; Rec."Group Description UA")
                {
                    ApplicationArea = All;
                }
                field("Short Description EN"; Rec."Short Description EN")
                {
                    ApplicationArea = All;
                }
                field("Description UA"; Rec."Description UA")
                {
                    ApplicationArea = All;
                }
                field("Description EN"; Rec."Description EN")
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
            action(DownloadDataset)
            {
                Caption = 'Download dataset';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Refresh;

                trigger OnAction()
                var
                    ImportMccDataset: Codeunit "Import MCC Dataset";
                begin
                    ImportMccDataset.GetDataset();
                end;
            }
        }
    }
}
