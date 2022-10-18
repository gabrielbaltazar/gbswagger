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

type
  TGBSwaggerJSONV2Parameter = class(TInterfacedObject, IGBSwaggerModelJSON)
  private
    FSwaggerParameter: IGBSwaggerParameter;

    procedure ParamEnum(AJsonObject: TJSONObject);
  public
    constructor Create(ASwaggerParameter: IGBSwaggerParameter);
    class function New(ASwaggerParameter: IGBSwaggerParameter): IGBSwaggerModelJSON;

    function ToJSON: TJSONValue;
  end;

implementation

{ TGBSwaggerJSONV2Parameter }

constructor TGBSwaggerJSONV2Parameter.Create(ASwaggerParameter: IGBSwaggerParameter);
begin
  FSwaggerParameter := ASwaggerParameter;
end;

class function TGBSwaggerJSONV2Parameter.New(ASwaggerParameter: IGBSwaggerParameter): IGBSwaggerModelJSON;
begin
  Result := Self.Create(ASwaggerParameter);
end;

procedure TGBSwaggerJSONV2Parameter.ParamEnum(AJsonObject: TJSONObject);
var
  LJsonArray: TJSONArray;
  I: Integer;
begin
  LJsonArray := TJSONArray.Create;
  for I := 0 to Pred(Length(FSwaggerParameter.EnumValues)) do
    LJsonArray.Add(VarToStr( FSwaggerParameter.EnumValues[I]));

  AJsonObject
    .AddPair('type', 'array')
    .AddPair('items', TJSONObject.Create
      .AddPair('type', 'string')
      .AddPair('enum', LJsonArray))
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

  Result := LJSON;
end;

end.
