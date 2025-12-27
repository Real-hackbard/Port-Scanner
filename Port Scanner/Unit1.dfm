object Form1: TForm1
  Left = 561
  Top = 207
  ActiveControl = SpinEdit1
  Caption = 'Port Scanner'
  ClientHeight = 595
  ClientWidth = 663
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 161
    Height = 559
    Align = alLeft
    BevelOuter = bvNone
    BiDiMode = bdLeftToRight
    Ctl3D = False
    ParentBiDiMode = False
    ParentCtl3D = False
    TabOrder = 0
    TabStop = True
    ExplicitHeight = 558
    object Label1: TLabel
      Left = 13
      Top = 104
      Width = 28
      Height = 13
      Caption = 'Host :'
    end
    object Label2: TLabel
      Left = 89
      Top = 185
      Width = 6
      Height = 13
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 13
      Top = 130
      Width = 28
      Height = 13
      Caption = 'Start :'
    end
    object Label4: TLabel
      Left = 16
      Top = 157
      Width = 25
      Height = 13
      Caption = 'End :'
    end
    object Label5: TLabel
      Left = 9
      Top = 185
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
      Top = 83
      Width = 40
      Height = 13
      Caption = 'Network'
    end
    object Bevel1: TBevel
      Left = 6
      Top = 248
      Width = 153
      Height = 2
    end
    object Label9: TLabel
      Left = 16
      Top = 264
      Width = 25
      Height = 13
      Caption = 'Port :'
    end
    object Bevel2: TBevel
      Left = 6
      Top = 328
      Width = 153
      Height = 2
    end
    object Label10: TLabel
      Left = 21
      Top = 375
      Width = 34
      Height = 13
      Caption = 'Count :'
    end
    object Label11: TLabel
      Left = 29
      Top = 402
      Width = 26
      Height = 13
      Caption = 'Size :'
    end
    object Label12: TLabel
      Left = 21
      Top = 431
      Width = 34
      Height = 13
      Caption = 'Buffer :'
    end
    object Label13: TLabel
      Left = 18
      Top = 348
      Width = 37
      Height = 13
      Caption = 'Target :'
    end
    object Label14: TLabel
      Left = 27
      Top = 458
      Width = 28
      Height = 13
      Caption = 'User :'
      Enabled = False
    end
    object Label15: TLabel
      Left = 18
      Top = 483
      Width = 37
      Height = 13
      Caption = 'Server :'
      Enabled = False
    end
    object Label16: TLabel
      Left = 3
      Top = 508
      Width = 52
      Height = 13
      Caption = 'Password :'
      Enabled = False
    end
    object Edit1: TEdit
      Left = 44
      Top = 102
      Width = 89
      Height = 19
      TabStop = False
      TabOrder = 0
    end
    object SpinEdit1: TSpinEdit
      Left = 44
      Top = 127
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
      Top = 154
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
      Left = 105
      Top = 214
      Width = 50
      Height = 20
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
      Left = 105
      Top = 297
      Width = 50
      Height = 20
      Caption = 'Check'
      TabOrder = 5
      TabStop = False
      OnClick = Button2Click
    end
    object SpinEdit3: TSpinEdit
      Left = 44
      Top = 261
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
      Left = 105
      Top = 533
      Width = 50
      Height = 20
      Caption = 'Ping'
      TabOrder = 7
      TabStop = False
      OnClick = Button3Click
    end
    object SpinEdit4: TSpinEdit
      Left = 58
      Top = 372
      Width = 55
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
      Left = 58
      Top = 400
      Width = 55
      Height = 22
      TabStop = False
      Ctl3D = True
      MaxValue = 8192
      MinValue = 32
      ParentCtl3D = False
      TabOrder = 9
      Value = 32
    end
    object SpinEdit6: TSpinEdit
      Left = 58
      Top = 428
      Width = 55
      Height = 22
      Ctl3D = True
      MaxValue = 8192
      MinValue = 1
      ParentCtl3D = False
      TabOrder = 10
      Value = 8192
    end
    object ComboBox2: TComboBox
      Left = 58
      Top = 345
      Width = 97
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 11
      Text = 'Localhost'
      OnChange = ComboBox2Change
      Items.Strings = (
        'Localhost'
        'Server')
    end
    object Edit2: TEdit
      Left = 58
      Top = 456
      Width = 97
      Height = 19
      Enabled = False
      TabOrder = 12
    end
    object Edit3: TEdit
      Left = 58
      Top = 481
      Width = 97
      Height = 19
      Enabled = False
      TabOrder = 13
      Text = '192.168.0.1'
    end
    object Edit4: TEdit
      Left = 58
      Top = 506
      Width = 97
      Height = 19
      Enabled = False
      TabOrder = 14
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 576
    Width = 663
    Height = 19
    Panels = <
      item
        Text = 'Progress : 0 %'
        Width = 150
      end
      item
        Text = 'User :'
        Width = 40
      end
      item
        Width = 120
      end
      item
        Text = 'Port List :'
        Width = 60
      end
      item
        Text = '0'
        Width = 50
      end>
    ExplicitTop = 575
    ExplicitWidth = 659
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 559
    Width = 663
    Height = 17
    Align = alBottom
    TabOrder = 2
    ExplicitTop = 558
    ExplicitWidth = 659
  end
  object PageControl1: TPageControl
    Left = 161
    Top = 0
    Width = 502
    Height = 559
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 3
    TabStop = False
    ExplicitWidth = 498
    ExplicitHeight = 558
    object TabSheet1: TTabSheet
      Caption = 'Scanner'
      object ListBox1: TListBox
        Left = 0
        Top = 0
        Width = 494
        Height = 531
        TabStop = False
        Style = lbOwnerDrawFixed
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Color = clWhite
        Ctl3D = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ItemHeight = 13
        ParentCtl3D = False
        ParentFont = False
        PopupMenu = PopupMenu1
        TabOrder = 0
        OnDrawItem = ListBox1DrawItem
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Description'
      ImageIndex = 1
      object ListBox2: TListBox
        Left = 0
        Top = 17
        Width = 494
        Height = 514
        Style = lbOwnerDrawVariable
        Align = alClient
        DragMode = dmAutomatic
        ItemHeight = 13
        MultiSelect = True
        PopupMenu = PopupMenu2
        TabOrder = 0
        OnDragDrop = ListBox2DragDrop
        OnDragOver = ListBox2DragOver
        OnDrawItem = ListBox2DrawItem
      end
      object HeaderControl1: THeaderControl
        Left = 0
        Top = 0
        Width = 494
        Height = 17
        Sections = <
          item
            ImageIndex = -1
            Text = 'Port:    Description:'
            Width = 150
          end>
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 461
    Top = 120
    object Clear1: TMenuItem
      Caption = 'Clear'
      OnClick = Clear1Click
    end
    object Copy1: TMenuItem
      Caption = 'Copy'
      OnClick = Copy1Click
    end
    object Save1: TMenuItem
      Caption = 'Save'
      OnClick = Save1Click
    end
  end
  object SaveDialog1: TSaveDialog
    Filter = 'Textdocument (*.TXT)|*.txt'
    Left = 373
    Top = 120
  end
  object PopupMenu2: TPopupMenu
    Left = 469
    Top = 200
    object Search1: TMenuItem
      Caption = 'Search'
      OnClick = Search1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Save2: TMenuItem
      Caption = 'Save'
      OnClick = Save2Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Remove1: TMenuItem
      Caption = 'Remove'
      OnClick = Remove1Click
    end
    object RemoveDuplicates1: TMenuItem
      Caption = 'Remove Duplicates'
      OnClick = RemoveDuplicates1Click
    end
  end
end
