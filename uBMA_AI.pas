unit uBMA_AI;

interface

uses
//<<<<<<< HEAD
  System.SysUtils, System.Classes, System.JSON, System.Generics.Collections,
  System.DateUtils, System.Net.HttpClient, System.Net.URLClient,
  System.NetEncoding, System.SyncObjs,
  IdHTTP, IdSSLOpenSSL, IdGlobal;

type
  /// أنواع المزودين المدعومين
  TAIProvider = (aipOpenAI, aipGemini, aipAnthropic, aipGroq);

  /// تصنيف النموذج
  TAIModelCategory = (mcChat, mcVision, mcEmbedding, mcCode, mcOther);

  /// معلومات نموذج واحد
  TAIModelInfo = record
    Id: string;
    DisplayName: string;
    Category: TAIModelCategory;
    Provider: TAIProvider;
  end;

  /// نتيجة عملية جلب النماذج
  TAIModelsResult = record
    Success: Boolean;
    Models: TArray<TAIModelInfo>;
    ErrorMessage: string;
    FromCache: Boolean;
  end;

  /// حدث يُستدعى عند اكتمال الجلب
  TOnModelsFetched = reference to procedure(const AResult: TAIModelsResult);

  /// طلب تنفيذ AI
  TAIExecuteRequest = record
    Provider: TAIProvider;
    ApiKey: string;
    Model: string;
    Prompt: string;
    Temperature: Double;
    MaxTokens: Integer;
  end;

  /// نتيجة تنفيذ AI
  TAIExecuteResponse = record
    Success: Boolean;
    Content: string;
    ErrorMessage: string;
  end;

  /// ============================================================
  /// الوحدة الرئيسية
  /// ============================================================
  TAIModelsFetcher = class
  private
    class var FCache: TDictionary<string, TPair<TDateTime, TArray<TAIModelInfo>>>;
    class var FLock: TCriticalSection;

    // Cache
    class function CacheKey(const AProvider: TAIProvider): string;
    class function TryGetFromCache(const AProvider: TAIProvider;
      out AModels: TArray<TAIModelInfo>): Boolean;
    class procedure SaveToCache(const AProvider: TAIProvider;
      const AModels: TArray<TAIModelInfo>);

    // جلب النماذج
    class function FetchFromOpenAI(const AApiKey: string): TAIModelsResult;
    class function FetchFromGemini(const AApiKey: string): TAIModelsResult;
    class function FetchFromAnthropic(const AApiKey: string): TAIModelsResult;
    class function FetchFromGroq(const AApiKey: string): TAIModelsResult;

    // تحليل النماذج
    class function ParseOpenAIStyleModels(const AJSON: string;
      AProvider: TAIProvider): TArray<TAIModelInfo>;
    class function ParseGeminiModels(const AJSON: string): TArray<TAIModelInfo>;
    class function ParseAnthropicModels(const AJSON: string): TArray<TAIModelInfo>;

    // قائمة احتياطية
    class function GetFallbackModels(AProvider: TAIProvider): TArray<TAIModelInfo>;

    // أدوات
    class function CreateHTTP: TIdHTTP;
    class function GuessCategory(const AModelId: string): TAIModelCategory;
    class function IsChatModel(const AModelId, AProvider: string): Boolean;

    // تنفيذ AI
    class function ExecuteOpenAI(const Req: TAIExecuteRequest): TAIExecuteResponse;
    class function ExecuteGemini(const Req: TAIExecuteRequest): TAIExecuteResponse;
    class function ExecuteAnthropic(const Req: TAIExecuteRequest): TAIExecuteResponse;
    class function ExecuteGroq(const Req: TAIExecuteRequest): TAIExecuteResponse;

    // استخراج النص
    class function ExtractOpenAIText(const AJSON: string): string;
    class function ExtractGeminiText(const AJSON: string): string;
    class function ExtractAnthropicText(const AJSON: string): string;
    class function ExtractErrorMessage(const AJSON: string): string;
    class function EscapeJSON(const S: string): string;

  public
    class constructor Create;
    class destructor Destroy;

    // ====== جلب النماذج ======
    class function Fetch(AProvider: TAIProvider; const AApiKey: string;
      AUseCache: Boolean = True): TAIModelsResult;

    class procedure FetchAsync(AProvider: TAIProvider; const AApiKey: string;
      AOnDone: TOnModelsFetched; AUseCache: Boolean = True);

    // ====== تنفيذ AI ======
    class function ExecuteAI(const Req: TAIExecuteRequest): TAIExecuteResponse;

    // ====== تنظيف الردود ======
    class function CleanAIResponse(const AText: string): string;

    // ====== تصفية ======
    class function FilterByCategory(const AModels: TArray<TAIModelInfo>;
      ACategory: TAIModelCategory): TArray<TAIModelInfo>;
    class function FilterByPattern(const AModels: TArray<TAIModelInfo>;
      const APattern: string): TArray<TAIModelInfo>;
    class function FilterChatModels(const AModels: TArray<TAIModelInfo>): TArray<TAIModelInfo>;

    // ====== Cache ======
    class procedure ClearCache(AProvider: TAIProvider; AClearAll: Boolean = False);

    // ====== تحويلات ======
    class function ProviderFromString(const AName: string): TAIProvider;
    class function ProviderToString(AProvider: TAIProvider): string;
    class function CategoryToString(ACategory: TAIModelCategory): string;

  end;

