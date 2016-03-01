{
  do not forget:
  * icon
  * taskbar icon and hint
  * proxy?
  * very large experience and spell levels?
  * autosize last columns?
  * double buffering everything
}

unit Main;

{$MODE Delphi}

{$OVERFLOWCHECKS ON}
{$RANGECHECKS ON}

{ copyright (c)2002 Eric Fredricksen all rights reserved  }
{ copyright (c) 2015 Alexey Korepanov all rights reserved }

{$UNDEF CHEATS}
{$UNDEF LOGGING}

interface

uses
  LCLIntf, LCLType, LMessages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Buttons, Menus, LazFileUtils, StreamZlib, Saves,
  InventoryBack;

const
  // revs:
  // 5: pq 6.3
  // 4: pq 6.2
  // 3: pq 6.1
  // 2: pq 6.0
  // 1: pq 6.0, some early release I guess; don't remember
  RevString = '&rev=5';
  wmIconTray = WM_USER + Ord('t');
  kFileExt = '.lpq';

type

  { TMainForm }

  TMainForm = class(TForm)
    Button1: TButton;
    Button3: TButton;
    CashIn: TButton;
    CheatPlot: TButton;
    Cheats: TPanel;
    EncumBar: TProgressBar;
    Equips: TListView;
    ExpBar: TProgressBar;
    FinishQuest: TButton;
    fQuest: TLabel;
    fQueue: TListBox;
    fTask: TLabel;
    Inventory: TListView;
    InventoryLabelAlsoGameStyle: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Panel1: TPanel;
    Panel123: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel3top: TPanel;
    Panel3bottom: TPanel;
    Panel2top: TPanel;
    Panel2bottom: TPanel;
    Panel1top: TPanel;
    Panel1middle: TPanel;
    Panel1bottom: TPanel;
    PlotBar: TProgressBar;
    Plots: TListView;
    QuestBar: TProgressBar;
    Quests: TListView;
    Spells: TListView;
    Panel4: TPanel;
    Kill: TStatusBar;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    Splitter4: TSplitter;
    Splitter5: TSplitter;
    Splitter6: TSplitter;
    Stats: TListView;
    TaskBar: TProgressBar;
    Timer1: TTimer;
    Traits: TListView;
    TrayIcon1: TTrayIcon;
    vars: TPanel;
    procedure FormActivate(Sender: TObject);
    procedure OnMainFormWindowStateChange(Sender: TObject);
    procedure OnClickTrayIcon1(Sender: TObject);
    procedure GoButtonClick(Sender: TObject);
    procedure PlotsItemChecked(Sender: TObject; Item: TListItem);
    procedure QuestsItemChecked(Sender: TObject; Item: TListItem);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CashInClick(Sender: TObject);
    procedure FinishQuestClick(Sender: TObject);
    procedure CheatPlotClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure UnselectListItem(Sender: TObject; Item: TListItem);
    procedure TriggerAutoSizes;
    procedure InventoryData(Sender: TObject; Item: TListItem);
  private
    AutoSized: boolean;
    pWindowState: TWindowState;
    Save: TSave;
    procedure Task(caption: String; msec: Integer);
    procedure Dequeue;
    procedure Q(s: string);
    function TaskDone: Boolean;
    procedure CompleteQuest;
    procedure CompleteAct;
    procedure WinEquip;
    procedure WinSpell;
    procedure WinStat;
    procedure WinItem;
    function SpecialItem: String;
    procedure LevelUp;
    function BoringItem: String;
    function InterestingItem: String;
    function MonsterTask(var level: Integer): String;
    function EquipPrice: Integer;
    procedure Brag(trigger: String);
    function GameSaveName: String;
    procedure Guildify;
    function AuthenticateUrl(url: String): String;
    {$IFDEF LOGGING}
    procedure Log(line: String);
    {$ENDIF}
    procedure ExportCharSheet;
    function CharSheet: String;
    procedure InterplotCinematic;
    function NamedMonster(level: Integer): String;
    function ImpressiveGuy: String;
    procedure InventoryUpd;
  public
    InventoryBack: TInventoryBack;
    InventoryBack_Gold: integer;
    FReportSave: Boolean;
    FLogEvents: Boolean;
    FMakeBackups: Boolean;
    FMinToTray: Boolean;
    FExportSheets: Boolean;
    FSaveFileName: String;
    procedure LoadGame(name: String);
    function SaveGame: Boolean;
    procedure AddInventory(key: string; value: integer);
    procedure Put(list: TListView; key: String; value: String); overload;
    procedure Put(list: TListView; pos: Integer; value: String); overload;
    procedure Put(list: TListView; key: String; value: Integer); overload;
    procedure Add(list: TListView; key: String; value: Integer); overload;
    procedure AddR(list: TListView; key: String; value: Integer); overload;
    function Get(list: TListView; key: String): String; overload;
    function Get(list: TListView; index: Integer): String; overload;
    function GetI(list: TListView; key: String): Integer; overload;
    function GetI(list: TListView; index: Integer): Integer; overload;
    function Sum(list: TListView): Integer;
    function RollCharacter: Boolean;
    function GetMotto: String;
    function GetPasskey: Integer;
    procedure SetMotto(v: String);
    procedure SetPasskey(v: String);
    function GetHostAddr: String;
    function GetHostName: String;
    procedure SetHostAddr(v: String);
    procedure SetHostName(v: String);
    function GetLogin: String;
    function GetPassword: String;
    procedure SetLogin(v: String);
    procedure SetPassword(v: String);
    function GetGuild: String;
    procedure SetGuild(v: String);
  end;

var
  MainForm: TMainForm;

function Split(s: String; field: Integer): String; overload;
function Split(s: String; field: Integer; separator: String): String; overload;

implementation

uses Web, StrUtils, NewGuy, Math, Config, Front, SelServ;

{$R *.lfm}

procedure TMainForm.TriggerAutoSizes;
var i: Integer;
begin
  for i:=0 to ComponentCount-1 do begin
    if Components[i] is TSplitter then begin
      with (Components[i] as TSplitter) do begin
        MoveSplitter(-1);
        MoveSplitter(1);
      end;
    end;
  end;
end;


procedure TMainForm.UnselectListItem(Sender: TObject; Item: TListItem);
begin
  Item.Selected := False;
end;

procedure StartTimer;
begin
  if not MainForm.Timer1.Enabled then begin
    MainForm.Timer1.Tag := GetTickCount;
  end;
  MainForm.Timer1.Enabled := True;
  // BS location for this, but...
  MainForm.Caption := 'ProgressQuest - ' + ChangeFileExt(ExtractFileName(MainForm.GameSaveName), '');
end;

function TMainForm.GetPasskey: Integer; begin Result := Traits.Tag; end;
procedure TMainForm.SetPasskey(v: String);
begin
  Traits.Hint := v;
  Traits.Tag := StrToIntDef(Traits.Hint,0);
end;

function TMainForm.GetMotto: String; begin Result := Stats.Hint; end;
procedure TMainForm.SetMotto(v: String); begin Stats.Hint := v; end;

function TMainForm.GetHostName: String; begin Result := Spells.Hint; end;
procedure TMainForm.SetHostName(v: String); begin Spells.Hint := v; end;

function TMainForm.GetHostAddr: String;
begin
  Result := Equips.Hint;
  if (Result = '') and (GetPasskey <> 0) then
    Result := 'http://www.progressquest.com/knoram.php?';
end;
procedure TMainForm.SetHostAddr(v: String); begin Equips.Hint := v; end;

function TMainForm.GetLogin: String; begin Result := Inventory.Hint; end;
procedure TMainForm.SetLogin(v: String); begin Inventory.Hint := v; end;

function TMainForm.GetPassword: String; begin Result := Plots.Hint; end;
procedure TMainForm.SetPassword(v: String); begin Plots.Hint := v; end;

function TMainForm.GetGuild: String; begin Result := Label1.Hint; end;
procedure TMainForm.SetGuild(v: String); begin Label1.Hint := v; end;

