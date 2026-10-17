unit editor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  System.Diagnostics, ShellAPI, RzLstBox, AdvMemo, AdvmPS, dxGDIPlusClasses,
  Vcl.ExtCtrls, Vcl.Menus, AdvGlassButton, System.ImageList, Vcl.ImgList,
//<<<<<<< HEAD
  cxImageList, cxGraphics, ResizeKit, sSkinManager, AdvShapeButton,
  Vcl.Themes, Vcl.Styles, RzLaunch, Vcl.WinXCtrls, acPNG, sPanel,
  Vcl.Mask, sGroupBox, sButton, System.Generics.Collections,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore,
  dxSkinBasic, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkroom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,

  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMetropolis, dxSkinMetropolisDark, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinOffice2013DarkGray,
  dxSkinOffice2013LightGray, dxSkinOffice2013White, dxSkinOffice2016Colorful,
  dxSkinOffice2016Dark, dxSkinOffice2019Black, dxSkinOffice2019Colorful,
//<<<<<<< HEAD
  dxSkinOffice2019DarkGray, dxSkinOffice2019White, dxSkinPumpkin,
  dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringtime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinTheBezier, dxSkinsDefaultPainters,
  dxSkinValentine, dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint, dxSkinWXI,
  dxSkinXmas2008Blue, cxGeometry, dxFramedControl, dxPanel,
  IdHTTP, IdSSLOpenSSL, IdGlobal, System.JSON,
  frxClass, dxPSGlbl, dxPSUtl, dxPSEngn, dxPrnPg,

  dxBkgnd, dxWrap, dxPrnDev, dxPSCompsProvider, dxPSFillPatterns,
  dxPSEdgePatterns, dxPSPDFExportCore, dxPSPDFExport, cxDrawTextUtils,
  dxPSPrVwStd, dxPSPrVwAdv, dxPSPrVwRibbon, dxPScxPageControlProducer,
  dxPSTextLnk, dxPSImgLnk, dxPScxEditorProducers, dxPScxExtEditorProducers,
//<<<<<<< HEAD
  dxPSCore, dxPSContainerLnk, cxClasses, Data.DB,
  uDM, uBMA_AI,MMSystem;

type
  TFEditor = class(TForm)
    Memo1: TAdvMemo;
    AdvPascalMemoStyler1: TAdvPascalMemoStyler;
    MainMenu1: TMainMenu;
    F1: TMenuItem;
    o1: TMenuItem;
    h1: TMenuItem;
    Panel1: TPanel;
    AdvGlassButton1: TAdvGlassButton;
    AdvGlassButton2: TAdvGlassButton;
    Memo2: TMemo;
    AdvGlassButton3: TAdvGlassButton;
    AdvGlassButton4: TAdvGlassButton;
    SaveDialog1: TSaveDialog;
    T1: TMenuItem;
    a1: TMenuItem;
    N1: TMenuItem;
    D1: TMenuItem;
    t2: TMenuItem;
    c1: TMenuItem;
    p1: TMenuItem;
    Procedure1: TMenuItem;
    O2: TMenuItem;
    o3: TMenuItem;
    S1: TMenuItem;
    e1: TMenuItem;
    OpenDialog1: TOpenDialog;
    sSkinManager1: TsSkinManager;
    P2: TMenuItem;
    FontDialog1: TFontDialog;
    other1: TMenuItem;
    RzLauncher1: TRzLauncher;
    menuView: TPanel;
//<<<<<<< HEAD
    IconUsingAI: TImage;

    sGroupBox1: TsGroupBox;
    Memo3: TMemo;
    Button1: TAdvGlassButton;
    ToggleSwitch1: TToggleSwitch;
//<<<<<<< HEAD
    IcoPrint: TImage;
    P3: TMenuItem;
    IconApiKey: TImage;
    cxImageList1: TcxImageList;
    O4: TMenuItem;
    MyGithub: TRzLauncher;


    procedure AdvGlassButton1Click(Sender: TObject);
    procedure AdvGlassButton2Click(Sender: TObject);
    procedure AdvGlassButton3Click(Sender: TObject);
    procedure AdvGlassButton4Click(Sender: TObject);
    procedure S1Click(Sender: TObject);
    procedure o3Click(Sender: TObject);
    procedure D1Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure t2Click(Sender: TObject);
    procedure e1Click(Sender: TObject);
    procedure P2Click(Sender: TObject);
    procedure h1Click(Sender: TObject);
    procedure other1Click(Sender: TObject);
    procedure c1Click(Sender: TObject);
    procedure p1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Procedure1Click(Sender: TObject);
    procedure O2Click(Sender: TObject);