implementation

//<<<<<<< HEAD
const
  CACHE_DURATION_HOURS = 6;

{ ============================================================
  إنشاء / تحرير
  ============================================================ }
class constructor TAIModelsFetcher.Create;
begin
  FCache := TDictionary<string, TPair<TDateTime, TArray<TAIModelInfo>>>.Create;
  FLock  := TCriticalSection.Create;
end;

class destructor TAIModelsFetcher.Destroy;
begin
  FLock.Enter;
  try
    FCache.Free;
  finally
    FLock.Leave;
  end;
  FLock.Free;
end;

{ ============================================================
  تحويلات
  ============================================================ }
class function TAIModelsFetcher.ProviderToString(AProvider: TAIProvider): string;
begin
  case AProvider of
    aipOpenAI:    Result := 'openai';
    aipGemini:    Result := 'gemini';
    aipAnthropic: Result := 'anthropic';
    aipGroq:      Result := 'groq';
  else
    Result := 'unknown';
  end;
end;

class function TAIModelsFetcher.ProviderFromString(const AName: string): TAIProvider;
begin
  if SameText(AName, 'openai') then Result := aipOpenAI
  else if SameText(AName, 'gemini') then Result := aipGemini
  else if SameText(AName, 'anthropic') then Result := aipAnthropic
  else if SameText(AName, 'groq') then Result := aipGroq
  else Result := aipGemini;
end;

class function TAIModelsFetcher.CategoryToString(ACategory: TAIModelCategory): string;
begin
  case ACategory of
    mcChat:      Result := 'Chat';
    mcVision:    Result := 'Vision';
    mcEmbedding: Result := 'Embedding';
    mcCode:      Result := 'Code';
  else
    Result := 'Other';
  end;
end;

{ ============================================================
  HTTP
  ============================================================ }
class function TAIModelsFetcher.CreateHTTP: TIdHTTP;
var
  SSL: TIdSSLIOHandlerSocketOpenSSL;
begin
  Result := TIdHTTP.Create(nil);
  Result.ConnectTimeout := 15000;
  Result.ReadTimeout    := 60000;
  Result.HandleRedirects := True;

  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(Result);
  SSL.SSLOptions.Method := sslvTLSv1_2;
  SSL.SSLOptions.SSLVersions := [sslvTLSv1_2];

  Result.IOHandler := SSL;
  Result.Request.ContentType := 'application/json';
  Result.Request.CharSet := 'utf-8';
  Result.Request.UserAgent := 'BMA-Pascal-Editor/1.4';
end;

{ ============================================================
  تخمين التصنيف
  ============================================================ }
class function TAIModelsFetcher.GuessCategory(const AModelId: string): TAIModelCategory;
var
  S: string;
begin
  S := LowerCase(AModelId);

  if (Pos('embed', S) > 0) then
    Exit(mcEmbedding);

  if (Pos('vision', S) > 0) or (Pos('-vl', S) > 0) then
    Exit(mcVision);

  if (Pos('code', S) > 0) or (Pos('codestral', S) > 0) or
     (Pos('coder', S) > 0) then
    Exit(mcCode);

  if (Pos('gpt', S) > 0) or (Pos('claude', S) > 0) or
     (Pos('gemini', S) > 0) or (Pos('llama', S) > 0) or
     (Pos('mixtral', S) > 0) or (Pos('gemma', S) > 0) or
     (Pos('qwen', S) > 0) or (Pos('deepseek', S) > 0) then
    Exit(mcChat);

  Result := mcOther;
end;

class function TAIModelsFetcher.IsChatModel(const AModelId, AProvider: string): Boolean;
var
  S: string;
