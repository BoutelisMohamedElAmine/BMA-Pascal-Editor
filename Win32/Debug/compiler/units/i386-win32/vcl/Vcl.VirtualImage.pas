{*******************************************************}
{                                                       }
{            Delphi Visual Component Library            }
{                                                       }
{ Copyright(c) 2018-2023 Embarcadero Technologies, Inc. }
{              All rights reserved                      }
{                                                       }
{*******************************************************}

unit Vcl.VirtualImage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Classes, System.Types, System.Messaging,
  Vcl.Graphics, Vcl.Controls, Vcl.BaseImageCollection;

type

  /// <summary>
  /// TCustomVirtualImage component, which draws scalable image from TCustomImageCollection
  /// </summary>
  TCustomVirtualImage = class(TGraphicControl)
  private
    FImageCollection: TCustomImageCollection;
    FCenter: Boolean;
    FProportional: Boolean;
    FImageWidth: Integer;
    FImageHeight: Integer;
    FImageName: String;
    FImageIndex: Integer;
    FCollectionChangedMessageID: Integer;
    procedure SetCenter(Value: Boolean);
    procedure SetProportional(Value: Boolean);
    procedure SetImageWidth(Value: Integer);
    procedure SetImageHeight(Value: Integer);
    procedure SetImageIndex(Value: Integer);
    procedure SetImageName(const Value: String);
    procedure SetImageCollection(Value: TCustomImageCollection);
    procedure CollectionChangedMessageHandler(const Sender: TObject; const Msg: System.Messaging.TMessage);
  protected
    function DestRect: TRect;
    procedure Paint; override;
    procedure CheckImageIndex;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure ChangeScale(M, D: Integer; isDpiChange: Boolean); override;
 public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    /// <summary>
    /// Indicates whether the image is centered in the image control if ImageWidth and ImageHeight properties are set
    /// </summary>
    property Center: Boolean read FCenter write SetCenter default False;
    /// <summary>
    /// Image collection component, which uses as source for image
    /// </summary>
    property ImageCollection: TCustomImageCollection
      read FImageCollection write SetImageCollection;
    /// <summary>
    /// Virtual width of the image
    /// </summary>
    property ImageWidth: Integer read FImageWidth write SetImageWidth;
    /// <summary>
    /// Virtual height of the image
    /// </summary>
    property ImageHeight: Integer read FImageHeight write SetImageHeight;
    /// <summary>
    /// Index of linked item from image collection
    /// </summary>
    property ImageIndex: Integer read FImageIndex write SetImageIndex;
    /// <summary>
    /// Name of linked item from image collection
    /// </summary>
    property ImageName: String read FImageName write SetImageName;
    /// <summary>
    /// Indicates whether the size of the image should be changed without distortion
    /// </summary>
    property Proportional: Boolean read FProportional write SetProportional default True;
  end;

  TVirtualImage = class(TCustomVirtualImage)
  published
    property Align;
    property Anchors;
    property Center;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property ImageCollection;
    property ImageWidth;
    property ImageHeight;
    property ImageIndex;
    property ImageName;
    property Enabled;
    property ParentShowHint;
    property PopupMenu;
    property Proportional;
    property ShowHint;
    property Touch;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnGesture;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

implementation
  uses
    Winapi.UxTheme, Winapi.DwmApi;

constructor TCustomVirtualImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csReplicatable, csPannable];
  FCollectionChangedMessageID := TMessageManager.DefaultManager.SubscribeToMessage(TImageCollectionChangedMessage, CollectionChangedMessageHandler);
  FProportional := True;
  FImageIndex := -1;
  Height := 105;
  Width := 105;
end;

destructor TCustomVirtualImage.Destroy;
begin
  TMessageManager.DefaultManager.Unsubscribe(TImageCollectionChangedMessage, FCollectionChangedMessageID);
  ImageCollection := nil;
  inherited Destroy;
end;