//<<<<<<< HEAD
    procedure IconUsingAIClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ToggleSwitch1Click(Sender: TObject);
    procedure IcoPrintClick(Sender: TObject);
    procedure P3Click(Sender: TObject);
    procedure IconApiKeyClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RzLauncher1Error(Sender: TObject; ErrorCode: Cardinal);
    procedure O4Click(Sender: TObject);

  private
    function RunCompiler(const SourceFile: string): string;
    procedure SetupAutoCompletion;
    function ExtractCompilerErrors(const CompilerOutput: string): string;
//<<<<<<< HEAD
    procedure RequestAICorrection(const ErroneousCode, ErrorMessage: string);
    procedure AI_ResponseReceived(const CorrectedCode: string; ShowNotification: Boolean = True);
    procedure AI_ErrorOccurred(const ErrorMsg: string; ShowNotification: Boolean = True);
    function GetActiveProviderName: string;


  public
  end;

var
//<<<<<<< HEAD
  FEditor: TFEditor;


implementation

{$R *.dfm}
//<<<<<<< HEAD

uses
  dprocess, dpipes, uapi_key, operations, info, themes, functions,
  procedures, mybooks, UmyPrint;

{ ============================================================
  الإعداد المسبق للإكمال التلقائي
  ============================================================ }
procedure TFEditor.SetupAutoCompletion;
var
  KW: string;
  Keywords: array of string;
begin
  Keywords := [
    'absolute','and','array','asm','begin','case','class','const','constructor',
    'destructor','div','do','downto','else','end','except','exports','false','file',
    'finalization','finally','for','function','goto','if','implementation','in',
    'inherited','initialization','inline','interface','is','label','library','mod',
    'nil','not','object','of','on','operator','or','packed','procedure','program',
    'property','raise','record','repeat','resourcestring','set','shl','shr','string',
    'then','threadvar','to','true','try','type','unit','until','uses','var','while',
    'with','xor','Boolean','Byte','ShortInt','SmallInt','Word','Integer','LongInt','Int64',
    'Cardinal','QWord','Single','Double','Extended','Comp','Currency','Char',
    'WideChar','PChar','String','AnsiString','WideString','Variant','TObject',
//<<<<<<< HEAD
    'TObjectClass','Pointer','PointerType','break','continue','exit','raise','try','except','finally','on',
    'read','readln','write','writeln'

  ];

  AdvPascalMemoStyler1.AutoCompletion.Clear;
  for KW in Keywords do
    AdvPascalMemoStyler1.AutoCompletion.Add(KW);
end;

//<<<<<<< HEAD
{ ============================================================
  الحصول على اسم المزود النشط
  ============================================================ }
function TFEditor.GetActiveProviderName: string;
begin
  Result := 'gemini';  // ← غيّرها لاحقًا من إعدادات المستخدم
end;

{ ============================================================
  تشغيل المُصرّف
  ============================================================ }
function TFEditor.RunCompiler(const SourceFile: string): string;
var
  Process: TProcess;
  Reader: TStreamReader;
  OutputLines: TStringList;
  Line, OutputFile: string;
begin
  Result := '';
  Process := TProcess.Create(nil);
  OutputLines := TStringList.Create;
  try