begin
  S := LowerCase(AModelId);

  if (Pos('embed', S) > 0) or (Pos('whisper', S) > 0) or
     (Pos('tts', S) > 0) or (Pos('dall-e', S) > 0) or
     (Pos('moderation', S) > 0) or (Pos('audio', S) > 0) or
     (Pos('image', S) > 0) or (Pos('davinci', S) > 0) or
     (Pos('babbage', S) > 0) or (Pos('ada', S) > 0) then
    Exit(False);

  if SameText(AProvider, 'gemini') then
    Exit(Pos('gemini', S) > 0);

  if SameText(AProvider, 'anthropic') then
    Exit(Pos('claude', S) > 0);

  Result := True;
end;

{ ============================================================
  Cache
  ============================================================ }
class function TAIModelsFetcher.CacheKey(const AProvider: TAIProvider): string;
begin
  Result := 'models_' + ProviderToString(AProvider);
end;

class function TAIModelsFetcher.TryGetFromCache(const AProvider: TAIProvider;
  out AModels: TArray<TAIModelInfo>): Boolean;
var
  Entry: TPair<TDateTime, TArray<TAIModelInfo>>;
begin
  Result := False;
  FLock.Enter;
  try
    if FCache.TryGetValue(CacheKey(AProvider), Entry) then
    begin
      if HoursBetween(Now, Entry.Key) < CACHE_DURATION_HOURS then
      begin
        AModels := Entry.Value;
        Result := True;
      end
      else
        FCache.Remove(CacheKey(AProvider));
    end;
  finally
    FLock.Leave;
  end;
end;

class procedure TAIModelsFetcher.SaveToCache(const AProvider: TAIProvider;
  const AModels: TArray<TAIModelInfo>);
begin
  FLock.Enter;
  try
    FCache.AddOrSetValue(CacheKey(AProvider),
      TPair<TDateTime, TArray<TAIModelInfo>>.Create(Now, AModels));
  finally
    FLock.Leave;
  end;
end;

class procedure TAIModelsFetcher.ClearCache(AProvider: TAIProvider;
  AClearAll: Boolean);
begin
  FLock.Enter;
  try
    if AClearAll then
      FCache.Clear
    else
      FCache.Remove(CacheKey(AProvider));
  finally
    FLock.Leave;
  end;
end;

{ ============================================================
  Fetch الرئيسية
  ============================================================ }
class function TAIModelsFetcher.Fetch(AProvider: TAIProvider;
  const AApiKey: string; AUseCache: Boolean): TAIModelsResult;
var
  Cached: TArray<TAIModelInfo>;
begin
  Result.Success := False;
  Result.FromCache := False;
  Result.ErrorMessage := '';

  if AApiKey.Trim = '' then
  begin
   Result.ErrorMessage := 'API key is empty';
    Exit;
  end;

  if AUseCache and TryGetFromCache(AProvider, Cached) then
  begin
    Result.Success := True;
    Result.Models := Cached;
    Result.FromCache := True;
    Exit;
  end;

  case AProvider of
    aipOpenAI:    Result := FetchFromOpenAI(AApiKey);
    aipGemini:    Result := FetchFromGemini(AApiKey);
    aipAnthropic: Result := FetchFromAnthropic(AApiKey);
    aipGroq:      Result := FetchFromGroq(AApiKey);
  end;

  if not Result.Success or (Length(Result.Models) = 0) then
  begin
    Result.Models := GetFallbackModels(AProvider);
    Result.Success := Length(Result.Models) > 0;
    if Result.ErrorMessage = '' then
     Result.ErrorMessage := 'Fetch failed — fallback list';
  end;

  if Result.Success and (Length(Result.Models) > 0) then
    SaveToCache(AProvider, Result.Models);
end;

class procedure TAIModelsFetcher.FetchAsync(AProvider: TAIProvider;
  const AApiKey: string; AOnDone: TOnModelsFetched; AUseCache: Boolean);
begin
  TThread.CreateAnonymousThread(
    procedure
    var
      Res: TAIModelsResult;
    begin
      Res := Fetch(AProvider, AApiKey, AUseCache);
      if Assigned(AOnDone) then
        TThread.Synchronize(nil,
          procedure
          begin
            AOnDone(Res);
          end);
    end
  ).Start;
end;

{ ============================================================
  Fetch — OpenAI
  ============================================================ }
class function TAIModelsFetcher.FetchFromOpenAI(
  const AApiKey: string): TAIModelsResult;
var
  HTTP: TIdHTTP;
  Response: string;
