unit WebModule.Main;

interface

uses 
  System.SysUtils,
  System.Classes,
  Web.HTTPApp,
  MVCFramework;

type
  TwmMain = class(TWebModule)
    procedure WebModuleCreate(Sender: TObject);
    procedure WebModuleDestroy(Sender: TObject);
  private
    FMVC: TMVCEngine;
  public
    { Public declarations }
  end;

var
  WebModuleClass: TComponentClass = TwmMain;

implementation

{$R *.dfm}

uses 
  Controller.Customer,
  System.IOUtils, 
  MVCFramework.Commons, 
  MVCFramework.Middleware.ActiveRecord, 
  MVCFramework.Middleware.StaticFiles, 
  MVCFramework.Middleware.Analytics, 
  MVCFramework.Middleware.Trace, 
  MVCFramework.Middleware.CORS, 
  MVCFramework.Middleware.ETag, 
  MVCFramework.Middleware.Compression;

procedure TwmMain.WebModuleCreate(Sender: TObject);
begin
  FMVC := TMVCEngine.Create(Self,
    procedure(Config: TMVCConfig)
    begin
      Config.dotEnv := dotEnv; 
      // session timeout (0 means session cookie)
      // Config[TMVCConfigKey.SessionTimeout] := dotEnv.Env('dmvc.session_timeout', '0');
      //default content-type
      Config[TMVCConfigKey.DefaultContentType] := dotEnv.Env('dmvc.default.content_type', TMVCConstants.DEFAULT_CONTENT_TYPE);
      //default content charset
      Config[TMVCConfigKey.DefaultContentCharset] := dotEnv.Env('dmvc.default.content_charset', TMVCConstants.DEFAULT_CONTENT_CHARSET);
      //unhandled actions are permitted?
      Config[TMVCConfigKey.AllowUnhandledAction] := dotEnv.Env('dmvc.allow_unhandled_actions', 'false');
      //enables or not system controllers loading (available only from localhost requests)
      Config[TMVCConfigKey.LoadSystemControllers] := dotEnv.Env('dmvc.load_system_controllers', 'true');
      //default view file extension
      Config[TMVCConfigKey.DefaultViewFileExtension] := dotEnv.Env('dmvc.default.view_file_extension', 'html');
      //view path
      Config[TMVCConfigKey.ViewPath] := dotEnv.Env('dmvc.view_path', 'templates');
      //use cache for server side views (use "false" in debug and "true" in production for faster performances
      Config[TMVCConfigKey.ViewCache] := dotEnv.Env('dmvc.view_cache', 'false');
      //Max Record Count for automatic Entities CRUD
      Config[TMVCConfigKey.MaxEntitiesRecordCount] := dotEnv.Env('dmvc.max_entities_record_count', IntToStr(TMVCConstants.MAX_RECORD_COUNT));
      //Enable Server Signature in response
      Config[TMVCConfigKey.ExposeServerSignature] := dotEnv.Env('dmvc.expose_server_signature', 'false');
      //Enable X-Powered-By Header in response
      Config[TMVCConfigKey.ExposeXPoweredBy] := dotEnv.Env('dmvc.expose_x_powered_by', 'true');
      // Max request size in bytes
      Config[TMVCConfigKey.MaxRequestSize] := dotEnv.Env('dmvc.max_request_size', IntToStr(TMVCConstants.DEFAULT_MAX_REQUEST_SIZE));
    end);
  FMVC.AddController(TCustomer);

