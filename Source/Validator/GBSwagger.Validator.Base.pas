unit GBSwagger.Validator.Base;

interface

uses
  GBSwagger.Model.Attributes,
  GBSwagger.Validator.Attributes,
  GBSwagger.Validator.Interfaces,
  GBSwagger.RTTI,
  System.Rtti,
  System.SysUtils,
  System.TypInfo;

type TGBSwaggerValidator = class(TInterfacedObject, IGBSwaggerValidator)

  private
    function GetPropertyName(AProp: TRttiProperty; AInstanceName: String): string;

    procedure validateRequiredProperty(Value: TObject; AProp: TRttiProperty; AInstanceName: string);
    procedure validateNumberProperty  (Value: TObject; AProp: TRttiProperty; AInstanceName: string);

    procedure validateProperty(Value: TObject; AProp: TRttiProperty; AInstanceName: string);

    procedure validateStringProperty  (Value: TObject; AProp: TRttiProperty; AInstanceName: string);
    procedure validateIntegerProperty (Value: TObject; AProp: TRttiProperty; AInstanceName: string);
    procedure validateDoubleProperty  (Value: TObject; AProp: TRttiProperty; AInstanceName: string);
    procedure validateListProperty    (Value: TObject; AProp: TRttiProperty; AInstanceName: string);
    procedure validateEnumProperty    (Value: TObject; AProp: TRttiProperty; AInstanceName: string);
    procedure validateObjectProperty  (Value: TObject; AProp: TRttiProperty; AInstanceName: string);
    procedure validateObjectListProperty(Value: TObject; AProp: TRttiProperty; AInstanceName: string);

  protected
    procedure validate(Value: TObject; AInstanceName: String = '');

  public
    class function New: IGBSwaggerValidator;
end;

implementation

{ TGBSwaggerValidator }

function TGBSwaggerValidator.GetPropertyName(AProp: TRttiProperty; AInstanceName: String): string;
begin
  result := AProp.SwagName;
  if not AInstanceName.Trim.IsEmpty then
    result := AInstanceName + '.' + result;
end;

class function TGBSwaggerValidator.New: IGBSwaggerValidator;
begin
  result := Self.Create;
end;

procedure TGBSwaggerValidator.validate(Value: TObject; AInstanceName: String = '');
var
  i: Integer;
  properties : TArray<TRttiProperty>;
begin
  if not Assigned(Value) then
    Exit;

  properties := Value.GetProperties;
  for i := 0 to Pred(Length(properties)) do
    validateProperty(Value, properties[i], AInstanceName);
end;

procedure TGBSwaggerValidator.validateDoubleProperty(Value: TObject; AProp: TRttiProperty; AInstanceName: string);
begin
  validateNumberProperty(Value, AProp, AInstanceName);
end;

procedure TGBSwaggerValidator.validateEnumProperty(Value: TObject; AProp: TRttiProperty; AInstanceName: string);
var
  enumValue: Int64;
  enumNames: TArray<String>;

  function splitEnumNames: string;
  var
    i: Integer;
  begin
    for i := 0 to Pred(Length(enumNames)) do
    begin
      if i = 0 then
        result := enumNames[i]
      else
        result := result + ', ' + enumNames[i];
    end;
  end;
begin
  enumValue := AProp.GetValue(Value).AsOrdinal;
  enumNames := AProp.GetEnumNames;
  if (enumValue < 0) or (enumValue > Pred(Length(enumNames))) then
    raise Exception.CreateFmt('The property %s must be in [%s]', [GetPropertyName(AProp, AInstanceName), splitEnumNames]);
end;

procedure TGBSwaggerValidator.validateIntegerProperty(Value: TObject; AProp: TRttiProperty; AInstanceName: string);
begin
  validateNumberProperty(Value, AProp, AInstanceName);
end;

procedure TGBSwaggerValidator.validateListProperty(Value: TObject; AProp: TRttiProperty; AInstanceName: string);
var
  rttiType: TRttiType;
  method  : TRttiMethod;
  listValue : TValue;
  i       : Integer;
begin
  listValue := AProp.GetValue(Value);

  if listValue.AsObject = nil then
    Exit;

  rttiType := TGBSwaggerRTTI.GetInstance.GetType(listValue.AsObject.ClassType);

  method    := rttiType.GetMethod('ToArray');
  listValue := method.Invoke(listValue.AsObject, []);

  if listValue.GetArrayLength = 0 then
    Exit;

  for i := 0 to listValue.GetArrayLength - 1 do
    validateObjectListProperty(listValue.GetArrayElement(i).AsObject, AProp, AInstanceName);
end;

procedure TGBSwaggerValidator.validateNumberProperty(Value: TObject; AProp: TRttiProperty; AInstanceName: string);
var
  propValue: Double;
  number: SwagNumber;
