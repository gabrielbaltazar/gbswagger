unit GBSwagger.JSON.V2.Schema;

interface

uses
  GBSwagger.Model.Interfaces,
  GBSwagger.JSON.Interfaces,
  GBSwagger.RTTI,
  System.Rtti,
  System.JSON,
  System.SysUtils,
  System.TypInfo,
  System.StrUtils,
  GBSwagger.Model.Attributes;

type TGBSwaggerJSONV2Schema = class(TInterfacedObject, IGBSwaggerModelJSON)

  private
    FSchema: IGBSwaggerSchema;

    function JSONSchema: TJSONObject;
    function JSONRequired: TJSONArray;
    function JSONProperties: TJSONObject;

    function JSONProperty(AProperty: TRttiProperty): TJSONObject;
    function JSONPropertyPairArray(AProperty: TRttiProperty): TJSONPair;
    function JSONPropertyPairList(AProperty: TRttiProperty): TJSONPair;
    function JSONPropertyPairEnum(AProperty: TRttiProperty): TJSONPair;
    function JSONPropertyPairObject(AProperty: TRttiProperty): TJSONPair;

    function PropertyDateTimeFormat(AProperty: TRttiProperty): string;
  public
    function ToJSON: TJSONValue;

    constructor create(Schema: IGBSwaggerSchema);
    class function New(Schema: IGBSwaggerSchema): IGBSwaggerModelJSON;
    destructor  Destroy; override;
end;

implementation

{ TGBSwaggerJSONV2Schema }

constructor TGBSwaggerJSONV2Schema.create(Schema: IGBSwaggerSchema);
begin
  FSchema := Schema;
end;

destructor TGBSwaggerJSONV2Schema.Destroy;
begin

  inherited;
end;

function TGBSwaggerJSONV2Schema.JSONProperties: TJSONObject;
var
  rttiProperty: TRttiProperty;
  pair: TJSONPair;
begin
  result := TJSONObject.Create;
  for rttiProperty in FSchema.ClassType.GetProperties do
  begin
    if not rttiProperty.IsSwaggerIgnore(FSchema.ClassType) then
      if Result.Get(rttiProperty.SwagName) = nil then
        Result.AddPair(rttiProperty.SwagName, JSONProperty(rttiProperty))
  end;

  // Excluir Swagger Ignore em caso de heran�a
  for rttiProperty in FSchema.ClassType.GetProperties do
    if rttiProperty.IsSwaggerIgnore(FSchema.ClassType) then
    begin
      pair := Result.RemovePair(rttiProperty.SwagName);
      pair.Free;
    end;
end;

function TGBSwaggerJSONV2Schema.JSONProperty(AProperty: TRttiProperty): TJSONObject;
var
  attSwagNumber: SwagNumber;
begin
  result := TJSONObject.Create
              .AddPair('type', AProperty.SwagType)
              .AddPair('description', AProperty.SwagDescription)
              .AddPair('minLength', TJSONNumber.Create(AProperty.SwagMinLength))
              .AddPair('maxLength', TJSONNumber.Create(AProperty.SwagMaxLength));

  if AProperty.IsSwaggerReadOnly then
    Result.AddPair('readOnly', TJSONBool.Create(True));

  if (AProperty.IsInteger) or (AProperty.IsFloat) then
  begin
    attSwagNumber := AProperty.GetSwagNumber;
    if Assigned(attSwagNumber) then
    begin
      Result.AddPair('minimum', TJSONNumber.Create(attSwagNumber.minimum))
            .AddPair('maximum', TJSONNumber.Create(attSwagNumber.maximum));
    end;
  end;

  if AProperty.IsDateTime then
  begin
    result.AddPair('format', PropertyDateTimeFormat(AProperty));
    Exit;
  end;

  if AProperty.IsArray then
  begin
    Result.AddPair(JSONPropertyPairArray(AProperty));
    Exit;
  end;

  if AProperty.IsList then
  begin
    Result.AddPair(JSONPropertyPairList(AProperty));
    Exit;
  end;

  if AProperty.IsEnum then
  begin
    Result.AddPair(JSONPropertyPairEnum(AProperty));
    exit;
  end;

  if AProperty.IsObject then
  begin
    Result.AddPair(JSONPropertyPairObject(AProperty));
    Result.RemovePair('type').DisposeOf;
    Exit;
  end;
