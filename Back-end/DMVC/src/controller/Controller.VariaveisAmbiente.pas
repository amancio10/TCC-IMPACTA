unit Controller.VariaveisAmbiente;

interface

uses
  System.SysUtils,
  System.IniFiles;

type
  TVariaveisAmbiente = class
  Private
    constructor Create;
    class var ExecutablePath: string;
  Public
    class procedure LerVariaveisDB(var Database, UserName, Password, DriverID: string);
    class procedure LerVariaveisGemini(var URLBase, Key: string);
  end;

implementation

constructor TVariaveisAmbiente.Create;
begin
  ExecutablePath := ExtractFilePath(ParamStr(0));
end;

class procedure TVariaveisAmbiente.LerVariaveisDB(var Database, UserName, Password, DriverID: string);
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(ExecutablePath + 'Conexao.ini');

  try
    Database := IniFile.ReadString('Config', 'Database', '');
    UserName := IniFile.ReadString('Config', 'User_Name', '');
    Password := IniFile.ReadString('Config', 'Password', '');
    DriverID := IniFile.ReadString('Config', 'DriverID', '');
  finally
    IniFile.Free;
  end;

end;

class procedure TVariaveisAmbiente.LerVariaveisGemini(var URLBase, Key: string);
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(ExecutablePath + 'CGemini.ini');

  try
    URLBase := IniFile.ReadString('Config', 'URLBase', '');
    Key := IniFile.ReadString('Config', 'Key', '');
  finally
    IniFile.Free;
  end;

end;

end.
