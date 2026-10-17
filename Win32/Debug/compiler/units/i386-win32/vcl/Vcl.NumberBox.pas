{*******************************************************}
{                                                       }
{            Delphi Visual Component Library            }
{                                                       }
{ Copyright(c) 1995-2023 Embarcadero Technologies, Inc. }
{              All rights reserved                      }
{                                                       }
{*******************************************************}

unit Vcl.NumberBox;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Types, System.UITypes, System.SysUtils, System.Classes,
  Vcl.Themes, Vcl.Graphics, Vcl.Controls, Vcl.StdCtrls, Vcl.Forms,
  System.Math, System.Rtti, System.Bindings.Helper, System.Bindings.Expression;

const
  cDefaultButtonWidth = 17;
  cDefaultSmallStep = 1;
  cDefaultLargeStep = 10;
  cDefaultRepeatTimerInterval = 100;

type
  TCustomNumberBox = class;

  TNumberBoxMode = (nbmInteger, nbmFloat, nbmCurrency);
  TNumberBoxSpinButtonPlacement = (nbspNone, nbspCompact, nbspInline);
  TNumberBoxCurrencyFormat = (nbcfPrefix, nbcfPostfix, nbcfPrefixSpace, nbcfPostfixSpace);

  /// <summary>
  /// Defines spin button properties and behavior
  /// </summary>
  TNumberBoxSpinButtonOptions = class(TPersistent)
  private
    FButtonWidth: Integer;
    FNumberBox: TCustomNumberBox;
    FPlacement: TNumberBoxSpinButtonPlacement;
    FArrowColor: TColor;
    FArrowHotColor: TColor;
    FArrowPressedColor: TColor;
    FArrowDisabledColor: TColor;
    FShowInlineDividers: Boolean;
    FArrowWidth: Integer;
    FRepeatTimerInterval: Integer;
    procedure SetArrowWidth(AValue: Integer);
    procedure SetShowInlineDividers(AValue: Boolean);
    procedure SetButtonWidth(AValue: Integer);
    procedure SetPlacement(AValue: TNumberBoxSpinButtonPlacement);
    procedure SetArrowColor(AValue: TColor);
    procedure SetArrowHotColor(AValue: TColor);
    procedure SetArrowPressedColor(AValue: TColor);
    procedure SetArrowDisabledColor(AValue: TColor);
    procedure Change(AFullUpdate: Boolean);
  public
    constructor CreateLinked(ANumberBox: TCustomNumberBox);
    procedure Assign(Source: TPersistent); override;
  published
    /// <summary>
    /// Defines width of arrow
    /// if value is 0 then arrow has width, which adjusts automatically
    /// </summary>
    property ArrowWidth: Integer
      read FArrowWidth write SetArrowWidth default 0;
    /// <summary>
    /// Defines width of button
    /// </summary>
    property ButtonWidth: Integer
      read FButtonWidth write SetButtonWidth default cDefaultButtonWidth;
    /// <summary>
    /// Defines placement of spin button
    /// </summary>
    property Placement: TNumberBoxSpinButtonPlacement
      read FPlacement write SetPlacement default nbspNone;
    /// <summary>
    /// Defines arrow color for normal state
    /// </summary>
    property ArrowColor: TColor
      read FArrowColor write SetArrowColor default clWindowText;
    /// <summary>
    /// Defines arrow color for hot state
    /// </summary>
    property ArrowHotColor: TColor
      read FArrowHotColor write SetArrowHotColor default clWindowText;
    /// <summary>
    /// Defines arrow color for pressed state
    /// </summary>
    property ArrowPressedColor: TColor
      read FArrowPressedColor write SetArrowPressedColor default clWindowText;
    /// <summary>
    /// Defines arrow color for disabled state
    /// </summary>
    property ArrowDisabledColor: TColor
      read FArrowDisabledColor write SetArrowDisabledColor default clGrayText;
    /// <summary>
    /// Defines timer inerval to repeat click of the button
    /// </summary>
    property RepeatTimerInterval: Integer
      read FRepeatTimerInterval write FRepeatTimerInterval default cDefaultRepeatTimerInterval;
    /// <summary>
    /// Defines visiblity of dividers if Placement is nbspInline
    /// </summary>
    property ShowInlineDividers: Boolean
      read FShowInlineDividers write SetShowInlineDividers default True;
  end;

  TNumberBoxButtonType = (nbbtUp, nbbtDown);

  TNumberBoxButton = class(TPersistent)
  private
    FButtonType: TNumberBoxButtonType;
    FButtonRect: TRect;
    FMouseIn: Boolean;
    FDown: Boolean;
    FNumberBox: TCustomNumberBox;
  public
    constructor CreateLinked(AButtonType: TNumberBoxButtonType; ANumberBox: TCustomNumberBox);
    procedure Draw(ACanvas: TCanvas);
    procedure Click;
    property ButtonRect: TRect read FButtonRect write FButtonRect;
    property MouseIn: Boolean read FMouseIn write FMouseIn;
    property Down: Boolean read FDown write FDown;
  end;

  TNumberBoxValidateCharEvent = procedure(AChar: Char; var AValidated: Boolean) of object;

  TCustomNumberBox = class(TCustomEdit)
  strict private
    class constructor Create;
    class destructor Destroy;
  private
    FAcceptExpressions: Boolean;
    FCurrencyString: string;
    FDisplayFormat: string;
    FValue: Extended;
    FMinValue: Extended;
    FMaxValue: Extended;
    FSmallStep: Extended;
    FLargeStep: Extended;
    FMode: TNumberBoxMode;
    FDecimal: Byte;
    FSpinButtonOptions: TNumberBoxSpinButtonOptions;
    FMouseOverButtons: Boolean;
    FActiveButton: Integer;
    FDownButton: Integer;
    FTimerMode: Byte;
    FValueChanging, FTextChanging: Boolean;
    FOnChangeValue: TNotifyEvent;
    FOnValidateChar: TNumberBoxValidateCharEvent;
    FOnEvaluateExpression: TNotifyEvent;
    FUseNaNValue: Boolean;
    FUseUpDownKeys: Boolean;
    FUseMouseWheel: Boolean;
    FWrap: Boolean;
    FNegativeValueColor: TColor;
    FCurrencyFormat: TNumberBoxCurrencyFormat;
    procedure SetDisplayFormat(const AValue: string);
    procedure SetCurrencyString(const AValue: string);
    procedure SetDecimal(AValue: Byte);
    procedure SetMinValue(AValue: Extended);
    procedure SetMaxValue(AValue: Extended);
    procedure SetValue(AValue: Extended);
    procedure SetMode(AValue: TNumberBoxMode);
    procedure SetSmallStep(AValue: Extended);
    procedure SetLargeStep(AValue: Extended);
    procedure SetAcceptExpressions(AValue: Boolean);
    function GetValueInt: Integer;
    function GetValueFloat: Extended;
    function GetValueCurrency: Currency;
    procedure SetValueInt(const AValue: Integer);
    procedure SetValueFloat(const AValue: Extended);
    procedure SetValueCurrency(const AValue: Currency);
    procedure UpdateFrame(AFullUpdate: Boolean);
    procedure ShowButtons;
    procedure HideButtons;
    function IsButtonsVisible: Boolean;
    function ButtonAtPos(APos: TPoint): Integer;
    procedure CheckMouseLeave;
    procedure SetTextFromValue;
    procedure InitTimer(ATimerMode: Integer);
    procedure StartTimer(ATimerMode: Integer);
    procedure StopTimer;
    function IsSmallStepStored: Boolean;
    function IsLargeStepStored: Boolean;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
    procedure WMNCPaint(var Message: TWMNCPaint); message WM_NCPAINT;
    procedure WMNCCalcSize(var Message: TWMNCCalcSize); message WM_NCCALCSIZE;
    procedure WMNCHitTest(var Message: TMessage); message WM_NCHITTEST;
    procedure WMSetCursor(var Message: TWMSetCursor); message WM_SETCURSOR;
    procedure WMLButtonDown(var Message: TMessage); message WM_LBUTTONDOWN;
    procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
    procedure WMLButtonDblClk(var Message: TMessage); message WM_LBUTTONDBLCLK;
    procedure WMRButtonDown(var Message: TMessage); message WM_RBUTTONDOWN;
    procedure WMMouseMove(var Message: TWMMouseMove); message WM_MOUSEMOVE;
    procedure WMTimer(var Message: TWMTimer); message WM_TIMER;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMChar(var Message: TWMChar); message WM_CHAR;
    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure WMCut(var Message: TMessage); message WM_CUT;
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
    function EditValue(const AStep: Extended): Boolean;
    procedure SetNegativeValueColor(const AValue: TColor);
    procedure SetCurrencyFormat(const AValue: TNumberBoxCurrencyFormat);
    function IsCurrencyFormatStored: Boolean;
    function IsCurrencyStringStored: Boolean;
    function IsDecimalStored: Boolean;
  protected
    FButtons: array[0..1] of TNumberBoxButton;
    procedure DrawButtons(ACanvas: TCanvas); virtual;
    function GetDisplayText: string; virtual;
    procedure DrawDisplayText(AText: string; ACanvas: TCanvas; ANegative: Boolean); virtual;
    procedure DoButtonClick(AButtonType: TNumberBoxButtonType);
    procedure ChangeScale(M, D: Integer; isDpiChange: Boolean); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    function IsValidChar(AKey: Char): Boolean; virtual;
    function IsNumericText(const AText: string): Boolean; overload; virtual;
    function IsNumericText: Boolean; overload;
    function GetValidCharSet(AAcceptExpressions: Boolean): TSysCharSet; virtual;
    procedure DoChangeValue; virtual;
    procedure EvaluateExpression; virtual;
    procedure Change; override;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    /// <summary>
    /// Defines in which mode control works
    /// </summary>
    property Mode: TNumberBoxMode
      read FMode write SetMode default nbmInteger;
    /// <summary>
    /// Current Value
    /// </summary>
    property Value: Extended
     read FValue write SetValue;
    /// <summary>
    /// Current Value as Integer
    /// </summary>
    property ValueInt: Integer read GetValueInt write SetValueInt;
    /// <summary>
    /// Current Value as Extended, which rounded using Decimal property
    /// </summary>
    property ValueFloat: Extended read GetValueFloat write SetValueFloat;
    /// <summary>
    /// Current Value as Currency, which rounded using Decimal property
    /// </summary>
    property ValueCurrency: Currency read GetValueCurrency write SetValueCurrency;
    /// <summary>
    /// Defines string for currency mode, which will be added at the end of display text.
    /// Default value is FormatSettings.CurrencyString.
    /// </summary>
    property CurrencyString: string
      read FCurrencyString write SetCurrencyString stored IsCurrencyStringStored;
    /// <summary>
    /// Defines CurrencyString placement and separation for currency mode. For details
    /// see TFormatSettings.CurrencyFormat. Default value matches to FormatSettings.CurrencyFormat.
    /// </summary>
    property CurrencyFormat: TNumberBoxCurrencyFormat
      read FCurrencyFormat write SetCurrencyFormat stored IsCurrencyFormatStored;
    /// <summary>
    /// Defines custom text format
    /// </summary>
    property DisplayFormat: string
      read FDisplayFormat write SetDisplayFormat;
    /// <summary>
    /// Defines minimum value
    /// </summary>
    property MinValue: Extended
     read FMinValue write SetMinValue;
    /// <summary>
    /// Defines maximum value
    /// </summary>
    property MaxValue: Extended
     read FMaxValue write SetMaxValue;
    /// <summary>
    /// Defines decimal count
    /// </summary>
    property Decimal: Byte
      read FDecimal write SetDecimal stored IsDecimalStored;
    /// <summary>
    /// Defines value, on which Value property will be changed with spin button, Up/Down keys and mouse wheel
    /// </summary>
    property SmallStep: Extended
      read FSmallStep write SetSmallStep stored IsSmallStepStored;
    /// <summary>
    /// Defines value, on which Value property will be changed with Page Up/ Page Down keys
    /// </summary>
    property LargeStep: Extended
      read FLargeStep write SetLargeStep stored IsLargeStepStored;
    /// <summary>
    /// Enables using expressions in control
    /// </summary>
    property AcceptExpressions: Boolean
      read FAcceptExpressions write SetAcceptExpressions default False;
    /// <summary>
    /// Defines options of spin button
    /// </summary>
    property SpinButtonOptions: TNumberBoxSpinButtonOptions
      read FSpinButtonOptions write FSpinButtonOptions;
    /// <summary>
    /// Uses NaN value when text is empty
    /// </summary>
    property UseNaNValue: Boolean
      read FUseNaNValue write FUseNaNValue default False;
    /// <summary>
    /// Enables changing Value with mouse wheel using SmallStep property
    /// </summary>
    property UseMouseWheel: Boolean
      read FUseMouseWheel write FUseMouseWheel default False;
    /// <summary>
    /// Enables changing Value with Up/Down and Page Up/ Page Down keys
    /// </summary>
    property UseUpDownKeys: Boolean
      read FUseUpDownKeys write FUseUpDownKeys default True;
    /// <summary>
    /// Enables wraping Value from MaxValue to MinValue and opposite
    /// </summary>
    property Wrap: Boolean
      read FWrap write FWrap default False;
    /// <summary>
    /// Specifies font color for negative values. Set ot clNone to use the same
    /// color as for positive values.
    /// </summary>
    property NegativeValueColor: TColor
      read FNegativeValueColor write SetNegativeValueColor default clNone;
    /// <summary>
    /// Event, which occurs if Value property is changed
    /// </summary>
    property OnChangeValue: TNotifyEvent
      read FOnChangeValue write FOnChangeValue;
    /// <summary>
    /// Event to apply custom evaluation of expession using Text and Value properties
    /// </summary>
    property OnEvaluateExpression: TNotifyEvent
      read FOnEvaluateExpression write FOnEvaluateExpression;
    /// <summary>
    /// Event for custom validation of input char
    /// </summary>
    property OnValidateChar: TNumberBoxValidateCharEvent
      read FOnValidateChar write FOnValidateChar;
  end;

  [ObservableMember('Value', True)]
  TNumberBox = class(TCustomNumberBox)
  published
    property AcceptExpressions;
    property Align;
    property Alignment;
    property Anchors;
    property AutoSelect;
    property AutoSize;
    property BiDiMode;
    property BorderStyle;
    property CharCase;
    property Color;
    property Constraints;
    property CurrencyString;
    property CurrencyFormat;
    property Decimal;
    property DisplayFormat;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DoubleBuffered;
    property Enabled;
    property Font;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property LargeStep;
    property Mode;
    property MinValue;
    property MaxValue;
    property MaxLength;
    property OEMConvert;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentDoubleBuffered;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property SmallStep;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property TextHint;
    property Touch;
    property Value;
    property Visible;
    property SpinButtonOptions;
    property StyleElements;
    property StyleName;
    property UseNaNValue;
    property UseMouseWheel;
    property UseUpDownKeys;
    property Wrap;
    property NegativeValueColor;
    property OnChange;
    property OnChangeValue;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEvaluateExpression;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGesture;
    property OnValidateChar;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  TNumberBoxStyleHook = class(TEditStyleHook)
  strict protected
    procedure PaintNC(Canvas: TCanvas); override;
  end;

