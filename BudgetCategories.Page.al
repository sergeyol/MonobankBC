page 50184 "Budget Categories"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Budget Categories';
    PageType = List;
    SourceTable = "Budget Category";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                //IndentationColumn = Rec.Indentation;
                //IndentationControls = "Code";
                //ShowAsTree = true;
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleTxt;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Parent Category"; Rec."Parent Category")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Indentation; Rec.Indentation)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }


    trigger OnAfterGetCurrRecord()
    begin
        StyleTxt := Rec.GetStyleText;
    end;

    trigger OnAfterGetRecord()
    begin
        StyleTxt := Rec.GetStyleText;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        StyleTxt := Rec.GetStyleText;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        StyleTxt := Rec.GetStyleText;
    end;

    var
        StyleTxt: Text;

    procedure GetSelectionFilter(): Text
    var
        ItemCategory: Record "Item Category";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SetSelectionFilter(ItemCategory);
        exit(SelectionFilterManagement.GetSelectionFilterForItemCategory(ItemCategory));
    end;

    procedure SetSelection(var ItemCategory: Record "Item Category")
    begin
        CurrPage.SetSelectionFilter(ItemCategory);
    end;
}

