unit GBSwagger.JSON.V2.Parameter;

interface

uses
  GBSwagger.JSON.Interfaces,
  GBSwagger.JSON.Utils,
  GBSwagger.Model.Interfaces,
  GBSwagger.Types,
  System.SysUtils,
  System.StrUtils,
  System.Variants,
  System.JSON;

type TGBSwaggerJSONV2Parameter = class(TInterfacedObject, IGBSwaggerModelJSON)

  private
    FSwaggerParameter: IGBSwaggerParameter;

    procedure ParamEnum(AJsonObject: TJSONObject);
  public
    constructor create(SwaggerParameter: IGBSwaggerParameter);
    class function New(SwaggerParameter: IGBSwaggerParameter): IGBSwaggerModelJSON;

    function ToJSON: TJSONValue;
end;

implementation

{ TGBSwaggerJSONV2Parameter }

constructor TGBSwaggerJSONV2Parameter.create(SwaggerParameter: IGBSwaggerParameter);
begin
  FSwaggerParameter := SwaggerParameter;
end;

class function TGBSwaggerJSONV2Parameter.New(SwaggerParameter: IGBSwaggerParameter): IGBSwaggerModelJSON;
begin
  result := Self.create(SwaggerParameter);
end;

procedure TGBSwaggerJSONV2Parameter.ParamEnum(AJsonObject: TJSONObject);
var
  jsonArray: TJSONArray;
  i        : Integer;
begin
  jsonArray := TJSONArray.Create;
  for i := 0 to Pred(Length(FSwaggerParameter.EnumValues)) do
    jsonArray.Add(VarToStr( FSwaggerParameter.EnumValues[i]));

  AJsonObject
    .AddPair('type', 'array')
    .AddPair('items', TJSONObject.Create
                        .AddPair('type', 'string')
                        .AddPair('enum', jsonArray))
                        .AddPair('default', VarToStr(FSwaggerParameter.EnumValues[0]));
end;

function TGBSwaggerJSONV2Parameter.ToJSON: TJSONValue;
var
  jsonObject: TJSONObject;
  schemaName: string;
begin
  jsonObject := TJSONObject.Create
                  .AddPair('in', FSwaggerParameter.ParamType.toString)
                  .AddPair('name', FSwaggerParameter.Name)
                  .AddPair('description', FSwaggerParameter.Description)
                  .AddPair('required', TJSONBool.Create(FSwaggerParameter.Required));

  schemaName := FSwaggerParameter.SchemaType;

  if not schemaName.IsEmpty then
    if FSwaggerParameter.IsArray then
    begin
      if FSwaggerParameter.SchemaType.IsEmpty then
        jsonObject.AddPair('schema', TGBSwaggerModelJSONUtils.JSONSchemaArray(schemaName))
      else
      begin
        if FSwaggerParameter.Schema <> nil then
        begin
          jsonObject.AddPair('schema', TJSONObject.Create
                                          .AddPair('type', 'array')
                                          .AddPair('items', TJSONObject.Create
                                              .AddPair('$ref', '#/definitions/' + schemaName)) );
        end
        else
        jsonObject
          .AddPair('type', 'array')
          .AddPair('items', TJSONObject.Create.AddPair('type', FSwaggerParameter.SchemaType));
      end;
    end
    else
    if FSwaggerParameter.IsObject then
      jsonObject.AddPair('schema', TGBSwaggerModelJSONUtils.JSONSchemaObject(schemaName))
    else
    if FSwaggerParameter.IsEnum then
      ParamEnum(jsonObject)
    else
    begin
      if FSwaggerParameter.ParamType = gbBody then
        jsonObject.AddPair('schema', TJSONObject.Create.AddPair('type', schemaName))
      else
        jsonObject.AddPair('type', schemaName);
    end;

  result := jsonObject;
end;

end.
