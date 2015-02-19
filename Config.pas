unit Config;

{$MODE Delphi}

{ copyright (c)2002 Eric Fredricksen all rights reserved }

interface

uses
  LCLIntf, LCLType, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type

  { TConfigForm }

  TConfigForm = class(TForm)
    Spells: TMemo;
    Label1: TLabel;
    OffenseAttrib: TMemo;
    Label2: TLabel;
    DefenseAttrib: TMemo;
    Label3: TLabel;
    Shields: TMemo;
    Label4: TLabel;
    Armors: TMemo;
    Label5: TLabel;
    Weapons: TMemo;
    Label6: TLabel;
    Specials: TMemo;
    Label7: TLabel;
    ItemAttrib: TMemo;
    Label8: TLabel;
    ItemOfs: TMemo;
    Label9: TLabel;
    BoringItems: TMemo;
    Label10: TLabel;
    Monsters: TMemo;
    MonMods: TMemo;
    Label11: TLabel;
    Label12: TLabel;
    OffenseBad: TMemo;
    Label13: TLabel;
    DefenseBad: TMemo;
    Label14: TLabel;
    Races: TMemo;
    Label15: TLabel;
    Label16: TLabel;
    Klasses: TMemo;
    Label17: TLabel;
    Titles: TMemo;
    ImpressiveTitles: TMemo;
    Label18: TLabel;
  end;

var
  K: TConfigForm;

implementation

{$R *.lfm}

{ TConfigForm }

end.