const
                                                                                     
  nbcfNone = TNumberBoxCurrencyFormat(Integer(High(TNumberBoxCurrencyFormat)) + 1);

implementation

uses
  Vcl.Clipbrd, Vcl.GraphUtil;

procedure DrawSpinButtonArrow(AButtonType: TNumberBoxButtonType; AArrowWidth: Integer; ACanvas: TCanvas;
  ARect: TRect; AColor: TColor; AScaleFactor: Single);
var
  I, J: Integer;
  X, Y: Integer;
  LOffset: Integer;
  LWidth: Integer;
begin
  if AScaleFactor < 1 then
    AScaleFactor := 1;

  ACanvas.Pen.Color := AColor;

  if AArrowWidth > ARect.Width then
    AArrowWidth := ARect.Width
  else
  if (AArrowWidth > 0) and (AArrowWidth < 6) then
    AArrowWidth := 6;

  if AArrowWidth = 0 then
    LOffset := ARect.Width div 2
  else
    LOffset := AArrowWidth div 2;

  LWidth := Trunc(AScaleFactor + 1);
  X := ARect.Left + ARect.Width div 2;
  J := 1;
  case AButtonType of
    nbbtDown:
      begin
        Y := ARect.Bottom - (ARect.Height + LWidth - LOffset) div 2 - 1;
        for I := 1 to LWidth do
        begin
          ACanvas.MoveTo(X, Y);
          ACanvas.LineTo(X - LOffset + J, Y - LOffset + J);
          ACanvas.MoveTo(X, Y);
          ACanvas.LineTo(X + LOffset - J, Y - LOffset + J);
          Inc(Y);
          J := 0;
        end;
     end;
    nbbtUp:
      begin
        Y := ARect.Top + (ARect.Height + LWidth - LOffset) div 2;
        for I := 1 to LWidth do
        begin
          ACanvas.MoveTo(X, Y);
          ACanvas.LineTo(X - LOffset + J, Y + LOffset - J);
          ACanvas.MoveTo(X, Y);
          ACanvas.LineTo(X + LOffset - J, Y + LOffset - J);
          Dec(Y);
          J := 0;
        end;
      end;
  end;
