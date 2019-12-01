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
    cbxIncluirTitulos: TComboBox;
    btnNovo: TButton;
    btnCancelar: TButton;
    btnAlterar: TButton;
    btnExcluirTitulo: TButton;
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
    procedure btnExcluirTituloClick(Sender: TObject);
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

uses UFrmCampeonatos, UListaTimes;

procedure TfrmCadastroTimeFutebol.btnAlterarClick(Sender: TObject);
begin
  ModoBotaoInsercao;
  statusBotaoAlterar:= true;
end;

procedure TfrmCadastroTimeFutebol.btnCadastrarTitulosClick(Sender: TObject);
var
i,a : Integer;
begin

  if cbxIncluirTitulos.ItemIndex = -1 then
  begin
    MessageDlg('Título não selecionado. Verifique!',mtInformation,[mbOK],0);
    cbxIncluirTitulos.SetFocus;
    Abort;
  end;

  CDS_TITULOS.First;

  while not CDS_TITULOS.Eof do
  begin
    if  listaCampeonatos.Items[cbxIncluirTitulos.ItemIndex].id = CDS_TITULOSID.Value then
    begin
      MessageDlg('Título já foi inserido',mtInformation,[mbOK],0);
      cbxIncluirTitulos.SetFocus;
      Abort;
    end;
    CDS_TITULOS.Next;
  end;

  for i := 0 to ListaTimesCadastrados.Count-1 do
  begin
    for a := 0 to ListaTimesCadastrados.Items[i].titulos.Count-1 do
      begin
        if ListaTimesCadastrados.Items[i].titulos.Items[a].id = listaCampeonatos.Items[cbxIncluirTitulos.ItemIndex].id then
          begin
            MessageDlg('Título já inserido para o time de futebol: '+ListaTimesCadastrados.Items[i].nome,mtInformation,[mbOK],0);
            cbxIncluirTitulos.SetFocus;
            Abort;
          end;
      end;
  end;


  CDS_TITULOS.Append;
  CDS_TITULOS.FieldByName('ID').AsInteger:=  listaCampeonatos.Items[cbxIncluirTitulos.ItemIndex].id;
  CDS_TITULOS.FieldByName('nome').AsString:= listaCampeonatos.Items[cbxIncluirTitulos.ItemIndex].nome;
  CDS_TITULOS.FieldByName('ano').AsInteger:= listaCampeonatos.Items[cbxIncluirTitulos.ItemIndex].ano;
  CDS_TITULOS.Post;


end;

procedure TfrmCadastroTimeFutebol.btnCancelarClick(Sender: TObject);
begin
  ModoBotaoNaoInsercao;
  CDS_TITULOS.Close;
  CDS_TITULOS.CreateDataSet;
  statusBotaoAlterar:= false;
end;

procedure TfrmCadastroTimeFutebol.btnExcluirClick(Sender: TObject);
var
i : Integer;
begin
  statusBotaoAlterar:= false;
  if CDS_FUTEBOLID.Value = 0 then
  begin
    ShowMessage('Selecione um time para ser excluído');
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

procedure TfrmCadastroTimeFutebol.btnExcluirTituloClick(Sender: TObject);
begin

  if CDS_TITULOSID.Value > 0 then
  begin
    if MessageDlg('Tem certeza que deseja excluir o título selecionado?',mtConfirmation,[mbYes,mbNo],0)=mrYes then
    begin
      CDS_TITULOS.Delete;
      Abort;
    end
    else
    begin
      btnExcluirTitulo.SetFocus;
      Abort;
    end;
  end
  else
    MessageDlg('Nenhum registro a ser excluído. Verifique!',mtInformation,[mbOK],0);
    btnExcluirTitulo.SetFocus;
    Abort;
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
       ShowMessage('O time de futebol '+ ListaTimesCadastrados.Items[i].nome + ' possui '+ IntToStr(ListaTimesCadastrados.Items[i].titulos.Count)+' títulos.');
    end;
  end
  else
    MessageDlg('Favor selecionar um time de futebol para a realização da busca de quantidade de títulos',mtInformation,[mbOK],0);
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
lTimeFutebol : TTimeFutebol;
lCampeonato : TCampeonatos;
lListaCampeonatos : TObjectList<TCampeonatos>;
i,ii,j,lValorSelecionado : Integer;

