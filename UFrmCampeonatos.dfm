object frmCadastroCampeonatos: TfrmCadastroCampeonatos
  Left = 0
  Top = 0
  Caption = 'Cadastro de campoeonatos'
  ClientHeight = 317
  ClientWidth = 447
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Nome: TLabel
    Left = 8
    Top = 8
    Width = 27
    Height = 13
    Caption = 'Nome'
  end
  object Ano: TLabel
    Left = 10
    Top = 51
    Width = 19
    Height = 13
    Caption = 'Ano'
  end
  object edtNome: TEdit
    Left = 8
    Top = 24
    Width = 121
    Height = 21
    Enabled = False
    TabOrder = 0
  end
  object edtAno: TEdit
    Left = 8
    Top = 68
    Width = 121
    Height = 21
    Enabled = False
    TabOrder = 1
  end
  object DBGrid1: TDBGrid
    Left = -4
    Top = 136
    Width = 443
    Height = 179
    DataSource = DS
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object btnSalvar: TButton
    Left = 144
    Top = 105
    Width = 75
    Height = 25
    Caption = 'Salvar'
    TabOrder = 3
    OnClick = btnSalvarClick
  end
  object btnExcluir: TButton
    Left = 306
    Top = 105
    Width = 75
    Height = 25
    Caption = 'Excluir'
    TabOrder = 4
    OnClick = btnExcluirClick
  end
  object btnInserir: TButton
    Left = 63
    Top = 105
    Width = 75
    Height = 25
    Caption = 'Inserir'
    TabOrder = 5
    OnClick = btnInserirClick
  end
  object btnCancelar: TButton
    Left = 225
    Top = 105
    Width = 75
    Height = 25
    Caption = 'Cancelar'
    TabOrder = 6
    OnClick = btnCancelarClick
  end
  object DS: TDataSource
    DataSet = CDS
    Left = 264
    Top = 32
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 336
    Top = 40
    object CDSID: TIntegerField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'ID'
    end
    object CDSNome: TStringField
      FieldName = 'Nome'
    end
    object CDSAno: TStringField
      FieldName = 'Ano'
    end
  end
end