end;

constructor TNumberBoxSpinButtonOptions.CreateLinked(ANumberBox: TCustomNumberBox);
begin
  inherited Create;
  FButtonWidth := cDefaultButtonWidth;
  FRepeatTimerInterval := cDefaultRepeatTimerInterval;
  FNumberBox := ANumberBox;
  FPlacement := nbspNone;
  FArrowColor := clWindowText;
  FArrowHotColor := clWindowText;
  FArrowPressedColor := clWindowText;
  FArrowDisabledColor := clGrayText;
  FShowInlineDividers := True;
end;

procedure TNumberBoxSpinButtonOptions.Assign(Source: TPersistent);
begin
  if Source is TNumberBoxSpinButtonOptions then
  begin
    FArrowWidth := TNumberBoxSpinButtonOptions(Source).FArrowWidth;
    FButtonWidth := TNumberBoxSpinButtonOptions(Source).FButtonWidth;
    FPlacement := TNumberBoxSpinButtonOptions(Source).FPlacement;
    FArrowColor := TNumberBoxSpinButtonOptions(Source).FArrowColor;
    FArrowHotColor := TNumberBoxSpinButtonOptions(Source).FArrowHotColor;
    FArrowPressedColor := TNumberBoxSpinButtonOptions(Source).FArrowPressedColor;
    FArrowDisabledColor := TNumberBoxSpinButtonOptions(Source).FArrowDisabledColor;
    FShowInlineDividers := TNumberBoxSpinButtonOptions(Source).FShowInlineDividers;
    FRepeatTimerInterval := TNumberBoxSpinButtonOptions(Source).FRepeatTimerInterval;
  end
  else
    inherited;
end;

procedure TNumberBoxSpinButtonOptions.Change(AFullUpdate: Boolean);
begin
  if AFullUpdate or (FPlacement <> nbspNone) then
    FNumberBox.UpdateFrame(AFullUpdate);
end;

procedure TNumberBoxSpinButtonOptions.SetArrowWidth(AValue: Integer);
begin
  if (AValue <> FArrowWidth) and (AValue >= 0) then
  begin
    FArrowWidth := AValue;
    FNumberBox.UpdateFrame(False);
  end;
end;

procedure TNumberBoxSpinButtonOptions.SetButtonWidth(AValue: Integer);
begin
  if (FButtonWidth <> AValue) and (AValue >= 15) then
  begin
    FButtonWidth := AValue;
    FNumberBox.UpdateFrame(True);
  end;
end;

procedure TNumberBoxSpinButtonOptions.SetPlacement(AValue: TNumberBoxSpinButtonPlacement);
begin
  if FPlacement <> AValue then
  begin
    FPlacement := AValue;
    if FPlacement = nbspNone then
      FNumberBox.HideButtons
    else
      FNumberBox.ShowButtons;
  end;
end;

procedure TNumberBoxSpinButtonOptions.SetArrowColor(AValue: TColor);
begin
  if FArrowColor <> AValue then
  begin
    FArrowColor := AValue;
    Change(False);
  end;
end;

procedure TNumberBoxSpinButtonOptions.SetArrowHotColor(AValue: TColor);
begin
  FArrowHotColor := AValue;
end;

procedure TNumberBoxSpinButtonOptions.SetArrowPressedColor(AValue: TColor);
begin
  FArrowPressedColor := AValue;
end;

procedure TNumberBoxSpinButtonOptions.SetArrowDisabledColor(AValue: TColor);
begin
  if FArrowDisabledColor <> AValue then
  begin
    FArrowDisabledColor := AValue;
    Change(False);
  end;
end;

procedure TNumberBoxSpinButtonOptions.SetShowInlineDividers(AValue: Boolean);
begin
  if FShowInlineDividers <> AValue then
  begin
    FShowInlineDividers := AValue;
    Change(False);
  end;
end;

constructor TNumberBoxButton.CreateLinked(AButtonType: TNumberBoxButtonType; ANumberBox: TCustomNumberBox);
begin
  inherited;
  FNumberBox := ANumberBox;
  FButtonType := AButtonType;
end;

procedure TNumberBoxButton.Click;
begin
  FNumberBox.DoButtonClick(FButtonType);
end;

procedure TNumberBoxButton.Draw(ACanvas: TCanvas);
var
  LBuffer: TBitmap;
  LStyle: TCustomStyleServices;
  LRect, LDividerRect: TRect;
  LFillColor, LArrowColor: TColor;
  LFillColorAlpha: Byte;