//<<<<<<< HEAD
    Process.Executable := ExtractFilePath(Application.ExeName) +
      'compiler\bin\i386-win32\fpc.exe';

    OutputFile := ChangeFileExt(SourceFile, '.exe');

    Process.Parameters.Add(SourceFile);
    Process.Parameters.Add('-o' + OutputFile);
    Process.Options := [poUsePipes, poWaitOnExit];
    Memo2.Lines.Add('🔍 Trying to run: ' + Process.Executable);

    Process.ShowWindow := swoHIDE;
    Process.Options := [poUsePipes, poWaitOnExit];

    Process.Execute;

    Reader := TStreamReader.Create(Process.Output);
    try
      while not Reader.EndOfStream do
      begin
        Line := Reader.ReadLine;
        OutputLines.Add(Line);
        Application.ProcessMessages;
      end;
    finally
      Reader.Free;
    end;

    if Process.Stderr.NumBytesAvailable > 0 then
    begin
      Reader := TStreamReader.Create(Process.Stderr);
      try
        while not Reader.EndOfStream do
        begin
          Line := Reader.ReadLine;
          OutputLines.Add('! ' + Line);
          Application.ProcessMessages;
        end;
      finally
        Reader.Free;
      end;
    end;

    Result := OutputLines.Text;
  finally
    OutputLines.Free;
    Process.Free;
  end;
end;

//<<<<<<< HEAD
procedure TFEditor.RzLauncher1Error(Sender: TObject; ErrorCode: Cardinal);
begin

end;

{ ============================================================
  استخراج الأخطاء
  ============================================================ }
function TFEditor.ExtractCompilerErrors(const CompilerOutput: string): string;
var
  Lines: TStringList;
  i: Integer;
  Line: string;
  ErrorFound: Boolean;
begin
  Result := '';
  ErrorFound := False;
  Lines := TStringList.Create;
  try
    Lines.Text := CompilerOutput;

    for i := 0 to Lines.Count - 1 do
    begin
      Line := Lines[i];
      if (Pos('Error:', Line) > 0) or
         (Pos('Fatal:', Line) > 0) or
         (Pos('error:', LowerCase(Line)) > 0) or
         (Pos('fatal:', LowerCase(Line)) > 0) or
         (Pos('warning:', LowerCase(Line)) > 0) then
      begin
        ErrorFound := True;
        Result := Result + Line + #13#10;
        if i + 1 < Lines.Count then
          Result := Result + Lines[i + 1] + #13#10;
        if i + 2 < Lines.Count then
          Result := Result + Lines[i + 2] + #13#10;
        Result := Result + '---' + #13#10;
      end
      else if (Pos('Identifier not found', Line) > 0) or
              (Pos('identifier not found', LowerCase(Line)) > 0) or
              (Pos('Syntax error', Line) > 0) or
              (Pos('syntax error', LowerCase(Line)) > 0) or
              (Pos('Illegal expression', Line) > 0) or
              (Pos('illegal expression', LowerCase(Line)) > 0) or
              (Pos('Incompatible types', Line) > 0) or
              (Pos('incompatible types', LowerCase(Line)) > 0) then
      begin
        ErrorFound := True;
        Result := Result + Line + #13#10;
      end;
    end;

    if not ErrorFound then
    begin
      if Length(CompilerOutput) > 500 then
        Result := Copy(CompilerOutput, 1, 500) + '...'
      else
        Result := CompilerOutput;
    end;

  finally
    Lines.Free;
  end;
end;

//<<<<<<< HEAD
{ ============================================================
  طلب التصحيح من AI — يعمل في خيط منفصل
  ============================================================ }
procedure TFEditor.RequestAICorrection(const ErroneousCode, ErrorMessage: string);
var
  Req: TAIExecuteRequest;
  Res: TAIExecuteResponse;
  ProviderName, ModelName, ApiKey, Prompt: string;
