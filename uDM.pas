unit uDM;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils,
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat,
  FireDAC.VCLUI.Wait, FireDAC.Comp.Client, FireDAC.Comp.UI,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, Data.DB;

type
  TDM = class(TDataModule)
    FDConnection: TFDConnection;
    FDQuery: TFDQuery;
    FDPhysSQLiteDriverLink: TFDPhysSQLiteDriverLink;
  private
    function GetDatabasePath: string;
    procedure ConfigureConnection;
    procedure CreateSchemaIfNeeded;
    function TableExists(const TableName: string): Boolean;
  public
    /// <summary>فتح الاتصال بقاعدة البيانات (يُنشئها إن لم توجد)</summary>
    function Connect: Boolean;
    /// <summary>إغلاق نظيف مع دمج ملفات WAL</summary>
    procedure Disconnect;
    /// <summary>المسار الحالي لملف database.db</summary>
    property DatabasePath: string read GetDatabasePath;
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ ============================================================
  المسار: database.db بجانب ملف exe مباشرة
  ============================================================ }
function TDM.GetDatabasePath: string;
begin
  Result := TPath.Combine(ExtractFilePath(ParamStr(0)), 'database.db');
end;

{ ============================================================
  ضبط إعدادات الاتصال (WAL + Normal locking لتفادي القفل)
  ============================================================ }
procedure TDM.ConfigureConnection;
begin
  FDConnection.Close;
  FDConnection.Params.Clear;
  FDConnection.Params.Add('DriverID=SQLite');
  FDConnection.Params.Add('Database=' + GetDatabasePath);
  FDConnection.Params.Add('JournalMode=WAL');
  FDConnection.Params.Add('LockingMode=Normal');
  FDConnection.Params.Add('Synchronous=Normal');
  FDConnection.Params.Add('SharedCache=False');
  FDConnection.Params.Add('BusyTimeout=10000');
  FDConnection.Params.Add('OpenMode=CreateUTF8');

  FDConnection.UpdateOptions.LockWait := True;
  FDConnection.UpdateOptions.LockPoint := lpDeferred;
  FDConnection.LoginPrompt := False;
  FDConnection.ResourceOptions.SilentMode := True;
  FDConnection.ResourceOptions.AutoReconnect := True;

  FDQuery.Connection := FDConnection;
end;

{ ============================================================
  التحقق من وجود جدول
  ============================================================ }
function TDM.TableExists(const TableName: string): Boolean;
begin
  FDQuery.Close;
  FDQuery.SQL.Text :=
    'SELECT COUNT(*) FROM sqlite_master ' +
    'WHERE type=''table'' AND name=:n';
  FDQuery.ParamByName('n').AsString := TableName;
  FDQuery.Open;
  Result := FDQuery.Fields[0].AsInteger > 0;
  FDQuery.Close;
end;

{ ============================================================
  إنشاء الجداول إن لم تكن موجودة
  ============================================================ }
procedure TDM.CreateSchemaIfNeeded;
begin
  // جدول MyCode
  if not TableExists('MyCode') then
  begin
    FDConnection.ExecSQL(
      'CREATE TABLE MyCode (' +
      '  NCode       INTEGER PRIMARY KEY AUTOINCREMENT,' +
      '  Title_Code  TEXT    NOT NULL,' +
      '  Code        TEXT    NOT NULL' +
      ');');
    FDConnection.ExecSQL(
      'CREATE INDEX idx_MyCode_Title ON MyCode (Title_Code);');
  end;

  // جدول My_Api_Key
  if not TableExists('My_Api_Key') then
  begin
    FDConnection.ExecSQL(
      'CREATE TABLE My_Api_Key (' +
      '  n_fix    INTEGER PRIMARY KEY AUTOINCREMENT,' +
      '  api_key  TEXT    NOT NULL' +
      ');');
    FDConnection.ExecSQL(
      'INSERT INTO My_Api_Key (api_key) VALUES ('''');');
  end;
end;

{ ============================================================
  الاتصال الرئيسي
  ============================================================ }
function TDM.Connect: Boolean;
begin
  Result := False;
  try
    ConfigureConnection;
    FDConnection.Connected := True;
    CreateSchemaIfNeeded;
    Result := FDConnection.Connected;
  except
    on E: Exception do
    begin
      Result := False;
      raise Exception.Create(
        'فشل الاتصال بقاعدة البيانات:' + sLineBreak +
        E.Message + sLineBreak +
        'المسار: ' + GetDatabasePath);
    end;
  end;
end;

{ ============================================================
  إغلاق نظيف + دمج ملفات WAL
  ============================================================ }
procedure TDM.Disconnect;
begin
  if not FDConnection.Connected then Exit;
  try
    FDConnection.ExecSQL('PRAGMA wal_checkpoint(TRUNCATE);');
    FDConnection.ExecSQL('PRAGMA journal_mode=DELETE;');
  except
    // تجاهل الأخطاء عند الإغلاق
  end;
  FDConnection.Close;
end;

end.
