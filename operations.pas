unit operations;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, AdvMemo, acPNG,
  dxGDIPlusClasses, ResizeKit;

type
  TFoperations = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Memo1: TAdvMemo;
    AdvMemo1: TAdvMemo;
    AdvMemo2: TAdvMemo;
    AdvMemo3: TAdvMemo;
    Image2: TImage;
    Image1: TImage;
    Image4: TImage;
    Image3: TImage;
    ResizeKit1: TResizeKit;
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var

  Foperations: TFoperations;

implementation

{$R *.dfm}
uses editor;

procedure TFoperations.Image1Click(Sender: TObject);
begin
Feditor.Memo1.Lines:=advMemo1.Lines;
close;
end;

procedure TFoperations.Image2Click(Sender: TObject);
begin
Feditor.Memo1.Lines:=Memo1.Lines;
close;
end;

procedure TFoperations.Image3Click(Sender: TObject);
begin
Feditor.Memo1.Lines:=advMemo3.Lines;
close;
end;

procedure TFoperations.Image4Click(Sender: TObject);
begin
Feditor.Memo1.Lines:=advMemo2.Lines;
close;
end;

end.