begin
  // 1) اقرأ المزود النشط
  ProviderName := GetActiveProviderName;

  // 2) اقرأ المفتاح والنموذج من قاعدة البيانات
  ApiKey    := TFApi_Key.GetApiKeyByProvider(ProviderName);
  ModelName := TFApi_Key.GetModelByProvider(ProviderName);

  if ApiKey.Trim = '' then
  begin
    TThread.Synchronize(nil,
      procedure
      begin
       AI_ErrorOccurred('⚠️ API key not entered for ' + ProviderName +
          ' — Open the API Key screen', True);
end);
    Exit;
  end;

  if ModelName.Trim = '' then
    ModelName := 'gemini-2.5-flash-lite';

  // 3) جهّز الطلب
  Prompt :=
    'You are a Pascal programming expert. ' +
    'Fix the code below and return ONLY the corrected code. ' +
    'Do NOT include any explanation, markdown fences, or backticks.' +
    #13#10 + #13#10 +
    'ERROR:' + #13#10 + ErrorMessage + #13#10 + #13#10 +
    'CODE:' + #13#10 + ErroneousCode;

  Req.Provider    := TAIModelsFetcher.ProviderFromString(ProviderName);
  Req.ApiKey      := ApiKey;
  Req.Model       := ModelName;
  Req.Prompt      := Prompt;
  Req.Temperature := 0.1;
  Req.MaxTokens   := 2000;

  // 4) نفّذ الطلب
  TThread.Synchronize(nil,
    procedure
    begin
     Memo2.Lines.Add('📤 Sending to ' + ProviderName + ' (' + ModelName + ')...');
    end);

  Res := TAIModelsFetcher.ExecuteAI(Req);

  // 5) اعرض النتيجة
  TThread.Synchronize(nil,
    procedure
    begin
      if Res.Success then
      begin
       Memo2.Lines.Add('✅ Received from ' + ProviderName);
        AI_ResponseReceived(Res.Content, True);
      end
      else
      begin
        Memo2.Lines.Add('❌ Failed: ' + Res.ErrorMessage);
        AI_ErrorOccurred(Res.ErrorMessage, True);
      end;
    end);
end;

{ ============================================================
  استقبال الرد
  ============================================================ }
procedure TFEditor.AI_ResponseReceived(const CorrectedCode: string;
  ShowNotification: Boolean);
begin
  Memo3.Lines.Clear;
  Memo3.Lines.Add(CorrectedCode);

  if ShowNotification then
   ShowMessage('✅ Code successfully corrected — check the AI area');
end;

procedure TFEditor.AI_ErrorOccurred(const ErrorMsg: string;
  ShowNotification: Boolean);
begin
  Memo3.Lines.Clear;
  Memo3.Lines.Add('❌ AI Error:');
  Memo3.Lines.Add(ErrorMsg);

  if ShowNotification then
    ShowMessage('❌ ' + ErrorMsg);
end;

{ ============================================================
  زر التصريف الرئيسي
  ============================================================ }
procedure TFEditor.AdvGlassButton1Click(Sender: TObject);
var
  SourceFile, OutputFile, CompilerOutput, ErrorMessages: string;
  HasErrors: Boolean;

begin
  SourceFile := ExtractFilePath(Application.ExeName) + 'temp/temp.pas';
  ForceDirectories(ExtractFilePath(SourceFile));
  Memo1.Lines.SaveToFile(SourceFile);
  OutputFile := ChangeFileExt(SourceFile, '.exe');

  CompilerOutput := RunCompiler(SourceFile);
  Memo2.Lines.Add(CompilerOutput);
  HasErrors := False;
  if (Pos('Error:', CompilerOutput) > 0) or
     (Pos('Fatal:', CompilerOutput) > 0) or
     (Pos('error', LowerCase(CompilerOutput)) > 0) or
     (Pos('identifier not found', LowerCase(CompilerOutput)) > 0) or
     (Pos('syntax error', LowerCase(CompilerOutput)) > 0) then
  begin
    HasErrors := True;
  end;

  if FileExists(OutputFile) and (not HasErrors) then
  begin
    ShowMessage('✅ Compilation successful');
    Memo3.Lines.Add('✅ Compilation successful - No errors found');
  end
  else
  begin
    if HasErrors then
    begin

      if ToggleSwitch1.State = tssOff then
      begin
        ShowMessage('❌ Compilation failed - AI correction is disabled');
        Memo3.Lines.Add('❌ Compilation failed - AI correction is disabled');
        Exit;
      end;

      ShowMessage('❌ Compilation failed - Requesting AI correction...');


      ErrorMessages := ExtractCompilerErrors(CompilerOutput);
      if ErrorMessages = 'No errors found or compilation successful.' then
        ErrorMessages := Copy(CompilerOutput, 1, 500);

      Memo2.Lines.Add('🔍 Errors detected: ' + ErrorMessages);


      // خيط منفصل
      TThread.CreateAnonymousThread(
        procedure
        begin
          RequestAICorrection(Memo1.Lines.Text, ErrorMessages);
        end
      ).Start;
    end
    else
    begin
      ShowMessage('⚠️ Compilation failed but no clear errors detected.');
      Memo3.Lines.Add('⚠️ Compilation failed - No clear errors detected');
    end;
  end;
