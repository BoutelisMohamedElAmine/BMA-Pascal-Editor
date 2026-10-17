{*******************************************************}
{                                                       }
{            Delphi Visual Component Library            }
{                                                       }
{ Copyright(c) 1995-2023 Embarcadero Technologies, Inc. }
{              All rights reserved                      }
{                                                       }
{*******************************************************}

unit Vcl.ControlList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Types, System.SysUtils, System.Classes, System.Math,
  Vcl.Themes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ImgList,
  Vcl.Buttons, Vcl.ActnList, System.UITypes;

type

  TCustomControlList = class;

  TControlListItemPanel = class(TCustomControl)
  private
    FControlList: TCustomControlList;
    FItemIndex: Integer;
    procedure WMEraseBkgnd(var Message: TMessage); message WM_ERASEBKGND;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    procedure CMControlListChange(var Msg: TCMControlListChange); message CM_CONTROLLISTCHANGE;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Paint; override;
  public
    constructor CreateLinked(AControlList: TCustomControlList);
    property ItemIndex: Integer read FItemIndex write FItemIndex;
  end;

  TControlListDrawItemEvent = procedure(AIndex: Integer;
    ACanvas: TCanvas; ARect: TRect; AState: TOwnerDrawState) of object;
  TControlListDrawItemsEvent = procedure(ACanvas: TCanvas; ARect: TRect) of object;
  TControlListEnableItemEvent = procedure(const AIndex: Integer; var AEnabled: Boolean) of object;
  TControlListEnableControlEvent = procedure(const AIndex: Integer; AControl: TControl; var AEnabled: Boolean) of object;
  TControlListShowControlEvent = procedure(const AIndex: Integer; AControl: TControl; var AVisible: Boolean) of object;

  TControlListColumnLayout = (cltSingle, cltMultiTopToBottom, cltMultiLeftToRight);

  TControlListItemSelectionOptions = class(TPersistent)
  private
    FHotColor: TColor;
    FSelectedColor: TColor;
    FFocusedColor: TColor;
    FHotColorAlpha: Byte;
    FSelectedColorAlpha: Byte;
    FFocusedColorAlpha: Byte;
    FHotFontColor: TColor;
    FSelectedFontColor: TColor;
    FFocusedFontColor: TColor;
    FUseFontColorForLabels: Boolean;
    FOnChange: TNotifyEvent;
    procedure SetUseFontColorForLabels(Value: Boolean);
    procedure SetHotColor(Value: TColor);
    procedure SetFocusedColor(Value: TColor);
    procedure SetSelectedColor(Value: TColor);
    procedure SetHotColorAlpha(Value: Byte);
    procedure SetSelectedColorAlpha(Value: Byte);
    procedure SetFocusedColorAlpha(Value: Byte);
    procedure SetHotFontColor(Value: TColor);
    procedure SetFocusedFontColor(Value: TColor);
    procedure SetSelectedFontColor(Value: TColor);
  protected
    procedure DoChange;
  public
    constructor Create; virtual;
    procedure Assign(Source: TPersistent); override;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  published
    /// <summary>
    /// Defines selection color for hot item
    /// </summary>
    property HotColor: TColor
      read FHotColor write SetHotColor default clHighLight;
    /// <summary>
    /// Defines alpha transparency of color for hot item
    /// </summary>
    property HotColorAlpha: Byte
      read FHotColorAlpha write SetHotColorAlpha default 80;
    /// <summary>
    /// Defines selection color for selected item
    /// </summary>
    property SelectedColor: TColor
      read FSelectedColor write SetSelectedColor default clHighLight;
    /// <summary>
    /// Defines alpha transparency of color for selected item
    /// </summary>
    property SelectedColorAlpha: Byte
      read FSelectedColorAlpha write SetSelectedColorAlpha default 130;
    /// <summary>
    /// Defines selection color for selected item in focused control
    /// </summary>
    property FocusedColor: TColor
      read FFocusedColor write SetFocusedColor default clHighLight;
    /// <summary>
    /// Defines alpha transparency of selection color for selected item in focused control
    /// </summary>
    property FocusedColorAlpha: Byte
      read FFocusedColorAlpha write SetFocusedColorAlpha default 150;
    /// <summary>
    /// Defines text color for hot item
    /// </summary>
    property HotFontColor: TColor
      read FHotFontColor write SetHotFontColor default clWindowText;
    /// <summary>
    /// Defines text color for selected item
    /// </summary>
    property SelectedFontColor: TColor
      read FSelectedFontColor write SetSelectedFontColor default clWindowText;
    /// <summary>
    /// Defines text color for selected item in focused control
    /// </summary>
    property FocusedFontColor: TColor
      read FFocusedFontColor write SetFocusedFontColor default clWindowText;
    /// <summary>
    /// Set UseFontColorForLabels to True if you want to use defined colors for TLabel controls automatically
    /// </summary>
    property UseFontColorForLabels: Boolean
      read FUseFontColorForLabels write SetUseFontColorForLabels default False;
  end;

  /// <summary>
  /// TCustomControlList control, which has items with virtual controls
  /// </summary>
  TCustomControlList = class(TCustomControl)
  private
    FBorderStyle: TBorderStyle;
    FItemCount: Integer;
    FItemWidth: Integer;
    FItemHeight: Integer;
    FItemIndex: Integer;
    FItemPanel: TControlListItemPanel;
    FColumnLayout: TControlListColumnLayout;
    FOldWidth, FOldHeight: Integer;
    FHotItemIndex: Integer;
    FItemDownIndex: Integer;
    FClicksDisabled: Boolean;
    FItemMargins: TMargins;
    FItemColor: TColor;
    FStopScroll: Boolean;
    FUpdatingItemIndex: Integer;
    FScrollPos: Integer;
    FDrawingList, FNeedUpdateItem, FCheckingControlStates: Boolean;
    FActiveControl: TControl;
    FItemSelectionOptions: TControlListItemSelectionOptions;
    FMarkDisabledItem: Boolean;
    FOnChange: TNotifyEvent;
    FOnItemClick: TNotifyEvent;
    FOnItemDblClick: TNotifyEvent;
    FOnBeforeDrawItem, FOnAfterDrawItem: TControlListDrawItemEvent;
    FOnBeforeDrawItems, FOnAfterDrawItems: TControlListDrawItemsEvent;
    FOnEnableItem: TControlListEnableItemEvent;
    FOnEnableControl: TControlListEnableControlEvent;
    FOnShowControl: TControlListShowControlEvent;
    FItemIndexChanged: Boolean;
    FItemDblClick: Boolean;
    class constructor Create;
    class destructor Destroy;
    procedure SetMarkDisabledItem(Value: Boolean);
    procedure SetItemColor(Value: TColor);
    procedure SetItemMargins(const Value: TMargins);
    procedure SetColumnLayout(Value: TControlListColumnLayout);
    procedure SetBorderStyle(Value: TBorderStyle);
    procedure SetItemCount(Value: Integer);
    procedure SetItemWidth(Value: Integer);
    procedure SetItemHeight(Value: Integer);
    procedure SetItemIndex(Value: Integer);
    procedure DoItemMarginChange(Sender: TObject);
    procedure DoItemSelectionOptionsChange(Sender: TObject);
    procedure CheckItemPanelSize;
    procedure UpdateList;
    function GetItemWidth(AWithMargins: Boolean): Integer;
    function GetItemHeight(AWithMargins: Boolean): Integer;
    function GetItemRect(AIndex: Integer; AWithMargins: Boolean): TRect; overload;
    function GetItemsPerPage: Integer;
    function GetScrollItemsPerPage: Integer;
    function GetVisibleColumns: Integer;
    function GetVisibleRows: Integer;
    function GetRows: Integer;
    function GetCols: Integer;
    function GetInternalColumnLayout: TControlListColumnLayout;
    function GetFirstDrawItemIndex: Integer;
    function GetLastDrawItemIndex: Integer;
    procedure ScrollToItem(AIndex: Integer; ASelect: Boolean; AUpdate: Boolean);
    procedure FindFirstItem;
    procedure FindLastItem;
    procedure FindLeftItem;
    procedure FindRightItem;
    procedure FindUpItem;
    procedure FindDownItem;
    procedure FindPageUpItem;
    procedure FindPageDownItem;
    procedure FindNextEnabledItem(AIndex: Integer);
    procedure FindPriorEnabledItem(AIndex: Integer);
    procedure CheckHotItem;
    procedure CheckEnabledControls(AIndex: Integer);
    procedure CheckVisibleControls(AIndex: Integer);
  protected
    function ItemControlAtPos(AIndex: Integer; AX, AY: Integer): TControl;
    function ItemAtPos(AX, AY: Integer; var ARect: TRect): Integer;
    function CanObserve(const ID: Integer): Boolean; override;
    procedure DoChange; virtual;
    procedure DoItemClicked; virtual;
    procedure DoAfterDrawItems(ACanvas: TCanvas; ARect: TRect); virtual;
    procedure DoBeforeDrawItems(ACanvas: TCanvas; ARect: TRect); virtual;
    procedure DoAfterDrawItem(AIndex: Integer;
      ACanvas: TCanvas; ARect: TRect; AState: TOwnerDrawState); virtual;
    procedure DoBeforeDrawItem(AIndex: Integer;
      ACanvas: TCanvas; ARect: TRect; AState: TOwnerDrawState); virtual;
    function GetItemState(AIndex: Integer): TOwnerDrawState;
    procedure UpdateHScrollBar;
    procedure UpdateVScrollBar;
    procedure UpdateScrollBar;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DrawList(ACanvas: TCanvas); virtual;
    procedure Loaded; override;
    function GetItemCount: Integer; virtual;
    function GetChildParent: TComponent; override;
    procedure DrawItem(ACanvas: TCanvas; AX, AY: Integer; AIndex: Integer);
    procedure ChangeScale(M, D: Integer; isDpiChange: Boolean); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure WndProc(var Message: TMessage); override;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMCtl3DChanged(var Message: TMessage); message CM_CTL3DCHANGED;
    property ItemPanel: TControlListItemPanel read FItemPanel;
    property InternalColumnLayout: TControlListColumnLayout read GetInternalColumnLayout;
    property FirstDrawItemIndex: Integer read GetFirstDrawItemIndex;
    property LastDrawItemIndex: Integer read GetLastDrawItemIndex;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Invalidate; override;
    procedure Paint; override;
    procedure AddControlToItem(AControl: TControl; AUpdate: Boolean = False);
    function GetItemRect(AIndex: Integer): TRect; overload;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    /// <summary>
    /// Use IsItemEnabled method to get enabling of item with specific index
    /// </summary>
    function IsItemEnabled(const AIndex: Integer): Boolean; virtual;
    /// <summary>
    /// Use IsControlVisible method to get visibility of control on item with specific index
    /// </summary>
    function IsControlVisible(const AIndex: Integer; AControl: TControl): Boolean; virtual;
    /// <summary>
    /// Use IsControlEnabled method to get enablity of control on item with specific index
    /// </summary>
    function IsControlEnabled(const AIndex: Integer; AControl: TControl): Boolean; virtual;
    /// <summary>
    /// Use UpdateItem method to update item with specific index
    /// </summary>
    procedure UpdateItem(const AIndex: Integer); virtual;
    /// <summary>
    /// Defines whether the control has a single line drawn around it
    /// </summary>
    property BorderStyle: TBorderStyle read
      FBorderStyle write SetBorderStyle default bsSingle;
    /// <summary>
    /// Defines general background of control
    /// </summary>
    property Color default clWindow;
    /// <summary>
    /// Defines count of items
    /// </summary>
    property ItemCount: Integer read GetItemCount write SetItemCount default 0;
    /// <summary>
    /// Defines background color of item
    /// </summary>
    property ItemColor: TColor read FItemColor write SetItemColor default clNone;
    /// <summary>
    /// Index of active item
    /// </summary>
    property ItemIndex: Integer read FItemIndex write SetItemIndex default -1;
    /// <summary>
    /// Defines width of the item
    /// </summary>
    property ItemWidth: Integer read FItemWidth write SetItemWidth default 0;
    /// <summary>
    /// Defines height of the item
    /// </summary>
    property ItemHeight: Integer read FItemHeight write SetItemHeight default 70;
    /// <summary>
    /// Defines margins between items
    /// </summary>
    property ItemMargins: TMargins read
      FItemMargins write SetItemMargins;
    /// <summary>
    /// Defines column layout for items
    /// </summary>
    property ColumnLayout: TControlListColumnLayout
      read FColumnLayout write SetColumnLayout default cltSingle;
    /// <summary>
    /// Defines selection and text colors for item states
    /// </summary>
    property ItemSelectionOptions: TControlListItemSelectionOptions
      read FItemSelectionOptions write FItemSelectionOptions;
    /// <summary>
    /// Index of hot item
    /// </summary>
    property HotItemIndex: Integer read FHotItemIndex;
    /// <summary>
    /// Set MarkDisabledItem to True for automatically drawing disabled content of disabled item
    /// </summary>
    property MarkDisabledItem: Boolean
      read FMarkDisabledItem write SetMarkDisabledItem default True;
    /// <summary>
    /// Event to define property of controls and background drawing before drawing of item content
    /// </summary>
    property OnBeforeDrawItem: TControlListDrawItemEvent
      read FOnBeforeDrawItem write FOnBeforeDrawItem;
    /// <summary>
    /// Event to define property of controls and background drawing after drawing of item content
    /// </summary>
    property OnAfterDrawItem: TControlListDrawItemEvent
      read FOnAfterDrawItem write FOnAfterDrawItem;
    /// <summary>
    /// Event to define general background drawing before drawing of all items
    /// </summary>
    property OnBeforeDrawItems: TControlListDrawItemsEvent
      read FOnBeforeDrawItems write FOnBeforeDrawItems;
    /// <summary>
    /// Event to define general list drawing after drawing of all items (over all items)
    /// </summary>
    property OnAfterDrawItems: TControlListDrawItemsEvent
      read FOnAfterDrawItems write FOnAfterDrawItems;
    /// <summary>
    /// Item index change event
    /// </summary>
    property OnChange: TNotifyEvent
      read FOnChange write FOnChange;
    /// <summary>
    /// Item click event
    /// </summary>
    property OnItemClick: TNotifyEvent
      read FOnItemClick write FOnItemClick;
    /// <summary>
    /// Item double click event
    /// </summary>
    property OnItemDblClick: TNotifyEvent
      read FOnItemDblClick write FOnItemDblClick;
    /// <summary>
    /// Event to define enabled and disabled items
    /// </summary>
    property OnEnableItem: TControlListEnableItemEvent
      read FOnEnableItem write FOnEnableItem;
    /// <summary>
    /// Event to define enabled and disabled controls in specific item
    /// </summary>
    property OnEnableControl: TControlListEnableControlEvent
      read FOnEnableControl write FOnEnableControl;
    /// <summary>
    /// Event to show / hide controls in specific item
    /// </summary>
    property OnShowControl: TControlListShowControlEvent
      read FOnShowControl write FOnShowControl;
  end;

  TControlList = class(TCustomControlList)
  published
    property Align;
    property Anchors;
    property BiDiMode;
    property BorderStyle;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ItemCount;
    property ItemColor;
    property ItemWidth;
    property ItemHeight;
    property ItemIndex;
    property ItemMargins;
    property ColumnLayout;
    property ItemSelectionOptions;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentDoubleBuffered;
    property ParentFont;
    property ParentShowHint;
    property MarkDisabledItem;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property Touch;
    property Visible;
    property StyleElements;
    property StyleName;
    property OnAfterDrawItem;
    property OnBeforeDrawItem;
    property OnAfterDrawItems;
    property OnBeforeDrawItems;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEnableControl;
    property OnShowControl;
    property OnEnableItem;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGesture;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnStartDock;
    property OnStartDrag;
    property OnItemClick;
    property OnItemDblClick;
  end;

                                                                           
                                                                                   
                                                             
  TCustomControlListHelper = class helper for TCustomControlList
  private
    function GetMultiSelect: Boolean;
    function GetSelected(Index: Integer): Boolean;
    procedure SetMultiSelect(const AValue: Boolean);
    procedure SetSelected(Index: Integer; const AValue: Boolean);
    procedure RemoveList;
    procedure InitSelection;
  public
    /// <summary>
    /// Deselects all list items, including current item.
    /// </summary>
    procedure ClearSelection;
    /// <summary>
    /// Selects all list items.
    /// </summary>
    procedure SelectAll;
    /// <summary>
    /// Returns True when a list item with Index is selected.
    /// </summary>
    property Selected[Index: Integer]: Boolean read GetSelected write SetSelected;
  published
    /// <summary>
    /// Specifies whether the user can select more than one list item.
    /// </summary>
    property MultiSelect: Boolean read GetMultiSelect write SetMultiSelect default False;
  end;

  TControlListControlState = (clstNormal, clstHot, clstPressed, clstDisabled);

  /// <summary>
  /// TControlListControl control, which can change states in items of TCustomControlList control
  /// </summary>
  TControlListControl = class(TGraphicControl)
  private
    function GetControlList: TCustomControlList;
  protected
    FMouseInControl: Boolean;
    FMouseDown: Boolean;
    function GetState: TControlListControlState; virtual;
    procedure MouseEnter; virtual;
    procedure MouseLeave; virtual;
    property ControlList: TCustomControlList read GetControlList;
    property State: TControlListControlState read GetState;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Invalidate; override;
    procedure InvalidateWithItem; virtual;
  end;

  TControlListButtonStyle = (clbkPushButton, clbkToolButton, clbkLink);

  /// <summary>
  /// Special button control, which can be used in items of TCustomControlList control
  /// </summary>
  TControlListButton = class(TControlListControl)
  private
    FImages: TCustomImageList;
    FImageIndex: TImageIndex;
    FDisabledImageIndex: TImageIndex;
    FHotImageIndex: TImageIndex;
    FPressedImageIndex: TImageIndex;
    FImageName: TImageName;
    FDisabledImageName: TImageName;
    FHotImageName: TImageName;
    FPressedImageName: TImageName;
    FImageChangeLink: TChangeLink;
    FLayout: TButtonLayout;
    FSpacing: Integer;
    FMargin: Integer;
    FStyle: TControlListButtonStyle;
    FLinkHotColor: TColor;
    FWordWrap: Boolean;
    procedure SetWordWrap(Value: Boolean);
    procedure SetStyle(Value: TControlListButtonStyle);
    procedure SetLayout(Value: TButtonLayout);
    procedure SetSpacing(Value: Integer);
    procedure SetMargin(Value: Integer);
    procedure ImageListChange(Sender: TObject);
    procedure SetImages(Value: TCustomImageList);
    procedure SetImageIndex(Value: TImageIndex);
    procedure SetHotImageIndex(Value: TImageIndex);
    procedure SetPressedImageIndex(Value: TImageIndex);
    procedure SetDisabledImageIndex(Value: TImageIndex);
    procedure SetImageName(const Value: TImageName);
    procedure SetHotImageName(const Value: TImageName);
    procedure SetDisabledImageName(const Value: TImageName);
    procedure SetPressedImageName(const Value: TImageName);
    function IsImageIndexStored: Boolean;
    function IsImageNameStored: Boolean;
    procedure CheckImageIndexes;
    procedure UpdateImageName(AIndex: TImageIndex; var AName: TImageName);
    procedure UpdateImageIndex(AName: TImageName; var AIndex: TImageIndex);
    procedure PaintPushButton;
    procedure PaintToolButton;
    procedure PaintLink;
    procedure PaintImageAndText;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;
    function GetActionLinkClass: TControlActionLinkClass; override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
  published
    property Action;
    property Align;
    property Anchors;
    property BiDiMode;
    property Constraints;
    property Caption;
    property Enabled;
    property Font;
    property ParentFont;
    property ParentShowHint;
    property ParentBiDiMode;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property StyleElements;
    property StyleName;
    /// <summary>
    /// Imagelist component
    /// </summary>
    property Images: TCustomImageList read FImages write SetImages;
    /// <summary>
    /// Image index for disabled state
    /// </summary>
    property DisabledImageIndex: TImageIndex read FDisabledImageIndex write SetDisabledImageIndex default -1;
    /// <summary>
    /// Image name for disabled state
    /// </summary>
    property DisabledImageName: TImageName read FDisabledImageName write SetDisabledImageName;
    /// <summary>
    /// Image index for normal state
    /// </summary>
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex stored IsImageIndexStored default -1;
    /// <summary>
    /// Image name for normal state
    /// </summary>
    property ImageName: TImageName read FImageName write SetImageName stored IsImageNameStored;
    /// <summary>
    /// Image index for hot state
    /// </summary>
    property HotImageIndex: TImageIndex read FHotImageIndex write SetHotImageIndex default -1;
    /// <summary>
    /// Image name for hot state
    /// </summary>
    property HotImageName: TImageName read FHotImageName write SetHotImageName;
    /// <summary>
    /// Image index for pressed state
    /// </summary>
    property PressedImageIndex: TImageIndex read FPressedImageIndex write SetPressedImageIndex default -1;
    /// <summary>
    /// Image name for pressed state
    /// </summary>
    property PressedImageName: TImageName read FPressedImageName write SetPressedImageName;
    /// <summary>
    /// Margin for image and text
    /// </summary>
    property Margin: Integer read FMargin write SetMargin default -1;
    /// <summary>
    /// Spacing between image and text
    /// </summary>
    property Spacing: Integer read FSpacing write SetSpacing default 4;
    /// <summary>
    /// Defines position of image and text
    /// </summary>
    property Layout: TButtonLayout read FLayout write SetLayout default blGlyphLeft;
    /// <summary>
    /// Defines color of the text in hot state for clbkLink style
    /// </summary>
    property LinkHotColor: TColor read FLinkHotColor write FLinkHotColor default clHighLightText;
    /// <summary>
    /// Defines style of the button
    /// </summary>
    property Style: TControlListButtonStyle read FStyle write SetStyle default clbkPushButton;
    /// <summary>
    /// Defines word break for caption
    /// </summary>
    property WordWrap: Boolean read FWordWrap write SetWordWrap default False;
    property OnClick;
    property OnDblClick;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
  end;

  TControlListButtonActionLink = class(TControlActionLink)
  protected
    FClient: TControlListButton;
    FImageIndex: Integer;
    procedure AssignClient(AClient: TObject); override;
    function IsImageIndexLinked: Boolean; override;
    function IsImageNameLinked: Boolean; override;
  public
    constructor Create(AClient: TObject); override;
  end;

  EControlListException = class(Exception);

