unit Saves;

{$mode delphi}

{$UNDEF PQSAVES_DEBUG}

interface

uses
  Classes, SysUtils, fpjson, fpjsonrtti;

type TSave = class(TCollectionItem)
  private
    mLabel1_Hint: String;

    mTraits_Tag: PtrInt;
    mTraits_Hint: String;
    mTraits_Items_Captions: TStringList;
    mTraits_Items_Subitems: TStringList;

    mStats_Hint: String;
    mStats_Items_Captions: TStringList;
    mStats_Items_Subitems: TStringList;

    mExpBar_Hint: String;
    mExpBar_Min: LongInt;
    mExpBar_Max: LongInt;
    mExpBar_Position: LongInt;

    mSpells_Hint: String;
    mSpells_Items_Captions: TStringList;
    mSpells_Items_Subitems: TStringList;

    mQuestBar_Hint: String;
    mQuestBar_Min: LongInt;
    mQuestBar_Max: LongInt;
    mQuestBar_Position: LongInt;


    mPlots_Items_Captions: TStringList;

    mPlotBar_Hint: String;
    mPlotBar_Min: LongInt;
    mPlotBar_Max: LongInt;
    mPlotBar_Position: LongInt;

    mQuests_Items_Captions: TStringList;

    mInventoryLabelAlsoGameStyle_Tag: PtrInt;

    mInventory_Tag: PtrInt;
    mInventory_Items_Captions: TStringList;
    mInventory_Items_Subitems: TStringList;

    mEncumBar_Hint: String;
    mEncumBar_Min: LongInt;
    mEncumBar_Max: LongInt;
    mEncumBar_Position: LongInt;

    mEquips_Tag: PtrInt;
    mEquips_Hint: String;
    mEquips_Items_Captions: TStringList;
    mEquips_Items_Subitems: TStringList;

    mfTask_Caption: String;

    mfQuest_Tag: PtrInt;

    mKill_SimpleText: String;

    mTaskBar_Min: LongInt;
    mTaskBar_Max: LongInt;
    mTaskBar_Position: LongInt;
    mTaskBar_Step: LongInt;

    mTimer1_Tag: PtrInt;
    mTimer1_Enabled: Boolean;
    mTimer1_Interval: LongInt;
  public
    procedure Dump(f: TStream);
    procedure Load(f: TStream);
    procedure LoadDfm(f: TStream);
    constructor Create; overload;
  published

    property Label1_Hint: String read mLabel1_Hint write mLabel1_Hint;

    property Traits_Tag: PtrInt read mTraits_Tag write mTraits_Tag;
    property Traits_Hint: String read mTraits_Hint write mTraits_Hint;
    property Traits_Items_Captions: TStringList read mTraits_Items_Captions write mTraits_Items_Captions;
    property Traits_Items_Subitems: TStringList read mTraits_Items_Subitems write mTraits_Items_Subitems;

    property Stats_Hint: String read mStats_Hint write mStats_Hint;
    property Stats_Items_Captions: TStringList read mStats_Items_Captions write mStats_Items_Captions;
    property Stats_Items_Subitems: TStringList read mStats_Items_Subitems write mStats_Items_Subitems;

    property ExpBar_Hint:        String   read mExpBar_Hint        write mExpBar_Hint;
    property ExpBar_Min:         LongInt  read mExpBar_Min         write mExpBar_Min;
    property ExpBar_Max:         LongInt  read mExpBar_Max         write mExpBar_Max;
    property ExpBar_Position:    LongInt  read mExpBar_Position    write mExpBar_Position;

    property Spells_Hint: String read mSpells_Hint write mSpells_Hint;
    property Spells_Items_Captions: TStringList read mSpells_Items_Captions write mSpells_Items_Captions;
    property Spells_Items_Subitems: TStringList read mSpells_Items_Subitems write mSpells_Items_Subitems;

    property QuestBar_Hint:      String   read mQuestBar_Hint      write mQuestBar_Hint;
    property QuestBar_Min:       LongInt  read mQuestBar_Min       write mQuestBar_Min;
    property QuestBar_Max:       LongInt  read mQuestBar_Max       write mQuestBar_Max;
    property QuestBar_Position:  LongInt  read mQuestBar_Position  write mQuestBar_Position;

    property Plots_Items_Captions: TStringList read mPlots_Items_Captions write mPlots_Items_Captions;

    property PlotBar_Hint:       String   read mPlotBar_Hint       write mPlotBar_Hint;
    property PlotBar_Min:        LongInt  read mPlotBar_Min        write mPlotBar_Min;
    property PlotBar_Max:        LongInt  read mPlotBar_Max        write mPlotBar_Max;
    property PlotBar_Position:   LongInt  read mPlotBar_Position   write mPlotBar_Position;

    property Quests_Items_Captions: TStringList read mQuests_Items_Captions write mQuests_Items_Captions;

    property InventoryLabelAlsoGameStyle_Tag: PtrInt read mInventoryLabelAlsoGameStyle_Tag write mInventoryLabelAlsoGameStyle_Tag;

    property Inventory_Tag: PtrInt read mInventory_Tag write mInventory_Tag;
    property Inventory_Items_Captions: TStringList read mInventory_Items_Captions write mInventory_Items_Captions;
    property Inventory_Items_Subitems: TStringList read mInventory_Items_Subitems write mInventory_Items_Subitems;

    property EncumBar_Hint:      String   read mEncumBar_Hint      write mEncumBar_Hint;
    property EncumBar_Min:       LongInt  read mEncumBar_Min       write mEncumBar_Min;
    property EncumBar_Max:       LongInt  read mEncumBar_Max       write mEncumBar_Max;
    property EncumBar_Position:  LongInt  read mEncumBar_Position  write mEncumBar_Position;

    property Equips_Tag: PtrInt read mEquips_Tag write mEquips_Tag;
    property Equips_Hint: String read mEquips_Hint write mEquips_Hint;
    property Equips_Items_Captions: TStringList read mEquips_Items_Captions write mEquips_Items_Captions;
    property Equips_Items_Subitems: TStringList read mEquips_Items_Subitems write mEquips_Items_Subitems;

    property fTask_Caption:      String   read mfTask_Caption      write mfTask_Caption;

    property fQuest_Tag:         PtrInt  read mfQuest_Tag         write mfQuest_Tag;

    property Kill_SimpleText:    String   read mKill_SimpleText    write mKill_SimpleText;

    property TaskBar_Min:        LongInt  read mTaskBar_Min        write mTaskBar_Min;
    property TaskBar_Max:        LongInt  read mTaskBar_Max        write mTaskBar_Max;
    property TaskBar_Position:   LongInt  read mTaskBar_Position   write mTaskBar_Position;
    property TaskBar_Step:       LongInt  read mTaskBar_Step       write mTaskBar_Step;

    property Timer1_Tag:         PtrInt   read mTimer1_Tag         write mTimer1_Tag;
    property Timer1_Enabled:     Boolean  read mTimer1_Enabled     write mTimer1_Enabled;
    property Timer1_Interval:    LongInt  read mTimer1_Interval    write mTimer1_Interval;