end;


{ ============================================================
  تشغيل البرنامج المُصرّف
  ============================================================ }
procedure TFEditor.AdvGlassButton2Click(Sender: TObject);
var
  OutputFile, CommandLine: string;
begin
  OutputFile := ExtractFilePath(Application.ExeName) + 'temp\temp.exe';
  if FileExists(OutputFile) then
  begin
    CommandLine := Format('/K "%s"', [OutputFile]);
    ShellExecute(0, 'open', 'cmd.exe', PChar(CommandLine), nil, SW_SHOWNORMAL);
  end
  else
    ShowMessage('your file not found!');
end;


procedure TFEditor.AdvGlassButton3Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
    Memo1.Lines.SaveToFile(SaveDialog1.FileName + '.pas');
end;


procedure TFEditor.AdvGlassButton4Click(Sender: TObject);
begin
  Memo1.Lines.Clear;
  Memo2.Lines.Clear;
  Memo3.Lines.Clear;
end;


procedure TFEditor.Button1Click(Sender: TObject);
begin
  if Memo3.Lines.Count > 0 then
  begin
    Memo1.Lines.Text := Memo3.Lines.Text;
    ShowMessage('✅ The corrected code has been copied to the main editor');

    menuView.Width := 40;
  end
  else
    ShowMessage('❌ There is no code in memo');
end;

procedure TFEditor.o3Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    Memo1.Lines.LoadFromFile(OpenDialog1.FileName);
    ForceDirectories(ExtractFilePath(Application.ExeName) + 'temp');
    Memo1.Lines.SaveToFile(ExtractFilePath(Application.ExeName) + 'temp\temp.pas');
  end;
end;

procedure TFEditor.O4Click(Sender: TObject);
begin
MyGithub.Launch;
end;

procedure TFEditor.S1Click(Sender: TObject);

begin
  if SaveDialog1.Execute then
    Memo1.Lines.SaveToFile(SaveDialog1.FileName + '.pas');
end;

procedure TFEditor.e1Click(Sender: TObject);
begin
  Application.Terminate;
end;

{ ============================================================
  FormCreate
  ============================================================ }
procedure TFEditor.FormCreate(Sender: TObject);
begin
  sSkinManager1.SkinDirectory := ExtractFilePath(Application.ExeName) + 'Skins';
  sSkinManager1.SkinName := 'jeans';
  sSkinManager1.Active := True;
  SetupAutoCompletion;

  ForceDirectories(ExtractFilePath(Application.ExeName) + 'temp');

  // اختبار وجود DM
  if not Assigned(DM) then
  begin
    ShowMessage('❌ DataModule not initialized! Check the CreateForm order in Project.dpr');
    Application.Terminate;
    Exit;
  end;

  // الاتصال
  try
    if DM.Connect then
      Caption := 'BMA Pascal Editor v1.4 AI — Database Active ✅'
    else
      Caption := 'BMA Pascal Editor v1.4 AI — Database Disactive ❌';
  except
    on E: Exception do
    begin
      ShowMessage('❌ Database connection failed: ' + sLineBreak +
      E.Message + sLineBreak + sLineBreak +
      'Path: ' + DM.DatabasePath);
      Application.Terminate;
      Exit;
    end;
  end;

  // منطقة الذكاء الاصطناعي
  Memo3.Clear;
  Memo3.Lines.Add('📝 AI Zone');
  Memo3.Lines.Add('========================');
  Memo3.Lines.Add('Here, the automatically corrected code will appear.');
  Memo3.Lines.Add('Click "Copy Code" to move it to the main editor.');
end;

procedure TFEditor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Application.MainForm = Self then
  begin
    if Assigned(DM) then
      DM.Disconnect;
  end;
end;

{ ============================================================
  التبديل بين السكينات
  ============================================================ }
procedure TFEditor.D1Click(Sender: TObject);

