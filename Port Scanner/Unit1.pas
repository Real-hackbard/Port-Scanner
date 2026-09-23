{$WARN UNSAFE_TYPE off}
{$WARN UNSAFE_CAST off}
{$WARN UNSAFE_CODE off}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN SYMBOL_LIBRARY OFF}
{$WARN SYMBOL_DEPRECATED OFF}
// must turn off range checking or various records declared array [0..0] die !!!!!
{$R-}
{$Q-}

unit Unit1;

interface

uses
  Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, WinApi.WinSock,
  Vcl.AppEvnts, Vcl.Buttons, Vcl.ComCtrls, WinApi.ActiveX, System.Win.ComObj,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Samples.Spin, Vcl.Menus, Vcl.ClipBrd,
  System.ImageList, Vcl.ImgList;

type
  TForm1 = class(TForm)
    StatusBar1: TStatusBar;
    ProgressBar1: TProgressBar;
    PopupMenu1: TPopupMenu;
    Clear1: TMenuItem;
    Copy1: TMenuItem;
    Save1: TMenuItem;
    SaveDialog1: TSaveDialog;
    PopupMenu2: TPopupMenu;
    Search1: TMenuItem;
    Save2: TMenuItem;
    RemoveDuplicates1: TMenuItem;
    N1: TMenuItem;
    Remove1: TMenuItem;
    N2: TMenuItem;
    Timer1: TTimer;
    Panel2: TPanel;
    ComboBox1: TComboBox;
    Label7: TLabel;
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ListBox2: TListBox;
    HeaderControl1: THeaderControl;
    TabSheet3: TTabSheet;
    Memo1: TMemo;
    Panel3: TPanel;
    Button4: TButton;
    ComboBox3: TComboBox;
    Panel4: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label8: TLabel;
    Bevel1: TBevel;
    Label9: TLabel;
    Bevel2: TBevel;
    Label10: TLabel;
    Label11: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Edit1: TEdit;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    Button1: TButton;
    Button2: TButton;
    SpinEdit3: TSpinEdit;
    Button3: TButton;
    SpinEdit4: TSpinEdit;
    SpinEdit5: TSpinEdit;
    ComboBox2: TComboBox;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    ListView1: TListView;
    ImageList1: TImageList;
    Edit5: TEdit;
    Label6: TLabel;
    N3: TMenuItem;
    N4: TMenuItem;
    Grid1: TMenuItem;
    Button5: TButton;
    Timer2: TTimer;
    Label12: TLabel;
    ScrollBar1: TScrollBar;
    Label17: TLabel;
    Label18: TLabel;
    Button6: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ApplicationEvents1Message(var Msg: tagMSG;
      var Handled: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ListBox2DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure Clear1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Search1Click(Sender: TObject);
    procedure Save2Click(Sender: TObject);
    procedure RemoveDuplicates1Click(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure Remove1Click(Sender: TObject);
    procedure ListBox2DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListBox2DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Timer1Timer(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit5KeyPress(Sender: TObject; var Key: Char);
    procedure Grid1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
    flbHorzScrollWidth: Integer;
    procedure CaptureConsoleOutput(const ACommand, AParameters: String; AMemo: TMemo);
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
  SelectedItems: TStrings;
  TheTime: Integer;

implementation

{$R *.dfm}
// Time measurement does not exist in Delphi's core runtime library (RTL).
function GetCounter(Second: Integer): string;
var
  Minute, NewSecond, Hour: Currency;
begin
  Hour       := Int(Second / 3600);
  Minute     := Int((Second - (Hour * 3600)) / 60);
  NewSecond  := Second - int(Hour * 3600 + Minute * 60);
  GetCounter := CurrToStr(Hour) + ':' + CurrToStr(Minute) + ':' + CurrToStr(NewSecond);
end;

// save port repot to textfile
procedure SaveListViewToFile(AListView: TListView; const AFileName: string);
var
  Lines: TStringList;
  Item: TListItem;
  RowText: string;
  I: Integer;
begin
  Lines := TStringList.Create;
  try
    for I := 0 to AListView.Items.Count - 1 do
    begin
      Item := AListView.Items[I];
      // Start the row string with the main column text (Caption)
      RowText := Item.Caption;
      // Append the sub-items (remaining columns) separated by tabs
      if Item.SubItems.Count > 0 then
        RowText := RowText + #9 + Item.SubItems.CommaText;
        // Note: Use Item.SubItems.ToString or a loop if CommaText introduces unwanted quotes.
        // Alternative precise tab loop:
        // for J := 0 to Item.SubItems.Count - 1 do RowText := RowText + #9 + Item.SubItems[J];
      Lines.Add(RowText);
    end;
    // Save with UTF8 to preserve special characters and Unicode
    Lines.SaveToFile(AFileName, TEncoding.UTF8);
  finally
    Lines.Free;
  end;
end;

// capture console output from a CLI application or DOS command
procedure TForm1.CaptureConsoleOutput(const ACommand, AParameters: String; AMemo: TMemo);
 const
   CReadBuffer = 2400;
 var
   saSecurity: TSecurityAttributes;
   hRead: THandle;
   hWrite: THandle;
   suiStartup: TStartupInfo;
   piProcess: TProcessInformation;
   pBuffer: array[0..CReadBuffer] of AnsiChar;
   dRead: DWord;
   dRunning: DWord;
 begin
   saSecurity.nLength := SizeOf(TSecurityAttributes);
   saSecurity.bInheritHandle := True;
   saSecurity.lpSecurityDescriptor := nil;

   if CreatePipe(hRead, hWrite, @saSecurity, 0) then
   begin
     FillChar(suiStartup, SizeOf(TStartupInfo), #0);
     suiStartup.cb := SizeOf(TStartupInfo);
     suiStartup.hStdInput := hRead;
     suiStartup.hStdOutput := hWrite;
     suiStartup.hStdError := hWrite;
     suiStartup.dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
     suiStartup.wShowWindow := SW_HIDE;

     if CreateProcess(nil, PChar(ACommand + ' ' + AParameters), @saSecurity,
       @saSecurity, True, NORMAL_PRIORITY_CLASS, nil, nil, suiStartup, piProcess)
       then
     begin
       repeat
         dRunning := WaitForSingleObject(piProcess.hProcess, 100);
         Application.ProcessMessages();
         repeat
           dRead := 0;
           ReadFile(hRead, pBuffer[0], CReadBuffer, dRead, nil);
           pBuffer[dRead] := #0;

           OemToAnsi(pBuffer, pBuffer);
           AMemo.Lines.Add(String(pBuffer));
           //Sleep(150);
         until (dRead < CReadBuffer);
       until

       {  When capturing console output in Delphi using Windows API
          pipes (CreateProcess, ReadFile), a common pitfall occurs when
          evaluating..
          WaitForSingleObject(ProcessInfo.hProcess, Timeout) = WAIT_TIMEOUT }

       //(dRunning <> WAIT_TIMEOUT);

       {  When capturing console output in Delphi via asynchronous Windows
          pipes (overlapped I/O), the return value
          WAIT_IO_COMPLETION (or wrIOCompletion in Delphi wrappers) signals
          that a wait state was interrupted because the system executed
          an I/O completion routine. }

       (dRunning <> WAIT_IO_COMPLETION);


       CloseHandle(piProcess.hProcess);
       CloseHandle(piProcess.hThread);
     end;
     CloseHandle(hRead);
     CloseHandle(hWrite);
   end;
end;

// copy port list to clipboard
procedure ListBoxToClipboard(ListBox: TListBox;
  BufferSize: Integer;
  CopyAll: Boolean);
var
  Buffer: PChar;
  Size: Integer;
  Ptr: PChar;
  I: Integer;
  Line: string[255];
  Count: Integer;
begin
  if not Assigned(ListBox) then
    Exit;

  GetMem(Buffer, BufferSize);
  Ptr   := Buffer;
  Count := 0;
  for I := 0 to ListBox.Items.Count - 1 do
  begin
    Line := ListBox.Items.strings[I];
    if not CopyAll and ListBox.MultiSelect and (not ListBox.Selected[I]) then
      Continue;
    { Check buffer overflow }
    Count := Count + Length(Line) + 3;
    if Count = BufferSize then
      Break;
    { Append to buffer }
    Move(Line[1], Ptr^, Length(Line));
    Ptr    := Ptr + Length(Line);
    Ptr[0] := #13;
    Ptr[1] := #10;
    Ptr    := Ptr + 2;
  end;
  Ptr[0] := #0;
  ClipBoard.SetTextBuf(Buffer);
  FreeMem(Buffer, BufferSize);
end;

// ping status message codes
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

// ----------------------------------------------- Ping ---------}
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

  item : TListItem;
begin;
  PacketsReceived:=0;
  Minimum        :=0;
  Maximum        :=0;
  Average        :=0;

  // To establish a connection to Windows Management Instrumentation (WMI)
  // via the integrated COM/OLE interface
  FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');

      case Form1.ComboBox2.ItemIndex of
        0 : FWMIService   := FSWbemLocator.ConnectServer('localhost',
                                                         'root\CIMV2',
                                                         '', '');
        1 : FWMIService   := FSWbemLocator.ConnectServer(Form1.Edit3.Text,   // server
                                                         'root\CIMV2',
                                                         Form1.Edit2.Text,   // user
                                                         Form1.Edit4.Text);  // password
      end;


    // add entries to lIstView
    item := Form1.ListView1.Items.Add;
    item.ImageIndex := 3;
    item.Caption := (Format('Pinging %s with %d bytes of data:',[Address,BufferSize]));

    for i := 0 to Retries-1 do
    begin
      try
      FWbemObjectSet:= FWMIService.ExecQuery(Format('SELECT * FROM Win32_PingStatus where Address=%s AND BufferSize=%d',
                                                    [QuotedStr(Address),BufferSize]),
                                                    'WQL',
                                                    0);
      // retrieves the enumerator for a WMI object set to iterate over the individual results
      oEnum  := IUnknown(FWbemObjectSet._NewEnum) as IEnumVariant;

      if oEnum.Next(1, FWbemObject, iValue) = 0 then
      begin
        if FWbemObject.StatusCode=0 then
        begin
        item := Form1.ListView1.Items.Add;

          //  round-trip network ping response time in milliseconds
          if FWbemObject.ResponseTime > 0 then
          begin
          item.ImageIndex := 4;
          item.Caption :=(Format('Reply from %s | Bytes = %s Time = %sms TTL= %s',
                                          [FWbemObject.ProtocolAddress,
                                           FWbemObject.ReplySize,
                                           FWbemObject.ResponseTime,
                                           FWbemObject.TimeToLive]));
          end else begin
          item.ImageIndex := 5;
          item.Caption :=(Format('Reply from %s | Bytes = %s Time =< 1ms TTL = %s',
                                          [FWbemObject.ProtocolAddress,
                                          FWbemObject.ReplySize,
                                          FWbemObject.TimeToLive]));
          end;

          Inc(PacketsReceived);

          // check the response time
          if FWbemObject.ResponseTime > Maximum then
            Maximum := FWbemObject.ResponseTime;

          if Minimum=0 then Minimum := Maximum;

          if FWbemObject.ResponseTime < Minimum then
            Minimum := FWbemObject.ResponseTime;

          Average:=Average+FWbemObject.ResponseTime;
        end
        else

        // Check whether the StatusCode property of the WMI object (FWbemObject)
        // is unset or empty.
        if not VarIsNull(FWbemObject.StatusCode) then
        begin
          item := Form1.ListView1.Items.Add;
          item.ImageIndex := 4;
          item.Caption :=(Format('Reply from %s : %s',
            [FWbemObject.ProtocolAddress,GetStatusCodeStr(FWbemObject.StatusCode)]));
        end else begin
          item.ImageIndex := 5;
          item.Caption :=(Format('Reply from %s : %s',
            [Address,'Error processing request']));
        end;
      end;
      FWbemObject:=Unassigned;
      FWbemObjectSet:=Unassigned;
      finally

      end;
    end;

    item := Form1.ListView1.Items.Add;
    item.ImageIndex := 3;
    item.Caption := (Format('Ping statistics for %s : ',[Address]));
    item := Form1.ListView1.Items.Add;
    item.ImageIndex := 3;
    item.Caption := (Format('Packets: Sent = %d, Received = %d, Lost = %d (%d%% loss),',
                                    [Retries,
                                    PacketsReceived,
                                    Retries-PacketsReceived,
                                    Round((Retries-PacketsReceived)*100/Retries)]));

    if PacketsReceived>0 then
    begin
      item := Form1.ListView1.Items.Add;
      item.ImageIndex := 6;
      item.Caption := ('Approximate round trip times in milli-seconds:');
      item := Form1.ListView1.Items.Add;
      item.ImageIndex := 6;
      item.Caption := (Format('Minimum = %dms, Maximum = %dms, Average = %dms',
                      [Minimum,Maximum,Round(Average/PacketsReceived)]));
    end;


    with Form1.ListView1 do
      begin
        if Items.Count > 0 Then
          Items [Items.Count-1].MakeVisible (True);
      end;

  Form1.Button1.Enabled := true;
  Form1.Button2.Enabled := true;
  Screen.Cursor := crDefault;
end;

// check is port open
function PortTCPIsOpen(dwPort : Word; ipAddressStr:string) : boolean;
var
  // sockaddr_in is used by Windows Sockets to specify a local or remote endpoint address
  client : sockaddr_in;
  sock   : Integer;
begin
  // htons converts a u_short from host to TCP/IP network byte order.
  client.sin_family      := AF_INET;
  // port number
  client.sin_port        := htons(dwPort);
  // the inet_addr function converts a string containing an IPv4
  // dotted-decimal address into a proper address for the IN_ADDR structure.
  client.sin_addr.s_addr := inet_addr(PAnsiChar(AnsiString(ipAddressStr)));
  // The socket function creates a socket
  sock  := socket(AF_INET, SOCK_STREAM, 0);
  // establishes a connection to a specified socket.
  Result:=connect(sock,client,SizeOf(client))=0;
end;

// Checking individual ports for their status
procedure Ports();
var
  ret    : Integer;
  wsdata : WSAData;
  i : integer;
  s : string;

  item : TListItem;
begin
  Screen.Cursor := crHourGlass;

  ret := WSAStartup($0002, wsdata);
  if ret <> 0 then exit;
  try
    // ListView output
    item := Form1.ListView1.Items.Add;
    item.Caption := ('> Init WinSock');
    item := Form1.ListView1.Items.Add;
    item.Caption := '> Api         : ' + wsData.szDescription; // Winsock2 message
    item := Form1.ListView1.Items.Add;
    item.Caption := ('> Status      : '+wsData.szSystemStatus);

    item := Form1.ListView1.Items.Add;

    // Port (TCP) check
    if PortTCPIsOpen(Form1.SpinEdit3.Value,Form1.Edit1.Text) then
    begin
      item.ImageIndex := 0;
      item.Caption := ('> Result      : Port is Open');
    end else begin
      item.ImageIndex := 1;
      item.Caption := ('> Result      : Port is Closed');
    end;

    item := Form1.ListView1.Items.Add;

    // Copy the description from "port.lst" into the ListView.
    for i := 0 to Form1.Listbox2.Items.count-1 do
     if pos(IntToStr(Form1.SpinEdit3.Value), Form1.Listbox2.Items[i]) > 0 then
     begin
      Form1.Listbox2.Itemindex := i;
      s := Form1.ListBox2.Items[i];
      s := Copy(s, 7 ,length(s));
      item.Caption := ('> Description : ' + s);
      Exit;
     end;

  finally
    //terminates use of the Winsock
    WSACleanup;
    if s = '' then item.Caption := ('> Description : Unassigned or Reserved');
    item.ImageIndex := 3;
    item.Caption := ('ready.');

    // in case the entry is to be marked
    {
    with Form1.ListView1 Do
    begin
      if Items.Count > 0 Then
        Items [Items.Count-1].MakeVisible (True);
    end;
    }

    Screen.Cursor := crDefault;
  end;
end;

// IP address
function IP : string;
resourcestring
    cTxtIP = '%d.%d.%d.%d';
var
  rSockVer : WordRec;
  aWSAData : TWSAData;
  szHostName : array[0..255] of Char;
  pHE : PHostEnt;
  sIP : String;
begin
  rSockVer.Hi := 1;
  rSockVer.Lo := 1;
  WSAStartup(Word(rSockVer), aWSAData );
   try
    // initializes a memory area entirely with null bytes
     FillChar(szHostName, SizeOf(szHostName), #0);
     // Null-terminated character array (char array)
     GetHostName(@szHostName, SizeOf(szHostName));
     // Explicitly cast hostnames to AnsiString and pass them as PAnsiChar.
     pHE := GetHostByName(@szHostName);

     {  Method for converting an array of four bytes (an IPv4 address from
        the obsolete Winsock `hostent` structure) into a readable string. }
     if Assigned(pHE) then with pHE^ do
      sIP := Format(cTxtIP,[Byte(h_addr^[0]), Byte(h_addr^[1]),
                    Byte(h_addr^[2]), Byte(h_addr^[3])]);
   finally
   // end Winsock
   WSACleanup;
  end;
  Form1.ComboBox1.Items.Add(sIP);
end;

// Find out our name
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

// Intercepting Windows messages before they are processed by the application's main loop
procedure TForm1.ApplicationEvents1Message(var Msg: tagMSG;
  var Handled: Boolean);
var
  i : integer;
  s : string;
  item : TListItem;
begin
 if (Msg.message>=FPStart+WM_USER) and (Msg.message<=FPEnd+WM_USER)
 then
 // Retrieve the error code of an asynchronous socket operation.
 if WSAGETSELECTERROR(Msg.lParam)=0
 then
  // Low-order word of lParam in an asynchronous Windows socket message
  case WSAGETSELECTEVENT(msg.lParam) of
   FD_CONNECT:
      begin

      // whether a specific relative message offset exists in a text-based list or a string
       for i := 0 to Form1.Listbox2.Items.count-1 do
        if pos(IntToStr(Msg.message - WM_USER), Form1.Listbox2.Items[i]) > 0 then
        begin
          Form1.Listbox2.Itemindex := i;
          s := Form1.ListBox2.Items[i];
          s := Copy(s, 7 ,length(s));
          Break;
       end;

       // output message to ListView
       item := ListView1.Items.Add;
       item.Caption := ('IP: '+inet_ntoa(FSocket[0].sa.sin_addr) +'  |  '+
                        'Port: '+intToStr(Msg.message - WM_USER) + ' | Open' +
                        ' | Description : ' + s);

       Application.ProcessMessages;
      end;
  end;

  // in case the entry is to be marked
  {
  with Form1.ListView1 Do
    begin
      if Items.Count > 0 Then
        Items [Items.Count-1].MakeVisible (True);
    end;
   }
  Handled:=false;
end;

procedure enable;
begin
  Form1.Label1.Enabled := true;
  Form1.Label3.Enabled := true;
  Form1.Label4.Enabled := true;
  Form1.Label7.Enabled := true;
  Form1.Label8.Enabled := true;
  Form1.ComboBox1.Enabled := true;
  Form1.Edit1.Enabled := true;
  Form1.SpinEdit1.Enabled := true;
  Form1.SpinEdit2.Enabled := true;
  Form1.Button2.Enabled := true;
  Form1.Button3.Enabled := true;
  Form1.PageControl1.Enabled := true;
end;

procedure disable;
begin
  Form1.Label1.Enabled := false;
  Form1.Label3.Enabled := false;
  Form1.Label4.Enabled := false;
  Form1.Label7.Enabled := false;
  Form1.Label8.Enabled := false;
  Form1.ComboBox1.Enabled := false;
  Form1.Edit1.Enabled := false;
  Form1.SpinEdit1.Enabled := false;
  Form1.SpinEdit2.Enabled := false;
  Form1.Button2.Enabled := false;
  Form1.Button3.Enabled := false;
  Form1.PageControl1.Enabled := false;
end;

// start/stop portlist check thread
procedure TForm1.Button1Click(Sender: TObject);
begin
  if SThread = nil
 then
  begin
   SThread:=TMyThread.Create(false);
   Button1.Caption:='Stop';
   TheTime := GetTickCount;
   Timer2.Enabled := true;
   disable;
  end
 else
  begin
   SThread.Terminate;
   SThread.WaitFor;
   SThread := nil;
   Button1.Caption:='Start';
   Timer2.Enabled := false;
   StatusBar1.Panels[0].Text := 'Progress : finish.';
   enable;
  end;
  StatusBar1.SetFocus;
end;

// Check individual ports.
procedure TForm1.Button2Click(Sender: TObject);
var
  item : TListItem;
begin
  item := ListView1.Items.Add;
  item.ImageIndex := 2;
  item.Caption := ('> Check Port  : ' + IntToStr(SpinEdit3.Value) + ' | ' + Edit1.Text);
  Application.ProcessMessages;
  ports();
  StatusBar1.SetFocus;
end;

// start ping
procedure TForm1.Button3Click(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  Button1.Enabled := false;
  Button2.Enabled := false;
  try
    try
      PingHost(Edit5.Text, SpinEdit4.Value, SpinEdit5.Value);
    finally
    end;
  except
    on E:Exception do
    begin
        ShowMessage(E.Message);
        Button1.Enabled := true;
        Button2.Enabled := true;
        Screen.Cursor := crDefault;
    end;
  end;
  StatusBar1.SetFocus;
end;

// netstat measurement
procedure TForm1.Button4Click(Sender: TObject);
begin
  Memo1.Clear;

  case ComboBox3.ItemIndex of
    { Displays all active TCP connections and the TCP and UDP ports on
      which the computer is listening. }
    0 : CaptureConsoleOutput('cmd /c', 'netstat -an', Memo1);
    { Displays Ethernet statistics, such as the number of bytes and packets
      sent and received. This parameter can be combined with -s. }
    1 : CaptureConsoleOutput('cmd /c', 'netstat -e', Memo1);
    { Displays active TCP connections, however, addresses and port numbers
      are expressed numerically and no attempt is made to determine names. }
    2 : CaptureConsoleOutput('cmd /c', 'netstat -n', Memo1);
    { Displays active TCP connections and includes the process ID (PID) for
      each connection. You can find the application based on the PID on the
      Processes tab in Windows Task Manager. This parameter can be combined
      with -a, -n, and -p. }
    3 : CaptureConsoleOutput('cmd /c', 'netstat -o', Memo1);
    { Shows connections for the protocol specified by Protocol.
      In this case, the Protocol can be tcp, udp, tcpv6, or udpv6. If this
      parameter is used with -s to display statistics by protocol, Protocol
      can be tcp, udp, icmp, ip, tcpv6, udpv6, icmpv6, or ipv6. }
    4 : CaptureConsoleOutput('cmd /c', 'netstat -p tcp', Memo1);
    { Displays all connections, listening ports, and bound nonlistening
      TCP ports. Bound nonlistening ports may or may not be associated
      with an active connection. }
    5 : CaptureConsoleOutput('cmd /c', 'netstat -q', Memo1);
    { Displays statistics by protocol. By default, statistics are shown for
      the TCP, UDP, ICMP, and IP protocols. If the IPv6 protocol is
      installed, statistics are shown for the TCP over IPv6, UDP over
      IPv6, ICMPv6, and IPv6 protocols. The -p parameter can be used to
      specify a set of protocols. }
    6 : CaptureConsoleOutput('cmd /c', 'netstat -s', Memo1);
    { Displays the contents of the IP routing table. This is equivalent to
      the route print command. }
    7 : CaptureConsoleOutput('cmd /c', 'netstat -r', Memo1);
  end;

  // scroll memo box to top
  Memo1.Perform(EM_LineScroll, 0 , -Memo1.Lines.Count-1);
  StatusBar1.SetFocus;
end;

// netstat measurement
procedure TForm1.Button5Click(Sender: TObject);
begin
  if Button5.Caption = 'Start' then
  begin
    Button5.Caption := 'Stop';
    Timer1.Enabled := true;
  end else begin
    Button5.Caption := 'Start';
    Timer1.Enabled := false;
  end;
  StatusBar1.SetFocus;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  MessageDlg('Port Scanner v1.0.4' + chr(10) +
             'Copyright © hackbard' + chr(10) +
             'github.com | Release 2026' ,mtInformation, [mbOK], 0);
  StatusBar1.SetFocus;
end;

procedure TForm1.Clear1Click(Sender: TObject);
begin
  ListView1.Clear;
end;

// IP selection
procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  case ComboBox1.ItemIndex of
    0 : begin
          Label8.Caption := 'Network';
          Edit1.Text := ComboBox1.Text;
          Edit5.Text := ComboBox1.Text;
        end;
    1 : begin
          Label8.Caption := 'Localhost';
          Edit1.Text := ComboBox1.Text;
          Edit5.Text := ComboBox1.Text;
        end;
    2 : begin
          Label8.Caption := 'Gateway';
          Edit1.Text := ComboBox1.Text;
          Edit5.Text := ComboBox1.Text;
        end;
  end;
end;

procedure TForm1.ComboBox2Change(Sender: TObject);
begin
  case ComboBox2.ItemIndex of
  0 : begin
        Label14.Enabled := false;
        Label15.Enabled := false;
        Label16.Enabled := false;
        Label6.Enabled := true;
        Edit2.Enabled := false;
        Edit3.Enabled := false;
        Edit4.Enabled := false;
        Edit5.Enabled := true;
      end;

  1 : begin
        Label14.Enabled := true;
        Label15.Enabled := true;
        Label16.Enabled := true;
        Label6.Enabled := false;
        Edit2.Enabled := true;
        Edit3.Enabled := true;
        Edit4.Enabled := true;
        Edit5.Enabled := false;
      end;
  end;
end;

// Copies the selected ListView entry to clipboard
procedure TForm1.Copy1Click(Sender: TObject);
var
  item: TListItem;
  s : string;
begin
  if ListView1.Items.Count = 0 then
  begin
    MessageBox(Application.Handle,'There are no Port to copy.',
            PChar(Application.Title),MB_OK or MB_ICONINFORMATION or MB_SYSTEMMODAL);
    Exit;
  end;

  item := ListView1.Selected;

  if item <> nil then
  begin
   s := item.Caption;
   Clipboard.AsText := s;
  end;
end;

// Allows only numbers and a decimal point to be entered into the box.
procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  If not (Key in [#46, #48..#57, #8]) then
    Key := #0;
end;

// Allows only numbers and a decimal point to be entered into the box.
procedure TForm1.Edit5KeyPress(Sender: TObject; var Key: Char);
begin
  If not (Key in [#46, #48..#57, #8]) then
    Key := #0;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Free the StringList again.
  SelectedItems.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
 i: integer;
begin
  // flicker-free rendering of the ListView
  // All components are located on "Panel1".
  Panel1.DoubleBuffered := true;

  // Check the Winsock initialization.
  if WSAStartup(MAKEWORD(2, 0), FInfo) <> 0 then Halt;
  for i:=0 to MAX_PORTS-1 do
   with FSocket[i] do
    begin
     TimeOut := 0;
     {  To create a TCP socket for IPv4 communication using the Windows
        Sockets API (WinSock) }
     FData := Socket(AF_INET, SOCK_STREAM, 0);

     // Terminate Winsock on error
     if FData = SOCKET_ERROR
     then
      begin
       WSACleanup;
       Halt;
      end;
    end;

  // IP address tracing
  IP;

  // Reset the timer to zero.
  TheTime := GetTickCount;

  // Default IP addresses can be changed.
  ComboBox1.Items.Add('127.0.0.1');    // localhost
  ComboBox1.Items.Add('192.168.0.1');  // gateway
  ComboBox1.ItemIndex := 0;

  // "load portlist in ListBox"
  ListBox2.Items.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Ports\ports.lst');
  // get computer name
  StatusBar1.Panels[2].Text := GetComputerName;
  Edit2.Text := GetComputerName;
  // count port list entries
  StatusBar1.Panels[4].Text := IntToStr(ListBox2.Items.Count);
  // Ready to intercept processes
  Application.OnMessage:=Form1.ApplicationEvents1Message;
  // create horizontal scrollbar for "listBox" (1000px)
  Listbox2.Perform(LB_SetHorizontalExtent, 1000, Longint(0));

  ListBox2.MultiSelect := true;
  ListBox2.ExtendedSelect := true;

  // create memory access for Stringlist
  SelectedItems := TStringList.Create;
end;

// Securely terminate all processes
procedure TForm1.FormDestroy(Sender: TObject);
var
 i: integer;
begin
  Application.Terminate;

  // in case he still gets stuck in a thread
  if SThread <> nil then
   begin
    SThread.Terminate;
    SThread.WaitFor;
    SThread:=nil;
   end;

   // Release all port accesses free
   for i:=0 to MAX_PORTS-1 do
    CloseSocket(FSocket[i].FData);

   // end Winsock
   WSACleanup;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  // Update IP box
  ComboBox1.OnChange(sender);
  StatusBar1.SetFocus;
end;

procedure TForm1.Grid1Click(Sender: TObject);
begin
  ListView1.GridLines := Grid1.Checked;
end;

// Allow drag-and-drop of ListBox entries to edit the port list.
procedure TForm1.ListBox2DragDrop(Sender, Source: TObject; X, Y: Integer);
var
  ListBox: TListBox;
  i, TargetIndex: Integer;
  SelectedItems: TStringList;
begin
  Assert(Source=Sender);
  ListBox := Sender as TListBox;
  TargetIndex := ListBox.ItemAtPos(Point(X, Y), False);
  if TargetIndex<>-1 then
  begin
    SelectedItems := TStringList.Create;
    try
      ListBox.Items.BeginUpdate;
      try
        for i := ListBox.Items.Count-1 downto 0 do
        begin
          if ListBox.Selected[i] then
          begin
            SelectedItems.AddObject(ListBox.Items[i], ListBox.Items.Objects[i]);
            ListBox.Items.Delete(i);
            if i<TargetIndex then
              dec(TargetIndex);
          end;
        end;

        for i := SelectedItems.Count-1 downto 0 do
        begin
          ListBox.Items.InsertObject(TargetIndex, SelectedItems[i], SelectedItems.Objects[i]);
          ListBox.Selected[TargetIndex] := True;
          inc(TargetIndex);
        end;
      finally
        ListBox.Items.EndUpdate;
      end;
    finally
      SelectedItems.Free;
    end;
  end;
end;

// accept drag % drop ListBox items
procedure TForm1.ListBox2DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept := Source = ListBox2;
end;

// Draw a custom ListBox with scrollbar horizontal
procedure TForm1.ListBox2DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
 Len: Integer;
 NewText: String;
begin
  NewText:=Listbox2.Items[Index];

  with Listbox2.Canvas do
  begin
    FillRect(Rect);
    TextOut(Rect.Left + 1, Rect.Top, NewText);
    Len:=TextWidth(NewText) + Rect.Left + 10;
    if Len>flbHorzScrollWidth then
    begin
      flbHorzScrollWidth:=Len;
      Listbox2.Perform(LB_SETHORIZONTALEXTENT, flbHorzScrollWidth, 0 );
    end;
  end;
end;

procedure TForm1.PageControl1Change(Sender: TObject);
begin
  if PageControl1.ActivePage = TabSheet1 then
  Begin
    Button1.Enabled := true;
    Button2.Enabled := true;
    Button3.Enabled := true;
  end else begin
    Button1.Enabled := false;
    Button2.Enabled := false;
    Button3.Enabled := false;
  end;

  // disable Monitoring when tab is changed
  if PageControl1.ActivePage <> TabSheet3 then
  begin
    Timer1.Enabled := false;
    Button5.Caption := 'Start';
  end;
end;

// Remove one or more entries from the port list.
procedure TForm1.Remove1Click(Sender: TObject);
var
  i: integer;
begin
  for i := ListBox2.Items.Count - 1 downto 0 do
    if ListBox2.Selected[i] then
      ListBox2.Items.Delete(i);
      StatusBar1.Panels[4].Text := IntToStr(ListBox2.Items.Count);
end;

// Remove duplicate entries from the port list box.
procedure TForm1.RemoveDuplicates1Click(Sender: TObject);
var
  n, i, r, m : integer;
begin
  m := ListBox2.Items.Count; // count items
  n := 0;
  try
    // Proceed step by step.
    while n <= ListBox2.Items.count - 2 do
    begin
      for i := n + 1 to ListBox2.Items.count - 1 do
      begin
      // compare entries
      if ListBox2.Items[n] = ListBox2.Items[i] then
        begin
            dec(n);
            // delete founded duplicate item
            ListBox2.Items.delete(i);
            break;
        end;
        inc(n);
      end;
    end;
  finally
    StatusBar1.Panels[4].Text := IntToStr(ListBox2.Items.Count);
    // Subtract the removed entries from the count.
    r := m - ListBox2.Items.Count;
    // give a message
    Beep;
    ShowMessage(IntToStr(r) + ' duplicates removed from list');
  end;
  Screen.Cursor := crDefault;
end;

// save port report to textfile
procedure TForm1.Save1Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
    SaveListViewToFile(ListView1, SaveDialog1.FileName + '.txt');
end;

// save or overwrite portlist to file
procedure TForm1.Save2Click(Sender: TObject);
begin
  Beep;
  if MessageBox(Handle,'This will overwrite the existing port list; are you sure?','Confirm',
                MB_YESNO) = IDYES then
    BEGIN
      ListBox2.Items.SaveToFile(ExtractFilePath(Application.ExeName) + 'Ports\ports.lst');
    END;
end;

// Speed measurement
procedure TForm1.ScrollBar1Change(Sender: TObject);
begin
  Timer1.Interval := ScrollBar1.Position;
  Label18.Caption := IntToStr(ScrollBar1.Position div 1000) + ' sec';
end;

// looking for a specific port in the port list
procedure TForm1.Search1Click(Sender: TObject);
var
  str, s : string;
  i : integer;
begin
  // execute InputBox
  str := InputBox('Port Search','Type Port','80');

  for i := 0 to Listbox2.Items.count-1 do
   // if port found
   if pos(str, Listbox2.Items[i]) > 0 then
   begin
    // show index
    Listbox2.Itemindex := i;
    Exit;
   end;

  // if nothing was found
  Beep;
  ShowMessage('Port not found!');
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Memo1.Clear;

  case ComboBox3.ItemIndex of
    { Displays all active TCP connections and the TCP and UDP ports on
      which the computer is listening. }
    0 : CaptureConsoleOutput('cmd /c', 'netstat -an', Memo1);
    { Displays Ethernet statistics, such as the number of bytes and packets
      sent and received. This parameter can be combined with -s. }
    1 : CaptureConsoleOutput('cmd /c', 'netstat -e', Memo1);
    { Displays active TCP connections, however, addresses and port numbers
      are expressed numerically and no attempt is made to determine names. }
    2 : CaptureConsoleOutput('cmd /c', 'netstat -n', Memo1);
    { Displays active TCP connections and includes the process ID (PID) for
      each connection. You can find the application based on the PID on the
      Processes tab in Windows Task Manager. This parameter can be combined
      with -a, -n, and -p. }
    3 : CaptureConsoleOutput('cmd /c', 'netstat -o', Memo1);
    { Shows connections for the protocol specified by Protocol.
      In this case, the Protocol can be tcp, udp, tcpv6, or udpv6. If this
      parameter is used with -s to display statistics by protocol, Protocol
      can be tcp, udp, icmp, ip, tcpv6, udpv6, icmpv6, or ipv6. }
    4 : CaptureConsoleOutput('cmd /c', 'netstat -p tcp', Memo1);
    { Displays all connections, listening ports, and bound nonlistening
      TCP ports. Bound nonlistening ports may or may not be associated
      with an active connection. }
    5 : CaptureConsoleOutput('cmd /c', 'netstat -q', Memo1);
    { Displays statistics by protocol. By default, statistics are shown for
      the TCP, UDP, ICMP, and IP protocols. If the IPv6 protocol is
      installed, statistics are shown for the TCP over IPv6, UDP over
      IPv6, ICMPv6, and IPv6 protocols. The -p parameter can be used to
      specify a set of protocols. }
    6 : CaptureConsoleOutput('cmd /c', 'netstat -s', Memo1);
    { Displays the contents of the IP routing table. This is equivalent to
      the route print command. }
    7 : CaptureConsoleOutput('cmd /c', 'netstat -r', Memo1);
  end;

  // scroll memo box to top
  Memo1.Perform(EM_LineScroll, 0 , -Memo1.Lines.Count-1);
end;

// Show the system time and the port search timing.
procedure TForm1.Timer2Timer(Sender: TObject);
begin
  StatusBar1.Panels[6].Text := GetCounter(GetTickCount div 1000 - TheTime div 1000) +
                               ' - ' + TimeToStr(Now);
end;

{ To manually initialize the Windows Sockets API (Winsock) if the network
  library being used has not already done so automatically at program startup. }
procedure InitSockets;
var
 i: integer;
begin
 for i:=0 to MAX_PORTS-1 do
  // Array list of socket connections
  with FSocket[i] do
   // when all ports have been checked or the thread has been manually terminated..
   if (FPort>=FPEnd) or (SThread.Terminated)
    then break   // ..then go out or..
   else
   // ..Continue with ping.

    // Consideration of overflow protection for timeout
    if GetTickCount-TimeOut>PING
    then
     begin
      // To set the network protocol to IPv4
      sa.sin_family := AF_INET;
      // assigning a string IP address or a host object directly to "S_addr"
      sa.sin_addr.S_addr := FHost;
      // To initialize a port for a network connection (via sockets)
      sa.sin_port := htons(FPort);
      { ensures that Windows sends a message to the application window as
        soon as a connection has been established, instead of the thread
        blocking and waiting for the connection. }
      WSAAsyncSelect(FData, Application.Handle, WM_USER+FPort, FD_CONNECT);
      // connection using the classic Windows Sockets API
      Connect(FData, FSocket[i].sa, SizeOf(FSocket[i].sa));
      // set to zero
      TimeOut:=GetTickCount;
      // Increases the value of the integer variable FPort by exactly 1.
      inc(FPort);
      // count founded ports
      Form1.Label2.Caption:='Port: '+intToStr(FPort);
      // get progress
      Form1.ProgressBar1.Position :=trunc(((FPort-FPStart)*100)/(FPEnd-FPStart));
      // display search progress
      Form1.StatusBar1.Panels[0].Text := 'Progress : ' + IntToStr(Form1.ProgressBar1.Position) + ' %';
      Application.ProcessMessages;
      // Delaying the current thread
      Sleep(PING div MAX_PORTS);
     end;
end;

// execution of the thread
procedure TMyThread.Execute;
var
 i: integer;
 buf: in_addr;
begin
  // start port
  FPStart := Form1.SpinEdit1.Value;
  // end port
  FPEnd := Form1.SpinEdit2.Value;
  // expects a null-terminated string (a PAnsiChar) containing an IPv4 address in dotted notation
  FHost := inet_addr(PAnsiChar(AnsiString(Form1.Edit1.Text)));

  // Check how far the program has processed the port.
  if (FPEnd<=FPStart)or (Form1.SpinEdit1.Value>65535) or
                            (Form1.SpinEdit2.Value>65535)
    then FHost:=SOCKET_ERROR; // Socket operation failed (-1)

  // Terminate thread if socket operation failed (-1)
  if FHost=SOCKET_ERROR then
  begin
   if not Terminated
    then SThread:=nil;
   Form1.Button1.Caption:='Start';
   Exit;
  end;

  // expects a 32-bit numeric code
  buf.S_addr := FHost;
  // converting a network-byte-order IPv4 address into a dotted-decimal string
  Form1.Edit1.Text := inet_ntoa(buf);
  Form1.ListView1.Clear;
  // Go to the start port.
  FPort := FPStart;

  { initializes a connection-oriented IPv4 TCP socket using the native
    Windows Socket API (Winsock) }
  for i := 0 to MAX_PORTS-1 do
  with FSocket[i] do
   begin
    TimeOut:=0;
    FData := Socket(AF_INET, SOCK_STREAM, 0);
   end;

  // if not, abort
  while not Terminated do
  begin
   InitSockets;
   if FPort>=FPEnd
   then break;
  end;

  // properly close the open socket connection and release the allocated system resources
 for i:=0 to MAX_PORTS-1 do
  CloseSocket(FSocket[i].FData);

  // End thread
 if not Terminated
 then
  begin
   SThread := nil;
  end;
end;

end.
