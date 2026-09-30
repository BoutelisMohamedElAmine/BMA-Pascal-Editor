program BMA_Pascal_Editor;

uses
  Vcl.Forms,
  editor in 'editor.pas' {Form1},
  dprocess in 'dprocess.pas',
  dpipes in 'dpipes.pas',
  ProcessUtils in 'ProcessUtils.pas',
  operations in 'operations.pas' {Form2},
  info in 'info.pas' {Form3},
  functions in 'functions.pas' {Form4},
  procedures in 'procedures.pas' {Form5},
  mybooks in 'mybooks.pas' {F_myBooks},
  themes in 'themes.pas' {form7},
  uBMA_AI in 'uBMA_AI.pas',
  UmyPrint in 'UmyPrint.pas' {FmyPrint},
  UApi_Key in 'UApi_Key.pas' {FApi_Key};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm5, Form5);
  Application.CreateForm(TF_myBooks, F_myBooks);
  Application.CreateForm(Tform7, form7);
  Application.CreateForm(TFmyPrint, FmyPrint);
  Application.CreateForm(TFApi_Key, FApi_Key);
  Application.Run;
end.
