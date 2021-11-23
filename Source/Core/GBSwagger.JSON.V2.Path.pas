unit GBSwagger.JSON.V2.Path;

interface

uses
  GBSwagger.JSON.Interfaces,
  GBSwagger.JSON.Utils,
  GBSwagger.JSON.V2.PathMethod,
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.Types,
  System.SysUtils,
  System.StrUtils,
  System.JSON;

type TGBSwaggerJSONV2Path = class(TInterfacedObject, IGBSwaggerModelJSON)

  private
    FSwaggerPath: IGBSwaggerPath;

  public
    constructor create(SwaggerPath: IGBSwaggerPath);
    class function New(SwaggerPath: IGBSwaggerPath): IGBSwaggerModelJSON;

    function ToJSON: TJSONValue;
end;

implementation

{ TGBSwaggerJSONV2Path }

constructor TGBSwaggerJSONV2Path.create(SwaggerPath: IGBSwaggerPath);
begin
  FSwaggerPath := SwaggerPath;
end;

class function TGBSwaggerJSONV2Path.New(SwaggerPath: IGBSwaggerPath): IGBSwaggerModelJSON;
begin
  result := Self.create(SwaggerPath);
end;

function TGBSwaggerJSONV2Path.ToJSON: TJSONValue;
var
  jsonObject: TJSONObject;
  i         : Integer;
begin
  jsonObject := TJSONObject.Create;

  for i := 0 to Pred(Length(FSwaggerPath.Methods)) do
    jsonObject.AddPair(
        FSwaggerPath.Methods[i].MethodType.toString,
        TGBSwaggerJSONV2PathMethod.New(FSwaggerPath.Methods[i]).ToJSON
    );

  Result := jsonObject;
end;

end.
