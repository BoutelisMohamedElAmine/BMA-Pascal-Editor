unit themes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, sMaskEdit,
  sCustomComboEdit, sComboBox, sComboBoxes, sLabel, ResizeKit;

type
  Tform7 = class(TForm)
    sSkinSelector1: TsSkinSelector;
    sLabelFX2: TsLabelFX;
    ResizeKit1: TResizeKit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  form7: Tform7;

implementation

{$R *.dfm}

end.
