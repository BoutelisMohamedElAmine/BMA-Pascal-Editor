unit UApi_Key;


interface

uses

  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Data.DB, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls,
  AdvGlassButton, ResizeKit,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet,
  uDM, uBMA_AI;

type
  TFApi_Key = class(TForm)
    AdvGlassButton1: TAdvGlassButton;   // زر الحفظ
    DBEdit1: TDBEdit;                    // حقل المفتاح
    show_hide: TCheckBox;                // إظهار/إخفاء
    Panel1: TPanel;                      // شريط الحالة
    ResizeKit1: TResizeKit;
    DataSource1: TDataSource;            // مصدر البيانات
    ComboBox1: TComboBox;                // اختيار المزود (غير مربوط)
    DBComboBox1: TDBComboBox;            // اختيار النموذج (مربوط)

    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure show_hideClick(Sender: TObject);
    procedure AdvGlassButton1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private
    FQuery: TFDQuery;
    FModelsLoading: Boolean;

    procedure LoadProvider(const AProvider: string);
    procedure LoadModelsForProvider(const AProvider: string);
    procedure PopulateFallbackModels(const AProvider: string; const ACurrentModel: string);
    procedure UpdateStatus(const AMessage: string; AIsError: Boolean = False);

  public
    class function GetApiKeyByProvider(const AProvider: string): string;
    class function GetModelByProvider(const AProvider: string): string;
     procedure DiagnoseFetch;

  end;

var
  FApi_Key: TFApi_Key;

implementation

{$R *.dfm}


const
  PROVIDERS: array[0..3] of string = ('openai', 'gemini', 'anthropic', 'groq');






  procedure TFApi_Key.DiagnoseFetch;
var
  Res: TAIModelsResult;
  ApiKey: string;
  Msg: string;
begin
  ApiKey := FQuery.FieldByName('api_key').AsString;

  Msg := 'Diagnostics:' + sLineBreak;
  Msg := Msg + 'Provider: ' + FQuery.FieldByName('provider').AsString + sLineBreak;
  Msg := Msg + 'API Key Length: ' + IntToStr(Length(ApiKey)) + sLineBreak;
  Msg := Msg + 'API Key Preview: ' + Copy(ApiKey, 1, 8) + '...' + sLineBreak;
  Msg := Msg + '---' + sLineBreak;

  if ApiKey.Trim = '' then
  begin
   Msg := Msg + '❌ The key is empty! Enter it first.';
    ShowMessage(Msg);
    Exit;
  end;

  // جلب بدون Cache لاختبار الاتصال الحقيقي
  Res := TAIModelsFetcher.Fetch(
    TAIModelsFetcher.ProviderFromString(FQuery.FieldByName('provider').AsString),
    ApiKey,
    False  // لا تستخدم Cache
  );

 if Res.Success then
Msg := Msg + '✅ Success! Number of models: ' + IntToStr(Length(Res.Models))
else
begin
Msg := Msg + '❌ Failed:' + sLineBreak + Res.ErrorMessage;
end;

  ShowMessage(Msg);
end;








{ ============================================================
  إنشاء النموذج
  ============================================================ }
procedure TFApi_Key.FormCreate(Sender: TObject);
begin
  // 1) تحقق من DataModule
  if not Assigned(DM) then
  begin
    ShowMessage('❌ DataModule was not initialized!');
    Exit;
  end;

  if not DM.FDConnection.Connected then
  begin
    try
      DM.Connect;
    except
      on E: Exception do
      begin
        ShowMessage('❌ Connection failed: ' + E.Message);
        Exit;
      end;
    end;
  end;

  // 2) قائمة المزودين
  ComboBox1.Items.Clear;
  ComboBox1.Items.Add('openai');
  ComboBox1.Items.Add('gemini');
  ComboBox1.Items.Add('anthropic');
  ComboBox1.Items.Add('groq');
  ComboBox1.Style := csDropDownList;

  // 3) إنشاء الاستعلام (يعرض صف مزود واحد في كل مرة)
  FQuery := TFDQuery.Create(Self);
  FQuery.Connection := DM.FDConnection;
  FQuery.SQL.Text :=
    'SELECT n_fix, provider, api_key, model_name ' +
    'FROM My_Api_Key WHERE provider = :p LIMIT 1';

  // 4) ربط المكونات
  DataSource1.DataSet := FQuery;

  DBEdit1.DataSource := DataSource1;
  DBEdit1.DataField  := 'api_key';

  DBComboBox1.DataSource := DataSource1;
  DBComboBox1.DataField  := 'model_name';

  // 5) إخفاء المفتاح افتراضيًا
  DBEdit1.PasswordChar := '*';
  show_hide.Checked := False;
  show_hide.Caption := 'Show Api_Key';

  // 6) اختر Gemini افتراضيًا
  ComboBox1.ItemIndex := 1;
  LoadProvider('gemini');
end;

procedure TFApi_Key.FormDestroy(Sender: TObject);
begin
 if Assigned(FQuery) then
  begin
    if FQuery.Active then FQuery.Close;
    FreeAndNil(FQuery);
  end;
