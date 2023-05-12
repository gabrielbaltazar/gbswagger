unit Horse.GBSwagger;

interface

uses
  Horse,
  Horse.GBSwagger.Register,
  Horse.GBSwagger.Controller,
  GBSwagger.Model.Interfaces,
  GBSwagger.JSON.Interfaces,
  GBSwagger.Model.Types,
  GBSwagger.Web.HTML,
  System.JSON,
  System.Classes,
  System.StrUtils,
  System.SysUtils,
  Web.HTTPApp;

const
  SWAG_STRING = GBSwagger.Model.Types.SWAG_STRING;
  SWAG_INTEGER = GBSwagger.Model.Types.SWAG_INTEGER;
  PATH_HTML = '/swagger/doc/html';
  PATH_JSON = '/swagger/doc/json';

type
  TGBSwaggerContentType = GBSwagger.Model.Types.TGBSwaggerContentType;
  TGBSwaggerProtocol = GBSwagger.Model.Types.TGBSwaggerProtocol;
  TGBSwaggerParamType = GBSwagger.Model.Types.TGBSwaggerParamType;
  THorseGBSwaggerRegister = Horse.GBSwagger.Register.THorseGBSwaggerRegister;
  THorseGBSwagger = Horse.GBSwagger.Controller.THorseGBSwagger;

function HorseSwagger: THorseCallback; overload;
function HorseSwagger(APathHtml: String; APathJSON: string = ''): THorseCallback; overload;

procedure SwaggerHTML(ARequest: THorseRequest; AResponse: THorseResponse; ANext: TProc);
procedure SwaggerJSON(ARequest: THorseRequest; AResponse: THorseResponse; ANext: TProc);

var
  HTMLSwagger: string;
  JSONSwagger: string;
  JSONPath: string;
  Swagger: IGBSwagger;

implementation

function HorseSwagger(APathHtml: String; APathJSON: string = ''): THorseCallback;
var
  LHorseHtmlPath: string;
  LHorseJsonPath: string;
begin
  LHorseJsonPath := IfThen(APathJSON.IsEmpty, PATH_JSON, APathJSON);
  LHorseHtmlPath := IfThen(APathHtml.IsEmpty, PATH_HTML, APathHtml);
  JSONPath := LHorseJsonPath;

  THorse.GetInstance.Get(LHorseHtmlPath, SwaggerHTML);
  THorse.GetInstance.Get(LHorseJsonPath, SwaggerJSON);

  Result :=
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    begin
      try
        Next();
      finally
      end;
    end;
end;

function HorseSwagger: THorseCallback;
begin
  Result := HorseSwagger(PATH_HTML, PATH_JSON);
end;

procedure SwaggerHTML(ARequest: THorseRequest; AResponse: THorseResponse; ANext: TProc);
var
  LPathJSON: string;
  LBasePath: string;
begin
  if HTMLSwagger.IsEmpty then
  begin
    LBasePath := EmptyStr;
    LPathJSON := JSONPath;
    if not LPathJSON.StartsWith('/') then
      LPathJSON := '/' + LPathJSON;
    {$IF Defined(HORSE_ISAPI) or Defined(HORSE_APACHE)}
    // Ajuda do Paulo Monteiro para compatibilidade com ISAPI
    LBasePath := '/' + Swagger.Config.ModuleName;
    {$ENDIF}

    LPathJSON := LBasePath + LPathJSON;
    HTMLSwagger := SwaggerDocument(LPathJSON);
  end;
  AResponse.ContentType(Swagger.Config.HTMLContentType)
    .Send(HTMLSwagger);
end;

procedure SwaggerJSON(ARequest: THorseRequest; AResponse: THorseResponse; ANext: TProc);
var
  LWebResponse: TWebResponse;
begin
  if JSONSwagger.IsEmpty then
    JSONSwagger := SwaggerJSONString(Swagger);

  LWebResponse := AResponse.RawWebResponse;
  LWebResponse.ContentType := 'application/json';
  LWebResponse.ContentStream := TStringStream.Create(JSONSwagger, TEncoding.UTF8);
  LWebResponse.SendResponse;
end;

initialization
  JSONSwagger := EmptyStr;
  HTMLSwagger := EmptyStr;
  Swagger := GBSwagger.Model.Interfaces.Swagger;

end.
