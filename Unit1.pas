
unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StdCtrls, Dialogs, ExtCtrls, WinSock, AppEvnts, Buttons, Gauges, Spin,
  ComCtrls, XPMan, ActiveX, ComObj;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    Label3: TLabel;
    Label4: TLabel;
    StatusBar1: TStatusBar;
    ProgressBar1: TProgressBar;
    Label5: TLabel;
    Button1: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ListBox1: TListBox;
    ListBox2: TListBox;
    HeaderControl1: THeaderControl;
    Label6: TLabel;
    ComboBox1: TComboBox;
    Label7: TLabel;
    Button2: TButton;
    Label8: TLabel;
    Bevel1: TBevel;
    Label9: TLabel;
    SpinEdit3: TSpinEdit;
    Bevel2: TBevel;
    Button3: TButton;
    SpinEdit4: TSpinEdit;
    SpinEdit5: TSpinEdit;
    Label10: TLabel;
    Label11: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ApplicationEvents1Message(var Msg: tagMSG;
      var Handled: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TMyThread = class(TThread)
   protected
    procedure Execute; override;
  end;

  TFSocket = record
   sa: TSockAddr;
   FData: integer;
   TimeOut: integer;
  end;

const
 MAX_PORTS=500;
 Ping=5000;

var
  Form1: TForm1;
  FSocket: array [0..MAX_PORTS - 1] of TFSocket;
  FPort: WORD;
  FInfo: TWSADATA;
  FHost: integer;
  FPStart, FPEnd: WORD;
  SThread: TMyThread;

implementation

{$R *.dfm}
function GetStatusCodeStr(statusCode:integer) : string;
begin
  case statusCode of
    0     : Result:='Success';
    11001 : Result:='Buffer Too Small';
    11002 : Result:='Destination Net Unreachable';
    11003 : Result:='Destination Host Unreachable';
    11004 : Result:='Destination Protocol Unreachable';
    11005 : Result:='Destination Port Unreachable';
    11006 : Result:='No Resources';
    11007 : Result:='Bad Option';
    11008 : Result:='Hardware Error';
    11009 : Result:='Packet Too Big';
    11010 : Result:='Request Timed Out';
    11011 : Result:='Bad Request';
    11012 : Result:='Bad Route';
    11013 : Result:='TimeToLive Expired Transit';
    11014 : Result:='TimeToLive Expired Reassembly';
    11015 : Result:='Parameter Problem';
    11016 : Result:='Source Quench';
    11017 : Result:='Option Too Big';
    11018 : Result:='Bad Destination';
    11032 : Result:='Negotiating IPSEC';
    11050 : Result:='General Failure'
    else
    result:='Unknow';
  end;
end;

procedure PingHost(const Address:string;Retries,BufferSize:Word);
var
  FSWbemLocator : OLEVariant;
  FWMIService   : OLEVariant;
  FWbemObjectSet: OLEVariant;
  FWbemObject   : OLEVariant;
  oEnum         : IEnumvariant;
  iValue        : LongWord;
  i             : Integer;

  PacketsReceived : Integer;
  Minimum         : Integer;
  Maximum         : Integer;
  Average         : Integer;
begin;
  PacketsReceived:=0;
  Minimum        :=0;
  Maximum        :=0;
  Average        :=0;

  Form1.ListBox1.Items.Add(Format('Pinging %s with %d bytes of data:',[Address,BufferSize]));

  FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  FWMIService   := FSWbemLocator.ConnectServer('localhost', 'root\CIMV2', '', '');
  //FWMIService   := FSWbemLocator.ConnectServer(Form1.Edit1.Text, 'root\CIMV2', 'user', 'password');
  for i := 0 to Retries-1 do
  begin
    FWbemObjectSet:= FWMIService.ExecQuery(Format('SELECT * FROM Win32_PingStatus where Address=%s AND BufferSize=%d',[QuotedStr(Address),BufferSize]),'WQL',0);
    oEnum         := IUnknown(FWbemObjectSet._NewEnum) as IEnumVariant;
    if oEnum.Next(1, FWbemObject, iValue) = 0 then
    begin
      if FWbemObject.StatusCode=0 then
      begin
        if FWbemObject.ResponseTime>0 then
        Form1.ListBox1.Items.Add(Format('Reply from %s: bytes=%s time=%sms TTL=%s',[FWbemObject.ProtocolAddress,FWbemObject.ReplySize,FWbemObject.ResponseTime,FWbemObject.TimeToLive]))
        else
        Form1.ListBox1.Items.Add(Format('Reply from %s: bytes=%s time=<1ms TTL=%s',[FWbemObject.ProtocolAddress,FWbemObject.ReplySize,FWbemObject.TimeToLive]));

        Inc(PacketsReceived);

        if FWbemObject.ResponseTime>Maximum then
        Maximum:=FWbemObject.ResponseTime;

        if Minimum=0 then Minimum:=Maximum;

        if FWbemObject.ResponseTime<Minimum then
        Minimum:=FWbemObject.ResponseTime;

        Average:=Average+FWbemObject.ResponseTime;
      end
      else
      if not VarIsNull(FWbemObject.StatusCode) then
      Form1.ListBox1.Items.Add(Format('Reply from %s: %s',[FWbemObject.ProtocolAddress,GetStatusCodeStr(FWbemObject.StatusCode)]))
      else
      Form1.ListBox1.Items.Add(Format('Reply from %s: %s',[Address,'Error processing request']));
    end;
    FWbemObject:=Unassigned;
    FWbemObjectSet:=Unassigned;
  end;

  Form1.ListBox1.Items.Add(Format('Ping statistics for %s:',[Address]));
  Form1.ListBox1.Items.Add(Format('    Packets: Sent = %d, Received = %d, Lost = %d (%d%% loss),',[Retries,PacketsReceived,Retries-PacketsReceived,Round((Retries-PacketsReceived)*100/Retries)]));

  if PacketsReceived>0 then
  begin
  Form1.ListBox1.Items.Add('Approximate round trip times in milli-seconds:');

   Form1.ListBox1.Items.Add(Format('    Minimum = %dms, Maximum = %dms, Average = %dms',[Minimum,Maximum,Round(Average/PacketsReceived)]));
  end;
end;

function PortTCPIsOpen(dwPort : Word; ipAddressStr:string) : boolean;
var
      client : sockaddr_in;//sockaddr_in is used by Windows Sockets to specify a local or remote endpoint address
      sock   : Integer;
begin
        client.sin_family      := AF_INET;
        client.sin_port        := htons(dwPort);//htons converts a u_short from host to TCP/IP network byte order.
        client.sin_addr.s_addr := inet_addr(PAnsiChar(AnsiString(ipAddressStr))); //the inet_addr function converts a string containing an IPv4 dotted-decimal address into a proper address for the IN_ADDR structure.
        sock  :=socket(AF_INET, SOCK_STREAM, 0);//The socket function creates a socket
        Result:=connect(sock,client,SizeOf(client))=0;//establishes a connection to a specified socket.
end;

procedure Ports();
var
  ret    : Integer;
  wsdata : WSAData;
begin
  Screen.Cursor := crHourGlass;
  //Form1.ListBox1.Items.Add('Init WinSock');
  ret := WSAStartup($0002, wsdata);   //initiates use of the Winsock
  if ret<>0 then exit;
  try
    Form1.ListBox1.Items.Add('Description : '+wsData.szDescription);
    Form1.ListBox1.Items.Add('Status         : '+wsData.szSystemStatus);

    if PortTCPIsOpen(Form1.SpinEdit3.Value,Form1.Edit1.Text) then
    Form1.ListBox1.Items.Add('Result         : Port is Open')
    else
    Form1.ListBox1.Items.Add('Result         : Port is Closed');

  finally
  WSACleanup;     //terminates use of the Winsock
  Form1.ListBox1.Items.Add('ready.');
  Screen.Cursor := crDefault;
  end;
end;

function IP : string;
resourcestring
 cTxtIP = '%d.%d.%d.%d';
var rSockVer : WordRec; aWSAData : TWSAData;
    szHostName : array[0..255] of Char; pHE : PHostEnt; sIP : String;
begin
  rSockVer.Hi := 1;
  rSockVer.Lo := 1;
  WSAStartup(Word(rSockVer), aWSAData );
   try
     FillChar(szHostName, SizeOf(szHostName), #0);
     GetHostName(@szHostName, SizeOf(szHostName));
     pHE := GetHostByName(@szHostName);
     if Assigned(pHE) then with pHE^ do
      sIP := Format(cTxtIP,[Byte(h_addr^[0]), Byte(h_addr^[1]),
                    Byte(h_addr^[2]), Byte(h_addr^[3])]);
   finally
   WSACleanup;
  end;
  Form1.ComboBox1.Items.Add(sIP);
end;

function GetComputerName: String;
var
  Len: DWORD;
begin
  Len:=MAX_COMPUTERNAME_LENGTH+1;
  SetLength(Result,Len);
  if Windows.GetComputerName(PChar(Result), Len) then
    SetLength(Result,Len)
  else
    RaiseLastOSError;
end;

procedure TForm1.ApplicationEvents1Message(var Msg: tagMSG;
  var Handled: Boolean);
begin
 if (Msg.message>=FPStart+WM_USER) and (Msg.message<=FPEnd+WM_USER)
 then
 if WSAGETSELECTERROR(Msg.lParam)=0
 then
  case WSAGETSELECTEVENT(msg.lParam) of
   FD_CONNECT:
      begin
       ListBox1.Items.Add(IntToStr(ListBox1.Count + 1)+
                        ') IP: '+inet_ntoa(FSocket[0].sa.sin_addr)+'  |  '+
                        'Port: '+intToStr(Msg.message - WM_USER) + ' | Open');
       Application.ProcessMessages;
      end;
  end;
 Handled:=false;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if SThread = nil
 then
  begin
   SThread:=TMyThread.Create(false);
   Button1.Caption:='Stop';
  end
 else
  begin
   SThread.Terminate;
   SThread.WaitFor;
   SThread := nil;
   Button1.Caption:='Start';
   StatusBar1.Panels[0].Text := 'Progress : finish.';
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin

  ListBox1.Items.Add('');
  ListBox1.Items.Add('Check Port : ' + IntToStr(SpinEdit3.Value) + ' | ' + Edit1.Text);
  Application.ProcessMessages;
  ports();
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  try
    try
      ListBox1.Items.Add('');
      PingHost(Edit1.Text, SpinEdit4.Value, SpinEdit5.Value);
    finally
    end;
 except
    on E:Exception do
        Writeln(E.Classname, ':', E.Message);
 end;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  case ComboBox1.ItemIndex of
  0 : begin Label8.Caption := 'Network'; Edit1.Text := ComboBox1.Text; end;
  1 : begin Label8.Caption := 'Localhost'; Edit1.Text := ComboBox1.Text; end;
  2 : begin Label8.Caption := 'Gateway'; Edit1.Text := ComboBox1.Text; end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
 i: integer;
 s : string;
 IPs: TStrings;
begin
 if WSAStartup(MAKEWORD(2, 0), FInfo)<>0
 then Halt;
 for i:=0 to MAX_PORTS-1 do
 with FSocket[i] do
  begin
   TimeOut := 0;
   FData := Socket(AF_INET, SOCK_STREAM, 0);
   if FData = SOCKET_ERROR
   then
    begin
     WSACleanup;
     Halt;
    end;
  end;

  IP;
  ComboBox1.Items.Add('127.0.0.1');
  ComboBox1.Items.Add('192.168.0.1');
  ComboBox1.ItemIndex := 0;

 ListBox2.Items.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Ports\ports.lst');
 StatusBar1.Panels[2].Text := GetComputerName;
 Application.OnMessage:=Form1.ApplicationEvents1Message;
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
 i: integer;
begin
 if SThread<>nil
 then
  begin
   SThread.Terminate;
   SThread.WaitFor;
   SThread:=nil;
  end;
 for i:=0 to MAX_PORTS-1 do
  CloseSocket(FSocket[i].FData);
 WSACleanup;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  ComboBox1.OnChange(sender);
  StatusBar1.SetFocus;
end;

procedure InitSockets;
var
 i: integer;
begin
 for i:=0 to MAX_PORTS-1 do
  with FSocket[i] do
   if (FPort>=FPEnd) or (SThread.Terminated)
    then break
   else

    if GetTickCount-TimeOut>PING
    then

     begin
      sa.sin_family:=AF_INET;
      sa.sin_addr.S_addr:=FHost;
      sa.sin_port:=htons(FPort);
      WSAAsyncSelect(FData, Application.Handle, WM_USER+FPort, FD_CONNECT);
      connect(FData, FSocket[i].sa, SizeOf(FSocket[i].sa));
      TimeOut:=GetTickCount;
      inc(FPort);
      Form1.Label2.Caption:='Port: '+intToStr(FPort);
      Form1.ProgressBar1.Position :=trunc(((FPort-FPStart)*100)/(FPEnd-FPStart));
      Form1.StatusBar1.Panels[0].Text := 'Progress : ' + IntToStr(Form1.ProgressBar1.Position) + ' %';
      Application.ProcessMessages;
      Sleep(PING div MAX_PORTS);
     end;
end;

procedure TMyThread.Execute;
var
 i: integer;
 buf: in_addr;
begin
 FPStart:=Form1.SpinEdit1.Value;
 FPEnd:=Form1.SpinEdit2.Value;
 FHost:=inet_addr(PAnsiChar(AnsiString(Form1.Edit1.Text)));
 if (FPEnd<=FPStart)or (Form1.SpinEdit1.Value>65535) or
                            (Form1.SpinEdit2.Value>65535)
 then FHost:=SOCKET_ERROR;
 if FHost=SOCKET_ERROR
 then
  begin
   if not Terminated
   then SThread:=nil;
   Form1.Button1.Caption:='Start';
   Exit;
  end;
 buf.S_addr:=FHost;
 Form1.Edit1.Text:=inet_ntoa(buf);
 Form1.ListBox1.Clear;
 FPort:=FPStart;

 for i:=0 to MAX_PORTS-1 do
  with FSocket[i] do
   begin
    TimeOut:=0;
    FData:=Socket(AF_INET, SOCK_STREAM, 0);
   end;

 while not Terminated do
  begin
   InitSockets;
   if FPort>=FPEnd
   then break;
  end;

 for i:=0 to MAX_PORTS-1 do
  CloseSocket(FSocket[i].FData);

 if not Terminated
 then
  begin
   SThread:=nil;
  end;
end;

end.
