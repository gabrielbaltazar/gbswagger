unit GBSwagger.Web.HTML;

interface

uses
  System.Classes,
  System.SysUtils,
  System.StrUtils,
  GBSwagger.Resources;

function SwaggerDocument(AJsonPath: string): string; overload;

implementation

function SwaggerDocument(AJsonPath: string): string;
begin
  Result := GETSwagger_HTML(AJsonPath);
end;

end.
