unit uBMA_AI;

interface

uses
  Classes, SysUtils, IdHTTP, IdSSLOpenSSL, IdGlobal,System.JSON , System.NetEncoding;

type
  TBMA_AICorrector = class(TComponent)
  private
    FAPI_URL: string;
    FAPI_Key: string;
    FModel: string;
    FMaxTokens: Integer;
    FTemperature: Double;
    FOnError: TNotifyEvent;
    FOnResponse: TNotifyEvent;
    FLastResponse: string;
    FLastError: string;
    FIsBusy: Boolean;
    procedure SetAPIKey(const Value: string);
    function SanitizeCode(const Code: string): string;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    // الدالة الرئيسية لطلب تصحيح الكود
    function CorrectPascalCode(const ErroneousCode, ErrorMessage: string): string;
    procedure CorrectPascalCodeAsync(const ErroneousCode, ErrorMessage: string);

    // للاتصال بـ OpenAI أو بديل مفتوح المصدر
    procedure SetOpenAI(const APIKey: string; Model: string = 'gpt-3.5-turbo');
    procedure SetOpenSourceAI(const API_URL: string); // مثل Ollama أو محلي

    // خاصيات
    property APIKey: string write SetAPIKey;
    property API_URL: string read FAPI_URL write FAPI_URL;
    property Model: string read FModel write FModel;
    property MaxTokens: Integer read FMaxTokens write FMaxTokens;
    property Temperature: Double read FTemperature write FTemperature;
    property LastResponse: string read FLastResponse;
    property LastError: string read FLastError;
    property IsBusy: Boolean read FIsBusy;
    property OnError: TNotifyEvent read FOnError write FOnError;
    property OnResponse: TNotifyEvent read FOnResponse write FOnResponse;
  end;

implementation

{ TBMA_AICorrector }

constructor TBMA_AICorrector.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAPI_URL := 'https://api.openai.com/v1/chat/completions';
  FModel := 'gpt-3.5-turbo';
  FMaxTokens := 1000;
  FTemperature := 0.3;
  FIsBusy := False;
end;

destructor TBMA_AICorrector.Destroy;
begin
  inherited Destroy;
end;

procedure TBMA_AICorrector.SetAPIKey(const Value: string);
begin
  FAPI_Key := Value;
end;

procedure TBMA_AICorrector.SetOpenAI(const APIKey: string; Model: string = 'gpt-3.5-turbo');
begin
  FAPI_Key := APIKey;
  FAPI_URL := 'https://api.openai.com/v1/chat/completions';
  FModel := Model;
end;

procedure TBMA_AICorrector.SetOpenSourceAI(const API_URL: string);
begin
  FAPI_URL := API_URL;
  FAPI_Key := ''; // غير مطلوب
  FModel := 'local-model';
end;