end;

function TGBSwaggerJSONV2Schema.JSONPropertyPairArray(AProperty: TRttiProperty): TJSONPair;
begin
  if AProperty.PropertyType.TypeKind = tkSet then
  begin
    enumNames := TRttiSetType(AProperty.PropertyType).ElementType.GetEnumNamesArray;
    jsonArray := TJSONArray.Create;

    for i := 0 to Length(enumNames) - 1 do
      jsonArray.Add(enumNames[i]);

    Result := TJSONPair.Create('items',TJSONObject.Create
                                        .AddPair('type','string')
                                        .AddPair('enum',jsonArray));
  end
  else
    Result := TJSONPair.Create(
          'items', TJSONObject.Create
                      .AddPair('type', AProperty.ArrayType)
      );
end;

function TGBSwaggerJSONV2Schema.JSONPropertyPairEnum(AProperty: TRttiProperty): TJSONPair;
var
  enumNames: TArray<String>;
  jsonArray: TJSONArray;
  i: Integer;
begin
  enumNames := AProperty.GetEnumNames;
  jsonArray := TJSONArray.Create;

  for i := 0 to Length(enumNames) - 1 do
    jsonArray.Add(enumNames[i]);

  result := TJSONPair.Create('enum', jsonArray);
end;

function TGBSwaggerJSONV2Schema.JSONPropertyPairList(AProperty: TRttiProperty): TJSONPair;
var
  classType: TClass;
  className: string;
begin
  classType := AProperty.ListTypeClass;
  className := FSchema.&End.SchemaName(classType);
  Result    := TJSONPair.Create(
        'items', TJSONObject.Create
                   .AddPair('$ref', '#/definitions/' + className)
  );
end;

function TGBSwaggerJSONV2Schema.JSONPropertyPairObject(AProperty: TRttiProperty): TJSONPair;
var
  classType: TClass;
  className: string;
  jsonArray: TJSONArray;
begin
  classType := AProperty.GetClassType;
  className := FSchema.&End.SchemaName(classType);

  jsonArray := TJSONArray.Create;
  jsonArray.AddElement(TJsonObject.Create
                          .AddPair('$ref', '#/definitions/' + className));

  Result := TJSONPair.Create('allOf', jsonArray);
//  Result := TJSONPair.Create('$ref', '#/definitions/' + className);
end;

function TGBSwaggerJSONV2Schema.JSONRequired: TJSONArray;
var
  i : Integer;
  requiredFields: TArray<String>;
begin
  requiredFields := FSchema.ClassType.SwaggerRequiredFields;

  result := TJSONArray.Create;
  for i := 0 to Pred(Length(requiredFields)) do
    result.Add(requiredFields[i]);
end;

function TGBSwaggerJSONV2Schema.JSONSchema: TJSONObject;
begin
  result := TJSONObject.Create
              .AddPair('type', 'object')
              .AddPair('description', FSchema.ClassType.SwagDescription(FSchema.&End));

  if Length(FSchema.ClassType.SwaggerRequiredFields) > 0 then
    result.AddPair('required', JSONRequired);

  result.AddPair('properties', JSONProperties);
end;

class function TGBSwaggerJSONV2Schema.New(Schema: IGBSwaggerSchema): IGBSwaggerModelJSON;
begin
  result := Self.create(Schema);
end;

function TGBSwaggerJSONV2Schema.PropertyDateTimeFormat(AProperty: TRttiProperty): string;
var
  swDate: SwagDate;
begin
  result := EmptyStr;

  swDate := AProperty.GetAttribute<SwagDate>;
  if Assigned(swDate) then
    result := swDate.dateFormat;

  if result.IsEmpty then
    result := FSchema.&End.Config.DateFormat;

  if result.IsEmpty then
    result := 'date-time';
end;

function TGBSwaggerJSONV2Schema.ToJSON: TJSONValue;
begin
  Result := JSONSchema;
end;

end.
