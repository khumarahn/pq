{ 
  copyright (c) Udo Schmal 2014, 
  Alexey Korepanov, 2015 
}

unit StreamZlib;
{$ifdef fpc}
  {$mode objfpc}
{$endif}
{$H+}

interface

uses
  Classes, SysUtils, PasZLib, zbase;

type
  TZCompressionLevel = (zcNone, zcFastest, zcDefault, zcMax);

const
  RAW_WBITS = -MAX_WBITS; // deflate raw stream (without any header)

  ZLevels: array[TZCompressionLevel] of Shortint = (
    Z_NO_COMPRESSION,
    Z_BEST_SPEED,
    Z_DEFAULT_COMPRESSION,
    Z_BEST_COMPRESSION
  );

function deflate(inStream, outStream: TMemoryStream; level: TZCompressionLevel = zcDefault): boolean;
function inflate(inStream, OutStream: TMemoryStream): boolean;
function ZLib(inStream, outStream: TMemoryStream; level: TZCompressionLevel = zcDefault): boolean;
function UnZlib(inStream, outStream: TMemoryStream): boolean;

implementation

// deflate raw stream
function deflate(inStream, outStream: TMemoryStream; level: TZCompressionLevel = zcDefault): boolean;
var
  zstream: z_stream;
  headerSize: longword;
begin
  result := false;
  headerSize := outStream.Position;
  zstream.next_in := inStream.Memory;
  zstream.avail_in := inStream.Size;
  outStream.SetSize(headerSize + ((inStream.Size + (inStream.Size div 10) + 12) + 255) and not 255);
  zstream.next_out := outStream.Memory + headerSize;
  zstream.avail_out := outStream.Size - headerSize;
  if paszlib.deflateInit2(zstream, ZLevels[level], Z_DEFLATED, RAW_WBITS, 8, Z_DEFAULT_STRATEGY) < Z_OK then Exit;
  paszlib.deflate(zstream, Z_FINISH);
  result := not (deflateEnd(zstream) < 0);
  outStream.SetSize(zstream.total_out + headerSize);
  outStream.Position := zstream.total_out + headerSize;
end;

// inflate raw stream
function inflate(inStream, OutStream: TMemoryStream): boolean;
var
  zstream: z_stream;
  headerSize, delta: longword;
begin
  headerSize := inStream.Position;
  zstream.next_in := inStream.Memory + headerSize;
  zstream.avail_in := inStream.Size - headerSize;
  delta := (inStream.Size + 255) and not 255;
  if outStream.Size = 0 then
    outStream.SetSize(delta);
  zstream.next_out := outStream.Memory;
  zstream.avail_out := outStream.Size;
  if paszlib.inflateInit2(zstream, RAW_WBITS) < 0 then Exit;
  while paszlib.inflate(zstream, Z_NO_FLUSH) = Z_OK do
  begin
    outStream.SetSize(outStream.Size + delta);
    zstream.next_out := outStream.Memory + zstream.total_out;
    zstream.avail_out := delta;
  end;
  result := not (inflateEnd(zstream) < 0);
  outStream.SetSize(zstream.total_out);
end;


function ZLib(inStream, outStream: TMemoryStream; level: TZCompressionLevel = zcDefault): boolean;
var adler: longword;
begin
  inStream.Position := 0;
  outStream.Position := 0;
  outStream.WriteWord($9c78); //ZLib Header
  adler := adler32(0, Z_NULL, 0);
  adler := adler32(adler, Pointer(inStream.Memory), inStream.Size);
  result := deflate(inStream, outStream, level);
  if result then // add adler32 checksum
    outStream.WriteDWord(SwapEndian(adler)); // adler32 checksum
  outStream.Position := 0;
end;

function UnZlib(inStream, outStream: TMemoryStream): boolean;
var
  hdr, adler, adler32in: longword;
begin
  result := false;
  inStream.Position := 0;
  outStream.Position := 0;
  hdr := inStream.ReadDWord;
  if (hdr and $00009C78) = $00009C78 then // zlib header
  begin
    // first byte is start of deflate header
    inStream.Seek(-4, soFromEnd);
    adler32in := SwapEndian(inStream.ReadDWord);
    // cut the 4 byte adler32 code
    inStream.Size := inStream.Size-4; 
    outStream.SetSize(0);
    // jump over header
    inStream.Position := 2;
    result := inflate(inStream, outStream);
    // check checksum
    if result then 
    begin
      adler := adler32(0, Z_NULL, 0);
      adler := adler32(adler, Pointer(outStream.Memory), outStream.Size);
    end;
    result := (adler = adler32in);
  end
  else
  begin
    result := false;
  end;
  inStream.Position := 0;
  outStream.Position := 0;
end;

end.