implementation

uses
  Vcl.Consts, Vcl.GraphUtil, System.Generics.Collections;

const
  DefaultItemHeight = 70;
  ItemDisabledAlpha = 120;
  CM_UPDATELIST = WM_USER + 100;

type
  TControlHookClass = class(TControl);

procedure FillRectWithAlpha(ACanvas: TCanvas; ARect: TRect; AColor: TColor; AColorAlpha: Byte);
begin
  if AColorAlpha = 255 then
  begin
    ACanvas.Brush.Style := bsSolid;
    ACanvas.Brush.Color := AColor;
    ACanvas.FillRect(ARect);
    ACanvas.Brush.Style := bsClear;
  end
  else
    FillRectAlpha(ACanvas, ARect, AColor, AColorAlpha);
end;

procedure CalcButtonLayout(ACanvas: TCanvas; const AClient: TRect;
  const ACaption: string; AImages: TCustomImageList; AImageIndex: Integer; ALayout: TButtonLayout;
  AMargin, ASpacing: Integer; var AGlyphPos: TPoint; var ATextBounds: TRect;  ABiDiFlags: LongInt);
var
  LTextPos: TPoint;
  LClientSize, LGlyphSize, LTextSize: TPoint;
  LTotalSize: TPoint;
begin
  if (ABiDiFlags and DT_RIGHT) = DT_RIGHT then
    if ALayout = blGlyphLeft then ALayout := blGlyphRight
    else
      if ALayout = blGlyphRight then ALayout := blGlyphLeft;

  LClientSize := Point(AClient.Width, AClient.Height);

  if (AImages <> nil) and (AImageIndex <> -1) then
    LGlyphSize := Point(AImages.Width, AImages.Height)
  else
    LGlyphSize := Point(0, 0);

  if Length(ACaption) > 0 then
  begin
    case ALayout of
      blGlyphLeft, blGlyphRight:
        begin
          ATextBounds := Rect(0, 0, AClient.Width, 0);
          if LGlyphSize.X > 0 then
            Dec(ATextBounds.Right, LGlyphSize.X + ASpacing);
          if AMargin > 0 then
            Dec(ATextBounds.Right, AMargin);
        end;
      blGlyphTop, blGlyphBottom:
      begin
        ATextBounds := Rect(0, 0, AClient.Width, AClient.Height);
        if LGlyphSize.Y > 0 then
          Dec(ATextBounds.Bottom, LGlyphSize.Y + ASpacing);
        if AMargin > 0 then
          Dec(ATextBounds.Bottom, AMargin);
      end;
    end;

    DrawText(ACanvas.Handle, ACaption, Length(ACaption), ATextBounds,
      DT_CALCRECT or ABiDiFlags);
    LTextSize := Point(ATextBounds.Width, ATextBounds.Height);
  end
  else
  begin
    ATextBounds := Rect(0, 0, 0, 0);
    LTextSize := Point(0,0);
  end;

  if ALayout in [blGlyphLeft, blGlyphRight] then
  begin
    AGlyphPos.Y := (LClientSize.Y - LGlyphSize.Y + 1) div 2;
    LTextPos.Y := (LClientSize.Y - LTextSize.Y + 1) div 2;
  end
  else
  begin
    AGlyphPos.X := (LClientSize.X - LGlyphSize.X + 1) div 2;
    LTextPos.X := (LClientSize.X - LTextSize.X + 1) div 2;
  end;

  if (LTextSize.X = 0) or (LGlyphSize.X = 0) then
    ASpacing := 0;

  if AMargin = -1 then
  begin
    if ASpacing < 0 then
    begin
      LTotalSize := Point(LGlyphSize.X + LTextSize.X, LGlyphSize.Y + LTextSize.Y);
      if ALayout in [blGlyphLeft, blGlyphRight] then
        AMargin := (LClientSize.X - LTotalSize.X) div 3
      else
        AMargin := (LClientSize.Y - LTotalSize.Y) div 3;
      ASpacing := AMargin;
    end
    else
    begin
      LTotalSize := Point(LGlyphSize.X + ASpacing + LTextSize.X, LGlyphSize.Y +
        ASpacing + LTextSize.Y);
      if ALayout in [blGlyphLeft, blGlyphRight] then
        AMargin := (LClientSize.X - LTotalSize.X + 1) div 2
      else
        AMargin := (LClientSize.Y - LTotalSize.Y + 1) div 2;
    end;
  end
  else
  begin
    if ASpacing < 0 then
    begin
      LTotalSize := Point(LClientSize.X - (AMargin + LGlyphSize.X), LClientSize.Y -
        (AMargin + LGlyphSize.Y));
      if ALayout in [blGlyphLeft, blGlyphRight] then
        ASpacing := (LTotalSize.X - LTextSize.X) div 2
      else
        ASpacing := (LTotalSize.Y - LTextSize.Y) div 2;
    end;
  end;

  case ALayout of
    blGlyphLeft:
      begin
        AGlyphPos.X := AMargin;
        LTextPos.X := AGlyphPos.X + LGlyphSize.X + ASpacing;
      end;
    blGlyphRight:
      begin
        AGlyphPos.X := LClientSize.X - AMargin - LGlyphSize.X;
        LTextPos.X := AGlyphPos.X - ASpacing - LTextSize.X;
      end;
    blGlyphTop:
      begin
        AGlyphPos.Y := AMargin;
        LTextPos.Y := AGlyphPos.Y + LGlyphSize.Y + ASpacing;
      end;
    blGlyphBottom:
      begin
        AGlyphPos.Y := LClientSize.Y - AMargin - LGlyphSize.Y;
        LTextPos.Y := AGlyphPos.Y - ASpacing - LTextSize.Y;
      end;
  end;

  Inc(AGlyphPos.X, AClient.Left);
  Inc(AGlyphPos.Y, AClient.Top);

  OffsetRect(ATextBounds, LTextPos.X + AClient.Left, LTextPos.Y + AClient.Top);
