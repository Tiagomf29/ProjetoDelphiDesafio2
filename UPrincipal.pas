unit UPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls,
  Data.DB, Datasnap.DBClient,System.Generics.Collections, UTimeFutebol,
  Vcl.Menus, UCampeonato;

type
  TfrmCadastroTimeFutebol = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    btSalvar: TButton;
    btnExcluir: TButton;
    edtNome: TEdit;
    edtQtdeTorcida: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    DS_TITULOS: TDataSource;
    CDS_TITULOS: TClientDataSet;
    DS_FUTEBOL: TDataSource;
    CDS_FUTEBOL: TClientDataSet;
    CDS_TITULOSID: TIntegerField;
    CDS_TITULOSNome: TStringField;
    CDS_FUTEBOLID: TIntegerField;
    CDS_FUTEBOLNome: TStringField;
    CDS_FUTEBOLQuantidade_Torcida: TIntegerField;
    btnQtdeTimesCadastrados: TButton;
    btnQtdeCampeonatosCadastrados: TButton;
    btnQtdeCampCadastradosTime: TButton;
    CDS_TITULOSAno: TSmallintField;
    MainMenu: TMainMenu;
    Cadastro1: TMenuItem;
    Campeonatos1: TMenuItem;
    btnCadastrarTitulos: TButton;
    ComboBox1: TComboBox;
    btnNovo: TButton;
    btnCancelar: TButton;
    btnAlterar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btSalvarClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnQtdeTimesCadastradosClick(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure Campeonatos1Click(Sender: TObject);
    procedure btnCadastrarTitulosClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnQtdeCampeonatosCadastradosClick(Sender: TObject);
    procedure btnQtdeCampCadastradosTimeClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
  private
    valorSeqencial : Integer;
    listaCampeonatos : TObjectList<TCampeonatos>;
    statusBotaoAlterar : boolean;
    procedure ModoBotaoInsercao();
    procedure ModoBotaoNaoInsercao();
    { Private declarations }
  public
    ListaTimesCadastrados : TObjectList<TTimeFutebol>;
    { Public declarations }
  end;

var
  frmCadastroTimeFutebol: TfrmCadastroTimeFutebol;

implementation

{$R *.dfm}

uses UFrmCampeonatos;

procedure TfrmCadastroTimeFutebol.btnAlterarClick(Sender: TObject);
begin
  ModoBotaoInsercao;
  statusBotaoAlterar:= true;
end;

procedure TfrmCadastroTimeFutebol.btnCadastrarTitulosClick(Sender: TObject);
begin
  CDS_TITULOS.Append;
  CDS_TITULOS.FieldByName('ID').AsInteger:=  listaCampeonatos.Items[ComboBox1.ItemIndex].id;
  CDS_TITULOS.FieldByName('nome').AsString:= listaCampeonatos.Items[ComboBox1.ItemIndex].nome;
  CDS_TITULOS.FieldByName('ano').AsInteger:= listaCampeonatos.Items[ComboBox1.ItemIndex].ano;
  CDS_TITULOS.Post;
end;

procedure TfrmCadastroTimeFutebol.btnCancelarClick(Sender: TObject);
begin
  ModoBotaoNaoInsercao;
  statusBotaoAlterar:= false;
end;

procedure TfrmCadastroTimeFutebol.btnExcluirClick(Sender: TObject);
var
i : Integer;
begin
  statusBotaoAlterar:= false;
  if CDS_FUTEBOLID.Value = 0 then
  begin
    ShowMessage('Selecione um time para ser exclu�do');
  end
  else
  begin
    for i := 0 to ListaTimesCadastrados.Count-1 do
    begin
      if ListaTimesCadastrados.Items[i].id = CDS_FUTEBOLID.Value then
      begin
        ListaTimesCadastrados.Delete(i);
        Break;
      end;
    end;
      CDS_FUTEBOL.Delete;
      CDS_TITULOS.Close;
      CDS_TITULOS.CreateDataSet;
      ModoBotaoNaoInsercao;
  end;
end;

procedure TfrmCadastroTimeFutebol.btnNovoClick(Sender: TObject);
begin
  CDS_TITULOS.Close;
  CDS_TITULOS.CreateDataSet;
  ModoBotaoInsercao;
  edtNome.Text:='';
  edtQtdeTorcida.Text:='';
  statusBotaoAlterar:= False;
end;

procedure TfrmCadastroTimeFutebol.btnQtdeCampCadastradosTimeClick(Sender: TObject);
var
i : Integer;
begin
    if CDS_FUTEBOLID.Value > 0 then
    begin
      for I := 0 to ListaTimesCadastrados.Count-1 do
      begin
        if (CDS_FUTEBOLID.Value = ListaTimesCadastrados.Items[i].id) then
         ShowMessage('O time de futebol '+ ListaTimesCadastrados.Items[i].nome + ' possui '+ IntToStr(ListaTimesCadastrados.Items[i].titulos.Count)+' t�tulos.');
      end;
    end
    else
      MessageDlg('Favor selecionar um time de futebol para a realiza��o da busca de quantidade de t�tulos',mtInformation,[mbOK],0);
end;

procedure TfrmCadastroTimeFutebol.btnQtdeCampeonatosCadastradosClick(Sender: TObject);
begin
    MessageDlg('Existem '+ IntToStr(frmCadastroCampeonatos.listaCampeonatos.Count)+' campeonatos cadastrados.',mtInformation,[mbOK],0);
end;

procedure TfrmCadastroTimeFutebol.btnQtdeTimesCadastradosClick(Sender: TObject);
begin
  MessageDlg('Existem '+ IntToStr(ListaTimesCadastrados.Count) + ' times de futebol cadastrados.',mtInformation,[mbOK],0);
end;

procedure TfrmCadastroTimeFutebol.btSalvarClick(Sender: TObject);
var
timeFutebol : TTimeFutebol;
cp : TCampeonatos;
lListaCampeonatos : TObjectList<TCampeonatos>;
i,valorSelecionado : Integer;

begin

  if edtNome.Text = '' then
  begin
    MessageDlg('Nome n�o informado. Verifique!',mtInformation,[mbOK],0);
    edtNome.SetFocus;
  end
  else
  begin
    timeFutebol:= TTimeFutebol.Create;

    valorSeqencial:= valorSeqencial+1;
    timeFutebol.id:=valorSeqencial;
    timeFutebol.nome:= edtNome.Text;
    timeFutebol.quantidadeTorcida:= StrToInt(edtQtdeTorcida.Text);

    lListaCampeonatos := TObjectList<TCampeonatos>.Create;

    CDS_TITULOS.First;
    while not CDS_TITULOS.Eof do
    begin
      cp := TCampeonatos.Create;

      cp.id := CDS_TITULOS.FieldByName('id').AsInteger;
      cp.nome :=CDS_TITULOS.FieldByName('nome').AsString;
      cp.ano := CDS_TITULOS.FieldByName('ano').AsInteger;

      lListaCampeonatos.Add(cp);

      CDS_TITULOS.Next;

    end;

    timeFutebol.titulos:= lListaCampeonatos;

    if not statusBotaoAlterar then
    begin
      CDS_FUTEBOL.Append;
      CDS_FUTEBOL.FieldByName('id').AsInteger:= timeFutebol.id;
    end else
      CDS_FUTEBOL.Edit;

    CDS_FUTEBOL.FieldByName('nome').AsString := timeFutebol.nome;
    CDS_FUTEBOL.FieldByName('Quantidade_Torcida').AsFloat:= timeFutebol.quantidadeTorcida;

    CDS_FUTEBOL.Post;

    CDS_TITULOS.Close;
    CDS_TITULOS.CreateDataSet;

    valorSelecionado:= CDS_FUTEBOLID.Value;
    CDS_FUTEBOL.First;
    ModoBotaoNaoInsercao;

    if not statusBotaoAlterar then
    begin
      ListaTimesCadastrados.Add(timeFutebol);
    end else
    begin
      for i := 0 to ListaTimesCadastrados.Count-1 do
      begin
        if valorSelecionado = ListaTimesCadastrados.Items[i].id then
        begin
           timeFutebol.id := ListaTimesCadastrados.Items[i].id;
           ListaTimesCadastrados.Delete(i);
           break;
        end;
      end;
        ListaTimesCadastrados.Add(timeFutebol);
    end;

   statusBotaoAlterar:= false;

  end;
end;

procedure TfrmCadastroTimeFutebol.Campeonatos1Click(Sender: TObject);
var
i : Integer;
begin

  frmcadastroCampeonatos.ShowModal;
  listaCampeonatos := frmCadastroCampeonatos.listaCampeonatos;

  ComboBox1.Clear;
  
  for i := 0 to listaCampeonatos.Count-1 do
  begin
    ComboBox1.Items.AddObject(listaCampeonatos.Items[i].nome +'-' +IntToStr(listaCampeonatos.Items[i].ano),
      TObject(listaCampeonatos));
  end;    
end;

procedure TfrmCadastroTimeFutebol.DBGrid1CellClick(Column: TColumn);
var
i,j :Integer;
lista : TObjectList<TCampeonatos>;
begin

  ModoBotaoNaoInsercao;
  edtNome.Text:= CDS_FUTEBOLNome.Value;
  edtQtdeTorcida.Text := IntToStr(CDS_FUTEBOLQuantidade_Torcida.Value);

  CDS_TITULOS.Close;
  CDS_TITULOS.CreateDataSet;

  lista:= TObjectList<TCampeonatos>.Create;

  for I := 0 to ListaTimesCadastrados.Count-1 do
  begin

    if(CDS_FUTEBOLID.Value = ListaTimesCadastrados.Items[i].id)then
    begin
      CDS_TITULOS.Close;
      CDS_TITULOS.CreateDataSet;

      lista:= ListaTimesCadastrados.Items[i].titulos;

      for j := 0 to lista.Count-1 do
      begin
        CDS_TITULOS.Append;
        CDS_TITULOS.FieldByName('id').AsInteger:= lista.Items[j].id;
        CDS_TITULOS.FieldByName('nome').AsString:=lista.Items[j].nome;
        CDS_TITULOS.FieldByName('ano').AsInteger:= lista.Items[j].ano;
        CDS_TITULOS.Post;
      end;
    end;
  end;
end;

procedure TfrmCadastroTimeFutebol.FormCreate(Sender: TObject);

begin
  CDS_TITULOS.CreateDataSet;
  CDS_FUTEBOL.CreateDataSet;
  ListaTimesCadastrados := TObjectList<TTimeFutebol>.Create;
  ModoBotaoNaoInsercao;
end;

procedure TfrmCadastroTimeFutebol.FormDestroy(Sender: TObject);
begin
  FreeAndNil(ListaTimesCadastrados);
end;

procedure TfrmCadastroTimeFutebol.ModoBotaoInsercao;
begin
  edtNome.Enabled:= true;
  edtQtdeTorcida.Enabled:=True;
  btnNovo.Enabled:=false;
  btSalvar.Enabled:=True;
  btnAlterar.Enabled:=false;
  btnExcluir.Enabled:=false;
  btnCancelar.Enabled:= True;
  btnCadastrarTitulos.Enabled:=True;
  edtNome.SetFocus;
end;

procedure TfrmCadastroTimeFutebol.ModoBotaoNaoInsercao;
begin
  edtNome.Enabled:= false;
  edtQtdeTorcida.Enabled:=false;
  btnNovo.Enabled:=true;
  btSalvar.Enabled:=false;
  btnAlterar.Enabled:=true;
  btnExcluir.Enabled:=true;
  btnCancelar.Enabled:=false;
  btnCadastrarTitulos.Enabled:=False;
end;

end.
