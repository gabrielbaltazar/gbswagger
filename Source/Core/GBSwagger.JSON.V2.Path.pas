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

type
  TGBSwaggerJSONV2Path = class(TInterfacedObject, IGBSwaggerModelJSON)
  private
    FSwaggerPath: IGBSwaggerPath;
  public
    constructor Create(ASwaggerPath: IGBSwaggerPath);
    class function New(ASwaggerPath: IGBSwaggerPath): IGBSwaggerModelJSON;
    function ToJSON: TJSONValue;
  end;

implementation

{ TGBSwaggerJSONV2Path }

constructor TGBSwaggerJSONV2Path.Create(ASwaggerPath: IGBSwaggerPath);
begin
  FSwaggerPath := ASwaggerPath;
end;

class function TGBSwaggerJSONV2Path.New(ASwaggerPath: IGBSwaggerPath): IGBSwaggerModelJSON;
begin
  Result := Self.Create(ASwaggerPath);
end;

function TGBSwaggerJSONV2Path.ToJSON: TJSONValue;
var
  LJsonObject: TJSONObject;
  I: Integer;
begin
  LJsonObject := TJSONObject.Create;
  for I := 0 to Pred(Length(FSwaggerPath.Methods)) do
    LJsonObject.AddPair(
        FSwaggerPath.Methods[I].MethodType.toString,
        TGBSwaggerJSONV2PathMethod.New(FSwaggerPath.Methods[I]).ToJSON);
  Result := LJsonObject;
end;

end.
