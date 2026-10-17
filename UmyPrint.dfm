object FmyPrint: TFmyPrint
  Left = 0
  Top = 0
  Caption = 'FmyPrint'
  ClientHeight = 561
  ClientWidth = 984
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    984
    561)
  TextHeight = 15
  object sLabelFX1: TsLabelFX
    Left = 0
    Top = 20
    Width = 1002
    Height = 64
    Alignment = taCenter
    Anchors = [akLeft, akRight]
    AutoSize = False
    Caption = 'My Codes | Print'
    Color = 16485489
    ParentColor = False
    ParentFont = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clTeal
    Font.Height = -48
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    Angle = 0
    Shadow.OffsetKeeper.LeftTop = -1
    Shadow.OffsetKeeper.RightBottom = 9
    Shadow.Color = clWhite
    Shadow.Mode = smCustom
    Shadow.BlurCount = 5
    Shadow.Distance = 4
  end
  object DbTitle: TRzDBEdit
    Left = 440
    Top = 136
    Width = 500
    Height = 34
    DataSource = DataSource1
    Font.Charset = ANSI_CHARSET
    Font.Color = clTeal
    Font.Height = -24
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnExit = DbTitleExit
  end
  object AdvGlassButton1: TAdvGlassButton
    Left = 370
    Top = 503
    Width = 250
    Height = 50
    BackColor = 9349428
    BackGroundSymbolColor = 9349428
    Caption = 'Preview | Print'
    Font.Charset = ANSI_CHARSET
    Font.Color = 4798004
    Font.Height = -24
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ForeColor = 9349428
    GlowColor = 16760205
    Images = FEditor.cxImageList1
    ImageIndex = 6
    InnerBorderColor = 9349428
    OuterBorderColor = 9349428
    ParentFont = False
    ShineColor = 9349428
    TabOrder = 1
    Version = '1.3.3.1'
    OnClick = AdvGlassButton1Click
  end
  object StyledDbNavigator1: TStyledDbNavigator
    Left = 40
    Top = 176
    Width = 900
    Height = 54
    DataSource = DataSource1
    VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbDelete, nbPost, nbCancel, nbRefresh]
    TabOrder = 2
    OnClick = StyledDbNavigator1Click
  end
  object Panel1: TPanel
    Left = 40
    Top = 129
    Width = 394
    Height = 41
    Caption = 'Title Code =>'
    Color = 16485489
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -27
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 3
  end
  object DBGrid1: TDBGrid
    Left = 496
    Top = 236
    Width = 444
    Height = 261
    DataSource = DataSource1
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = clRed
    TitleFont.Height = -21
    TitleFont.Name = 'Times New Roman'
    TitleFont.Style = [fsBold]
    Columns = <
      item
        Expanded = False
        FieldName = 'NCode'
        Width = 79
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Title_Code'
        Width = 200
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Code'
        Width = 300
        Visible = True
      end>
  end
  object MMyCode: TcxDBMemo
    Left = 40
    Top = 236
    DataBinding.DataField = 'Code'
    DataBinding.DataSource = DataSource1
    ParentFont = False
    Properties.ScrollBars = ssBoth
    Properties.OnChange = MMyCodePropertiesChange
    Style.Font.Charset = ANSI_CHARSET
    Style.Font.Color = clTeal
    Style.Font.Height = -21
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.IsFontAssigned = True
    TabOrder = 5
    Height = 261
    Width = 450
  end
  object SearchBox1: TSearchBox
    Left = 40
    Top = 89
    Width = 900
    Height = 34
    Alignment = taCenter
    Font.Charset = ANSI_CHARSET
    Font.Color = clTeal
    Font.Height = -24
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    TextHint = 'Search'
    OnChange = SearchBox1Change
    OnInvokeSearch = SearchBox1InvokeSearch
  end
  object DataSource1: TDataSource
    DataSet = DM.FDQuery
    Left = 160
    Top = 24
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
    Left = 760
    Top = 72
    DesignFrmW = 984
    DesignFrmH = 561
    DesignDpiW = 96
    DesignDpiH = 96
  end
  object frxReport1: TfrxReport
    Version = '6.9.14'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick, pbCopy, pbSelection]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 46130.250805162000000000
    ReportOptions.LastChange = 46311.107561273150000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      
        'procedure frxDBDataset2Title_CodeOnBeforePrint(Sender: TfrxCompo' +
        'nent);'
      'begin'
      ''
      'end;'
      'begin'
      'end.')
    Left = 784
    Top = 8
    Datasets = <
      item
        DataSet = frxDBDataset1
        DataSetName = 'frxDBDataset1'
      end>
    Variables = <>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 210.000000000000000000
      PaperHeight = 297.000000000000000000
      PaperSize = 9
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
      MirrorMargins = True
      Frame.Typ = []
      MirrorMode = []
      PrintIfEmpty = False
      PrintOnPreviousPage = True
      ResetPageNumbers = True
      object ReportTitle1: TfrxReportTitle
        FillType = ftBrush
        FillGap.Top = 0
        FillGap.Left = 0
        FillGap.Bottom = 0
        FillGap.Right = 0
        Frame.Typ = []
        Height = 170.078850000000000000
        Top = 18.897650000000000000
        Width = 718.110700000000000000
        object Memo2: TfrxMemoView
          AllowVectorExport = True
          Left = 75.590600000000000000
          Top = 22.677180000000000000
          Width = 566.929500000000000000
          Height = 71.811070000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 4227327
          Font.Height = -37
          Font.Name = 'Arial'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            #9733#9733#9733' BMA Pascal Editor '#9733#9733#9733)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo3: TfrxMemoView
          AllowVectorExport = True
          Left = 151.181200000000000000
          Top = 94.488250000000000000
          Width = 415.748300000000000000
          Height = 37.795300000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 16744448
          Font.Height = -24
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            '|'#1600#1600#1600#1600#1600#1600#1600#1600#1600#1600' Pascal Source Code '#1600#1600#1600#1600#1600#1600#1600#1600#1600#1600'|')
          ParentFont = False
          VAlign = vaCenter
        end
      end
      object MasterData1: TfrxMasterData
        FillType = ftBrush
        FillGap.Top = 0
        FillGap.Left = 0
        FillGap.Bottom = 0
        FillGap.Right = 0
        Frame.Typ = []
        Height = 449.764070000000000000
        Top = 347.716760000000000000
        Width = 718.110700000000000000
        AllowSplit = True
        DataSet = frxDBDataset1
        DataSetName = 'frxDBDataset1'
        RowCount = 0
        StartNewPage = True
        Stretched = True
        object MemoCode: TfrxMemoView
          IndexTag = 1
          AllowVectorExport = True
          Top = 128.504020000000000000
          Width = 718.110700000000000000
          Height = 321.260050000000000000
          StretchMode = smActualHeight
          DataSetName = 'frxDBDataset2'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -24
          Font.Name = 'Consolas'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            '[frxDBDataset1."Code"]')
          ParentFont = False
          VAlign = vaCenter
        end
        object MemoTitleCode: TfrxMemoView
          IndexTag = 1
          AllowVectorExport = True
          Top = 15.118120000000000000
          Width = 718.110700000000000000
          Height = 75.590600000000000000
          DataSetName = 'frxDBDataset2'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -27
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Fill.BackColor = 4227327
          HAlign = haCenter
          Memo.UTF8W = (
            'The Title Code : [frxDBDataset1."Title_Code"]')
          ParentFont = False
          VAlign = vaCenter
        end
      end
      object PageFooter1: TfrxPageFooter
        FillType = ftBrush
        FillGap.Top = 0
        FillGap.Left = 0
        FillGap.Bottom = 0
        FillGap.Right = 0
        Frame.Typ = []
        Height = 98.267780000000000000
        Top = 857.953310000000000000
        Width = 718.110700000000000000
        object Memo1: TfrxMemoView
          AllowVectorExport = True
          Top = 49.133890000000000000
          Width = 718.110700000000000000
          Height = 49.133890000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -19
          Font.Name = 'Arial'
          Font.Style = [fsBold, fsItalic]
          Frame.Typ = []
          Fill.BackColor = 16744448
          HAlign = haCenter
          Memo.UTF8W = (
            'BMA Pascal Editor v1.4 AI | Page : ([PAGE#])')
          ParentFont = False
          VAlign = vaCenter
        end
      end
      object PageHeader1: TfrxPageHeader
        FillType = ftBrush
        FillGap.Top = 0
        FillGap.Left = 0
        FillGap.Bottom = 0
        FillGap.Right = 0
        Frame.Typ = []
        Height = 75.590600000000000000
        Top = 211.653680000000000000
        Width = 718.110700000000000000
      end
    end
  end
  object frxDBDataset1: TfrxDBDataset
    UserName = 'frxDBDataset1'
    CloseDataSource = False
    BCDToCurrency = False
    Left = 712
    Top = 8
  end
end
