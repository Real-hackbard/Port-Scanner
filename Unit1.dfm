object Form1: TForm1
  Left = 561
  Top = 207
  ActiveControl = SpinEdit1
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Port Scanner'
  ClientHeight = 576
  ClientWidth = 577
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 161
    Height = 540
    Align = alLeft
    BevelOuter = bvNone
    BiDiMode = bdLeftToRight
    Ctl3D = False
    ParentBiDiMode = False
    ParentCtl3D = False
    TabOrder = 0
    TabStop = True
    object Label1: TLabel
      Left = 8
      Top = 120
      Width = 33
      Height = 13
      Caption = 'Hosts :'
    end
    object Label2: TLabel
      Left = 89
      Top = 209
      Width = 6
      Height = 13
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 13
      Top = 146
      Width = 28
      Height = 13
      Caption = 'Start :'
    end
    object Label4: TLabel
      Left = 16
      Top = 173
      Width = 25
      Height = 13
      Caption = 'End :'
    end
    object Label5: TLabel
      Left = 9
      Top = 209
      Width = 71
      Height = 13
      Caption = 'Port Scanned :'
    end
    object Label6: TLabel
      Left = 9
      Top = 8
      Width = 113
      Height = 26
      Caption = 'Port Scanner'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Impact'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 25
      Top = 59
      Width = 16
      Height = 13
      Caption = 'IP :'
    end
    object Label8: TLabel
      Left = 44
      Top = 99
      Width = 40
      Height = 13
      Caption = 'Network'
    end
    object Bevel1: TBevel
      Left = 5
      Top = 292
      Width = 153
      Height = 2
    end
    object Label9: TLabel
      Left = 16
      Top = 317
      Width = 25
      Height = 13
      Caption = 'Port :'
    end
    object Bevel2: TBevel
      Left = 5
      Top = 404
      Width = 153
      Height = 2
    end
    object Label10: TLabel
      Left = 7
      Top = 423
      Width = 34
      Height = 13
      Caption = 'Count :'
    end
    object Label11: TLabel
      Left = 15
      Top = 450
      Width = 26
      Height = 13
      Caption = 'Size :'
    end
    object Edit1: TEdit
      Left = 44
      Top = 118
      Width = 89
      Height = 19
      TabStop = False
      TabOrder = 0
    end
    object SpinEdit1: TSpinEdit
      Left = 44
      Top = 143
      Width = 89
      Height = 22
      TabStop = False
      Ctl3D = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      MaxLength = 5
      MaxValue = 65535
      MinValue = 1
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 1
      Value = 1
    end
    object SpinEdit2: TSpinEdit
      Left = 44
      Top = 170
      Width = 89
      Height = 22
      TabStop = False
      Ctl3D = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      MaxLength = 5
      MaxValue = 65535
      MinValue = 1
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 2
      Value = 65535
    end
    object Button1: TButton
      Left = 83
      Top = 246
      Width = 72
      Height = 25
      Caption = 'start'
      TabOrder = 3
      TabStop = False
      OnClick = Button1Click
    end
    object ComboBox1: TComboBox
      Left = 44
      Top = 56
      Width = 111
      Height = 21
      Style = csDropDownList
      TabOrder = 4
      OnChange = ComboBox1Change
    end
    object Button2: TButton
      Left = 83
      Top = 357
      Width = 72
      Height = 25
      Caption = 'Check'
      TabOrder = 5
      TabStop = False
      OnClick = Button2Click
    end
    object SpinEdit3: TSpinEdit
      Left = 44
      Top = 314
      Width = 89
      Height = 22
      Ctl3D = True
      MaxValue = 65535
      MinValue = 1
      ParentCtl3D = False
      TabOrder = 6
      Value = 80
    end
    object Button3: TButton
      Left = 83
      Top = 490
      Width = 72
      Height = 25
      Caption = 'Ping'
      TabOrder = 7
      TabStop = False
      OnClick = Button3Click
    end
    object SpinEdit4: TSpinEdit
      Left = 44
      Top = 420
      Width = 89
      Height = 22
      TabStop = False
      Ctl3D = True
      MaxValue = 1000
      MinValue = 1
      ParentCtl3D = False
      TabOrder = 8
      Value = 8
    end
    object SpinEdit5: TSpinEdit
      Left = 44
      Top = 448
      Width = 89
      Height = 22
      TabStop = False
      Ctl3D = True
      MaxValue = 8192
      MinValue = 32
      ParentCtl3D = False
      TabOrder = 9
      Value = 32
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 557
    Width = 577
    Height = 19
    Panels = <
      item
        Text = 'Progress : 0 %'
        Width = 300
      end
      item
        Text = 'User :'
        Width = 40
      end
      item
        Width = 50
      end>
    ExplicitTop = 556
    ExplicitWidth = 573
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 540
    Width = 577
    Height = 17
    Align = alBottom
    TabOrder = 2
    ExplicitTop = 539
    ExplicitWidth = 573
  end
  object PageControl1: TPageControl
    Left = 161
    Top = 0
    Width = 416
    Height = 540
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 3
    TabStop = False
    ExplicitLeft = 177
    ExplicitWidth = 396
    ExplicitHeight = 539
    object TabSheet1: TTabSheet
      Caption = 'Scanner'
      object ListBox1: TListBox
        Left = 0
        Top = 0
        Width = 408
        Height = 512
        TabStop = False
        Align = alClient
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        TabOrder = 0
        ExplicitWidth = 388
        ExplicitHeight = 511
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Description'
      ImageIndex = 1
      object ListBox2: TListBox
        Left = 0
        Top = 17
        Width = 408
        Height = 495
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
        ExplicitWidth = 392
      end
      object HeaderControl1: THeaderControl
        Left = 0
        Top = 0
        Width = 408
        Height = 17
        Sections = <
          item
            ImageIndex = -1
            Text = 'Port:    Description:'
            Width = 150
          end>
        ExplicitWidth = 392
      end
    end
  end
end
