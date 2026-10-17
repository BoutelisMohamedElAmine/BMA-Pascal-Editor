object StringsPropPage: TStringsPropPage
  Left = 196
  Top = 111
  Width = 313
  Height = 184
  Caption = 'Cha'#238'nes'
  ParentFont = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 6
    Top = 141
    Width = 166
    Height = 13
    Caption = '<Appuyez sur CTRL-ENTREE pour une nouvelle ligne>'
  end
  object StringMemo: TMemo
    Left = 6
    Top = 30
    Width = 292
    Height = 109
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object ClearBtn: TButton
    Left = 246
    Top = 3
    Width = 50
    Height = 20
    Caption = '&Effacer'
    TabOrder = 1
    OnClick = ClearBtnClick
  end
  object PropName: TComboBox
    Left = 96
    Top = 3
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 0
    OnChange = PropNameChange
    OnClick = PropNameClick
  end
  object StaticText2: TStaticText
    Left = 9
    Top = 6
    Width = 77
    Height = 17
    Caption = 'Nom de propri'#233't'#233' :'
    TabOrder = 3
  end
end