procedure TMainForm.Q(s: string);
begin
  fQueue.Items.Add(s);
  Dequeue;
end;

function TMainForm.TaskDone: Boolean;
begin
  with TaskBar do
    Result := Position >= Max;
end;

function Odds(chance, outof: Integer): Boolean;
begin
  Result := Random(outof) < chance;
end;

function RandSign(): Integer;
begin
  Result := Random(2) * 2 - 1;
end;

function Pick(s: TStrings): String;
begin
  Result := s[Random(s.Count)];
end;

function RandomLow(below: Integer): Integer;
begin
  Result := Min(Random(below),Random(below));
end;

function PickLow(s: TStrings): String;
begin
  Result := s[RandomLow(s.Count)];
end;

function Ends(s,e: String): Boolean;
begin
  Result := Copy(s,1+Length(s)-Length(e),Length(e)) = e;
end;

function Plural(s: String): String;
begin
       if Ends(s,'y')
       then Result := Copy(s,1,Length(s)-1) + 'ies'
  else if Ends(s,'us')
       then Result := Copy(s,1,Length(s)-2) + 'i'
  else if Ends(s,'ch') or Ends(s,'x') or Ends(s,'s')
       then Result := s + 'es'
  else if Ends(s,'f')
       then Result := Copy(s,1,Length(s)-1) + 'ves'
  else if Ends(s,'man') or Ends(s,'Man')
       then Result := Copy(s,1,Length(s)-2) + 'en'
       else Result := s + 's';
end;

function Split(s: String; field: Integer; separator: String): String;
var
  p: Integer;
begin
  while field > 0 do begin
    p := Pos(separator,s);
    s := Copy(s,p+1,10000);
    Dec(field);
  end;
  if Pos(separator,s) > 0
  then Result := Copy(s,1,Pos(separator,s)-1)
  else Result := s;
end;

function Split(s: String; field: Integer): String;
begin
  result := Split(s, field, '|');
end;

function Indefinite(s: String; qty: Integer): String;
begin
  if qty = 1 then begin
    if Pos(s[1], 'AEIOUÜaeiouü') > 0
    then Result := 'an ' + s
    else Result := 'a ' + s;
  end else begin
    Result := IntToStr(qty) + ' ' + Plural(s);
  end;
end;

function Definite(s: String; qty: Integer): String;
begin
  if qty > 1 then
    s := {IntToStr(qty) + ' ' +} Plural(s);
  Result := 'the ' + s;
end;

function Sick(m: Integer; s: String): String;
begin
  Result := IntToStr(m) + s; // in case I screw up
  case m of
  -5,5: Result := 'dead ' + s;
  -4,4: Result := 'comatose ' + s;
  -3,3: Result := 'crippled ' + s;
  -2,2: Result := 'sick ' + s;
  -1,1: Result := 'undernourished ' + s;
  end;
end;

function Young(m: Integer; s: String): String;
begin
  Result := IntToStr(m) + s; // in case I screw up
  case -m of
  -5,5: Result := 'foetal ' + s;
  -4,4: Result := 'baby ' + s;
  -3,3: Result := 'preadolescent ' + s;
  -2,2: Result := 'teenage ' + s;
  -1,1: Result := 'underage ' + s;
  end;
end;

function Big(m: Integer; s: String): String;
begin
  Result := s; // in case I screw up
  case m of
  1,-1: Result := 'greater ' + s;
  2,-2: Result := 'massive ' + s;
  3,-3: Result := 'enormous ' + s;
  4,-4: Result := 'giant ' + s;
  5,-5: Result := 'titanic ' + s;
  end;
end;

function Special(m: Integer; s: String): String;
begin
  Result := s; // in case I screw up
  case -m of
  1,-1:
      if Pos(' ',Result) > 0
      then Result := 'veteran ' + s
      else Result := 'Battle-' + s;
  2,-2: Result := 'cursed ' + s;
  3,-3:
      if Pos(' ',Result) > 0
      then Result := 'warrior ' + s
      else Result := 'Were-' + s;
  4,-4: Result := 'undead ' + s;
  5,-5: Result := 'demon ' + s;
  end;
end;

procedure TMainForm.InterplotCinematic;
var
  nemesis: String;
  i, s: Integer;
begin
  case Random(3) of
  0: begin
    Q('task|1|Exhausted, you arrive at a friendly oasis in a hostile land');
    Q('task|2|You greet old friends and meet new allies');
    Q('task|2|You are privy to a council of powerful do-gooders');
    Q('task|1|There is much to be done. You are chosen!');
     end;
  1: begin
    Q('task|1|Your quarry is in sight, but a mighty enemy bars your path!');
    nemesis := NamedMonster(GetI(Traits,'Level')+3);
    Q('task|4|A desperate struggle commences with ' + nemesis);
    s := Random(3);
    for i := 1 to Random(1 + Plots.Items.Count) do begin
      Inc(s, 1 + Random(2));
      case s mod 3 of
      0: Q('task|2|Locked in grim combat with ' + nemesis);
      1: Q('task|2|' + nemesis + ' seems to have the upper hand');
      2: Q('task|2|You seem to gain the advantage over ' + nemesis);
      end;
    end;
    Q('task|3|Victory! ' + nemesis + ' is slain! Exhausted, you lose conciousness');
    Q('task|2|You awake in a friendly place, but the road awaits');
      end;
  2: begin
    nemesis := ImpressiveGuy;
    Q('task|2|Oh sweet relief! You''ve reached the protection of the good ' + nemesis);
    Q('task|3|There is rejoicing, and an unnerving encouter with ' + nemesis + ' in private');
    Q('task|2|You forget your ' + BoringItem + ' and go back to get it');
    Q('task|2|What''s this!? You overhear something shocking!');
    Q('task|2|Could ' + nemesis + ' be a dirty double-dealer?');
    Q('task|3|Who can possibly be trusted with this news!? ... Oh yes, of course');
      end;
  end;
  Q('plot|1|Loading');
end;


function TMainForm.NamedMonster(level: Integer): String;
var
  lev, i: Integer;
  m: String;
begin
  lev := 0;  // shut up, compiler hint
  Result := '';  // yeah shut up
  for i := 1 to 5 do begin
    m := Pick(K.Monsters.Lines);
    if (Result = '') or (abs(level-StrToInt(Split(m,1))) < abs(level-lev)) then begin
      Result := Split(m,0);
      lev := StrToInt(Split(m,1));
    end;
  end;
  Result := GenerateName + ' the ' + Result;
end;

function TMainForm.ImpressiveGuy: String;
begin
  Result := Pick(K.ImpressiveTitles.Lines);
  case Random(2) of
  0: Result := Result + ' of the ' + Pick(K.Races.Lines);
  1: Result := Result + ' of ' + GenerateName;
  end;
end;

function TMainForm.MonsterTask(var level: Integer): String;
var
  qty, lev, i: Integer;
  monster, m1: string;
  definite: Boolean;
