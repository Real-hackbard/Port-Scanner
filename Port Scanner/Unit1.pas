
unit Unit1;

interface

uses
  Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, WinSock, AppEvnts,
  Vcl.Buttons, Vcl.ComCtrls, ActiveX, ComObj, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Samples.Spin, Vcl.Menus, Vcl.ClipBrd, IdBaseComponent, IdComponent,
  IdUDPBase, IdUDPClient;

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
    Label12: TLabel;
    SpinEdit6: TSpinEdit;
    ComboBox2: TComboBox;
    Label13: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Remove1: TMenuItem;
    N2: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ApplicationEvents1Message(var Msg: tagMSG;
      var Handled: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ListBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
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
  private
    { Private declarations }
    flbHorzScrollWidth: Integer;
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

implementation

{$R *.dfm}

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
  Form1.ListBox1.Items.Add('');

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


  BufferSize := Form1.SpinEdit6.Value;

  for i := 0 to Retries-1 do
  begin
    FWbemObjectSet:= FWMIService.ExecQuery(Format('SELECT * FROM Win32_PingStatus where Address=%s AND BufferSize=%d',[QuotedStr(Address),BufferSize]),'WQL',0);
    oEnum         := IUnknown(FWbemObjectSet._NewEnum) as IEnumVariant;
    if oEnum.Next(1, FWbemObject, iValue) = 0 then
    begin
      if FWbemObject.StatusCode=0 then
      begin
        if FWbemObject.ResponseTime>0 then
        Form1.ListBox1.Items.Add(Format('Reply from %s | bytes=%s time=%sms TTL=%s',
                                        [FWbemObject.
                                        ProtocolAddress,
                                        FWbemObject.ReplySize,
                                        FWbemObject.ResponseTime,
                                        FWbemObject.TimeToLive]))
        else
        Form1.ListBox1.Items.Add(Format('Reply from %s | bytes=%s time=<1ms TTL=%s',
                                        [FWbemObject.ProtocolAddress,
                                        FWbemObject.ReplySize,
                                        FWbemObject.TimeToLive]));

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
      Form1.ListBox1.Items.Add(Format('Reply from %s : %s',
          [FWbemObject.ProtocolAddress,GetStatusCodeStr(FWbemObject.StatusCode)]))
      else
      Form1.ListBox1.Items.Add(Format('Reply from %s : %s',
          [Address,'Error processing request']));
    end;
    FWbemObject:=Unassigned;
    FWbemObjectSet:=Unassigned;
  end;
  Form1.ListBox1.Items.Add('');
  Form1.ListBox1.Items.Add(Format('Ping statistics for %s : ',[Address]));
  Form1.ListBox1.Items.Add(Format('Packets: Sent = %d, Received = %d, Lost = %d (%d%% loss),',
                                  [Retries,
                                  PacketsReceived,
                                  Retries-PacketsReceived,
                                  Round((Retries-PacketsReceived)*100/Retries)]));

  if PacketsReceived>0 then
  begin
    Form1.ListBox1.Items.Add('Approximate round trip times in milli-seconds:');

    Form1.ListBox1.Items.Add(Format('Minimum = %dms, Maximum = %dms, Average = %dms',
                                    [Minimum,Maximum,Round(Average/PacketsReceived)]));
  end;
end;

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

procedure Ports();
var
  ret    : Integer;
  wsdata : WSAData;
  i : integer;
  s : string;
begin
  Screen.Cursor := crHourGlass;
  //Form1.ListBox1.Items.Add('Init WinSock');
  //initiates use of the Winsock
  ret := WSAStartup($0002, wsdata);
  if ret <> 0 then exit;
  try
    Form1.ListBox1.Items.Add('> Api         : '+wsData.szDescription);
    Form1.ListBox1.Items.Add('> Status      : '+wsData.szSystemStatus);

    if PortTCPIsOpen(Form1.SpinEdit3.Value,Form1.Edit1.Text) then
    begin
      Form1.ListBox1.Items.Add('> Result      : Port is Open');
    end else begin
      Form1.ListBox1.Items.Add('> Result      : Port is Closed');
    end;

    for i := 0 to Form1.Listbox2.Items.count-1 do
     if pos(IntToStr(Form1.SpinEdit3.Value), Form1.Listbox2.Items[i]) > 0 then
     begin
      Form1.Listbox2.Itemindex := i;
      s := Form1.ListBox2.Items[i];
      s := Copy(s, 7 ,length(s));
      Form1.ListBox1.Items.Add('> Description : ' + s);
      Exit;
     end;

  finally
    //terminates use of the Winsock
    WSACleanup;
    if s = '' then Form1.ListBox1.Items.Add('> Description : Unassigned or Reserved');
    Form1.ListBox1.Items.Add('ready.');
    Screen.Cursor := crDefault;
  end;
end;

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
var
  i : integer;
  s : string;
begin
 if (Msg.message>=FPStart+WM_USER) and (Msg.message<=FPEnd+WM_USER)
 then
 if WSAGETSELECTERROR(Msg.lParam)=0
 then
  case WSAGETSELECTEVENT(msg.lParam) of
   FD_CONNECT:
      begin

       for i := 0 to Form1.Listbox2.Items.count-1 do
        if pos(IntToStr(Msg.message - WM_USER), Form1.Listbox2.Items[i]) > 0 then
        begin
          Form1.Listbox2.Itemindex := i;
          s := Form1.ListBox2.Items[i];
          s := Copy(s, 7 ,length(s));
          Break;
       end;

       ListBox1.Items.Add(IntToStr(ListBox1.Count + 1)+
                        ') IP: '+inet_ntoa(FSocket[0].sa.sin_addr) +'  |  '+
                        'Port: '+intToStr(Msg.message - WM_USER) + ' | Open' +
                        ' | Description : ' + s);

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
  ListBox1.Items.Add('> Check Port  : ' + IntToStr(SpinEdit3.Value) + ' | ' + Edit1.Text);
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
        ShowMessage(E.Message);
  end;
end;

procedure TForm1.Clear1Click(Sender: TObject);
begin
  ListBox1.Clear;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  case ComboBox1.ItemIndex of
  0 : begin Label8.Caption := 'Network'; Edit1.Text := ComboBox1.Text; end;
  1 : begin Label8.Caption := 'Localhost'; Edit1.Text := ComboBox1.Text; end;
  2 : begin Label8.Caption := 'Gateway'; Edit1.Text := ComboBox1.Text; end;
  end;
end;

procedure TForm1.ComboBox2Change(Sender: TObject);
begin
  case ComboBox2.ItemIndex of
  0 : begin
        Label14.Enabled := false;
        Label15.Enabled := false;
        Label16.Enabled := false;
        Edit2.Enabled := false;
        Edit3.Enabled := false;
        Edit4.Enabled := false;
      end;

  1 : begin
        Label14.Enabled := true;
        Label15.Enabled := true;
        Label16.Enabled := true;
        Edit2.Enabled := true;
        Edit3.Enabled := true;
        Edit4.Enabled := true;
      end;
  end;
end;

procedure TForm1.Copy1Click(Sender: TObject);
var
  i: integer;
  sl: TStringList;
begin
  if ListBox1.SelCount = 0 then Exit;
  sl := TStringList.Create;
  for i := 0 to ListBox1.Items.Count - 1 do
    if ListBox1.Selected[i] then
      sl.Add(ListBox1.Items[i]);
  ClipBoard.AsText := sl.Text;
  sl.Free;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SelectedItems.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
 i: integer;
 s : string;
 IPs: TStrings;
begin
   if WSAStartup(MAKEWORD(2, 0), FInfo) <> 0 then Halt;
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
  Edit2.Text := GetComputerName;
  StatusBar1.Panels[4].Text := IntToStr(ListBox2.Items.Count);
  Application.OnMessage:=Form1.ApplicationEvents1Message;
  Listbox1.Perform(LB_SetHorizontalExtent, 1000, Longint(0));
  Listbox2.Perform(LB_SetHorizontalExtent, 1000, Longint(0));
  ListBox2.MultiSelect       := true;
  ListBox2.ExtendedSelect := true;
  SelectedItems := TStringList.Create;

  Application.ProcessMessages;
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

procedure TForm1.ListBox1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
 Len: Integer;
 NewText: String;
begin
  NewText:=Listbox1.Items[Index];

  with Listbox1.Canvas do
  begin
    FillRect(Rect);
    TextOut(Rect.Left + 1, Rect.Top, NewText);
    Len:=TextWidth(NewText) + Rect.Left + 10;
    if Len>flbHorzScrollWidth then
    begin
      flbHorzScrollWidth:=Len;
      Listbox1.Perform(LB_SETHORIZONTALEXTENT, flbHorzScrollWidth, 0 );
    end;
  end;
end;

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


procedure TForm1.ListBox2DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept := Source = ListBox2;
end;

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

procedure TForm1.Remove1Click(Sender: TObject);
var
  i: integer;
begin
  for i := ListBox2.Items.Count - 1 downto 0 do
    if ListBox2.Selected[i] then
      ListBox2.Items.Delete(i);
      StatusBar1.Panels[4].Text := IntToStr(ListBox2.Items.Count);
end;

procedure TForm1.RemoveDuplicates1Click(Sender: TObject);
var
  n, i, r, m : integer;
begin
  m := ListBox2.Items.Count;
  n := 0;
  try
    while n <= ListBox2.Items.count - 2 do
    begin
      for i := n + 1 to ListBox2.Items.count - 1 do
      begin
      if ListBox2.Items[n] = ListBox2.Items[i] then
        begin
            dec(n);
            ListBox2.Items.delete(i);
            break;
        end;
        inc(n);
      end;
    end;
  finally
    StatusBar1.Panels[4].Text := IntToStr(ListBox2.Items.Count);
    r := m - ListBox2.Items.Count;
    Beep;
    ShowMessage(IntToStr(r) + ' duplicates removed from list');
  end;
  Screen.Cursor := crDefault;
end;

procedure TForm1.Save1Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
  ListBox1.Items.SaveToFile(SaveDialog1.FileName + '.txt');
end;

procedure TForm1.Save2Click(Sender: TObject);
begin
  Beep;
  if MessageBox(Handle,'This will overwrite the existing port list; are you sure?','Confirm',
                MB_YESNO) = IDYES then
    BEGIN
      ListBox2.Items.SaveToFile(ExtractFilePath(Application.ExeName) + 'Ports\ports.lst');
    END;
end;

procedure TForm1.Search1Click(Sender: TObject);
var
  str, s : string;
  i : integer;
begin
  str := InputBox('Port Search','Type Port','80');

  for i := 0 to Listbox2.Items.count-1 do

   if pos(str, Listbox2.Items[i]) > 0 then
   begin
    Listbox2.Itemindex := i;
    Exit;
  end;

  Beep;
  ShowMessage('Port not found!');
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