end;

procedure TFApi_Key.FormShow(Sender: TObject);
begin
 // أعد تحميل بيانات المزود الحالي إن كان النموذج جاهزًا
 if Assigned(FQuery) and (ComboBox1.ItemIndex >= 0) then
    LoadProvider(ComboBox1.Text);
end;

{ ============================================================
  تغيير المزود من ComboBox1
  ============================================================ }
procedure TFApi_Key.ComboBox1Change(Sender: TObject);
begin
  if ComboBox1.ItemIndex < 0 then Exit;
  LoadProvider(ComboBox1.Text);
end;

{ ============================================================
  تحميل بيانات مزود معيّن
  ============================================================ }
procedure TFApi_Key.LoadProvider(const AProvider: string);
begin
  if not Assigned(FQuery) then Exit;

  // احفظ أي تعديل معلّق
  try
    if FQuery.State in [dsEdit, dsInsert] then
      FQuery.Post;
  except
  end;

  // افتح على المزود الجديد
  FQuery.Close;
  FQuery.ParamByName('p').AsString := AProvider;
  FQuery.Open;

  // إن لم يوجد صف (نظريًا لن يحدث بفضل UNIQUE)، أنشئه
  if FQuery.IsEmpty then
  begin
    FQuery.Insert;
    FQuery.FieldByName('provider').AsString   := AProvider;
    FQuery.FieldByName('api_key').AsString    := '';
    FQuery.FieldByName('model_name').AsString := '';
    FQuery.Post;

    LoadProvider(AProvider);
    Exit;
  end;

  // حدّث العنوان
  Panel1.Caption := 'Your Api_Key (' + AProvider + ') :';

  // حمّل النماذج ديناميكيًا
  LoadModelsForProvider(AProvider);
end;

{ ============================================================
  تحميل النماذج من الإنترنت عبر uAIModels
  ============================================================ }
procedure TFApi_Key.LoadModelsForProvider(const AProvider: string);
var
  ProvType: TAIProvider;
  ApiKey, CurrentModel: string;
begin
  if FModelsLoading then Exit;
  FModelsLoading := True;

  ProvType     := TAIModelsFetcher.ProviderFromString(AProvider);
  ApiKey       := FQuery.FieldByName('api_key').AsString;
  CurrentModel := FQuery.FieldByName('model_name').AsString;

  DBComboBox1.Items.Clear;
  DBComboBox1.Enabled := False;

  // ⚠️ إذا لم يكن هناك مفتاح، لا تحاول الجلب — اطلبه من المستخدم
  if ApiKey.Trim = '' then
  begin
    FModelsLoading := False;
    DBComboBox1.Items.Add('🔑 Enter the key first, then click Save');
DBComboBox1.Enabled := True;
UpdateStatus('🔑 Enter the ' + AProvider + ' key in the field, then click Save', True);
Exit;
  end;

  // ✅ المفتاح موجود → ابدأ الجلب
 DBComboBox1.Items.Add('⏳ Loading templates...');
UpdateStatus('⏳ Loading ' + AProvider + ' templates...');

  TAIModelsFetcher.FetchAsync(ProvType, ApiKey,
    procedure(const AResult: TAIModelsResult)
    var
      Models: TArray<TAIModelInfo>;
      M: TAIModelInfo;
      Idx: Integer;
    begin
      FModelsLoading := False;
      DBComboBox1.Items.Clear;
      DBComboBox1.Enabled := True;

      if Length(AResult.Models) = 0 then
      begin
        PopulateFallbackModels(AProvider, CurrentModel);
       UpdateStatus('⚠️ Retrieval failed — fallback list', True);
        Exit;
      end;

      Models := TAIModelsFetcher.FilterChatModels(AResult.Models);
      for M in Models do
        DBComboBox1.Items.Add(M.Id);

      if CurrentModel <> '' then
      begin
        Idx := DBComboBox1.Items.IndexOf(CurrentModel);
        if Idx >= 0 then
          DBComboBox1.ItemIndex := Idx
        else
          DBComboBox1.Items.Insert(0, CurrentModel);
      end;

       if AResult.FromCache then
          UpdateStatus(Format('✅ %d models (%s) — from cache',
          [Length(Models), AProvider]))
       else
          UpdateStatus(Format('✅ %d models (%s) — from the Internet',
          [Length(Models), AProvider]));
    end,
    True
  );
end;

{ ============================================================
  قائمة احتياطية عند فشل الإنترنت
  ============================================================ }
procedure TFApi_Key.PopulateFallbackModels(const AProvider: string;
  const ACurrentModel: string);
