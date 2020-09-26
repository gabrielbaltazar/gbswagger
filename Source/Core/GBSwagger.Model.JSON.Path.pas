unit GBSwagger.Model.JSON.Path;

interface

uses
  GBSwagger.Model.JSON.Interfaces,
  GBSwagger.Model.JSON.Utils,
  GBSwagger.Model.JSON.PathMethod,
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.Types,
  System.SysUtils,
  System.StrUtils,
  System.JSON;

type TGBSwaggerModelJSONPath = class(TInterfacedObject, IGBSwaggerModelJSON)

  private
    FSwaggerPath: IGBSwaggerPath;

  public
    constructor create(SwaggerPath: IGBSwaggerPath);
    class function New(SwaggerPath: IGBSwaggerPath): IGBSwaggerModelJSON;

    function ToJSON: TJSONValue;
end;

implementation

{ TGBSwaggerModelJSONPath }

constructor TGBSwaggerModelJSONPath.create(SwaggerPath: IGBSwaggerPath);
begin
  FSwaggerPath := SwaggerPath;
end;

class function TGBSwaggerModelJSONPath.New(SwaggerPath: IGBSwaggerPath): IGBSwaggerModelJSON;
begin
  result := Self.create(SwaggerPath);
end;

function TGBSwaggerModelJSONPath.ToJSON: TJSONValue;
var
  jsonObject: TJSONObject;
  i         : Integer;
begin
  jsonObject := TJSONObject.Create;

  for i := 0 to Pred(Length(FSwaggerPath.Methods)) do
    jsonObject.AddPair(
        FSwaggerPath.Methods[i].MethodType.toString,
        TGBSwaggerModelJSONPathMethod.New(FSwaggerPath.Methods[i]).ToJSON
    );

  Result := jsonObject;
end;

end.