end;

{ TControlListItemPanel }

constructor TControlListItemPanel.CreateLinked(AControlList: TCustomControlList);
begin
  inherited Create(AControlList);
  ControlStyle := [csAcceptsControls, csCaptureMouse, csClickEvents,
    csDoubleClicks, csOpaque, csReplicatable, csGestures];
  FControlList := AControlList;
  FItemIndex := -1;
  Parent := FControlList;
end;

procedure TControlListItemPanel.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.WindowClass.style := Params.WindowClass.style and not (CS_HREDRAW or CS_VREDRAW);
end;

procedure TControlListItemPanel.Paint;
var
  LStyle: TCustomStyleServices;
  LColor: TColor;
  LState: TOwnerDrawState;
  LFontColor: TColor;
  R: TRect;

procedure DrawSelection;
var
  LColor: TColor;
  LColorAlpha: Byte;
begin
  if (odSelected in LState) and (odFocused in LState) then
  begin
    LColor := FControlList.ItemSelectionOptions.FocusedColor;
    LColorAlpha := FControlList.ItemSelectionOptions.FocusedColorAlpha;
    LFontColor := FControlList.ItemSelectionOptions.FFocusedFontColor;
  end
  else
  if (odSelected in LState) then
  begin
    LColor := FControlList.ItemSelectionOptions.SelectedColor;
    LColorAlpha := FControlList.ItemSelectionOptions.SelectedColorAlpha;
    LFontColor := FControlList.ItemSelectionOptions.FSelectedFontColor;
  end
  else
  begin
    LColor := FControlList.ItemSelectionOptions.HotColor;
    LColorAlpha := FControlList.ItemSelectionOptions.HotColorAlpha;
    LFontColor := FControlList.ItemSelectionOptions.FHotFontColor;
  end;

  if LStyle.Enabled and (seClient in FControlList.StyleElements) then
    LColor := LStyle.GetSystemColor(LColor);

  FillRectWithAlpha(Canvas, Rect(0, 0, Width, Height), LColor, LColorAlpha);
end;

procedure CheckLabelFontColors;
var
  I: Integer;
begin
  if LStyle.Enabled then
    LFontColor := LStyle.GetSystemColor(LFontColor);
  for I := 0 to ControlCount - 1 do
    if (Controls[I] is TLabel) and (seFont in Controls[I].StyleElements) then
      TLabel(Controls[I]).Font.Color := LFontColor;
end;

begin
  R := Rect(0, 0, Width, Height);

  LStyle := StyleServices(FControlList);
  LState := FControlList.GetItemState(FItemIndex);
  LFontColor := FControlList.Font.Color;

  if FControlList.FItemColor <> clNone then
  begin
    if LStyle.Enabled and (seClient in FControlList.StyleElements) then
      LColor := LStyle.GetSystemColor(FControlList.ItemColor)
    else
      LColor := FControlList.ItemColor;
  end
  else
  begin
    if LStyle.Enabled and (seClient in FControlList.StyleElements) then
      LColor := LStyle.GetSystemColor(FControlList.Color)
    else
      LColor := Color;
  end;

  Canvas.Brush.Color := LColor;

  if (csDesigning in ComponentState) or (FControlList.FItemColor <> clNone) then
    Canvas.FillRect(R);

  if (odSelected in LState) or (odHotLight in LState) then
    DrawSelection;

  if not(csDesigning in ComponentState) and FControlList.ItemSelectionOptions.UseFontColorForLabels then
    CheckLabelFontColors;

  FControlList.DoBeforeDrawItem(FItemIndex, Canvas, R, LState);
end;

procedure TControlListItemPanel.CMControlListChange(var Msg: TCMControlListChange);
begin
  if Msg.Inserting and not (Msg.Control is TGraphicControl) then
    raise EControlListException.Create(SGraphicControlAcceptedOnly);
end;

procedure TControlListItemPanel.WMPaint(var Message: TWMPaint);
begin
  inherited;
end;

procedure TControlListItemPanel.WMNCHitTest(var Message: TWMNCHitTest);
begin
  if csDesigning in ComponentState then
    Message.Result := HTCLIENT
  else
    Message.Result := HTTRANSPARENT;
end;

procedure TControlListItemPanel.WMEraseBkgnd(var Message: TMessage);
begin
  Message.Result := 1;
end;

{ TControlListItemSelectionOptions }

constructor TControlListItemSelectionOptions.Create;
begin
  inherited;
  FHotColor := clHighLight;
  FSelectedColor := clHighLight;
  FFocusedColor := clHighLight;
  FHotColorAlpha := 80;
  FSelectedColorAlpha := 130;
  FFocusedColorAlpha := 150;
  FHotFontColor := clWindowText;
  FSelectedFontColor := clWindowText;
  FFocusedFontColor := clWindowText;
end;

procedure TControlListItemSelectionOptions.Assign(Source: TPersistent);
begin
  if Source is TControlListItemSelectionOptions then
  begin
    FHotColor := TControlListItemSelectionOptions(Source).FHotColor;
    FSelectedColor := TControlListItemSelectionOptions(Source).FSelectedColor;
    FFocusedColor := TControlListItemSelectionOptions(Source).FFocusedColor;
    FHotColorAlpha := TControlListItemSelectionOptions(Source).FHotColorAlpha;
    FSelectedColorAlpha := TControlListItemSelectionOptions(Source).FSelectedColorAlpha;
    FFocusedColorAlpha := TControlListItemSelectionOptions(Source).FFocusedColorAlpha;
    FHotFontColor := TControlListItemSelectionOptions(Source).FHotFontColor;
    FSelectedFontColor := TControlListItemSelectionOptions(Source).FSelectedFontColor;
    FFocusedFontColor := TControlListItemSelectionOptions(Source).FFocusedFontColor;
    FUseFontColorForLabels := TControlListItemSelectionOptions(Source).FUseFontColorForLabels;
  end
  else
    inherited;
end;

procedure TControlListItemSelectionOptions.SetHotFontColor(Value: TColor);
begin
  if FHotFontColor <> Value then
  begin
    FHotFontColor := Value;
    DoChange;
  end;
end;

procedure TControlListItemSelectionOptions.SetFocusedFontColor(Value: TColor);
begin
  if FFocusedFontColor <> Value then
  begin
    FFocusedFontColor := Value;
    DoChange;
  end;
end;

procedure TControlListItemSelectionOptions.SetSelectedFontColor(Value: TColor);
begin
  if FSelectedFontColor <> Value then
  begin
    FSelectedFontColor := Value;
    DoChange;
  end;
end;

procedure TControlListItemSelectionOptions.SetHotColor(Value: TColor);
begin
  if FHotColor <> Value then
  begin
    FHotColor := Value;
    DoChange;
  end;
end;

procedure TControlListItemSelectionOptions.SetFocusedColor(Value: TColor);
begin
  if FFocusedColor <> Value then
  begin
    FFocusedColor := Value;
    DoChange;
  end;
end;

procedure TControlListItemSelectionOptions.SetSelectedColor(Value: TColor);
begin
  if FSelectedColor <> Value then
  begin
    FSelectedColor := Value;
    DoChange;
  end;
end;

procedure TControlListItemSelectionOptions.SetHotColorAlpha(Value: Byte);
begin
  if FHotColorAlpha <> Value then
  begin
    FHotColorAlpha := Value;
    DoChange;
  end;
end;

procedure TControlListItemSelectionOptions.SetSelectedColorAlpha(Value: Byte);
begin
  if FSelectedColorAlpha <> Value then
  begin
    FSelectedColorAlpha := Value;
    DoChange;
  end;
end;

procedure TControlListItemSelectionOptions.SetFocusedColorAlpha(Value: Byte);
begin
  if FFocusedColorAlpha <> Value then
  begin
    FFocusedColorAlpha := Value;
    DoChange;
  end;
end;

procedure TControlListItemSelectionOptions.SetUseFontColorForLabels(Value: Boolean);
begin
  if FUseFontColorForLabels <> Value then
  begin
    FUseFontColorForLabels := Value;
    DoChange;
  end;
end;

procedure TControlListItemSelectionOptions.DoChange;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

{ TCustomControlList }

class constructor TCustomControlList.Create;
begin
  TCustomStyleEngine.RegisterStyleHook(TCustomControlList, TScrollingStyleHook);
end;

class destructor TCustomControlList.Destroy;
begin
  TCustomStyleEngine.UnRegisterStyleHook(TCustomControlList, TScrollingStyleHook);
end;

constructor TCustomControlList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csCaptureMouse, csOpaque, csDoubleClicks,
    csNeedsBorderPaint, csPannable, csGestures];
  FItemMargins := TMargins.Create(Self);
  FItemMargins.Left := 0;
  FItemMargins.Top := 0;
  FItemMargins.Right := 0;
  FItemMargins.Bottom := 0;
  FItemMargins.OnChange := DoItemMarginChange;
  FItemSelectionOptions := TControlListItemSelectionOptions.Create;
  FItemSelectionOptions.OnChange := DoItemSelectionOptionsChange;
  FItemPanel := TControlListItemPanel.CreateLinked(Self);
  FItemPanel.Visible := csDesigning in ComponentState;
  FItemIndexChanged := False;
  FItemDblClick := False;
  FStopScroll := False;
  FDrawingList := False;
  FCheckingControlStates := False;
  FNeedUpdateItem := False;
  FMarkDisabledItem := True;
  FClicksDisabled := False;
  FItemDownIndex := -1;
  FItemColor := clNone;
  FScrollPos := 0;
  FItemCount := 0;
  FItemWidth := 0;
  FItemHeight := DefaultItemHeight;
  FItemIndex := -1;
  FOldWidth := -1;
  FOldHeight := -1;
  FHotItemIndex := -1;
  FActiveControl := nil;
  FBorderStyle := bsSingle;
  FColumnLayout := cltSingle;
  FUpdatingItemIndex := -1;
  ParentColor := False;
  TabStop := True;
  Color := clWindow;
  Width := 200;
  Height := 200;
end;

destructor TCustomControlList.Destroy;
begin
  RemoveList;
  FItemSelectionOptions.Free;
  FItemMargins.Free;
  inherited;
end;

function TCustomControlList.GetChildParent: TComponent;
begin
  Result := FItemPanel;
end;

procedure TCustomControlList.GetChildren(Proc: TGetChildProc; Root: TComponent);
begin
  FItemPanel.GetChildren(Proc, Root);
end;

function TCustomControlList.GetItemState(AIndex: Integer): TOwnerDrawState;
begin
  Result := [];
  if csDesigning in ComponentState then
    Exit;

  if not IsItemEnabled(AIndex) then
    Result := Result + [odDisabled]
  else
  begin
    if MultiSelect and Selected[AIndex] or
       not MultiSelect and (AIndex = FItemIndex) and (FItemIndex <> -1) then
    begin
      Result := Result + [odSelected];
      if Focused then
        Result := Result + [odFocused];
    end;
    if AIndex = FHotItemIndex then
      Result := Result + [odHotLight];
  end;
end;

