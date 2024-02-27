program Project3;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit3 in 'Unit3.pas' {Form3},
  uConnection in '..\api\src\features\uConnection.pas',
  util.Base64 in '..\api\src\features\util.Base64.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