begin
  definite := false;
  for i := level downto 1 do begin
    if Odds(2,5) then
      Inc(level, RandSign());
  end;
  if level < 1 then level := 1;
  // level = level of puissance of opponent(s) we'll return

  if Odds(1,25) then begin
    // use an NPC every once in a while
    monster := ' ' + Pick(NewGuyForm.Race.Items);
    if Odds(1,2)
    then monster := 'passing' + monster + ' ' + Pick(NewGuyForm.Klass.Items)
    else begin
      monster := PickLow(K.Titles.Lines) + ' ' + GenerateName + ' the' + monster;
      definite := true;
    end;
    lev := level;
    monster := monster + '|' + IntToStr(level) + '|*';
  end else if (fQuest.Caption <> '') and Odds(1,4) then begin
    // use the quest monster
    monster := k.Monsters.Lines[fQuest.Tag];
    lev := StrToInt(Split(monster,1));
  end else begin
    // pick the monster out of so many random ones closest to the level we want
    monster := Pick(K.Monsters.Lines);
    lev := StrToInt(Split(monster,1));
    i := 5;
    while (i > 0) do begin // or (lev - level > 4) do begin
      m1 := Pick(K.Monsters.Lines);
      if abs(level-StrToInt(Split(m1,1))) < abs(level-lev) then begin
        monster := m1;
        lev := StrToInt(Split(monster,1));
      end;
      if i > 0 then Dec(i);
    end;
  end;

  fTask.Caption := monster;
  Result := Split(monster,0);
  fTask.Caption := 'kill|' + fTask.Caption;

  qty := 1;
  if (level-lev) > 10 then begin
      // lev is too low. multiply...
      qty := (level + Random(lev)) div max(lev,1);
      if qty < 1 then qty := 1;
      level := level div qty;
  end;

  if (level - lev) <= -10 then begin
    Result := 'imaginary ' + Result;
  end else if (level-lev) < -5 then begin
    i := 10+(level-lev);
    i := 5-Random(i+1);
    Result := Sick(i,Young((lev-level)-i,Result));
  end else if ((level-lev) < 0) and (Random(2) = 1) then begin
    Result := Sick(level-lev,Result);
  end else if ((level-lev) < 0) then begin
    Result := Young(level-lev,Result);
  end else if (level-lev) >= 10 then begin
    Result := 'messianic ' + Result;
  end else if (level-lev) > 5 then begin
    i := 10-(level-lev);
    i := 5-Random(i+1);
    Result := Big(i,Special((level-lev)-i,Result));
  end else if ((level-lev) > 0) and (Random(2) = 1) then begin
    Result := Big(level-lev,Result);
  end else if ((level-lev) > 0) then begin
    Result := Special(level-lev,Result);
  end;

  lev := level;
  level := lev * qty;

  if not definite then Result := Indefinite(Result, qty);
end;

function ProperCase(s:String):String;
begin
  Result := UpperCase(Copy(s,1,1)) + Copy(s,2,10000);
end;

function TMainForm.EquipPrice: Integer;
begin
  Result :=  5 * GetI(Traits,'Level') * GetI(Traits,'Level')
          + 10 * GetI(Traits,'Level')
          + 20;
end;

procedure TMainForm.Dequeue;
var
  s, a, old: String;
  n, l: Integer;
  si: TInventoryBack.TStringIntPair;
begin
  while TaskDone do begin
    if Split(fTask.Caption,0) = 'kill' then begin
      if Split(fTask.Caption,3) = '*' then begin
        WinItem;
      end else if Split(fTask.Caption,3) <> '' then begin
        AddInventory(LowerCase(Split(fTask.Caption,1) + ' ' + ProperCase(Split(fTask.Caption,3))),1);
        InventoryUpd;
      end;
    end else if fTask.Caption = 'buying' then begin
      // buy some equipment
      AddInventory('gold',-EquipPrice);
      InventoryUpd;
      WinEquip;
    end else if (fTask.Caption = 'market') or (fTask.Caption = 'sell') then begin
      if fTask.Caption = 'sell' then begin
        si := InventoryBack.Pop;
        InventoryUpd;
        with Encumbar do begin
          Position := InventoryBack.encum;
          Hint := IntToStr(Position) + '/' + IntToStr(Max) + ' cubits';
        end;
        Tag := si.i;
        Tag := Tag * GetI(Traits,'Level');
        if Pos(' of ', si.s) > 0 then
          Tag := Tag * (1+RandomLow(10)) * (1+RandomLow(GetI(Traits,'Level')));
        AddInventory('gold',Tag);
        InventoryUpd;
      end;
      if InventoryBack.Count > 0 then begin
        Task('Selling ' + Indefinite(InventoryBack.Items_s(0), InventoryBack.Items_i(0)), 1 * 1000);
        fTask.Caption := 'sell';
        break;
      end;
    end;
    old := fTask.Caption;
    fTask.Caption := '';
    if (fQueue.Items.Count > 0) then begin
      a := Split(fQueue.Items[0],0);
      n := StrToInt(Split(fQueue.Items[0],1));
      s := Split(fQueue.Items[0],2);
      if (a = 'task') or (a = 'plot') then begin
        if a = 'plot' then begin
          CompleteAct;
          s := 'Loading ' + Plots.Items[Plots.Items.Count-1].Caption;
        end;
        Task(s, n * 1000);
        fQueue.Items.Delete(0);
      end else begin
        raise Exception.Create('bah!');
      end;
    end else with Encumbar do if Position >= Max then begin
      Task('Heading to market to sell loot',4 * 1000);
      fTask.Caption := 'market';
    end else if (Pos('kill|',old) <= 0) and (old <> 'heading') then begin
      if InventoryBack_Gold > EquipPrice then begin
        Task('Negotiating purchase of better equipment', 5 * 1000);
        fTask.Caption := 'buying';
      end else begin
        Task('Heading to the killing fields', 4 * 1000);
        fTask.Caption := 'heading';
      end;
    end else begin
      n := GetI(Traits,'Level');
      l := n;
      s := MonsterTask(n);
      n := (2 * InventoryLabelAlsoGameStyle.Tag * n * 1000) div l;
      Task('Executing ' + s, n);
    end;
  end;
end;

function IndexOf(list: TListView; key: String): Integer;
var
  i: Integer;
begin
  for i := 0 to list.Items.Count-1 do    if list.Items.Item[i].Caption = key then begin
      Result := i;
      Exit;
    end;
  with list.Items.Add do begin
    Result := Index;
    Caption := key;
    MakeVisible(false);
  end;
end;

procedure TMainForm.Put(list: TListView; key, value: String);
begin
  Put(list, IndexOf(list,key), value);
end;

procedure TMainForm.Put(list: TListView; key: String; value: Integer);
begin
  Put(list,key,IntToStr(value));
  if key = 'STR' then
    Encumbar.Max := 10 + value;
end;

procedure TMainForm.Put(list: TListView; pos: Integer; value: String);
begin
  with list.Items.Item[pos] do begin
    if SubItems.Count < 1
    then SubItems.Add(value)
    else SubItems[0] := value;
  end;
  list.Items[pos].Selected := true;
end;

function LevelUpTime(level: Integer): Integer;  // seconds
begin
  // original levelup curve - exponential
  Result := Round((20.0 + IntPower(1.15,level)) * 60.0);

  // old levelup curve - 20 minutes per level
  //Result := 20 * level * 60;
end;

procedure TMainForm.GoButtonClick(Sender: TObject);
begin
  with ExpBar do begin
    Position := 0;
    Max := LevelUpTime(1);
  end;

  fTask.Caption := '';
  fQuest.Caption := '';
  fQueue.Items.Clear;

  Task('Loading.',2000); // that dot is spotted for later...
  Q('task|10|Experiencing an enigmatic and foreboding night vision');
  Q('task|6|Much is revealed about that wise old bastard you''d underestimated');
  Q('task|6|A shocking series of events leaves you alone and bewildered, but resolute');
  Q('task|4|Drawing upon an unexpected reserve of determination, you set out on a long and dangerous journey');
  Q('task|2|Loading');

  PlotBar.Max := 26;
  with Plots.Items.Add do begin
    Caption := 'Prologue';
    Checked := False;
  end;

  StartTimer;
  SaveGame;
  Brag('s');
end;

procedure TMainForm.OnMainFormWindowStateChange(Sender: TObject);
begin
  // wierd bug with gtk have to check prev state
  if (WindowState = wsMinimized) and (pWindowState <> wsMinimized) then begin
    TrayIcon1.Hint := 'Progress Quest'
      + ' - ' + Get(Traits,'Name')
      + ' - Level ' + Get(Traits,'Level');
    TrayIcon1.Show;
    Hide;
    ShowInTaskBar := stNever;
    pWindowState := wsMinimized;
  end;
  pWindowState := WindowState;
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
  if not AutoSized then begin
    AutoSized := True;
    TriggerAutoSizes;
  end;
end;

