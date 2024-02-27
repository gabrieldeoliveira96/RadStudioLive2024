unit controller.ean13;

interface

uses
  System.JSON, uConnection, System.SysUtils;

const
  CURL_PREFIX_IMAGEM = 'http://www.eanpictures.com.br:9000/api/gtin';
  CURL_PREFIX_DESCRICAO = 'http://www.eanpictures.com.br:9000/api/descricao';

function GetDescricaoEan13(AEan13:string):TJSONObject;

implementation

function GetDescricaoEan13(AEan13:string):TJSONObject;
var
 LCon:TConnection;
 LResult:string;
begin

  try
    LCon:= TConnection.Create;

    if not LCon.Get(CURL_PREFIX_DESCRICAO,[AEan13],LResult) then
    begin
      exit;
    end;

    Result:= TJSONObject.Create;
    Result.AddPair('descricao',LResult);


  finally
    FreeAndNil(LCon);
  end;


end;

end.