table 50182 "Monobank Statement"
{
    Caption = 'Monobank Statement';
    DataClassification = CustomerContent;
    LookupPageId = "Monobank Statement";
    DrillDownPageId = "Monobank Statement";

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
        field(31; Comment; Text[1024])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(40; MCC; Integer)
        {
            Caption = 'MCC';
            DataClassification = CustomerContent;
        }
        field(41; "Original MCC"; Integer)
        {
            Caption = 'Original MCC';
            DataClassification = CustomerContent;
        }
        field(42; "MCC Description"; Text[100])
        {
            Caption = 'MCC Description';
            FieldClass = FlowField;
            CalcFormula = lookup("Merchant Category Code"."Short Description UA" where(Code = field(MCC)));
            Editable = false;
        }
        field(43; "MCC Group"; Code[10])
        {
            Caption = 'MCC Group';
            FieldClass = FlowField;
            CalcFormula = lookup("Merchant Category Code"."Group Code" where(Code = field(MCC)));
            Editable = false;
        }
        field(50; "Currency Id"; Integer)
        {
            Caption = 'Currency Id';
            DataClassification = CustomerContent;
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
        field(70; Hold; Boolean)
        {
            Caption = 'Hold';
            DataClassification = CustomerContent;
        }
        field(80; Balance; Decimal)
        {
            Caption = 'Balance';
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
        field(100; "Counter ERDPOU"; Text[10])
        {
            Caption = 'Counter EDRPOU';
            DataClassification = CustomerContent;
        }
        field(110; "Counter IBAN"; Text[40])
        {
            Caption = 'Counter IBAN';
            DataClassification = CustomerContent;
        }
        field(120; "Receipt Id"; Text[30])
        {
            Caption = 'Receipt Id';
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
