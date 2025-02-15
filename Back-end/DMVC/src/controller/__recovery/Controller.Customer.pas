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


 {$Region 'Chama o Gemini'}
  RESTClient1.BaseURL := URLBase + Key;
  CaminhoExecutavel := ExtractFilePath(Application.ExeName);

  TVariaveisAmbiente.LerVariaveisDB(Database, UserName, Password, DriverID);

  Prompt      := TStringList.Create;
  Complemento := TStringList.Create;
  JSONBody := TJSONObject.Create;
  try
    Prompt.LoadFromFile(CaminhoExecutavel + '\prompt.txt');
    Complemento.LoadFromFile(CaminhoExecutavel + '\complemento.txt');

    Prompt.Add(complemento.Text);
    Prompt.Add(edtPergunta.Text);

    ContentsArray := TJSONArray.Create;
    PartsArray := TJSONArray.Create;
    PartsArray.AddElement(TJSONObject.Create.AddPair('text', Prompt.Text));
    ContentsArray.AddElement(TJSONObject.Create.AddPair('parts', PartsArray));
    JSONBody.AddPair('contents', ContentsArray);

    RESTRequest1.Params.ParameterByName('body4E6B89C7FD1E4198BD64C5BE65C5188E').Value := JSONBody.ToString;
  finally
    JSONBody.Free;
    Prompt.Free;
    Complemento.Free;
  end;

  RESTRequest1.Execute;
 {$EndRegion}




  Render(Response);
end;

end.
