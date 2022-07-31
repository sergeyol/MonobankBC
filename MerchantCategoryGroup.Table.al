table 50184 "Merchant Category Group"
{
    Caption = 'Merchant Category Group';
    DataClassification = ToBeClassified;
    LookupPageId = "Merchant Category Groups";
    DrillDownPageId = "Merchant Category Codes";

    fields
    {
        field(10; "Code"; Code[10])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(20; "Description UA"; Text[100])
        {
            Caption = 'Description UA';
            DataClassification = ToBeClassified;
        }
        field(30; "Description EN"; Text[100])
        {
            Caption = 'Description EN';
            DataClassification = ToBeClassified;
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
