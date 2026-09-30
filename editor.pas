unit editor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  System.Diagnostics, ShellAPI, RzLstBox, AdvMemo, AdvmPS, dxGDIPlusClasses,
  Vcl.ExtCtrls, Vcl.Menus, AdvGlassButton, System.ImageList, Vcl.ImgList,
  cxImageList, cxGraphics, ResizeKit, sSkinManager, AdvShapeButton, Vcl.Themes, Vcl.Styles,
  RzLaunch, Vcl.WinXCtrls, acPNG, sPanel, Vcl.Mask, sGroupBox, sButton,System.Generics.Collections,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinBasic,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkroom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMetropolis, dxSkinMetropolisDark, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinOffice2013DarkGray,
  dxSkinOffice2013LightGray, dxSkinOffice2013White, dxSkinOffice2016Colorful,
  dxSkinOffice2016Dark, dxSkinOffice2019Black, dxSkinOffice2019Colorful,
  dxSkinOffice2019DarkGray, dxSkinOffice2019White, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringtime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinTheBezier, dxSkinsDefaultPainters, dxSkinValentine,
  dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint, dxSkinWXI,
  dxSkinXmas2008Blue, cxGeometry, dxFramedControl, dxPanel, IdHTTP, IdSSLOpenSSL,
  IdGlobal, System.JSON, frxClass, dxPSGlbl, dxPSUtl, dxPSEngn, dxPrnPg,
  dxBkgnd, dxWrap, dxPrnDev, dxPSCompsProvider, dxPSFillPatterns,
  dxPSEdgePatterns, dxPSPDFExportCore, dxPSPDFExport, cxDrawTextUtils,
  dxPSPrVwStd, dxPSPrVwAdv, dxPSPrVwRibbon, dxPScxPageControlProducer,
  dxPSTextLnk, dxPSImgLnk, dxPScxEditorProducers, dxPScxExtEditorProducers,
  dxPSCore, dxPSContainerLnk, cxClasses, Data.DB, Data.Win.ADODB
  ;

type
  TForm1 = class(TForm)
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
    Image1: TImage;
    sGroupBox1: TsGroupBox;
    Memo3: TMemo;
    Button1: TAdvGlassButton;
    ToggleSwitch1: TToggleSwitch;
    Image2: TImage;
    P3: TMenuItem;
    Image3: TImage;
    ADOConnection2: TADOConnection;
    ADOTable2: TADOTable;
    DataSource2: TDataSource;
    ADOTable2api_key: TWideMemoField;
    cxImageList1: TcxImageList;
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
    procedure Image1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ToggleSwitch1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure P3Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
  private
    function RunCompiler(const SourceFile: string): string;
    procedure SetupAutoCompletion;
    function ExtractCompilerErrors(const CompilerOutput: string): string;
    function CorrectCodeWithAI(const ErroneousCode, ErrorMessage: string): string;
    procedure AI_ResponseReceived(const CorrectedCode: string; ShowNotification: Boolean = True);
    procedure AI_ErrorOccurred(const ErrorMsg: string; ShowNotification: Boolean = True);
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
uses dprocess, dpipes,uapi_key, operations, info, themes, functions, procedures, mybooks,UmyPrint;

procedure TForm1.SetupAutoCompletion;
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
    'TObjectClass','Pointer','PointerType','break','continue','exit','raise','try','except','finally','on'
    ,'read','readln','write','writeln'
  ];

  AdvPascalMemoStyler1.AutoCompletion.Clear;
  for KW in Keywords do
    AdvPascalMemoStyler1.AutoCompletion.Add(KW);
end;

function TForm1.RunCompiler(const SourceFile: string): string;
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
    Process.Executable := ExtractFilePath(Application.ExeName) + 'compiler\bin\i386-win32\fpc.exe';

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

function TForm1.ExtractCompilerErrors(const CompilerOutput: string): string;
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

      // البحث عن أسطر الأخطاء في مخرجات FPC (باستخدام حالة غير حساسة)
      if (Pos('Error:', Line) > 0) or
         (Pos('Fatal:', Line) > 0) or
         (Pos('error:', LowerCase(Line)) > 0) or
         (Pos('fatal:', LowerCase(Line)) > 0) or
         (Pos('warning:', LowerCase(Line)) > 0) then
      begin
        ErrorFound := True;
        // أخذ السطر الحالي والخطين التاليين
        Result := Result + Line + #13#10;
        if i + 1 < Lines.Count then
          Result := Result + Lines[i + 1] + #13#10;
        if i + 2 < Lines.Count then
          Result := Result + Lines[i + 2] + #13#10;
        Result := Result + '---' + #13#10;
      end
      // أسطر الأخطاء النموذجية في FPC
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
      // إذا لم نجد أخطاء محددة، نعيد جزءًا من المخرجات
      if Length(CompilerOutput) > 500 then
        Result := Copy(CompilerOutput, 1, 500) + '...'
      else
        Result := CompilerOutput;
    end;

  finally
    Lines.Free;
  end;