function TCustomControlList.CanObserve(const ID: Integer): Boolean;
begin
  Result := False;
  if ID = TObserverMapping.EditLinkID then
    Result := True
  else if ID = TObserverMapping.PositionLinkID then
    Result := True
  else if ID = TObserverMapping.ControlValueID then
    Result := True
  else if ID = TObserverMapping.IteratorLinkID then
    Result := True;
end;

procedure TCustomControlList.ChangeScale(M, D: Integer; isDpiChange: Boolean);
begin
  FItemHeight := MulDiv(FItemHeight, M, D);
  FItemWidth := MulDiv(FItemWidth, M, D);
  FItemMargins.OnChange := nil;
  FItemMargins.Left := MulDiv(FItemMargins.Left, M, D);
  FItemMargins.Top := MulDiv(FItemMargins.Top, M, D);
  FItemMargins.Right := MulDiv(FItemMargins.Right, M, D);
  FItemMargins.Bottom := MulDiv(FItemMargins.Bottom, M, D);
  FItemMargins.OnChange := DoItemMarginChange;
  FScrollPos := MulDiv(FScrollPos, M, D);
  inherited;
  if not (csLoading in ComponentState) then
  begin
    if IsWindowVisible(Handle) then
      FStopScroll := True;
    PostMessage(Handle, CM_UPDATELIST,  0, 0);
  end;
end;

procedure TCustomControlList.DoItemSelectionOptionsChange(Sender: TObject);
begin
  if not (csDesigning in ComponentState) and not (csLoading in ComponentState) then
    Invalidate;
end;

procedure TCustomControlList.DoItemMarginChange(Sender: TObject);
begin
  if not (csLoading in ComponentState) then
    UpdateList;
end;

function TCustomControlList.IsControlVisible(const AIndex: Integer; AControl: TControl): Boolean;
begin
  if AControl <> nil then
  begin
    Result := AControl.Visible;
    if Assigned(FOnShowControl) then
      FOnShowControl(AIndex, AControl, Result);
  end
  else
    Result := False;
end;

function TCustomControlList.IsControlEnabled(const AIndex: Integer; AControl: TControl): Boolean;
begin
  if AControl <> nil then
  begin
    Result := AControl.Enabled;
    if Assigned(FOnEnableControl) then
      FOnEnableControl(AIndex, AControl, Result);
  end
  else
    Result := False;
end;

function TCustomControlList.IsItemEnabled(const AIndex: Integer): Boolean;
begin
  Result := True;
  if Assigned(FOnEnableItem) then
    FOnEnableItem(AIndex, Result);
end;

procedure TCustomControlList.DoChange;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TCustomControlList.DoItemClicked;
begin
  if Assigned(FOnItemClick) then
    FOnItemClick(Self);
end;

procedure TCustomControlList.DoBeforeDrawItems(ACanvas: TCanvas; ARect: TRect);
begin
  if Assigned(FOnBeforeDrawItems) then
    FOnBeforeDrawItems(ACanvas, ARect);
end;

procedure TCustomControlList.DoBeforeDrawItem(AIndex: Integer;
  ACanvas: TCanvas; ARect: TRect; AState: TOwnerDrawState);
begin
  if Assigned(FOnBeforeDrawItem) then
    FOnBeforeDrawItem(AIndex, ACanvas, ARect, AState);
end;

procedure TCustomControlList.DoAfterDrawItem(AIndex: Integer;
  ACanvas: TCanvas; ARect: TRect; AState: TOwnerDrawState);
begin
  if Assigned(FOnAfterDrawItem) then
    FOnAfterDrawItem(AIndex, ACanvas, ARect, AState);
end;

procedure TCustomControlList.DoAfterDrawItems(ACanvas: TCanvas; ARect: TRect);
begin
  if Assigned(FOnAfterDrawItems) then
    FOnAfterDrawItems(ACanvas, ARect);
end;

procedure TCustomControlList.SetMarkDisabledItem(Value: Boolean);
begin
   if FMarkDisabledItem <> Value then
  begin
    FMarkDisabledItem := Value;
    if not (csDesigning in ComponentState) then
      Invalidate;
  end;
end;

procedure TCustomControlList.SetItemColor(Value: TColor);
begin
  if FItemColor <> Value then
  begin
    FItemColor := Value;
    if csDesigning in ComponentState then
      FItemPanel.Invalidate
    else
      Invalidate;
  end;
end;

procedure TCustomControlList.SetItemMargins(const Value: TMargins);
begin
  FItemMargins.Assign(Value);
end;

procedure TCustomControlList.SetColumnLayout(Value: TControlListColumnLayout);
begin
  if FColumnLayout <> Value then
  begin
    FColumnLayout := Value;
    RecreateWnd;
    UpdateList;
  end;
end;

procedure TCustomControlList.SetBorderStyle(Value: TBorderStyle);
begin
  if FBorderStyle <> Value then
  begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;

function TCustomControlList.GetItemCount: Integer;
begin
  Result := FItemCount;
end;

                                                                                    
                                                                                 
                                 
procedure TCustomControlList_LimitMaximumItemCount(Self: TCustomControlList; AUpdate: Boolean);
var
  LRows, LHeight, LCount: Integer;
begin
  with Self do
  begin
    LRows := GetRows;
    LHeight := GetItemHeight(True);
    if Int64(LRows) * Int64(LHeight) > MaxInt then
    begin
      LCount := MaxInt div LHeight;
      if AUpdate then
        ItemCount := LCount
      else
        FItemCount := LCount;
    end;
  end;
end;

function TCustomControlList_IsLastConseqSel(Self: TCustomControlList; AIndex: Integer): Boolean;
var
  I, LFirst: Integer;
begin
  with Self do
  begin
    for I := AIndex + 1 to ItemCount - 1 do
      if Selected[I] then
        Exit(False);
    LFirst := -1;
    for I := AIndex downto 0 do
      if not Selected[I] then
        Break
      else
        LFirst := I;
    if LFirst = -1 then
      Exit(False);
    for I := LFirst - 1 downto 0 do
      if Selected[I] then
        Exit(False);
    Result := True;
  end;
end;

function TCustomControlList_IsFirstConseqSel(Self: TCustomControlList; AIndex: Integer): Boolean;
var
  I, LLast: Integer;
begin
  with Self do
  begin
    for I := AIndex - 1 downto 0 do
      if Selected[I] then
        Exit(False);
    LLast := -1;
    for I := AIndex to ItemCount - 1 do
      if not Selected[I] then
        Break
      else
        LLast := I;
    if LLast = -1 then
      Exit(False);
    for I := LLast + 1 to ItemCount - 1 do
      if Selected[I] then
        Exit(False);
    Result := True;
  end;
end;

procedure TCustomControlList.SetItemCount(Value: Integer);
var
  LItemIndex: Integer;
begin
  if (FItemCount <> Value) and (Value >= 0) then
  begin
    FItemCount := Value;
    TCustomControlList_LimitMaximumItemCount(Self, False);
    if FItemCount = 0 then
      LItemIndex := -1
    else
    begin
      LItemIndex := FItemIndex;
      if LItemIndex > FItemCount - 1 then
        LItemIndex := FItemCount - 1;
    end;
    InitSelection;
    UpdateList;
    ItemIndex := LItemIndex;
  end;
end;

procedure TCustomControlList.SetItemWidth(Value: Integer);
begin
  if FItemWidth <> Value then
  begin
    FItemWidth := Value;
    TCustomControlList_LimitMaximumItemCount(Self, True);
    if (FItemWidth = 0) and (FColumnLayout = cltMultiLeftToRight) then
      ColumnLayout := cltSingle
    else
      UpdateList;
  end;
end;

procedure TCustomControlList.SetItemHeight(Value: Integer);
begin
  if (FItemHeight <> Value) and (Value > 0) then
  begin
    FItemHeight := Value;
    TCustomControlList_LimitMaximumItemCount(Self, True);
    UpdateList;
  end;
end;

procedure TCustomControlList.SetItemIndex(Value: Integer);
begin
  if Value < -1 then
    Value := -1
  else
  if Value > ItemCount - 1 then
    Value := ItemCount - 1;

  if FItemIndex <> Value then
  begin
    if Observers.IsObserving(TObserverMapping.PositionLinkID) then
      TLinkObservers.PositionLinkPosChanging(Observers);

    FItemIndex := Value;
    if not (csDesigning in ComponentState) then
    begin
      if FItemIndex <> -1 then
      begin
        ScrollToItem(FItemIndex, False, False);
        UpdateList;
        if not (csLoading in ComponentState) and IsItemEnabled(FItemIndex) then
          DoChange;
      end
      else
        UpdateList;
    end;

    if Observers.IsObserving(TObserverMapping.PositionLinkID) then
      TLinkObservers.PositionLinkPosChanged(Observers);
  end;
end;

procedure TCustomControlList.WndProc(var Message: TMessage);
var
  LControl: TControl;
  LpHintInfo: Vcl.Controls.PHintInfo;
  P: TPoint;

  function GetControlAtPos(AX, AY: Integer): TControl;
  var
    LItemIndex: Integer;
    LItemRect: TRect;
  begin
    LItemIndex := ItemAtPos(AX, AY, LItemRect);
    if LItemIndex >= 0 then
    begin
      Dec(AX, LItemRect.Left);
      Dec(AY, LItemRect.Top);
      Result := ItemControlAtPos(LItemIndex, AX, AY);
    end
    else
      Result := nil;
    if Result = nil then
      Result := Self;
  end;

begin
  case Message.Msg of
    CM_UPDATELIST:
      begin
        FStopScroll := False;
        UpdateList;
      end;
    WM_LBUTTONDOWN, WM_LBUTTONDBLCLK:
      if not (csDesigning in ComponentState) then
      begin
        if not Focused then
        begin
          FClicksDisabled := True;
          WinApi.Windows.SetFocus(Handle);
          FClicksDisabled := False;
          if not Focused then Exit;
        end;

        LControl := GetControlAtPos(TWMMouse(Message).XPos, TWMMouse(Message).YPos);
        if (TControlHookClass(LControl).DragMode = dmAutomatic) or
           (LControl <> Self) and (DragMode = dmAutomatic) then
        begin
          ControlState := ControlState + [csLButtonDown];
          Dispatch(Message);

          if TControlHookClass(LControl).DragMode = dmAutomatic then
            TControlHookClass(LControl).BeginAutoDrag;

          Message.Result := 1;
          Exit;
        end;
      end;
    CN_COMMAND:
      if FClicksDisabled then Exit;
    CM_HINTSHOW:
      begin
        inherited WndProc(Message);
        LpHintInfo := Vcl.Controls.PHintInfo(Message.LParam);
        LControl := GetControlAtPos(LpHintInfo^.CursorPos.X, LpHintInfo^.CursorPos.Y);
        if LControl.Hint <> '' then
        begin
          if LControl.ShowHint then
            LpHintInfo^.HintStr := GetShortHint(LControl.Hint)
          else
            Message.Result := 1;
        end;
        Exit;
      end;
    WM_SETCURSOR:
      if (Word(Message.LParam) = HTCLIENT) and not (csDesigning in ComponentState) then
      begin
        GetCursorPos(P);
        P := ScreenToClient(P);
        LControl := GetControlAtPos(P.X, P.Y);
        if LControl.Cursor <> crDefault then
        begin
          Winapi.Windows.SetCursor(Screen.Cursors[LControl.Cursor]);
          Message.Result := 1;
          Exit;
        end;
      end;
  end;
  inherited WndProc(Message);
end;

procedure TCustomControlList.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS;
end;

procedure TCustomControlList.WMSetFocus(var Message: TWMSetFocus);
begin
  inherited;
  PostMessage(Handle, CM_UPDATELIST, 0, 0);
end;

procedure TCustomControlList.WMKillFocus(var Message: TWMKillFocus);
begin
  inherited;
  Invalidate;
end;

procedure TCustomControlList.WMMouseWheel(var Message: TWMMouseWheel);
var
  LOldScrollPos: Integer;
begin
  inherited;
  LOldScrollPos := FScrollPos;

  if InternalColumnLayout = cltMultiLeftToRight then
  begin
    if Message.WheelDelta > 0 then
      Dec(FScrollPos, GetItemWidth(True))
    else
      Inc(FScrollPos, GetItemWidth(True));
  end
  else
  begin
    if Message.WheelDelta > 0 then
      Dec(FScrollPos, GetItemHeight(True))
    else
      Inc(FScrollPos, GetItemHeight(True));
  end;

  UpdateScrollBar;
  if LOldScrollPos <> FScrollPos then
  begin
    Invalidate;
    CheckHotItem;
  end;
end;

procedure TCustomControlList.WMHScroll(var Message: TWMHScroll);
var
  LScrollInfo: TScrollInfo;
