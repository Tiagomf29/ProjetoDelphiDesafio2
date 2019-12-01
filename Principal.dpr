program Principal;

uses
  Vcl.Forms,
  UPrincipal in 'UPrincipal.pas' {frmCadastroTimeFutebol},
  UTimeFutebol in 'UTimeFutebol.pas',
  UCampeonato in 'UCampeonato.pas',
  UFrmCampeonatos in 'UFrmCampeonatos.pas' {frmCadastroCampeonatos},
  UListaTimes in 'UListaTimes.pas' {frmListaTimes};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmCadastroTimeFutebol, frmCadastroTimeFutebol);
  Application.CreateForm(TfrmCadastroCampeonatos, frmCadastroCampeonatos);
  Application.CreateForm(TfrmListaTimes, frmListaTimes);
  Application.Run;
end.
