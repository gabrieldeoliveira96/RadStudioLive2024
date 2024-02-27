unit uConnection;

interface

uses System.SysUtils, System.Classes, REST.Types, REST.Client, System.JSON;

type
  TConnection = class
    private
     FRESTClient: TRESTClient;
     FRESTRequest: TRESTRequest;
     FRESTResponse: TRESTResponse;
    public
     constructor Create;
     destructor Destroy;
     function Post(AUrl:string; AParameter: array of string; ABody:TJSONObject; out AResult:string): Boolean; overload;
     function Post(AUrl:string; AParameter: array of string; ABody:TJSONArray; out AResult:string): Boolean; overload;
     function Get(AUrl:string; AParameter: array of string; out AResult:string): Boolean; overload;
     function Get(AUrl:string; AParameter: array of string; out AResult:TBytes; out AHeader: TStrings): Boolean; overload;
     function Put(AUrl:string; AParameter: array of string; ABody:TJSONObject; out AResult:string): Boolean;
     function Delete(AUrl:string; AParameter: array of string; ABody:TJSONObject; out AResult:string): Boolean; overload;
     function Delete(AUrl:string; AParameter: array of string; out AResult:string): Boolean; overload;
  end;

implementation

function TConnection.Post(AUrl:string; AParameter: array of string; ABody:TJSONObject; out AResult:string): Boolean;
var
 LUrl:string;
begin

  FRESTRequest.Client:= FRESTClient;
  FRESTRequest.Response:= FRESTResponse;
  try
    LUrl:= AUrl;
    for var i := 0 to pred(length(AParameter)) do
      LUrl := LUrl + '/' + AParameter[i];

    FRESTRequest.ClearBody;
    FRESTRequest.AddBody(ABody);

    FRESTClient.BaseURL := LUrl;
    FRESTRequest.Method := rmPOST;
    FRESTRequest.Execute;

    AResult:= FRESTResponse.Content;
    Result:= FRESTResponse.StatusCode = 200;

  except
    on e: exception do
    begin
      Result := false;
    end;

  end;
end;

constructor TConnection.Create;
begin
  FRESTClient:= TRESTClient.Create(nil);
  FRESTRequest:= TRESTRequest.Create(nil);
  FRESTResponse:= TRESTResponse.Create(nil);

end;

function TConnection.Delete(AUrl: string; AParameter: array of string;
  ABody: TJSONObject; out AResult: string): Boolean;
var
 LUrl:string;
begin

  FRESTRequest.Client:= FRESTClient;
  FRESTRequest.Response:= FRESTResponse;
  try
    LUrl:= AUrl;
    for var i := 0 to pred(length(AParameter)) do
      LUrl := LUrl + '/' + AParameter[i];

    FRESTRequest.ClearBody;
    FRESTRequest.AddBody(ABody);

    FRESTClient.BaseURL := LUrl;
    FRESTRequest.Method := rmDELETE;
    FRESTRequest.Execute;

    AResult:= FRESTResponse.Content;
    Result:= FRESTResponse.StatusCode = 200;

  except
    on e: exception do
    begin
      Result := false;
    end;

  end;
end;

destructor TConnection.Destroy;
begin
  FreeAndNil(FRESTClient);
  FreeAndNil(FRESTRequest);
  FreeAndNil(FRESTResponse);
end;

function TConnection.Get(AUrl: string; AParameter: array of string;
  out AResult: TBytes; out AHeader: TStrings): Boolean;
var
  LUrl:string;
begin
  FRESTRequest.Client:= FRESTClient;
  FRESTRequest.Response:= FRESTResponse;
  try
    LUrl:= AUrl;
    for var i := 0 to pred(length(AParameter)) do
      LUrl := LUrl + '/' + AParameter[i];

    FRESTClient.BaseURL := LUrl;
    FRESTClient.FallbackCharsetEncoding := '';
    FRESTRequest.Method := rmGET;
    FRESTRequest.SynchronizedEvents := False;
    FRESTRequest.Execute;

    AResult:= FRESTResponse.RawBytes;
    AHeader:= FRESTResponse.Headers;
    Result:= FRESTResponse.StatusCode = 200;

  except
    on e: exception do
    begin
      Result := false;
    end;

  end;