begin
  sSkinManager1.SkinDirectory := ExtractFilePath(Application.ExeName) + 'Skins';
  sSkinManager1.SkinName := 'Terminal4bit';
  sSkinManager1.Active := True;
  Memo1.BkColor := clblack;
  Memo1.Gutter.GutterColor := clblack;
  Memo1.Gutter.GutterColorTo := clblack;
  Memo1.Gutter.LineNumberTextColor := clwhite;
  D1.Checked := true;
  N1.Checked := false;
end;

procedure TFEditor.N1Click(Sender: TObject);
begin
  sSkinManager1.SkinDirectory := ExtractFilePath(Application.ExeName) + 'Skins';
  sSkinManager1.SkinName := 'Fluent White';
  sSkinManager1.Active := True;
  Memo1.BkColor := clwhite;
  Memo1.Gutter.GutterColor := clwhite;
  Memo1.Gutter.GutterColorTo := clwhite;
  Memo1.Gutter.LineNumberTextColor := clblack;
  N1.Checked := true;
  D1.Checked := false;
end;

{ ============================================================
  أحداث القوائم
  ============================================================ }
procedure TFEditor.O2Click(Sender: TObject);
begin
  RzLauncher1.Execute;
end;

procedure TFEditor.c1Click(Sender: TObject);
begin
  form4.Show;
end;

procedure TFEditor.h1Click(Sender: TObject);
begin
  form3.Show;
end;


procedure TFEditor.other1Click(Sender: TObject);
begin
  form7.Show;
end;

procedure TFEditor.p1Click(Sender: TObject);
begin
  form5.Show;
end;

procedure TFEditor.Procedure1Click(Sender: TObject);
begin
  f_myBooks.show;
end;

procedure TFEditor.t2Click(Sender: TObject);
begin
  Foperations.Show;
end;

procedure TFEditor.P2Click(Sender: TObject);
begin
  if FontDialog1.Execute then
    Memo1.Font := FontDialog1.Font;
end;

{ ============================================================
  عرض/إخفاء لوحة AI
  ============================================================ }
procedure TFEditor.IconUsingAIClick(Sender: TObject);
begin
  if menuView.Width = 40 then
    menuView.Width := 220
  else if menuView.Width = 220 then
    menuView.Width := 40;
end;

{ ============================================================
  حفظ الكود في قاعدة البيانات
  ============================================================ }
procedure TFEditor.IcoPrintClick(Sender: TObject);
begin
  if not Assigned(DM) or not DM.FDConnection.Connected then
  begin
   ShowMessage('❌ Database is not connected!');
    Exit;
  end;

  if Memo1.Lines.Text.Trim = '' then
  begin
    ShowMessage('⚠️ No code to save!');
    Memo1.SetFocus;
    Exit;
  end;

  if not Assigned(FmyPrint) then
    FmyPrint := TFmyPrint.Create(Application);

  try
    FmyPrint.PrepareNewCode(Memo1.Lines.Text);
    FmyPrint.Show;
    FmyPrint.BringToFront;
    FmyPrint.DbTitle.SetFocus;
  except
    on E: Exception do
      ShowMessage('❌ Failed to open the save window: ' + E.Message);
  end;

  ShowMessage('📝 Please enter the code title (Title_Code)');
end;

procedure TFEditor.P3Click(Sender: TObject);
begin
  if not Assigned(DM) or not DM.FDConnection.Connected then
  begin
   ShowMessage('❌ Database is not connected!');
    Exit;
  end;

  if Memo1.Lines.Text.Trim = '' then
  begin
    ShowMessage('⚠️ No code to save!');
    Memo1.SetFocus;
    Exit;
end;
end;

{ ============================================================
  شاشة API Key
  ============================================================ }
procedure TFEditor.IconApiKeyClick(Sender: TObject);
begin
  fapi_key.ShowModal;
end;

{ ============================================================
  Toggle Switch
  ============================================================ }
procedure TFEditor.ToggleSwitch1Click(Sender: TObject);
begin
  if ToggleSwitch1.State = tssOff then
  begin
    ToggleSwitch1.FrameColor := clred;
    ToggleSwitch1.ThumbColor := clred;
    ToggleSwitch1.Font.Color := clred;
  end
  else
  begin
    ToggleSwitch1.FrameColor := clgreen;
    ToggleSwitch1.ThumbColor := clgreen;
    ToggleSwitch1.Font.Color := clgreen;
  end;

end;

end.