procedure  TCustomVirtualImage.ChangeScale(M, D: Integer; isDpiChange: Boolean);
begin
  FImageWidth := MulDiv(FImageWidth, M, D);
  FImageHeight := MulDiv(FImageHeight, M, D);
  inherited;
end;

function TCustomVirtualImage.DestRect: TRect;
var
  W, H: Integer;
begin
  if (FImageWidth <> 0) and (FImageHeight <> 0) then
  begin
    W := FImageWidth;
    H := FImageHeight;
  end
  else
  begin
    W := Width;
    H := Height;
  end;

  Result := Rect(0, 0, W, H);

  if FCenter then
    OffsetRect(Result, (Width - W) div 2, (Height - H) div 2);
end;

procedure TCustomVirtualImage.Paint;
begin
  if csDesigning in ComponentState then
  begin
    Canvas.Pen.Style := psDash;
    Canvas.Brush.Style := bsClear;
    Canvas.Rectangle(0, 0, Width, Height);
  end;

  CheckImageIndex;

  if (FImageCollection <> nil) and FImageCollection.IsIndexAvailable(FImageIndex) then
    FImageCollection.Draw(Canvas, DestRect, FImageIndex, FProportional);
end;

procedure TCustomVirtualImage.SetCenter(Value: Boolean);
begin
  if FCenter <> Value then
  begin
    FCenter := Value;
    if (FImageWidth > 0) and (FImageHeight > 0) then
      Invalidate;
  end;
end;

procedure TCustomVirtualImage.SetProportional(Value: Boolean);
begin
  if FProportional <> Value then
  begin
    FProportional := Value;
    Invalidate;
  end;
end;

procedure TCustomVirtualImage.SetImageWidth(Value: Integer);
begin
  if (Value >= 0) and (Value <> FImageWidth) then
  begin
    FImageWidth := Value;
    Invalidate;
  end;
end;

procedure TCustomVirtualImage.SetImageHeight(Value: Integer);
begin
  if (Value >= 0) and (Value <> FImageHeight) then
  begin
    FImageHeight := Value;
    Invalidate;
  end;
end;

procedure TCustomVirtualImage.SetImageIndex(Value: Integer);
begin
  if (FImageIndex <> Value) and (Value >= -1) then
  begin
    FImageIndex := Value;
    if FImageCollection <> nil then
      FImageName := FImageCollection.GetNameByIndex(FImageIndex);
    Invalidate;
  end;
end;

procedure TCustomVirtualImage.SetImageName(const Value: String);
begin
  if FImageName <> Value then
  begin
    FImageName := Value;
    if FImageCollection <> nil then
      FImageIndex := FImageCollection.GetIndexByName(FImageName);
    Invalidate;
  end;
end;

procedure TCustomVirtualImage.CheckImageIndex;
var
  LImageName: String;
begin
  if (FImageCollection <> nil) and (FImageName <> '') then
  begin
    LImageName := FImageCollection.GetNameByIndex(FImageIndex);
    if LImageName <> FImageName then
      FImageIndex := FImageCollection.GetIndexByName(FImageName);
  end;
end;

procedure TCustomVirtualImage.SetImageCollection(Value: TCustomImageCollection);
begin
  if FImageCollection <> Value then
  begin
    if FImageCollection <> nil then
      FImageCollection.RemoveFreeNotification(Self);
    FImageCollection := Value;
    if FImageCollection <> nil then
      FImageCollection.FreeNotification(Self);
    if not (csLoading in ComponentState) and not (csDestroying in ComponentState) then
      Invalidate;
  end;
end;

procedure TCustomVirtualImage.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FImageCollection) then
    FImageCollection := nil;
end;

procedure TCustomVirtualImage.CollectionChangedMessageHandler(const Sender: TObject; const Msg: System.Messaging.TMessage);
begin
  if TImageCollectionChangedMessage(Msg).Collection = FImageCollection then
  begin
    CheckImageIndex;
    Invalidate;
  end;
end;

end.