begin
  if (FNumberBox = nil) or FButtonRect.IsEmpty then
    Exit;

  LBuffer := TBitmap.Create(FButtonRect.Width, FButtonRect.Height);
  try
    LRect := Rect(0, 0, LBuffer.Width, LBuffer.Height);
    LStyle := StyleServices(FNumberBox);
    if not (csDesigning in FNumberBox.ComponentState) and FNumberBox.IsCustomStyleActive and
        LStyle.Enabled and (seClient in FNumberBox.StyleElements) then
      LBuffer.Canvas.Brush.Color := LStyle.GetStyleColor(scEdit)
    else
      LBuffer.Canvas.Brush.Color := FNumberBox.Color;
    LBuffer.Canvas.FillRect(LRect);

    LFillColor := FNumberBox.SpinButtonOptions.ArrowColor;
    LFillColorAlpha := 0;

    if FDown and FMouseIn then
    begin
      LArrowColor := FNumberBox.SpinButtonOptions.ArrowPressedColor;
      LFillColorAlpha := 50;
    end
    else
    if FMouseIn then
    begin
      LArrowColor := FNumberBox.SpinButtonOptions.ArrowHotColor;
      LFillColorAlpha := 30;
    end
    else
    if FNumberBox.Enabled then
      LArrowColor := FNumberBox.SpinButtonOptions.ArrowColor
    else
      LArrowColor := FNumberBox.SpinButtonOptions.ArrowDisabledColor;

    if not (csDesigning in FNumberBox.ComponentState) and FNumberBox.IsCustomStyleActive and
       LStyle.Enabled and (seClient in FNumberBox.StyleElements) then
    begin
      LArrowColor := LStyle.GetSystemColor(LArrowColor);
      LFillColor := LStyle.GetSystemColor(LFillColor);
    end;

    FillRectAlpha(LBuffer.Canvas, LRect, LFillColor, LFillColorAlpha);

    if FNumberBox.SpinButtonOptions.FPlacement = nbspInline then
    begin
      if FNumberBox.SpinButtonOptions.ShowInlineDividers then
      begin
        if FNumberBox.Enabled then
          LFillColor := FNumberBox.SpinButtonOptions.ArrowColor
        else
          LFillColor := FNumberBox.SpinButtonOptions.ArrowDisabledColor;

        if not (csDesigning in FNumberBox.ComponentState) and FNumberBox.IsCustomStyleActive and
            LStyle.Enabled and (seClient in FNumberBox.StyleElements) then
          LFillColor := LStyle.GetSystemColor(LFillColor);

        LFillColorAlpha := 100;
        LDividerRect := LRect;
        if FNumberBox.BiDiMode <> bdRightToLeft then
        begin
          LDividerRect.Right := LDividerRect.Left + 1;
          Inc(LRect.Left);
        end
        else
        begin
          LDividerRect.Left := LDividerRect.Right - 1;
          Dec(LRect.Right);
        end;
        FillRectAlpha(LBuffer.Canvas, LDividerRect, LFillColor, LFillColorAlpha);
      end;
      LRect.Inflate(FNumberBox.ScaleValue(-2), FNumberBox.ScaleValue(-2));
    end
    else
      LRect.Inflate(FNumberBox.ScaleValue(-4), FNumberBox.ScaleValue(-4));

    DrawSpinButtonArrow(FButtonType, FNumberBox.SpinButtonOptions.ArrowWidth,
      LBuffer.Canvas, LRect, LArrowColor, FNumberBox.ScaleFactor);
    ACanvas.Draw(FButtonRect.Left, FButtonRect.Top, LBuffer);
  finally
    LBuffer.Free;
  end;
end;

class constructor TCustomNumberBox.Create;
begin
  TCustomStyleEngine.RegisterStyleHook(TCustomNumberBox, TNumberBoxStyleHook);
end;

class destructor TCustomNumberBox.Destroy;
begin
  TCustomStyleEngine.UnRegisterStyleHook(TCustomNumberBox, TNumberBoxStyleHook);
end;

constructor TCustomNumberBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csSetCaption];
  FSpinButtonOptions := TNumberBoxSpinButtonOptions.CreateLinked(Self);
  FUseUpDownKeys := True;
  FDownButton := -1;
  FActiveButton := -1;
  FCurrencyString := FormatSettings.CurrencyString;
  FCurrencyFormat := TNumberBoxCurrencyFormat(FormatSettings.CurrencyFormat);
  Text := '0';
  FSmallStep := cDefaultSmallStep;
  FLargeStep := cDefaultLargeStep;
  FMode := nbmInteger;
  FDecimal := FormatSettings.CurrencyDecimals;
  FNegativeValueColor := clNone;
end;

destructor TCustomNumberBox.Destroy;
begin
  FSpinButtonOptions.Free;
  FreeAndNil(FButtons[0]);
  FreeAndNil(FButtons[1]);
  inherited;
end;

function TCustomNumberBox.IsSmallStepStored: Boolean;
begin
  Result := FSmallStep <> cDefaultSmallStep;
end;

function TCustomNumberBox.IsLargeStepStored: Boolean;
begin
  Result := FLargeStep <> cDefaultLargeStep;
end;

function TCustomNumberBox.IsButtonsVisible: Boolean;
begin
  Result := FButtons[0] <> nil;
end;

procedure TCustomNumberBox.SetCurrencyString(const AValue: string);
begin
  if FCurrencyString <> AValue then
  begin
    FCurrencyString := AValue;
    if Mode = nbmCurrency then
      Invalidate;
  end;
end;

function TCustomNumberBox.IsCurrencyStringStored: Boolean;
begin
  Result := FCurrencyString <> FormatSettings.CurrencyString;
end;

procedure TCustomNumberBox.SetCurrencyFormat(const AValue: TNumberBoxCurrencyFormat);
begin
  if FCurrencyFormat <> AValue then
  begin
    FCurrencyFormat := AValue;
    if Mode = nbmCurrency then
      Invalidate;
  end;
end;

function TCustomNumberBox.IsCurrencyFormatStored: Boolean;
begin
  Result := FCurrencyFormat <> TNumberBoxCurrencyFormat(FormatSettings.CurrencyFormat);
end;

procedure TCustomNumberBox.SetDisplayFormat(const AValue: string);
begin
  if FDisplayFormat <> AValue then
  begin
    FDisplayFormat := AValue;
    Invalidate;
  end;
end;

procedure TCustomNumberBox.SetDecimal(AValue: Byte);
begin
  if (FDecimal <> AValue) and (AValue <= 20) then
  begin
    FDecimal := AValue;
    SetTextFromValue;
  end;
end;

function TCustomNumberBox.IsDecimalStored: Boolean;
begin
  Result := FDecimal <> FormatSettings.CurrencyDecimals;
end;

procedure TCustomNumberBox.SetMinValue(AValue: Extended);
begin
  if FMinValue <> AValue then
  begin
    FMinValue := AValue;
    if (FValue < FMinValue) and (FMinValue <> FMaxValue) then
      Value := FMinValue;
  end;
end;

procedure TCustomNumberBox.SetMaxValue(AValue: Extended);
begin
  if FMaxValue <> AValue then
  begin
    FMaxValue := AValue;
    if (FValue > FMaxValue) and (FMaxValue <> FMinValue) then
      Value := FMaxValue;
  end;
end;

procedure TCustomNumberBox.EvaluateExpression;
var
  LEditLink: Boolean;
  LExpression: TBindingExpression;
  LText: string;
begin
  LEditLink := Observers.IsObserving(TObserverMapping.EditLinkID);
  if LEditLink and not TLinkObservers.EditLinkEdit(Observers) then
    Exit;

  if Assigned(FOnEvaluateExpression) then
  begin
    FOnEvaluateExpression(Self);
    Exit;
  end;

  LText := Text;
  if FormatSettings.DecimalSeparator <> '.' then
    LText := LText.Replace(FormatSettings.DecimalSeparator, '.');
  LExpression := TBindings.CreateExpression([], LText);
  try
    Value := LExpression.Evaluate.GetValue.AsExtended;
  finally
    LExpression.Free;
  end;

  if LEditLink then
    TLinkObservers.EditLinkModified(Observers);
  if Observers.IsObserving(TObserverMapping.ControlValueID) then
  begin
    TLinkObservers.ControlValueModified(Observers);
    TLinkObservers.ControlValueTrackUpdate(Observers);
  end;
