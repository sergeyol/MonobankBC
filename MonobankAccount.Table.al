table 50181 "Monobank Account"
{
    Caption = 'Monobank Account';
    DataClassification = ToBeClassified;

    fields
    {
        field(10; "Client Id"; Text[30])
        {
            Caption = 'Client Id';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(20; "Account Id"; Text[30])
        {
            Caption = 'Account Id';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(50; "Currency Id"; Integer)
        {
            Caption = 'Currency Id';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                Currency: Record Currency;
            begin
                Currency.SetRange("ISO Numeric Code", Format("Currency Id"));
                if Currency.FindFirst() then
                    "Currency Code" := Currency.Code;
            end;
        }
        field(51; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = CustomerContent;
        }
        field(60; Type; Text[50])
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
        field(40; IBAN; Code[40])
        {
            Caption = 'IBAN';
            DataClassification = CustomerContent;
        }
        field(70; "Cashback Type"; Text[50])
        {
            Caption = 'Cashback Type';
            DataClassification = CustomerContent;
        }
        field(80; "Credit Limit"; Decimal)
        {
            Caption = 'Credit Limit';
            DataClassification = CustomerContent;
        }
        field(90; "Balance"; Decimal)
        {
            Caption = 'Balance';
            DataClassification = CustomerContent;
        }
        field(100; "Last Sync. DateTime"; DateTime)
        {
            Caption = 'Last Sync. DateTime';
            DataClassification = CustomerContent;
        }
        field(30; "Card Number"; Text[250])
        {
            Caption = 'Card Number';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(110; "Client Name"; Text[100])
        {
            Caption = 'Client Name';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(120; "Description"; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Client Id", "Account Id")
        {
            Clustered = true;
        }
    }
}
