{*******************************************************}
{                                                       }
{            Delphi Visual Component Library            }
{                                                       }
{ Copyright(c) 1995-2023 Embarcadero Technologies, Inc. }
{              All rights reserved                      }
{                                                       }
{*******************************************************}

unit Vcl.TitleBarCtrls;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  Winapi.Windows,
  Winapi.Messages,
  Winapi.GDIPAPI,
  Winapi.GDIPOBJ,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Buttons,
  Vcl.Forms;

type
  TSystemButton = (sbMinimize, sbRestore, sbClose, sbCustom, sbSpacer);
  /// <summary>
  /// TSystemTitlebarButton implements a button control to be used in the form titlebar,
  /// The control mimics the system caption buttons per the ButtonKind property.
  /// </summary>
  TSystemTitlebarButton = class(TCustomSpeedButton)
  strict private type
    TGlowWindow = class
      FWindowHandle, FWndMethod : THandle;
      procedure InitWindow;
      procedure LoadImage;
    private
      FLeft, FTop: Integer;
      FVisible: Boolean;
      procedure SetVisible(const Value: Boolean);
    public
      constructor Create;
      destructor Destroy; override;
      procedure SetLocation(X, Y : Integer);
      property Visible: Boolean read FVisible write SetVisible;
    end;
  private
    FOnPaint: TNotifyEvent;
    FClient: TCustomForm;
    FButtonType: TSystemButton;
    FPath: TGPGraphicsPath;
    FGlow: TSystemTitlebarButton.TGlowWindow;
    FBitmapList: TObjectDictionary<string, TBitmap>;
    FIndex, FCount : Integer;
    FDesignMode: Boolean;
    function GetClient: TCustomForm;
    procedure SetButtonType(const Value: TSystemButton);

    procedure DrawWin10CloseSymbol(ACanvas: TCanvas; ARect: TRect; FGColor, BGColor: TColor);
    procedure DrawWin10MaximizeSymbol(ACanvas: TCanvas; ARect: TRect; FGColor, BGColor: TColor);
    procedure DrawWin10RestoreSymbol(ACanvas: TCanvas; ARect: TRect; FGColor, BGColor: TColor);
    procedure DrawWin10MinimizeSymbol(ACanvas: TCanvas; ARect: TRect; FGColor, BGColor: TColor);

    procedure DrawWin81Symbol(AChar: Char; ACanvas: TCanvas; ARect: TRect; FGColor, BGColor: TColor);
    procedure DrawWin81CloseSymbol(ACanvas: TCanvas; ARect: TRect; FGColor, BGColor: TColor);
    procedure DrawWin81MaximizeSymbol(ACanvas: TCanvas; ARect: TRect; FGColor, BGColor: TColor);
    procedure DrawWin81RestoreSymbol(ACanvas: TCanvas; ARect: TRect; FGColor, BGColor: TColor);
    procedure DrawWin81MinimizeSymbol(ACanvas: TCanvas; ARect: TRect; FGColor, BGColor: TColor);

    procedure DrawWin7CaptionButton;
    procedure DrawWin81CaptionButton;
    procedure DrawWin10CaptionButton;
    procedure DrawWin10CaptionButtonDesign;
    function GetGraphicsPath: TGPGraphicsPath;
    function GetSymbolSize: Integer;
    function DoGlassPaint: Boolean;
    function GetBitmapResource(AName: string): TBitmap;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
  protected
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
    property Client: TCustomForm read GetClient;
    property Path: TGPGraphicsPath read GetGraphicsPath;
    property CollectionIndex: Integer read FIndex;
  public
    property Canvas;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Action;
    property Align;
    property Anchors;
    /// <summary>
    /// ButtonType use this property to read or set the button type.
    /// Supported types are:
    ///
    ///   sbMinimize - mimics the system minimize caption button
    ///   sbRestore  - mimics the system restore/maximize caption button
    ///   sbClose    - mimics the system close caption button
    ///   sbCustom   - used to custom draw the caption button using the OnPaint event.
    ///
    /// </summary>
    property ButtonType: TSystemButton read FButtonType write SetButtonType;
    property Constraints;
    property Enabled;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;
  end;

  TTitleBarPaintEvent = procedure(Sender: TObject; Canvas: TCanvas; var ARect: TRect) of object;
  TCustomTitleBarPanel = class;
  TCustomButtons = class;
  TCaptionButtonItem = class;
  TCustomButtonsClass = class of TCustomButtons;
  TCaptionButtonItemClass = class of TCaptionButtonItem;

  TCaptionButtonItem = class(TCollectionItem)
  private
    FTitlebarButton: TSystemTitlebarButton;
    procedure SetTitlebarButton(const Value: TSystemTitlebarButton);
    procedure SetButtonType(const Value: TSystemButton);
    procedure SetVisible(const Value: Boolean);
    procedure SetEnabled(const Value: Boolean);
    procedure SetOnClick(const Value: TNotifyEvent);
    procedure SetOnPaint(const Value: TNotifyEvent);
    function GetButtonType: TSystemButton;
    function GetEnabled: Boolean;
    function GetHint: String;
    function GetWidth: Integer;
    function GetOnClick: TNotifyEvent;
    function GetOnPaint: TNotifyEvent;
    function GetVisible: Boolean;
    procedure SetWidth(Value: Integer);
    procedure SetHint(const Value: String);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  protected
    property Button: TSystemTitlebarButton read FTitlebarButton write SetTitlebarButton;
  published
    property ButtonType: TSystemButton read GetButtonType write SetButtonType;
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property Hint: String read GetHint write SetHint;
    property Width: Integer read GetWidth write SetWidth;
    property Visible: Boolean read GetVisible write SetVisible;
    property OnPaint: TNotifyEvent read GetOnPaint write SetOnPaint;
    property OnClick: TNotifyEvent read GetOnClick write SetOnClick;
  end;

  TCustomButtons = class(TCollection)
  strict private
    FTitleBarPanel: TCustomTitleBarPanel;
  protected
    function GetItem(Index: Integer): TCaptionButtonItem;
    function GetOwner: TPersistent; override;
    procedure SetItem(Index: Integer; const Value: TCaptionButtonItem);
  public
    constructor Create(const ATitleBarPanel: TCustomTitleBarPanel;
      const ItemClass: TCollectionItemClass); overload; virtual;
    property TitleBarPanel: TCustomTitleBarPanel read FTitleBarPanel;
    property Items[Index: Integer]: TCaptionButtonItem read GetItem write SetItem; default;
  end;

  TCustomTitleBarPanel = class(TCustomTransparentControl)
  strict private
    FAlphaValue: Byte;
    FClient: TCustomForm;
    FLastWindowStateUpdated: TWindowState;
    FOnPaint: TTitleBarPaintEvent;
    FOnUpdateTitlebarButtons: TNotifyEvent;
    FTitleButtonClose, FTitleButtonRestore,
    FTitleButtonMin: TSystemTitlebarButton;
    procedure UpdateAlign;
    procedure WMEraseBkgnd(var Message: TWmEraseBkgnd); message WM_ERASEBKGND;
    function GetClient: TCustomForm;
    property Client: TCustomForm read GetClient;
    procedure TitleButtonCloseClick(Sender: TObject);
    procedure TitleButtonRestoreClick(Sender: TObject);
    procedure TitleButtonMinClick(Sender: TObject);
    procedure SetTitleButtonsVisibility(Value: Boolean);
    function UpdateCustomButtons(XOffset: Integer = 0): TRect;
    function  IsValidState(AState: DWORD): Boolean;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
  private
    FCustomButtons: TCustomButtons;
    procedure SetCustomButtons(const Value: TCustomButtons);
    procedure CMStyleChanged(var Message: TMessage); message CM_STYLECHANGED;
    procedure UpdateTitlebarButtons(BoundsOnly: Boolean = False);
  protected
    procedure AdjustSize; override;
    function GetCustomButtonsClass: TCustomButtonsClass; virtual;
    function GetCaptionButtonItemClass:  TCaptionButtonItemClass; virtual;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Loaded; override;
  public
    procedure Invalidate; override;
    procedure Paint; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property OnPaint: TTitleBarPaintEvent read FOnPaint write FOnPaint;
    property OnUpdateTitlebarButtons: TNotifyEvent read FOnUpdateTitlebarButtons write FOnUpdateTitlebarButtons;
    /// <summary>AlphaValue allow to specify a custom alpha value for the background, only works if the TTitlebar.SystemColors is False.</summary>
    property AlphaValue: Byte read FAlphaValue write FAlphaValue;
    property CustomButtons: TCustomButtons read FCustomButtons write SetCustomButtons;
    property TitleButtonClose: TSystemTitlebarButton read FTitleButtonClose;
    property TitleButtonRestore: TSystemTitlebarButton read FTitleButtonRestore;
    property TitleButtonMin: TSystemTitlebarButton read FTitleButtonMin;
  end;

  /// <summary>
  /// TTitleBarPanel implements a container that interact with the form custom titlebar,
  /// used for align child controls and also add custom paint support.
  /// </summary>
  TTitleBarPanel = class(TCustomTitleBarPanel)
  published
    /// <summary>OnPaint use this event for custom paint the titlebar area.</summary>
    property OnPaint;
    property CustomButtons;
  end;

