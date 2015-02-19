unit Front;

{$MODE Delphi}

{ copyright (c)2002 Eric Fredricksen all rights reserved }

interface

uses
  LCLIntf, LCLType, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFrontForm = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    OpenDialog1: TOpenDialog;
    Button4: TButton;
    Label2: TLabel;
    Button3: TButton;
    Panel2: TPanel;
    Logo: TImage;
    Label3: TLabel;
    HomeLink: TLabel;
    Label1: TLabel;
    procedure HomeLinkClick(Sender: TObject);
    procedure LogoClick(Sender: TObject);
  end;

var
  FrontForm: TFrontForm;

implementation

{$R *.lfm}

procedure TFrontForm.HomeLinkClick(Sender: TObject);
begin
  OpenURL('http://progressquest.com/'); { *Converted from ShellExecute* }
end;

procedure TFrontForm.LogoClick(Sender: TObject);
begin
  OpenURL('http://progressquest.com/'); { *Converted from ShellExecute* }
end;

end.