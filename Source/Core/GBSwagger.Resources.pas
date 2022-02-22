unit GBSwagger.Resources;

interface

uses
  System.Classes,
  System.SysUtils,
  System.StrUtils,
  System.Types,
  GBSwagger.Model.Interfaces;

function GETSwagger_HTML(AJSONPath: string): string;

implementation

{$R GBSwagger20.RES}

function LoadResource(AResource: String): String;
var
  LResource: TResourceStream;
  LStringStream: TStringStream;
begin
  LResource := TResourceStream.Create(HInstance, AResource, RT_RCDATA);
  try
    LStringStream := TStringStream.Create;
    try
      LStringStream.LoadFromStream(LResource);
      result := LStringStream.DataString;
    finally
      LStringStream.Free;
    end;
  finally
    LResource.Free;
  end;
end;

function GETSwagger_HTML(AJSONPath: string): string;
begin
  result := LoadResource('GBSwagger20html');
  Result := result.Replace('::SWAGGER_TITLE', Swagger.Info.Title)
                  .Replace('::SWAGGER_JSON', AJSONPath)
                  .Replace('<%=jsonurl%>', AJSONPath)
                  .Replace('::SWAGGER_CSS', LoadResource('GBSwagger20css'))
                  .Replace('::SWAGGER_UI_BUNDLE_JS', LoadResource('GBSwagger20Bundlejs'))
                  .Replace('::SWAGGER_UI_STANDALONE', LoadResource('GBSwagger20StandAlonejs'));
end;

end.
