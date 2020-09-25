unit Datasnap.GBSwagger.Scripts;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp, Web.HTTPProd;

type
  TDataModule1 = class(TDataModule)
    swagger_ui_bundle: TPageProducer;
    swagger_ui_standalone_preset: TPageProducer;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SwaggerUiStandAlonePreset: String;
  SwaggerUIBundle: string;

function GetSwaggerUiStandAlonePreset: string;
function GetSwaggerUIBundle: string;

implementation

function GetSwaggerUiStandAlonePreset: string;
begin
  if SwaggerUiStandAlonePreset.IsEmpty then
  begin
    with TDataModule1.Create(nil) do
    begin
      try
        SwaggerUiStandAlonePreset := swagger_ui_standalone_preset.HTMLDoc.Text;
      finally
        Free;
      end;
    end;
  end;

  result := SwaggerUiStandAlonePreset;
end;

function GetSwaggerUIBundle: string;
begin
  if SwaggerUIBundle.IsEmpty then
  begin
    with TDataModule1.Create(nil) do
    begin
      try
        SwaggerUIBundle := swagger_ui_bundle.HTMLDoc.Text;
      finally
        Free;
      end;
    end;
  end;

  result := SwaggerUIBundle;
end;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
