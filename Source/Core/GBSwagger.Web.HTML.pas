unit GBSwagger.Web.HTML;

interface

uses
  System.Classes,
  System.SysUtils,
  System.StrUtils,
  GBSwagger.Resources;

function SwaggerDocument(AJsonPath: String): string; overload;

implementation

function SwaggerDocument(AJsonPath: String): string;
begin
  result := GETSwagger_HTML(AJsonPath);
end;

end.
