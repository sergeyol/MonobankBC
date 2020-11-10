table 50180 "Monobank API Setup"
{
    Caption = 'Monobank API Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(10; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = ToBeClassified;
        }
        field(20; "Personal Access Token"; Text[100])
        {
            Caption = 'Personal Access Token';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

}