begin
  Result.Success := False;
  Result.FromCache := False;
  HTTP := CreateHTTP;
  try
    try
      HTTP.Request.CustomHeaders.Clear;
      HTTP.Request.CustomHeaders.AddValue('Authorization', 'Bearer ' + AApiKey);
      Response := HTTP.Get('https://api.openai.com/v1/models');

      Result.Models  := ParseOpenAIStyleModels(Response, aipOpenAI);
      Result.Success := Length(Result.Models) > 0;
      if not Result.Success then
        Result.ErrorMessage := 'No Models found';
    except
      on E: Exception do
        Result.ErrorMessage := 'OpenAI: ' + E.Message;
    end;
  finally
    HTTP.Free;
  end;
end;

{ ============================================================
  Fetch — Gemini
  ============================================================ }
class function TAIModelsFetcher.FetchFromGemini(
  const AApiKey: string): TAIModelsResult;
var
  HTTP: TIdHTTP;
  Response, URL: string;
begin
  Result.Success := False;
  Result.FromCache := False;
  HTTP := CreateHTTP;
  try
    try
      URL := 'https://generativelanguage.googleapis.com/v1beta/models?key=' +
             AApiKey + '&pageSize=100';
      Response := HTTP.Get(URL);

      Result.Models  := ParseGeminiModels(Response);
      Result.Success := Length(Result.Models) > 0;
      if not Result.Success then
      Result.ErrorMessage := 'No Models found';
    except
      on E: Exception do
        Result.ErrorMessage := 'Gemini: ' + E.Message;
    end;
  finally
    HTTP.Free;
  end;
end;

{ ============================================================
  Fetch — Anthropic
  ============================================================ }
class function TAIModelsFetcher.FetchFromAnthropic(
  const AApiKey: string): TAIModelsResult;
var
  HTTP: TIdHTTP;
  Response: string;
begin
  Result.Success := False;
  Result.FromCache := False;
  HTTP := CreateHTTP;
  try
    try
      HTTP.Request.CustomHeaders.Clear;
      HTTP.Request.CustomHeaders.AddValue('x-api-key', AApiKey);
      HTTP.Request.CustomHeaders.AddValue('anthropic-version', '2023-06-01');
      Response := HTTP.Get('https://api.anthropic.com/v1/models');

      Result.Models  := ParseAnthropicModels(Response);
      Result.Success := Length(Result.Models) > 0;
      if not Result.Success then
        Result.ErrorMessage := 'No Models found';
    except
      on E: Exception do
        Result.ErrorMessage := 'Anthropic: ' + E.Message;
    end;
  finally
    HTTP.Free;
  end;
end;

{ ============================================================
  Fetch — Groq
  ============================================================ }
class function TAIModelsFetcher.FetchFromGroq(
  const AApiKey: string): TAIModelsResult;
var
  HTTP: TIdHTTP;
  Response: string;
begin
  Result.Success := False;
  Result.FromCache := False;
  HTTP := CreateHTTP;
  try
    try
      HTTP.Request.CustomHeaders.Clear;
      HTTP.Request.CustomHeaders.AddValue('Authorization', 'Bearer ' + AApiKey);
      Response := HTTP.Get('https://api.groq.com/openai/v1/models');

      Result.Models  := ParseOpenAIStyleModels(Response, aipGroq);
      Result.Success := Length(Result.Models) > 0;
      if not Result.Success then
        Result.ErrorMessage := 'No Models found';
    except
      on E: Exception do
        Result.ErrorMessage := 'Groq: ' + E.Message;
    end;
  finally
    HTTP.Free;
  end;
end;

{ ============================================================
  تحليل — OpenAI Style
  ============================================================ }
class function TAIModelsFetcher.ParseOpenAIStyleModels(const AJSON: string;
  AProvider: TAIProvider): TArray<TAIModelInfo>;
var
  Root, Item: TJSONObject;
  Arr: TJSONArray;
  I: Integer;
  ModelId: string;
  ModelInfo: TAIModelInfo;
  List: TList<TAIModelInfo>;
begin
  List := TList<TAIModelInfo>.Create;
  try
    Root := TJSONObject.ParseJSONValue(AJSON) as TJSONObject;
    if not Assigned(Root) then
    begin
      SetLength(Result, 0);
      Exit;
    end;
    try
      Arr := Root.GetValue<TJSONArray>('data');
      if Assigned(Arr) then
        for I := 0 to Arr.Count - 1 do
        begin
          Item := Arr.Items[I] as TJSONObject;
          if not Assigned(Item) then Continue;
          ModelId := Item.GetValue<string>('id');
          if ModelId = '' then Continue;
          if not IsChatModel(ModelId, ProviderToString(AProvider)) then Continue;

          ModelInfo.Id          := ModelId;
          ModelInfo.DisplayName := ModelId;
          ModelInfo.Category    := GuessCategory(ModelId);
          ModelInfo.Provider    := AProvider;
          List.Add(ModelInfo);
        end;
    finally
      Root.Free;
    end;
    Result := List.ToArray;
  finally
    List.Free;
  end;
