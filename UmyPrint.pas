unit UmyPrint;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Mask, RzEdit,
  RzDBEdit, Vcl.Grids, Vcl.DBGrids, RzDBGrid, sLabel, Data.Win.ADODB,
  Vcl.ExtCtrls, Vcl.StyledDbNavigator, AdvGlassButton, Vcl.DBCtrls, ResizeKit,
  frxClass, frxDBSet, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore, dxSkinBasic,
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
  dxSkinXmas2008Blue, cxTextEdit, cxMemo, cxDBEdit, RzLstBox, RzDBList,
  ovceditf, ovciseb, ovcdbise, Vcl.WinXCtrls;

type
  TFmyPrint = class(TForm)
    DbTitle: TRzDBEdit;
    sLabelFX1: TsLabelFX;
    AdvGlassButton1: TAdvGlassButton;
    StyledDbNavigator1: TStyledDbNavigator;
    Panel1: TPanel;
    ADOConnection1: TADOConnection;
    ADOTable1: TADOTable;
    DataSource1: TDataSource;
    ResizeKit1: TResizeKit;
    DBGrid1: TDBGrid;
    MMyCode: TcxDBMemo;
    Timer1: TTimer;
    SearchBox1: TSearchBox;
    frxReport1: TfrxReport;
    frxDBDataset1: TfrxDBDataset;
    procedure FormShow(Sender: TObject);
    procedure AdvGlassButton1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure DbTitleExit(Sender: TObject);
    procedure StyledDbNavigator1Click(Sender: TObject; Button: TNavigateBtn);
    procedure SearchBox1InvokeSearch(Sender: TObject);
    procedure SearchBox1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FmyPrint: TFmyPrint;

implementation

{$R *.dfm}
uses editor,uapi_key;
procedure TFmyPrint.AdvGlassButton1Click(Sender: TObject);
begin
frxReport1.ShowReport;
frxReport1.Print;
end;

procedure TFmyPrint.DbTitleExit(Sender: TObject);
begin
Timer1.Enabled:=false;
end;

procedure TFmyPrint.FormShow(Sender: TObject);
begin
 fmyprint.ADOConnection1.Connected:=false;
  fmyprint.ADOConnection1.ConnectionString:=ExtractFilePath(Application.ExeName)+'database.mdb';
  fmyprint.ADOConnection1.Connected:=true;
  fmyprint.Adotable1.active:=true;




end;

procedure TFmyPrint.SearchBox1Change(Sender: TObject);
begin
if not(searchbox1.Text=('')) then
      begin
       ADOTable1.Filter := 'Title_Code LIKE ''*' + SearchBox1.Text + '*''';
       ADOTable1.Filtered := True;
      end else
    ADOTable1.Filtered := false;
end;

procedure TFmyPrint.SearchBox1InvokeSearch(Sender: TObject);
begin
if not(searchbox1.Text=('')) then
      begin
       ADOTable1.Filter := 'Title_Code LIKE ''*' + SearchBox1.Text + '*''';
       ADOTable1.Filtered := True;
      end else
    ADOTable1.Filtered := false;

end;

procedure TFmyPrint.StyledDbNavigator1Click(Sender: TObject;
  Button: TNavigateBtn);
begin
Timer1.Enabled:=false;
end;

procedure TFmyPrint.Timer1Timer(Sender: TObject);
begin
fmyprint.MMyCode.Lines.text:=(form1.Memo1.Lines.Text);
end;

end.
