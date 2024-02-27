unit openAi;

interface

uses
  OpenAIClient, OpenAIDtos, System.SysUtils, system.JSON;

function GerarImagem(AProduto: string; Atamanho: string = '512x512'):string;

implementation

function GerarImagem(AProduto: string; Atamanho: string = '512x512'):string;
var
 LRequest:TCreateImageRequest;
 LResponse:TImagesResponse;
 LClient:IOpenAIClient;
 LString:string;
 LJo:TJSONObject;
begin
  try

    LClient:= TOpenAIClient.Create;
    LClient.Config.AccessToken:= CAPI_KEY;

    LRequest:= TCreateImageRequest.Create;


    LJo:= TJSONObject.ParseJSONValue(AProduto) as TJSONObject;


    LString:= LJo.GetValue<string>('descricao');

    LRequest.Prompt:= 'generate a good quality image for the '+LString +' product';
    LRequest.Size:= Atamanho;
    LRequest.N:= 1;
    LRequest.ResponseFormat:= 'b64_json';
    LResponse:= LClient.OpenAI.CreateImage(LRequest);
    if Assigned(LResponse.Data) and (LResponse.Data.count > 0) then
      Result:= LResponse.Data.items[0].B64Json
    else
    Result:= '';

  finally

    FreeAndNil(LRequest);
    FreeAndNil(LResponse);


  end;





end;

end.
