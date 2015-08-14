{$mode objfpc}
unit InventoryBack;

interface

uses
  Sysutils, grbtree;

type
TInventoryBack = class
  type
    TStringIntPair= record
      s : string;
      i: integer;
    end;
    TStringIntPairP = ^TStringIntPair;

    TTree = specialize TRBTree<ptruint>;
  private
    var 
      list: array of TStringIntPair;
      tree: TTree;
      list_min: ptruint;
      list_length: ptruint;
      m_encum: integer;
    function CompareStringIntPair(const i1, i2: ptruint): Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure Add(const s: string; const i: Integer);
    function Pop: TStringIntPair;
    function Items(const k: ptruint): TStringIntPair;
    function Items_s(const k: ptruint): string;
    function Items_i(const k: ptruint): Integer;
    function Count: ptruint;
    property encum: Integer read m_encum;
end;

implementation

function TInventoryBack.CompareStringIntPair(const i1, i2: ptruint): Integer;
begin
  if (list[i1].s < list[i2].s) then begin
    Result := -1;
  end else if (list[i1].s = list[i2].s) then begin
    Result := 0;
  end else begin
    Result := 1;
  end
end;

constructor TInventoryBack.Create;
begin
  tree := TTree.Create(@CompareStringIntPair);
  SetLength(list,0);
  list_min := 0;
  list_length := 0;
  m_encum := 0;
end;

procedure TInventoryBack.Clear;
begin
  tree.Clear;
  SetLength(list,0);
  list_min := 0;
  list_length := 0;
  m_encum := 0;
end;


destructor TInventoryBack.Destroy;
begin
  tree.Destroy;
  SetLength(list,0);
  inherited Destroy;
end;

procedure TInventoryBack.Add(const s:string; const i:Integer);
var
  si: TStringIntPair;
  it: TTree.TRBNodeP;
  k: ptruint;
begin
  if list_min > 0 then begin
    {on any add we move everything down, this may be not efficient, but is OK for our use case}
    k := list_min;
    while k < list_length do begin
      list[k-list_min] := list[k];
      k := k + 1;
    end;
    it := tree.First;
    if it <> nil then begin
      while true do begin
        it^.k := it^.k - list_min;
        if it = tree.Last then break;
        TTree.RBInc(it);
      end;
    end;
    list_length := list_length - list_min;
    list_min := 0;
    if list_length*2 < Length(list) then
      SetLength(list, list_length*2+1);
  end;

  { generate struct, add it to the end of list }
  si.s := s;
  si.i := i;
  { extend list if we need more space }
  if Length(list)<list_length+1 then begin
    SetLength(list, 1+(list_length*3) div 2 );
  end;
  list[list_length] := si;
  list_length := list_length + 1;

  it := tree.Find(list_length-1);
  if it<>nil then begin
    list[it^.k].i := list[it^.k].i + i;
    list_length := list_length - 1;
  end else begin
    tree.Add(list_length-1);
  end;
  m_encum := m_encum + i;
end;

function TInventoryBack.Pop: TStringIntPair;
begin
  Result := list[list_min];
  m_encum := m_encum - Result.i;
  tree.Delete(tree.Find(list_min));
  list_min := list_min + 1;
end;

function TInventoryBack.Items(const k:ptruint): TStringIntPair;
begin
  Result := list[list_min+k];
end;

function TInventoryBack.Items_s(const k:ptruint): string;
begin
  Result := list[list_min+k].s;
end;

function TInventoryBack.Items_i(const k:ptruint): Integer;
begin
  Result := list[list_min+k].i;
end;

function TInventoryBack.Count: ptruint;
begin
  Result := list_length - list_min;
end;

end.
