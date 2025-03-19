object DMConexao: TDMConexao
  OnCreate = DataModuleCreate
  Height = 176
  Width = 339
  object FDConnection: TFDConnection
    Params.Strings = (
      
        'Database=C:\Users\amanc\OneDrive\Documentos\GitHub\TCC-IMPACTA\B' +
        'ack-end\DataBase\BDSqlite.db'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 53
    Top = 32
  end
  object Query: TFDQuery
    Connection = FDConnection
    Left = 149
    Top = 32
  end
  object RESTRequest: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient
    Method = rmPOST
    Params = <
      item
        Kind = pkREQUESTBODY
        Name = 'body4E6B89C7FD1E4198BD64C5BE65C5188E'
        Value = 
          '{"contents":[{"parts":[{"text":"Oi, me fale brevemente sobre voc' +
          #195#170', voc'#195#170' '#195#169' gratis?"}]}]}'
        ContentTypeStr = 'application/atom+xml'
      end>
    Response = RESTResponse
    SynchronizedEvents = False
    Left = 40
    Top = 104
  end
  object RESTClient: TRESTClient
    BaseURL = 
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1' +
      '.5-flash-latest:generateContent?key=AIzaSyBTB62ox4J_wSkLS6_68q6O' +
      'MiRZGYyg0mQ'
    Params = <>
    SynchronizedEvents = False
    Left = 152
    Top = 104
  end
  object RESTResponse: TRESTResponse
    Left = 256
    Top = 104
  end
end
