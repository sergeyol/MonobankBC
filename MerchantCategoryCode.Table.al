table 50183 "Merchant Category Code"
{
    Caption = 'Merchant Category Code';
    DataClassification = ToBeClassified;
    LookupPageId = "Merchant Category Codes";
    DrillDownPageId = "Merchant Category Codes";

    fields
    {
        field(10; "Code"; Integer)
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(20; "Description UA"; Text[250])
        {
            Caption = 'Description UA';
            DataClassification = ToBeClassified;
        }
        field(30; "Description EN"; Text[250])
        {
            Caption = 'Description EN';
            DataClassification = ToBeClassified;
        }
        field(50; "Short Description UA"; Text[100])
        {
            Caption = 'Short Description UA';
            DataClassification = ToBeClassified;
        }
        field(60; "Short Description EN"; Text[100])
        {
            Caption = 'Short Description EN';
            DataClassification = ToBeClassified;
        }
        field(80; "Group Code"; Code[10])
        {
            Caption = 'Group Code';
            DataClassification = ToBeClassified;
        }
        field(85; "Group Description UA"; Text[100])
        {
            Caption = 'Group Description UA';
            FieldClass = FlowField;
            CalcFormula = lookup("Merchant Category Group"."Description UA" where(Code = field("Group Code")));
            Editable = false;
        }
        field(100; Amount; Decimal)
        {
            Caption = 'Amount';
            FieldClass = FlowField;
            CalcFormula = sum("Monobank Statement".Amount where(MCC = field(Code)));
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