function TBMA_AICorrector.SanitizeCode(const Code: string): string;
begin
  Result := StringReplace(Code, #13#10, '\n', [rfReplaceAll]);
  Result := StringReplace(Result, '"', '\"', [rfReplaceAll]);
  Result := StringReplace(Result, #9, '\t', [rfReplaceAll]);
end;

function TBMA_AICorrector.CorrectPascalCode(const ErroneousCode, ErrorMessage: string): string;
var
  HTTP: TIdHTTP;
  SSLHandler: TIdSSLIOHandlerSocketOpenSSL;
  RequestBody: TStringStream;
  Response: string;
  JsonData, JsonMsg: TJSONObject;
  JsonArray: TJSONArray;
  JsonValue: TJSONValue;
  ChoicesArray: TJSONArray;
  ChoiceObj: TJSONObject;
  MessageObj: TJSONObject;
begin
  Result := '';
  FLastError := '';
  FLastResponse := '';

  if FAPI_Key = '' then
  begin
    FLastError := 'API Key غير مضبوط.';
    if Assigned(FOnError) then FOnError(Self);
    Exit;
  end;

  HTTP := TIdHTTP.Create(nil);
  SSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create(HTTP);
  RequestBody := TStringStream.Create('', TEncoding.UTF8);
  JsonData := TJSONObject.Create;
  JsonArray := TJSONArray.Create;

  try
    HTTP.IOHandler := SSLHandler;
    HTTP.Request.ContentType := 'application/json';
    HTTP.Request.CharSet := 'utf-8';
    HTTP.Request.CustomHeaders.AddValue('Authorization', 'Bearer ' + FAPI_Key);

    // بناء رسالة النظام
    JsonMsg := TJSONObject.Create;
    JsonMsg.AddPair('role', 'system');
    JsonMsg.AddPair('content', 'You are an expert Pascal (Delphi/Object Pascal) programmer. Correct only the code provided. Return only the corrected Pascal code without explanations, comments, or markdown. If no correction is needed, return the original code.');
    JsonArray.AddElement(JsonMsg);

    // رسالة المستخدم
    JsonMsg := TJSONObject.Create;
    JsonMsg.AddPair('role', 'user');
    JsonMsg.AddPair('content', 'Erroneous Pascal code: ' + SanitizeCode(ErroneousCode) + ' Error message: ' + ErrorMessage + '. Provide only the corrected Pascal code.');
    JsonArray.AddElement(JsonMsg);

    JsonData.AddPair('model', FModel);
    JsonData.AddPair('messages', JsonArray);
    JsonData.AddPair('max_tokens', TJSONNumber.Create(FMaxTokens));
    JsonData.AddPair('temperature', TJSONNumber.Create(FTemperature));

    RequestBody.WriteString(JsonData.ToJSON);
    RequestBody.Position := 0;

    try
      Response := HTTP.Post(FAPI_URL, RequestBody);

      // استخدام TJSONObject.ParseJSONValue في Delphi
      JsonValue := TJSONObject.ParseJSONValue(Response, False);
      try
        if (JsonValue <> nil) and (JsonValue is TJSONObject) then
        begin
          // البحث عن المحتوى في الاستجابة
          ChoicesArray := TJSONObject(JsonValue).GetValue<TJSONArray>('choices');
          if (ChoicesArray <> nil) and (ChoicesArray.Count > 0) then
          begin
            ChoiceObj := ChoicesArray.Items[0] as TJSONObject;
            if ChoiceObj <> nil then
            begin
              MessageObj := ChoiceObj.GetValue<TJSONObject>('message');
              if MessageObj <> nil then
              begin
                Result := MessageObj.GetValue<string>('content');
                FLastResponse := Result;
                if Assigned(FOnResponse) then FOnResponse(Self);
              end;
            end;
          end
          else
          begin
            FLastError := 'لم يتم العثور على إجابة من الذكاء الاصطناعي';
            if Assigned(FOnError) then FOnError(Self);
          end;
        end
        else
        begin
          FLastError := 'استجابة غير صالحة من الخادم';
          if Assigned(FOnError) then FOnError(Self);
        end;
      finally
        JsonValue.Free;
      end;

    except
      on E: Exception do
      begin
        FLastError := 'خطأ في الاتصال: ' + E.Message;
        if Assigned(FOnError) then FOnError(Self);
      end;
    end;
  finally
    HTTP.Free;
    RequestBody.Free;
    JsonData.Free;
  end;
end;


procedure TBMA_AICorrector.CorrectPascalCodeAsync(const ErroneousCode, ErrorMessage: string);
var
  Thread: TThread;
begin
  if FIsBusy then Exit;

  FIsBusy := True;
  Thread := TThread.CreateAnonymousThread(
    procedure
    var
      CorrectedCode: string;
    begin
      try
        CorrectedCode := CorrectPascalCode(ErroneousCode, ErrorMessage);
        TThread.Synchronize(nil,
          procedure
          begin
            FLastResponse := CorrectedCode;
            if Assigned(FOnResponse) then FOnResponse(Self);
          end);
      finally
        FIsBusy := False;
      end;
    end);
  Thread.Start;
end;

end.
