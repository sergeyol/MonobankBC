table 50185 "Category Mapping"
{
    Caption = 'Category Mapping';
    DataClassification = CustomerContent;
    LookupPageId = "Category Mappings";
    DrillDownPageId = "Category Mappings";

    fields
    {
        field(10; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }
        field(20; Priority; Integer)
        {
            Caption = 'Priority';
            DataClassification = CustomerContent;
        }

        field(30; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(40; MCC; Integer)
        {
            Caption = 'MCC';
            TableRelation = "Merchant Category Code".MCC;
            DataClassification = CustomerContent;
        }
        field(42; "MCC Group"; Code[10])
        {
            Caption = 'MCC Group';
            TableRelation = "Merchant Category Code"."Group Code";
            DataClassification = CustomerContent;
        }
        field(51; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
            DataClassification = CustomerContent;
        }
        field(60; "Account Id"; Text[30])
        {
            Caption = 'Account Id';
            TableRelation = "Monobank Account"."Account Id";
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }

        key(PriorityKey; Priority) { }
    }

}
