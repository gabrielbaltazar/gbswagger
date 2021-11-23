unit GBSwagger.JSON.V2.Info;

interface

uses
  GBSwagger.JSON.Interfaces,
  GBSwagger.Model.Interfaces,
  GBSwagger.Types,
  GBSwagger.JSON.V2.Contact,
  System.JSON,
  System.SysUtils;

type TGBSwaggerJSONV2Info = class(TInterfacedObject, IGBSwaggerModelJSON)

  private
    FSwaggerInfo: IGBSwaggerInfo;

  public
    constructor create(SwaggerInfo: IGBSwaggerInfo);
    class function New(SwaggerInfo: IGBSwaggerInfo): IGBSwaggerModelJSON;

    function ToJSON: TJSONValue;

end;

implementation

{ TGBSwaggerJSONV2Info }

constructor TGBSwaggerJSONV2Info.create(SwaggerInfo: IGBSwaggerInfo);
begin
  FSwaggerInfo := SwaggerInfo;
end;

class function TGBSwaggerJSONV2Info.New(SwaggerInfo: IGBSwaggerInfo): IGBSwaggerModelJSON;
begin
  Result := Self.create(SwaggerInfo);
end;

function TGBSwaggerJSONV2Info.ToJSON: TJSONValue;
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
              .AddPair('contact', TGBSwaggerJSONV2Contact.New(FSwaggerInfo.Contact).ToJSON)
              .AddPair('license', TGBSwaggerJSONV2Contact.New(FSwaggerInfo.License).ToJSON);
end;

end.
