unit functions;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvMemo, dxGDIPlusClasses, Vcl.ExtCtrls,
  ResizeKit;

type
  TForm4 = class(TForm)
    Panel1: TPanel;
    Memo1: TAdvMemo;
    ResizeKit1: TResizeKit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}
uses editor;
end.
