program pq;

{$MODE Delphi}

uses
  Forms, Interfaces,
  Config in 'Config.pas' {K},
  Front in 'Front.pas' {FrontForm},
  Main in 'Main.pas' {MainForm},
  NewGuy in 'NewGuy.pas' {NewGuyForm},
  SelServ in 'SelServ.pas' {ServerSelectForm},
  Web in 'Web.pas',
  StreamZlib in 'StreamZlib.pas',
  Saves in 'Saves.pas';

begin
  Application.Initialize;
  Application.Title := 'Progress Quest';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TConfigForm, K);
  Application.CreateForm(TFrontForm, FrontForm);
  Application.CreateForm(TNewGuyForm, NewGuyForm);
  Application.CreateForm(TServerSelectForm, ServerSelectForm);
  Application.Run;
end.