procedure TMainForm.InventoryData(Sender: TObject; Item: TListItem);
begin
  if Item.subItems.Count < 1 then Item.SubItems.Add('');
  if Item.Index = 0 then begin
    Item.Caption := 'Gold';
    Item.SubItems[0] := IntToStr(InventoryBack_Gold);
  end else begin
    Item.Caption := InventoryBack.Items_s(Item.Index-1);
    Item.SubItems[0] := IntToStr(InventoryBack.Items_i(Item.Index-1));
  end;
end;

procedure TMainForm.InventoryUpd;
var
  i: integer;
begin
  if Inventory.TopItem <> nil then i := Inventory.TopItem.Index else i:=0;
  if Inventory.Items.Count = 1 + InventoryBack.Count then begin
    Inventory.Update;
  end else begin
    Inventory.Items.Count := 1 + InventoryBack.Count;
  end;

  i := 0;
  i := i;
  {
  if Inventory.TopItem <> nil then i := Inventory.TopItem.Index else i:= 0;
  if i <  0 then i := 0;
  if i >= Inventory.Items.Count then i := Inventory.Items.Count - 1;
  Inventory.Items.Item[i].MakeVisible(true);
  }

end;

procedure TMainForm.AddInventory(key: string; value: integer);
{$IFDEF LOGGING}
var
  line, kkey: string;
{$ENDIF}
begin
  if (key='gold') or (key='Gold') then
    InventoryBack_Gold := InventoryBack_Gold + value
  else begin
    InventoryBack.Add(key, value);
    with Encumbar do begin
      Position := InventoryBack.encum;
      Hint := IntToStr(Position) + '/' + IntToStr(Max) + ' cubits';
    end;
  end;
  {$IFDEF LOGGING}
  kkey := key;
  if value > 0 then line := 'Gained' else line := 'Lost';
  if key = 'gold' then begin
    kkey := 'gold piece';
    if value > 0 then line := 'Got paid' else line := 'Spent';
  end;
  if value < 0 then value := -value;
  line := line + ' ' + Indefinite(kkey, value);
  Log(line);
  {$ENDIF}
end;

procedure TMainForm.OnClickTrayIcon1(Sender: TObject);
begin
  if WindowState <> wsNormal then WindowState := wsNormal;
  Show;
  ShowInTaskBar := stDefault;
  TrayIcon1.Hide;
end;

procedure TMainForm.PlotsItemChecked(Sender: TObject; Item: TListItem);
begin
  Item.Checked := not Item.Checked;
end;

procedure TMainForm.QuestsItemChecked(Sender: TObject; Item: TListItem);
begin
  Item.Checked := not Item.Checked;
end;

procedure TMainForm.WinSpell;
begin
  AddR(Spells, K.Spells.Lines[RandomLow(Min(GetI(Stats,'WIS')+GetI(Traits,'Level'),
                                            K.Spells.Lines.Count))], 1);
end;

function LPick(list: TStrings; goal: Integer): String;
var
  i, best, b1: Integer;
  s: String;
begin
  Result := Pick(list);
  for i := 1 to 5 do begin
    best := StrToInt(Split(Result,1));
    s := Pick(list);
    b1 := StrToInt(Split(s,1));
    if abs(goal-best) > abs(goal-b1) then
      Result := s;
  end;
end;

procedure TMainForm.WinEquip;
var
  posn, qual, plus, count: Integer;
  name, modifier: String;
  stuff, better, worse: TStrings;
begin
  posn := Random(Equips.Items.Count);
  Equips.Tag := posn; // remember as the "best item"
  if posn = 0 then begin
    stuff := K.Weapons.Lines;
    better := K.OffenseAttrib.Lines;
    worse := K.OffenseBad.Lines;
  end else begin
    better := K.DefenseAttrib.Lines;
    worse := K.DefenseBad.Lines;
    if posn = 1
    then stuff := K.Shields.Lines
    else stuff := K.Armors.Lines;
  end;
  name := LPick(stuff,GetI(Traits,'Level'));
  qual := StrToInt(Split(name,1));
  name := Split(name,0);
  plus := GetI(Traits,'Level') - qual;
  if plus < 0 then better := worse;
  count := 0;
  while (count < 2) and (plus <> 0) do begin
    modifier := Pick(better);
    qual := StrToInt(Split(modifier, 1));
    modifier := Split(modifier, 0);
    if Pos(modifier, name) > 0 then Break; // no repeats
    if Abs(plus) < Abs(qual) then Break; // too much
    name := modifier + ' ' + name;
    Dec(plus, qual);
    Inc(count);
  end;
  if plus <> 0 then name := IntToStr(plus) + ' ' + name;
  if plus > 0 then name := '+' + name;

  Put(Equips, posn, name);
end;

procedure TMainForm.WinStat;
var
  i: Integer;
  t: Extended;
  function Square(x: Extended): Extended; begin Result := x * x; end;
begin
  if Odds(1,2)
  then i := Random(Stats.Items.Count)
  else begin
    // favor the best stat so it will tend to clump
    t := 0;
    for i := 0 to 5 do t := t + Square(GetI(Stats,i));
    t := t * Random;
    i := -1;
    while t >= 0 do begin
      Inc(i);
      t := t- Square(GetI(Stats,i));
    end;
  end;
  Add(Stats, Stats.Items[i].Caption, 1);
end;

function TMainForm.SpecialItem: String;
begin
  Result := InterestingItem + ' of ' +
            Pick(K.ItemOfs.Lines);
end;

function TMainForm.InterestingItem: String;
begin
  Result := Pick(K.ItemAttrib.Lines) + ' ' +
            Pick(K.Specials.Lines);
end;

function TMainForm.BoringItem: String;
begin
  Result := Pick(K.BoringItems.Lines);
end;

procedure TMainForm.WinItem;
begin
  AddInventory(SpecialItem, 1);
end;

procedure TMainForm.CompleteQuest;
var
  lev, level, l, i, montag: Integer;
  m: string;
begin
  lev := 0;  // Quell stupid compiler warning
  with QuestBar do begin
    Position := 0;
    Max := 50 + Random(100);
  end;
  with Quests do begin
    if Items.Count > 0 then begin
      {$IFDEF LOGGING}
      Log('Quest completed: ' + Items[Items.Count-1].Caption);
      {$ENDIF}
      Items[Items.Count-1].Checked := True;
      case Random(4) of
        0: WinSpell;
        1: WinEquip;
        2: WinStat;
        3: WinItem;
      end;
    end;
    while Items.Count > 99 do Items.Delete(0);

    with Items.Add do begin
      case Random(5) of
        0: begin
          level := GetI(Traits,'Level');
          for i := 1 to 4 do begin
            montag := Random(K.Monsters.Lines.Count);
            m := K.Monsters.Lines[montag];
            l := StrToInt(Split(m,1));
            if (i = 1) or (abs(l - level) < abs(lev - level)) then begin
              lev := l;
              fQuest.Caption := m;
              fQuest.Tag := montag;
            end;
          end;
          Caption := 'Exterminate ' + Definite(Split(fQuest.Caption,0),2);
        end;
        1: begin
          fQuest.Caption := InterestingItem;
          Caption := 'Seek ' + Definite(fQuest.Caption,1);
          fQuest.Caption := '';
        end;
        2: begin
          fQuest.Caption := BoringItem;
          Caption := 'Deliver this ' + fQuest.Caption;
          fQuest.Caption := '';
        end;
        3: begin
          fQuest.Caption := BoringItem;
          Caption := 'Fetch me ' + Indefinite(fQuest.Caption,1);
          fQuest.Caption := '';
        end;
        4: begin
          level := GetI(Traits,'Level');
          for i := 1 to 2 do begin
            montag := Random(K.Monsters.Lines.Count);
            m := K.Monsters.Lines[montag];
            l := StrToInt(Split(m,1));
            if (i = 1) or (abs(l - level) < abs(lev - level)) then begin
              lev := l;
              fQuest.Caption := m;
            end;
          end;
          Caption := 'Placate ' + Definite(Split(fQuest.Caption,0),2);
          fQuest.Caption := '';
        end;
      end;
      {$IFDEF LOGGING}
      Log('Commencing quest: ' + Caption);
      {$ENDIF}
      Checked := False;
      MakeVisible(false);
    end;
  end;
  SaveGame;
