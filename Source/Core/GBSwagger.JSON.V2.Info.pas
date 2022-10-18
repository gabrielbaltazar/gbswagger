unit GBSwagger.JSON.V2.Info;

interface

uses
  GBSwagger.JSON.Interfaces,
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.Types,
  GBSwagger.JSON.V2.Contact,
  System.JSON,
  System.SysUtils;

type
  TGBSwaggerJSONV2Info = class(TInterfacedObject, IGBSwaggerModelJSON)
  private
    FSwaggerInfo: IGBSwaggerInfo;
  public
    constructor Create(ASwaggerInfo: IGBSwaggerInfo);
    class function New(ASwaggerInfo: IGBSwaggerInfo): IGBSwaggerModelJSON;

    function ToJSON: TJSONValue;
  end;

implementation

{ TGBSwaggerJSONV2Info }

constructor TGBSwaggerJSONV2Info.Create(ASwaggerInfo: IGBSwaggerInfo);
begin
  FSwaggerInfo := ASwaggerInfo;
end;

class function TGBSwaggerJSONV2Info.New(ASwaggerInfo: IGBSwaggerInfo): IGBSwaggerModelJSON;
begin
  Result := Self.Create(ASwaggerInfo);
end;

function TGBSwaggerJSONV2Info.ToJSON: TJSONValue;
var
  LTitle: string;
  LExt: string;
begin
  LTitle := FSwaggerInfo.Title;
  if LTitle.IsEmpty then
  begin
    LTitle := ExtractFileName(GetModuleName(HInstance));
    LExt   := ExtractFileExt(LTitle);
    LTitle := LTitle.Replace(LExt, EmptyStr);
  end;

  Result := TJSONObject.Create
    .AddPair('description', FSwaggerInfo.Description)
    .AddPair('version', FSwaggerInfo.Version)
    .AddPair('title', LTitle)
    .AddPair('termsOfService', FSwaggerInfo.TermsOfService)
    .AddPair('contact', TGBSwaggerJSONV2Contact.New(FSwaggerInfo.Contact).ToJSON)
    .AddPair('license', TGBSwaggerJSONV2Contact.New(FSwaggerInfo.License).ToJSON);
end;

end.