implementation

{$R TitleBarCtrls.res}

uses
  System.Types,
  System.Math,
  Vcl.Themes,
  Vcl.GraphUtil,
  Vcl.Imaging.PngImage,
  Winapi.UxTheme,
  Winapi.DwmApi;
  
const
  cTitleBarMinimizeButtonIndex = 2;
  cTitleBarRestoreButtonIndex = 3;
  cTitleBarCloseButtonIndex = 5;
  cWin7Tag = 'WIN7';
  cWin7MouseOverBlueGlow = 'WIN7MOUSEOVERBLUEGLOW';
  cWin7Designer = 'WIN7DESIGNER';

{ TGlowWindow }

constructor TSystemTitlebarButton.TGlowWindow.Create;
begin
  inherited;
  InitWindow;
  LoadImage;
end;

destructor TSystemTitlebarButton.TGlowWindow.Destroy;
begin
  DestroyWindow(FWindowHandle);
  inherited;
end;

procedure TSystemTitlebarButton.TGlowWindow.InitWindow;
var
  ExStyle, Style: Cardinal;
  LWndClass: TWndClass;
begin
  FillChar(LWndClass, SizeoF(LWndClass), #0);
  LWndClass.hInstance := hInstance;
  LWndClass.lpfnWndProc := @DefWindowProc;
  LWndClass.lpszClassName := PChar(ClassName);
  Winapi.Windows.RegisterClass(LWndClass);
  ExStyle := WS_EX_NOACTIVATE or WS_EX_TOPMOST;
  Style := WS_POPUP;
  FWindowHandle := CreateWindowEx(ExStyle, LWndClass.lpszClassName, nil, Style, 0, 0, 0, 0, 0, 0, HInstance, nil);
end;

procedure TSystemTitlebarButton.TGlowWindow.LoadImage;
var
  LPngImage: TPngImage;
  pptDst, pptSrc: TPoint;
  Size: TSize;
  LBlendFunc: TBlendFunction;
  LBitmap: TBitmap;
begin
  if FWindowHandle = 0 then exit;
  LPngImage := TPngImage.Create;
  try
    LPngImage.LoadFromResourceName(HInstance, 'TITLEBARCTRLS_' + cWin7MouseOverBlueGlow);
    LBitmap := TBitmap.Create;
    try
      LBitmap.Assign(LPngImage);
      pptDst := Point(0, 0);
      pptSrc := Point(0, 0);
      Size.cx := LPngImage.Width;
      Size.cy := LPngImage.Height;
      SetWindowPos(FWindowHandle, 0, 0, 0, LPngImage.Width, LPngImage.Height,
        SWP_HIDEWINDOW or SWP_NOACTIVATE or SWP_NOZORDER);
      LBlendFunc.BlendOp := AC_SRC_OVER;
      LBlendFunc.BlendFlags := 0;
      LBlendFunc.SourceConstantAlpha := 255;
      LBlendFunc.AlphaFormat := AC_SRC_ALPHA;

      SetWindowLong(FWindowHandle, GWL_EXSTYLE, GetWindowLong(FWindowHandle,
        GWL_EXSTYLE) or WS_EX_LAYERED or WS_EX_NOACTIVATE);

      UpdateLayeredWindow(FWindowHandle, GetDC(FWindowHandle), @pptDst, @Size,
        LBitmap.Canvas.Handle, @pptSrc, 0, @LBlendFunc, ULW_ALPHA);
    finally
      LBitmap.Free;
    end;
  finally
    LPngImage.Free;
  end;
end;

procedure TSystemTitlebarButton.TGlowWindow.SetLocation(X, Y: Integer);
begin
  if (FLeft <> X) or (FTop <> Y) then
  begin
    FLeft := X;
    FTop := Y;
    SetWindowPos(FWindowHandle, 0, X, Y, 0, 0, SWP_NOACTIVATE or SWP_NOSIZE);
  end;
end;

procedure TSystemTitlebarButton.TGlowWindow.SetVisible(const Value: Boolean);
const
  States: Array[Boolean] of DWORD = (SWP_HIDEWINDOW, SWP_SHOWWINDOW);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    SetWindowPos(FWindowHandle, 0, 0, 0, 0, 0, States[FVisible] or SWP_NOACTIVATE or SWP_NOSIZE or SWP_NOMOVE);
  end;
end;

{ TSystemTitlebarButton }

procedure TSystemTitlebarButton.MouseMove(Shift: TShiftState; X, Y: Integer);
const
  cGlowRectOffset = 16;
var
  LPoint: TPoint;
begin
  inherited;
  if not FDesignMode and (TOSVersion.Major = 6) and (TOSVersion.Minor = 1)
    and (X > 0) and (Y < Height - 2) and (X < Width - 2) then
  begin
    if (FGlow = nil) then
      FGlow := TSystemTitlebarButton.TGlowWindow.Create;

    LPoint := Self.ClientToScreen(TPoint.Create(0, 0));
    LPoint.X := LPoint.X - cGlowRectOffset;
    LPoint.Y := LPoint.Y - cGlowRectOffset;
    if (FGlow.FLeft <> LPoint.X) or (FGlow.FTop <> LPoint.Y) or not FGlow.Visible then
    begin
      FGlow.SetLocation(LPoint.X, LPoint.Y);
      FGlow.Visible := True;
    end;
  end;
end;

procedure TSystemTitlebarButton.CMMouseLeave(var Message: TMessage);
begin
  if Assigned(FGlow) then
    FGlow.Visible := False;
  inherited;
end;

constructor TSystemTitlebarButton.Create(AOwner: TComponent);
begin
  inherited;
  FButtonType := TSystemButton.sbCustom;
  Transparent := False;
  FDesignMode := csDesigning in ComponentState;
  if not ((TOSVersion.Major = 6) and (TOSVersion.Minor = 1)) then
    ControlStyle := ControlStyle + [csPaintBlackOpaqueOnGlass];
  FBitmapList := TObjectDictionary<string, TBitmap>.Create([doOwnsValues]);
end;

destructor TSystemTitlebarButton.Destroy;
begin
  FreeAndNil(FPath);
  FreeAndNil(FBitmapList);
  if Assigned(FGlow) then
    FreeAndNil(FGlow);
  inherited;
end;

function TSystemTitlebarButton.GetSymbolSize: Integer;
const
  cDefaultSymbolSize = 10;
begin
  Result := ScaleValue(cDefaultSymbolSize - 1);
end;

function TSystemTitlebarButton.DoGlassPaint: Boolean;
begin
  Result := csGlassPaint in ControlState;
end;

procedure TSystemTitlebarButton.DrawWin10CloseSymbol(ACanvas: TCanvas; ARect: TRect; FGColor, BGColor: TColor);
var
  LRect: TRect;
  LGPGraphics: TGPGraphics;
  LGPPen: TGPPen;
  LRGBColor: Integer;
  LColor: Cardinal;
  LSize: Integer;
begin
  LRGBColor := ColorToRGB(FGColor);
  LColor := MakeColor(GetRValue(LRGBColor), GetGValue(LRGBColor), GetBValue(LRGBColor));
  LGPGraphics := TGPGraphics.Create(ACanvas.Handle);
  try
    LGPGraphics.SetSmoothingMode(SmoothingModeDefault);
    LGPPen := TGPPen.Create(LColor, Client.CurrentPPI / Screen.DefaultPixelsPerInch);
    try
      LSize := GetSymbolSize;
      LRect := CenteredRect(ARect, Rect(0, 0, LSize, LSize));
      LGPGraphics.DrawLine(LGPPen, LRect.Left, LRect.Top, LRect.Right, LRect.Bottom);
      LGPGraphics.DrawLine(LGPPen, LRect.Left, LRect.Bottom, LRect.Right, LRect.Top);
    finally
      LGPPen.Free;
    end;
  finally
    LGPGraphics.Free;
  end;
end;

procedure TSystemTitlebarButton.DrawWin10MaximizeSymbol(ACanvas: TCanvas; ARect: TRect; FGColor, BGColor: TColor);
var
  LRect: TRect;
  LGPGraphics: TGPGraphics;
  LGPPen: TGPPen;
  LGPRect: TGPRect;
  LRGBColor: Integer;
  LColor: Cardinal;
  LSize: Integer;
begin
  LRGBColor := ColorToRGB(FGColor);
  LColor := MakeColor(GetRValue(LRGBColor), GetGValue(LRGBColor), GetBValue(LRGBColor));
  LGPGraphics := TGPGraphics.Create(ACanvas.Handle);
  try
    LGPPen := TGPPen.Create(LColor, Client.CurrentPPI / Screen.DefaultPixelsPerInch);
    try
      LSize := GetSymbolSize;
      LRect := CenteredRect(ARect, Rect(0, 0, LSize, LSize));
      LGPRect := MakeRect(LRect.Left, LRect.Top, LRect.Width, LRect.Height);
      Path.Reset;
      Path.AddRectangle(LGPRect);
      LGPGraphics.DrawPath(LGPPen, Path);
    finally
      LGPPen.Free;
    end;
  finally
    LGPGraphics.Free;
  end;
end;

procedure TSystemTitlebarButton.DrawWin10RestoreSymbol(ACanvas: TCanvas; ARect: TRect; FGColor, BGColor: TColor);
const
  cBorder = 2;
var
  LRect: TRect;
  LGPGraphics: TGPGraphics;
  LGPPen: TGPPen;
  LGPRect: TGPRect;
  LRGBColor: Integer;
  LColor: Cardinal;
  LSize, LBorder: Integer;
begin
  LRGBColor := ColorToRGB(FGColor);
  LColor := MakeColor(GetRValue(LRGBColor), GetGValue(LRGBColor), GetBValue(LRGBColor));
  LGPGraphics := TGPGraphics.Create(ACanvas.Handle);
  try
    LSize := GetSymbolSize;
    LBorder := ScaleValue(cBorder);
    LGPPen := TGPPen.Create(LColor, Client.CurrentPPI / Screen.DefaultPixelsPerInch);
    try
      LRect := CenteredRect(ARect, Rect(0, 0, LSize, LSize));
      Inc(LRect.Top, LBorder);
      Dec(LRect.Right, LBorder);
      LGPRect := MakeRect(LRect.Left, LRect.Top, LRect.Width, LRect.Height);
      Path.Reset;
      Path.AddRectangle(LGPRect);

      LRect := CenteredRect(ARect, Rect(0, 0, LSize, LSize));
      Dec(LRect.Bottom, LBorder);
      Inc(LRect.Left, LBorder);
      Path.AddLine(LRect.Left, LRect.Top + LBorder, LRect.Left, LRect.Top + LBorder);
      Path.AddLine(LRect.Left, LRect.Top, LRect.Right, LRect.Top);
      Path.AddLine(LRect.Right, LRect.Top, LRect.Right, LRect.Bottom);
      Path.AddLine(LRect.Right - LBorder, LRect.Bottom, LRect.Right, LRect.Bottom);

      LGPGraphics.DrawPath(LGPPen, Path);
    finally
      LGPPen.Free;
    end;
  finally
    LGPGraphics.Free;
  end;
end;

procedure TSystemTitlebarButton.DrawWin10CaptionButtonDesign;
var
  LBGColor, LGColor: TColor;
begin
  if Client.CustomTitleBar.Enabled then
  begin
    LBGColor := Client.CustomTitleBar.ButtonBackgroundColor;
    LGColor := Client.CustomTitleBar.ButtonForegroundColor;
  end
  else
  begin
    LBGColor := Client.CustomTitleBar.ButtonInActiveBackgroundColor;
    LGColor := Client.CustomTitleBar.ButtonInActiveForegroundColor;
  end;

  Canvas.Brush.Color := LBGColor;
  Canvas.Brush.Style := bsSolid;
  Canvas.FillRect(ClientRect);

  case FButtonType of
    sbMinimize: DrawWin10MinimizeSymbol(Canvas, ClientRect, LGColor, LBGColor);
    sbRestore:
      if Client.WindowState = wsMaximized then
        DrawWin10RestoreSymbol(Canvas, ClientRect, LGColor, LBGColor)
      else
        DrawWin10MaximizeSymbol(Canvas, ClientRect, LGColor, LBGColor);
    sbClose: DrawWin10CloseSymbol(Canvas, ClientRect, LGColor, LBGColor);
  end;
end;

procedure TSystemTitlebarButton.DrawWin10CaptionButton;
const
  cWin10CloseSymbolColor = clWhite;
  cWin10InactiveHighLightColor = clGray;
  cWin10EnabledTextColor = TColor($010101);
  cWin10CloseButtonHoverColor = TColor($2311E8);
  cWin10CloseButtonPressedColor = TColor($2E24A4);
  cWin10CaptionTextColor: array [Boolean] of TColor = (clWhite, cWin10EnabledTextColor);

var
  LGlassPaint: Boolean;
  BGColor, FGColor: TColor;
begin
  LGlassPaint := DoGlassPaint;

  if Client.Active then
    FGColor := Client.CustomTitleBar.ButtonForegroundColor
  else
    FGColor := Client.CustomTitleBar.ButtonInactiveForegroundColor;

  if not Enabled then
  begin
    if Client.Active then
      BGColor := Client.CustomTitleBar.ButtonBackgroundColor
    else
      BGColor := Client.CustomTitleBar.ButtonInactiveBackgroundColor;
    FGColor := ColorBlendRGB(FGColor, BGColor, 0.7);
  end
  else
    if FState in [bsDown, bsExclusive] then
    begin
      if FButtonType = sbClose then
      begin
        BGColor := cWin10CloseButtonPressedColor;
        FGColor := cWin10CloseSymbolColor;
      end
      else if Client.Active then
        BGColor := Client.CustomTitleBar.ButtonPressedBackgroundColor
      else
        BGColor := ColorBlendRGB(cWin10InactiveHighLightColor, Client.CustomTitleBar.InactiveBackgroundColor, 0.7);
    end
    else
      if MouseInControl then
      begin
        if FButtonType = sbClose then
        begin
          BGColor := cWin10CloseButtonHoverColor;
          FGColor := cWin10CloseSymbolColor;
        end
        else if Client.Active then
          BGColor := Client.CustomTitleBar.ButtonHoverBackgroundColor
        else
        begin
          BGColor := ColorBlendRGB(cWin10InactiveHighLightColor, Client.CustomTitleBar.InactiveBackgroundColor, 0.7);
          FGColor := cWin10CaptionTextColor[ColorIsBright(BGColor)];
        end;
      end
      else
      begin
        if Client.Active then
          BGColor := Client.CustomTitleBar.ButtonBackgroundColor
        else
          BGColor := Client.CustomTitleBar.ButtonInactiveBackgroundColor;
      end;

  if (LGlassPaint and not Transparent) then
    FillRectAlpha(Canvas, ClientRect, BGColor)
  else
  begin
    Canvas.Brush.Color := BGColor;
    Canvas.FillRect(ClientRect);
  end;

  case FButtonType of
    sbMinimize: DrawWin10MinimizeSymbol(Canvas, ClientRect, FGColor, BGColor);
    sbRestore:
      if Client.WindowState = wsMaximized then
        DrawWin10RestoreSymbol(Canvas, ClientRect, FGColor, BGColor)
      else
        DrawWin10MaximizeSymbol(Canvas, ClientRect, FGColor, BGColor);
    sbClose: DrawWin10CloseSymbol(Canvas, ClientRect, FGColor, BGColor);
  end;
end;

procedure TSystemTitlebarButton.DrawWin7CaptionButton;
var
  LBitmapName: string;
  LBitmap: TBitmap;

  function GetResourceID : String;
  begin
    if FCount <= 1 then
      Result := 'STANDALONE'
    else if (FIndex = 0) and (FCount > 0) then
      Result := 'RIGHT'
    else if (FIndex > 0) and (FIndex = FCount - 1) then
      Result := 'LEFT'
    else Result := 'MIDDLE';
    Result := cWin7Tag + Result;
  end;

begin
  if FDesignMode then
    LBitmapName := cWin7Designer
  else
  if (FState in [bsDown, bsExclusive]) then
    LBitmapName := GetResourceID + 'MOUSEPRESSED' 
  else if MouseInControl then
    LBitmapName := GetResourceID + 'MOUSEOVER' 
  else if not Client.Active then
    LBitmapName := GetResourceID +  'NONFOCUSED' 
  else
    LBitmapName := GetResourceID;

  LBitmap := GetBitmapResource(LBitmapName);
  DrawTransparentBitmap(LBitmap, Canvas, ClientRect, 255);
end;

procedure TSystemTitlebarButton.DrawWin81Symbol(AChar: Char; ACanvas: TCanvas; ARect: TRect; FGColor, BGColor: TColor);
var
  s: String;
begin
  ACanvas.Brush.Color := BGColor;
  ACanvas.FillRect(ARect);
  s := AChar;
  ACanvas.Font.Name := 'Marlett'; { Do not localize }
  ACanvas.Font.Size := ScaleValue(11);
  ACanvas.Font.Color := FGColor;
  ACanvas.Font.Style := [fsBold];
  ACanvas.TextRect(ARect, s, [tfSingleLine, tfVerticalCenter, tfCenter]);
end;

procedure TSystemTitlebarButton.DrawWin81CloseSymbol(ACanvas: TCanvas;
  ARect: TRect; FGColor, BGColor: TColor);
begin
  DrawWin81Symbol(Chr($72), ACanvas, ARect, FGColor, BGColor);
end;

procedure TSystemTitlebarButton.DrawWin81MinimizeSymbol(ACanvas: TCanvas;
  ARect: TRect; FGColor, BGColor: TColor);
begin
  DrawWin81Symbol(Chr($30), ACanvas, ARect, FGColor, BGColor);
end;

procedure TSystemTitlebarButton.DrawWin81RestoreSymbol(ACanvas: TCanvas;
  ARect: TRect; FGColor, BGColor: TColor);
begin
  DrawWin81Symbol(Chr($32), ACanvas, ARect, FGColor, BGColor);
end;

procedure TSystemTitlebarButton.DrawWin81MaximizeSymbol(ACanvas: TCanvas;
  ARect: TRect; FGColor, BGColor: TColor);
begin
  DrawWin81Symbol(Chr($31), ACanvas, ARect, FGColor, BGColor);
end;

procedure TSystemTitlebarButton.DrawWin81CaptionButton;
const
  cWin81CloseSymbolColor = clWhite;
  cWin81CloseButtonPressedColor = TColor($3C3F96);
  cWin81CloseButtonHoverColor = TColor($4343E0);
  cWin81CloseButtonColor = TColor($5050C7);
  cWin81CloseButtonDisabledColor = TColor($BCBCBC);
var
  LGlassPaint: Boolean;
  BGColor, FGColor: TColor;
begin
  LGlassPaint := DoGlassPaint;

  if Client.Active then
    FGColor := Client.CustomTitleBar.ButtonForegroundColor
  else
    FGColor := Client.CustomTitleBar.ButtonInactiveForegroundColor;

  if not Enabled then
  begin
    if Client.Active then
      BGColor := Client.CustomTitleBar.ButtonBackgroundColor
    else
      BGColor := Client.CustomTitleBar.ButtonInactiveBackgroundColor;
  end
  else
    if FState in [bsDown, bsExclusive] then
    begin
      if FButtonType = sbClose then
      begin
        BGColor := cWin81CloseButtonPressedColor;
        FGColor := cWin81CloseSymbolColor;
      end
      else
      begin
        BGColor := Client.CustomTitleBar.ButtonPressedBackgroundColor;
        FGColor := Client.CustomTitleBar.ButtonPressedForegroundColor;
      end;
    end
    else
      if MouseInControl then
      begin
        if FButtonType = sbClose then
        begin
          BGColor := cWin81CloseButtonHoverColor;
          FGColor := cWin81CloseSymbolColor;
        end
        else
        begin
          BGColor := Client.CustomTitleBar.ButtonHoverBackgroundColor;
          FGColor := Client.CustomTitleBar.ButtonHoverForegroundColor;
        end;
      end
      else
      begin
        if FButtonType = sbClose then
        begin
          if Client.Active then
            BGColor := cWin81CloseButtonColor
          else
            BGColor := cWin81CloseButtonDisabledColor;
          FGColor := cWin81CloseSymbolColor;
        end
        else
        begin
          if Client.Active then
            BGColor := Client.CustomTitleBar.ButtonBackgroundColor
          else
            BGColor := Client.CustomTitleBar.ButtonInactiveBackgroundColor;
        end;
      end;

  if (LGlassPaint and not Transparent) then
    FillRectAlpha(Canvas, ClientRect, BGColor)
  else
  begin
    Canvas.Brush.Color := BGColor;
    Canvas.FillRect(ClientRect);
  end;

  case FButtonType of
    sbMinimize: DrawWin81MinimizeSymbol(Canvas, ClientRect, FGColor, BGColor);
    sbRestore:
      if Client.WindowState = wsMaximized then
        DrawWin81RestoreSymbol(Canvas, ClientRect, FGColor, BGColor)
      else
        DrawWin81MaximizeSymbol(Canvas, ClientRect, FGColor, BGColor);
    sbClose: DrawWin81CloseSymbol(Canvas, ClientRect, FGColor, BGColor);
  end;
end;

procedure TSystemTitlebarButton.DrawWin10MinimizeSymbol(ACanvas: TCanvas; ARect: TRect; FGColor, BGColor: TColor);
var
  LRect: TRect;
  LGPGraphics: TGPGraphics;
  LGPPen: TGPPen;
  LRGBColor: Integer;
  LColor: Cardinal;
  LSize: Integer;
begin
  LRGBColor := ColorToRGB(FGColor);
  LColor := MakeColor(GetRValue(LRGBColor), GetGValue(LRGBColor), GetBValue(LRGBColor));
  LGPGraphics := TGPGraphics.Create(ACanvas.Handle);
  try
    LGPPen := TGPPen.Create(LColor, Client.CurrentPPI / Screen.DefaultPixelsPerInch);
    try
      LSize := GetSymbolSize;
      LRect := CenteredRect(ARect, Rect(0, 0, LSize, LSize));
      Path.Reset;
      Path.AddLine(LRect.Left, LRect.Top + LRect.Height div 2, LRect.Right, LRect.Top + LRect.Height div 2);
      LGPGraphics.DrawPath(LGPPen, Path);
    finally
      LGPPen.Free;
    end;
  finally
    LGPGraphics.Free;
  end;
end;

function TSystemTitlebarButton.GetBitmapResource(AName: string): TBitmap;

  procedure AddResource;
  var
    LPngImage: TPngImage;
    LBitmap: TBitmap;
  begin
    LPngImage := TPngImage.Create;
    try
      LBitmap := TBitmap.Create;
      LPngImage.LoadFromResourceName(HInstance, 'TITLEBARCTRLS_' + AName);
      LBitmap.Assign(LPngImage);
      FBitmapList.Add(AName, LBitmap);
    finally
      LPngImage.Free;
    end;
  end;

begin
  if not FBitmapList.ContainsKey(AName) then
    AddResource;
  Result := FBitmapList[AName];
end;

function TSystemTitlebarButton.GetClient: TCustomForm;
begin
  if FClient = nil then
   if Parent <> nil then
     FClient := GetParentForm(Parent)
   else
     FClient := GetParentForm(Self);
  Result := FClient;
end;

function TSystemTitlebarButton.GetGraphicsPath: TGPGraphicsPath;
begin
  if FPath = nil then
    FPath := TGPGraphicsPath.Create;
  Result := FPath;
end;

procedure TSystemTitlebarButton.Paint;
var
  MemDC: HDC;
  LRect: TRect;
  PaintBuffer: HPAINTBUFFER;
  OrgHandle: THandle;
  LGlassPaint: Boolean;
  LStyle: TCustomStyleServices;
begin
  if Client = nil then Exit;

  if not Enabled then
  begin
    FState := bsDisabled;
    LocalDragging := False;
  end
  else if FState = bsDisabled then
    if Down and (GroupIndex <> 0) then
      FState := bsExclusive
    else
      FState := bsUp;
  LRect := ClientRect;
  OrgHandle := Canvas.Handle;
  try
    PaintBuffer := BeginBufferedPaint(Canvas.Handle, LRect, BPBF_COMPOSITED, nil, MemDC);
    try
      Canvas.Handle := MemDC;
      Canvas.Font := Self.Font;

      LStyle := StyleServices(Self);
      LGlassPaint := DoGlassPaint;

      if not LGlassPaint then
        if Transparent then
          LStyle.DrawParentBackground(0, Canvas.Handle, nil, True)
        else
          PerformEraseBackground(Self, Canvas.Handle)
      else
        FillRect(Canvas.Handle, ClientRect, GetStockObject(BLACK_BRUSH));

      if TOSVersion.Check(10) then
      begin
        if FDesignMode or ((Parent <> nil) and (csDesigning in Parent.ComponentState)) then
          DrawWin10CaptionButtonDesign
        else
          DrawWin10CaptionButton;
      end
      else if (TOSVersion.Major = 6) and ((TOSVersion.Minor = 2) or (TOSVersion.Minor = 3)) then
        DrawWin81CaptionButton
      else
        DrawWin7CaptionButton;

      if Assigned(FOnPaint) then FOnPaint(Self);

      if (csPaintBlackOpaqueOnGlass in ControlStyle) then
        BufferedPaintMakeOpaque(PaintBuffer, LRect);
    finally
      EndBufferedPaint(PaintBuffer, True);
    end;
  finally
    Canvas.Handle := OrgHandle;
  end;
end;

procedure TSystemTitlebarButton.SetButtonType(const Value: TSystemButton);
begin
  if FButtonType <> Value then
  begin
    FButtonType := Value;
    Invalidate;
  end;
end;

{ TCustomTitleBarPanel }

procedure TCustomTitleBarPanel.AdjustSize;
begin
  FLastWindowStateUpdated := wsMinimized;
  inherited;
end;

procedure TCustomTitleBarPanel.CMStyleChanged(var Message: TMessage);
begin
  inherited;
  FLastWindowStateUpdated := wsMinimized;
  Invalidate;
end;

constructor TCustomTitleBarPanel.Create(AOwner: TComponent);
var
  X, Y: Integer;
begin
  inherited Create(AOwner);
  FAlphaValue := 255;
  X := GetSystemMetrics(SM_CXSIZE);
  Y := GetSystemMetrics(SM_CYSIZE);

  FCustomButtons := GetCustomButtonsClass.Create(Self, GetCaptionButtonItemClass);
  if TOSVersion.Check(10) then
  begin
    FTitleButtonClose := TSystemTitlebarButton.Create(nil);
    FTitleButtonClose.ButtonType := TSystemButton.sbClose;
    FTitleButtonClose.Parent := Self;
    FTitleButtonClose.SetBounds(0, 0, X, Y);
    FTitleButtonClose.OnClick := TitleButtonCloseClick;

    FTitleButtonRestore := TSystemTitlebarButton.Create(nil);
    FTitleButtonRestore.ButtonType := TSystemButton.sbRestore;
    FTitleButtonRestore.Parent := Self;
    FTitleButtonRestore.SetBounds(0, 0, X, Y);
    FTitleButtonRestore.OnClick := TitleButtonRestoreClick;
    
    FTitleButtonMin := TSystemTitlebarButton.Create(nil);
    FTitleButtonMin.ButtonType := TSystemButton.sbMinimize;
    FTitleButtonMin.Parent := Self;
    FTitleButtonMin.SetBounds(0, 0, X, Y);
    FTitleButtonMin.OnClick := TitleButtonMinClick;

    SetTitleButtonsVisibility(False);
  end;

  ControlStyle := ControlStyle + [csAcceptsControls] - [csOpaque];
  if csDesigning in ComponentState then
    Align := alTop;
  InterceptMouse := csDesigning in ComponentState;
  FLastWindowStateUpdated := wsMinimized;
  ParentDoubleBuffered := false;
  DoubleBuffered := True;
  SetBounds(0, 0, X, Y);
end;

destructor TCustomTitleBarPanel.Destroy;
begin
  if TOSVersion.Check(10) then
  begin
    FTitleButtonClose.Free;
    FTitleButtonRestore.Free;
    FTitleButtonMin.Free;
  end;
  FCustomButtons.Free;
  inherited;
end;

procedure TCustomTitleBarPanel.Loaded;
begin
  inherited;
  if Client <> nil then
    FClient.UpdateDesignerCaption(not FClient.CustomTitleBar.Enabled or (FClient.CustomTitleBar.Control <> Self) or not TStyleManager.SystemStyle.Enabled, False);
end;

procedure TCustomTitleBarPanel.UpdateAlign;
const
  cWin10ButtonOffset = 6;
var
  LBorderSize, Y: Integer;
begin
  if not (csDesigning in ComponentState) and (Client <> nil) and
    (Client.CustomTitleBar.Enabled) and (Client.CustomTitleBar.Control = Self) then
  begin
    //  Check if the client area of the form was already extended
    //  if the client area is not extended yet we update the client.
    if (Client.BoundsRect.Height - Client.ClientRect.Height) > Client.CustomTitleBar.Height then
      SetWindowPos(Client.Handle, 0, 0, 0, 0, 0, SWP_FRAMECHANGED or SWP_NOACTIVATE or
        SWP_NOMOVE or SWP_NOSIZE or SWP_NOZORDER);
    Align := alNone;
    LBorderSize := GetSystemMetrics(SM_CXBORDER);

    if (Client.WindowState = wsMaximized) then
      Y := ScaleValue(cWin10ButtonOffset + LBorderSize)
    else
      Y := LBorderSize;

    SetBounds(0, Y, Client.ClientWidth, Client.CustomTitleBar.Height - Y);
    Anchors := [akLeft, akTop, akRight];
    FLastWindowStateUpdated := Client.WindowState;
  end;
end;

procedure TCustomTitleBarPanel.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle and not WS_EX_TRANSPARENT;
end;

function TCustomTitleBarPanel.GetCustomButtonsClass: TCustomButtonsClass;
begin
  Result := TCustomButtons;
end;

function TCustomTitleBarPanel.GetCaptionButtonItemClass: TCaptionButtonItemClass;
begin
  Result := TCaptionButtonItem;
end;

function TCustomTitleBarPanel.GetClient: TCustomForm;
begin
  if FClient = nil then
    FClient := GetParentForm(Self);
  Result := FClient;
end;

procedure TCustomTitleBarPanel.Invalidate;
begin
  Perform(CM_INVALIDATE, 0, 0);
end;

function TCustomTitleBarPanel.UpdateCustomButtons(XOffset: Integer = 0): TRect;
const
  cDefaultCustomButtonSize = 23; // TCustomSpeedButton.Create
var
  LTitleBarInfo: TTitleBarInfoEx;
  X, Y, W, H, I, LEdge, LWidth: Integer;
  LCaptionButtonsRect, LRect, LButtonRect: TRect;
  LPoint: TPoint;
  LStyle: TCustomStyleServices;
  LDetails: TThemedElementDetails;
begin
  FillChar(LTitleBarInfo, SizeOf(LTitleBarInfo), 0);
  LTitleBarInfo.cbSize := SizeOf(LTitleBarInfo);
  SendMessage(Client.Handle, WM_GETTITLEBARINFOEX, 0, NativeInt(@LTitleBarInfo));
  LEdge := GetSystemMetrics(SM_CXEDGE);
  Result := TRect.Empty;
  if IsValidState(LTitleBarInfo.rgstate[cTitleBarMinimizeButtonIndex]) then
  begin
    W := LTitleBarInfo.rgrect[cTitleBarMinimizeButtonIndex].Width;
    H := LTitleBarInfo.rgrect[cTitleBarMinimizeButtonIndex].Height;
  end
  else if IsValidState(LTitleBarInfo.rgstate[cTitleBarRestoreButtonIndex]) then
  begin
    W := LTitleBarInfo.rgrect[cTitleBarRestoreButtonIndex].Width;
    H := LTitleBarInfo.rgrect[cTitleBarRestoreButtonIndex].Height;
  end
  else
  begin
    W := LTitleBarInfo.rgrect[cTitleBarCloseButtonIndex].Width;
    H := LTitleBarInfo.rgrect[cTitleBarCloseButtonIndex].Height;
  end;

  if csDesigning in ComponentState then
  begin
    if TOSVersion.Check(10) then
    begin
      LStyle := TStyleManager.DesignerStyle[False];
      if (LStyle <> nil) and not (Client.BorderStyle in [bsToolWindow, bsSizeToolWin]) then
      begin
        LDetails := LStyle.GetElementDetails(twCloseButtonNormal);
        if LStyle.GetElementContentRect(0, LDetails, LRect, LButtonRect) and not LButtonRect.IsEmpty then
          W := MulDiv(LButtonRect.Width, CurrentPPI, Screen.DefaultPixelsPerInch);
      end;
    end;
    LPoint := TPoint.Zero;
    X := LPoint.X;
    LRect := ClientRect;
    LRect.Height := -Client.CustomTitleBar.FrameRect.Top;
    Y := (LRect.Height - H) div 2;
    if IsValidState(LTitleBarInfo.rgstate[cTitleBarCloseButtonIndex]) then
    begin
      LPoint := ScreenToClient(LTitleBarInfo.rgrect[cTitleBarCloseButtonIndex].TopLeft);
      X := LPoint.X;
    end;

    if IsValidState(LTitleBarInfo.rgstate[cTitleBarRestoreButtonIndex]) then
    begin
      LPoint := ScreenToClient(LTitleBarInfo.rgrect[cTitleBarRestoreButtonIndex].TopLeft);
      X := LPoint.X;
    end;

    if IsValidState(LTitleBarInfo.rgstate[cTitleBarMinimizeButtonIndex]) then
    begin
      LPoint := ScreenToClient(LTitleBarInfo.rgrect[cTitleBarMinimizeButtonIndex].TopLeft);
      X := LPoint.X;
    end;

    LCaptionButtonsRect := Rect(X, Y, X + W, Y + H);
  end
  else
    LCaptionButtonsRect := Client.CustomTitleBar.CaptionButtonsRect;

  if (csDesigning in ComponentState) then 
    X := XOffset
  else
    X := LCaptionButtonsRect.Left;
  if (TOSVersion.Major = 6) and (TOSVersion.Minor = 1) then
    if not (csDesigning in ComponentState) then
      Dec(X, GetSystemMetrics(SM_CXFRAME))
    else
      Dec(X, LEdge);

  if (TOSVersion.Major = 6) and (TOSVersion.Minor = 1) and (Client.WindowState = wsMaximized) then
    Inc(H, 1)
  else if TOSVersion.Check(10) then
    H := LCaptionButtonsRect.Height;

  Result.Left := X;
  LWidth := ClientRect.Width - X;
  for i := 0 to FCustomButtons.Count - 1 do
  begin
    if (FCustomButtons[i].Button.Width > 0) and (FCustomButtons[i].Button.Width <> cDefaultCustomButtonSize) then
      W := FCustomButtons[i].Button.Width;
    if csDesigning in ComponentState then
      FCustomButtons[i].Button.FDesignMode := csDesigning in ComponentState;
    FCustomButtons[i].Button.FCount := FCustomButtons.Count;
    FCustomButtons[i].Button.FIndex := i;
    FCustomButtons[i].Button.Parent := Self;
    FCustomButtons[i].Button.SetBounds(X - W, LCaptionButtonsRect.Top, W, H);
    FCustomButtons[i].Button.Anchors := [akRight, akTop];

    Result.Left := Result.Left - W;
    Inc(LWidth, W);
    Dec(X, W);
    if (csDesigning in ComponentState) and (TOSVersion.Major = 6) and (TOSVersion.Minor = 1) then
    begin
      Dec(X, LEdge);
      Inc(LWidth, LEdge);
    end;
  end;

  Result.Top := LCaptionButtonsRect.Top;
  Result.Height := H;
  Result.Width := LWidth;
end;

type
  TCustomFormClass = class(Vcl.Forms.TCustomForm);

procedure TCustomTitleBarPanel.UpdateTitlebarButtons(BoundsOnly: Boolean = False);
var
  LTitleBarInfo: TTitleBarInfoEx;
  ButtonRect, LCaptionButtonsRect: TRect;
  LPoint: TPoint;
  LState: DWORD;
begin
  if Client.CustomTitleBar.SystemButtons then
  begin
    SetTitleButtonsVisibility(False);
    Exit;
  end;

  FillChar(LTitleBarInfo, SizeOf(LTitleBarInfo), 0);
  LTitleBarInfo.cbSize := SizeOf(LTitleBarInfo);
  SendMessage(Client.Handle, WM_GETTITLEBARINFOEX, 0, NativeInt(@LTitleBarInfo));
  LCaptionButtonsRect := Client.CustomTitleBar.CaptionButtonsRect;

  // Restore button
  LState := LTitleBarInfo.rgstate[cTitleBarRestoreButtonIndex];
  if IsValidState(LState) then
  begin
    ButtonRect := LTitleBarInfo.rgrect[cTitleBarRestoreButtonIndex];
    LPoint := ScreenToClient(ButtonRect.TopLeft);
    if Client.WindowState = wsMaximized then
    begin
      if not Client.CustomTitleBar.SystemHeight or (Client.BoundsRect.Top >= 0) then
        LPoint.Y := 0
      else
        LPoint.Y := FClient.Top div 2; // FClient.Top returns the pixel offset when the form is maximized
      ButtonRect.Height := LCaptionButtonsRect.Height;
    end;
    ButtonRect.SetLocation(LPoint);
    if not BoundsOnly then
      FTitleButtonRestore.Visible := True;
    FTitleButtonRestore.BoundsRect := ButtonRect;
  end
  else if not BoundsOnly then
    FTitleButtonRestore.Visible := False;

  // Close button
  LState := LTitleBarInfo.rgstate[cTitleBarCloseButtonIndex];
  if IsValidState(LState) then
  begin
    ButtonRect := LTitleBarInfo.rgrect[cTitleBarCloseButtonIndex];
    LPoint := ScreenToClient(ButtonRect.TopLeft);
    if Client.WindowState = wsMaximized then
    begin
      if not Client.CustomTitleBar.SystemHeight or (Client.BoundsRect.Top >= 0) then
        LPoint.Y := 0
      else
        LPoint.Y := FClient.Top div 2; // FClient.Top returns the pixel offset when the form is maximized
      ButtonRect.Height := LCaptionButtonsRect.Height;
      // WM_GETTITLEBARINFOEX is not returning valid values for the close button when the form is maximized,
      // we use the maximize button bounds to fix the close button.
      ButtonRect.Width := FTitleButtonRestore.Width;
      LPoint.X := FTitleButtonRestore.BoundsRect.Right;
    end;
    ButtonRect.SetLocation(LPoint);
    if not BoundsOnly then
      FTitleButtonClose.Visible := True;
    FTitleButtonClose.BoundsRect := ButtonRect;
  end
  else if not BoundsOnly then
    FTitleButtonClose.Visible := False;

  // Minimize button
  LState := LTitleBarInfo.rgstate[cTitleBarMinimizeButtonIndex];
  if IsValidState(LState) or (LTitleBarInfo.rgrect[cTitleBarMinimizeButtonIndex].Width > 0) then
  begin
    ButtonRect := LTitleBarInfo.rgrect[cTitleBarMinimizeButtonIndex];
    LPoint := ScreenToClient(ButtonRect.TopLeft);
    if Client.WindowState = wsMaximized then
    begin
      if not Client.CustomTitleBar.SystemHeight or (Client.BoundsRect.Top >= 0) then
        LPoint.Y := 0
      else
        LPoint.Y := FClient.Top div 2; // FClient.Top returns the pixel offset when the form is maximized
      ButtonRect.Height := LCaptionButtonsRect.Height;
    end;
    ButtonRect.SetLocation(LPoint);
    if not BoundsOnly then
      FTitleButtonMin.Visible := True;
    FTitleButtonMin.Enabled := biMinimize in TCustomFormClass(Client).BorderIcons;
    FTitleButtonMin.BoundsRect := ButtonRect;
  end
  else if not BoundsOnly then
    FTitleButtonMin.Visible := False;

  if Assigned(FOnUpdateTitlebarButtons) then
    FOnUpdateTitlebarButtons(Self);
end;

procedure TCustomTitleBarPanel.Paint;
var
  LRect, ButtonRect, LCaptionButtonsRect: TRect;
  LStyle: TCustomStyleServices;
  LTitleBarInfo: TTitleBarInfoEx;
  LEdge, LastX: Integer;
  MemDC: HDC;
  PaintBuffer: HPAINTBUFFER;
  LCanvas: TCanvas;
  LColor: TColor;
  LState: DWORD;
  SaveIndex: Integer;
  LButtonWidth: Integer;
  LDetails: TThemedElementDetails;
begin
  if csDesigning in ComponentState then
  begin
    if (Client <> nil) and (Client.CustomTitleBar.Control = Self) then
    begin
      LRect := ClientRect;
      if Client.CustomTitleBar.Enabled then
        LColor := Client.CustomTitleBar.BackgroundColor
      else
        LColor := Client.CustomTitleBar.InactiveBackgroundColor;

      Canvas.Brush.Color := LColor;
      Canvas.Brush.Style := bsSolid;
      Canvas.FillRect(LRect);

      SaveIndex := SaveDC(Canvas.Handle);
      try
        LRect.Height := -Client.CustomTitleBar.FrameRect.Top;
        LEdge := GetSystemMetrics(SM_CXEDGE);
        if Client.BorderStyle <> bsNone then
        begin
          FillChar(LTitleBarInfo, SizeOf(LTitleBarInfo), 0);
          LTitleBarInfo.cbSize := SizeOf(LTitleBarInfo);
          SendMessage(Client.Handle, WM_GETTITLEBARINFOEX, 0, NativeInt(@LTitleBarInfo));

          if TOSVersion.Check(10) then
            LStyle := TStyleManager.DesignerStyle[not Vcl.GraphUtil.ColorIsBright(LColor)]
          else
            LStyle := nil;

          LButtonWidth := 0;
          if LStyle = nil then
            LStyle := TStyleManager.SystemStyle
          else
            if not (Client.BorderStyle in [bsToolWindow, bsSizeToolWin]) then
            begin
              LDetails := LStyle.GetElementDetails(twCloseButtonNormal);
              if LStyle.GetElementContentRect(0, LDetails, LRect, ButtonRect) and not ButtonRect.IsEmpty then
                LButtonWidth := MulDiv(ButtonRect.Width, CurrentPPI, Screen.DefaultPixelsPerInch);
            end;

          ButtonRect := Rect(0, 0, 0, 0);

          if LStyle.Enabled then
          begin
            // Close button
            LState := LTitleBarInfo.rgstate[cTitleBarCloseButtonIndex];
            if IsValidState(LState) then
            begin
              LastX := LRect.Right - LEdge;
              ButtonRect := LRect;
              ButtonRect.Height := LTitleBarInfo.rgrect[cTitleBarCloseButtonIndex].Height;
              ButtonRect.Width := Max(LButtonWidth, LTitleBarInfo.rgrect[cTitleBarCloseButtonIndex].Width);
              ButtonRect.SetLocation(LastX - ButtonRect.Width, (LRect.Height - ButtonRect.Height) div 2);
              if (Client.BorderStyle <> bsToolWindow) and (Client.BorderStyle <> bsSizeToolWin) then
              begin
                if Client.CustomTitleBar.Enabled then
                 LDetails := LStyle.GetElementDetails(twCloseButtonNormal)
               else
                 LDetails := LStyle.GetElementDetails(twCloseButtonDisabled);
              end
              else
              begin
                if Client.CustomTitleBar.Enabled then
                  LDetails := LStyle.GetElementDetails(twSmallCloseButtonNormal)
                else
                  LDetails := LStyle.GetElementDetails(twSmallCloseButtonDisabled);
              end;
              if Client.CustomTitleBar.SystemButtons then
                LStyle.DrawElement(Canvas.Handle, LDetails, ButtonRect, nil, CurrentPPI)
              else if Assigned(FTitleButtonClose) then
              begin
                FTitleButtonClose.Visible := True;
                FTitleButtonClose.BoundsRect := ButtonRect;
              end;
            end
            else if Assigned(FTitleButtonClose) then
              FTitleButtonClose.Visible := False;

            // Maximize button
            LState := LTitleBarInfo.rgstate[cTitleBarRestoreButtonIndex];
            if IsValidState(LState) then
            begin
              LastX := ButtonRect.Left - LEdge;
              ButtonRect := LRect;
              ButtonRect.Height := LTitleBarInfo.rgrect[cTitleBarRestoreButtonIndex].Height;
              ButtonRect.Width := Max(LButtonWidth, LTitleBarInfo.rgrect[cTitleBarRestoreButtonIndex].Width);
              ButtonRect.SetLocation(LastX - ButtonRect.Width, (LRect.Height - ButtonRect.Height) div 2);
              if Client.CustomTitleBar.Enabled then
                LDetails := LStyle.GetElementDetails(twMaxButtonNormal)
              else
                LDetails := LStyle.GetElementDetails(twMaxButtonDisabled);
              if Client.CustomTitleBar.SystemButtons then
                LStyle.DrawElement(Canvas.Handle, LDetails, ButtonRect, nil, CurrentPPI)
              else if Assigned(FTitleButtonRestore) then
              begin
                FTitleButtonRestore.Visible := True;
                FTitleButtonRestore.BoundsRect := ButtonRect;
              end;
            end
            else if Assigned(FTitleButtonRestore) then
              FTitleButtonRestore.Visible := False;

            // Minimize button
            LState := LTitleBarInfo.rgstate[cTitleBarMinimizeButtonIndex];
            if IsValidState(LState) then
            begin
              LastX := ButtonRect.Left - LEdge;
              ButtonRect := LRect;
              ButtonRect.Height := LTitleBarInfo.rgrect[cTitleBarMinimizeButtonIndex].Height;
              ButtonRect.Width := Max(LButtonWidth, LTitleBarInfo.rgrect[cTitleBarMinimizeButtonIndex].Width);
              ButtonRect.SetLocation(LastX - ButtonRect.Width, (LRect.Height - ButtonRect.Height) div 2);
              if Client.CustomTitleBar.Enabled then
                LDetails := LStyle.GetElementDetails(twMinButtonNormal)
              else
                LDetails := LStyle.GetElementDetails(twMinButtonDisabled);
              if Client.CustomTitleBar.SystemButtons then
                 LStyle.DrawElement(Canvas.Handle, LDetails, ButtonRect, nil, CurrentPPI)
              else if Assigned(FTitleButtonMin) then
              begin
                FTitleButtonMin.Visible := True;
                FTitleButtonMin.BoundsRect := ButtonRect;
              end;
            end
            else if Assigned(FTitleButtonMin) then
              FTitleButtonMin.Visible := False;
          end;
        end
        else
        begin
          ButtonRect := LRect;
          ButtonRect.Left := ButtonRect.Right;
        end;

        if FCustomButtons.Count > 0 then
          ButtonRect := UpdateCustomButtons(ButtonRect.TopLeft.X)
        else
          ButtonRect.Width := ClientRect.Width - ButtonRect.Left;

        Client.CustomTitleBar.DrawCustomTitleBar(Canvas, ButtonRect);
      finally
        RestoreDC(Canvas.Handle, SaveIndex);
      end;
    end;
    Canvas.Pen.Style := psDash;
    Canvas.Brush.Style := bsClear;
    Canvas.Rectangle(0, 0, Width, Height);
  end
  else
  begin
    if (Client <> nil) and (Client.CustomTitleBar.Enabled) and (Client.CustomTitleBar.Control = Self) then
    begin
      if not (csDesigning in ComponentState) and (FLastWindowStateUpdated <> Client.WindowState) then
        UpdateAlign;

      LCaptionButtonsRect := Client.CustomTitleBar.CaptionButtonsRect;
      ButtonRect := LCaptionButtonsRect;
      LRect := ClientRect;
      LCanvas := TCanvas.Create;
      try
        PaintBuffer := BeginBufferedPaint(Canvas.Handle, LRect, BPBF_COMPOSITED, nil, MemDC);
        try
          LCanvas.Handle := MemDC;
          FillRect(LCanvas.Handle, LRect, GetStockObject(BLACK_BRUSH));

          if TOSVersion.Check(10) and not Client.CustomTitleBar.SystemColors then
          begin
            if FClient.Active then
              LColor := Client.CustomTitleBar.BackgroundColor
            else
              LColor := Client.CustomTitleBar.InactiveBackgroundColor;
            LCanvas.Brush.Color := LColor;
            if Client.CustomTitleBar.SystemButtons then
              LRect.Right := LCaptionButtonsRect.Left;
            LCanvas.FillRect(LRect);
            if (ClientRect.Height > LCaptionButtonsRect.Height) and Client.CustomTitleBar.SystemButtons then
            begin
              LRect := LCaptionButtonsRect;
              LRect.Top := LCaptionButtonsRect.Bottom;
              LRect.Bottom := ClientRect.Bottom;
              LCanvas.FillRect(LRect);
            end;
          end;

          // WM_GETTITLEBARINFOEX message can fail if the client is not active/visible.
          // we need update the titlebar buttons bounds before paint.
          if TOSVersion.Check(10) then
            UpdateTitlebarButtons;

          if FCustomButtons.Count > 0 then
            ButtonRect := UpdateCustomButtons;

          Client.CustomTitleBar.DrawCustomTitleBar(LCanvas, ButtonRect);

          LRect := ClientRect;
          if Assigned(FOnPaint) then FOnPaint(Self, LCanvas, LRect);

          if TOSVersion.Check(10) and not Client.CustomTitleBar.SystemColors and (FAlphaValue > 0) then
          begin
            LRect := ClientRect;
            if Client.CustomTitleBar.SystemButtons then
              LRect.Right := LCaptionButtonsRect.Left;
            BufferedPaintSetAlpha(PaintBuffer, @LRect, FAlphaValue);
            if (ClientRect.Height > LCaptionButtonsRect.Height) and Client.CustomTitleBar.SystemButtons then
            begin
              LRect := LCaptionButtonsRect;
              LRect.Top := LCaptionButtonsRect.Bottom;
              LRect.Bottom := ClientRect.Bottom;
              BufferedPaintSetAlpha(PaintBuffer, @LRect, FAlphaValue);
            end;
          end;
        finally
          EndBufferedPaint(PaintBuffer, True);
        end;
      finally
        LCanvas.Handle := 0;
        LCanvas.Free;
      end;
    end;
  end;
end;

procedure TCustomTitleBarPanel.SetCustomButtons(const Value: TCustomButtons);
begin
  FCustomButtons.Assign(Value);
end;

procedure TCustomTitleBarPanel.SetTitleButtonsVisibility(Value: Boolean);
begin
  FTitleButtonClose.Visible := Value;
  FTitleButtonRestore.Visible := Value;
  FTitleButtonMin.Visible := Value;
end;

function TCustomTitleBarPanel.IsValidState(AState: DWORD): Boolean;
begin
  Result := (AState and STATE_SYSTEM_INVISIBLE = 0) and (AState and STATE_SYSTEM_OFFSCREEN = 0) and
    (AState and STATE_SYSTEM_UNAVAILABLE = 0);
end;

procedure TCustomTitleBarPanel.TitleButtonCloseClick(Sender: TObject);
begin
  if not (csDesigning in ComponentState) and (Client <> nil) then
    Client.Close;
end;

procedure TCustomTitleBarPanel.TitleButtonMinClick(Sender: TObject);
begin
  if not (csDesigning in ComponentState) and (Client <> nil) then
    SendMessage(Client.Handle, WM_SYSCOMMAND, SC_MINIMIZE, 0);
end;

procedure TCustomTitleBarPanel.TitleButtonRestoreClick(Sender: TObject);
begin
  if not (csDesigning in ComponentState) then
  begin
    if (Client <> nil) and IsZoomed(Client.Handle) then
      SendMessage(Client.Handle, WM_SYSCOMMAND, SC_RESTORE, 0)
    else if (Client <> nil) then
      SendMessage(Client.Handle, WM_SYSCOMMAND, SC_MAXIMIZE, 0);
  end;
end;

procedure TCustomTitleBarPanel.WMEraseBkgnd(var Message: TWmEraseBkgnd);
begin
  if csDesigning in ComponentState then
    inherited
  else
    Message.Result := 1;
end;

procedure TCustomTitleBarPanel.WMPaint(var Message: TWMPaint);
begin
  ControlState := ControlState + [csCustomPaint];
  if csDesigning in ComponentState then
    inherited
  else
    PaintHandler(Message);
  ControlState := ControlState - [csCustomPaint];
end;

{ TCustomButtons }

constructor TCustomButtons.Create(const ATitleBarPanel: TCustomTitleBarPanel;
  const ItemClass: TCollectionItemClass);
begin
  inherited Create(ItemClass);
  FTitleBarPanel := ATitleBarPanel;
end;

function TCustomButtons.GetItem(Index: Integer): TCaptionButtonItem;
begin
  Result := inherited GetItem(Index) as TCaptionButtonItem;
end;

function TCustomButtons.GetOwner: TPersistent;
begin
  Result := FTitleBarPanel;
end;

procedure TCustomButtons.SetItem(Index: Integer;
  const Value: TCaptionButtonItem);
begin
  inherited SetItem(Index, Value);
end;

{ TCaptionButtonItem }

procedure TCaptionButtonItem.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
end;

constructor TCaptionButtonItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FTitlebarButton := TSystemTitlebarButton.Create(nil);
end;

destructor TCaptionButtonItem.Destroy;
begin
  FTitlebarButton.Free;
  inherited;
end;

function TCaptionButtonItem.GetButtonType: TSystemButton;
begin
  Result := FTitlebarButton.ButtonType;
end;

function TCaptionButtonItem.GetEnabled: Boolean;
begin
  Result := FTitlebarButton.Enabled;
end;

function TCaptionButtonItem.GetHint: String;
begin
  Result := FTitlebarButton.Hint;
end;

function TCaptionButtonItem.GetWidth: Integer;
begin
  Result := FTitlebarButton.Width;
end;

function TCaptionButtonItem.GetOnClick: TNotifyEvent;
begin
  Result := FTitlebarButton.OnClick;
end;

function TCaptionButtonItem.GetOnPaint: TNotifyEvent;
begin
  Result := FTitlebarButton.OnPaint;
end;

function TCaptionButtonItem.GetVisible: Boolean;
begin
  Result := FTitlebarButton.Visible;
end;

procedure TCaptionButtonItem.SetButtonType(const Value: TSystemButton);
begin
  FTitlebarButton.ButtonType := Value;
end;

procedure TCaptionButtonItem.SetEnabled(const Value: Boolean);
begin
  FTitlebarButton.Enabled := Value;
end;

procedure TCaptionButtonItem.SetHint(const Value: String);
begin
  FTitlebarButton.Hint := Value;
end;

procedure TCaptionButtonItem.SetWidth(Value: Integer);
begin
  FTitlebarButton.Width := Value;
end;

procedure TCaptionButtonItem.SetOnClick(const Value: TNotifyEvent);
begin
  FTitlebarButton.OnClick := Value;
end;

procedure TCaptionButtonItem.SetOnPaint(const Value: TNotifyEvent);
begin
  FTitlebarButton.OnPaint := Value;
end;

procedure TCaptionButtonItem.SetTitlebarButton(
  const Value: TSystemTitlebarButton);
begin
  FTitlebarButton.Assign(Value);
end;

procedure TCaptionButtonItem.SetVisible(const Value: Boolean);
begin
  FTitlebarButton.Visible := Value;
end;

end.