end;

                                                                              
                                      
procedure TCustomNumberBox_ApplyConstraints(Self: TCustomNumberBox);
begin
  with Self do
    if (FMinValue <> FMaxValue) or (FMode in [nbmInteger, nbmCurrency]) then
      SetValue(FValue);
end;

procedure TCustomNumberBox.Loaded;
begin
  inherited;
  TCustomNumberBox_ApplyConstraints(Self);
  SetTextFromValue;
end;

procedure TCustomNumberBox.Change;
var
  LValue: Extended;
begin
  if not FValueChanging and (Text = '') then
  begin
    FTextChanging := True;
    try
      if FUseNaNValue and (FMode <> nbmInteger) then
        Value := NaN
      else
        Value := 0;
    finally
      FTextChanging := False;
    end;
  end
  else
  if not FValueChanging and (Text <> '') and IsNumericText then
  begin
    FTextChanging := True;
    try
      LValue := StrToFloat(Text);
      Value := LValue;
    finally
      FTextChanging := False;
    end;
    if LValue <> Value then
      SetTextFromValue;
  end;
  inherited;
end;

procedure TCustomNumberBox.DoChangeValue;
begin
  if not (csLoading in ComponentState) then
    if Assigned(FOnChangeValue) then
      FOnChangeValue(Self);
end;

procedure TCustomNumberBox.SetTextFromValue;
begin
  if not FTextChanging then
  begin
    FValueChanging := True;
    try
      if FValue.IsNan then
        Text := ''
      else
        case Mode of
          nbmInteger:
            Text := IntToStr(ValueInt);
          nbmFloat, nbmCurrency:
            Text := FloatToStrF(FValue, ffFixed, 22, FDecimal);
        end;
    finally
      FValueChanging := False;
    end;
  end;
end;

procedure TCustomNumberBox.SetValue(AValue: Extended);
begin
  if not AValue.IsNaN then
  begin
    if not (FTextChanging and Focused) then
    begin
      if (AValue > FMaxValue) and (FMinValue <> FMaxValue) then
        AValue := FMaxValue
      else
      if (AValue < FMinValue) and (FMinValue <> FMaxValue) then
        AValue := FMinValue;
      if FMode = nbmInteger then
      begin
        if AValue > MaxInt then
          AValue := MaxInt
        else
        if AValue < -MaxInt then
          AValue := -MaxInt;
      end
      else if FMode = nbmCurrency then
      begin
        if AValue > MaxCurrency then
          AValue := MaxCurrency
        else
        if AValue < MinCurrency then
          AValue := MinCurrency;
      end;
    end;
  end;

  if (FValue <> AValue) or string(Text).Trim.IsEmpty then
  begin
    FValue := AValue;
    SetTextFromValue;
    DoChangeValue;
  end;
end;

procedure TCustomNumberBox.SetMode(AValue: TNumberBoxMode);
begin
  if FMode <> AValue then
  begin
    FMode := AValue;
    SetTextFromValue;
    Invalidate;
  end;
end;

procedure TCustomNumberBox.SetNegativeValueColor(const AValue: TColor);
begin
  if FNegativeValueColor <> AValue then
  begin
    FNegativeValueColor := AValue;
    Invalidate;
  end;
end;

procedure TCustomNumberBox.SetSmallStep(AValue: Extended);
begin
  if (FSmallStep <> AValue) and (AValue > 0) then
    FSmallStep := AValue;
end;

procedure TCustomNumberBox.SetLargeStep(AValue: Extended);
begin
  if (FLargeStep <> AValue) and (AValue > 0) then
    FLargeStep := AValue;
end;

procedure TCustomNumberBox.SetAcceptExpressions(AValue: Boolean);
begin
  if FAcceptExpressions <> AValue then
  begin
    FAcceptExpressions := AValue;
    Invalidate;
  end;
end;

function TCustomNumberBox.GetValueInt: Integer;
begin
  if not FValue.IsNaN then
    Result := Round(FValue)
  else
    Result := 0;
end;

function TCustomNumberBox.GetValueFloat: Extended;
begin
  Result := RoundTo(FValue, -FDecimal);
end;

function TCustomNumberBox.GetValueCurrency: Currency;
begin
  if not FValue.IsNaN then
  begin
{$IF SizeOf(Extended) >= 10}
    Result := FloatToCurr(ValueFloat);
{$ELSE}
    var s: string;
    if FDecimal > 0 then
      s := FormatFloat('0.' + StringOfChar('0', FDecimal), FValue)
    else
      s := FormatFloat('0', FValue);
    Result := StrToCurr(s);
{$ENDIF}
  end
  else
    Result := 0;
end;

procedure TCustomNumberBox.SetValueInt(const AValue: Integer);
begin
  Value := AValue;
end;

procedure TCustomNumberBox.SetValueFloat(const AValue: Extended);
begin
  Value := RoundTo(AValue, -FDecimal);
end;

procedure TCustomNumberBox.SetValueCurrency(const AValue: Currency);
begin
  ValueFloat := AValue;
end;

procedure TCustomNumberBox.ShowButtons;
begin
  if FButtons[0] = nil then
    FButtons[0] := TNumberBoxButton.CreateLinked(nbbtUp, Self);
  if FButtons[1] = nil then
    FButtons[1] := TNumberBoxButton.CreateLinked(nbbtDown, Self);
  UpdateFrame(True);
end;

procedure TCustomNumberBox.HideButtons;
begin
  FreeAndNil(FButtons[0]);
  FreeAndNil(FButtons[1]);
  UpdateFrame(True);
end;

procedure TCustomNumberBox.UpdateFrame(AFullUpdate: Boolean);
begin
  if HandleAllocated and not (csLoading in ComponentState) then
    if AFullUpdate then
    begin
      SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_FRAMECHANGED or SWP_NOACTIVATE or
        SWP_NOMOVE or SWP_NOSIZE or SWP_NOZORDER);
      Invalidate;
    end
    else
      SendMessage(Handle, WM_NCPAINT, 0, 0);
end;

procedure TCustomNumberBox.DoButtonClick(AButtonType: TNumberBoxButtonType);
var
  LStep: Extended;
begin
  if not ReadOnly then
  begin
    LStep := 0;
    case AButtonType of
      nbbtUp:
        LStep := SmallStep;
      nbbtDown:
        LStep := - SmallStep;
    end;
    if LStep <> 0 then
      EditValue(LStep);
  end;
end;

procedure TCustomNumberBox.DrawButtons(ACanvas: TCanvas);
var
  LFrameRect, LRect: TRect;
  LStyle: TCustomStyleServices;
  LColor: TColor;