end;

 ///////////////////////////////////////////////function ai
function TForm1.CorrectCodeWithAI(const ErroneousCode, ErrorMessage: string): string;
var
  HTTP: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  RequestBody: TStringStream;
  Response: string;
  API_Key: string;
  JSONStr: string;
  StartPos, EndPos: Integer;
begin
  Result := '';
  API_Key := FApi_Key.DBEdit1.Text;

  HTTP := TIdHTTP.Create(nil);
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(HTTP);
  RequestBody := TStringStream.Create('', TEncoding.UTF8);

  try
    try
      // إعدادات SSL للاتصال بـ Google API
      SSL.SSLOptions.Method := sslvTLSv1_2;
      SSL.SSLOptions.SSLVersions := [sslvTLSv1_2];

      HTTP.IOHandler := SSL;
      HTTP.Request.ContentType := 'application/json';
      HTTP.Request.CharSet := 'utf-8';

      // تنظيف النصوص من الرموز التي تفسد JSON
      JSONStr := '{' +
        '"contents": [{' +
          '"parts": [{' +
            '"text": "Fix this Pascal code error. Return ONLY the corrected code without explanation. \\n\\n' +
            'Error: ' + StringReplace(ErrorMessage, '"', '\"', [rfReplaceAll]) + '\\n\\n' +
            'Code:\\n' + StringReplace(StringReplace(ErroneousCode, #13#10, '\\n', [rfReplaceAll]), '"', '\"', [rfReplaceAll]) + '"' +
          '}]' +
        '}],' +
        '"generationConfig": {' +
          '"temperature": 0.1,' +
          '"maxOutputTokens": 2000' +
        '}' +
      '}';

      Memo2.Lines.Add('📤 Submit a request to Google Gemini...');
      Memo2.Lines.Add('JSON length: ' + IntToStr(Length(JSONStr)));

      RequestBody.WriteString(JSONStr);
      RequestBody.Position := 0;

      try
        Response := HTTP.Post(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent?key=' + API_Key,
          RequestBody
        );

        Memo2.Lines.Add('✅ Reply received from Gemini');
        Memo2.Lines.Add('Length of text: ' + IntToStr(Length(Response)));

        // استخراج النص
        StartPos := Pos('"text": "', Response);
        if StartPos > 0 then
        begin
          StartPos := StartPos + 9;

          // البحث عن نهاية النص (مع التعامل مع الـ escape sequences)
          EndPos := StartPos;
          var InEscape := False;

          while EndPos <= Length(Response) do
          begin
            if Response[EndPos] = '\' then
              InEscape := True
            else if (Response[EndPos] = '"') and not InEscape then
              Break
            else
              InEscape := False;

            Inc(EndPos);
          end;

          if EndPos > StartPos then
          begin
            Result := Copy(Response, StartPos, EndPos - StartPos);

            // تحويل الـ Newlines من تنسيق JSON إلى Delphi
            Result := StringReplace(Result, '\n', #13#10, [rfReplaceAll]);
            Result := StringReplace(Result, '\r', #13, [rfReplaceAll]);
            Result := StringReplace(Result, '\t', #9, [rfReplaceAll]);
            Result := StringReplace(Result, '\"', '"', [rfReplaceAll]);
            Result := StringReplace(Result, '\\', '\', [rfReplaceAll]);

            // استدعاء الإجراءات الموجودة في TForm1
            AI_ResponseReceived(Result, False); // لا تعرض إشعار هنا
          end
          else
          begin
            AI_ErrorOccurred('No text was found in the reply', False);
          end;
        end
        else
        begin
          // إذا لم نجد "text": "، قد يكون هناك خطأ
          if Pos('"error":', Response) > 0 then
          begin
            var ErrorPos := Pos('"message": "', Response);
            if ErrorPos > 0 then
            begin
              ErrorPos := ErrorPos + 12;
              var ErrorEnd := Pos('"', Response, ErrorPos + 1);
              if ErrorEnd > ErrorPos then
                AI_ErrorOccurred('Error from Gemini:' + Copy(Response, ErrorPos, ErrorEnd - ErrorPos), False)
              else
                AI_ErrorOccurred('An unexpected response from Gemini', False);
            end;
          end
          else
          begin
            AI_ErrorOccurred('The response format is unexpected.', False);
          end;
        end;

      except
        on E: EIdHTTPProtocolException do
        begin
          Memo2.Lines.Add('❌ HTTP Error:' + E.Message);
          Memo2.Lines.Add('Error code:' + IntToStr(E.ErrorCode));
          AI_ErrorOccurred('Connection error:' + E.Message + ' (code: ' + IntToStr(E.ErrorCode) + ')', False);
        end;
        on E: Exception do
        begin
          Memo2.Lines.Add('❌ Error:' + E.Message);
          AI_ErrorOccurred('Error: ' + E.Message, False);
        end;
      end;

    except
      on E: Exception do
      begin
        Memo2.Lines.Add('❌ Connection setup error:' + E.Message);
        AI_ErrorOccurred('Setup error:' + E.Message, False);
      end;
    end;

  finally
    RequestBody.Free;
    HTTP.Free;
  end;
end;

procedure TForm1.AI_ResponseReceived(const CorrectedCode: string; ShowNotification: Boolean = True);
begin
  Memo3.Lines.Clear;
  Memo3.Lines.Add(CorrectedCode);

  // عرض إشعار فقط إذا طُلب ذلك
  if ShowNotification then
    ShowMessage('✅ The code has been successfully corrected!');
end;

procedure TForm1.AI_ErrorOccurred(const ErrorMsg: string; ShowNotification: Boolean = True);
begin
  Memo3.Lines.Clear;
  Memo3.Lines.Add('❌ Artificial intelligence error:');
  Memo3.Lines.Add(ErrorMsg);

  // عرض إشعار فقط إذا طُلب ذلك
  if ShowNotification then
    ShowMessage('❌ ' + ErrorMsg);
end;

procedure TForm1.AdvGlassButton1Click(Sender: TObject);
var
  SourceFile, OutputFile, CompilerOutput, ErrorMessages: string;
  Thread: TThread;
  HasErrors: Boolean;
begin
  SourceFile := ExtractFilePath(Application.ExeName) + 'temp/temp.pas';
  ForceDirectories(ExtractFilePath(SourceFile));
  Memo1.Lines.SaveToFile(SourceFile);
  OutputFile := ChangeFileExt(SourceFile, '.exe');

  CompilerOutput := RunCompiler(SourceFile);
  memo2.Lines.Add(CompilerOutput);

  // تحقق مما إذا كان هناك أخطاء في المخرجات
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
      // تحقق من حالة ToggleSwitch1 - إذا كان مغلقاً لا تطلب التصحيح التلقائي
      if ToggleSwitch1.State = tssOff then
      begin
        ShowMessage('❌ Compilation failed - AI correction is disabled (ToggleSwitch is OFF)');
        Memo3.Lines.Add('❌ Compilation failed - AI correction is disabled');
        Exit;
      end;

      ShowMessage('❌ Compilation failed - Requesting AI correction...');

      // استخراج الأخطاء
      ErrorMessages := ExtractCompilerErrors(CompilerOutput);

      // إذا لم نحصل على أخطاء محددة، أضف المخرجات الكاملة
      if ErrorMessages = 'No errors found or compilation successful.' then
        ErrorMessages := Copy(CompilerOutput, 1, 500);

      Memo2.Lines.Add('🔍 Errors detected: ' + ErrorMessages);

      // استخدام خيط منفصل للاتصال بالذكاء الاصطناعي
      Thread := TThread.CreateAnonymousThread(
        procedure
        var
          CorrectedCode: string;
        begin
          CorrectedCode := CorrectCodeWithAI(Memo1.lines.Text, ErrorMessages);

          TThread.Synchronize(nil,
            procedure
            begin
              if CorrectedCode <> '' then
                AI_ResponseReceived(CorrectedCode, True) // تعرض إشعار هنا فقط
              else
                AI_ErrorOccurred('Failure to obtain a correction from artificial intelligence', True);
            end);
        end);
      Thread.Start;
    end
    else
    begin
      ShowMessage('⚠️ Compilation failed but no clear errors detected.');
      Memo3.Lines.Add('⚠️ Compilation failed - No clear errors detected');
    end;
  end;
end;

procedure TForm1.AdvGlassButton2Click(Sender: TObject);
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

procedure TForm1.AdvGlassButton3Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
    Memo1.Lines.SaveToFile(SaveDialog1.FileName + '.pas');
end;

procedure TForm1.AdvGlassButton4Click(Sender: TObject);
begin
  Memo1.Lines.Clear;
  Memo2.Lines.Clear;
  Memo3.Lines.Clear;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  // نسخ الكود من Memo3 إلى Memo1 (المحرر الرئيسي)
  if Memo3.Lines.Count > 0 then
  begin
    Memo1.Lines.Text := Memo3.Lines.Text;
    ShowMessage('✅ The corrected code has been copied to the main editor');
    menuView.Width:=40;
  end
  else
    ShowMessage('❌ There is no code in memo');
end;

procedure TForm1.o3Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    Memo1.Lines.LoadFromFile(OpenDialog1.FileName);
    ForceDirectories(ExtractFilePath(Application.ExeName) + 'temp');
    Memo1.Lines.SaveToFile(ExtractFilePath(Application.ExeName) + 'temp\temp.pas');
  end;
end;

procedure TForm1.S1Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
    Memo1.Lines.SaveToFile(SaveDialog1.FileName + '.pas');
end;

procedure TForm1.e1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  sSkinManager1.SkinDirectory := ExtractFilePath(Application.ExeName) + 'Skins';
  sSkinManager1.SkinName := 'jeans';
  sSkinManager1.Active := True;
  SetupAutoCompletion;

  ForceDirectories(ExtractFilePath(Application.ExeName) + 'temp');

   ADOConnection2.Connected:=false;
  ADOConnection2.ConnectionString:=ExtractFilePath(Application.ExeName)+'database.mdb';
  ADOConnection2.Connected:=true;
  Adotable2.active:=true;



  Memo3.Clear;
  Memo3.Lines.Add('📝 AI Zone');
  Memo3.Lines.Add('========================');
  Memo3.Lines.Add('Here, the automatically corrected code will appear when errors are found.');
  Memo3.Lines.Add('Click "Copy Code" to move it to the main editor.');




  end;

procedure TForm1.D1Click(Sender: TObject);
begin
  sSkinManager1.SkinDirectory := ExtractFilePath(Application.ExeName) + 'Skins';
  sSkinManager1.SkinName := 'Terminal4bit';
  sSkinManager1.Active := True;
  Memo1.BkColor:=clblack;
  Memo1.Gutter.GutterColor:=clblack;
  Memo1.Gutter.GutterColorTo:=clblack;
  Memo1.Gutter.LineNumberTextColor:=clwhite;
  D1.Checked:=true;
  N1.Checked:=false;
end;

procedure TForm1.N1Click(Sender: TObject);
begin
  sSkinManager1.SkinDirectory := ExtractFilePath(Application.ExeName) + 'Skins';
  sSkinManager1.SkinName := 'Fluent White';
  sSkinManager1.Active := True;
  Memo1.BkColor:=clwhite;
  Memo1.Gutter.GutterColor:=clwhite;
  Memo1.Gutter.GutterColorTo:=clwhite;
  Memo1.Gutter.LineNumberTextColor:=clblack;
  N1.Checked:=true;
  D1.Checked:=false;
end;

procedure TForm1.O2Click(Sender: TObject);
begin
  RzLauncher1.Execute;
end;

procedure TForm1.c1Click(Sender: TObject);
begin
  form4.Show;
end;

procedure TForm1.h1Click(Sender: TObject);
begin
  form3.Show;
end;

procedure TForm1.Image1Click(Sender: TObject);
begin
  if menuView.Width=40 then
    menuView.Width:=220
  else if menuView.Width=220 then
    menuView.Width:=40;
end;

procedure TForm1.Image2Click(Sender: TObject);
begin
Fmyprint.show;
FmyPrint.ADOTable1.Append;
fmyprint.Timer1.enabled:=true;
 showmessage('Add Title Code Please !!');
end;

procedure TForm1.Image3Click(Sender: TObject);
begin
fapi_key.ShowModal;
end;

procedure TForm1.other1Click(Sender: TObject);
begin
  form7.Show;
end;

procedure TForm1.p1Click(Sender: TObject);
begin
  form5.Show;
end;

procedure TForm1.P2Click(Sender: TObject);
begin
  if FontDialog1.Execute then
    Memo1.Font := FontDialog1.Font;
end;

procedure TForm1.P3Click(Sender: TObject);
begin
fmyPrint.show;
end;

procedure TForm1.Procedure1Click(Sender: TObject);
begin
  f_myBooks.show;
end;

procedure TForm1.t2Click(Sender: TObject);
begin
  form2.Show;
end;

procedure TForm1.ToggleSwitch1Click(Sender: TObject);
begin
if ToggleSwitch1.State=tssOff then
begin
 ToggleSwitch1.FrameColor:=clred;
 ToggleSwitch1.ThumbColor:=clred;
 ToggleSwitch1.Font.Color:=clred;
end
else
begin
  ToggleSwitch1.FrameColor:=clgreen;
 ToggleSwitch1.ThumbColor:=clgreen;
 ToggleSwitch1.Font.Color:=clgreen;
end;
end;

end.