end;

{ ============================================================
  تحليل — Gemini
  ============================================================ }
class function TAIModelsFetcher.ParseGeminiModels(
  const AJSON: string): TArray<TAIModelInfo>;
var
  Root, Item: TJSONObject;
  Arr: TJSONArray;
  I: Integer;
  FullName, ShortName: string;
  ModelInfo: TAIModelInfo;
  List: TList<TAIModelInfo>;
begin
  List := TList<TAIModelInfo>.Create;
  try
    Root := TJSONObject.ParseJSONValue(AJSON) as TJSONObject;
    if not Assigned(Root) then
    begin
      SetLength(Result, 0);
      Exit;
    end;
    try
      Arr := Root.GetValue<TJSONArray>('models');
      if Assigned(Arr) then
        for I := 0 to Arr.Count - 1 do
        begin
          Item := Arr.Items[I] as TJSONObject;
          if not Assigned(Item) then Continue;
          FullName := Item.GetValue<string>('name');
          if FullName = '' then Continue;

          ShortName := FullName;
          if Pos('models/', ShortName) = 1 then
            Delete(ShortName, 1, 7);

          if not IsChatModel(ShortName, 'gemini') then Continue;

          ModelInfo.Id          := ShortName;
          ModelInfo.DisplayName := ShortName;
          ModelInfo.Category    := GuessCategory(ShortName);
          ModelInfo.Provider    := aipGemini;
          List.Add(ModelInfo);
        end;
    finally
      Root.Free;
    end;
    Result := List.ToArray;
  finally
    List.Free;
  end;
end;

{ ============================================================
  تحليل — Anthropic
  ============================================================ }
class function TAIModelsFetcher.ParseAnthropicModels(
  const AJSON: string): TArray<TAIModelInfo>;
var
  Root, Item: TJSONObject;
  Arr: TJSONArray;
  I: Integer;
  ModelId: string;
  ModelInfo: TAIModelInfo;
  List: TList<TAIModelInfo>;
begin
  List := TList<TAIModelInfo>.Create;
  try
    Root := TJSONObject.ParseJSONValue(AJSON) as TJSONObject;
    if not Assigned(Root) then
    begin
      SetLength(Result, 0);
      Exit;
    end;
    try
      Arr := Root.GetValue<TJSONArray>('data');
      if Assigned(Arr) then
        for I := 0 to Arr.Count - 1 do
        begin
          Item := Arr.Items[I] as TJSONObject;
          if not Assigned(Item) then Continue;
          ModelId := Item.GetValue<string>('id');
          if ModelId = '' then Continue;
          if not IsChatModel(ModelId, 'anthropic') then Continue;

          ModelInfo.Id          := ModelId;
          ModelInfo.DisplayName := ModelId;
          ModelInfo.Category    := GuessCategory(ModelId);
          ModelInfo.Provider    := aipAnthropic;
          List.Add(ModelInfo);
        end;
    finally
      Root.Free;
    end;
    Result := List.ToArray;
  finally
    List.Free;
  end;
end;

{ ============================================================
  قائمة احتياطية
  ============================================================ }
class function TAIModelsFetcher.GetFallbackModels(
  AProvider: TAIProvider): TArray<TAIModelInfo>;
var
  List: TList<TAIModelInfo>;

  procedure AddModel(const AId: string);
  var
    M: TAIModelInfo;
  begin
    M.Id          := AId;
    M.DisplayName := AId;
    M.Category    := GuessCategory(AId);
    M.Provider    := AProvider;
    List.Add(M);
  end;

begin
  List := TList<TAIModelInfo>.Create;
  try
    case AProvider of
      aipOpenAI:
        begin
          AddModel('gpt-4o-mini');
          AddModel('gpt-4o');
          AddModel('gpt-4-turbo');
          AddModel('gpt-3.5-turbo');
        end;
      aipGemini:
        begin
          AddModel('gemini-2.5-flash-lite');
          AddModel('gemini-2.5-flash');
          AddModel('gemini-2.5-pro');
          AddModel('gemini-2.0-flash');
        end;
      aipAnthropic:
        begin
          AddModel('claude-3-5-sonnet-20241022');
          AddModel('claude-3-5-haiku-20241022');
          AddModel('claude-3-opus-20240229');
        end;
      aipGroq:
        begin
          AddModel('llama-3.3-70b-versatile');
          AddModel('llama-3.1-8b-instant');
          AddModel('mixtral-8x7b-32768');
        end;
    end;
    Result := List.ToArray;
  finally
    List.Free;
  end;
