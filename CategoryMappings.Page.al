page 50185 "Category Mappings"
{

    ApplicationArea = All;
    Caption = 'Category Mappings';
    PageType = List;
    SourceTable = "Category Mapping";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = All;
                }
                field("MCC Group"; Rec."MCC Group")
                {
                    ApplicationArea = All;
                }
                field(MCC; Rec.MCC)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Account Id"; Rec."Account Id")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
