unit GBSwagger.Model.JSON.Parameter;

interface

uses
  GBSwagger.Model.JSON.Interfaces,
  GBSwagger.Model.JSON.Utils,
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.Types,
  System.SysUtils,
  System.StrUtils,
  System.Variants,
  System.JSON;

type TGBSwaggerModelJSONParameter = class(TInterfacedObject, IGBSwaggerModelJSON)

  private
    FSwaggerParameter: IGBSwaggerParameter;

    procedure ParamEnum(AJsonObject: TJSONObject);
  public
    constructor create(SwaggerParameter: IGBSwaggerParameter);
    class function New(SwaggerParameter: IGBSwaggerParameter): IGBSwaggerModelJSON;

    function ToJSON: TJSONValue;
end;

implementation

{ TGBSwaggerModelJSONParameter }

constructor TGBSwaggerModelJSONParameter.create(SwaggerParameter: IGBSwaggerParameter);
begin
  FSwaggerParameter := SwaggerParameter;
end;

class function TGBSwaggerModelJSONParameter.New(SwaggerParameter: IGBSwaggerParameter): IGBSwaggerModelJSON;
begin
  result := Self.create(SwaggerParameter);
end;

procedure TGBSwaggerModelJSONParameter.ParamEnum(AJsonObject: TJSONObject);
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

function TGBSwaggerModelJSONParameter.ToJSON: TJSONValue;
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
      jsonObject.AddPair('type', schemaName);

  result := jsonObject;
end;

end.
