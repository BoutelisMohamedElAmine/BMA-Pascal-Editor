unit procedures;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ResizeKit, AdvMemo, dxGDIPlusClasses,
  Vcl.ExtCtrls;

type
  TForm5 = class(TForm)
    Panel1: TPanel;
    Memo1: TAdvMemo;
    ResizeKit1: TResizeKit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

{$R *.dfm}

end.
