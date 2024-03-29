unit UFrmCampeonatos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids,
  Data.DB, Datasnap.DBClient, System.Generics.Collections,Ucampeonato;

type
  TfrmCadastroCampeonatos = class(TForm)
    edtNome: TEdit;
    edtAno: TEdit;
    DBGrid1: TDBGrid;
    Nome: TLabel;
    Ano: TLabel;
    btnSalvar: TButton;
    btnExcluir: TButton;
    DS: TDataSource;
    CDS: TClientDataSet;
    CDSID: TIntegerField;
    CDSNome: TStringField;
    CDSAno: TStringField;
    btnInserir: TButton;
    btnCancelar: TButton;
    procedure btnSalvarClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnInserirClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    variavelSequencial : Integer;
    procedure ModoBotaoInsercao();
    procedure ModoBotaoNaoInsercao();
    { Private declarations }
  public
      listaCampeonatos : TObjectList<TCampeonatos>;

  end;

var
  frmCadastroCampeonatos: TfrmCadastroCampeonatos;

implementation

{$R *.dfm}

procedure TfrmCadastroCampeonatos.btnInserirClick(Sender: TObject);
begin
  ModoBotaoInsercao;
end;

procedure TfrmCadastroCampeonatos.btnSalvarClick(Sender: TObject);
var
campeonato : TCampeonatos;

begin
  if(edtNome.Text = '')then
  begin
    MessageDlg('Nome n�o informado. Verifique.',mtInformation,[mbOK],0);
  end
  else
  begin

    variavelSequencial:= variavelSequencial+1;

    campeonato:= TCampeonatos.Create;

    campeonato.id:= variavelSequencial;
    campeonato.nome:= edtNome.Text;
    campeonato.ano:= StrToInt(edtAno.Text);

    CDS.Append;

    CDS.FieldByName('id').AsInteger := campeonato.id;
    cds.FieldByName('nome').AsString := campeonato.nome;
    cds.FieldByName('ano').AsInteger := campeonato.ano;

    CDS.Post;
    ModoBotaoNaoInsercao;
    btnInserir.SetFocus;
    CDS.First;

    listaCampeonatos.Add(campeonato);

  end;
end;

procedure TfrmCadastroCampeonatos.btnCancelarClick(Sender: TObject);
begin
  ModoBotaoNaoInsercao;
end;

procedure TfrmCadastroCampeonatos.btnExcluirClick(Sender: TObject);
var
  i : Integer;
begin

  if CDSID.Value > 0 then
  begin
    for i := 0 to listaCampeonatos.Count-1 do
    begin
      if (listaCampeonatos.Items[i].id)= CDSID.Value then
      begin
        listaCampeonatos.Delete(i);
        Break;
      end;
    end;
      CDS.Delete;
      ModoBotaoNaoInsercao;
  end
  else
  MessageDlg('Selecione um registro para a realiza��o da exclus�o', mtInformation,[mbOK],0);

end;

procedure TfrmCadastroCampeonatos.FormCreate(Sender: TObject);
begin
  CDS.CreateDataSet;
  listaCampeonatos:=TObjectList<TCampeonatos>.Create;
  ModoBotaoNaoInsercao;
end;

procedure TfrmCadastroCampeonatos.FormDestroy(Sender: TObject);
begin
 FreeAndNil(listaCampeonatos);
end;

procedure TfrmCadastroCampeonatos.FormShow(Sender: TObject);
var
i :Integer;
lcampeonato : TCampeonatos;
begin

   CDS.Close;
   CDS.CreateDataSet;
   if listaCampeonatos.Count=0 then
   begin
     for i := 1 to 6 do
       begin
         variavelSequencial:= variavelSequencial+1;
         CDS.Append;
         CDS.FieldByName('ID').AsInteger:= variavelSequencial;
         CDS.FieldByName('Nome').AsString:='Brasileiro';
         CDS.FieldByName('ano').AsInteger:=StrToInt('2009')+i;
         CDS.Post;

         lcampeonato:= TCampeonatos.Create;

         lcampeonato.id:= CDSID.AsInteger;
         lcampeonato.nome:= CDSNome.AsString;
         lcampeonato.ano:= CDS.FieldByName('ano').AsInteger;
         listaCampeonatos.Add(lcampeonato);

       end;
   end
   else
   begin
     for i := 0 to listaCampeonatos.Count-1 do
       begin
         CDS.Append;
         CDS.FieldByName('Id').AsInteger:= listaCampeonatos.Items[i].id;
         CDS.FieldByName('Nome').AsString:= listaCampeonatos.Items[i].nome;
         CDS.FieldByName('ano').AsInteger:= listaCampeonatos.Items[i].ano;
         CDS.Post;
       end;
   end;


end;

procedure TfrmCadastroCampeonatos.ModoBotaoInsercao;
begin
  btnInserir.Enabled:=false;
  edtNome.Enabled:=true;
  edtAno.Enabled:=true;
  edtNome.Text:='';
  edtAno.Text:='';
  edtNome.SetFocus;
  btnCancelar.Enabled:=true;
  btnSalvar.Enabled:=True;
  btnExcluir.Enabled:=false;
end;

procedure TfrmCadastroCampeonatos.ModoBotaoNaoInsercao;
begin
  btnInserir.Enabled:=true;
  edtNome.Text:='';
  edtAno.Text:='';
  edtNome.Enabled:=false;
  edtAno.Enabled:=false;
  btnCancelar.Enabled:=false;
  btnSalvar.Enabled:=false;
  btnExcluir.Enabled:=true;
end;

end.