end;

{ ============================================================
  تصفية
  ============================================================ }
class function TAIModelsFetcher.FilterByCategory(
  const AModels: TArray<TAIModelInfo>;
  ACategory: TAIModelCategory): TArray<TAIModelInfo>;
var
  List: TList<TAIModelInfo>;
  M: TAIModelInfo;
begin
  List := TList<TAIModelInfo>.Create;
  try
    for M in AModels do
      if M.Category = ACategory then
        List.Add(M);
    Result := List.ToArray;
  finally
    List.Free;
  end;
end;

class function TAIModelsFetcher.FilterByPattern(
  const AModels: TArray<TAIModelInfo>; const APattern: string): TArray<TAIModelInfo>;
var
  List: TList<TAIModelInfo>;
  M: TAIModelInfo;
  P: string;
  Match: Boolean;
  Parts: TArray<string>;
  I: Integer;
begin
  List := TList<TAIModelInfo>.Create;
  try
    P := LowerCase(APattern);
    Parts := P.Split(['*']);

    for M in AModels do
    begin
      if P = '' then
        Match := True
      else
      begin
        Match := True;
        for I := 0 to High(Parts) do
          if (Parts[I] <> '') and (Pos(Parts[I], LowerCase(M.Id)) = 0) then
          begin
            Match := False;
            Break;
          end;
      end;

      if Match then
        List.Add(M);
    end;
    Result := List.ToArray;
  finally
    List.Free;
  end;
end;

class function TAIModelsFetcher.FilterChatModels(
  const AModels: TArray<TAIModelInfo>): TArray<TAIModelInfo>;
var
  List: TList<TAIModelInfo>;
  M: TAIModelInfo;
begin
  List := TList<TAIModelInfo>.Create;
  try
    for M in AModels do
      if M.Category in [mcChat, mcVision, mcCode] then
        List.Add(M);
    Result := List.ToArray;
  finally
    List.Free;
  end;
end;

{ ============================================================
  تنظيف الرد من Markdown
  ============================================================ }
class function TAIModelsFetcher.CleanAIResponse(const AText: string): string;
var
  S: string;
  StartFence, EndFence, P: Integer;