end;

implementation
  constructor TSave.Create;
  begin
    Traits_Items_Captions := TStringList.Create;
    Traits_Items_Subitems := TStringList.Create;

    Stats_Items_Captions := TStringList.Create;
    Stats_Items_Subitems := TStringList.Create;

    Spells_Items_Captions := TStringList.Create;
    Spells_Items_Subitems := TStringList.Create;

    Plots_Items_Captions := TStringList.Create;

    Quests_Items_Captions := TStringList.Create;

    Inventory_Items_Captions := TStringList.Create;
    Inventory_Items_Subitems := TStringList.Create;

    Equips_Items_Captions := TStringList.Create;
    Equips_Items_Subitems := TStringList.Create;

  end;

  procedure TSave.Dump(f: TStream);
  var
    JS: TJSONStreamer;
    j: TJSONData;
  begin
    JS := TJSONStreamer.Create(Nil);
    j := JS.ObjectToJSON(Self);
    f.WriteAnsiString(j.FormatJSON);
  end;

  procedure TSave.Load(f: TStream);
  var
    JS: TJSONDeStreamer;
  begin
    JS := TJSONDeStreamer.Create(Nil);
    JS.JSONToObject(f.ReadAnsiString, Self);
  end;

  procedure TSave.LoadDfm(f: TStream);
  var
    Reader: TBinaryObjectReader;
    ValueType: TValueType;
    i: integer;
    v_class, v_class_type, v_name, v_value, v_type: string;
    v_binary: TMemoryStream;
    b_dword, b_size: LongInt;
    b_byte: ShortInt;
    b_string1, b_string2: String;
  begin
    {$IFDEF PQSAVES_DEBUG}
    writeln('Hello world');
    {$ENDIF}

    v_binary := TMemoryStream.Create;

    Reader := TBinaryObjectReader.Create(f, 4096);

    while True do
    try

      Reader.BeginRootComponent;

      {$IFDEF PQSAVES_DEBUG}
      Write('Starting new component ');
      {$ENDIF}
      v_class_type := Reader.ReadStr;
      v_class := UpperCase(Reader.ReadStr);
      {$IFDEF PQSAVES_DEBUG}
      WriteLn(v_class + ' : ' + v_class_type);
      {$ENDIF}

      while True do
      begin

        v_name := UpperCase(Reader.ReadStr);
        v_value := '#ignore#'; v_binary.SetSize(0);
        ValueType := Reader.NextValue;
        // check for end of component
        if ValueType = vaNull then begin
          Reader.SkipValue;
          break;
        end;
        case ValueType of
          vaInt8:         begin v_type := 'vaInt8';         Reader.ReadValue; v_value := IntToStr(Reader.ReadInt8);   end;
          vaInt16:        begin v_type := 'vaInt16';        Reader.ReadValue; v_value := IntToStr(Reader.ReadInt16);  end;
          vaInt32:        begin v_type := 'vaInt32';        Reader.ReadValue; v_value := IntToStr(Reader.ReadInt32);  end;
          vaString:       begin v_type := 'vaString';       Reader.ReadValue; v_value := Reader.ReadStr;              end;
          vaIdent:        begin v_type := 'vaIdent';        Reader.ReadValue; v_value := Reader.ReadStr;              end;
          vaUString:      begin v_type := 'vaUString';      Reader.SkipValue;                                         end;
          vaSet:          begin v_type := 'vaSet';          Reader.SkipValue;                                         end;
          vaList:         begin v_type := 'vaList';         Reader.SkipValue;                                         end;
          vaExtended:     begin v_type := 'vaExtended';     Reader.SkipValue;                                         end;
          vaFalse:        begin v_type := 'vaFalse';        Reader.SkipValue; v_value := 'false';                     end;
          vaTrue:         begin v_type := 'vaTrue';         Reader.SkipValue; v_value := 'true';                      end;
          vaCollection:   begin v_type := 'vaCollection';   Reader.SkipValue;                                         end;
          vaBinary:       begin v_type := 'vaBinary';       Reader.ReadValue; Reader.ReadBinary(v_binary);            end;
          vaLString:      begin v_type := 'vaLString';      Reader.SkipValue;                                         end;
          vaNil:          begin v_type := 'vaNil';          Reader.SkipValue;                                         end;
          vaSingle:       begin v_type := 'vaSingle';       Reader.SkipValue;                                         end;
          vaCurrency:     begin v_type := 'vaCurrency';     Reader.SkipValue;                                         end;
          vaDate:         begin v_type := 'vaDate';         Reader.SkipValue;                                         end;
          vaWString:      begin v_type := 'vaWString';      Reader.SkipValue;                                         end;
          vaInt64:        begin v_type := 'vaInt64';        Reader.SkipValue;                                         end;
          vaUTF8String:   begin v_type := 'vaUTF8String';   Reader.SkipValue;                                         end;
          vaQWord:        begin v_type := 'vaQWord';        Reader.SkipValue;                                         end;
        else              begin v_type := 'else';           Reader.SkipValue; v_value := '#WTF!!111#';                end;
        end;
        {$IFDEF PQSAVES_DEBUG}
        WriteLn(v_class + '.' + v_name + ' = ' + v_value + ' ('+v_type+')');
        {$ENDIF}

        if v_class = 'LABEL1' then begin
          if v_name = 'HINT' then Label1_Hint := v_value;
        end; // LABEL1

        if v_class = 'TRAITS' then begin
          if v_name = 'TAG' then Traits_Tag := StrToInt(v_value);
          if v_name = 'HINT' then Traits_Hint := v_value;
          if v_name = 'ITEMS.DATA' then begin
            b_dword := v_binary.ReadDWord; {$IFDEF PQSAVES_DEBUG}WriteLn(' length: ', b_dword);{$ENDIF}
            b_size  := v_binary.ReadDWord; {$IFDEF PQSAVES_DEBUG}WriteLn(' size: ', b_size);{$ENDIF}
            for i:=0 to b_size-1 do begin
              v_binary.ReadDWord; v_binary.ReadDWord; v_binary.ReadDWord; v_binary.ReadDWord; v_binary.ReadDWord;
              b_byte := v_binary.ReadByte; SetLength(b_string1, b_byte); v_binary.ReadBuffer(Pointer(b_string1)^, b_byte);
              b_byte := v_binary.ReadByte; SetLength(b_string2, b_byte); v_binary.ReadBuffer(Pointer(b_string2)^, b_byte);
              Traits_Items_Captions.Add(b_string1);
              Traits_Items_Subitems.Add(b_string2);
              {$IFDEF PQSAVES_DEBUG}
              WriteLn(b_string1 + ' : ' + b_string2);
              {$ENDIF}
            end;
          end;
        end; // TRAITS

        if v_class = 'STATS' then begin
          if v_name = 'HINT' then Stats_Hint := v_value;
          if v_name = 'ITEMS.DATA' then begin
            b_dword := v_binary.ReadDWord; {$IFDEF PQSAVES_DEBUG}WriteLn(' length: ', b_dword);{$ENDIF}
            b_size  := v_binary.ReadDWord; {$IFDEF PQSAVES_DEBUG}WriteLn(' size: ', b_size);{$ENDIF}
            for i:=0 to b_size-1 do begin
              v_binary.ReadDWord; v_binary.ReadDWord; v_binary.ReadDWord; v_binary.ReadDWord; v_binary.ReadDWord;
              b_byte := v_binary.ReadByte; SetLength(b_string1, b_byte); v_binary.ReadBuffer(Pointer(b_string1)^, b_byte);
              b_byte := v_binary.ReadByte; SetLength(b_string2, b_byte); v_binary.ReadBuffer(Pointer(b_string2)^, b_byte);
              Stats_Items_Captions.Add(b_string1);
              Stats_Items_Subitems.Add(b_string2);
              {$IFDEF PQSAVES_DEBUG}
              WriteLn(b_string1 + ' : ' + b_string2);
              {$ENDIF}
            end;
          end;
        end; // STATS

        if v_class = 'EXPBAR' then begin
          if v_name = 'HINT'       then  ExpBar_Hint :=     v_value;
          if v_name = 'MIN'        then  ExpBar_Min :=      StrToInt(v_value);
          if v_name = 'MAX'        then  ExpBar_Max :=      StrToInt(v_value);
          if v_name = 'POSITION'   then  ExpBar_Position := StrToInt(v_value);
        end; // EXPBAR

        if v_class = 'SPELLS' then begin
          if v_name = 'HINT' then Spells_Hint := v_value;
          if v_name = 'ITEMS.DATA' then begin
            b_dword := v_binary.ReadDWord; {$IFDEF PQSAVES_DEBUG}WriteLn(' length: ', b_dword);{$ENDIF}
            b_size  := v_binary.ReadDWord; {$IFDEF PQSAVES_DEBUG}WriteLn(' size: ', b_size);{$ENDIF}
            for i:=0 to b_size-1 do begin
              v_binary.ReadDWord; v_binary.ReadDWord; v_binary.ReadDWord; v_binary.ReadDWord; v_binary.ReadDWord;
              b_byte := v_binary.ReadByte; SetLength(b_string1, b_byte); v_binary.ReadBuffer(Pointer(b_string1)^, b_byte);
              b_byte := v_binary.ReadByte; SetLength(b_string2, b_byte); v_binary.ReadBuffer(Pointer(b_string2)^, b_byte);
              Spells_Items_Captions.Add(b_string1);
              Spells_Items_Subitems.Add(b_string2);
              {$IFDEF PQSAVES_DEBUG}
              WriteLn(b_string1 + ' : ' + b_string2);
              {$ENDIF}
            end;
          end;
        end; // SPELLS

        if v_class = 'QUESTBAR' then begin
          if v_name = 'HINT'       then  QuestBar_Hint :=     v_value;
          if v_name = 'MIN'        then  QuestBar_Min :=      StrToInt(v_value);
          if v_name = 'MAX'        then  QuestBar_Max :=      StrToInt(v_value);
          if v_name = 'POSITION'   then  QuestBar_Position := StrToInt(v_value);
        end; // QUESTBAR

        if v_class = 'PLOTS' then begin
          if v_name = 'ITEMS.DATA' then begin
            b_dword := v_binary.ReadDWord; {$IFDEF PQSAVES_DEBUG}WriteLn(' length: ', b_dword);{$ENDIF}
            b_size  := v_binary.ReadDWord; {$IFDEF PQSAVES_DEBUG}WriteLn(' size: ', b_size);{$ENDIF}
            for i:=0 to b_size-1 do begin
              v_binary.ReadDWord; v_binary.ReadDWord; v_binary.ReadDWord; v_binary.ReadDWord; v_binary.ReadDWord;
              b_byte := v_binary.ReadByte; SetLength(b_string1, b_byte); v_binary.ReadBuffer(Pointer(b_string1)^, b_byte);
              Plots_Items_Captions.Add(b_string1);
              {$IFDEF PQSAVES_DEBUG}
              WriteLn(b_string1);
              {$ENDIF}
            end;
          end;
        end; // PLOTS

        if v_class = 'PLOTBAR' then begin
          if v_name = 'HINT'       then  PlotBar_Hint :=     v_value;
          if v_name = 'MIN'        then  PlotBar_Min :=      StrToInt(v_value);
          if v_name = 'MAX'        then  PlotBar_Max :=      StrToInt(v_value);
          if v_name = 'POSITION'   then  PlotBar_Position := StrToInt(v_value);
        end; // PLOTTBAR

        if v_class = 'QUESTS' then begin
          if v_name = 'ITEMS.DATA' then begin
            b_dword := v_binary.ReadDWord; {$IFDEF PQSAVES_DEBUG}WriteLn(' length: ', b_dword);{$ENDIF}
            b_size  := v_binary.ReadDWord; {$IFDEF PQSAVES_DEBUG}WriteLn(' size: ', b_size);{$ENDIF}
            for i:=0 to b_size-1 do begin
              v_binary.ReadDWord; v_binary.ReadDWord; v_binary.ReadDWord; v_binary.ReadDWord; v_binary.ReadDWord;
              b_byte := v_binary.ReadByte; SetLength(b_string1, b_byte); v_binary.ReadBuffer(Pointer(b_string1)^, b_byte);
              Quests_Items_Captions.Add(b_string1);
              {$IFDEF PQSAVES_DEBUG}
              WriteLn(b_string1);
              {$ENDIF}
            end;
          end;
        end; // QUESTS

        if v_class = 'INVENTORYLABELALSOGAMESTYLE' then begin
          if v_name = 'TAG'   then  InventoryLabelAlsoGameStyle_Tag := StrToInt(v_value);
        end; // INVENTORYLABELALSOGAMESTYLE

        if v_class = 'INVENTORY' then begin
          if v_name = 'TAG' then Inventory_Tag := StrToInt(v_value);
          if v_name = 'ITEMS.DATA' then begin
            b_dword := v_binary.ReadDWord; {$IFDEF PQSAVES_DEBUG}WriteLn(' length: ', b_dword);{$ENDIF}
            b_size  := v_binary.ReadDWord; {$IFDEF PQSAVES_DEBUG}WriteLn(' size: ', b_size);{$ENDIF}
            for i:=0 to b_size-1 do begin
              v_binary.ReadDWord; v_binary.ReadDWord; v_binary.ReadDWord; v_binary.ReadDWord; v_binary.ReadDWord;
              b_byte := v_binary.ReadByte; SetLength(b_string1, b_byte); v_binary.ReadBuffer(Pointer(b_string1)^, b_byte);
              b_byte := v_binary.ReadByte; SetLength(b_string2, b_byte); v_binary.ReadBuffer(Pointer(b_string2)^, b_byte);
              Inventory_Items_Captions.Add(b_string1);
              Inventory_Items_Subitems.Add(b_string2);
              {$IFDEF PQSAVES_DEBUG}
              WriteLn(b_string1 + ' : ' + b_string2);
              {$ENDIF}
            end;
          end;
        end; // INVENTORY

        if v_class = 'ENCUMBAR' then begin
          if v_name = 'HINT'       then  EncumBar_Hint :=     v_value;
          if v_name = 'MIN'        then  EncumBar_Min :=      StrToInt(v_value);
          if v_name = 'MAX'        then  EncumBar_Max :=      StrToInt(v_value);
          if v_name = 'POSITION'   then  EncumBar_Position := StrToInt(v_value);
        end; // ENCUMBAR

        if v_class = 'EQUIPS' then begin
          if v_name = 'TAG' then Equips_Tag := StrToInt(v_value);
          if v_name = 'HINT' then Equips_Hint := v_value;
          if v_name = 'ITEMS.DATA' then begin
            b_dword := v_binary.ReadDWord; {$IFDEF PQSAVES_DEBUG}WriteLn(' length: ', b_dword);{$ENDIF}
            b_size  := v_binary.ReadDWord; {$IFDEF PQSAVES_DEBUG}WriteLn(' size: ', b_size);{$ENDIF}
            for i:=0 to b_size-1 do begin
              v_binary.ReadDWord; v_binary.ReadDWord; v_binary.ReadDWord; v_binary.ReadDWord; v_binary.ReadDWord;
              b_byte := v_binary.ReadByte; SetLength(b_string1, b_byte); v_binary.ReadBuffer(Pointer(b_string1)^, b_byte);
              b_byte := v_binary.ReadByte; SetLength(b_string2, b_byte); v_binary.ReadBuffer(Pointer(b_string2)^, b_byte);
              Equips_Items_Captions.Add(b_string1);
              Equips_Items_Subitems.Add(b_string2);
              {$IFDEF PQSAVES_DEBUG}
              WriteLn(b_string1 + ' : ' + b_string2);
              {$ENDIF}
            end;
          end;
        end; // EQUIPS

        if v_class = 'FTASK' then begin
          if v_name = 'CAPTION'   then  fTask_Caption := v_value;
        end; // FTASK

        if v_class = 'FQUEST' then begin
          if v_name = 'TAG'   then  fQuest_Tag := StrToInt(v_value);
        end; // FQUEST

        if v_class = 'KILL' then begin
          if v_name = 'SIMPLETEXT'   then  Kill_SimpleText := v_value;
        end; // KILL

        if v_class = 'TASKBAR' then begin
          if v_name = 'MIN'        then  TaskBar_Min :=      StrToInt(v_value);
          if v_name = 'MAX'        then  TaskBar_Max :=      StrToInt(v_value);
          if v_name = 'POSITION'   then  TaskBar_Position := StrToInt(v_value);
          if v_name = 'STEP'       then  TaskBar_Step :=     StrToInt(v_value);
        end; // TASKBAR

        if v_class = 'TIMER1' then begin
          if v_name = 'TAG'        then  Timer1_Tag :=       StrToInt(v_value);
          if v_name = 'Enabled'    then
            if v_value = 'true' then Timer1_Enabled := True else Timer1_Enabled := False;
          if v_name = 'INTERVAL'   then  Timer1_Interval :=  StrToInt(v_value);
        end; // TIMER1

      end;
    except
      on E: Exception do break;
    end;
    {$IFDEF PQSAVES_DEBUG}
    writeln('Done, world!');
    {$ENDIF}
    v_class_type := v_class_type; v_type := v_type; b_dword := b_dword; // suppressing compiler warnings
  end;


end.

