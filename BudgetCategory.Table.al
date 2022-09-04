table 50184 "Budget Category"
{
    Caption = 'Budget Category';
    LookupPageID = "Budget Categories";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; "Parent Category"; Code[20])
        {
            Caption = 'Parent Category';
            TableRelation = "Budget Category";

            trigger OnValidate()
            var
                BudgetCategory: Record "Budget Category";
                ParentCategory: Code[20];
            begin
                ParentCategory := "Parent Category";
                while BudgetCategory.Get(ParentCategory) do begin
                    if BudgetCategory.Code = Code then
                        Error(CyclicInheritanceErr);
                    ParentCategory := BudgetCategory."Parent Category";
                end;
            end;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(9; Indentation; Integer)
        {
            Caption = 'Indentation';
            MinValue = 0;
        }
        field(11; "Has Children"; Boolean)
        {
            Caption = 'Has Children';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
        key(Key2; "Parent Category")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if HasChildren() then
            Error(DeleteWithChildrenErr);
    end;

    trigger OnInsert()
    begin
        TestField(Code);
        UpdateIndentation();
    end;

    trigger OnModify()
    begin
        UpdateIndentation();
    end;

    var
        CyclicInheritanceErr: Label 'An item category cannot be a parent of itself or any of its children.';
        BudgetCategoryManagement: Codeunit "Item Category Management";
        DeleteWithChildrenErr: Label 'You cannot delete this item category because it has child item categories.';

    procedure HasChildren(): Boolean
    var
        BudgetCategory: Record "Budget Category";
    begin
        BudgetCategory.SetRange("Parent Category", Code);
        exit(not BudgetCategory.IsEmpty)
    end;

    procedure GetStyleText(): Text
    begin
        if Indentation = 0 then
            exit('Strong');

        if HasChildren() then
            exit('Strong');

        exit('');
    end;

    local procedure UpdateIndentation()
    var
        ParentBudgetCategory: Record "Budget Category";
    begin
        if ParentBudgetCategory.Get("Parent Category") then
            UpdateIndentationTree(ParentBudgetCategory.Indentation + 1)
        else
            UpdateIndentationTree(0);
    end;

    procedure UpdateIndentationTree(Level: Integer)
    var
        BudgetCategory: Record "Budget Category";
    begin
        Indentation := Level;

        BudgetCategory.SetRange("Parent Category", Code);
        if BudgetCategory.FindSet() then
            repeat
                BudgetCategory.UpdateIndentationTree(Level + 1);
                BudgetCategory.Modify();
            until BudgetCategory.Next() = 0;
    end;
}

