codeunit 50180 "Monobank API"
{
    trigger OnRun()
    begin

    end;

    var
        BaseURL: label 'https://api.monobank.ua', Locked = true;

    local procedure GetAccessToken(): Text
    var
        MonobankApiSetup: Record "Monobank API Setup";
    begin
        MonobankApiSetup.get;
        MonobankApiSetup.TestField("Personal Access Token");
        exit(MonobankApiSetup."Personal Access Token");
    end;

    procedure GetPersonalInfo()
    var
        RestClient: HttpClient;
        Response: HttpResponseMessage;
        Headers: HttpHeaders;
        Content: HttpContent;
        Result: Text;
        Address: Text;
        ResultJson: JsonObject;
        JObject: JsonObject;
        JToken: JsonToken;
        JArray: JsonArray;
        i: Integer;
        ClientId: Text;
        ClientName: Text;
    begin
        Address := BaseURL + '/personal/client-info';

        RestClient.DefaultRequestHeaders.Add('X-Token', GetAccessToken());

        if RestClient.Get(Address, Response) then begin
            Response.Content().ReadAs(Result);
            if not Response.IsSuccessStatusCode then
                Error(Result);

            ResultJson.ReadFrom(Result);
            ClientId := GetTokenValue(ResultJson, 'clientId').AsText();
            ClientName := GetTokenValue(ResultJson, 'name').AsText();

            ResultJson.get('accounts', JToken);
            if JToken.IsArray() then begin
                JArray := JToken.AsArray();

                for i := 0 to JArray.Count() - 1 do begin
                    JArray.Get(i, JToken);
                    JObject := JToken.AsObject();

                    ProcessClientAccount(ClientId, ClientName, JObject);
                end;
            end;
        end else begin
            // process error
            Error(GetLastErrorText);
        end;
    end;

    local procedure ProcessClientAccount(ClientId: Text; ClientName: Text; AccountJObject: JsonObject)
    var
        MonobankAccount: Record "Monobank Account";
        AccountId: Text;
        MaskedCardNumber: Text;
        RecordExists: Boolean;
        JToken: JsonToken;
        JArray: JsonArray;
        i: Integer;
    begin
        AccountId := GetTokenValue(AccountJObject, 'id').AsText();

        if MonobankAccount.get(ClientId, AccountId) then
            RecordExists := true
        else begin
            MonobankAccount.Init();
            MonobankAccount."Client Id" := ClientId;
            MonobankAccount."Client Name" := ClientName;
            MonobankAccount."Account Id" := AccountId;
        end;

        MonobankAccount."Currency Id" := GetTokenValue(AccountJObject, 'currencyCode').AsInteger();
        MonobankAccount."Currency Code" := FindCurrencyCodeByIso(MonobankAccount."Currency Id");
        MonobankAccount."Send Id" := GetTextValue(AccountJObject, 'sendId');
        MonobankAccount.Type := GetTextValue(AccountJObject, 'type');
        MonobankAccount.IBAN := GetTextValue(AccountJObject, 'iban');
        MonobankAccount."Cashback Type" := GetTextValue(AccountJObject, 'cashbackType');
        MonobankAccount."Balance" := 0.01 * GetTokenValue(AccountJObject, 'balance').AsInteger();
        MonobankAccount."Credit Limit" := 0.01 * GetTokenValue(AccountJObject, 'creditLimit').AsInteger();

        AccountJObject.get('maskedPan', JToken);
        if JToken.IsArray() then begin
            MonobankAccount."Card Number" := '';
            JArray := JToken.AsArray();
            for i := 0 to JArray.Count() - 1 do begin
                JArray.Get(i, JToken);
                if JToken.IsValue() then begin
                    MaskedCardNumber := JToken.AsValue().AsText();

                    if MonobankAccount."Card Number" <> '' then
                        MonobankAccount."Card Number" += ', ';

                    MonobankAccount."Card Number" += MaskedCardNumber;
                end;

            end;
        end;

        MonobankAccount."Last Sync. DateTime" := CurrentDateTime;

        if RecordExists then
            MonobankAccount.Modify(true)
        else
            MonobankAccount.Insert(true);
    end;

    procedure GetStatementForAccount(MonobankAccount: Record "Monobank Account")
    var
        MonobankStatement: Record "Monobank Statement";
        FromUnixTime, ToUnixTime : BigInteger;
    begin
        ToUnixTime := GetUnixTime(CurrentDateTime);
        FromUnixTime := ToUnixTime - 2682000;   // approx. 1 month: max duration of statement request according to https://api.monobank.ua/docs/
        MonobankStatement.SetRange("Account Id", MonobankAccount."Account Id");
        MonobankStatement.SetCurrentKey("Date Time");
        if MonobankStatement.findlast and (MonobankStatement."Unix Time" > FromUnixTime) then
            FromUnixTime := MonobankStatement."Unix Time";

        GetStatementForAccount(MonobankAccount, FromUnixTime, ToUnixTime);

    end;

    procedure GetStatementHistoryForAccount(MonobankAccount: Record "Monobank Account")
    var
        MonobankStatement: Record "Monobank Statement";
        FromUnixTime, ToUnixTime : BigInteger;
    begin
        MonobankStatement.SetRange("Account Id", MonobankAccount."Account Id");
        MonobankStatement.SetCurrentKey("Date Time");
        if MonobankStatement.FindFirst() then begin
            ToUnixTime := MonobankStatement."Unix Time";
            FromUnixTime := ToUnixTime - 2682000;   // approx. 1 month: max duration of statement request according to https://api.monobank.ua/docs/

            GetStatementForAccount(MonobankAccount, FromUnixTime, ToUnixTime);
        end;
    end;

    procedure GetStatementForAccount(MonobankAccount: Record "Monobank Account"; FromUnixTime: BigInteger; ToUnixTime: BigInteger)
    var
        RestClient: HttpClient;
        Response: HttpResponseMessage;
        Headers: HttpHeaders;
        Content: HttpContent;
        TypeHelper: Codeunit "Type Helper";
        Result: Text;
        Address: Text;
        JObject: JsonObject;
        JToken: JsonToken;
        JArray: JsonArray;
        i: Integer;
        ClientId: Text;
        ClientName: Text;
    begin
        Address := BaseURL + StrSubstNo('/personal/statement/%1/%2/%3', MonobankAccount."Account Id", FromUnixTime, ToUnixTime);

        RestClient.DefaultRequestHeaders.Add('X-Token', GetAccessToken());

        if RestClient.Get(Address, Response) then begin
            Response.Content().ReadAs(Result);
            if not Response.IsSuccessStatusCode then
                Error(Result);

            JToken.ReadFrom(Result);
            JArray := JToken.AsArray();

            for i := 0 to JArray.Count() - 1 do begin
                JArray.Get(i, JToken);
                JObject := JToken.AsObject();

                ProcessAccountStatement(MonobankAccount, JObject);
            end;
        end else begin
            // process error
            Error(GetLastErrorText);
        end;
    end;

    local procedure ProcessAccountStatement(MonobankAccount: Record "Monobank Account"; StatementJObject: JsonObject)
    var
        MonobankStatement: Record "Monobank Statement";
        TypeHelper: Codeunit "Type Helper";
        StatementId: Text;
        RecordExists: Boolean;
    begin
        StatementId := GetTokenValue(StatementJObject, 'id').AsText();

        if MonobankStatement.get(StatementId, MonobankAccount."Account Id") then
            RecordExists := true
        else begin
            MonobankStatement.Init();
            MonobankStatement."Account Id" := MonobankAccount."Account Id";
            MonobankStatement."Statement Id" := StatementId;
        end;

        MonobankStatement."Client Id" := MonobankAccount."Client Id";
        MonobankStatement."Unix Time" := GetTokenValue(StatementJObject, 'time').AsBigInteger();
        MonobankStatement."Date Time" := TypeHelper.EvaluateUnixTimestamp(MonobankStatement."Unix Time");
        MonobankStatement.Description := GetTextValue(StatementJObject, 'description');
        MonobankStatement.Comment := GetTextValue(StatementJObject, 'comment');
        MonobankStatement.MCC := GetTokenValue(StatementJObject, 'mcc').AsInteger();
        MonobankStatement."Original MCC" := GetTokenValue(StatementJObject, 'originalMcc').AsInteger();
        MonobankStatement.Amount := 0.01 * GetTokenValue(StatementJObject, 'amount').AsInteger();
        MonobankStatement."Operation Amount" := 0.01 * GetTokenValue(StatementJObject, 'operationAmount').AsInteger();
        MonobankStatement."Currency Id" := GetTokenValue(StatementJObject, 'currencyCode').AsInteger();
        MonobankStatement."Currency Code" := FindCurrencyCodeByIso(MonobankStatement."Currency Id");
        MonobankStatement."Commission Rate" := 0.01 * GetTokenValue(StatementJObject, 'commissionRate').AsDecimal();
        MonobankStatement."Cashback Amount" := 0.01 * GetTokenValue(StatementJObject, 'cashbackAmount').AsInteger();
        MonobankStatement.Balance := 0.01 * GetTokenValue(StatementJObject, 'balance').AsInteger();
        MonobankStatement.Hold := GetTokenValue(StatementJObject, 'hold').AsBoolean();
        MonobankStatement."Counter ERDPOU" := GetTextValue(StatementJObject, 'counterEdrpou');
        MonobankStatement."Counter IBAN" := GetTextValue(StatementJObject, 'counterIban');
        MonobankStatement."Receipt Id" := GetTextValue(StatementJObject, 'receiptId');

        if RecordExists then
            MonobankStatement.Modify(true)
        else
            MonobankStatement.Insert(true);
    end;

    local procedure GetLastStatementUnixTime(AccountId: Text) UnixTime: BigInteger
    var
        MonobankStatement: Record "Monobank Statement";
    begin
        MonobankStatement.SetRange("Account Id", AccountId);
        MonobankStatement.SetCurrentKey("Date Time");
        if MonobankStatement.findlast then
            UnixTime := MonobankStatement."Unix Time"
        else begin
            UnixTime := GetUnixTime(CreateDateTime(DMY2Date(1, 1, 2020), 0T));
        end;
    end;

    local procedure GetTokenValue(JObject: JsonObject; PropertyName: Text): JsonValue
    var
        JToken: JsonToken;
    begin
        JObject.get(PropertyName, JToken);
        if JToken.IsValue() then
            exit(JToken.AsValue());
    end;

    local procedure GetTextValue(JObject: JsonObject; PropertyName: Text): Text
    var
        JToken: JsonToken;
        JValue: JsonValue;
    begin
        if JObject.get(PropertyName, JToken) then
            if JToken.IsValue() then
                exit(JToken.AsValue().AsText());
    end;

    local procedure GetUnixTime(FromDateTime: DateTime) UnixTime: BigInteger
    var
        EpochDateTime: DateTime;
        EpochDuration: Duration;
    begin
        EpochDateTime := CreateDateTime(DMY2Date(1, 1, 1970), 0T);

        EpochDuration := FromDateTime - EpochDateTime;
        UnixTime := Round(EpochDuration / 1000, 1);
    end;

    local procedure FindCurrencyCodeByIso(IsoNumericCode: Integer) CurrencyCode: Code[10]
    var
        Currency: Record Currency;
    begin
        Currency.SetRange("ISO Numeric Code", Format(IsoNumericCode));
        if Currency.FindFirst() then
            exit(Currency.Code);

        case IsoNumericCode of
            978:
                exit('EUR');
            985:
                exit('PLN');
            980:
                exit('UAH');
            840:
                exit('USD');
        end;
    end;

}