begin
  if not IsButtonsVisible then
    Exit;

  LFrameRect := Rect(0, 0, Width, Height);
  if BorderStyle = bsSingle then
    LFrameRect.Inflate(-2, -2);

  case FSpinButtonOptions.Placement of
    nbspCompact:
    begin
      if BidiMode <> bdRightToLeft then
      begin
        FButtons[0].FButtonRect := Rect(LFrameRect.Right - FSpinButtonOptions.ButtonWidth,
          LFrameRect.Top, LFrameRect.Right, LFrameRect.Top + LFrameRect.Height div 2);
        FButtons[1].FButtonRect := Rect(LFrameRect.Right - FSpinButtonOptions.ButtonWidth,
          FButtons[0].FButtonRect.Bottom, LFrameRect.Right, LFrameRect.Bottom);
      end
      else
      begin
        FButtons[0].FButtonRect := Rect(LFrameRect.Left,
          LFrameRect.Top, LFrameRect.Left + FSpinButtonOptions.ButtonWidth, LFrameRect.Top + LFrameRect.Height div 2);
        FButtons[1].FButtonRect := Rect(LFrameRect.Left,
          FButtons[0].FButtonRect.Bottom, LFrameRect.Left + FSpinButtonOptions.ButtonWidth, LFrameRect.Bottom);
      end;

      if FButtons[1].FButtonRect.Height > FButtons[0].FButtonRect.Height then
      begin
        LRect := FButtons[1].FButtonRect;
        LRect.Bottom := LRect.Top + 1;
        LStyle := StyleServices(Self);
        if not (csDesigning in ComponentState) and IsCustomStyleActive and
            LStyle.Enabled and (seClient in StyleElements) then
          LColor := LStyle.GetStyleColor(scEdit)
        else
          LColor := Color;
        ACanvas.Brush.Style := bsSolid;
        ACanvas.Brush.Color := LColor;
        ACanvas.FillRect(LRect);
        Inc(FButtons[1].FButtonRect.Top);
      end;
    end;

    nbspInline:
      begin
        if BidiMode <> bdRightToLeft then
        begin
          FButtons[0].FButtonRect := Rect(LFrameRect.Right - FSpinButtonOptions.ButtonWidth * 2,
            LFrameRect.Top, LFrameRect.Right - FSpinButtonOptions.ButtonWidth, LFrameRect.Bottom);
          FButtons[1].FButtonRect := Rect(FButtons[0].FButtonRect.Right,
            LFrameRect.Top, LFrameRect.Right, LFrameRect.Bottom);
        end
        else
        begin
          FButtons[0].FButtonRect := Rect(LFrameRect.Left,
            LFrameRect.Top, LFrameRect.Left + FSpinButtonOptions.ButtonWidth, LFrameRect.Bottom);
          FButtons[1].FButtonRect := Rect(FButtons[0].FButtonRect.Right,
            LFrameRect.Top, FButtons[0].FButtonRect.Right + FSpinButtonOptions.ButtonWidth, LFrameRect.Bottom);
        end;
      end;
  end;

  FButtons[0].Draw(ACanvas);
  FButtons[1].Draw(ACanvas);
end;

procedure TCustomNumberBox.WMChar(var Message: TWMChar);
var
  LPrevText: TCaption;
begin
  inherited;
  if Message.CharCode = VK_RETURN then
  begin
    LPrevText := Text;
    if FAcceptExpressions then
      EvaluateExpression
    else
      TCustomNumberBox_ApplyConstraints(Self);
    if LPrevText <> Text then
      SelectAll;
  end;
end;

procedure TCustomNumberBox.WMNCPaint(var Message: TWMNCPaint);
var
  LDC: HDC;
  LCanvas: TCanvas;
begin
  inherited;
  if not IsButtonsVisible then
    Exit;

  LDC := GetWindowDC(Handle);
  try
    LCanvas := TCanvas.Create;
    LCanvas.Handle := LDC;
    try
      DrawButtons(LCanvas);
    finally
      LCanvas.Handle := 0;
      LCanvas.Free;
    end;
  finally
    ReleaseDC(Handle, LDC);
  end;
end;

procedure TCustomNumberBox.WMNCCalcSize(var Message: TWMNCCalcSize);
var
  LButtonsWidth: Integer;
begin
  if IsButtonsVisible then
  begin
    LButtonsWidth := FSpinButtonOptions.ButtonWidth;
    if FSpinButtonOptions.Placement = nbspInline then
      LButtonsWidth := LButtonsWidth * 2;
    if BidiMode <> bdRightToLeft then
      Dec(Message.CalcSize_Params^.rgrc[0].Right, LButtonsWidth)
    else
      Inc(Message.CalcSize_Params^.rgrc[0].Left, LButtonsWidth);
  end;
  inherited;
end;

procedure TCustomNumberBox.WMSize(var Msg: TWMSize);
begin
  inherited;
  UpdateFrame(False);
end;

procedure TCustomNumberBox.ChangeScale(M, D: Integer; isDpiChange: Boolean);
begin
  FSpinButtonOptions.FButtonWidth := MulDiv(FSpinButtonOptions.FButtonWidth, M, D);
  FSpinButtonOptions.FArrowWidth := MulDiv(FSpinButtonOptions.FArrowWidth, M, D);
  inherited;
end;

procedure TCustomNumberBox.WMNCHitTest(var Message: TMessage);
begin
  inherited;
  if IsButtonsVisible and (Message.Result = Winapi.Windows.HTNOWHERE) then
  begin
    FMouseOverButtons := True;
    Message.Result := HTCLIENT;
  end
  else
    FMouseOverButtons := False;
end;

procedure TCustomNumberBox.WMSetCursor(var Message: TWMSetCursor);
begin
  if FMouseOverButtons then
    Message.HitTest := Winapi.Windows.HTNOWHERE;
  inherited;
end;

function TCustomNumberBox.ButtonAtPos(APos: TPoint): Integer;
var
  I: Integer;
begin
  Result := -1;
  if not IsButtonsVisible then
    Exit;

  if BorderStyle = bsSingle then
    APos.Offset(2, 2);

  for I := 0 to 1 do
    if FButtons[I].ButtonRect.Contains(APos) then
    begin
      Result := I;
      Break;
    end;
end;

procedure TCustomNumberBox.WMLButtonDblClk(var Message: TMessage);
begin
  if FMouseOverButtons then
    WMLButtonDown(Message)
  else
    inherited;
end;

procedure TCustomNumberBox.WMRButtonDown(var Message: TMessage);
begin
  if FMouseOverButtons then
  begin
    Message.Result := 0;
  end
  else
    inherited;
end;

procedure TCustomNumberBox.WMLButtonDown(var Message: TMessage);
begin
  FDownButton := -1;
  if FMouseOverButtons then
  begin
    if not Focused then
      SetFocus;
    if FActiveButton <> -1 then
    begin
      FButtons[FActiveButton].Down := True;
      UpdateFrame(False);
      FDownButton := FActiveButton;
      SetCapture(Handle);
      InitTimer(Ord(FButtons[FActiveButton].FButtonType) + 1);
    end;
    Message.Result := 0;
  end
  else
    inherited;
end;

procedure TCustomNumberBox.WMLButtonUp(var Message: TWMLButtonUp);
var
  LUpdateIndex: Integer;
  LNeedClick: Boolean;
begin
  ReleaseCapture;

  LNeedClick := FTimerMode < 3;
  StopTimer;

  if FMouseOverButtons or (FDownButton <> -1) then
  begin
    LUpdateIndex := FDownButton;
    if LUpdateIndex <> -1 then
    begin
      FButtons[LUpdateIndex].Down := False;
      FButtons[LUpdateIndex].MouseIn := FActiveButton = LUpdateIndex;
      UpdateFrame(False);
      if LNeedClick and FButtons[LUpdateIndex].MouseIn then
        FButtons[LUpdateIndex].Click;
    end;
    FDownButton := -1;
    Message.Result := 0;
  end
  else
    inherited;
end;

procedure TCustomNumberBox.CheckMouseLeave;
var
  I: Integer;
  LNeedUpdate: Boolean;