end;

procedure TMainForm.CompleteAct;
begin
  PlotBar.Position := 0;
  with Plots do begin
    Items[Items.Count-1].Checked := True;
    PlotBar.Max := 60 * 60 * (1 + 5 * Items.Count); // 1 hr + 5/act
    PlotBar.Hint := 'Cutscene omitted';
    with Items.Add do begin
      Caption := 'Act ' + IntToRoman(Items.Count-1);
      MakeVisible(false);
      Checked := False;
      Width := Width-1;
    end;
  end;
  WinItem;
  WinEquip;
  SaveGame;
  Brag('a');
end;


{$IFDEF LOGGING}
procedure TMainForm.Log(line: String);
var
  stamp: String;
  logname: String;
  log: Text;
begin
  if FLogEvents then begin
    logname := ChangeFileExt(GameSaveName, '.log');
    DateTimeToString(stamp, '[yyyy-mm-dd hh:nn:ss]', Now);
    AssignFile(log, logname);
    if FileExists(logname) then Append(log) else Rewrite(log);
    WriteLn(log, stamp + ' ' + line);
    Flush(log);
    CloseFile(log);
  end;
end;
{$ENDIF}

procedure TMainForm.ExportCharSheet;
var
  f: TextFile;
begin
  AssignFile(f, ChangeFileExt(GameSaveName, '.sheet'));
  Rewrite(f);
  Write(f, CharSheet);
  Flush(f);
  CloseFile(f);
end;

