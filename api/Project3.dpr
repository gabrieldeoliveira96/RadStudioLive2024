program Project3;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  Horse.Jhonson,
  System.JSON,
  controller.ean13 in 'src\controller\controller.ean13.pas',
  uConnection in 'src\features\uConnection.pas',
  openAi in 'src\features\openAi.pas';

begin

  THorse.Use(Jhonson);

  THorse.Get('/descricao/:ean13',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      res.Send<TJSONObject>(controller.ean13.GetDescricaoEan13(req.Params.Items['ean13'])
      ).Status(200);

    end);

  THorse.Post('/img',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      res.Send(openAi.GerarImagem(req.Body)).Status(200);

    end);


  THorse.Get('/ping',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      Res.Send('pong');
    end);

  THorse.Listen(9000);
end.