begin
  if IsButtonsVisible then
  begin
    FActiveButton := -1;
    LNeedUpdate := False;
    for I := 0 to 1 do
      if FButtons[I].MouseIn then
      begin
        if FDownButton = I then
          StopTimer;
        FButtons[I].MouseIn := False;
        LNeedUpdate := True;
      end;

    if LNeedUpdate then
      UpdateFrame(False);
  end;
end;

procedure TCustomNumberBox.WMMouseMove(var Message: TWMMouseMove);
var
  LOldActiveButton: Integer;
begin
  if FMouseOverButtons then
  begin
    LOldActiveButton := FActiveButton;
    FActiveButton := ButtonAtPos(Message.Pos);
    if (FActiveButton <> -1) and (LOldActiveButton <> FActiveButton) then
    begin
      FButtons[FActiveButton].MouseIn := True;
      if LOldActiveButton <> -1 then
        FButtons[LOldActiveButton].MouseIn := False;
      UpdateFrame(False);
      if FDownButton = FActiveButton then
        StartTimer(Ord(FButtons[FActiveButton].FButtonType) + 1)
      else
      if FDownButton = LOldActiveButton then
        StopTimer;
    end
    else
    if (LOldActiveButton <> -1) and (FActiveButton = -1) then
    begin
      FButtons[LOldActiveButton].MouseIn := False;
      UpdateFrame(False);
      if FDownButton = LOldActiveButton then
        StopTimer;
    end;
    Message.Result := 0;
  end
  else
  begin
    CheckMouseLeave;
    inherited;
  end;
end;

procedure TCustomNumberBox.CMExit(var Message: TCMExit);
var
  s: TCaption;
begin
  inherited;
  s := Text;
  try
    TCustomNumberBox_ApplyConstraints(Self);
    SetTextFromValue;
  finally
    if s = Text then
      Invalidate;
  end;
end;

procedure TCustomNumberBox.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  CheckMouseLeave;
end;

procedure TCustomNumberBox.WMTimer(var Message: TWMTimer);
begin
  inherited;
  if Message.TimerID = 1 then
    case FTimerMode of
      1: StartTimer(1);
      2: StartTimer(2);
      3: DoButtonClick(nbbtUp);
      4: DoButtonClick(nbbtDown);
    end;
end;

procedure TCustomNumberBox.InitTimer(ATimerMode: Integer);
begin
  FTimerMode := ATimerMode;
  SetTimer(Handle, 1, 500, nil);
end;

procedure TCustomNumberBox.StartTimer(ATimerMode: Integer);
begin
  if FTimerMode > 0 then
    KillTimer(Handle, 1);

  FTimerMode := ATimerMode + 2;
  SetTimer(Handle, 1, FSpinButtonOptions.RepeatTimerInterval, nil);
end;

procedure TCustomNumberBox.StopTimer;
begin
  if FTimerMode > 0 then
  begin
    FTimerMode := 0;
    KillTimer(Handle, 1);
  end;
end;

function TCustomNumberBox.EditValue(const AStep: Extended): Boolean;
var
  LEditLink: Boolean;
  LPrevValue: Extended;
begin
  Result := False;
  LEditLink := Observers.IsObserving(TObserverMapping.EditLinkID);
  if LEditLink and not TLinkObservers.EditLinkEdit(Observers) then
    Exit;

  LPrevValue := Value;
  Value := Value + AStep;
  if Wrap and (Value = LPrevValue) then
    if AStep > 0 then
      Value := MinValue
    else
    if AStep < 0 then
      Value := MaxValue;

  Result := True;
  if LEditLink then
    TLinkObservers.EditLinkModified(Observers);
  if Observers.IsObserving(TObserverMapping.ControlValueID) then
  begin
    TLinkObservers.ControlValueModified(Observers);
    TLinkObservers.ControlValueTrackUpdate(Observers);
  end;
end;

procedure TCustomNumberBox.WMMouseWheel(var Message: TWMMouseWheel);
var
  LStep: Extended;
begin
  inherited;
  if FUseMouseWheel and not ReadOnly then
  begin
    if Message.WheelDelta > 0 then
      LStep := FSmallStep
    else
      LStep := - FSmallStep;
    if LStep <> 0 then
      EditValue(LStep);
  end;
end;

procedure TCustomNumberBox.KeyDown(var Key: Word; Shift: TShiftState);
var
  LStep: Extended;
begin
  inherited;
  if (Key = Ord('A')) and (Shift = [ssCtrl]) then
  begin
    SelectAll;
    Key := 0;
  end
  else if FUseUpDownKeys and not ReadOnly then
  begin
    LStep := 0;
    case Key of
      VK_UP:
        LStep := FSmallStep;
      VK_DOWN:
        LStep := - FSmallStep;
      VK_PRIOR:
        LStep := FLargeStep;
      VK_NEXT:
        LStep := - FLargeStep;
    end;
    if LStep <> 0 then
    begin
      Key := 0;
      EditValue(LStep);
    end;
  end;
end;

procedure TCustomNumberBox.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  if csDesigning in ComponentState then
  begin
    UpdateFrame(False);
    Invalidate;
  end;
end;

procedure TCustomNumberBox.DrawDisplayText(AText: string; ACanvas: TCanvas;
  ANegative: Boolean);
const
  StyleFontColor: array[Boolean] of TStyleFont = (sfEditBoxTextDisabled, sfEditBoxTextNormal);
  StyleColor: array[Boolean] of TStyleColor = (scEditDisabled, scEdit);
var
  LBrushColor, LTextColor: TColor;
  LStyle: TCustomStyleServices;
  X, Y: Integer;
  LDrawRect: TRect;
begin
  LStyle := StyleServices(Self);

  if not (csDesigning in ComponentState) and IsCustomStyleActive and (seFont in StyleElements) then
  begin
    LBrushColor := LStyle.GetStyleColor(StyleColor[Enabled]);
    if Enabled and ANegative and (NegativeValueColor <> clNone) then
      LTextColor := NegativeValueColor
    else
      LTextColor := LStyle.GetStyleFontColor(StyleFontColor[Enabled]);
  end
  else
  begin
    LBrushColor := Self.Color;
    if Enabled then
      if ANegative and (NegativeValueColor <> clNone) then
        LTextColor := NegativeValueColor
      else
        LTextColor := Font.Color
    else
      LTextColor := clGrayText;
  end;

  LDrawRect := ClientRect;
  ACanvas.Brush.Color := LBrushColor;
  ACanvas.Brush.Style := bsSolid;
  ACanvas.FillRect(LDrawRect);
  ACanvas.Font.Assign(Font);

  LDrawRect.Inflate(-1, -1);
  X := 0;
  if BidiMode <> bdRightToLeft then
    case Alignment of
    taLeftJustify:
      X := LDrawRect.Left;
    taRightJustify:
      X := LDrawRect.Right - ACanvas.TextWidth(AText);
    taCenter:
      X := LDrawRect.Left + (LDrawRect.Width - ACanvas.TextWidth(AText)) div 2;
    end
  else
    case Alignment of
    taLeftJustify:
      X := LDrawRect.Right - ACanvas.TextWidth(AText);
    taRightJustify:
      X := LDrawRect.Left;
    taCenter:
      X := LDrawRect.Left + (LDrawRect.Width - ACanvas.TextWidth(AText)) div 2;
    end;
  Y := LDrawRect.Top + (LDrawRect.Height - ACanvas.TextHeight(AText)) div 2 - 1;

  ACanvas.Font.Color := LTextColor;
  ACanvas.Brush.Style := bsClear;
  ACanvas.TextRect(ClientRect, X, Y, AText);
end;

