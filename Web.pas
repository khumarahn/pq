unit Web;

{$MODE Delphi}

interface

uses SysUtils, fphttpclient;

type
  EWebError = Class(Exception);

function DownloadString(url: String): String;

implementation

function DownloadString(url: string): string;
begin
  Result := '';
  With TFPHttpClient.Create(Nil) do
    try
      Result := Get(url); Free;
  except on Exception do begin
      Free;
      raise EWebError.Create('ConnectionError');
    end;
  end;
end;

end.