begin
  inherited;

  case Message.ScrollCode of
    SB_THUMBPOSITION, SB_ENDSCROLL:
    begin
      LScrollInfo.cbSize := SizeOf(LScrollInfo);
      LScrollInfo.fMask := SIF_ALL;
      GetScrollInfo(Handle, SB_HORZ, LScrollInfo);
      if BidiMode <> bdRightToLeft then
        FScrollPos := LScrollInfo.nPos
      else
        FScrollPos := LScrollInfo.nMax - ClientWidth - LScrollInfo.nPos;
    end;
    SB_THUMBTRACK:
    begin
      LScrollInfo.cbSize := SizeOf(LScrollInfo);
      LScrollInfo.fMask := SIF_ALL;
      GetScrollInfo(Handle, SB_HORZ, LScrollInfo);
      if BidiMode <> bdRightToLeft then
        FScrollPos := LScrollInfo.nTrackPos
      else
        FScrollPos := LScrollInfo.nMax - ClientWidth - LScrollInfo.nTrackPos;
    end;
    SB_PAGEDOWN:
      if BidiMode <> bdRightToLeft then
        Inc(FScrollPos, ClientWidth)
      else
        Dec(FScrollPos, ClientWidth);
    SB_PAGEUP:
      if BidiMode <> bdRightToLeft then
        Dec(FScrollPos, ClientWidth)
      else
        Inc(FScrollPos, ClientWidth);
    SB_LINEUP:
      if BidiMode <> bdRightToLeft then
        Dec(FScrollPos, GetItemWidth(True))
      else
        Inc(FScrollPos, GetItemWidth(True));
    SB_LINEDOWN:
      if BidiMode <> bdRightToLeft then
        Inc(FScrollPos, GetItemWidth(True))
      else
        Dec(FScrollPos, GetItemWidth(True));
    SB_BOTTOM:
      if BidiMode <> bdRightToLeft then
        FScrollPos := GetCols * GetItemWidth(True)
      else
        FScrollPos := 0;
    SB_TOP:
      if BidiMode <> bdRightToLeft then
        FScrollPos := 0
      else
        FScrollPos := GetCols * GetItemWidth(True);
  end;

  UpdateList;
end;

procedure TCustomControlList.WMVScroll(var Message: TWMVScroll);
var
  LScrollInfo: TScrollInfo;
begin
  inherited;

  case Message.ScrollCode of
    SB_THUMBPOSITION, SB_ENDSCROLL:
    begin
      LScrollInfo.cbSize := SizeOf(LScrollInfo);
      LScrollInfo.fMask := SIF_ALL;
      GetScrollInfo(Handle, SB_VERT, LScrollInfo);
      FScrollPos := LScrollInfo.nPos;
    end;
    SB_THUMBTRACK:
    begin
      LScrollInfo.cbSize := SizeOf(LScrollInfo);
      LScrollInfo.fMask := SIF_ALL;
      GetScrollInfo(Handle, SB_VERT, LScrollInfo);
      FScrollPos := LScrollInfo.nTrackPos;
    end;
    SB_PAGEDOWN:
      Inc(FScrollPos, ClientHeight);
    SB_PAGEUP:
      Dec(FScrollPos, ClientHeight);
    SB_LINEUP:
      Dec(FScrollPos, GetItemHeight(True));
    SB_LINEDOWN:
      Inc(FScrollPos, GetItemHeight(True));
    SB_BOTTOM:
     FScrollPos := GetRows * GetItemHeight(True);
    SB_TOP:
     FScrollPos := 0;
  end;

  UpdateList;
end;

function TCustomControlList.ItemControlAtPos(AIndex: Integer; AX, AY: Integer): TControl;
begin
  FCheckingControlStates := True;
  try
    CheckVisibleControls(AIndex);
    CheckEnabledControls(AIndex);
  finally
    FCheckingControlStates := False;
  end;
  Result := FItemPanel.ControlAtPos(Point(AX, AY), False);
end;

procedure TCustomControlList.MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
var
  LItemIndex,
  LPrevItemIndex, I: Integer;
  LItemRect: TRect;
  LControl: TControl;
  LPrevSelected: Boolean;
  LMultiSelect: Boolean;
begin
  inherited;
  FItemDblClick := False;
  FItemDownIndex := -1;
  LItemIndex := ItemAtPos(X, Y, LItemRect);
  FItemIndexChanged := False;
  if (Button = mbLeft) and (LItemIndex <> -1) and IsItemEnabled(LItemIndex) then
  begin
    FItemDownIndex := LItemIndex;
    FItemIndexChanged := FItemIndex <> LItemIndex;

    X := X - LItemRect.Left;
    Y := Y - LItemRect.Top;
    LControl := ItemControlAtPos(LItemIndex, X, Y);
    if (LControl <> nil) and (LControl is TControlListControl) then
    begin
      FNeedUpdateItem := not FItemIndexChanged;
      FActiveControl := LControl;
      TControlHookClass(LControl).MouseDown(mbLeft, Shift, X - LControl.Left, Y - LControl.Top);
      FNeedUpdateItem := False;
    end
    else
      if ssDouble in Shift then
      begin
        FItemDblClick := True;
        if Assigned(FOnItemDblClick) then
          FOnItemDblClick(Self);
      end;

    LMultiSelect := MultiSelect and (Button = mbLeft) and not (ssDouble in Shift);
    LPrevSelected := Selected[LItemIndex];
    LPrevItemIndex := ItemIndex;
    if LMultiSelect and ([ssCtrl, ssShift] * Shift = []) then
      InitSelection;

    if FItemIndexChanged then
    begin
      ItemIndex := LItemIndex;

      if LMultiSelect then
        if (ssShift in Shift) and (LPrevItemIndex <> - 1) then
        begin
          if LPrevItemIndex < ItemIndex then
            for I := LPrevItemIndex to ItemIndex do
              Selected[I] := True
          else
            for I := ItemIndex to LPrevItemIndex do
              Selected[I] := True;
        end
        else if ssCtrl in Shift then
        begin
          if LPrevItemIndex <> -1 then
            Selected[LPrevItemIndex] := True;
          Selected[ItemIndex] := not LPrevSelected;
        end;

      DoItemClicked;
    end
    else if LMultiSelect and (ssCtrl in Shift) then
    begin
      Selected[ItemIndex] := not LPrevSelected;
      DoItemClicked;
    end;
  end;
end;

procedure TCustomControlList.MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
var
  LItemRect: TRect;
  LControl: TControl;
begin
  inherited;
  if (Button = mbLeft) and (FItemDownIndex <> -1) and IsItemEnabled(FItemDownIndex) then
  begin
    LItemRect := GetItemRect(FItemDownIndex, True);
    X := X - LItemRect.Left;
    Y := Y - LItemRect.Top;
    LControl := ItemControlAtPos(FItemDownIndex, X, Y);
    if (LControl <> nil) and (LControl is TControlListControl) then
    begin
      FNeedUpdateItem := True;
      FActiveControl := LControl;
      TControlHookClass(LControl).MouseUp(mbLeft, Shift, X - LControl.Left, Y - LControl.Top);
      FNeedUpdateItem := False;
    end
    else
      if not FItemIndexChanged and not FItemDblClick then
        DoChange;

    if (LControl <> nil) and LControl.Visible and LControl.Enabled then
      TControlHookClass(LControl).Click;
  end;

  FItemDblClick := False;
  FItemIndexChanged := False;
  FItemDownIndex := -1;
end;

procedure TCustomControlList.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  LItemIndex: Integer;
  LItemRect: TRect;
  LControl: TControl;
  LNeedUpdate: Boolean;
begin
  inherited;
  LItemIndex := ItemAtPos(X, Y, LItemRect);
  LNeedUpdate := False;
  if (LItemIndex <> FHotItemIndex) then
  begin
    FHotItemIndex := LItemIndex;
    LNeedUpdate := True;
  end;
  if LItemIndex >= 0 then
  begin
    X := X - LItemRect.Left;
    Y := Y - LItemRect.Top;
    LControl := ItemControlAtPos(LItemIndex, X, Y);
    if LControl <> FActiveControl then
    begin
      FNeedUpdateItem := not LNeedUpdate;
      if (FActiveControl <> nil) and (FActiveControl is TControlListControl) then
        TControlListControl(FActiveControl).MouseLeave;
      if (LControl <> nil) and (LControl is TControlListControl) then
        TControlListControl(LControl).MouseEnter;
      if (LControl = nil) or (LControl.Hint <> '') and LControl.ShowHint then
        Application.CancelHint;
      FNeedUpdateItem := False;
    end;
    FActiveControl := LControl;
    if (FActiveControl <> nil) and (FActiveControl is TControlListControl) then
    begin
      FNeedUpdateItem := not LNeedUpdate;
      TControlHookClass(FActiveControl).MouseMove(Shift, X - FActiveControl.Left, Y - FActiveControl.Top);
      FNeedUpdateItem := False;
    end;
  end;

  if LNeedUpdate then
    Invalidate;
end;

procedure TCustomControlList.CheckHotItem;
var
  P: TPoint;
  LItemIndex: Integer;
  LItemRect: TRect;
begin
  if FHotItemIndex <> -1 then
  begin
    GetCursorPos(P);
    P := ScreenToClient(P);
    LItemIndex := ItemAtPos(P.X, P.Y, LItemRect);
    if LItemIndex <> FHotItemIndex then
      MouseMove([], P.X, P.Y);
  end;
end;

procedure TCustomControlList.CMCtl3DChanged(var Message: TMessage);
begin
  inherited;
  RecreateWnd;
end;

procedure TCustomControlList.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  if FHotItemIndex <> -1 then
  begin
    FHotItemIndex := -1;
    Invalidate;
  end;
end;

procedure TCustomControlList.WMSize(var Msg: TWMSize);
begin
  FOldWidth := Width;
  FOldHeight := Height;
  inherited;
  UpdateList;
end;

procedure TCustomControlList.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  Message.Result := 1;
end;

procedure TCustomControlList.Loaded;
begin
  inherited;
  UpdateList;
end;

procedure TCustomControlList.UpdateScrollBar;
begin
  if FStopScroll then
    Exit;

  if InternalColumnLayout = cltMultiLeftToRight then
    UpdateHScrollBar
  else
    UpdateVScrollBar;
end;

procedure TCustomControlList.UpdateHScrollBar;
var
  LScrollInfo: TScrollInfo;
  LScrollBarVisible: Boolean;
  LClientRect: TRect;
begin
  LClientRect := ClientRect;

  LScrollBarVisible := GetCols * GetItemWidth(True) > LClientRect.Width;

  if LScrollBarVisible then
  begin
    LScrollInfo.cbSize := SizeOf(LScrollInfo);
    LScrollInfo.fMask := SIF_ALL;
    LScrollInfo.nPage := ClientWidth;
    LScrollInfo.nMin := 0;
    LScrollInfo.nMax := GetCols * GetItemWidth(True);

    if (FOldWidth <> -1) and (Width <> FOldWidth) then
      FScrollPos := FScrollPos - (Width - FOldWidth);

    if FScrollPos > LScrollInfo.nMax - LClientRect.Width then
      FScrollPos := LScrollInfo.nMax - LClientRect.Width
    else
    if FScrollPos < 0 then
      FScrollPos := 0;

    if BidiMode <> bdRightToLeft then
      LScrollInfo.nPos := FScrollPos
    else
      LScrollInfo.nPos := LScrollInfo.nMax - LClientRect.Width - FScrollPos;
  end
  else
  begin
    FScrollPos := 0;
    FOldWidth := -1;
    SetScrollRange(Handle, SB_HORZ, 0, 0, True);
  end;
  ShowScrollBar(Handle, SB_HORZ, LScrollBarVisible);
  if LScrollBarVisible then
    SetScrollInfo(Handle, SB_HORZ, LScrollInfo, True);
end;

procedure TCustomControlList.UpdateVScrollBar;
var
  LScrollInfo: TScrollInfo;
  LScrollBarVisible: Boolean;
  LClientRect: TRect;
begin
  LClientRect := ClientRect;

  LScrollBarVisible := GetRows * GetItemHeight(True) > LClientRect.Height;

  if LScrollBarVisible then
  begin
    LScrollInfo.cbSize := SizeOf(LScrollInfo);
    LScrollInfo.fMask := SIF_ALL;
    LScrollInfo.nMin := 0;
    LScrollInfo.nPage := ClientHeight;
    LScrollInfo.nMax := GetRows * GetItemHeight(True);

    if (FOldHeight <> -1) and (Height <> FOldHeight) then
      FScrollPos := FScrollPos - (Height - FOldHeight);

    if FScrollPos > LScrollInfo.nMax - LClientRect.Height then
      FScrollPos := LScrollInfo.nMax - LClientRect.Height
    else
    if FScrollPos < 0 then
      FScrollPos := 0;

    LScrollInfo.nPos := FScrollPos;
  end
  else
  begin
    FScrollPos := 0;
    FOldHeight := -1;
    SetScrollRange(Handle, SB_VERT, 0, 0, True);
  end;
  ShowScrollBar(Handle, SB_VERT, LScrollBarVisible);
  if LScrollBarVisible then
    SetScrollInfo(Handle, SB_VERT, LScrollInfo, True);
end;

procedure TCustomControlList.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  if FBorderStyle = bsSingle then
    if Ctl3D then
    begin
      Params.Style := Params.Style and not WS_BORDER;
      Params.ExStyle := Params.ExStyle or WS_EX_CLIENTEDGE;
    end
    else
      Params.Style := Params.Style or WS_BORDER;

  if InternalColumnLayout = cltMultiLeftToRight then
    Params.Style := Params.Style or WS_HSCROLL
  else
    Params.Style := Params.Style or WS_VSCROLL;

  Params.Style := Params.Style or WS_CLIPCHILDREN or WS_TABSTOP;
  Params.WindowClass.style := Params.WindowClass.style and not (CS_HREDRAW or CS_VREDRAW);
