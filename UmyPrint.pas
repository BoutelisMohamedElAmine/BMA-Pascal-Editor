unit UmyPrint;

interface

uses

  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Data.DB, Vcl.StdCtrls, Vcl.Mask, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls,
  Vcl.DBCtrls, Vcl.WinXCtrls,
  // FireDAC
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.Client,
  FireDAC.Comp.DataSet,
  // مكونات الطرف الثالث (احتفظت بما هو مستخدم فعلاً)
  RzEdit, RzDBEdit, RzDBGrid, sLabel, AdvGlassButton,
  Vcl.StyledDbNavigator, ResizeKit, frxClass, frxDBSet,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, cxTextEdit, cxMemo, cxDBEdit,
  // وحدات المشروع
  uDM, editor, uapi_key, dxSkinsCore, dxSkinBasic, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkroom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray,
  dxSkinOffice2013White, dxSkinOffice2016Colorful, dxSkinOffice2016Dark,
  dxSkinOffice2019Black, dxSkinOffice2019Colorful, dxSkinOffice2019DarkGray,
  dxSkinOffice2019White, dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic,
  dxSkinSharp, dxSkinSharpPlus, dxSkinSilver, dxSkinSpringtime, dxSkinStardust,
  dxSkinSummer2008, dxSkinTheAsphaltWorld, dxSkinTheBezier,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVisualStudio2013Blue,
  dxSkinVisualStudio2013Dark, dxSkinVisualStudio2013Light, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinWXI, dxSkinXmas2008Blue,dprocess,dpipes,
  Data.Win.ADODB;

