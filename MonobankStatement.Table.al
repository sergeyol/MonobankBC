table 50182 "Monobank Statement"
{
    Caption = 'Monobank Statement';
    DataClassification = CustomerContent;

    fields
    {
        field(20; "Statement Id"; Text[30])
        {
            Caption = 'Statement Id';
            DataClassification = CustomerContent;
        }
        field(5; "Client Id"; Text[30])
        {
            Caption = 'Client Id';
            DataClassification = CustomerContent;
        }
        field(10; "Account Id"; Text[30])
        {
            Caption = 'Account Id';
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
            DataClassification = CustomerContent;
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
        field(60; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(61; "Operation Amount"; Decimal)
        {
            Caption = 'Operation Amount';
            DataClassification = CustomerContent;
        }
        field(63; "Commission Rate"; Decimal)
        {
            Caption = 'Commission Rate';
            DataClassification = CustomerContent;
            BlankZero = true;
        }
        field(62; "Cashback Amount"; Decimal)
        {
            Caption = 'Cashback Amount';
            DataClassification = CustomerContent;
            BlankZero = true;
        }
        field(80; Balance; Decimal)
        {
            Caption = 'Balance';
            DataClassification = CustomerContent;
        }
        field(70; Hold; Boolean)
        {
            Caption = 'Hold';
            DataClassification = CustomerContent;
        }
        field(90; "Unix Time"; BigInteger)
        {
            Caption = 'Unix Time';
            DataClassification = CustomerContent;
        }
        field(91; "Date Time"; DateTime)
        {
            Caption = 'Date Time';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Statement Id", "Account Id")
        {
            Clustered = true;
        }

        key(DateKey; "Date Time") { }
    }

}