end;

function TCustomControlList.GetInternalColumnLayout;
begin
  if FItemWidth = 0 then
    Result := cltSingle
  else
    Result := FColumnLayout;
end;

function TCustomControlList.GetVisibleColumns: Integer;
begin
  if InternalColumnLayout = cltSingle then
    Result := 1
  else
    Result := Max(ClientWidth div GetItemWidth(True), 1);
  if (InternalColumnLayout = cltMultiLeftToRight) and (Result * GetItemWidth(True) < ClientWidth) then
    Inc(Result, 2);
end;

function TCustomControlList.GetCols: Integer;
begin
  Result := ItemCount div GetVisibleRows;
  if Result * GetVisibleRows < ItemCount then
    Inc(Result);
end;

function TCustomControlList.GetRows: Integer;
begin
  Result := ItemCount div GetVisibleColumns;
  if Result * GetVisibleColumns < ItemCount then
    Inc(Result);
end;

function TCustomControlList.GetVisibleRows: Integer;
begin
  Result := Max(ClientHeight div GetItemHeight(True), 1);
  if (InternalColumnLayout <> cltMultiLeftToRight) and (Result * GetItemHeight(True) < ClientHeight) then
    Inc(Result, 2);
end;

function TCustomControlList.GetScrollItemsPerPage: Integer;
begin
  Result := Max(ClientHeight div GetItemHeight(True), 1) * Max(ClientWidth div GetItemWidth(True), 1);
end;

function TCustomControlList.GetItemsPerPage: Integer;
begin
  Result := GetVisibleRows * GetVisibleColumns;
end;

procedure TCustomControlList.FindNextEnabledItem(AIndex: Integer);
var
  LItemIndex: Integer;
  LPrevItemIndex, I: Integer;
  LShift: TShiftState;
  LSelMode: Integer;
begin
  if ItemCount = 0 then
    Exit;

  if AIndex > ItemCount - 1 then
    AIndex := ItemCount - 1;

  LItemIndex := AIndex;
  while not (IsItemEnabled(LItemIndex) or (LItemIndex = ItemCount - 1)) do
    Inc(LItemIndex);
  if ItemIndex = LItemIndex then
    Exit;

  if IsItemEnabled(LItemIndex) then
  begin
    LPrevItemIndex := ItemIndex;
    LSelMode := 0;
    if MultiSelect then
    begin
      LShift := KeyDataToShiftState(0);
      if not (ssShift in LShift) then
        InitSelection
      else if TCustomControlList_IsLastConseqSel(Self, LPrevItemIndex) then
        LSelMode := 1
      else if TCustomControlList_IsFirstConseqSel(Self, LPrevItemIndex) then
        LSelMode := -1
      else
      begin
        InitSelection;
        LSelMode := 1;
      end;
    end;

    ItemIndex := LItemIndex;

    if LSelMode <> 0 then
      for I := LPrevItemIndex to ItemIndex - 1 do
        Selected[I] := LSelMode = 1;

    DoItemClicked;
  end
  else
    FindPriorEnabledItem(LItemIndex);
end;

procedure TCustomControlList.FindPriorEnabledItem(AIndex: Integer);
var
  LItemIndex: Integer;
  LPrevItemIndex, I: Integer;
  LShift: TShiftState;
  LSelMode: Integer;
begin
  if ItemCount = 0 then
    Exit;

  if AIndex < 0 then
    AIndex := 0;

  LItemIndex := AIndex;
  while not (IsItemEnabled(LItemIndex) or (LItemIndex = 0)) do
    Dec(LItemIndex);
  if ItemIndex = LItemIndex then
    Exit;

  if IsItemEnabled(LItemIndex) then
  begin
    LPrevItemIndex := ItemIndex;
    LSelMode := 0;
    if MultiSelect then
    begin
      LShift := KeyDataToShiftState(0);
      if not (ssShift in LShift) then
        InitSelection
      else if TCustomControlList_IsFirstConseqSel(Self, LPrevItemIndex) then
        LSelMode := 1
      else if TCustomControlList_IsLastConseqSel(Self, LPrevItemIndex) then
        LSelMode := -1
      else
      begin
        InitSelection;
        LSelMode := 1;
      end;
    end;

    ItemIndex := LItemIndex;

    if LSelMode <> 0 then
      for I := LPrevItemIndex downto ItemIndex + 1 do
        Selected[I] := LSelMode = 1;

    DoItemClicked;
  end;
end;

procedure TCustomControlList.FindFirstItem;
begin
  FindNextEnabledItem(0);
end;

procedure TCustomControlList.FindLastItem;
begin
  FindPriorEnabledItem(ItemCount - 1);
end;

procedure TCustomControlList.FindLeftItem;
begin
  if FItemIndex = -1 then
  begin
    FindFirstItem;
    Exit;
  end;
  if BidiMode <> bdRightToLeft then
  begin
    if InternalColumnLayout = cltMultiLeftToRight then
      FindPriorEnabledItem(FItemIndex - GetVisibleRows)
    else
      FindPriorEnabledItem(FItemIndex - 1);
  end
  else
  begin
    if InternalColumnLayout = cltMultiLeftToRight then
      FindNextEnabledItem(FItemIndex + GetVisibleRows)
    else
      FindNextEnabledItem(FItemIndex + 1);
  end;
end;

procedure TCustomControlList.FindRightItem;
begin
  if FItemIndex = -1 then
  begin
    FindFirstItem;
    Exit;
  end;

  if BidiMode <> bdRightToLeft then
  begin
    if InternalColumnLayout = cltMultiLeftToRight then
      FindNextEnabledItem(FItemIndex + GetVisibleRows)
    else
      FindNextEnabledItem(FItemIndex + 1);
  end
  else
  begin
    if InternalColumnLayout = cltMultiLeftToRight then
      FindPriorEnabledItem(FItemIndex - GetVisibleRows)
    else
      FindPriorEnabledItem(FItemIndex - 1);
  end;
end;

procedure TCustomControlList.FindUpItem;
begin
  if FItemIndex = -1 then
  begin
    FindFirstItem;
    Exit;
  end;

  if InternalColumnLayout = cltMultiLeftToRight then
    FindPriorEnabledItem(FItemIndex - 1)
  else
    FindPriorEnabledItem(FItemIndex - GetVisibleColumns);
end;

procedure TCustomControlList.FindDownItem;
begin
  if FItemIndex = -1 then
  begin
    FindFirstItem;
    Exit;
  end;

  if InternalColumnLayout = cltMultiLeftToRight then
    FindNextEnabledItem(FItemIndex + 1)
  else
    FindNextEnabledItem(ItemIndex + GetVisibleColumns);
end;

procedure TCustomControlList.FindPageUpItem;
begin
  if FItemIndex = -1 then
  begin
    FindFirstItem;
    Exit;
  end;

  FindPriorEnabledItem(FItemIndex - GetScrollItemsPerPage);
end;

procedure TCustomControlList.FindPageDownItem;
begin
  if FItemIndex = -1 then
  begin
    FindFirstItem;
    Exit;
  end;

  FindNextEnabledItem(FItemIndex + GetScrollItemsPerPage);
end;

procedure TCustomControlList.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  case Key of
    VK_NEXT:  FindPageDownItem;
    VK_PRIOR: FindPageUpItem;
    VK_UP:    FindUpItem;
    VK_LEFT:  FindLeftItem;
    VK_DOWN:  FindDownItem;
    VK_RIGHT: FindRightItem;
    VK_HOME:  FindFirstItem;
    VK_END:   FindLastItem;
    Ord('A'):
      if (Shift = [ssCtrl]) and MultiSelect then
      begin
        SelectAll;
        DoItemClicked;
      end;
  end;
end;

function TCustomControlList.GetItemHeight(AWithMargins: Boolean): Integer;
begin
  Result := FItemHeight;
  if AWithMargins then
    Inc(Result, FItemMargins.Top + FItemMargins.Bottom);
end;

function TCustomControlList.GetItemWidth(AWithMargins: Boolean): Integer;
begin
  Result := FItemWidth;
  if Result = 0 then
  begin
    Result := ClientWidth;
    if not AWithMargins then
      Dec(Result, FItemMargins.Left + FItemMargins.Right);
  end
  else
    if AWithMargins then
      Inc(Result, FItemMargins.Left + FItemMargins.Right);
end;

function TCustomControlList.GetItemRect(AIndex: Integer; AWithMargins: Boolean): TRect;
var
  LItemRow, LItemCol: Integer;
begin
  Result := TRect.Empty;

  if InternalColumnLayout = cltMultiLeftToRight then
  begin
    LItemCol := AIndex div GetVisibleRows;
    LItemRow := AIndex - LItemCol * GetVisibleRows;
    Result.Top := LItemRow * GetItemHeight(True);
    if BidiMode <> bdRightToLeft then
      Result.Left := GetItemWidth(True) * LItemCol - FScrollPos
    else
      Result.Left := ClientWidth - (LItemCol + 1) * GetItemWidth(True) + FScrollPos;
  end
  else
  begin
    LItemRow := AIndex div GetVisibleColumns;
    LItemCol := AIndex - LItemRow * GetVisibleColumns;
    if (InternalColumnLayout = cltMultiTopToBottom) and (BidiMode = bdRightToLeft) then
      Result.Left := ClientWidth - (LItemCol + 1) * GetItemWidth(True)
    else
      Result.Left := LItemCol * GetItemWidth(True);
    Result.Top := GetItemHeight(True) * LItemRow - FScrollPos;
  end;

  Result.Right := Result.Left + GetItemWidth(True);
  Result.Bottom := Result.Top + GetItemHeight(True);

  if AWithMargins then
  begin
    Inc(Result.Left, FItemMargins.Left);
    Inc(Result.Top, FItemMargins.Top);
    Dec(Result.Right, FItemMargins.Right);
    Dec(Result.Bottom, FItemMargins.Bottom);
  end;
end;

function TCustomControlList.GetItemRect(AIndex: Integer): TRect;
begin
  Result := GetItemRect(AIndex, False);
end;

procedure TCustomControlList.ScrollToItem(AIndex: Integer; ASelect: Boolean; AUpdate: Boolean);
var
  LClientRect, LItemRect: TRect;
begin
  if csDesigning in ComponentState then
    Exit;

  if AIndex < 0 then
    AIndex := 0
  else
  if AIndex > ItemCount - 1 then
    AIndex := ItemCount - 1;

  LClientRect := ClientRect;
  LItemRect := GetItemRect(AIndex, False);

  if not LClientRect.Contains(LItemRect) then
    if InternalColumnLayout = cltMultiLeftToRight then
    begin
      if BidiMode <> bdRightToLeft then
      begin
        if LItemRect.Left < LClientRect.Left then
          Dec(FScrollPos, LClientRect.Left - LItemRect.Left)
        else
        if LItemRect.Right > LClientRect.Right then
          Inc(FScrollPos, LItemRect.Right - LClientRect.Right);
      end
      else
      begin
        if LItemRect.Left < LClientRect.Left then
          Inc(FScrollPos, LClientRect.Left - LItemRect.Left)
        else
        if LItemRect.Right > LClientRect.Right then
          Dec(FScrollPos, LItemRect.Right - LClientRect.Right);
      end;
    end
    else
    begin
      if LItemRect.Top < LClientRect.Top then
        Dec(FScrollPos, LClientRect.Top - LItemRect.Top)
      else
      if LItemRect.Bottom > LClientRect.Bottom then
        Inc(FScrollPos, LItemRect.Bottom - LClientRect.Bottom);
    end;

  if ASelect then
    FItemIndex := AIndex;
  if AUpdate then
    Invalidate;
end;

procedure TCustomControlList.UpdateItem(const AIndex: Integer);
var
  LItemRect, LClientRect: TRect;
  LBuffer: TBitmap;
  LCanvas: TCanvas;
  LDC: HDC;
begin
  if (csDesigning in ComponentState) or (csLoading in ComponentState) then
    Exit;

  if not HandleAllocated or not Visible or
     (AIndex < 0) or (AIndex > ItemCount - 1) or FDrawingList or (ClientWidth = 0) or (ClientHeight = 0) then
  begin
    FUpdatingItemIndex := -1;
    Exit;
  end;

  LItemRect := GetItemRect(AIndex, True);
  LClientRect := ClientRect;
  if not LItemRect.IsEmpty and LClientRect.IntersectsWith(LItemRect) then
  begin
    LDC := GetDC(Handle);
    try
      FUpdatingItemIndex := AIndex;
      LCanvas := TCanvas.Create;
      LCanvas.Handle := LDC;
      try
        LBuffer := TBitmap.Create(LItemRect.Width, LItemRect.Height);
        try
          MoveWindowOrg(LBuffer.Canvas.Handle, -LItemRect.Left, -LItemRect.Top);
          CheckItemPanelSize;
          DrawList(LBuffer.Canvas);
          MoveWindowOrg(LBuffer.Canvas.Handle, LItemRect.Left, LItemRect.Top);
          LCanvas.Draw(LItemRect.Left, LItemRect.Top, LBuffer);
        finally
          LBuffer.Free;
        end;
      finally
        LCanvas.Handle := 0;
        LCanvas.Free;
        FUpdatingItemIndex := -1;
      end;
    finally
      ReleaseDC(Handle, LDC);
    end;
  end;
