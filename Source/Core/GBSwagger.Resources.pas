unit GBSwagger.Resources;

interface

uses
  System.SysUtils,
  System.Classes,
  System.StrUtils,
  Web.HTTPApp,
  Web.HTTPProd,
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.Types;

type
  TGBSwaggerResources = class(TDataModule)
    swagger_html: TPageProducer;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function GETSwagger_HTML(AJSONPath: string): string;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

function GETSwagger_HTML(AJSONPath: string): string;
var
  dm: TGBSwaggerResources;
begin
  dm := TGBSwaggerResources.Create(nil);
  try
    Result := dm.swagger_html.HTMLDoc.Text;
    result := Result.Replace('::SWAGGER_TITLE', Swagger.Info.Title)
                    .Replace('::SWAGGER_JSON', AJSONPath)
                    .Replace('<%=jsonurl%>', AJSONPath)
                    .Replace('::SWAGGER_CSS', Swagger.Config.ResourcePath)
                    .Replace('::SWAGGER_UI_BUNDLE_JS', Swagger.Config.ResourcePath)
                    .Replace('::SWAGGER_UI_STANDALONE', Swagger.Config.ResourcePath)
                    .Replace('::SWAGGER_DOC_EXPANSION', Swagger.Config.DocExpansion.toString);
  finally
    dm.Free;
  end;
end;

end.
