unit Controller.DmConexao;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.ConsoleUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.VCLUI.Wait, REST.Types, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, JsonDataObjects,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat;

type
  TDMConexao = class(TDataModule)
    FDConnection: TFDConnection;
    Query: TFDQuery;
    RESTRequest: TRESTRequest;
    RESTClient: TRESTClient;
    RESTResponse: TRESTResponse;
    procedure DataModuleCreate(Sender: TObject);
  private
    procedure Conexao();
    { Private declarations }
  public
    function ExecuteSQL(aSQL: string): WideString;
    function FindLogin(aSQL: string): Boolean;
    function CreateRegister(aSQL: string): WideString;
    function QueryBuilder(Email, Senha: string): WideString;
    { Public declarations }
  end;

var
  DMConexao: TDMConexao;

implementation

uses
  Controller.VariaveisAmbiente,
  System.JSON, DataSet.Serialize;

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

{ TDataModule1 }

function TDMConexao.CreateRegister(aSQL: string): WideString;
begin
  with Query do
  begin
    Close;
    SQL.Text := aSQL;
    try
      ExecSQL;
      Result := '{"message":"Registro criado com sucesso"}';
    except
      Result := '{"message":"Erro ao criar o registro"}';
    end;
  end;
end;

procedure TDMConexao.DataModuleCreate(Sender: TObject);
begin
  Conexao;
end;

function TDMConexao.ExecuteSQL(aSQL: string): WideString;
var
  JSONString: WideString;
begin
  with Query do
  begin
    Close;
    SQL.Text := aSQL;

    try
      Open;
      JSONString := Query.ToJSONArray.ToString;
    except
      JSONString := '{"message": "Não encontramos dados para essa questão. Melhore sua pergunta e tente novamente"}';
    end;

  end;

  Result := JSONString;
end;

function TDMConexao.FindLogin(aSQL: string): Boolean;
begin
  with Query do
  begin
    Close;
    SQL.Text := aSQL;
    try
      Open;
      if Query.RecordCount > 0 then
        Result := True
      else
        Result := False;
    except
      on E: Exception do
      Writeln('Erro ao conectar com a base de dados: ' + E.Message);
    end;
  end;
end;

function TDMConexao.QueryBuilder(Email, Senha: string): WideString;
var
  SQL           : TStringList;
  sSQL          : String;
begin
  try
    SQL := TStringList.Create();
    SQL.Add('SELECT');
    SQL.Add('EMAIL,');
    SQL.Add('SENHA');
    SQL.Add('FROM');
    SQL.Add('USUARIOS');
    SQL.Add('WHERE');
    SQL.Add('EMAIL=''%S''');
    SQL.Add('AND SENHA=''%S''');

    sSQL := Format(SQL.Text, [Email, Senha]);
  finally
    FreeAndNil(SQL);
  end;
    Result := sSQL;
end;

procedure TDMConexao.Conexao;
var
  Database, UserName, Password, DriverID: string;
  ExecutablePath: string;
begin
  TVariaveisAmbiente.LerVariaveisDB(Database, UserName, Password, DriverID);

  FDConnection.Params.Clear;
  FDConnection.Params.Add('DriverID=' + DriverID);
  FDConnection.Params.Add('Database=' + Database);
  FDConnection.Params.Add('User_Name=' + UserName);
  FDConnection.Params.Add('Password=' + Password);

  try
    FDConnection.Connected := True;
    Writeln('Conexão com a base de dados bem-sucedida!');
  except
    on E: Exception do
      Writeln('Erro ao conectar com a base de dados: ' + E.Message);
  end;

end;

end.
