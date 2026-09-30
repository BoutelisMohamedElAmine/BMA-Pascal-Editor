unit ResizeManager;

interface

uses
  System.Classes, Vcl.Controls, Vcl.Forms, System.SysUtils, System.Types;

type
  TScaleMode = (smNone, smProportional, smFixed);

  TResizeItem = class
  private
    FControl: TControl;
    FOriginalLeft: Integer;
    FOriginalTop: Integer;
    FOriginalWidth: Integer;
    FOriginalHeight: Integer;
    FOriginalParentWidth: Integer;
    FOriginalParentHeight: Integer;
    FAnchors: TAnchors;
    FScaleMode: TScaleMode;
  public
    property Control: TControl read FControl;
  end;

  TResizeManager = class(TComponent)
  private
    FItems: TList;
    FForm: TForm;
    FMinFormWidth: Integer;
    FMinFormHeight: Integer;
    FOriginalFormWidth: Integer;
    FOriginalFormHeight: Integer;
    FEnabled: Boolean;
    FAutoAddControls: Boolean;
    FOnResize: TNotifyEvent;
    procedure SetForm(const Value: TForm);
    procedure SetEnabled(const Value: Boolean);
    function GetItemCount: Integer;
    procedure UpdateOriginalSizes;
    procedure DoFormResize(Sender: TObject);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure AddControl(AControl: TControl; ScaleMode: Integer = 0);
    procedure RemoveControl(AControl: TControl);
    procedure Clear;

    procedure UpdateControls;
    procedure ResetAll;

    procedure AddControlsByClass(ParentControl: TWinControl;
      ControlClasses: array of TControlClass);
    procedure AddChildControls(ParentControl: TWinControl;
      IncludeParent: Boolean = False);

    property ItemCount: Integer read GetItemCount;
    property MinFormWidth: Integer read FMinFormWidth write FMinFormWidth;
    property MinFormHeight: Integer read FMinFormHeight write FMinFormHeight;
  published
    property Form: TForm read FForm write SetForm;
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property AutoAddControls: Boolean read FAutoAddControls write FAutoAddControls default False;
    property OnResize: TNotifyEvent read FOnResize write FOnResize;
  end;

procedure Register;

implementation

uses
  System.TypInfo, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Grids;

procedure Register;
begin
  RegisterComponents('Additional', [TResizeManager]);
end;

{ TResizeManager }

constructor TResizeManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FItems := TList.Create;
  FEnabled := True;
  FMinFormWidth := 320;
  FMinFormHeight := 240;
  FAutoAddControls := False;

  if AOwner is TForm then
    Form := TForm(AOwner);
end;

destructor TResizeManager.Destroy;
begin
  Clear;
  FItems.Free;
  inherited Destroy;
end;

procedure TResizeManager.SetForm(const Value: TForm);
begin
  if FForm <> Value then
  begin
    if FForm <> nil then
    begin
      FForm.RemoveFreeNotification(Self);
      FForm.OnResize := nil;
    end;

    FForm := Value;

    if FForm <> nil then
    begin
      FForm.FreeNotification(Self);
      FOriginalFormWidth := FForm.ClientWidth;
      FOriginalFormHeight := FForm.ClientHeight;
      FForm.OnResize := DoFormResize;
      UpdateOriginalSizes;
    end;
  end;
end;

