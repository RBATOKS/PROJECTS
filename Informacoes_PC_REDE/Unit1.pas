unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,  WinSock, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdCustomTCPServer, IdMappedPortTCP;
type
    TForm1 = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function GetCPUSpeed: Double;
const
  DelayTime = 500;
var
  TimerHi, TimerLo: DWORD;
  PriorityClass, Priority: Integer;
begin
  try
    PriorityClass := GetPriorityClass(GetCurrentProcess);
    Priority := GetThreadPriority(GetCurrentThread);
    SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
    SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);
    Sleep(10);
    asm
      dw 310Fh // rdtsc
      mov TimerLo, eax
      mov TimerHi, edx
    end;
    Sleep(DelayTime);
    asm
      dw 310Fh // rdtsc
      sub eax, TimerLo
      sbb edx, TimerHi
      mov TimerLo, eax
      mov TimerHi, edx
    end;
    SetThreadPriority(GetCurrentThread, Priority);
    SetPriorityClass(GetCurrentProcess, PriorityClass);
    Result := TimerLo / (1000.0 * DelayTime);
  except
  end;
end;

function Retorna_IP: string;
var
  p: PHostEnt;
  s: array[0..128] of char;
  p2: AnsiString;
  wVersionRequested: WORD;
  wsaData: TWSAData;
begin
  wVersionRequested := MAKEWORD(1, 1);
  WSAStartup(wVersionRequested, wsaData);
  GetHostName(@s, 128);
  p := GetHostByName(@s);
  p2 := iNet_ntoa(PInAddr(p^.h_addr_list^)^);
  Result := p2;
  WSACleanup;
end;

function Retorna_Nome: string;
var
  p: PHostEnt;
  s: array[0..128] of char;
  p2: pchar;
  wVersionRequested: WORD;
  wsaData: TWSAData;
begin
  wVersionRequested := MAKEWORD(1, 1);
  WSAStartup(wVersionRequested, wsaData);
  GetHostName(@s, 128);
  p := GetHostByName(@s);
  Result := p^.h_Name;
end;

function Retorna_Dominio: string;
var
  hProcesso, hTokenAcesso: THandle;
  Buffer: PChar;
  Usuario: array[0..31] of char;
  Dominio: array[0..31] of char;

  TamanhoBufferInfo: Cardinal;
  TamanhoUsuario: Cardinal;
  TamanhoDominio: Cardinal;
  snu: SID_NAME_USE;

begin
  TamanhoBufferInfo := 1000;
  TamanhoUsuario := sizeof(Usuario);
  TamanhoDominio := sizeof(Dominio);

  hProcesso := GetCurrentProcess;
  if OpenProcessToken(hProcesso, TOKEN_READ, hTokenAcesso) then
  try
    GetMem(Buffer, TamanhoBufferInfo);
    try
      if GetTokenInformation(hTokenAcesso, TokenUser, Buffer, TamanhoBufferInfo,
        TamanhoBufferInfo) then
        LookupAccountSid(nil, PSIDAndAttributes(Buffer)^.sid, Usuario,
          TamanhoUsuario, Dominio, TamanhoDominio, snu)
      else
        RaiseLastOSError;
    finally
      FreeMem(Buffer);
    end;
    result := Dominio;
  finally
    CloseHandle(hTokenAcesso);
  end
end;

function Retorna_Usuario: string;
var
  cUser: array[0..144] of Char;
  BufferSize: DWord;
  cUserName: string;

begin
  BufferSize := SizeOf(cUser);
  GetUserName(cUser, BufferSize);
  cUserName := Trim(StrPas(cUser));
  Result := cUserName;
end;

function Retorna_Memoria: string;
var
  MemoryStatus: TMemoryStatus;
begin
  MemoryStatus.dwLength := sizeof(MemoryStatus);
  GlobalMemoryStatus(MemoryStatus);
  Result := 'Total de memória física : ' + FormatFloat('#0,000',MemoryStatus.dwTotalPhys);
  (*
  {typedef struct _MEMORYSTATUS}
  DWORD dwLength; // sizeof(MEMORYSTATUS)
  DWORD dwMemoryLoad; // percentual de memória em uso
  DWORD dwTotalPhys; // bytes de memória física
  DWORD dwAvailPhys; // bytes livres de memória física
  DWORD dwTotalPageFile; // bytes de paginação de arquivo
  DWORD dwAvailPageFile; // bytes livres de paginação de arquivo
  DWORD dwTotalVirtual; // bytes em uso de espaço de endereço
  DWORD dwAvailVirtual; // bytes livres}
  *)
end;

function GetMacAddress: string;
var
  Lib: Cardinal;
  Func: function(GUID: PGUID): Longint; stdcall;
  GUID1, GUID2: TGUID;
begin
  Result := '';
  Lib := LoadLibrary('rpcrt4.dll');
  if Lib <> 0 then
  begin
    @Func := GetProcAddress(Lib, 'UuidCreateSequential');
    if Assigned(Func) then
    begin
      if (Func(@GUID1) = 0) and
         (Func(@GUID2) = 0) and
         (GUID1.D4[2] = GUID2.D4[2]) and
         (GUID1.D4[3] = GUID2.D4[3]) and
         (GUID1.D4[4] = GUID2.D4[4]) and
         (GUID1.D4[5] = GUID2.D4[5]) and
         (GUID1.D4[6] = GUID2.D4[6]) and
         (GUID1.D4[7] = GUID2.D4[7]) then
      begin
        Result :=
          IntToHex(GUID1.D4[2], 2) + '-' +
          IntToHex(GUID1.D4[3], 2) + '-' +
          IntToHex(GUID1.D4[4], 2) + '-' +
          IntToHex(GUID1.D4[5], 2) + '-' +
          IntToHex(GUID1.D4[6], 2) + '-' +
          IntToHex(GUID1.D4[7], 2);
      end;
    end;
  end;
end;


procedure TForm1.Button1Click(Sender: TObject);
var
  cpuspeed: string;

begin

  cpuspeed        := Format('¬f MHz', [GetCPUSpeed]);
  Label1.Caption  := 'Nome máquina: ' + Retorna_Nome;
  Label2.Caption  := 'IP: ' + Retorna_IP;
  Label3.Caption  := 'Domínio: ' + Retorna_Dominio;
  Label4.Caption  := 'Velocidade do CPU: ' + cpuspeed + ' (valor aproximado)';
  Label5.Caption  := 'Nome do usuário na rede: ' + Retorna_Usuario;
  Label6.Caption  := 'Memória RAM: ' + Retorna_Memoria;
  Label8.Caption  := 'Tamanho do Disco: ' + FormatFloat('#0,000',DiskSize(0) div 1024);
  Label7.Caption  := 'Espaço Livre: ' + FormatFloat('0,000',DiskFree(0) div 1024);
  label9.Caption  := 'Mac Adress : ' + GetMacAddress ;
  label10.Caption := '';
end;

procedure TForm1.FormShow(Sender: TObject);
   var i : integer;
begin

for i := 1 to ParamCount do
  begin

      if Copy(UpperCase(ParamStr(i)),1,4) = 'AUTO' then
      begin
        Button1.Click;
      end;
  end;
end;

end.
