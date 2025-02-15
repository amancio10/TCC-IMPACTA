unit Controller.Customer;

interface

uses
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Serializer.Commons,
  System.Generics.Collections;

type
  [MVCNameCase(ncCamelCase)]
  TAPIDados = class
  Private
    FPergunta: string;
  Public
    property Pergunta: string read FPergunta write FPergunta;
  end;

  [MVCPath('/api')]
  TCustomer = class(TMVCController)
  public
    //
  protected
    procedure OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean); override;
    procedure OnAfterAction(Context: TWebContext; const AActionName: string); override;

  public
    [MVCPath('/perguntar')]
    [MVCHTTPMethod([httpPOST])]
    procedure CreateAPIDados([MVCFromBody] APIDados: TAPIDados);
  end;

implementation

uses
  System.SysUtils,
  MVCFramework.Logger,
  System.StrUtils,
  JsonDataObjects,
  System.JSON;

procedure TCustomer.OnAfterAction(Context: TWebContext; const AActionName: string);
begin
  inherited;
end;

procedure TCustomer.OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean);
begin
  inherited;
end;

procedure TCustomer.CreateAPIDados([MVCFromBody] APIDados: TAPIDados);
var
  Response: TJSONObject;
begin
  Response := TJSONObject.Create;

  Response.AddPair('status', 'sucesso');
  Response.AddPair('mensagem', 'Recebido com sucesso!');
  Response.AddPair('pergunta', APIDados.Pergunta);

  Render(Response);
end;

end.
