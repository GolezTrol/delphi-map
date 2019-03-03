object KMLTestForm: TKMLTestForm
  Left = 0
  Top = 0
  Caption = 'KML test'
  ClientHeight = 845
  ClientWidth = 1000
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object ShowKMLMap: TCheckBox
    Left = 8
    Top = 8
    Width = 209
    Height = 17
    Caption = 'Draw map loaded from KML file'
    TabOrder = 0
    OnClick = ShowKMLMapClick
  end
  object ShowBinaryMap: TCheckBox
    Left = 8
    Top = 31
    Width = 209
    Height = 17
    Caption = 'Draw map loaded from binary file'
    Checked = True
    State = cbChecked
    TabOrder = 1
    OnClick = ShowBinaryMapClick
  end
end
