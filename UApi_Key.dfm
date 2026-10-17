object FApi_Key: TFApi_Key
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Api_Key'
  ClientHeight = 207
  ClientWidth = 884
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = ANSI_CHARSET
  Font.Color = clWhite
  Font.Height = -24
  Font.Name = 'Times New Roman'
  Font.Style = [fsBold]
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    884
    207)
  TextHeight = 26
  object AdvGlassButton1: TAdvGlassButton
    Left = 730
    Top = 112
    Width = 130
    Height = 32
    Hint = 'Confirmation'
    BackColor = clBlue
    BackGroundSymbolColor = clBlue
    Caption = 'Confirmer'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -19
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ForeColor = clBlue
    GlowColor = clBlue
    Images = FEditor.cxImageList1
    ImageIndex = 16
    InnerBorderColor = clBlue
    OuterBorderColor = clBlue
    ParentFont = False
    ParentShowHint = False
    ShineColor = clBlue
    ShowHint = True
    TabOrder = 0
    Version = '1.3.3.1'
    OnClick = AdvGlassButton1Click
  end
  object DBEdit1: TDBEdit
    Left = 20
    Top = 112
    Width = 700
    Height = 30
    DataSource = DataSource1
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -19
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    PasswordChar = '*'
    TabOrder = 1
  end
  object show_hide: TCheckBox
    Left = 392
    Top = 152
    Width = 201
    Height = 25
    Caption = 'show Api_Key'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -19
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = show_hideClick
  end
  object Panel1: TPanel
    Left = 20
    Top = 56
    Width = 840
    Height = 41
    BevelOuter = bvNone
    Caption = 'Your Api_Key :'
    Color = 16296338
    ParentBackground = False
    TabOrder = 3
  end
  object ComboBox1: TComboBox
    Left = 20
    Top = 8
    Width = 213
    Height = 34
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -24
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    Text = 'gemini'
    OnChange = ComboBox1Change
    Items.Strings = (
      'openai'
      'gemini'
      'anthropic'
      'groq')
  end
  object DBComboBox1: TDBComboBox
    Left = 248
    Top = 8
    Width = 612
    Height = 34
    Anchors = [akTop, akRight]
    DataSource = DataSource1
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -24
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
  end
  object ResizeKit1: TResizeKit
    FormPos = rpDefault
    FormWidth = 0
    FormHeight = 0
    FormMaxWidth = 0
    FormMaxHeight = 0
    FormMinWidth = 0
    FormMinHeight = 0
    ResizeFont = True
    Enabled = True
    ValidTaskbar = True
    Left = 232
    Top = 120
    DesignFrmW = 884
    DesignFrmH = 207
    DesignDpiW = 96
    DesignDpiH = 96
  end
  object DataSource1: TDataSource
    DataSet = DM.FDQuery
    Left = 616
    Top = 120
  end
end
