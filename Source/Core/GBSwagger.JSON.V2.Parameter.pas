unit GBSwagger.JSON.V2.Parameter;

interface

uses
  GBSwagger.JSON.Interfaces,
  GBSwagger.JSON.Utils,
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.Types,
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
  LJSON: TJSONObject;
  LSchema: string;
begin
  LSchema := FSwaggerParameter.SchemaType;

  LJSON := TJSONObject.Create
                  .AddPair('in', FSwaggerParameter.ParamType.toString)
                  .AddPair('name', FSwaggerParameter.Name)
                  .AddPair('description', FSwaggerParameter.Description)
                  .AddPair('required', TJSONBool.Create(FSwaggerParameter.Required));


  if not LSchema.IsEmpty then
    if FSwaggerParameter.IsArray then
    begin
      if FSwaggerParameter.SchemaType.IsEmpty then
        LJSON.AddPair('schema', TGBSwaggerModelJSONUtils.JSONSchemaArray(LSchema))
      else
      begin
        if FSwaggerParameter.Schema <> nil then
        begin
          LJSON.AddPair('schema', TJSONObject.Create
                                          .AddPair('type', 'array')
                                          .AddPair('items', TJSONObject.Create
                                              .AddPair('$ref', '#/definitions/' + LSchema)) );
        end
        else
        LJSON
          .AddPair('type', 'array')
          .AddPair('items', TJSONObject.Create.AddPair('type', FSwaggerParameter.SchemaType));
      end;
    end
    else
    if FSwaggerParameter.IsObject then
      LJSON.AddPair('schema', TGBSwaggerModelJSONUtils.JSONSchemaObject(LSchema))
    else
    if FSwaggerParameter.IsEnum then
      ParamEnum(LJSON)
    else
    begin
      if FSwaggerParameter.ParamType = gbBody then
        LJSON.AddPair('schema', TJSONObject.Create.AddPair('type', LSchema))
      else
        LJSON.AddPair('type', LSchema);
    end;

  result := LJSON;
end;

end.