begin
  propValue := AProp.GetValue(Value).AsExtended;
  number    := AProp.GetAttribute<SwagNumber>;

  if Assigned(number) then
  begin
    if (number.minimum <> 0) and (propValue < number.minimum) then
      raise Exception.CreateFmt('The minimum value to property %s is %s.', [GetPropertyName(AProp, AInstanceName), number.minimum.ToString]);

    if (number.maximum <> 0) and (propValue > number.maximum) then
      raise Exception.CreateFmt('The maximum value to property %s is %s.', [GetPropertyName(AProp, AInstanceName), number.maximum.ToString]);
  end;
end;

procedure TGBSwaggerValidator.validateObjectListProperty(Value: TObject; AProp: TRttiProperty; AInstanceName: string);
var
  propertiesToValidate : TArray<String>;
  SwagProps            : SwagValidateProperties;
  i                    : Integer;
  rProperty            : TRttiProperty;
begin
  SwagProps := AProp.GetAttribute<SwagValidateProperties>;

  if not Assigned(SwagProps) then
  begin
    validate(Value, GetPropertyName(AProp, AInstanceName));
    Exit;
  end;

  propertiesToValidate := SwagProps.properties;

  for i := 0 to Pred(Length(propertiesToValidate)) do
  begin
    rProperty := Value.GetProperty(propertiesToValidate[i]);
    if Assigned(rProperty) then
      validateProperty(Value, rProperty, GetPropertyName(rProperty, AInstanceName));
  end;
end;

procedure TGBSwaggerValidator.validateObjectProperty(Value: TObject; AProp: TRttiProperty; AInstanceName: string);
var
  propertiesToValidate : TArray<String>;
  SwagProps            : SwagValidateProperties;
  prop                 : TRttiProperty;
  AObject              : TObject;
  i                    : Integer;
begin
  SwagProps := AProp.GetAttribute<SwagValidateProperties>;
  AObject   := AProp.GetValue(Value).AsObject;

  if not Assigned(SwagProps) then
  begin
    validate(AObject, GetPropertyName(AProp, AInstanceName));
    Exit;
  end;

  propertiesToValidate := SwagProps.properties;

  for i := 0 to Pred(Length(propertiesToValidate)) do
  begin
    prop := AObject.GetProperty(propertiesToValidate[i]);
    if Assigned(prop) then
      validateProperty(AObject, prop, GetPropertyName(prop, AInstanceName));
  end;
end;

procedure TGBSwaggerValidator.validateProperty(Value: TObject; AProp: TRttiProperty; AInstanceName: string);
begin
  validateRequiredProperty(Value, AProp, AInstanceName);

  if AProp.IsString then
  begin
    validateStringProperty(Value, AProp, AInstanceName);
    Exit;
  end;

  if AProp.IsInteger then
  begin
    validateIntegerProperty(Value, AProp, AInstanceName);
    Exit;
  end;

  if AProp.IsFloat then
  begin
    validateDoubleProperty(Value, AProp, AInstanceName);
    Exit;
  end;

  if AProp.IsObject then
  begin
    validateObjectProperty(Value, AProp, AInstanceName);
    Exit;
  end;

  if AProp.IsList then
  begin
    validateListProperty(Value, AProp, AInstanceName);
    Exit;
  end;

  if AProp.IsEnum then
  begin
    validateEnumProperty(Value, AProp, AInstanceName);
    Exit;
  end;
end;

procedure TGBSwaggerValidator.validateRequiredProperty(Value: TObject; AProp: TRttiProperty; AInstanceName: string);
var
  required: SwagRequired;
  swaggerProp: SwagProp;
begin
  required := AProp.GetAttribute<SwagRequired>;
  if (Assigned(required)) and (AProp.IsEmptyValue(Value)) then
    raise Exception.CreateFmt('The property %s is required.', [GetPropertyName(AProp, AInstanceName)]);

  swaggerProp := AProp.GetAttribute<SwagProp>;
  if (Assigned(swaggerProp)) and (swaggerProp.required) and (AProp.IsEmptyValue(Value)) then
    raise Exception.CreateFmt('The property %s is required.', [GetPropertyName(AProp, AInstanceName)]);
end;

procedure TGBSwaggerValidator.validateStringProperty(Value: TObject; AProp: TRttiProperty; AInstanceName: string);
var
  str: SwagString;
  propValue: string;
begin
  str := AProp.GetAttribute<SwagString>;
  if Assigned(str) then
  begin
    propValue := AProp.GetValue(Value).AsString;

    if propValue.IsEmpty then
      Exit;

    if (str.minLength > 0) and (propValue.Length < str.minLength) then
      raise Exception.CreateFmt('The minimun length to property %s is %d.', [GetPropertyName(AProp, AInstanceName), str.minLength]);

    if (str.maxLength > 0) and (propValue.Length > str.maxLength) then
      raise Exception.CreateFmt('The maximum length to property %s is %d.', [GetPropertyName(AProp, AInstanceName), str.maxLength]);
  end;
end;

end.