function TCustomNumberBox.GetDisplayText: string;
var
  LCurr: string;
begin
  if FDisplayFormat <> '' then
    Result := FormatFloat(FDisplayFormat, FValue)
  else
  begin
    if (FDecimal > 0) and (Mode <> nbmInteger) then
      Result := FormatFloat(',0.' + StringOfChar('0', FDecimal), ValueFloat)
    else
      Result := FormatFloat(',0', ValueFloat);
    if (FMode = nbmCurrency) and (FCurrencyString.Trim <> '') and (CurrencyFormat <> nbcfNone) then
    begin
      LCurr := FCurrencyString;
      case CharCase of
        TEditCharCase.ecNormal:    ;
        TEditCharCase.ecUpperCase: LCurr := AnsiUpperCase(LCurr);
        TEditCharCase.ecLowerCase: LCurr := AnsiLowerCase(LCurr);
      end;
      case CurrencyFormat of
        nbcfPrefix:       Result := LCurr + Result;
        nbcfPostfix:      Result := Result + LCurr;
        nbcfPrefixSpace:  Result := LCurr + ' ' + Result;
        nbcfPostfixSpace: Result := Result + ' ' + LCurr;
      end;
    end;
  end;
end;

procedure TCustomNumberBox.WMPaint(var Message: TWMPaint);
var
  LDC: HDC;
  LPS: TPaintStruct;
  LCanvas: TCanvas;
  LText: string;
begin
  if (Text <> '') and not Focused then
  begin
    LDC := Message.DC;
    if LDC = 0 then
      LDC := BeginPaint(Handle, LPS);
    try
      LCanvas := TCanvas.Create;
      LCanvas.Handle := LDC;
      try
        LText := GetDisplayText;
        DrawDisplayText(LText, LCanvas, Sign(Value) = NegativeValue);
      finally
        LCanvas.Handle := 0;
        LCanvas.Free;
      end;
    finally
      if Message.DC = 0 then
        EndPaint(Handle, LPS);
    end;
  end
  else
    inherited;
end;

function TCustomNumberBox.GetValidCharSet(AAcceptExpressions: Boolean): TSysCharSet;
begin
  Result := ['0'..'9'];
  if (Mode <> nbmInteger) and (FDecimal > 0) then
    Result := Result + [FormatSettings.DecimalSeparator];
  if AAcceptExpressions then
    Result := Result + ['(', ')', '+', '-', '*', '/', ' ']
  else
  if (FMinValue < 0) or (FMinValue = 0) and (FMaxValue = 0) then
    Result := Result + ['-'];
end;

function TCustomNumberBox.IsNumericText(const AText: string): Boolean;
var
  LCharSet: TSysCharSet;
  I: Integer;
  LDecSepCount: Integer;
begin
  if (AText = '') or (AText = '-') or (AText = FormatSettings.DecimalSeparator) then
    Exit(False);

  Result := True;
  LDecSepCount := 0;

  LCharSet := GetValidCharSet(False);
  for I := 1 to AText.Length do
  begin
    if not CharInSet(AText[I], LCharSet) then
    begin
      Result := False;
      Break;
    end
    else
    if (AText[I] = '-') and (I > 1) then
    begin
      Result := False;
      Break;
    end
    else
    if AText[I] = FormatSettings.DecimalSeparator then
    begin
      Inc(LDecSepCount);
      if LDecSepCount > 1 then
      begin
        Result := False;
        Break;
      end;
    end;
  end;
end;

function TCustomNumberBox.IsNumericText: Boolean;
begin
  Result := IsNumericText(Text);
end;

function TCustomNumberBox.IsValidChar(AKey: Char): Boolean;
var
  LText: string;
  LCharSet: TSysCharSet;
  LPos1, LPos2: Integer;
begin
  LCharSet := GetValidCharSet(FAcceptExpressions);
  Result := CharInSet(AKey, LCharSet) or (AKey < #32);

  if Result and not AcceptExpressions then
  begin
    LText := Text;
    if (AKey = FormatSettings.DecimalSeparator) and LText.Contains(FormatSettings.DecimalSeparator) then
      Result := False
    else
    if (AKey = '-') and ((SelStart <> 0) or LText.Contains('-')) then
      Result := False
    else
    if (AKey <> '-') and LText.Contains('-') and (SelStart = 0) and (SelLength = 0) then
      Result := False
    else
    if CharInSet(AKey, ['0'..'9']) and LText.Contains(FormatSettings.DecimalSeparator) then
    begin
      LPos1 := LText.IndexOf(FormatSettings.DecimalSeparator);
      LPos2 := LText.Length - LPos1;
      Result := not ((SelLength = 0) and (SelStart > LPos1) and (LPos2 > FDecimal));
    end;
  end;

  if Assigned(FOnValidateChar) then
    FOnValidateChar(AKey, Result);
end;

procedure TCustomNumberBox.KeyPress(var Key: Char);
begin
  if not IsValidChar(Key) then
  begin
    Key := #0;
    MessageBeep(0);
  end;
  inherited KeyPress(Key);
end;

procedure TNumberBoxStyleHook.PaintNC(Canvas: TCanvas);
begin
  if Control is TCustomNumberBox then
    TCustomNumberBox(Control).DrawButtons(Canvas);
  inherited;
end;

{$R-}
procedure TCustomNumberBox.WMCut(var Message: TMessage);
var
  LEditText: string;
  LStart: Integer;
  LLen: Integer;
begin
  if ReadOnly then
  begin
    inherited;
    Exit;
  end;

  CopyToClipboard;
  LEditText := Text;
  LStart := SelStart;
  LLen := SelLength;
  if LLen > 0 then
    Delete(LEditText, LStart + 1, LLen);

  if IsNumericText(LEditText) or (LEditText = '') then
  begin
    Text := LEditText;
    SelLength := 0;
    if HandleAllocated then
      SendMessage(Winapi.Windows.GetParent(Handle), WM_COMMAND,
        MakeWParam(GetDlgCtrlID(Handle), EN_CHANGE), LPARAM(Handle));
  end;
end;

procedure TCustomNumberBox.WMPaste(var Message: TMessage);
var
  LText, LEditText: string;
  LStart: Integer;
  LLen: Integer;
begin
  if ReadOnly then
  begin
    inherited;
    Exit;
  end;

  Clipboard.Open;
  LText := Clipboard.AsText;
  Clipboard.Close;

  LText := StringReplace(LText, CurrencyString, '', [rfIgnoreCase, rfReplaceAll]);
  LText := StringReplace(LText, FormatSettings.ThousandSeparator, '', [rfReplaceAll]);
  if FormatSettings.DecimalSeparator = ',' then
    LText := StringReplace(LText, '.', FormatSettings.DecimalSeparator, [rfReplaceAll])
  else
    LText := StringReplace(LText, ',', FormatSettings.DecimalSeparator, [rfReplaceAll]);
  LText := StringReplace(LText, ' ', '', [rfReplaceAll]);

  LEditText := Text;
  LStart := SelStart;
  LLen := SelLength;
  if LLen > 0 then
    Delete(LEditText, LStart + 1, LLen);
  Insert(LText, LEditText, LStart + 1);

  if IsNumericText(LEditText) or (LEditText = '') then
  begin
    Text := LEditText;
    SelStart := LStart + Length(LText);
    SelLength := 0;
    if HandleAllocated then
      SendMessage(Winapi.Windows.GetParent(Handle), WM_COMMAND,
        MakeWParam(GetDlgCtrlID(Handle), EN_CHANGE), LPARAM(Handle));
  end;
end;

end.


