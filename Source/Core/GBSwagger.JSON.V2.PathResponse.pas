unit GBSwagger.JSON.V2.PathResponse;

interface

uses
  GBSwagger.RTTI,
  GBSwagger.JSON.Utils,
  GBSwagger.JSON.Interfaces,
  GBSwagger.Model.Interfaces,
  GBSwagger.JSON.V2.Header,
  GBSwagger.Types,
  System.SysUtils,
  System.StrUtils,
  System.JSON;

type TGBSwaggerJSONV2PathResponse = class(TInterfacedObject, IGBSwaggerModelJSON)

  private
    FSwaggerPathResponse: IGBSwaggerPathResponse;

    function JSONSchema: TJSONObject;
    function JSONHeaders: TJSONObject;
  public
    constructor create(SwaggerPathResponse: IGBSwaggerPathResponse);
    class function New(SwaggerPathResponse: IGBSwaggerPathResponse): IGBSwaggerModelJSON;

    function ToJSON: TJSONValue;
end;

implementation

{ TGBSwaggerJSONV2PathResponse }

constructor TGBSwaggerJSONV2PathResponse.create(SwaggerPathResponse: IGBSwaggerPathResponse);
begin
  FSwaggerPathResponse := SwaggerPathResponse;
end;

function TGBSwaggerJSONV2PathResponse.JSONHeaders: TJSONObject;
var
  header  : IGBSwaggerHeader;
  headers : TArray<IGBSwaggerHeader>;
begin
  result  := TJSONObject.Create;
  headers := FSwaggerPathResponse.Headers;

  if Length(headers) > 0 then
  begin
    for header in headers do
      result.AddPair(header.Name, TGBSwaggerJSONV2Header.New(header).ToJSON);
  end;
end;

function TGBSwaggerJSONV2PathResponse.JSONSchema: TJSONObject;
var
  schemaName: String;
begin
  schemaName := FSwaggerPathResponse.&End.&End.&End.SchemaName(FSwaggerPathResponse.Schema);
  if FSwaggerPathResponse.IsArray then
    result := TGBSwaggerModelJSONUtils.JSONSchemaArray(schemaName)
  else
    result := TGBSwaggerModelJSONUtils.JSONSchemaObject(schemaName);
end;

class function TGBSwaggerJSONV2PathResponse.New(SwaggerPathResponse: IGBSwaggerPathResponse): IGBSwaggerModelJSON;
begin
  result := Self.create(SwaggerPathResponse);
end;

function TGBSwaggerJSONV2PathResponse.ToJSON: TJSONValue;
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
