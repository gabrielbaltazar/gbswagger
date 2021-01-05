unit GBSwagger.Model.JSON.Schema;

interface

uses
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.JSON.Interfaces,
  GBSwagger.RTTI,
  System.Rtti,
  System.JSON,
  System.SysUtils,
  System.TypInfo,
  System.StrUtils,
  GBSwagger.Model.Attributes;

type TGBSwaggerModelJSONSchema = class(TInterfacedObject, IGBSwaggerModelJSON)

  private
    FSchema: IGBSwaggerSchema;

    function JSONSchema: TJSONObject;
    function JSONRequired: TJSONArray;
    function JSONProperties: TJSONObject;

    function JSONProperty             (AProperty: TRttiProperty): TJSONObject;
    function JSONPropertyPairArray    (AProperty: TRttiProperty): TJSONPair;
    function JSONPropertyPairList     (AProperty: TRttiProperty): TJSONPair;
    function JSONPropertyPairEnum     (AProperty: TRttiProperty): TJSONPair;
    function JSONPropertyPairObject   (AProperty: TRttiProperty): TJSONPair;

    function PropertyDateTimeFormat(AProperty: TRttiProperty): string;
  public
    function ToJSON: TJSONValue;

    constructor create(Schema: IGBSwaggerSchema);
    class function New(Schema: IGBSwaggerSchema): IGBSwaggerModelJSON;
    destructor  Destroy; override;
end;

implementation

{ TGBSwaggerModelJSONSchema }

constructor TGBSwaggerModelJSONSchema.create(Schema: IGBSwaggerSchema);
begin
  FSchema := Schema;
end;

destructor TGBSwaggerModelJSONSchema.Destroy;
begin

  inherited;
end;

function TGBSwaggerModelJSONSchema.JSONProperties: TJSONObject;
var
  rttiProperty: TRttiProperty;
begin
  result := TJSONObject.Create;
  for rttiProperty in FSchema.ClassType.GetProperties do
  begin
    if not rttiProperty.IsSwaggerIgnore(FSchema.ClassType) then
      Result.AddPair(rttiProperty.SwagName, JSONProperty(rttiProperty))
  end;
end;

function TGBSwaggerModelJSONSchema.JSONProperty(AProperty: TRttiProperty): TJSONObject;
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

function TGBSwaggerModelJSONSchema.JSONPropertyPairArray(AProperty: TRttiProperty): TJSONPair;
begin
  Result := TJSONPair.Create(
        'items', TJSONObject.Create
                    .AddPair('type', AProperty.ArrayType)
    );
end;

function TGBSwaggerModelJSONSchema.JSONPropertyPairEnum(AProperty: TRttiProperty): TJSONPair;
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

function TGBSwaggerModelJSONSchema.JSONPropertyPairList(AProperty: TRttiProperty): TJSONPair;
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

function TGBSwaggerModelJSONSchema.JSONPropertyPairObject(AProperty: TRttiProperty): TJSONPair;
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

function TGBSwaggerModelJSONSchema.JSONRequired: TJSONArray;
var
  i : Integer;
  requiredFields: TArray<String>;
begin
  requiredFields := FSchema.ClassType.SwaggerRequiredFields;

  result := TJSONArray.Create;
  for i := 0 to Pred(Length(requiredFields)) do
    result.Add(requiredFields[i]);
end;

function TGBSwaggerModelJSONSchema.JSONSchema: TJSONObject;
begin
  result := TJSONObject.Create
              .AddPair('type', 'object')
              .AddPair('description', FSchema.ClassType.SwagDescription(FSchema.&End));

  if Length(FSchema.ClassType.SwaggerRequiredFields) > 0 then
    result.AddPair('required', JSONRequired);

  result.AddPair('properties', JSONProperties);
end;

class function TGBSwaggerModelJSONSchema.New(Schema: IGBSwaggerSchema): IGBSwaggerModelJSON;
begin
  result := Self.create(Schema);
end;

function TGBSwaggerModelJSONSchema.PropertyDateTimeFormat(AProperty: TRttiProperty): string;
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

function TGBSwaggerModelJSONSchema.ToJSON: TJSONValue;
begin
  Result := JSONSchema;
end;

end.
