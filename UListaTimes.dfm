object frmListaTimes: TfrmListaTimes
  Left = 0
  Top = 0
  Caption = 'Lista de times'
  ClientHeight = 273
  ClientWidth = 350
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 0
    Top = 0
    Width = 350
    Height = 238
    Align = alTop
    DataSource = DS
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object Button1: TButton
    Left = 128
    Top = 244
    Width = 75
    Height = 25
    Caption = 'Selecionar'
    TabOrder = 1
    OnClick = Button1Click
  end
  object DS: TDataSource
    AutoEdit = False
    DataSet = CDS
    Left = 128
    Top = 96
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 272
    Top = 88
    object CDSID: TIntegerField
      FieldName = 'ID'
    end
    object CDSNome: TStringField
      FieldName = 'Nome'
    end
    object CDSQtdeTorcida: TIntegerField
      FieldName = 'QtdeTorcida'
    end
  end
end
