unit Horse.GBSwagger;

interface

uses
  Horse,
  Horse.GBSwagger.Register,
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.JSON.Interfaces,
  GBSwagger.Model.Types,
  GBSwagger.Web.HTML,
  System.StrUtils,
  System.SysUtils;

const
  SWAG_STRING  = GBSwagger.Model.Types.SWAG_STRING;
  SWAG_INTEGER = GBSwagger.Model.Types.SWAG_INTEGER;

  PATH_HTML = '/swagger/doc/html';
  PATH_JSON = '/swagger/doc/json';

type
  TGBSwaggerContentType   = GBSwagger.Model.Types.TGBSwaggerContentType;
  TGBSwaggerProtocol      = GBSwagger.Model.Types.TGBSwaggerProtocol;
  TGBSwaggerParamType     = GBSwagger.Model.Types.TGBSwaggerParamType;
  THorseGBSwaggerRegister = Horse.GBSwagger.Register.THorseGBSwaggerRegister;

function HorseSwagger: THorseCallback; overload;
function HorseSwagger(APathHtml: String; APathJSON: string = ''): THorseCallback; overload;

procedure SwaggerHTML(ARequest: THorseRequest; AResponse: THorseResponse; ANext: TProc);
procedure SwaggerJSON(ARequest: THorseRequest; AResponse: THorseResponse; ANext: TProc);

var
  HTMLSwagger: string;
  JSONSwagger: string;
  JSONPath   : string;
  Swagger    : IGBSwagger;

implementation

function HorseSwagger(APathHtml: String; APathJSON: string = ''): THorseCallback;
var
  horseHtmlPath: string;
  horseJsonPath: string;
begin
  horseJsonPath := IfThen(APathJSON.IsEmpty, PATH_JSON, APathJSON);
  horseHtmlPath := IfThen(APathHtml.IsEmpty, PATH_HTML, APathHtml);

  JSONPath := horseJsonPath;

  THorse.GetInstance.Get(horseHtmlPath, SwaggerHTML);
  THorse.GetInstance.Get(horseJsonPath, SwaggerJSON);

  result :=
    procedure(ARequest: THorseRequest; AResponse: THorseResponse; ANext: TProc)
    begin
      try
        ANext();
      finally
      end;
    end;
end;

function HorseSwagger: THorseCallback;
begin
  result := HorseSwagger(PATH_HTML, PATH_JSON);
end;

procedure SwaggerHTML(ARequest: THorseRequest; AResponse: THorseResponse; ANext: TProc);
var
  pathJSON: String;
  basePath: string;
begin
  if HTMLSwagger.IsEmpty then
  begin
    basePath := EmptyStr;
    pathJSON := JSONPath;
    if not pathJSON.StartsWith('/') then
      pathJSON := '/' + pathJSON;
    {$IF Defined(HORSE_ISAPI) or Defined(HORSE_APACHE)}
    // Ajuda do Paulo Monteiro para compatibilidade com ISAPI
    basePath := '/' + Swagger.Config.ModuleName;
    {$ENDIF}

    pathJSON := basePath + pathJSON;

    HTMLSwagger := SwaggerDocument(Swagger.Config.ResourcePath, pathJSON);
  end;

  AResponse.Send(HTMLSwagger);
end;

procedure SwaggerJSON(ARequest: THorseRequest; AResponse: THorseResponse; ANext: TProc);
begin
  if JSONSwagger.IsEmpty then
    JSONSwagger := SwaggerJSONString(Swagger);

  AResponse.Send(JSONSwagger);
end;

initialization
  JSONSwagger := EmptyStr;
  HTMLSwagger := EmptyStr;
  Swagger     := GBSwagger.Model.Interfaces.Swagger;

end.