begin

  if edtNome.Text = '' then
  begin
    MessageDlg('Nome não informado. Verifique!',mtInformation,[mbOK],0);
    edtNome.SetFocus;
    Abort;
  end
  else
  begin

    lTimeFutebol := TTimeFutebol.Create;

    valorSeqencial:= valorSeqencial+1;
    lTimeFutebol.id:=valorSeqencial;
    lTimeFutebol.nome:= edtNome.Text;
    if edtQtdeTorcida.Text = '' then
      lTimeFutebol.quantidadeTorcida:= 0
    else
    lTimeFutebol.quantidadeTorcida:= StrToInt(edtQtdeTorcida.Text);

    lListaCampeonatos := TObjectList<TCampeonatos>.Create;

    if (CDS_TITULOS.IsEmpty) and (not CDS_FUTEBOL.Eof)then
    begin
     if  MessageDlg('O time que está sendo cadastrado não possui títulos.'+#13+
      'Deseja copiar os títulos de algum time que já foi cadastrado?', mtConfirmation,[mbYes,mbNo],0) = mrYes then
      begin
        frmListaTimes.ShowModal;

        for i := 0 to ListaTimesCadastrados.Count-1 do
          begin
            if ListaTimesCadastrados.Items[i].id = frmListaTimes.CDSID.Value then
              for ii := 0 to ListaTimesCadastrados.Items[i].titulos.Count-1 do
              begin
                CDS_TITULOS.Append;
                CDS_TITULOS.FieldByName('Id').AsInteger:= ListaTimesCadastrados.Items[i].titulos.Items[ii].id;
                CDS_TITULOS.FieldByName('nome').AsString:= ListaTimesCadastrados.Items[i].titulos.Items[ii].nome;
                CDS_TITULOS.FieldByName('ano').AsInteger:= ListaTimesCadastrados.Items[i].titulos.Items[ii].ano;
                CDS_TITULOS.Post;
              end;
          end;
      end;
    end;
  end;

    CDS_TITULOS.First;
    while not CDS_TITULOS.Eof do
    begin
      lCampeonato := TCampeonatos.Create;

      lCampeonato.id := CDS_TITULOS.FieldByName('id').AsInteger;
      lCampeonato.nome :=CDS_TITULOS.FieldByName('nome').AsString;
      lCampeonato.ano := CDS_TITULOS.FieldByName('ano').AsInteger;

      lListaCampeonatos.Add(lCampeonato);

      CDS_TITULOS.Next;

    end;


    lTimeFutebol.titulos:= lListaCampeonatos;

    if not statusBotaoAlterar then
    begin
      CDS_FUTEBOL.Append;
      CDS_FUTEBOL.FieldByName('id').AsInteger:= lTimeFutebol.id;
    end else
      CDS_FUTEBOL.Edit;

    CDS_FUTEBOL.FieldByName('nome').AsString := lTimeFutebol.nome;
    CDS_FUTEBOL.FieldByName('Quantidade_Torcida').AsFloat:= lTimeFutebol.quantidadeTorcida;

    CDS_FUTEBOL.Post;

    CDS_TITULOS.Close;
    CDS_TITULOS.CreateDataSet;

    lValorSelecionado := CDS_FUTEBOLID.Value;
    CDS_FUTEBOL.First;
    ModoBotaoNaoInsercao;

    if not statusBotaoAlterar then
    begin
      ListaTimesCadastrados.Add(lTimeFutebol);
    end else
    begin
      for i := 0 to ListaTimesCadastrados.Count-1 do
      begin
        if lValorSelecionado = ListaTimesCadastrados.Items[i].id then
        begin
           lTimeFutebol.id := ListaTimesCadastrados.Items[i].id;
           ListaTimesCadastrados.Delete(i);
           break;
        end;
      end;
        ListaTimesCadastrados.Add(lTimeFutebol);
    end;

   statusBotaoAlterar:= false;
   btnNovo.SetFocus;


end;

procedure TfrmCadastroTimeFutebol.Campeonatos1Click(Sender: TObject);
var
i : Integer;
lCampeonato : TCampeonatos;
begin


  frmcadastroCampeonatos.ShowModal;

  listaCampeonatos.Clear;

  for i := 0 to frmCadastroCampeonatos.listaCampeonatos.Count-1 do
  begin
      lCampeonato:= TCampeonatos.Create;
      lCampeonato.copyFromObject(frmCadastroCampeonatos.listaCampeonatos.Items[i]);
      listaCampeonatos.Add(lCampeonato);
  end;

  cbxIncluirTitulos.Clear;
  
  for i := 0 to listaCampeonatos.Count-1 do
  begin
    cbxIncluirTitulos.Items.AddObject(listaCampeonatos.Items[i].nome +'-' +IntToStr(listaCampeonatos.Items[i].ano),
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
  listaCampeonatos:= TObjectList<TCampeonatos>.Create;
  ModoBotaoNaoInsercao;
end;

procedure TfrmCadastroTimeFutebol.FormDestroy(Sender: TObject);
begin
  FreeAndNil(ListaTimesCadastrados);
  FreeAndNil(listaCampeonatos);
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
  btnExcluirTitulo.Enabled:=true;
  cbxIncluirTitulos.ItemIndex:= -1;
  cbxIncluirTitulos.Enabled:=true;
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
  btnExcluirTitulo.Enabled:=false;
  cbxIncluirTitulos.ItemIndex:= -1;
  btnCadastrarTitulos.Enabled:=False;
  cbxIncluirTitulos.Enabled:=false;
end;

end.
