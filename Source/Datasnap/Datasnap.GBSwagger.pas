unit Datasnap.GBSwagger;

interface

uses
  Web.HTTPApp,
  Datasnap.DSServer,
  Datasnap.DSHTTPWebBroker,
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.JSON.Interfaces,
  GBSwagger.Model.Types,
  GBSwagger.Web.HTML,
  GBSwagger.RTTI,
  GBSwagger.Path.Register,
  GBSwagger.Path.Attributes,
  Datasnap.GBSwagger.Scripts,
  System.JSON,
  System.SysUtils,
  System.StrUtils,
  system.classes;

type
  SwagApp                = GBSwagger.Path.Attributes.SwagApp;
  SwagContact            = GBSwagger.Path.Attributes.SwagContact;
  SwagBasePath           = GBSwagger.Path.Attributes.SwagBasePath;
  SwagAppDescription     = GBSwagger.Path.Attributes.SwagAppDescription;
  SwagSecurityBearer     = GBSwagger.Path.Attributes.SwagSecurityBearer;
  SwagSecurityBasic      = GBSwagger.Path.Attributes.SwagSecurityBasic;
  SwagPath               = GBSwagger.Path.Attributes.SwagPath;
  SwagParamPath          = GBSwagger.Path.Attributes.SwagParamPath;
  SwagParamHeader        = GBSwagger.Path.Attributes.SwagParamHeader;
  SwagParamQuery         = GBSwagger.Path.Attributes.SwagParamQuery;
  SwagParamBody          = GBSwagger.Path.Attributes.SwagParamBody;
  SwagGET                = GBSwagger.Path.Attributes.SwagGET;
  SwagPOST               = GBSwagger.Path.Attributes.SwagPOST;
  SwagPUT                = GBSwagger.Path.Attributes.SwagPUT;
  SwagDELETE             = GBSwagger.Path.Attributes.SwagDELETE;
  SwagResponse           = GBSwagger.Path.Attributes.SwagResponse;

  TGBSwaggerPathRegister = GBSwagger.Path.Register.TGBSwaggerPathRegister;

  TDatasnapGBSwagger = class
  private
    FWebModule: TWebModule;

    procedure actionResponseHtml(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure actionResponseJSON(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);

    procedure initialize;
    procedure initializeApp;
    procedure initializeContact;
    procedure initializeAuth;
    procedure initializeBasePath;
    procedure initializeRegisterResponse;

    procedure createActionHtml;
    procedure createActionJSON;
  public
    constructor create(WebModule: TWebModule);

end;

var
  DatasnapGBSwagger: TDatasnapGBSwagger;
  JSONSwagger: string;
  Swagger    : IGBSwagger;

procedure applySwagger(WebModule: TWebModule);

implementation

procedure applySwagger(WebModule: TWebModule);
begin
  DatasnapGBSwagger := TDatasnapGBSwagger.create(WebModule);
end;

{ TDatasnapGBSwagger }

procedure TDatasnapGBSwagger.actionResponseHtml(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.ContentType := 'text/html; charset=utf-8';
  Response.Content := SwaggerDocument(Swagger.Config.ResourcePath, '/swagger/doc/json');
end;

procedure TDatasnapGBSwagger.actionResponseJSON(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  action: TWebActionItem;
begin
  if JSONSwagger.IsEmpty then
    JSONSwagger := SwaggerJSONString(Swagger);

  Response.ContentType := 'application/json';
  Response.Content := JSONSwagger;
end;

constructor TDatasnapGBSwagger.create(WebModule: TWebModule);
begin
  FWebModule := WebModule;

  initialize;
  createActionHtml;
  createActionJSON;
end;

procedure TDatasnapGBSwagger.createActionHtml;
var
  action: TWebActionItem;
begin
  action            := FWebModule.Actions.Add;
  action.Enabled    := True;
  action.MethodType := mtGet;
  action.Name       := 'swaggerHTML';
  action.PathInfo   := '/swagger/doc/html';
  action.OnAction   := actionResponseHtml;
end;

procedure TDatasnapGBSwagger.createActionJSON;
var
  action: TWebActionItem;
begin
  action            := FWebModule.Actions.Add;
  action.Enabled    := True;
  action.MethodType := mtGet;
  action.Name       := 'swaggerJSON';
  action.PathInfo   := '/swagger/doc/json';
  action.OnAction   := actionResponseJSON;
end;

procedure TDatasnapGBSwagger.initialize;
begin
  initializeApp;
  initializeContact;
  initializeAuth;
  initializeBasePath;
  initializeRegisterResponse;
end;

procedure TDatasnapGBSwagger.initializeApp;
var
  app: SwagApp;
  appDescription: SwagAppDescription;
  appTitle: string;
begin
  app := TGBSwaggerRTTI.GetInstance.GetType(FWebModule.ClassType)
          .GetAttribute<SwagApp>;

  if Assigned(app) then
  begin
    if not app.version.IsEmpty then
      Swagger.Info.Version(app.version);

    if not app.host.IsEmpty then
      Swagger.Host(app.host);

    appTitle := Swagger.Info.Title;
    appTitle := IfThen(appTitle.IsEmpty, app.title, appTitle);
    appTitle := IfThen(not appTitle.IsEmpty, appTitle, ChangeFileExt(ExtractFileName(GetModuleName(HInstance)), ''));

    Swagger.Info.Title(appTitle);
  end;

  appDescription := TGBSwaggerRTTI.GetInstance.GetType(FWebModule.ClassType)
          .GetAttribute<SwagAppDescription>;

  if Assigned(appDescription) then
    Swagger.Info.Description(appDescription.description);
end;

procedure TDatasnapGBSwagger.initializeAuth;
var
  authBearer: SwagSecurityBearer;
  authBasic : SwagSecurityBasic;
begin
  authBearer := TGBSwaggerRTTI.GetInstance.GetType(FWebModule.ClassType)
            .GetAttribute<SwagSecurityBearer>;

  if Assigned(authBearer) then
    Swagger.AddBearerSecurity;

  authBasic := TGBSwaggerRTTI.GetInstance.GetType(FWebModule.ClassType)
            .GetAttribute<SwagSecurityBasic>;

  if Assigned(authBasic) then
    Swagger.AddBasicSecurity;
end;

procedure TDatasnapGBSwagger.initializeBasePath;
var
  basePath: SwagBasePath;
begin
  basePath := TGBSwaggerRTTI.GetInstance.GetType(FWebModule.ClassType)
                .GetAttribute<SwagBasePath>;

  if Assigned(basePath) then
    Swagger.BasePath(basePath.value);
end;

procedure TDatasnapGBSwagger.initializeContact;
var
  contact: SwagContact;
begin
  contact := TGBSwaggerRTTI.GetInstance.GetType(FWebModule.ClassType)
                .GetAttribute<SwagContact>;

  if Assigned(contact) then
  begin
    Swagger.Info
      .Contact
        .Name(contact.name)
        .Email(contact.email)
        .URL(contact.site);
  end;
end;

procedure TDatasnapGBSwagger.initializeRegisterResponse;
var
  attr: TCustomAttribute;
  attributes: TArray<TCustomAttribute>;
begin
  attributes := TGBSwaggerRTTI.GetInstance.GetType(FWebModule.ClassType)
                  .GetAttributes;

  for attr in attributes do
  begin
    if attr.ClassNameIs(SwagResponse.ClassName) then
    begin
      Swagger.Register
        .Response(SwagResponse(attr).httpCode)
          .Description(SwagResponse(attr).description)
          .Schema(SwagResponse(attr).classType)
          .IsArray(SwagResponse(attr).isArray)
        .&End;
    end;
  end;
end;

initialization
  JSONSwagger := EmptyStr;
  Swagger     := GBSwagger.Model.Interfaces.Swagger;

finalization
  DatasnapGBSwagger.Free;

end.
