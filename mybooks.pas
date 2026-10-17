unit mybooks;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.jpeg, RzLaunch;

type
  TF_myBooks = class(TForm)
    Image1: TImage;
    Image2: TImage;
    Panel2: TPanel;
    Panel1: TPanel;
    RzLauncher1: TRzLauncher;
    RzLauncher2: TRzLauncher;
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Panel2Click(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_myBooks: TF_myBooks;

implementation

{$R *.dfm}
 uses editor;


procedure TF_myBooks.Image1Click(Sender: TObject);
begin
RzLauncher1.Execute;
end;

procedure TF_myBooks.Image2Click(Sender: TObject);
begin
RzLauncher2.Execute;
end;

procedure TF_myBooks.Panel1Click(Sender: TObject);
begin
RzLauncher1.Execute;
end;

procedure TF_myBooks.Panel2Click(Sender: TObject);
begin
RzLauncher2.Execute;
end;

end.