end;

function TConnection.Get(AUrl:string; AParameter: array of string; out AResult:string): Boolean;
var
 LUrl:string;
 LBytes:TBytes;
 LResponseStream: TStringStream;
begin

  FRESTRequest.Client:= FRESTClient;
  FRESTRequest.Response:= FRESTResponse;
  try
    LUrl:= AUrl;
    for var i := 0 to pred(length(AParameter)) do
      LUrl := LUrl + '/' + AParameter[i];

    FRESTClient.BaseURL := LUrl;
    FRESTClient.FallbackCharsetEncoding := '';
    FRESTRequest.Method := rmGET;
    FRESTRequest.SynchronizedEvents := False;
    FRESTRequest.Timeout := 10000;
    FRESTRequest.Execute;

    LBytes:= FRESTResponse.RawBytes;

    LResponseStream := TStringStream.Create;
    try
      LResponseStream.WriteData(LBytes, Length(LBytes));
      LResponseStream.Position := 0;

      AResult:= LResponseStream.DataString;

    finally
      FreeAndNil(LResponseStream)
    end;


    Result:= FRESTResponse.StatusCode = 200;

  except
    on e: exception do
    begin
      Result := false;
    end;

  end;

end;


function TConnection.Post(AUrl: string; AParameter: array of string;
  ABody: TJSONArray; out AResult: string): Boolean;
var
 LUrl:string;
begin

  FRESTRequest.Client:= FRESTClient;
  FRESTRequest.Response:= FRESTResponse;
  try
    LUrl:= AUrl;
    for var i := 0 to pred(length(AParameter)) do
      LUrl := LUrl + '/' + AParameter[i];

    FRESTRequest.ClearBody;
    FRESTRequest.AddBody(ABody.ToString,TRESTContentType.ctAPPLICATION_JSON);

    FRESTClient.BaseURL := LUrl;
    FRESTRequest.Method := rmPOST;
    FRESTRequest.Execute;

    AResult:= FRESTResponse.Content;
    Result:= FRESTResponse.StatusCode = 200;

  except
    on e: exception do
    begin
      Result := false;
    end;

  end;
end;


function TConnection.Put(AUrl: string; AParameter: array of string;
  ABody: TJSONObject; out AResult: string): Boolean;
var
 LUrl:string;
begin

  FRESTRequest.Client:= FRESTClient;
  FRESTRequest.Response:= FRESTResponse;
  try
    LUrl:= AUrl;
    for var i := 0 to pred(length(AParameter)) do
      LUrl := LUrl + '/' + AParameter[i];

    FRESTRequest.ClearBody;
    FRESTRequest.AddBody(ABody);

    FRESTClient.BaseURL := LUrl;
    FRESTRequest.Method := rmPUT;
    FRESTRequest.Execute;

    AResult:= FRESTResponse.Content;
    Result:= FRESTResponse.StatusCode = 200;

  except
    on e: exception do
    begin
      Result := false;
    end;

  end;

end;


function TConnection.Delete(AUrl: string; AParameter: array of string;
  out AResult: string): Boolean;
var
 LUrl:string;
begin

  FRESTRequest.Client:= FRESTClient;
  FRESTRequest.Response:= FRESTResponse;
  try
    LUrl:= AUrl;
    for var i := 0 to pred(length(AParameter)) do
      LUrl := LUrl + '/' + AParameter[i];

    FRESTRequest.ClearBody;

    FRESTClient.BaseURL := LUrl;
    FRESTRequest.Method := rmDELETE;
    FRESTRequest.Execute;

    AResult:= FRESTResponse.Content;
    Result:= FRESTResponse.StatusCode = 200;

  except
    on e: exception do
    begin
      Result := false;
    end;

  end;

end;


end.