begin
  Result := AText.Trim;
  if Result = '' then Exit;

  StartFence := Pos('```', Result);
  if StartFence > 0 then
  begin
    P := StartFence + 3;
    while (P <= Length(Result)) and (Result[P] <> #10) and (Result[P] <> #13) do
      Inc(P);
    while (P <= Length(Result)) and ((Result[P] = #10) or (Result[P] = #13)) do
      Inc(P);

    EndFence := Pos('```', Result, P);
    if EndFence > 0 then
      Result := Copy(Result, P, EndFence - P)
    else
      Result := Copy(Result, P, Length(Result) - P + 1);
  end;

  Result := Result.Trim;
end;

{ ============================================================
  تنفيذ AI — التوزيع
  ============================================================ }
class function TAIModelsFetcher.ExecuteAI(
  const Req: TAIExecuteRequest): TAIExecuteResponse;
begin
  Result.Success := False;
  Result.Content := '';
  Result.ErrorMessage := '';

  if Req.ApiKey.Trim = '' then
  begin
   Result.ErrorMessage := 'API key is empty';
    Exit;
  end;

  if Req.Model.Trim = '' then
  begin
    Result.ErrorMessage := 'Model name is empty';
    Exit;
  end;

  case Req.Provider of
    aipOpenAI:    Result := ExecuteOpenAI(Req);
    aipGemini:    Result := ExecuteGemini(Req);
    aipAnthropic: Result := ExecuteAnthropic(Req);
    aipGroq:      Result := ExecuteGroq(Req);
  end;

  if Result.Success then
    Result.Content := CleanAIResponse(Result.Content);
end;

{ ============================================================
  Execute — OpenAI
  ============================================================ }
class function TAIModelsFetcher.ExecuteOpenAI(
  const Req: TAIExecuteRequest): TAIExecuteResponse;
var
  HTTP: TIdHTTP;
  Body: TStringStream;
  JSONBody, Response: string;
begin
  Result.Success := False;
  HTTP := CreateHTTP;
  Body := TStringStream.Create('', TEncoding.UTF8);
  try
    try
      HTTP.Request.CustomHeaders.Clear;
      HTTP.Request.CustomHeaders.AddValue('Authorization', 'Bearer ' + Req.ApiKey);

      JSONBody :=
        '{"model":"' + Req.Model + '",' +
        '"messages":[{"role":"user","content":"' + EscapeJSON(Req.Prompt) + '"}],' +
        '"temperature":' + FloatToStr(Req.Temperature, TFormatSettings.Invariant) + ',' +
        '"max_tokens":' + IntToStr(Req.MaxTokens) + '}';

      Body.WriteString(JSONBody);
      Body.Position := 0;

      Response := HTTP.Post('https://api.openai.com/v1/chat/completions', Body);

      Result.Content := ExtractOpenAIText(Response);
      Result.Success := Result.Content <> '';
      if not Result.Success then
        Result.ErrorMessage := ExtractErrorMessage(Response);
    except
      on E: Exception do
        Result.ErrorMessage := 'OpenAI: ' + E.Message;
    end;
  finally
    Body.Free;
    HTTP.Free;
  end;
end;

{ ============================================================
  Execute — Gemini
  ============================================================ }
class function TAIModelsFetcher.ExecuteGemini(
  const Req: TAIExecuteRequest): TAIExecuteResponse;
var
  HTTP: TIdHTTP;
  Body: TStringStream;
  JSONBody, Response, URL: string;
begin
  Result.Success := False;
  HTTP := CreateHTTP;
  Body := TStringStream.Create('', TEncoding.UTF8);
  try
    try
      URL := 'https://generativelanguage.googleapis.com/v1beta/models/' +
             Req.Model + ':generateContent?key=' + Req.ApiKey;

      JSONBody :=
        '{"contents":[{"parts":[{"text":"' + EscapeJSON(Req.Prompt) + '"}]}],' +
        '"generationConfig":{"temperature":' +
        FloatToStr(Req.Temperature, TFormatSettings.Invariant) + ',' +
        '"maxOutputTokens":' + IntToStr(Req.MaxTokens) + '}}';

      Body.WriteString(JSONBody);
      Body.Position := 0;

      Response := HTTP.Post(URL, Body);

      Result.Content := ExtractGeminiText(Response);
      Result.Success := Result.Content <> '';
      if not Result.Success then
        Result.ErrorMessage := ExtractErrorMessage(Response);
    except
      on E: Exception do
        Result.ErrorMessage := 'Gemini: ' + E.Message;
    end;
  finally
    Body.Free;
    HTTP.Free;
  end;
end;

{ ============================================================
  Execute — Anthropic
  ============================================================ }
class function TAIModelsFetcher.ExecuteAnthropic(
  const Req: TAIExecuteRequest): TAIExecuteResponse;
var
  HTTP: TIdHTTP;
  Body: TStringStream;
  JSONBody, Response: string;
begin
  Result.Success := False;
  HTTP := CreateHTTP;
  Body := TStringStream.Create('', TEncoding.UTF8);
  try
    try
      HTTP.Request.CustomHeaders.Clear;
      HTTP.Request.CustomHeaders.AddValue('x-api-key', Req.ApiKey);
      HTTP.Request.CustomHeaders.AddValue('anthropic-version', '2023-06-01');

      JSONBody :=
        '{"model":"' + Req.Model + '",' +
        '"max_tokens":' + IntToStr(Req.MaxTokens) + ',' +
        '"temperature":' + FloatToStr(Req.Temperature, TFormatSettings.Invariant) + ',' +
        '"messages":[{"role":"user","content":"' + EscapeJSON(Req.Prompt) + '"}]}';

      Body.WriteString(JSONBody);
      Body.Position := 0;

      Response := HTTP.Post('https://api.anthropic.com/v1/messages', Body);

      Result.Content := ExtractAnthropicText(Response);
      Result.Success := Result.Content <> '';
      if not Result.Success then
        Result.ErrorMessage := ExtractErrorMessage(Response);
    except
      on E: Exception do
        Result.ErrorMessage := 'Anthropic: ' + E.Message;
    end;
  finally
    Body.Free;
    HTTP.Free;
  end;
end;

{ ============================================================
  Execute — Groq
  ============================================================ }
class function TAIModelsFetcher.ExecuteGroq(
  const Req: TAIExecuteRequest): TAIExecuteResponse;
var
  HTTP: TIdHTTP;
  Body: TStringStream;
  JSONBody, Response: string;
begin
  Result.Success := False;
  HTTP := CreateHTTP;
  Body := TStringStream.Create('', TEncoding.UTF8);
  try
    try
      HTTP.Request.CustomHeaders.Clear;
      HTTP.Request.CustomHeaders.AddValue('Authorization', 'Bearer ' + Req.ApiKey);

      JSONBody :=
        '{"model":"' + Req.Model + '",' +
        '"messages":[{"role":"user","content":"' + EscapeJSON(Req.Prompt) + '"}],' +
        '"temperature":' + FloatToStr(Req.Temperature, TFormatSettings.Invariant) + ',' +
        '"max_tokens":' + IntToStr(Req.MaxTokens) + '}';

      Body.WriteString(JSONBody);
      Body.Position := 0;

      Response := HTTP.Post('https://api.groq.com/openai/v1/chat/completions', Body);

      Result.Content := ExtractOpenAIText(Response);
      Result.Success := Result.Content <> '';
      if not Result.Success then
        Result.ErrorMessage := ExtractErrorMessage(Response);
    except
      on E: Exception do
        Result.ErrorMessage := 'Groq: ' + E.Message;
    end;
  finally
    Body.Free;
    HTTP.Free;
  end;
end;

{ ============================================================
  استخراج نصوص الردود
  ============================================================ }
class function TAIModelsFetcher.ExtractOpenAIText(const AJSON: string): string;
var
  Root, Choice, Msg: TJSONObject;
  Arr: TJSONArray;
begin
  Result := '';
  Root := TJSONObject.ParseJSONValue(AJSON) as TJSONObject;
  if not Assigned(Root) then Exit;
  try
    Arr := Root.GetValue<TJSONArray>('choices');
    if Assigned(Arr) and (Arr.Count > 0) then
    begin
      Choice := Arr.Items[0] as TJSONObject;
      if Assigned(Choice) then
      begin
        Msg := Choice.GetValue<TJSONObject>('message');
        if Assigned(Msg) then
          Result := Msg.GetValue<string>('content');
      end;
    end;
  finally
    Root.Free;
  end;
end;

class function TAIModelsFetcher.ExtractGeminiText(const AJSON: string): string;
var
  Root, Cand, Cont: TJSONObject;
  Parts: TJSONArray;
  Arr: TJSONArray;
begin
  Result := '';
  Root := TJSONObject.ParseJSONValue(AJSON) as TJSONObject;
  if not Assigned(Root) then Exit;
  try
    Arr := Root.GetValue<TJSONArray>('candidates');
    if Assigned(Arr) and (Arr.Count > 0) then
    begin
      Cand := Arr.Items[0] as TJSONObject;
      if Assigned(Cand) then
      begin
        Cont := Cand.GetValue<TJSONObject>('content');
        if Assigned(Cont) then
        begin
          Parts := Cont.GetValue<TJSONArray>('parts');
          if Assigned(Parts) and (Parts.Count > 0) then
            Result := (Parts.Items[0] as TJSONObject).GetValue<string>('text');
        end;
      end;
    end;
  finally
    Root.Free;
  end;
end;

class function TAIModelsFetcher.ExtractAnthropicText(const AJSON: string): string;
var
  Root, Item: TJSONObject;
  Arr: TJSONArray;
  I: Integer;
begin
  Result := '';
  Root := TJSONObject.ParseJSONValue(AJSON) as TJSONObject;
  if not Assigned(Root) then Exit;
  try
    Arr := Root.GetValue<TJSONArray>('content');
    if Assigned(Arr) then
      for I := 0 to Arr.Count - 1 do
      begin
        Item := Arr.Items[I] as TJSONObject;
        if Assigned(Item) and (Item.GetValue<string>('type') = 'text') then
          Result := Result + Item.GetValue<string>('text');
      end;
  finally
    Root.Free;
  end;
end;

class function TAIModelsFetcher.ExtractErrorMessage(const AJSON: string): string;
var
  Root, ErrObj: TJSONObject;
begin
  Result := 'Request failed';
  Root := TJSONObject.ParseJSONValue(AJSON) as TJSONObject;
  if not Assigned(Root) then Exit;
  try
    ErrObj := Root.GetValue<TJSONObject>('error');
    if Assigned(ErrObj) then
      Result := ErrObj.GetValue<string>('message');
  finally
    Root.Free;
  end;
end;

class function TAIModelsFetcher.EscapeJSON(const S: string): string;
begin
  Result := S;
  Result := StringReplace(Result, '\', '\\', [rfReplaceAll]);
  Result := StringReplace(Result, '"', '\"', [rfReplaceAll]);
  Result := StringReplace(Result, #13#10, '\n', [rfReplaceAll]);
  Result := StringReplace(Result, #10, '\n', [rfReplaceAll]);
  Result := StringReplace(Result, #13, '\n', [rfReplaceAll]);
  Result := StringReplace(Result, #9, '\t', [rfReplaceAll]);
end;

end.
