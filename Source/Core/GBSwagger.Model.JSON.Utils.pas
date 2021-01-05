unit GBSwagger.Model.JSON.Utils;

interface

uses
  System.JSON,
  GBSwagger.Model.Types;

type TGBSwaggerModelJSONUtils = class

  public
    class function JSONContentTypes(Value: TArray<String>): TJSONArray;
    class function JSONProtocols   (Value: TArray<TGBSwaggerProtocol>)   : TJSONArray;

    class function JSONSchemaArray (SchemaName: string): TJSONObject;
    class function JSONSchemaObject(SchemaName: string): TJSONObject;

end;

implementation

{ TGBSwaggerModelJSONUtils }

class function TGBSwaggerModelJSONUtils.JSONContentTypes(Value: TArray<String>): TJSONArray;
var
  i: Integer;
begin
  result := TJSONArray.Create;
  for i := 0 to Pred(Length(Value)) do
    Result.Add(Value[i]);
end;

class function TGBSwaggerModelJSONUtils.JSONProtocols(Value: TArray<TGBSwaggerProtocol>): TJSONArray;
var
  i: Integer;
begin
  result := TJSONArray.Create;
  for i := 0 to Pred(Length(Value)) do
    Result.Add(Value[i].toString);
end;

class function TGBSwaggerModelJSONUtils.JSONSchemaArray(SchemaName: string): TJSONObject;
begin
  result := TJSONObject.Create
              .AddPair('type', 'array')
              .AddPair('items',
                  TJSONObject.Create.AddPair('$ref', '#/definitions/' + SchemaName));
end;

class function TGBSwaggerModelJSONUtils.JSONSchemaObject(SchemaName: string): TJSONObject;
begin
  result := TJSONObject.Create
                .AddPair('$ref', '#/definitions/' + SchemaName);
end;

end.
