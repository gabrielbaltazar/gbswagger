unit GBSwagger.Model.JSON.Info;

interface

uses
  GBSwagger.Model.JSON.Interfaces,
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.Types,
  GBSwagger.Model.JSON.Contact,
  System.JSON,
  System.SysUtils;

type TGBSwaggerModelJSONInfo = class(TInterfacedObject, IGBSwaggerModelJSON)

  private
    FSwaggerInfo: IGBSwaggerInfo;

  public
    constructor create(SwaggerInfo: IGBSwaggerInfo);
    class function New(SwaggerInfo: IGBSwaggerInfo): IGBSwaggerModelJSON;

    function ToJSON: TJSONValue;

end;

implementation

{ TGBSwaggerModelJSONInfo }

constructor TGBSwaggerModelJSONInfo.create(SwaggerInfo: IGBSwaggerInfo);
begin
  FSwaggerInfo := SwaggerInfo;
end;

class function TGBSwaggerModelJSONInfo.New(SwaggerInfo: IGBSwaggerInfo): IGBSwaggerModelJSON;
begin
  Result := Self.create(SwaggerInfo);
end;

function TGBSwaggerModelJSONInfo.ToJSON: TJSONValue;
var
  title: string;
  ext  : string;
begin
  title := FSwaggerInfo.Title;
  if title.IsEmpty then
  begin
    title := ExtractFileName(GetModuleName(HInstance));
    ext   := ExtractFileExt(title);
    title := title.Replace(ext, EmptyStr);
  end;

  result := TJSONObject.Create
              .AddPair('description', FSwaggerInfo.Description)
              .AddPair('version', FSwaggerInfo.Version)
              .AddPair('title', title)
              .AddPair('termsOfService', FSwaggerInfo.TermsOfService)
              .AddPair('contact', TGBSwaggerModelJSONContact.New(FSwaggerInfo.Contact).ToJSON)
              .AddPair('license', TGBSwaggerModelJSONContact.New(FSwaggerInfo.License).ToJSON);
end;

end.
