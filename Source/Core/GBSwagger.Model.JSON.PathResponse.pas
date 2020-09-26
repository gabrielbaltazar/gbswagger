unit GBSwagger.Model.JSON.PathResponse;

interface

uses
  GBSwagger.RTTI,
  GBSwagger.Model.JSON.Utils,
  GBSwagger.Model.JSON.Interfaces,
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.JSON.Header,
  GBSwagger.Model.Types,
  System.SysUtils,
  System.StrUtils,
  System.JSON;

type TGBSwaggerModelJSONPathResponse = class(TInterfacedObject, IGBSwaggerModelJSON)

  private
    FSwaggerPathResponse: IGBSwaggerPathResponse;

    function JSONSchema   : TJSONObject;
    function JSONHeaders  : TJSONObject;
  public
    constructor create(SwaggerPathResponse: IGBSwaggerPathResponse);
    class function New(SwaggerPathResponse: IGBSwaggerPathResponse): IGBSwaggerModelJSON;

    function ToJSON: TJSONValue;
end;

implementation

{ TGBSwaggerModelJSONPathResponse }

constructor TGBSwaggerModelJSONPathResponse.create(SwaggerPathResponse: IGBSwaggerPathResponse);
begin
  FSwaggerPathResponse := SwaggerPathResponse;
end;

function TGBSwaggerModelJSONPathResponse.JSONHeaders: TJSONObject;
var
  header  : IGBSwaggerHeader;
  headers : TArray<IGBSwaggerHeader>;
begin
  result  := TJSONObject.Create;
  headers := FSwaggerPathResponse.Headers;

  if Length(headers) > 0 then
  begin
    for header in headers do
      result.AddPair(header.Name, TGBSwaggerModelJSONHeader.New(header).ToJSON);
  end;
end;

function TGBSwaggerModelJSONPathResponse.JSONSchema: TJSONObject;
var
  schemaName: String;
begin
  schemaName := FSwaggerPathResponse.&End.&End.&End.SchemaName(FSwaggerPathResponse.Schema);
  if FSwaggerPathResponse.IsArray then
    result := TGBSwaggerModelJSONUtils.JSONSchemaArray(schemaName)
  else
    result := TGBSwaggerModelJSONUtils.JSONSchemaObject(schemaName);
end;

class function TGBSwaggerModelJSONPathResponse.New(SwaggerPathResponse: IGBSwaggerPathResponse): IGBSwaggerModelJSON;
begin
  result := Self.create(SwaggerPathResponse);
end;

function TGBSwaggerModelJSONPathResponse.ToJSON: TJSONValue;
var
  json: TJSONObject;
begin
  json := TJSONObject.Create
              .AddPair('description', FSwaggerPathResponse.Description);

  if Assigned(FSwaggerPathResponse.Schema) then
    json.AddPair('schema', JSONSchema)
  else
    json.AddPair('schema', TJSONObject.Create
                            .AddPair('type', FSwaggerPathResponse.&Type));

  json.AddPair('headers', JSONHeaders);
  result := json;
end;

end.
