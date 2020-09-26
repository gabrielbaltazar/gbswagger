unit GBSwagger.Web.HTML;

interface

uses
  System.SysUtils,
  System.StrUtils,
  GBSwagger.Resources;

function SwaggerDocument(AResourcePath, AJsonPath: String): string; overload;

implementation

function SwaggerDocument(AResourcePath, AJsonPath: String): string;
begin
  result := GETSwagger_HTML(AJsonPath);
end;

end.
