page 50184 "Merchant Category Groups"
{
    ApplicationArea = All;
    Caption = 'Merchant Category Groups';
    PageType = List;
    SourceTable = "Merchant Category Group";
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
}
