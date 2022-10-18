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

type
  TGBSwaggerJSONV2Schema = class(TInterfacedObject, IGBSwaggerModelJSON)
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
    constructor Create(ASchema: IGBSwaggerSchema);
    class function New(ASchema: IGBSwaggerSchema): IGBSwaggerModelJSON;
    destructor Destroy; override;
    function ToJSON: TJSONValue;
  end;

implementation

{ TGBSwaggerJSONV2Schema }

constructor TGBSwaggerJSONV2Schema.Create(ASchema: IGBSwaggerSchema);
begin
  FSchema := ASchema;
end;

destructor TGBSwaggerJSONV2Schema.Destroy;
begin
  inherited;
end;

function TGBSwaggerJSONV2Schema.JSONProperties: TJSONObject;
var
  LProperty: TRttiProperty;
  LPair: TJSONPair;
begin
  Result := TJSONObject.Create;
  for LProperty in FSchema.ClassType.GetProperties do
  begin
    if not LProperty.IsSwaggerIgnore(FSchema.ClassType) then
      if Result.Get(LProperty.SwagName) = nil then
        Result.AddPair(LProperty.SwagName, JSONProperty(LProperty))
  end;

  // Excluir Swagger Ignore em caso de herança
  for LProperty in FSchema.ClassType.GetProperties do
    if LProperty.IsSwaggerIgnore(FSchema.ClassType) then
    begin
      LPair := Result.RemovePair(LProperty.SwagName);
      LPair.Free;
    end;
end;

function TGBSwaggerJSONV2Schema.JSONProperty(AProperty: TRttiProperty): TJSONObject;
var
  LAttSwagNumber: SwagNumber;
begin
  Result := TJSONObject.Create
    .AddPair('type', AProperty.SwagType)
    .AddPair('description', AProperty.SwagDescription)
    .AddPair('minLength', TJSONNumber.Create(AProperty.SwagMinLength))
    .AddPair('maxLength', TJSONNumber.Create(AProperty.SwagMaxLength));

  if AProperty.IsSwaggerReadOnly then
    Result.AddPair('readOnly', TJSONBool.Create(True));

  if (AProperty.IsInteger) or (AProperty.IsFloat) then
  begin
    LAttSwagNumber := AProperty.GetSwagNumber;
    if Assigned(LAttSwagNumber) then
    begin
      Result.AddPair('minimum', TJSONNumber.Create(LAttSwagNumber.Minimum))
        .AddPair('maximum', TJSONNumber.Create(LAttSwagNumber.Maximum));
    end;
  end;

  if AProperty.IsDateTime then
  begin
    Result.AddPair('format', PropertyDateTimeFormat(AProperty));
    Exit;
  end;

  if AProperty.IsDate then
  begin
    Result.AddPair('format', PropertyDateTimeFormat(AProperty));
    Exit;
  end;

  if AProperty.IsTime then
  begin
    Result.AddPair('format', PropertyDateTimeFormat(AProperty));
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
  Result := TJSONPair.Create('items', TJSONObject.Create
    .AddPair('type', AProperty.ArrayType));
end;

function TGBSwaggerJSONV2Schema.JSONPropertyPairEnum(AProperty: TRttiProperty): TJSONPair;
var
  LEnumNames: TArray<string>;
  LJsonArray: TJSONArray;
  I: Integer;
begin
  LEnumNames := AProperty.GetEnumNames;
  LJsonArray := TJSONArray.Create;
  for I := 0 to Length(LEnumNames) - 1 do
    LJsonArray.Add(LEnumNames[I]);
  Result := TJSONPair.Create('enum', LJsonArray);
end;

function TGBSwaggerJSONV2Schema.JSONPropertyPairList(AProperty: TRttiProperty): TJSONPair;
var
  LClassType: TClass;
  LClassName: string;
begin
  LClassType := AProperty.ListTypeClass;
  LClassName := FSchema.&End.SchemaName(LClassType);
  Result := TJSONPair.Create('items', TJSONObject.Create
    .AddPair('$ref', '#/definitions/' + LClassName));
end;

function TGBSwaggerJSONV2Schema.JSONPropertyPairObject(AProperty: TRttiProperty): TJSONPair;
var
  LClassType: TClass;
  LClassName: string;
  LJsonArray: TJSONArray;
begin
  LClassType := AProperty.GetClassType;
  LClassName := FSchema.&End.SchemaName(LClassType);

  LJsonArray := TJSONArray.Create;
  LJsonArray.AddElement(TJsonObject.Create
    .AddPair('$ref', '#/definitions/' + LClassName));

  Result := TJSONPair.Create('allOf', LJsonArray);
//  Result := TJSONPair.Create('$ref', '#/definitions/' + className);
end;

function TGBSwaggerJSONV2Schema.JSONRequired: TJSONArray;
var
  I: Integer;
  LRequiredFields: TArray<String>;
begin
  LRequiredFields := FSchema.ClassType.SwaggerRequiredFields;
  Result := TJSONArray.Create;
  for I := 0 to Pred(Length(LRequiredFields)) do
    Result.Add(LRequiredFields[I]);
end;

function TGBSwaggerJSONV2Schema.JSONSchema: TJSONObject;
begin
  Result := TJSONObject.Create
    .AddPair('type', 'object')
    .AddPair('description', FSchema.ClassType.SwagDescription(FSchema.&End));

  if Length(FSchema.ClassType.SwaggerRequiredFields) > 0 then
    Result.AddPair('required', JSONRequired);
  Result.AddPair('properties', JSONProperties);
end;

class function TGBSwaggerJSONV2Schema.New(ASchema: IGBSwaggerSchema): IGBSwaggerModelJSON;
begin
  Result := Self.Create(ASchema);
end;

function TGBSwaggerJSONV2Schema.PropertyDateTimeFormat(AProperty: TRttiProperty): string;
var
  LSwagDate: SwagDate;
begin
  Result := EmptyStr;
  LSwagDate := AProperty.GetAttribute<SwagDate>;
  if Assigned(LSwagDate) then
    Result := LSwagDate.dateFormat;

  if Result.IsEmpty then
    Result := FSchema.&End.Config.DateFormat;

  if Result.IsEmpty then
  begin
    if AProperty.IsDate then
      Result := 'date'
    else
    if AProperty.IsTime then
      Result := 'time'
    else
      Result := 'date-time';
  end;
end;

function TGBSwaggerJSONV2Schema.ToJSON: TJSONValue;
begin
  Result := JSONSchema;
end;

end.