// CORS middleware handles... well, CORS
//  FMVC.AddMiddleware(TMVCCORSMiddleware.Create('*'));

  FMVC.AddMiddleware(
    TMVCCORSMiddleware.Create(
         '*', { ****** AAllowedOriginURLs *******}
              (********************
              * Define quais origens (dom�nios) podem acessar sua API.  *
              * '*': permite qualquer origem (aberto total).            *
              * 'http://localhost:8080': permite apenas essa origem.    *
              *  'https://meusite.com': permite apenas esse dom�nio.    *
              *  Aten��o: Se voc� usar ' * ' aqui, voc� n�o pode ativar *
              * AllowCredentials = True (o navegador vai bloquear).     *
              *********************)
      False, { AAllowsCredentials }
             (************************
             * Indica se a API aceita credenciais nas requisi��es cross-origin:  *
             * Cookies                                                           *
             * Headers de Autentica��o (Authorization)                           *
             * Certificados de cliente                                           *
             * Importante: S� pode ser True se AAllowedOriginURLs for um dom�nio *
             * espec�fico (n�o pode ser '*').                                    *
             ***********************)
      '',    { AExposeHeaders (deixa vazio se n�o precisa expor headers espec�ficos) }
             (***************************
             * Define quais headers customizados o navegador pode enxergar na resposta.   *
             * Se sua API retorna um header como X-Custom-Token, voc� deve list�-lo aqui. *
             * Exemplo: 'X-Custom-Token, X-RateLimit'                                     *
             * Se for vazio (''), o navegador s� vai conseguir ver os headers "padr�o",   *
             * como Content-Type, Date, etc.                                              *
             **************************)
      'content-type,authorization,x-requested-with',
             { *********** AAllowsHeaders ************ }
             (****************************
             *  Define quais headers o cliente pode enviar numa requisi��o.                      *
             * 'content-type': necess�rio se voc� envia JSON (application/json).                 *
             * 'authorization': necess�rio se voc� envia token de autentica��o.                  *
             * 'x-requested-with': header comum em requisi��es AJAX (como fetch, axios, jQuery). *
             * Se algum header n�o estiver aqui, o navegador bloqueia a requisi��o CORS antes    *
             * mesmo de envi�-la para a API.                                                     *
             *****************************)
      'GET,POST,PUT,DELETE,OPTIONS',
             { ******** AAllowsMethods ********* }
             (************************
             * Define quais m�todos HTTP sua API permite em chamadas CORS.         *
             * OPTIONS: usado automaticamente pelo navegador em preflight requests *
             * GET, POST, PUT, DELETE: os m�todos REST cl�ssicos                   *
             *************************)
      3600   { ****AAccessControlMaxAge em segundos (ex: 1h = 3600s) **** }
             (**************************
             * Define por quanto tempo (em segundos) o navegador pode cachear a resposta *
             * da requisi��o OPTIONS (preflight).                                        *
             * 3600 = 1 hora                                                             *
             * Ajuda a evitar m�ltiplas requisi��es OPTIONS, melhorando performance      *
             ***************************)
    )
  );
  
  // Analytics middleware generates a csv log, useful to do traffic analysis
  //FMVC.AddMiddleware(TMVCAnalyticsMiddleware.Create(GetAnalyticsDefaultLogger));
  
  // The folder mapped as documentroot for TMVCStaticFilesMiddleware must exists!
  //FMVC.AddMiddleware(TMVCStaticFilesMiddleware.Create('/static', TPath.Combine(ExtractFilePath(GetModuleName(HInstance)), 'www')));
  
  // Trace middlewares produces a much detailed log for debug purposes
  //FMVC.AddMiddleware(TMVCTraceMiddleware.Create);
  
  // CORS middleware handles... well, CORS
  //FMVC.AddMiddleware(TMVCCORSMiddleware.Create);
  
  // Simplifies TMVCActiveRecord connection definition
  {
  FMVC.AddMiddleware(TMVCActiveRecordMiddleware.Create(
    dotEnv.Env('firedac.connection_definition_name', 'MyConnDef'), 
    dotEnv.Env('firedac.connection_definitions_filename', 'FDConnectionDefs.ini')
  ));
  }

  
  // Compression middleware must be the last in the chain, just before the ETag, if present.
  //FMVC.AddMiddleware(TMVCCompressionMiddleware.Create);
  
  // ETag middleware must be the latest in the chain
  //FMVC.AddMiddleware(TMVCETagMiddleware.Create);
 
   
  
  {
  FMVC.OnWebContextCreate( 
    procedure(const Context: TWebContext) 
    begin 
      // Initialize services to make them accessibile from Context
      // Context.CustomIntfObject := TMyService.Create; 
    end); 
  
  FMVC.OnWebContextDestroy(
    procedure(const Context: TWebContext)
    begin
      //Cleanup services, if needed
    end);
  }
end;

procedure TwmMain.WebModuleDestroy(Sender: TObject);
begin
  FMVC.Free;
end;

end.
