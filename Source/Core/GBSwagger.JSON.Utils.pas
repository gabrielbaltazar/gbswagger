unit GBSwagger.JSON.Utils;

interface

uses
  System.JSON,
  GBSwagger.Model.Types;

type
  TGBSwaggerModelJSONUtils = class
  public
    class function JSONContentTypes(AValue: TArray<string>): TJSONArray;
    class function JSONProtocols(AValue: TArray<TGBSwaggerProtocol>): TJSONArray;

    class function JSONSchemaArray(ASchemaName: string): TJSONObject;
    class function JSONSchemaObject(ASchemaName: string): TJSONObject;
  end;

implementation

{ TGBSwaggerModelJSONUtils }

class function TGBSwaggerModelJSONUtils.JSONContentTypes(AValue: TArray<string>): TJSONArray;
var
  I: Integer;
begin
  Result := TJSONArray.Create;
  for I := 0 to Pred(Length(AValue)) do
    Result.Add(AValue[I]);
end;

class function TGBSwaggerModelJSONUtils.JSONProtocols(AValue: TArray<TGBSwaggerProtocol>): TJSONArray;
var
  I: Integer;
begin
  Result := TJSONArray.Create;
  for I := 0 to Pred(Length(AValue)) do
    Result.Add(AValue[I].toString);
end;

class function TGBSwaggerModelJSONUtils.JSONSchemaArray(ASchemaName: string): TJSONObject;
begin
  Result := TJSONObject.Create
    .AddPair('type', 'array')
    .AddPair('items', TJSONObject.Create
      .AddPair('$ref', '#/definitions/' + ASchemaName));
end;

class function TGBSwaggerModelJSONUtils.JSONSchemaObject(ASchemaName: string): TJSONObject;
begin
  Result := TJSONObject.Create
    .AddPair('$ref', '#/definitions/' + ASchemaName);
end;

end.