procedure TResizeManager.SetEnabled(const Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    if FEnabled and (FForm <> nil) then
      UpdateControls;
  end;
end;

procedure TResizeManager.DoFormResize(Sender: TObject);
begin
  if FEnabled then
    UpdateControls;
end;

procedure TResizeManager.AddControl(AControl: TControl; ScaleMode: Integer);
var
  Item: TResizeItem;
  I: Integer;
begin
  if (AControl = nil) or (FForm = nil) or (AControl.Owner <> FForm) then Exit;

  // Check if already exists
  for I := 0 to FItems.Count - 1 do
    if TResizeItem(FItems[I]).FControl = AControl then Exit;

  Item := TResizeItem.Create;
  try
    Item.FControl := AControl;
    Item.FOriginalLeft := AControl.Left;
    Item.FOriginalTop := AControl.Top;
    Item.FOriginalWidth := AControl.Width;
    Item.FOriginalHeight := AControl.Height;
    Item.FOriginalParentWidth := FForm.ClientWidth;
    Item.FOriginalParentHeight := FForm.ClientHeight;
    Item.FAnchors := AControl.Anchors;

    if ScaleMode in [0..2] then
      Item.FScaleMode := TScaleMode(ScaleMode)
    else
      Item.FScaleMode := smProportional;

    FItems.Add(Item);
    AControl.FreeNotification(Self);
  except
    Item.Free;
    raise;
  end;
end;

procedure TResizeManager.RemoveControl(AControl: TControl);
var
  I: Integer;
begin
  for I := FItems.Count - 1 downto 0 do
  begin
    if TResizeItem(FItems[I]).FControl = AControl then
    begin
      TResizeItem(FItems[I]).Free;
      FItems.Delete(I);
      Break;
    end;
  end;
end;

procedure TResizeManager.Clear;
var
  I: Integer;
begin
  for I := 0 to FItems.Count - 1 do
    TResizeItem(FItems[I]).Free;
  FItems.Clear;
end;

procedure TResizeManager.UpdateControls;
var
  Item: TResizeItem;
  ScaleX, ScaleY: Double;
  NewLeft, NewTop, NewWidth, NewHeight: Integer;
  FormWidth, FormHeight: Integer;
  I: Integer;
begin
  if not FEnabled or (FForm = nil) then Exit;

  // Check minimum form size
  FormWidth := FForm.ClientWidth;
  FormHeight := FForm.ClientHeight;

  if FormWidth < FMinFormWidth then FormWidth := FMinFormWidth;
  if FormHeight < FMinFormHeight then FormHeight := FMinFormHeight;

  // Calculate scale factors
  if FOriginalFormWidth > 0 then
    ScaleX := FormWidth / FOriginalFormWidth
  else
    ScaleX := 1;

  if FOriginalFormHeight > 0 then
    ScaleY := FormHeight / FOriginalFormHeight
  else
    ScaleY := 1;

  // Update all controls
  for I := 0 to FItems.Count - 1 do
  begin
    Item := TResizeItem(FItems[I]);

    if Item.FControl = nil then Continue;
    if not Item.FControl.Visible then Continue;

    case Item.FScaleMode of
      smNone: Continue;

      smProportional:
        begin
          NewLeft := Round(Item.FOriginalLeft * ScaleX);
          NewTop := Round(Item.FOriginalTop * ScaleY);
          NewWidth := Round(Item.FOriginalWidth * ScaleX);
          NewHeight := Round(Item.FOriginalHeight * ScaleY);

          Item.FControl.SetBounds(NewLeft, NewTop, NewWidth, NewHeight);
        end;

      smFixed:
        begin
          // Only reposition, don't resize
          NewLeft := Round(Item.FOriginalLeft * ScaleX);
          NewTop := Round(Item.FOriginalTop * ScaleY);

          Item.FControl.SetBounds(NewLeft, NewTop,
            Item.FOriginalWidth, Item.FOriginalHeight);
        end;
    end;
  end;

  // Call event if assigned
  if Assigned(FOnResize) then
    FOnResize(Self);
end;

procedure TResizeManager.ResetAll;
begin
  if FForm = nil then Exit;

  FOriginalFormWidth := FForm.ClientWidth;
  FOriginalFormHeight := FForm.ClientHeight;
  UpdateOriginalSizes;
  UpdateControls;
end;

procedure TResizeManager.UpdateOriginalSizes;
var
  Item: TResizeItem;
  I: Integer;
begin
  FOriginalFormWidth := FForm.ClientWidth;
  FOriginalFormHeight := FForm.ClientHeight;

  for I := 0 to FItems.Count - 1 do
  begin
    Item := TResizeItem(FItems[I]);
    if Item.FControl <> nil then
    begin
      Item.FOriginalLeft := Item.FControl.Left;
      Item.FOriginalTop := Item.FControl.Top;
      Item.FOriginalWidth := Item.FControl.Width;
      Item.FOriginalHeight := Item.FControl.Height;
      Item.FOriginalParentWidth := FOriginalFormWidth;
      Item.FOriginalParentHeight := FOriginalFormHeight;
    end;
  end;
end;

procedure TResizeManager.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if Operation = opRemove then
  begin
    if AComponent = FForm then
    begin
      FForm := nil;
    end
    else if AComponent is TControl then
      RemoveControl(TControl(AComponent));
  end;
end;

function TResizeManager.GetItemCount: Integer;
begin
  Result := FItems.Count;
end;

procedure TResizeManager.AddControlsByClass(ParentControl: TWinControl;
  ControlClasses: array of TControlClass);

  procedure ProcessControl(Control: TControl);
  var
    J: Integer;
    K: Integer;
  begin
    for J := Low(ControlClasses) to High(ControlClasses) do
    begin
      if Control is ControlClasses[J] then
      begin
        AddControl(Control);
        Break;
      end;
    end;

    if Control is TWinControl then
    begin
      for K := 0 to TWinControl(Control).ControlCount - 1 do
        ProcessControl(TWinControl(Control).Controls[K]);
    end;
  end;

var
  I: Integer;
begin
  if ParentControl = nil then Exit;

  for I := 0 to ParentControl.ControlCount - 1 do
    ProcessControl(ParentControl.Controls[I]);
end;

procedure TResizeManager.AddChildControls(ParentControl: TWinControl;
  IncludeParent: Boolean);

  procedure ProcessControl(Control: TControl);
  var
    I: Integer;
  begin
    AddControl(Control);

    if Control is TWinControl then
    begin
      for I := 0 to TWinControl(Control).ControlCount - 1 do
        ProcessControl(TWinControl(Control).Controls[I]);
    end;
  end;

var
  I: Integer;
begin
  if ParentControl = nil then Exit;

  if IncludeParent and (ParentControl is TControl) then
    AddControl(TControl(ParentControl));

  for I := 0 to ParentControl.ControlCount - 1 do
    ProcessControl(ParentControl.Controls[I]);
end;

end.