begin
  DBComboBox1.Items.Clear;

  if SameText(AProvider, 'openai') then
    DBComboBox1.Items.AddStrings([
      'gpt-4o-mini', 'gpt-4o', 'gpt-4-turbo', 'gpt-3.5-turbo'])
  else if SameText(AProvider, 'gemini') then
    DBComboBox1.Items.AddStrings([
      'gemini-2.5-flash-lite', 'gemini-2.5-flash',
      'gemini-2.5-pro', 'gemini-2.0-flash'])
  else if SameText(AProvider, 'anthropic') then
    DBComboBox1.Items.AddStrings([
      'claude-3-5-sonnet-20241022', 'claude-3-5-haiku-20241022',
      'claude-3-opus-20240229'])
  else if SameText(AProvider, 'groq') then
    DBComboBox1.Items.AddStrings([
      'llama-3.3-70b-versatile', 'llama-3.1-8b-instant',
      'mixtral-8x7b-32768']);

  // استعد النموذج المحفوظ إن وُجد
  if (ACurrentModel <> '') and (DBComboBox1.Items.IndexOf(ACurrentModel) < 0) then
    DBComboBox1.Items.Insert(0, ACurrentModel);

  if (ACurrentModel <> '') and (DBComboBox1.Items.IndexOf(ACurrentModel) >= 0) then
    DBComboBox1.ItemIndex := DBComboBox1.Items.IndexOf(ACurrentModel);
end;

{ ============================================================
  شريط الحالة
  ============================================================ }
procedure TFApi_Key.UpdateStatus(const AMessage: string; AIsError: Boolean);
begin
  Panel1.Caption := AMessage;
  if AIsError then
    Panel1.Font.Color := clRed
  else
    Panel1.Font.Color := clGreen;
end;

{ ============================================================
  عند تغيير السجل (اختياري)
  ============================================================ }
procedure TFApi_Key.DataSource1DataChange(Sender: TObject; Field: TField);
begin
  // لا نحتاج فعل شيء هنا حاليًا
end;

{ ============================================================
  زر الحفظ
  ============================================================ }
procedure TFApi_Key.AdvGlassButton1Click(Sender: TObject);
var
  ProviderName: string;
begin
  if not Assigned(FQuery) or FQuery.IsEmpty then
  begin
    ShowMessage('⚠️ No provider selected');
    Exit;
  end;

  try
    FQuery.Edit;
    FQuery.FieldByName('api_key').AsString    := DBEdit1.Text;
    FQuery.FieldByName('model_name').AsString := DBComboBox1.Text;
    FQuery.Post;

    ProviderName := FQuery.FieldByName('provider').AsString;

    // امسح الـ Cache لأن المفتاح تغيّر
    TAIModelsFetcher.ClearCache(
      TAIModelsFetcher.ProviderFromString(ProviderName));

    UpdateStatus('✅ Key for ' + ProviderName + ' saved', False);

    // 🌟 الأهم: اجلب النماذج الآن بعد الحفظ
    LoadModelsForProvider(ProviderName);

  except
    on E: Exception do
     ShowMessage('❌ Save failed: ' + E.Message);
  end;
end;

{ ============================================================
  إظهار / إخفاء المفتاح
  ============================================================ }
procedure TFApi_Key.show_hideClick(Sender: TObject);
begin
  if show_hide.Checked then
  begin
    DBEdit1.PasswordChar := #0;
    show_hide.Caption := 'Hide Api_Key';
  end
  else
  begin
    DBEdit1.PasswordChar := '*';
    show_hide.Caption := 'Show Api_Key';
  end;
end;

{ ============================================================
  إغلاق نظيف
  ============================================================ }
procedure TFApi_Key.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // احفظ أي تعديل معلّق فقط — لا تحرّر FQuery
  try
    if Assigned(FQuery) and FQuery.Active and
       (FQuery.State in [dsEdit, dsInsert]) then
      FQuery.Post;
  except
    // تجاهل
  end;

  // لا نُغلق FQuery ولا نُحرّره — يبقى جاهزًا للفتح التالي
end;

{ ============================================================
  دوال مساعدة للاستخدام من وحدات أخرى
  ============================================================ }
class function TFApi_Key.GetApiKeyByProvider(const AProvider: string): string;
var
  Q: TFDQuery;
begin
  Result := '';
  if not Assigned(DM) or not DM.FDConnection.Connected then Exit;

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := DM.FDConnection;
    Q.SQL.Text := 'SELECT api_key FROM My_Api_Key WHERE provider = :p LIMIT 1';
    Q.ParamByName('p').AsString := AProvider;
    Q.Open;
    if not Q.IsEmpty then
      Result := Q.FieldByName('api_key').AsString;
  finally
    Q.Free;
  end;
end;

class function TFApi_Key.GetModelByProvider(const AProvider: string): string;
var
  Q: TFDQuery;
begin
  Result := '';
  if not Assigned(DM) or not DM.FDConnection.Connected then Exit;

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := DM.FDConnection;
    Q.SQL.Text := 'SELECT model_name FROM My_Api_Key WHERE provider = :p LIMIT 1';
    Q.ParamByName('p').AsString := AProvider;
    Q.Open;
    if not Q.IsEmpty then
      Result := Q.FieldByName('model_name').AsString;
  finally
    Q.Free;

  end;
end;

end.
