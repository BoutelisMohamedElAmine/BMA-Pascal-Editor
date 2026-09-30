unit ProcessUtils;

interface

uses
  Winapi.Windows, System.SysUtils, Vcl.Dialogs, System.Classes;

function RunProcessWithCreateProcess(const Command: string): Boolean;
function RunProcessWithCreatePipe(const Command: string): string;

implementation

// 🔹 تشغيل برنامج باستخدام CreateProcess بدون قراءة المخرجات
function RunProcessWithCreateProcess(const Command: string): Boolean;
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
begin
  ZeroMemory(@StartupInfo, SizeOf(TStartupInfo));
  ZeroMemory(@ProcessInfo, SizeOf(TProcessInformation));
  StartupInfo.cb := SizeOf(TStartupInfo);

  Result := CreateProcess(nil, PChar(Command), nil, nil, False, 0, nil, nil, StartupInfo, ProcessInfo);

  if Result then
  begin
    CloseHandle(ProcessInfo.hThread);
    WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
    CloseHandle(ProcessInfo.hProcess);
  end
  else
    ShowMessage('فشل تشغيل العملية: ' + SysErrorMessage(GetLastError));
end;

// 🔹 تشغيل برنامج باستخدام CreatePipe وقراءة المخرجات القياسية
function RunProcessWithCreatePipe(const Command: string): string;
var
  SecurityAttr: TSecurityAttributes;
  ReadPipe, WritePipe: THandle;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  Buffer: array[0..4095] of Char;
  BytesRead: DWORD;
  OutputText: TStringList;
begin
  Result := '';
  OutputText := TStringList.Create;

  try
    // إعدادات الأمان للأنابيب
    SecurityAttr.nLength := SizeOf(TSecurityAttributes);
    SecurityAttr.bInheritHandle := True;
    SecurityAttr.lpSecurityDescriptor := nil;

    // إنشاء الأنابيب
    if not CreatePipe(ReadPipe, WritePipe, @SecurityAttr, 0) then
    begin
      ShowMessage('فشل إنشاء الأنابيب!');
      Exit;
    end;

    // تهيئة معلومات التشغيل
    ZeroMemory(@StartupInfo, SizeOf(TStartupInfo));
    StartupInfo.cb := SizeOf(TStartupInfo);
    StartupInfo.hStdOutput := WritePipe;
    StartupInfo.hStdError := WritePipe;
    StartupInfo.dwFlags := STARTF_USESTDHANDLES;

    ZeroMemory(@ProcessInfo, SizeOf(TProcessInformation));

    // تشغيل العملية
    if not CreateProcess(nil, PChar(Command), nil, nil, True, CREATE_NO_WINDOW, nil, nil, StartupInfo, ProcessInfo) then
    begin
      ShowMessage('فشل تشغيل العملية: ' + SysErrorMessage(GetLastError));
      CloseHandle(ReadPipe);
      CloseHandle(WritePipe);
      Exit;
    end;

    // إغلاق المقبض غير المستخدم للكتابة
    CloseHandle(WritePipe);

    // قراءة المخرجات من الأنبوب
    while ReadFile(ReadPipe, Buffer, SizeOf(Buffer) - 1, BytesRead, nil) and (BytesRead > 0) do
    begin
      Buffer[BytesRead] := #0;
      OutputText.Add(Buffer);
    end;

    // إغلاق الأنابيب
    CloseHandle(ReadPipe);
    WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
    CloseHandle(ProcessInfo.hProcess);
    CloseHandle(ProcessInfo.hThread);

    // إرجاع الناتج
    Result := OutputText.Text;
  finally
    OutputText.Free;
  end;
end;

end.

