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

function GETSwagger_HTML(AJSONPath: string): string;
var
  LResource: TResourceStream;
  LStringStream: TStringStream;
begin
  LResource := TResourceStream.Create(HInstance, 'GBSwagger20html', RT_RCDATA);
  try
    LStringStream := TStringStream.Create;
    try
      LStringStream.LoadFromStream(LResource);
      result := LStringStream.DataString;
      Result := result.Replace('::SWAGGER_TITLE', Swagger.Info.Title)
                    .Replace('::SWAGGER_JSON', AJSONPath)
                    .Replace('<%=jsonurl%>', AJSONPath)
                    .Replace('::SWAGGER_CSS', Swagger.Config.ResourcePath)
                    .Replace('::SWAGGER_UI_BUNDLE_JS', Swagger.Config.ResourcePath)
                    .Replace('::SWAGGER_UI_STANDALONE', Swagger.Config.ResourcePath);
    finally
      LStringStream.Free;
    end;
  finally
    LResource.Free;
  end;
end;

end.
