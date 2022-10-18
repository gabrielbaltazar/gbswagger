unit GBSwagger.JSON.V2.PathResponse;

interface

uses
  GBSwagger.RTTI,
  GBSwagger.JSON.Utils,
  GBSwagger.JSON.Interfaces,
  GBSwagger.Model.Interfaces,
  GBSwagger.JSON.V2.Header,
  GBSwagger.Model.Types,
  System.SysUtils,
  System.StrUtils,
  System.JSON;

type
  TGBSwaggerJSONV2PathResponse = class(TInterfacedObject, IGBSwaggerModelJSON)
  private
    FSwaggerPathResponse: IGBSwaggerPathResponse;

    function JSONSchema: TJSONObject;
    function JSONHeaders: TJSONObject;
  public
    constructor Create(ASwaggerPathResponse: IGBSwaggerPathResponse);
    class function New(ASwaggerPathResponse: IGBSwaggerPathResponse): IGBSwaggerModelJSON;
    function ToJSON: TJSONValue;
  end;

implementation

{ TGBSwaggerJSONV2PathResponse }

constructor TGBSwaggerJSONV2PathResponse.Create(ASwaggerPathResponse: IGBSwaggerPathResponse);
begin
  FSwaggerPathResponse := ASwaggerPathResponse;
end;

function TGBSwaggerJSONV2PathResponse.JSONHeaders: TJSONObject;
var
  LHeader: IGBSwaggerHeader;
  LHeaders: TArray<IGBSwaggerHeader>;
begin
  Result := TJSONObject.Create;
  LHeaders := FSwaggerPathResponse.Headers;
  if Length(LHeaders) > 0 then
  begin
    for LHeader in LHeaders do
      Result.AddPair(LHeader.Name, TGBSwaggerJSONV2Header.New(LHeader).ToJSON);
  end;
end;

function TGBSwaggerJSONV2PathResponse.JSONSchema: TJSONObject;
var
  LSchemaName: string;
begin
  LSchemaName := FSwaggerPathResponse.&End.&End.&End.SchemaName(FSwaggerPathResponse.Schema);
  if FSwaggerPathResponse.IsArray then
    Result := TGBSwaggerModelJSONUtils.JSONSchemaArray(LSchemaName)
  else
    Result := TGBSwaggerModelJSONUtils.JSONSchemaObject(LSchemaName);
end;

class function TGBSwaggerJSONV2PathResponse.New(ASwaggerPathResponse: IGBSwaggerPathResponse): IGBSwaggerModelJSON;
begin
  Result := Self.Create(ASwaggerPathResponse);
end;

function TGBSwaggerJSONV2PathResponse.ToJSON: TJSONValue;
var
  LJson: TJSONObject;
begin
  LJson := TJSONObject.Create
    .AddPair('description', FSwaggerPathResponse.Description);

  if Assigned(FSwaggerPathResponse.Schema) then
    LJson.AddPair('schema', JSONSchema)
  else
    LJson.AddPair('schema', TJSONObject.Create
                            .AddPair('type', FSwaggerPathResponse.&Type));

  LJson.AddPair('headers', JSONHeaders);
  Result := LJson;
end;

end.
