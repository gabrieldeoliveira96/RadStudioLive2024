unit Unit3;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo, FMX.Objects, FMX.StdCtrls, FMX.Controls.Presentation,
  FMX.Edit, uConnection, system.JSON, System.NetEncoding, util.Base64;

type
  TForm3 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Image1: TImage;
    Memo1: TMemo;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.fmx}

procedure TForm3.Button1Click(Sender: TObject);
var
 LCon:TConnection;
 LResult:string;
 Ljo:TJSONObject;
begin

  LCon:= TConnection.Create;
  try

    if not LCon.Get('http://localhost:9000/descricao/',[Edit1.Text],LResult) then
      exit;

    Ljo:= TJSONObject.ParseJSONValue(LResult) as TJSONObject;


    Memo1.Lines.Clear;
    Memo1.Lines.Add(Ljo.GetValue<string>('descricao'));

  finally
    FreeAndNil(LCon);
  end;

end;

procedure TForm3.Button2Click(Sender: TObject);
var
 LCon:TConnection;
 LResult:string;
 LJo:TJSONObject;
 LBase64:string;
 LByte:TMemoryStream;
begin

  LCon:= TConnection.Create;
  try
    LJo:= TJSONObject.Create;
    LJo.AddPair('descricao',Memo1.Text);


    if not LCon.Post('http://localhost:9000/img',[],LJo,LResult) then
      exit;

    Image1.Bitmap:= Base64ToBitmap(LResult);

  finally
    FreeAndNil(LCon);
  end;


end;

end.
