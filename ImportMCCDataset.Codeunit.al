codeunit 50181 "Import MCC Dataset"
{
    var
        DatasetUrl: Label 'https://raw.githubusercontent.com/Oleksios/Merchant-Category-Codes/main/With%20groups/mcc.json';

    procedure GetDataset()
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
        if RestClient.Get(DatasetUrl, Response) then begin
            Response.Content().ReadAs(Result);
            if not Response.IsSuccessStatusCode then
                Error(Result);

            //ResultJson.ReadFrom(Result);
            JToken.ReadFrom(Result);

            if JToken.IsArray() then begin
                JArray := JToken.AsArray();

                for i := 0 to JArray.Count() - 1 do begin
                    JArray.Get(i, JToken);
                    JObject := JToken.AsObject();

                    ProcessMccEntry(JObject);
                end;
            end;
        end else begin
            //process error
            Error(GetLastErrorText);
        end;
    end;

    local procedure ProcessMccEntry(MccJObject: JsonObject)
    var
        MCC: Record "Merchant Category Code";
        MccGroup: Record "Merchant Category Group";
        DescJObject: JsonObject;
        GroupJObject: JsonObject;
        MccId: Integer;
        MaskedCardNumber: Text;
        RecordExists: Boolean;
        JToken: JsonToken;
        JArray: JsonArray;
        i: Integer;
    begin
        MccId := GetTokenValue(MccJObject, 'mcc').AsInteger();

        if MCC.Get(MccId) then begin
            RecordExists := true
        end else begin
            MCC.Init();
            MCC.Code := MccId;
        end;

        if MccJObject.Get('fullDescription', JToken) and JToken.IsObject() then begin
            DescJObject := JToken.AsObject();
            MCC."Description UA" := GetTextValue(DescJObject, 'uk');
            MCC."Description EN" := GetTextValue(DescJObject, 'en');
        end;

        if MccJObject.Get('shortDescription', JToken) and JToken.IsObject() then begin
            DescJObject := JToken.AsObject();
            MCC."Short Description UA" := GetTextValue(DescJObject, 'uk');
            MCC."Short Description EN" := GetTextValue(DescJObject, 'en');
        end;

        if MccJObject.Get('group', JToken) and JToken.IsObject() then begin
            GroupJObject := JToken.AsObject();
            MccGroup := ProcessMccGroup(GroupJObject);
            MCC."Group Code" := MccGroup.Code;
        end;

        if RecordExists then
            MCC.Modify(true)
        else
            MCC.Insert(true);
    end;

    local procedure ProcessMccGroup(GroupJObject: JsonObject) MccGroup: Record "Merchant Category Group"
    var
        DescJObject: JsonObject;
        GroupId: code[10];
        MaskedCardNumber: Text;
        RecordExists: Boolean;
        JToken: JsonToken;
        JArray: JsonArray;
        i: Integer;
    begin
        GroupId := GetTokenValue(GroupJObject, 'type').AsText();

        if MccGroup.Get(GroupId) then begin
            RecordExists := true
        end else begin
            MccGroup.Init();
            MccGroup.Code := GroupId;
        end;

        if GroupJObject.Get('description', JToken) and JToken.IsObject() then begin
            DescJObject := JToken.AsObject();
            MccGroup."Description UA" := GetTextValue(DescJObject, 'uk');
            MccGroup."Description EN" := GetTextValue(DescJObject, 'en');
        end;

        if RecordExists then
            MccGroup.Modify(true)
        else
            MccGroup.Insert(true);
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

}