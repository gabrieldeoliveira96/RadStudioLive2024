{** Douglas Colombo
  * Classe de conversão de arquivos em texto
  * e de Texto em Arquivos, BASE64
**}

unit util.Base64;

interface

uses System.Classes, System.netEncoding, FMX.Graphics;

procedure Base64ToFile(Arquivo, caminhoSalvar : String);
function Base64ToStream(imagem : String) : TMemoryStream;
function FileToBase64(Arquivo : String) : String;
function StreamToBase64(STream : TMemoryStream) : String;
function Base64ToBitmap(imagem : String) : TBitmap;
function BitmapToBase64(imagem : TBitmap) : String;

function Base64FromBitmap(Bitmap: TBitmap): string;
function Base64FromFile(Arquivo : string):string;

implementation

uses
  System.SysUtils;

procedure Base64ToFile(Arquivo, caminhoSalvar : String);
Var sTream : TMemoryStream;
begin
  Try
    if not (DirectoryExists(ExtractFilePath(caminhoSalvar))) then
       ForceDirectories(ExtractFilePath(caminhoSalvar));

    sTream := Base64ToStream(Arquivo);
    sTream.SaveToFile(caminhoSalvar);
  Finally
    sTream.free;
    sTream:=nil;
  End;
end;

function Base64ToStream(imagem: String): TMemoryStream;
var Base64 : TBase64Encoding;
    bytes : tBytes;
begin
  Try
    Base64 := TBase64Encoding.Create;
    bytes  := Base64.DecodeStringToBytes(imagem);
    result := TBytesStream.Create(bytes);
    result.Position := 0; {ANDROID 64 BITS}
    //result.Seek(0, 0); {ANDROID 32 BITS SOMENTE}
  Finally
    Base64.Free;
    Base64:=nil;
    SetLength(bytes, 0);
  End;
end;

function FileToBase64(Arquivo : String): String;
var
  sTream : tMemoryStream;

begin
  if (Trim(Arquivo) <> '') then
  begin
     sTream := TMemoryStream.Create;
     Try
       sTream.LoadFromFile(Arquivo);
       result := StreamToBase64(sTream);
     Finally
       Stream.Free;
       Stream:=nil;
     End;
  end else
     result := '';
end;

function Base64FromFile(Arquivo : string):string;
var
  Input: TBytesStream;
  Output: TStringStream;
  Encoding: TBase64Encoding;
begin
  Input := TBytesStream.Create;
  try
    Input.LoadFromFile(Arquivo);
    Input.Position := 0;
    Output := TStringStream.Create('', TEncoding.ASCII);
    try
      Encoding := TBase64Encoding.Create(0);
      try
        Encoding.Encode(Input, Output);
        Result := Output.DataString;
      finally
        Encoding.Free;
      end;
    finally
      Output.Free;
    end;
  finally
    Input.Free;
  end;
end;

function StreamToBase64(STream: TMemoryStream): String;
Var Base64 : tBase64Encoding;
begin
  Try
    {$IFDEF ANDROID64}
    Stream.Position := 0; {ANDROID 64 BITS}
    {$ENDIF}
    {$IFDEF ANDROID32}
    Stream.Seek(0, 0); {ANDROID 32 BITS SOMENTE}
    {$ENDIF}
    Base64 := TBase64Encoding.Create;
    Result := Base64.EncodeBytesToString(sTream.Memory, sTream.Size);
  Finally
    Base64.Free;
    Base64:=nil;
  End;
end;

function Base64ToBitmap(imagem: String): TBitmap;
Var sTream : TMemoryStream;
begin
  if (trim(imagem) <> '') then
  begin
     Try
        sTream := Base64ToStream(imagem);
        result := TBitmap.CreateFromStream(sTream);
     Finally
        sTream.DisposeOf;
        sTream := nil;
     End;
  end;
end;


function BitmapToBase64(imagem: TBitmap): String;
Var sTream : TMemoryStream;
begin
  result := '';

  if not (imagem.IsEmpty) then
  begin
     Try
        sTream := TMemoryStream.Create;
        imagem.SaveToStream(sTream);
        result := StreamToBase64(sTream);
        sTream.DisposeOf;
        sTream := nil;
     Except
     End;

  end;
end;

function Base64FromBitmap(Bitmap: TBitmap): string;
var
  Input: TBytesStream;
  Output: TStringStream;
  Encoding: TBase64Encoding;
begin
  Input := TBytesStream.Create;
  try
    Bitmap.SaveToStream(Input);
    Input.Position := 0;
    Output := TStringStream.Create('', TEncoding.ASCII);
    try
      Encoding := TBase64Encoding.Create(0);
      try
        Encoding.Encode(Input, Output);
        Result := Output.DataString;
      finally
        Encoding.Free;
      end;
    finally
      Output.Free;
    end;
  finally
    Input.Free;
  end;
end;

end.