function TMainForm.CharSheet: String;
var
  i: Integer;
  f: String;
  procedure Wr(a: String); begin f := f + a; end;
  procedure WrLn(a: String); overload; begin Wr(a + #13#10); end;
  procedure WrLn; overload; begin Wr(#13#10); end;
begin
  Wr(Get(Traits,'Name'));
  if GetHostName <> '' then
    Wr(' [' + GetHostName + ']');
  WrLn;
  WrLn(Get(Traits,'Race') + ' ' +  Get(Traits,'Class'));
  WrLn(Format('Level %d (exp. %d/%d)', [GetI(Traits,'Level'), ExpBar.Position, ExpBar.Max]));
  {$IFDEF CHEATS}
  WrLn;
  WrLn('Guild: '''+GetGuild+''', Motto: '''+GetMotto+'''');
  WrLn('Login: '''+GetLogin+''', Password: '''+GetPassword+''', Passkey: '+IntToStr(GetPasskey));
  WrLn('HostName: '''+GetHostName+''', HostAddr: '''+GetHostAddr+'''');
  {$ENDIF}
  //WrLn('Level ' + Get(Traits,'Level') + ' (' + ExpBar.Hint + ')');
  WrLn;
  with Plots do if Items.Count > 0 then
    WrLn('Plot stage: ' + Items[Items.Count-1].Caption + ' (' + PlotBar.Hint + ')');
  with Quests do if Items.Count > 0 then
    WrLn('Quest: ' + Items[Items.Count-1].Caption + ' (' + QuestBar.Hint + ')');
  WrLn;
  WrLn( 'Stats:');
  WrLn( Format('  STR%7d', [GetI(Stats,'STR')]));
  WrLn( Format('  CON%7d', [GetI(Stats,'CON')]));
  WrLn( Format('  DEX%7d', [GetI(Stats,'DEX')]));
  WrLn( Format('  INT%7d', [GetI(Stats,'INT')]));
  WrLn( Format('  WIS%7d      HP Max%7d', [GetI(Stats,'WIS'), GetI(Stats,'HP Max')]));
  WrLn( Format('  CHA%7d      MP Max%7d', [GetI(Stats,'CHA'), GetI(Stats,'MP Max')]));
  WrLn;
  WrLn( 'Equipment:');
  for i := 1 to Equips.Items.Count-1 do
    if Get(Equips,i) <> '' then
      WrLn( '  ' + LeftStr(Equips.Items[i].Caption + '            ', 12) + Get(Equips,i));
  WrLn;
  WrLn( 'Spell Book:');
  with Spells do
    for i := 1 to Items.Count-1 do
      WrLn( '  ' + Items[i].Caption + ' ' + Get(Spells,i));
  WrLn;
  WrLn( 'Inventory (' + EncumBar.Hint + '):');
  WrLn( '  ' + Indefinite('gold piece', InventoryBack_Gold));
  if InventoryBack.Count>0 then with InventoryBack do
    for i := 0 to Count-1 do
      if Pos(' of ', Items_s(i)) > 0
      then WrLn( '  ' + Definite(  Items_s(i), Items_i(i)))
      else WrLn( '  ' + Indefinite(Items_s(i), Items_i(i)));
  WrLn;
  WrLn( '-- ' + DateTimeToStr(Now));
  WrLn( '-- Progress Quest 6.2 - http://progressquest.com/');
  Result := f;
end;

procedure TMainForm.Task(caption: String; msec: Integer);
begin
  Kill.SimpleText := caption + '...';
  {$IFDEF LOGGING}
  Log(Kill.SimpleText);
  {$ENDIF}
  with TaskBar do begin
    Position := 0;
    Max := msec;
  end;
end;

procedure TMainForm.Add(list: TListView; key: String; value: Integer);
{$IFDEF LOGGING}
var line: String;
{$ENDIF}
begin
  Put(list, key, value + GetI(list,key));
  if value = 0 then Exit;

  {$IFDEF LOGGING}
  if value > 0 then line := 'Gained' else line := 'Lost';
  if key = 'Gold' then begin
    key := 'gold piece';
    if value > 0 then line := 'Got paid' else line := 'Spent';
  end;
  if value < 0 then value := -value;
  line := line + ' ' + Indefinite(key, value);
  Log(line);
  {$ENDIF}
end;

procedure TMainForm.AddR(list: TListView; key: String; value: Integer);
var
  lev: String;
begin
  lev := Get(list, key);
  if Length(lev)>0 then
    Put(list, key, IntToRoman(value + RomanToInt(Get(list,key))))
  else
    Put(list, key, 'I');
end;

function TMainForm.Get(list: TListView; key: String): String;
begin
  Result := Get(list, IndexOf(list,key));
end;

function TMainForm.Get(list: TListView; index: Integer): String;
begin
  with list.Items.Item[index] do begin
    if SubItems.Count < 1
    then Result := ''
    else Result := SubItems[0];
  end;
end;

function TMainForm.GetI(list: TListView; key: String): Integer;
begin
  Result := StrToIntDef(Get(list,key),0);
end;

function TMainForm.GetI(list: TListView; index: Integer): Integer;
begin
  Result := StrToIntDef(Get(list,index),0);
end;

function TMainForm.Sum(list: TListView): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to list.Items.Count - 1 do
    Inc(Result, GetI(list,i));
end;

procedure PutLast(list: TListView; value: String);
begin
  if list.Items.Count > 0 then
  with list.Items.Item[list.Items.Count-1] do begin
    if SubItems.Count < 1
    then SubItems.Add(value)
    else SubItems[0] := value;
  end;
end;

procedure TMainForm.LevelUp;
var
  i: Integer;
begin
  Add(Traits,'Level',1);
  Add(Stats,'HP Max', GetI(Stats,'CON') div 3 + 1 + Random(4));
  Add(Stats,'MP Max', GetI(Stats,'INT') div 3 + 1 + Random(4));
  for i := 1 to 2 do WinStat;
  WinSpell;
  with ExpBar do begin
    Position := 0;
    Max := LevelUpTime(GetI(Traits,'Level'));
  end;
  SaveGame;
  Brag('l');
  TrayIcon1.Hint := 'Progress Quest'
    + ' - ' + Get(Traits,'Name')
    + ' - Level ' + Get(Traits,'Level');
end;

function RoughTime(s: Integer): String;
begin
  if s < 120 then Result := IntToStr(s) + ' seconds'
  else if s < 60 * 120 then Result := IntToStr(s div 60) + ' minutes'
  else if s < 60 * 60 * 48 then Result := IntToStr(s div 3600) + ' hours'
  else Result := IntToStr(s div (3600 * 24)) + ' days';
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
var
  gain: Boolean;
  elapsed: DWORD;
  tick: DWORD;
begin
  gain := Pos('kill|',fTask.Caption) = 1;
  with TaskBar do begin
    if Position >= Max then begin
      if Kill.SimpleText = 'Loading....' then Max := 0;

      // gain XP / level up
      if gain then with ExpBar do if Position >= Max
      then LevelUp
      else Position := Position + TaskBar.Max div 1000;
      with ExpBar do Hint := IntToStr(Max-Position) + ' XP needed for next level';

      // advance quest
      if gain then if Plots.Items.Count > 1 then with QuestBar do if Position >= Max then begin
          CompleteQuest;
      end else if Quests.Items.Count > 0 then begin
          Position := Position + TaskBar.Max div 1000;
          Hint := IntToStr(100 * Position div Max) + '% complete';
      end;

      // advance plot
      if gain then with PlotBar do if Position >= Max
      then InterplotCinematic
      else Position := Position + TaskBar.Max div 1000;

      //Time.Caption := FormatDateTime('h:mm:ss',PlotBar.Position / (24.0 * 60 * 60));
      PlotBar.Hint := RoughTime(PlotBar.Max-PlotBar.Position) + ' remaining';
      //PlotBar.Hint := FormatDateTime('h:mm:ss" remaining"',(PlotBar.Max-PlotBar.Position) / (24.0 * 60 * 60));

      Dequeue();
    end else begin
      // compute elapsed time, try to avoid overflows
      tick := GetTickCount Mod 65536;
      // take into account previous design
      Timer1.Tag := Timer1.Tag Mod 65536;
      if tick >= Timer1.Tag then elapsed := tick - Timer1.Tag
      else elapsed := (65536 - Timer1.Tag) + tick;
      if (elapsed > 200) then elapsed := 200;

      TaskBar.Position := TaskBar.Position + elapsed;
    end;
  end;
  Timer1.Tag := GetTickCount;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  QuestBar.Position := 0;
  PlotBar.Position := 0;
  TaskBar.Position := 0;
  ExpBar.Position := 0;
  Encumbar.Position := 0;

  FReportSave := true;
  FLogEvents := false;
  FMakeBackups := true;
  FMinToTray := true;
  FExportSheets := false;

  TaskBar.DoubleBuffered := True;

  AutoSized := False;
end;

procedure TMainForm.SpeedButton1Click(Sender: TObject);
begin
  {$IFDEF CHEATS}
  TaskBar.Position := TaskBar.Max;
  {$ENDIF}
end;

function TMainForm.RollCharacter: Boolean;
var
  f: Integer;
begin
  Result := true;
  repeat
    if not NewGuyForm.Go then begin
      Result := false;
      Exit;
    end;
    Put(Traits, 'Name', NewGuyForm.Name.Text);
    if FileExistsUTF8(GameSaveName) and
          (mrNo = MessageDlg('The saved game "' + GameSaveName + '" already exists. Do you want to overwrite it?', mtWarning, [mbYes,mbNo], 0)) then begin
      // go around again
    end else begin
      f := FileCreate(GameSaveName);
      if f = -1 then begin
        ShowMessage('The thought police don''t like the name "' + GameSaveName + '". Choose a name without \\ / : * ? " < > or | in it.');
      end else begin
        FileClose(f);
        Break;
      end;
    end;
  until false;

  with NewGuyForm do begin
    Put(Traits,'Name',Name.Text);
    Put(Traits,'Race',Race.Items[Race.ItemIndex]);
    Put(Traits,'Class',Klass.Items[Klass.ItemIndex]);
    Put(Traits,'Level',1);
    Put(Stats,'STR',STR.Tag);
    Put(Stats,'CON',CON.Tag);
    Put(Stats,'DEX',DEX.Tag);
    Put(Stats,'INT',INT.Tag);
    Put(Stats,'WIS',WIS.Tag);
    Put(Stats,'CHA',CHA.Tag);
    Put(Stats,'HP Max',Random(8) + CON.Tag div 6);
    Put(Stats,'MP Max',Random(8) + INT.Tag div 6);
    Put(Equips,'Weapon','Sharp Stick');
    InventoryBack_Gold := 0;
    if InventoryBack = nil then begin
      InventoryBack := TInventoryBack.Create;
    end else begin
      InventoryBack.Clear;
    end;
    InventoryUpd;
    InventoryLabelAlsoGameStyle.Tag := 3; //GameStyle.Position;
    GoButtonClick(NewGuyForm);
  end;
end;

const
  KUsage =
    'Usage: pq [flags] [game.pq3]'#10 +
    #10 +
    'Flags:'#10 +
    '  -no-backup     Do not make a backup file when saving the game'#10 +
    {$IFDEF LOGGING}
    '  -log           Create a text log of events as they occur in the game'#10 +
    {$ENDIF}
    '  -no-report-save   Do not display the "Game saved" message when saving'#10 +
    '  -no-tray       Do not minimize to the system tray'#10 +
    '  -export        Export a text character sheet periodically'#10 +
    '  -export-only   Export a text character sheet now, then exit'#10 +
    '  -no-proxy      Do not use Internet Explorer proxy settings'#10 +
    '  -help          Display this chatter (and exit)'#10 ;

procedure TMainForm.FormShow(Sender: TObject);
var
  done, exportandexit: Boolean;
  i: Integer;
begin
  if Timer1.Enabled then Exit;
  done := false;
  exportandexit := false;
  for i := 1 to ParamCount do begin
    if ParamStr(i) = '-backup'
    then FMakeBackups := true
    {$IFDEF LOGGING}
    else if ParamStr(i) = '-log'
    then FLogEvents := true
    {$ENDIF}
    else if ParamStr(i) = '-no-report-save'
    then FReportSave := false
    else if ParamStr(i) = '-no-tray'
    then FMinToTray := false
    else if ParamStr(i) = '-export'
    then FExportSheets := true
    else if ParamStr(i) = '-export-only'
    then exportandexit := true
    else if ParamStr(i) = '-no-proxy'
    then //ProxyOK := false
    else if ParamStr(i) = '-help'
    then begin
      ShowMessage(KUsage);
      Close;
      Exit;
    end else begin
      LoadGame(ParamStr(i));
      if exportandexit then begin
        ExportCharSheet;
        Timer1.Enabled := false;
        Close;
      end;
      Exit;
    end;
  end;
  while not Done do begin
    SetHostName('');
    SetHostAddr('');
    SetLogin('');
    SetPassword('');
    case FrontForm.ShowModal of
    mrOk: begin
        done := RollCharacter;
      end;
    mrRetry: begin
      // load
        if FrontForm.OpenDialog1.Execute then begin
          LoadGame(FrontForm.OpenDialog1.Filename);
          Done := true;
        end;
      end;
    mrYesToAll: begin
        Done := ServerSelectForm.Go;
      end;
    mrCancel: begin
        Close;
        Done := true;
      end;
    end;
  end;
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  {$IFDEF CHEATS}
  LevelUp;
  {$ENDIF}
end;

procedure TMainForm.CashInClick(Sender: TObject);
begin
  {$IFDEF CHEATS}
  WinEquip;
  WinItem;
  WinSpell;
  WinStat;
  AddInventory('gold',Random(100));
  Inventory.Items.Count := InventoryBack.Count + 1;
  {$ENDIF}
end;

procedure TMainForm.FinishQuestClick(Sender: TObject);
begin
  {$IFDEF CHEATS}
  QuestBar.Position := QuestBar.Max;
  TaskBar.Position := TaskBar.Max;
  {$ENDIF}
end;

procedure TMainForm.CheatPlotClick(Sender: TObject);
begin
  {$IFDEF CHEATS}
  PlotBar.Position := PlotBar.Max;
  TaskBar.Position := TaskBar.Max;
  {$ENDIF}
end;

function TMainForm.SaveGame: Boolean;
var
  f: TFileStream;
  m, zm: TMemoryStream;
  i: Integer;
begin
  {$IFDEF LOGGING}
  Log('Saving game: ' + GameSaveName);
  {$ENDIF}
  Result := true;

  Save := TSave.Create;

  Save.Label1_Hint := Label1.Hint;

  Save.Traits_Tag := Traits.Tag;
  Save.Traits_Hint := Traits.Hint;
    with Traits do for i := 0 to Items.Count-1 do begin
    Save.Traits_Items_Captions.Add(Items[i].Caption);
    Save.Traits_Items_SubItems.Add(Items[i].Subitems[0]);
  end;

  Save.Stats_Hint := Stats.Hint;
  with Stats do for i := 0 to Items.Count-1 do begin
    Save.Stats_Items_Captions.Add(Items[i].Caption);
    Save.Stats_Items_SubItems.Add(Items[i].Subitems[0]);
  end;

  Save.ExpBar_Hint := ExpBar.Hint;
  Save.ExpBar_Min := ExpBar.Min;
  Save.ExpBar_Max := ExpBar.Max;
  Save.ExpBar_Position := ExpBar.Position;

  Save.Spells_Hint := Spells.Hint;
  with Spells do for i := 0 to Items.Count-1 do begin
    Save.Spells_Items_Captions.Add(Items[i].Caption);
    Save.Spells_Items_SubItems.Add(Items[i].Subitems[0]);
  end;

  Save.QuestBar_Hint := QuestBar.Hint;
  Save.QuestBar_Min := QuestBar.Min;
  Save.QuestBar_Max := QuestBar.Max;
  Save.QuestBar_Position := QuestBar.Position;

  with Plots do for i := 0 to Items.Count-1 do begin
    Save.Plots_Items_Captions.Add(Items[i].Caption);
  end;

  Save.PlotBar_Hint := PlotBar.Hint;
  Save.PlotBar_Min := PlotBar.Min;
  Save.PlotBar_Max := PlotBar.Max;
  Save.PlotBar_Position := PlotBar.Position;

  with Quests do for i := 0 to Items.Count-1 do begin
    Save.Quests_Items_Captions.Add(Items[i].Caption);
  end;

  Save.InventoryLabelAlsoGameStyle_Tag := InventoryLabelAlsoGameStyle.Tag;

  Save.Inventory_Tag := Inventory.Tag;
  Save.Inventory_Hint := Inventory.Hint;
  Save.Inventory_Items_Captions.Add('Gold');
  Save.Inventory_Items_Subitems.Add(IntToStr(InventoryBack_Gold));

  if InventoryBack.Count > 0 then with InventoryBack do
    for i := 0 to Count-1 do begin
      Save.Inventory_Items_Captions.Add(Items_s(i));
      Save.Inventory_Items_SubItems.Add(IntToStr(Items_i(i)));
    end;

  Save.EncumBar_Hint := EncumBar.Hint;
  Save.EncumBar_Min := EncumBar.Min;
  Save.EncumBar_Max := EncumBar.Max;
  Save.EncumBar_Position := EncumBar.Position;

  Save.Equips_Tag := Equips.Tag;
  Save.Equips_Hint := Equips.Hint;
  with Equips do for i := 0 to Items.Count-1 do begin
    Save.Equips_Items_Captions.Add(Items[i].Caption);
    Save.Equips_Items_SubItems.Add(Items[i].Subitems[0]);
  end;

  Save.fTask_Caption := fTask.Caption;

  Save.fQuest_Tag := fQuest.Tag;
  Save.fQuest_Caption := fQuest.Caption;

  Save.Kill_SimpleText := Kill.SimpleText;

  Save.TaskBar_Min := TaskBar.Min;
  Save.TaskBar_Max := TaskBar.Max;
  Save.TaskBar_Position := TaskBar.Position;
  Save.TaskBar_Step := TaskBar.Step;

  Save.Timer1_Tag := Timer1.Tag;
  Save.Timer1_Enabled := Timer1.Enabled;
  Save.Timer1_Interval := Timer1.Interval;

  m := TMemoryStream.Create;
  Save.Dump(m);
  zm := TMemoryStream.Create;
  m.Position := 0;
  Zlib(m, zm);

  if FMakeBackups then try
    if FileExists(GameSaveName) then
      DeleteFileUTF8(ChangeFileExt(GameSaveName, '.bak'));
    RenameFile(GameSaveName, ChangeFileExt(GameSaveName, '.bak'));
  except
    on Exception do begin
    end;
  end;

  try
    f := TFileStream.Create(ChangeFileExt(GameSaveName, '.lpq'), fmCreate);
    zm.Position := 0;
    f.Position := 0;
    f.CopyFrom(zm, zm.Size);
  except
    on EfCreateError do begin
      Result := false;
      Exit;
    end;
  end;

  m.Free; zm.Free; f.Free;

  Save.Destroy;
end;

procedure TMainForm.LoadGame(name: String);
var
  f: TStream;
  m, zm: TMemoryStream;
  i, c: Integer;
begin
  {$IFDEF LOGGING}
  Log('Loading game: ' + name);
  {$ENDIF}
  m := TMemoryStream.Create;
  zm := TMemoryStream.Create;
  f := TFileStream.Create(name, fmOpenRead);

  f.Position := 0;
  zm.CopyFrom(f, f.Size);

  zm.Position := 0;
  UnZlib(zm,m);

  m.Position := 0;
  Save := TSave.Create;
  if ExtractFileExt(name) = '.lpq' then Save.Load(m) else Save.LoadDfm(m);

  Traits.Items.Clear;
  Stats.Items.Clear;
  Equips.Items.Clear;
  Spells.Items.Clear;
  Plots.Items.Clear;

  if InventoryBack = nil then begin
    InventoryBack := TInventoryBack.Create;
  end else begin
    InventoryBack.Clear;
  end;
  InventoryUpd;

  Label1.Hint := Save.Label1_Hint;

  Traits.Tag := Save.Traits_Tag;
  Traits.Hint := Save.Traits_Hint;
  for i := 0 to Save.Traits_Items_Captions.Count-1 do begin
    Put(Traits, Save.Traits_Items_Captions[i], Save.Traits_Items_SubItems[i]);
  end;

  Stats.Hint := Save.Stats_Hint;
  for i := 0 to Save.Stats_Items_Captions.Count-1 do begin
    Put(Stats, Save.Stats_Items_Captions[i], Save.Stats_Items_SubItems[i]);
  end;

  ExpBar.Hint := Save.ExpBar_Hint;
  ExpBar.Min := Save.ExpBar_Min;
  ExpBar.Max := Save.ExpBar_Max;
  ExpBar.Position := Save.ExpBar_Position;

  Spells.Hint := Save.Spells_Hint;
  for i := 0 to Save.Spells_Items_Captions.Count-1 do begin
    Put(Spells, Save.Spells_Items_Captions[i], Save.Spells_Items_SubItems[i]);
  end;

  QuestBar.Hint := Save.QuestBar_Hint;
  QuestBar.Min := Save.QuestBar_Min;
  QuestBar.Max := Save.QuestBar_Max;
  QuestBar.Position := Save.QuestBar_Position;

  c := Save.Plots_Items_Captions.Count-1;
  for i := 0 to c do begin
    with Plots.Items.Add do begin
      Caption := Save.Plots_Items_Captions[i];
        if i < c then Checked := True
        else Checked := False;
    end;
  end;

  PlotBar.Hint := Save.PlotBar_Hint;
  PlotBar.Min := Save.PlotBar_Min;
  PlotBar.Max := Save.PlotBar_Max;
  PlotBar.Position := Save.PlotBar_Position;

  c := Save.Quests_Items_Captions.Count-1;
  for i := 0 to c do begin
    with Quests.Items.Add do begin
      Caption := Save.Quests_Items_Captions[i];
      if i < c then Checked := True
      else Checked := False;
    end;
  end;

  InventoryLabelAlsoGameStyle.Tag := Save.InventoryLabelAlsoGameStyle_Tag;

  Inventory.Tag := Save.Inventory_Tag;
  Inventory.Hint := Save.Inventory_Hint;
  InventoryBack_Gold := 0;

  for i := 0 to Save.Inventory_Items_Captions.Count-1 do begin
    if CompareText(Save.Inventory_Items_Captions[i], 'Gold')=0 then begin
      InventoryBack_Gold := StrToInt(Save.Inventory_Items_SubItems[i])
    end else begin
      InventoryBack.Add(Save.Inventory_Items_Captions[i], StrToInt(Save.Inventory_Items_SubItems[i]));
    end;
  end;
  InventoryUpd;

  EncumBar.Hint := Save.EncumBar_Hint;
  EncumBar.Min := Save.EncumBar_Min;
  EncumBar.Max := Save.EncumBar_Max;
  EncumBar.Position := Save.EncumBar_Position;

  Equips.Tag := Save.Equips_Tag;
  Equips.Hint := Save.Equips_Hint;
  for i := 0 to Save.Equips_Items_Captions.Count-1 do begin
    Put(Equips, Save.Equips_Items_Captions[i], Save.Equips_Items_SubItems[i]);
  end;

  fTask.Caption := Save.fTask_Caption;

  fQuest.Tag := Save.fQuest_Tag;
  fQuest.Caption := Save.fQuest_Caption;

  Kill.SimpleText := Save.Kill_SimpleText;

  TaskBar.Min := Save.TaskBar_Min;
  TaskBar.Max := Save.TaskBar_Max;
  TaskBar.Position := Save.TaskBar_Position;
  TaskBar.Step := Save.TaskBar_Step;

  Timer1.Tag := Save.Timer1_Tag;
  Timer1.Enabled := Save.Timer1_Enabled;
  Timer1.Interval := Save.Timer1_Interval;


  m.Free; zm.Free; f.Free;

  FSaveFileName := ChangeFileExt(name, '.lpq');

  Save.Destroy;

  {$IFDEF LOGGING}
  Log('Loaded game: ' + name);
  {$ENDIF}
  StartTimer;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Timer1.Enabled then begin
    Timer1.Enabled := false;
    if SaveGame then
      if FReportSave then
        ShowMessage('Game saved as ' + GameSaveName);
  end;
  FReportSave := true;
  Action := caFree;
end;

function TMainForm.GameSaveName: String;
begin
  if FSaveFileName = '' then begin
    FSaveFileName := Get(Traits,'Name');
    if GetHostName <> '' then
      FSaveFileName := FSaveFileName + ' [' + GetHostName + ']';
    FSaveFileName := FSaveFileName + kFileExt;
    FSaveFileName := ExpandFileNameUTF8(PChar(FSaveFileName));
  end;
  Result := FSaveFileName;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (ssShift in Shift) and (Key = ord('C')) then begin
    {$IFDEF CHEATS}
    Cheats.Visible := not Cheats.Visible;
    {$ENDIF}
  end;
  if (ssCtrl in Shift) and (Key = ord('A')) then begin
    ShowMessage(CharSheet);
  end;
  if GetPasskey = 0 then Exit; // no need for these things
  if (ssCtrl in Shift) and (Key = ord('B')) then begin
    Brag('b');
    OpenUrl(GetHostAddr + 'name=' + EncodeUrl(Get(Traits,'Name')));
  end;
  if (ssCtrl in Shift) and (Key = ord('M')) then begin
    SetMotto(InputBox('Progress Quest', 'Declare your motto!', GetMotto));
    Brag('m');
    OpenUrl(GetHostAddr + 'name=' + EncodeUrl(Get(Traits,'Name')));
  end;
  if (ssCtrl in Shift) and (Key = ord('G')) then begin
    SetGuild(InputBox('Progress Quest', 'Choose a guild.'#13#13'Make sure you undestand the guild rules before you join one. To learn more about guilds, visit http://progressquest.com/guilds.php', GetGuild));
    Guildify;
  end;
end;

function LFSR(pt: String; salt: Integer): Integer;
var
  k: Integer;
begin
  Result := salt;
  for k := 1 to Length(pt) do
    Result := Ord(pt[k])
          xor (Result shl 1)
          xor (1 and ((Result shr 31) xor (Result shr 5)));
  for k := 1 to 10 do
    Result := (Result shl 1)
          xor (1 and ((Result shr 31) xor (Result shr 5)));
end;


procedure TMainForm.Brag(trigger: String);
var
  url, body: string;
  best, i: Integer;
const
  flat = 1;
begin
  if FExportSheets then
    ExportCharSheet;
  if GetPasskey = 0 then Exit; // not a online game!
  url := 'cmd=b&t=' + trigger;
  with Traits do for i := 0 to Items.Count-1 do
    url := url + '&' + LowerCase(Items[i].Caption[1]) + '=' + EncodeUrl(Items[i].Subitems[0]);
  url := url + '&x=' + IntToStr(ExpBar.Position);
  url := url + '&i=' + EncodeUrl(Get(Equips,Equips.Tag));
  if Equips.Tag > 1 then url := url + '+' + Equips.Items[Equips.Tag].Caption;
  best := 0;
  if Spells.Items.Count > 0 then with Spells do begin
    for i := 1 to Items.Count-1 do
      if (i+flat) * RomanToInt(Get(Spells,i)) >
         (best+flat) * RomanToInt(Get(Spells,best)) then
        best := i;
    url := url + '&z=' + EncodeUrl(Items[best].Caption + ' ' + Get(Spells,best));
  end;
  best := 0;
  for i := 1 to 5 do
    if GetI(Stats,i) > GetI(Stats,best) then best := i;
  url := url + '&k=' + Stats.Items[best].Caption + '+' + Get(Stats,best);
  url := url + '&a=' + EncodeUrl(Plots.Items[Plots.Items.Count-1].Caption);
  url := url + '&h=' + EncodeUrl(GetHostName);
  url := url + RevString;
  url := url + '&p=' + IntToStr(LFSR(url, GetPasskey));
  url := url + '&m=' + EncodeUrl(GetMotto);
  url := AuthenticateUrl(GetHostAddr + url);
  try
    body := DownloadString(url);
    if (LowerCase(Split(body,0)) = 'report') then ShowMessage(Split(body,1));
    {$IFDEF CHEATS}
    WriteLn('Brag('+trigger+'); url: '''+url+''', body:');
    WriteLn(body);
    WriteLn('*******');
    {$ENDIF}
  except
    on EWebError do begin
      // 'ats okay.
      {$IFDEF CHEATS}
      WriteLn('Brag('+trigger+'); EWebError! url: '''+url+''', body:');
      WriteLn(body);
      WriteLn('*******');
      {$ENDIF}
    end;
  end;
end;

function TMainForm.AuthenticateUrl(url: String): String;
begin
  if (GetLogin <> '') or (GetPassword <> '') then
    Result := StuffString(url, 8, 0, GetLogin+':'+GetPassword+'@')
  else
    Result := url;
end;

procedure TMainForm.Guildify;
var
  url, s,b: string;
  i: Integer;
begin
  if GetPasskey = 0 then Exit; // not a online game!
  url := 'cmd=guild';
  with Traits do for i := 0 to Items.Count-1 do
    url := url + '&' + LowerCase(Items[i].Caption[1]) + '=' + EncodeUrl(Items[i].Subitems[0]);
  url := url + '&h=' + EncodeUrl(GetHostName);
  url := url + RevString;
  url := url + '&guild=' + EncodeUrl(GetGuild);
  url := url + '&p=' + IntToStr(LFSR(url, GetPasskey));
  url := AuthenticateUrl(GetHostAddr + url);
  try
    b := DownloadString(url);
    s := Take(b);
    if s <> '' then ShowMessage(s);
    s := Take(b);
    if s <> '' then DownloadString(s);
  except
    on EWebError do begin
      // 'ats okay.
      Abort;
    end;
  end;
end;

initialization

end.

