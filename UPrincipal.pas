unit UPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls,
  Data.DB, Datasnap.DBClient,System.Generics.Collections, UTimeFutebol,
  Vcl.Menus, UCampeonato;

type
  TForm1 = class(TForm)
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
    MainMenu1: TMainMenu;
    Cadastro1: TMenuItem;
    Campeonatos1: TMenuItem;
    btnCadastrarTitulos: TButton;
    ComboBox1: TComboBox;
    btnNovo: TButton;
    btnCancelar: TButton;
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
  private
    valorSeqencial : Integer;
    listaCampeonatos : TObjectList<TCampeonatos>;
    procedure ModoBotaoInsercao();
    procedure ModoBotaoNaoInsercao();
    { Private declarations }
  public
    ListaTimesCadastrados : TObjectList<TTimeFutebol>;
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses UFrmCampeonatos;

procedure TForm1.btnCadastrarTitulosClick(Sender: TObject);
begin
   CDS_TITULOS.Append;
   CDS_TITULOS.FieldByName('ID').AsInteger:=  listaCampeonatos.Items[ComboBox1.ItemIndex].id;
   CDS_TITULOS.FieldByName('nome').AsString:= listaCampeonatos.Items[ComboBox1.ItemIndex].nome;
   CDS_TITULOS.FieldByName('ano').AsInteger:= listaCampeonatos.Items[ComboBox1.ItemIndex].ano;
   CDS_TITULOS.Post;
   
end;                                                                            

procedure TForm1.btnCancelarClick(Sender: TObject);
begin
  ModoBotaoNaoInsercao;
end;

procedure TForm1.btnExcluirClick(Sender: TObject);
var
i : Integer;
begin
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

procedure TForm1.btnNovoClick(Sender: TObject);
begin
  CDS_TITULOS.Close;
  CDS_TITULOS.CreateDataSet;
  ModoBotaoInsercao;
end;

procedure TForm1.btnQtdeCampCadastradosTimeClick(Sender: TObject);
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

procedure TForm1.btnQtdeCampeonatosCadastradosClick(Sender: TObject);
begin
    MessageDlg('Existem '+ IntToStr(frmCadastroCampeonatos.listaCampeonatos.Count)+' campeonatos cadastrados.',mtInformation,[mbOK],0);
end;

procedure TForm1.btnQtdeTimesCadastradosClick(Sender: TObject);
begin
  MessageDlg('Existem '+ IntToStr(ListaTimesCadastrados.Count) + ' times de futebol cadastrados.',mtInformation,[mbOK],0);
end;

procedure TForm1.btSalvarClick(Sender: TObject);
var
timeFutebol : TTimeFutebol;
cp : TCampeonatos;
lListaCampeonatos : TObjectList<TCampeonatos>;

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

             lListaCampeonatos.Add( cp);

             CDS_TITULOS.Next;    
             
           end;

           timeFutebol.titulos:= lListaCampeonatos;
      
           CDS_FUTEBOL.Append;
    
           CDS_FUTEBOL.FieldByName('id').AsInteger:= timeFutebol.id;
           CDS_FUTEBOL.FieldByName('nome').AsString := timeFutebol.nome;
           CDS_FUTEBOL.FieldByName('Quantidade_Torcida').AsFloat:= timeFutebol.quantidadeTorcida;

           CDS_FUTEBOL.Post;
           CDS_FUTEBOL.First;
           ModoBotaoNaoInsercao;

           ListaTimesCadastrados.Add(timeFutebol);        
      
  end;  
end;

procedure TForm1.Campeonatos1Click(Sender: TObject);
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

procedure TForm1.DBGrid1CellClick(Column: TColumn);
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

procedure TForm1.FormCreate(Sender: TObject);

begin
  CDS_TITULOS.CreateDataSet;
  CDS_FUTEBOL.CreateDataSet;
  ListaTimesCadastrados := TObjectList<TTimeFutebol>.Create;
  ModoBotaoNaoInsercao;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNil(ListaTimesCadastrados);
end;

procedure TForm1.ModoBotaoInsercao;
begin
  edtNome.Enabled:= true;
  edtNome.Text:='';
  edtQtdeTorcida.Text:='';
  edtQtdeTorcida.Enabled:=True;
  btnNovo.Enabled:=false;
  btSalvar.Enabled:=True;
  btnExcluir.Enabled:=false;
  btnCancelar.Enabled:= True;
  btnCadastrarTitulos.Enabled:=True;
  edtNome.SetFocus;
end;

procedure TForm1.ModoBotaoNaoInsercao;
begin
  edtNome.Enabled:= false;
  edtQtdeTorcida.Enabled:=false;
  btnNovo.Enabled:=true;
  btSalvar.Enabled:=false;
  btnExcluir.Enabled:=true;
  btnCancelar.Enabled:=false;
  btnCadastrarTitulos.Enabled:=False;
end;

end.