end;

function TCustomControlList.GetFirstDrawItemIndex: Integer;
begin
  if InternalColumnLayout = cltMultiLeftToRight then
    Result := Max((FScrollPos div GetItemWidth(True)) * GetVisibleRows, 0)
  else
    Result := Max((FScrollPos div GetItemHeight(True)) * GetVisibleColumns, 0);
end;

function TCustomControlList.GetLastDrawItemIndex: Integer;
begin
  Result := Min(GetFirstDrawItemIndex + GetItemsPerPage, ItemCount - 1);
end;

function TCustomControlList.ItemAtPos(AX, AY: Integer; var ARect: TRect): Integer;
var
  I: Integer;
  LItemRect: TRect;
begin
  Result := -1;
  for I := FirstDrawItemIndex to LastDrawItemIndex do
  begin
    LItemRect := GetItemRect(I, True);
    if LItemRect.Contains(Point(AX, AY)) then
    begin
      Result := I;
      ARect := LItemRect;
      Break;
    end;
  end;
end;

procedure TCustomControlList.DrawList(ACanvas: TCanvas);

  procedure RefreshBindedControls(AControl: TWinControl);
  var
    i: Integer;
    LChild: TControl;
  begin
    for i := 0 to AControl.ControlCount - 1 do
    begin
      LChild := AControl.Controls[i];
      TLinkObservers.IteratorLinkUpdateControlComponent(Observers, LChild);
      if LChild is TWinControl then
        RefreshBindedControls(TWinControl(LChild));
    end;
  end;

var
  LStyle: TCustomStyleServices;
  LColor: TColor;
  LBrush: HBrush;
  I: Integer;
  LClientRect, LItemRect: TRect;
  LIterLink: Boolean;
begin
  LStyle := StyleServices(Self);
  if LStyle.Enabled and (seClient in StyleElements) then
    LColor := LStyle.GetSystemColor(Color)
  else
    LColor := Color;
  LClientRect := ClientRect;
  if csDesigning in ComponentState then
  begin
    LBrush := CreateHatchBrush(HS_BDIAGONAL, ColorToRGB(clBtnShadow));
    SetBkColor(ACanvas.Handle, ColorToRGB(LColor));
    FillRect(ACanvas.Handle, LClientRect, LBrush);
    DeleteObject(LBrush);
  end
  else
  begin
    ACanvas.Brush.Color := LColor;
    ACanvas.FillRect(LClientRect);
  end;

  if csDesigning in ComponentState then
    Exit;

  DoBeforeDrawItems(ACanvas, LClientRect);

  LIterLink := Observers.IsObserving(TObserverMapping.IteratorLinkID);
  if FUpdatingItemIndex = -1 then
  begin
    if LIterLink then
      TLinkObservers.IteratorLinkStartFrom(Observers, FirstDrawItemIndex);

    for I := FirstDrawItemIndex to LastDrawItemIndex do
    begin
      if LIterLink then
        TLinkObservers.IteratorLinkMoveNext(Observers);

      if (I <> ItemIndex) or (I = LastDrawItemIndex) then
      begin
        LItemRect := GetItemRect(I, True);
        if LClientRect.IntersectsWith(LItemRect) then
        begin
          if LIterLink then
            RefreshBindedControls(FItemPanel);
          DrawItem(ACanvas, LItemRect.Left, LItemRect.Top, I);
        end;
      end
      else
        FUpdatingItemIndex := I;
    end;
  end;

  if FUpdatingItemIndex <> -1 then
  begin
    if LIterLink then
      TLinkObservers.IteratorLinkStartFrom(Observers, FUpdatingItemIndex);

    LItemRect := GetItemRect(FUpdatingItemIndex, True);
    if LClientRect.IntersectsWith(LItemRect) then
    begin
      if LIterLink then
      begin
        TLinkObservers.IteratorLinkMoveNext(Observers);
        RefreshBindedControls(FItemPanel);
      end;
      DrawItem(ACanvas, LItemRect.Left, LItemRect.Top, FUpdatingItemIndex);
    end;
  end;

  if LIterLink then
    TLinkObservers.IteratorLinkFinish(Observers);

  FUpdatingItemIndex := -1;
  DoAfterDrawItems(ACanvas, LClientRect);
end;

procedure TCustomControlList.CheckEnabledControls(AIndex: Integer);
var
  I: Integer;
begin
  if Assigned(FOnEnableControl) then
    for I := 0 to FItemPanel.ControlCount - 1 do
      FItemPanel.Controls[I].Enabled := IsControlEnabled(AIndex, FItemPanel.Controls[I]);
end;

procedure TCustomControlList.CheckVisibleControls(AIndex: Integer);
var
  I: Integer;
begin
  if Assigned(FOnShowControl) then
    for I := 0 to FItemPanel.ControlCount - 1 do
      FItemPanel.Controls[I].Visible := IsControlVisible(AIndex, FItemPanel.Controls[I]);
end;

procedure TCustomControlList.DrawItem(ACanvas: TCanvas; AX, AY: Integer; AIndex: Integer);
var
  R: TRect;
  LColor: TColor;
  LStyle: TCustomStyleServices;
begin
  FItemPanel.ItemIndex := AIndex;
  CheckEnabledControls(AIndex);
  CheckVisibleControls(AIndex);
  FItemPanel.PaintTo(ACanvas, AX, AY);
  if FMarkDisabledItem and not IsItemEnabled(AIndex) then
  begin
    LStyle := StyleServices(Self);
    if LStyle.Enabled and (seClient in StyleElements) then
      LColor := LStyle.GetSystemColor(Color)
    else
      LColor := Color;
    FillRectWithAlpha(ACanvas, Rect(AX, AY, AX + GetItemWidth(True), AY + GetItemHeight(True)),
      LColor, ItemDisabledAlpha);
  end;
  if Assigned(FOnAfterDrawItem) then
  begin
    MoveWindowOrg(ACanvas.Handle, AX, AY);
    try
      R := Rect(0, 0, FItemPanel.Width, FItemPanel.Height);
      DoAfterDrawItem(AIndex, ACanvas, R, GetItemState(AIndex));
    finally
      MoveWindowOrg(ACanvas.Handle, -AX, -AY);
    end;
  end;
end;

procedure TCustomControlList.CheckItemPanelSize;
begin
  if BidiMode <> bdRightToLeft then
    FItemPanel.SetBounds(FItemMargins.Left, FItemMargins.Top, GetItemWidth(False), GetItemHeight(False))
  else
    FItemPanel.SetBounds(ClientWidth - FItemMargins.Right - GetItemWidth(False),
      FItemMargins.Top, GetItemWidth(False), GetItemHeight(False))
end;

procedure TCustomControlList.UpdateList;
begin
  UpdateScrollBar;
  Invalidate;
  CheckHotItem;
end;

procedure TCustomControlList.Invalidate;
begin
  if FDrawingList then
    Exit;

  inherited Invalidate;
end;

procedure TCustomControlList.Paint;
var
  LBuffer: TBitmap;
begin
  if FDrawingList or (ClientWidth = 0) or (ClientHeight = 0) then
    Exit;

  FUpdatingItemIndex := -1;

  FDrawingList := True;
  try
    CheckItemPanelSize;
    LBuffer := TBitmap.Create(ClientWidth, ClientHeight);
    try
      DrawList(LBuffer.Canvas);
      Canvas.Draw(0, 0, LBuffer);
    finally
      LBuffer.Free;
    end;
  finally
    FDrawingList := False;
  end;
end;

procedure TCustomControlList.AddControlToItem(AControl: TControl; AUpdate: Boolean = False);
begin
  if AControl is TGraphicControl then
  begin
    AControl.Parent := FItemPanel;
    if AUpdate then
      UpdateList;
  end;
end;

{ TCustomControlListHelper }

type
  TCustomControlListExt = class(TObject)
  private
    FMultiSelect: Boolean;
    FSelected: TDictionary<Integer, Boolean>;
    constructor Create;
    destructor Destroy; override;
  end;

var
  ExtDict: TObjectDictionary<TCustomControlList, TCustomControlListExt> = nil;

constructor TCustomControlListExt.Create;
begin
  inherited Create;
  FSelected := TDictionary<Integer, Boolean>.Create;
end;

destructor TCustomControlListExt.Destroy;
begin
  FSelected.Free;
  inherited Destroy;
end;

function GetExt(AList: TCustomControlList; AModify: Boolean): TCustomControlListExt;
begin
  if ExtDict = nil then
    if AModify then
      ExtDict := TObjectDictionary<TCustomControlList, TCustomControlListExt>.Create([doOwnsValues])
    else
      Exit(nil);
  if not ExtDict.TryGetValue(AList, Result) then
    if AModify then
    begin
      Result := TCustomControlListExt.Create;
      ExtDict.Add(AList, Result);
    end;
end;

procedure TCustomControlListHelper.RemoveList;
begin
  if ExtDict <> nil then
    ExtDict.Remove(Self);
end;

function TCustomControlListHelper.GetMultiSelect: Boolean;
var
  LExt: TCustomControlListExt;
begin
  LExt := GetExt(Self, False);
  Result := (LExt <> nil) and LExt.FMultiSelect;
end;

procedure TCustomControlListHelper.SetMultiSelect(const AValue: Boolean);
begin
  if MultiSelect <> AValue then
  begin
    GetExt(Self, True).FMultiSelect := AValue;
    if not AValue then
      InitSelection;
  end;
end;

function TCustomControlListHelper.GetSelected(Index: Integer): Boolean;
var
  LExt: TCustomControlListExt;
  LSel: Boolean;
begin
  if MultiSelect then
  begin
    LExt := GetExt(Self, False);
    Result := (LExt <> nil) and LExt.FSelected.TryGetValue(Index, LSel) and LSel or
      (Index = ItemIndex);
  end
  else
    Result := Index = ItemIndex;
end;

procedure TCustomControlListHelper.SetSelected(Index: Integer; const AValue: Boolean);
var
  LExt: TCustomControlListExt;
  LSel: Boolean;
begin
  if Selected[Index] <> AValue then
  begin
    if MultiSelect then
    begin
      LExt := GetExt(Self, True);
      if AValue then
      begin
        if not (LExt.FSelected.TryGetValue(Index, LSel) and LSel) then
          LExt.FSelected.AddOrSetValue(Index, True);
      end
      else
      begin
        LExt.FSelected.Remove(Index);
        if ItemIndex = Index then
          ItemIndex := -1;
      end;
      Invalidate;
    end
    else
    begin
      if AValue then
        ItemIndex := Index
      else if ItemIndex = Index then
        ItemIndex := -1;
    end;
  end;
end;

procedure TCustomControlListHelper.InitSelection;
begin
  GetExt(Self, True).FSelected.Clear;
  Invalidate;
end;

procedure TCustomControlListHelper.ClearSelection;
begin
  InitSelection;
  ItemIndex := -1;
end;

procedure TCustomControlListHelper.SelectAll;
var
  LExt: TCustomControlListExt;
  I: Integer;
  LSel: Boolean;
begin
  if MultiSelect then
  begin
    LExt := GetExt(Self, True);
    for I := 0 to ItemCount - 1 do
      if not LExt.FSelected.TryGetValue(I, LSel) then
        LExt.FSelected.Add(I, True)
      else if not LSel then
        LExt.FSelected.AddOrSetValue(I, True);
    Invalidate;
  end;
end;

{ TControlListControl }

constructor TControlListControl.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := ControlStyle - [csOpaque];
  FMouseInControl := False;
  FMouseDown := False;
end;

function TControlListControl.GetControlList: TCustomControlList;
begin
  Result := nil;
  if not (csDesigning in ComponentState) and (Parent <> nil) and
     (Parent is TControlListItemPanel) then
    Result := TControlListItemPanel(Parent).FControlList;
end;

function TControlListControl.GetState;
begin
  if not Enabled then
    Result := clstDisabled
  else
    Result := clstNormal;
  if (ControlList <> nil) and (ControlList.HotItemIndex = ControlList.ItemPanel.ItemIndex) then
  begin
    if FMouseDown then
      Result := clstPressed
    else
    if FMouseInControl then
      Result := clstHot;
  end;
end;

procedure TControlListControl.InvalidateWithItem;
begin
  if ControlList <> nil then
  begin
    if ControlList.FNeedUpdateItem then
      ControlList.UpdateItem(ControlList.HotItemIndex);
  end
  else
    Invalidate;
end;

procedure TControlListControl.Invalidate;
begin
  if ControlList <> nil then
  begin
    if not (csLoading in ComponentState) and not ControlList.FDrawingList and not ControlList.FCheckingControlStates then
      ControlList.Invalidate;
  end
  else
    inherited;
end;

procedure TControlListControl.MouseEnter;
begin
  FMouseInControl := True;
end;

procedure TControlListControl.MouseLeave;
begin
  FMouseInControl := False;
end;

{ TControlListButton }

