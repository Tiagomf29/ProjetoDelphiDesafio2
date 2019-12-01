unit UTimeFutebol;

interface
uses
UCampeonato,System.Generics.Collections;

type

TTimeFutebol = class

private

  FId                : Integer;
  FNome              : String;
  FQuantidadeTorcida : double;
  FTitulos           : TObjectList<TCampeonatos>;

  function getId                : Integer;
  function getNome              : String;
  function getQuantidadeTorcida : double;
  function getTitulos: TObjectList<TCampeonatos>;

  procedure SetId(const Value: Integer);
  procedure SetNome(const Value: String);
  procedure setQuantidadeTorcida(const Value: double);
  procedure setTitulos(const Value: TObjectList<TCampeonatos>);


protected

public
  property id                : Integer  read getId write SetId;
  property nome              : String read getNome write SetNome;
  property quantidadeTorcida : double read getQuantidadeTorcida write setQuantidadeTorcida;
  property titulos           : TObjectList<TCampeonatos> read getTitulos write setTitulos;

  procedure CopyFromObejct(timeFutebol :TTimeFutebol);

end;

implementation

{ TTimeFutebol }

procedure TTimeFutebol.CopyFromObejct(timeFutebol: TTimeFutebol);
begin
  Self.FId                  := timeFutebol.id;
  Self.FNome                := timeFutebol.nome;
  Self.quantidadeTorcida    := timeFutebol.quantidadeTorcida;
  Self.FTitulos             := timeFutebol.titulos;
end;

function TTimeFutebol.getId: Integer;
begin
  Result:= FId;
end;

function TTimeFutebol.getNome: String;
begin
  Result:= FNome;
end;

function TTimeFutebol.getQuantidadeTorcida: double;
begin
  Result:= FQuantidadeTorcida;
end;

function TTimeFutebol.getTitulos: TObjectList<TCampeonatos>;
begin
  Result:= FTitulos;
end;

procedure TTimeFutebol.SetId(const Value: Integer);
begin
  Self.FId:= Value;
end;

procedure TTimeFutebol.SetNome(const Value: String);
begin
  Self.FNome:= Value;
end;

procedure TTimeFutebol.setQuantidadeTorcida(const Value: double);
begin
  Self.FQuantidadeTorcida:= Value;
end;

procedure TTimeFutebol.setTitulos(const Value: TObjectList<TCampeonatos>);
begin
  Self.FTitulos:= Value;
end;

end.
