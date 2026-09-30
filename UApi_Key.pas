unit UApi_Key;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvGlassButton, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls, ResizeKit;

type
  TFApi_Key = class(TForm)
    AdvGlassButton1: TAdvGlassButton;
    DBEdit1: TDBEdit;
    show_hide: TCheckBox;
    Panel1: TPanel;
    ResizeKit1: TResizeKit;
    procedure show_hideClick(Sender: TObject);
    procedure AdvGlassButton1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FApi_Key: TFApi_Key;

implementation

{$R *.dfm}
uses umyprint,editor;
procedure TFApi_Key.AdvGlassButton1Click(Sender: TObject);
begin
Form1.ADOTable2.Edit;
form1.ADOTable2.Post;
panel1.Caption:='Your Api_Key (Gemini) : Confirmer';
end;

procedure TFApi_Key.FormClose(Sender: TObject; var Action: TCloseAction);
begin
panel1.Caption:='Your Api_Key (Gemini) :';
end;

procedure TFApi_Key.show_hideClick(Sender: TObject);
begin
if  show_hide.Checked=true then
  begin
  DBEdit1.PasswordChar:=#0; //#0 true
   show_hide.Caption:='Show Api_Key';
  end
else
  begin
      DBEdit1.PasswordChar:='*';
     show_hide.Caption:='Show Api_Key';
  end;
end;

end.
