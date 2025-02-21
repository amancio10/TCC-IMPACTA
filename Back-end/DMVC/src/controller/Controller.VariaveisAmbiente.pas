unit Controller.VariaveisAmbiente;

interface

uses
  System.SysUtils,
  System.IniFiles;

type
  TVariaveisAmbiente = class
  Private
    //
  Public
    class procedure GetExecutablePath(var ExecutablePath: string);
    class procedure LerVariaveisDB(var Database, UserName, Password, DriverID: string);
    class procedure LerVariaveisGemini(var URLBase, Key, Devolver: string);
  end;

implementation

class procedure TVariaveisAmbiente.GetExecutablePath(var ExecutablePath: string);
begin
  ExecutablePath := ExtractFilePath(ParamStr(0));
end;

class procedure TVariaveisAmbiente.LerVariaveisDB(var Database, UserName, Password, DriverID: string);
var
  IniFile: TIniFile;
  ExecutablePath : string;
begin
 GetExecutablePath(ExecutablePath);

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

class procedure TVariaveisAmbiente.LerVariaveisGemini(var URLBase, Key, Devolver: string);
var
  IniFile: TIniFile;
  ExecutablePath : string;
begin
  GetExecutablePath(ExecutablePath);

  IniFile := TIniFile.Create(ExecutablePath + 'CGemini.ini');

  try
    URLBase   := IniFile.ReadString('Config', 'URLBase' , '');
    Key       := IniFile.ReadString('Config', 'Key'     , '');
    Devolver  := IniFile.ReadString('Config', 'Devolver', 'JSON');
  finally
    IniFile.Free;
  end;

end;

end.