constructor TControlListButton.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := ControlStyle - [csSetCaption];
  FImageChangeLink := TChangeLink.Create;
  FImageChangeLink.OnChange := ImageListChange;
  FLayout := blGlyphLeft;
  FStyle := clbkPushButton;
  FWordWrap := False;
  FLinkHotColor := clHighLight;
  FSpacing := 4;
  FMargin := -1;
  FImageIndex := -1;
  FDisabledImageIndex := -1;
  FHotImageIndex := -1;
  FPressedImageIndex := -1;
  FImageName := '';
  FDisabledImageName := '';
  FHotImageName := '';
  FPressedImageName := '';
  Width := 25;
  Height := 25;
end;

destructor TControlListButton.Destroy;
begin
  FreeAndNil(FImageChangeLink);
  inherited;
end;

procedure TControlListButton.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if AComponent = FImages then
    FImages := nil;
end;

procedure TControlListButton.MouseEnter;
begin
  inherited;
  InvalidateWithItem;
end;

procedure TControlListButton.MouseLeave;
begin
  inherited;
  FMouseDown := False;
  InvalidateWithItem;
end;

procedure TControlListButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
begin
  inherited;
  FMouseDown := True;
  InvalidateWithItem;
end;

procedure TControlListButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer);
begin
  inherited;
  FMouseDown := False;
  InvalidateWithItem;
end;

procedure TControlListButton.SetStyle(Value: TControlListButtonStyle);
begin
  if Value <> FStyle then
  begin
    FStyle := Value;
    Invalidate;
  end;
end;

procedure TControlListButton.SetImages(Value: TCustomImageList);
begin
  if Value <> FImages then
  begin
    if FImages <> nil then
    begin
      FImages.RemoveFreeNotification(Self);
      FImages.UnRegisterChanges(FImageChangeLink);
    end;
    FImages := Value;
    if FImages <> nil then
    begin
      FImages.RegisterChanges(FImageChangeLink);
      FImages.FreeNotification(Self);
    end;
    Invalidate;
  end;
end;

procedure TControlListButton.SetImageIndex(Value: TImageIndex);
begin
  if FImageIndex <> Value then
  begin
    FImageIndex := Value;
    UpdateImageName(Value, FImageName);
    Invalidate;
  end;
end;

procedure TControlListButton.SetHotImageIndex(Value: TImageIndex);
begin
   if FHotImageIndex <> Value then
  begin
    FHotImageIndex := Value;
    UpdateImageName(Value, FHotImageName);
    Invalidate;
  end;
end;

procedure TControlListButton.SetPressedImageIndex(Value: TImageIndex);
begin
  if FPressedImageIndex <> Value then
  begin
    FPressedImageIndex := Value;
    UpdateImageName(Value, FPressedImageName);
    Invalidate;
  end;
end;

procedure TControlListButton.SetDisabledImageIndex(Value: TImageIndex);
begin
  if FDisabledImageIndex <> Value then
  begin
    FDisabledImageIndex := Value;
    UpdateImageName(Value, FDisabledImageName);
    Invalidate;
  end;
end;

procedure TControlListButton.SetImageName(const Value: TImageName);
begin
  if FImageName <> Value then
  begin
    FImageName := Value;
    UpdateImageIndex(Value, FImageIndex);
  end;
end;

procedure TControlListButton.SetHotImageName(const Value: TImageName);
begin
  if FHotImageName <> Value then
  begin
    FHotImageName := Value;
    UpdateImageIndex(Value, FHotImageIndex);
  end;
end;

procedure TControlListButton.SetDisabledImageName(const Value: TImageName);
begin
  if FDisabledImageName <> Value then
  begin
    FDisabledImageName := Value;
    UpdateImageIndex(Value, FDisabledImageIndex);
  end;
end;

procedure TControlListButton.SetPressedImageName(const Value: TImageName);
begin
  if FPressedImageName <> Value then
  begin
    FPressedImageName := Value;
    UpdateImageIndex(Value, FPressedImageIndex);
  end;
end;

procedure TControlListButton.ImageListChange(Sender: TObject);
begin
  if not (csLoading in ComponentState) and not (csDestroying in ComponentState) then
  begin
    CheckImageIndexes;
    Invalidate;
  end;
end;

procedure TControlListButton.CheckImageIndexes;
begin
  if (FImages = nil) or not FImages.IsImageNameAvailable then
    Exit;
  FImages.CheckIndexAndName(FImageIndex, FImageName);
  FImages.CheckIndexAndName(FHotImageIndex, FHotImageName);
  FImages.CheckIndexAndName(FPressedImageIndex, FPressedImageName);
  FImages.CheckIndexAndName(FDisabledImageIndex, FDisabledImageName);
end;

procedure TControlListButton.UpdateImageIndex(AName: TImageName; var AIndex: TImageIndex);
begin
  if (FImages <> nil) and FImages.IsImageNameAvailable then
  begin
    AIndex := FImages.GetIndexByName(AName);
    Invalidate;
  end;
end;

procedure TControlListButton.UpdateImageName(AIndex: TImageIndex; var AName: TImageName);
begin
  if (FImages <> nil) and FImages.IsImageNameAvailable then
    AName := FImages.GetNameByIndex(AIndex);
end;

procedure TControlListButton.SetMargin(Value: Integer);
begin
  if (Value <> FMargin) and (Value >= -1) then
  begin
    FMargin := Value;
    Invalidate;
  end;
end;

procedure TControlListButton.SetSpacing(Value: Integer);
begin
  if Value <> FSpacing then
  begin
    FSpacing := Value;
    Invalidate;
  end;
end;

procedure TControlListButton.SetLayout(Value: TButtonLayout);
begin
  if FLayout <> Value then
  begin
    FLayout := Value;
    Invalidate;
  end;
end;

procedure TControlListButton.SetWordWrap(Value: Boolean);
begin
  if FWordWrap <> Value then
  begin
    FWordWrap := Value;
    Invalidate;
  end;
end;

procedure TControlListButton.PaintPushButton;
var
  LStyle: TCustomStyleServices;
  LDetails: TThemedElementDetails;
  LPaintRect: TRect;
  LDrawFlags: Integer;
  LTextColor: TColor;
begin
  Canvas.Font := Self.Font;
  LPaintRect := Rect(0, 0, Width, Height);
  LStyle := StyleServices(Self);
  if Enabled then
    LTextColor := Canvas.Font.Color
  else
    LTextColor := clGrayText;
  if LStyle.Enabled then
  begin
    LDetails := LStyle.GetElementDetails(tbPushButtonNormal);
    case State of
      clstHot:
        LDetails := LStyle.GetElementDetails(tbPushButtonHot);
      clstPressed:
        LDetails := LStyle.GetElementDetails(tbPushButtonPressed);
      clstDisabled:
        LDetails := LStyle.GetElementDetails(tbPushButtonDisabled);
    end;
    LStyle.DrawElement(Canvas.Handle, LDetails, LPaintRect);
    if seFont in StyleElements then
      LStyle.GetElementColor(LDetails, ecTextColor, LTextColor);
  end
  else
  begin
    LDrawFlags := DFCS_BUTTONPUSH or DFCS_ADJUSTRECT;
    if State = clstPressed then
      LDrawFlags := LDrawFlags or DFCS_PUSHED;
    DrawFrameControl(Canvas.Handle, LPaintRect, DFC_BUTTON, LDrawFlags);
  end;

  Canvas.Font.Color := LTextColor;
end;

procedure TControlListButton.PaintToolButton;
const
  DownStyles: array[Boolean] of Integer = (BDR_RAISEDINNER, BDR_SUNKENOUTER);
var
  LStyle: TCustomStyleServices;
  LDetails: TThemedElementDetails;
  LPaintRect: TRect;
  LTextColor: TColor;
begin
  Canvas.Font := Self.Font;
  LPaintRect := Rect(0, 0, Width, Height);
  LStyle := StyleServices(Self);
  if Enabled then
    LTextColor := Canvas.Font.Color
  else
    LTextColor := clGrayText;
  if LStyle.Enabled then
  begin
    if (State <> clstNormal) and (State <> clstDisabled) then
    begin
      if State = clstPressed then
        LDetails := LStyle.GetElementDetails(ttbButtonPressed)
      else
        LDetails := LStyle.GetElementDetails(ttbButtonHot);
      LStyle.DrawElement(Canvas.Handle, LDetails, LPaintRect);
      if seFont in StyleElements then
        LStyle.GetElementColor(LDetails, ecTextColor, LTextColor);
    end
    else
      if seFont in StyleElements then
        LTextColor := LStyle.GetSystemColor(LTextColor);
  end
  else
  begin
    if (State <> clstNormal) and (State <> clstDisabled) then
      DrawEdge(Canvas.Handle, LPaintRect, DownStyles[State = clstPressed], BF_RECT);
  end;

  Canvas.Font.Color := LTextColor;
end;

procedure TControlListButton.PaintLink;
var
  LStyle: TCustomStyleServices;
  LTextColor: TColor;
begin
  Canvas.Font := Self.Font;
  LStyle := StyleServices(Self);
  if (State = clstHot) or (State = clstPressed) then
    LTextColor := FLinkHotColor
  else
  if Enabled then
    LTextColor := Canvas.Font.Color
  else
    LTextColor := clGrayText;

  if LStyle.Enabled and (seFont in StyleElements) then
    LTextColor := LStyle.GetSystemColor(LTextColor);

  Canvas.Font.Color := LTextColor;
end;

procedure TControlListButton.PaintImageAndText;
const
  WordWraps: array[Boolean] of Word = (0, DT_WORDBREAK);
var
  LDrawRect, LTextBounds: TRect;
  LImagePos: TPoint;
  LTextFlags: Longint;
  LImageIndex: TImageIndex;
begin
  LDrawRect := Rect(0, 0, Width, Height);
  LDrawRect.Inflate(-2, -2);

  LTextFlags :=  DrawTextBiDiModeFlags(0) or WordWraps[FWordWrap] or DT_HIDEPREFIX;

  CalcButtonLayout(Canvas, LDrawRect, Caption, FImages, FImageIndex, FLayout, FMargin, FSpacing,
    LImagePos, LTextBounds, LTextFlags);
  LTextFlags := LTextFlags or DT_CENTER or DT_VCENTER;
  SetBkMode(Canvas.Handle, TRANSPARENT);
  Winapi.Windows.DrawText(Canvas.Handle, Caption, Length(Caption), LTextBounds, LTextFlags);
  LImageIndex := -1;
  case State of
    clstNormal:
      LImageIndex := FImageIndex;
    clstHot:
      LImageIndex := FHotImageIndex;
    clstPressed:
      LImageIndex := FPressedImageIndex;
    clstDisabled:
      LImageIndex := FDisabledImageIndex;
  end;
  if LImageIndex = -1 then
    LImageIndex := FImageIndex;

  if (FImages <> nil) and (LImageIndex >= 0) and (LImageIndex < FImages.Count) then
    FImages.Draw(Canvas, LImagePos.X, LImagePos.Y, LImageIndex, (State <> clstDisabled) or (FDisabledImageIndex <> -1));
end;

procedure TControlListButton.Paint;
begin
  case FStyle of
    clbkPushButton: PaintPushButton;
    clbkToolButton: PaintToolButton;
    clbkLink: PaintLink;
  end;
  PaintImageAndText;
end;

function TControlListButton.GetActionLinkClass: TControlActionLinkClass;
begin
  Result := TControlListButtonActionLink;
end;

function TControlListButton.IsImageIndexStored: Boolean;
begin
  Result := (ActionLink = nil) or not TControlListButtonActionLink(ActionLink).IsImageIndexLinked;
end;

function TControlListButton.IsImageNameStored: Boolean;
begin
  Result := (ActionLink = nil) or not TControlListButtonActionLink(ActionLink).IsImageNameLinked;
end;

procedure TControlListButton.ActionChange(Sender: TObject; CheckDefaults: Boolean);
var
  Action: TCustomAction;
begin
  inherited ActionChange(Sender, CheckDefaults);
  if Sender is TCustomAction then
  begin
    Action := TCustomAction(Sender);
    if FImages <> nil then
    begin
      if not CheckDefaults or (ImageIndex = -1) then
        ImageIndex := Action.ImageIndex;
      if not CheckDefaults or (ImageName = '') then
        ImageName := Action.ImageName;
      Exit;
    end;
  end;
end;

procedure TControlListButton.CMTextChanged(var Message: TMessage);
begin
  Invalidate;
end;

{ TControlListButtonActionLink}

procedure TControlListButtonActionLink.AssignClient(AClient: TObject);
begin
  inherited AssignClient(AClient);
  FClient := AClient as TControlListButton;
end;

constructor TControlListButtonActionLink.Create(AClient: TObject);
begin
  inherited Create(AClient);
  FImageIndex := -1;
end;

function TControlListButtonActionLink.IsImageIndexLinked: Boolean;
begin
  Result := inherited IsImageIndexLinked and
    (FClient.ImageIndex = TCustomAction(Action).ImageIndex);
end;

function TControlListButtonActionLink.IsImageNameLinked: Boolean;
begin
  Result := inherited IsImageNameLinked and
    (FClient.ImageName = TCustomAction(Action).ImageName);
end;

initialization

finalization
  FreeAndNil(ExtDict);

end.


