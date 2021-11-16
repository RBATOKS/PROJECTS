object Form1: TForm1
  Left = 192
  Top = 107
  Caption = 'Lista Arquivos Diretorios'
  ClientHeight = 201
  ClientWidth = 339
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 39
    Height = 13
    Caption = 'Diret'#243'rio'
  end
  object Label2: TLabel
    Left = 8
    Top = 48
    Width = 41
    Height = 13
    Caption = 'Arquivos'
  end
  object Label3: TLabel
    Left = 184
    Top = 176
    Width = 72
    Height = 13
    Caption = 'Tamanho Total'
  end
  object edtDiretorio: TEdit
    Left = 8
    Top = 24
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'Caminho da pasta'
  end
  object chkSub: TCheckBox
    Left = 136
    Top = 24
    Width = 121
    Height = 17
    Caption = 'Incluir Subdiret'#243'rios'
    TabOrder = 1
  end
  object memLista: TMemo
    Left = 8
    Top = 64
    Width = 321
    Height = 105
    Lines.Strings = (
      'memLista')
    TabOrder = 2
  end
  object Button1: TButton
    Left = 256
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Verificar'
    TabOrder = 3
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 264
    Top = 176
    Width = 65
    Height = 21
    TabOrder = 4
  end
end