type
  TFmyPrint = class(TForm)
    DbTitle: TRzDBEdit;
    sLabelFX1: TsLabelFX;
    AdvGlassButton1: TAdvGlassButton;
    StyledDbNavigator1: TStyledDbNavigator;
    Panel1: TPanel;
    DataSource1: TDataSource;
    ResizeKit1: TResizeKit;
    DBGrid1: TDBGrid;
    MMyCode: TcxDBMemo;
    SearchBox1: TSearchBox;
    frxReport1: TfrxReport;
    frxDBDataset1: TfrxDBDataset;

    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AdvGlassButton1Click(Sender: TObject);
    procedure DbTitleExit(Sender: TObject);
    procedure StyledDbNavigator1Click(Sender: TObject; Button: TNavigateBtn);
    procedure SearchBox1InvokeSearch(Sender: TObject);
    procedure SearchBox1Change(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure MMyCodePropertiesChange(Sender: TObject);

  private
    FQuery: TFDQuery;
    procedure SetupQuery;
    procedure ApplyFilter(const AText: string);

  public
    { Public declarations }
      procedure PrepareNewCode(const ACode: string);
  end;

var
  FmyPrint: TFmyPrint;

implementation

{$R *.dfm}


procedure TFmyPrint.PrepareNewCode(const ACode: string);
begin
  // حماية: إن لم يكن FQuery جاهزًا، جرّب تهيئته الآن
  if not Assigned(FQuery) then
    SetupQuery;

  if not Assigned(FQuery) then
  begin
    ShowMessage('❌ تعذّر تهيئة الاستعلام (FQuery = nil)');
    Exit;
  end;

  try
    if not FQuery.Active then
      FQuery.Open;

    // إن كان هناك سجل قيد التحرير، ألغِه
    if FQuery.State in [dsEdit, dsInsert] then
      FQuery.Cancel;

    // ابدأ سجلًا جديدًا
    FQuery.Append;
    FQuery.FieldByName('Title_Code').AsString := '';
    FQuery.FieldByName('Code').AsString       := ACode;
  except
    on E: Exception do
      ShowMessage('❌ فشل تجهيز السجل: ' + E.Message);
  end;
end;


{ ============================================================
  إنشاء النموذج: نُنشئ FDQuery محليًا وندعم الاتصال عبر DM
  ============================================================ }
procedure TFmyPrint.FormCreate(Sender: TObject);
begin
  if not Assigned(DM) then
  begin
    ShowMessage('❌ لم يتم تهيئة DataModule!');
    Exit;
  end;

  // افتح الاتصال إن لم يكن مفتوحًا
  if not DM.FDConnection.Connected then
  begin
    try
      DM.Connect;
    except
      on E: Exception do
      begin
        ShowMessage('❌ ' + E.Message);
        Exit;
      end;
    end;
  end;

  SetupQuery;
end;

procedure TFmyPrint.MMyCodePropertiesChange(Sender: TObject);
begin

end;

{ ============================================================
  إعداد FDQuery للعمل على جدول MyCode
  ============================================================ }
procedure TFmyPrint.SetupQuery;
begin
  if Assigned(FQuery) then Exit;

  // 1) إنشاء الاستعلام وربطه
  FQuery := TFDQuery.Create(Self);
  FQuery.Connection := DM.FDConnection;
  FQuery.SQL.Text :=
    'SELECT NCode, Title_Code, Code FROM MyCode ORDER BY NCode DESC';

  // 2) إعدادات ضرورية لجعل الاستعلام قابلًا للتعديل
  FQuery.UpdateOptions.UpdateTableName := 'MyCode';
  FQuery.UpdateOptions.KeyFields        := 'NCode';
  FQuery.UpdateOptions.ReadOnly         := False;

  FQuery.FetchOptions.Mode           := fmAll;
  FQuery.FetchOptions.RecsMax        := 10000;
  FQuery.FetchOptions.Unidirectional := False;

  // 3) افتح الاستعلام
  FQuery.Open;

  // 4) ربط المكونات
  DataSource1.DataSet   := FQuery;
  frxDBDataset1.DataSet := FQuery;

  DbTitle.DataField  := 'Title_Code';
  DbTitle.DataSource := DataSource1;

  MMyCode.DataBinding.DataField  := 'Code';
  MMyCode.DataBinding.DataSource := DataSource1;

  DBGrid1.DataSource            := DataSource1;
  StyledDbNavigator1.DataSource := DataSource1;
end;

{ ============================================================
  إغلاق نظيف عند إغلاق النموذج
  ============================================================ }
procedure TFmyPrint.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(FQuery) then
  begin
    if FQuery.Active then FQuery.Close;
    FreeAndNil(FQuery);
  end;
end;

{ ============================================================
  زر الطباعة: عرض واحد فقط (ShowReport يتضمن الطباعة)
  ============================================================ }
procedure TFmyPrint.AdvGlassButton1Click(Sender: TObject);
begin
  if Assigned(frxReport1) and Assigned(frxDBDataset1) then
  begin
    frxReport1.ShowReport;
    // لا حاجة لـ Print بعد ShowReport لأن المعاينة تتيح الطباعة
  end;

end;

procedure TFmyPrint.DbTitleExit(Sender: TObject);
begin

  if not Assigned(FQuery) then Exit;
  if not FQuery.Active then Exit;

  try
    if FQuery.State in [dsEdit, dsInsert] then
    begin
      if FQuery.FieldByName('Title_Code').AsString.Trim = '' then
        Exit;  // لا تحفظ بدون عنوان

      FQuery.Post;
      Caption := 'BMA Pascal Editor v1.4 AI';
    end;
  except
    on E: Exception do
      ShowMessage('❌ فشل الحفظ: ' + E.Message);
  end;

end;

procedure TFmyPrint.StyledDbNavigator1Click(Sender: TObject;
  Button: TNavigateBtn);
begin

  // حفظ تلقائي قبل الانتقال
  try
    if FQuery.State in [dsEdit, dsInsert] then
      FQuery.Post;
  except
    // تجاهل
  end;
end;

{ ============================================================
  الفلترة: صيغة SQLite تستخدم % بدل *
  ============================================================ }
procedure TFmyPrint.ApplyFilter(const AText: string);
begin
  if AText.Trim = '' then
  begin
    FQuery.Filtered := False;
    Exit;
  end;

  // SQLite يستخدم % وليس *
  FQuery.Filter := 'Title_Code LIKE ' + QuotedStr('%' + AText + '%');
  FQuery.Filtered := True;
end;

procedure TFmyPrint.SearchBox1Change(Sender: TObject);
begin
  ApplyFilter(SearchBox1.Text);
end;

procedure TFmyPrint.SearchBox1InvokeSearch(Sender: TObject);
begin
  ApplyFilter(SearchBox1.Text);
end;

{ ============================================================
  مزامنة كود المحرر مع حقل Code في قاعدة البيانات
  (اختياري — اربطه بزر "حفظ" بدل Timer)
  ============================================================ }
procedure TFmyPrint.DataSource1DataChange(Sender: TObject; Field: TField);
begin
  // إن أردت عرض Code في المحرر عند التنقل بين السجلات:
  if Assigned(feditor) and FQuery.Active and (not FQuery.IsEmpty) then
  begin
    // فتح السجل في المحرر
    // feditor.Memo1.Lines.Text := FQuery.FieldByName('Code').AsString;
  end;

end;

end.
