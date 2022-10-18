unit GBSwagger.Validator.Base;

interface

uses
  GBSwagger.Model.Attributes,
  GBSwagger.Validator.Attributes,
  GBSwagger.Validator.Interfaces,
  GBSwagger.Validator.Messages.Interfaces,
  GBSwagger.RTTI,
  System.Rtti,
  System.SysUtils,
  System.TypInfo;

type
  TGBSwaggerValidator = class(TInterfacedObject, IGBSwaggerValidator)
  private
    FMessages: IGBSwaggerValidatorMessages;
    function GetPropertyName(AProp: TRttiProperty; AInstanceName: string): string;

    procedure ValidateRequiredProperty(AValue: TObject; AProp: TRttiProperty; AInstanceName: string);
    procedure ValidateNumberProperty(AValue: TObject; AProp: TRttiProperty; AInstanceName: string);
    procedure ValidateProperty(AValue: TObject; AProp: TRttiProperty; AInstanceName: string);

    procedure ValidateStringProperty(AValue: TObject; AProp: TRttiProperty; AInstanceName: string);
    procedure ValidateIntegerProperty(AValue: TObject; AProp: TRttiProperty; AInstanceName: string);
    procedure ValidateDoubleProperty(AValue: TObject; AProp: TRttiProperty; AInstanceName: string);
    procedure ValidateListProperty(AValue: TObject; AProp: TRttiProperty; AInstanceName: string);
    procedure ValidateEnumProperty(AValue: TObject; AProp: TRttiProperty; AInstanceName: string);
    procedure ValidateObjectProperty(AValue: TObject; AProp: TRttiProperty; AInstanceName: string);
    procedure ValidateObjectListProperty(AValue: TObject; AProp: TRttiProperty; AInstanceName: string);
  protected
    procedure Validate(AValue: TObject; AInstanceName: string = '');
  public
    class function New: IGBSwaggerValidator;
  end;

implementation

{ TGBSwaggerValidator }

function TGBSwaggerValidator.GetPropertyName(AProp: TRttiProperty; AInstanceName: string): string;
begin
  Result := AProp.SwagName;
  if not AInstanceName.Trim.IsEmpty then
    Result := AInstanceName + '.' + Result;
end;

class function TGBSwaggerValidator.New: IGBSwaggerValidator;
begin
  Result := Self.Create;
end;

procedure TGBSwaggerValidator.Validate(AValue: TObject; AInstanceName: string = '');
var
  I: Integer;
  LProperties: TArray<TRttiProperty>;
begin
  FMessages := GetValidatorMessage;
  if not Assigned(AValue) then
    Exit;

  LProperties := AValue.GetProperties;
  for I := 0 to Pred(Length(LProperties)) do
  begin
    if LProperties[I].IsSwaggerReadOnly then
      Continue;
    ValidateProperty(AValue, LProperties[I], AInstanceName);
  end;
end;

procedure TGBSwaggerValidator.ValidateDoubleProperty(AValue: TObject; AProp: TRttiProperty; AInstanceName: string);
begin
  ValidateNumberProperty(AValue, AProp, AInstanceName);
end;

procedure TGBSwaggerValidator.ValidateEnumProperty(AValue: TObject; AProp: TRttiProperty; AInstanceName: string);
var
  LEnumValue: Int64;
  LEnumNames: TArray<string>;

  function SplitEnumNames: string;
  var
    I: Integer;
  begin
    for I := 0 to Pred(Length(LEnumNames)) do
    begin
      if I = 0 then
        Result := LEnumNames[I]
      else
        Result := Result + ', ' + LEnumNames[I];
    end;
  end;
begin
  LEnumValue := AProp.GetValue(AValue).AsOrdinal;
  LEnumNames := AProp.GetEnumNames;
  if (LEnumValue < 0) or (LEnumValue > Pred(Length(LEnumNames))) then
    raise Exception.CreateFmt(FMessages.EnumValueMessage, [GetPropertyName(AProp, AInstanceName), SplitEnumNames]);
end;

procedure TGBSwaggerValidator.ValidateIntegerProperty(AValue: TObject; AProp: TRttiProperty; AInstanceName: string);
begin
  ValidateNumberProperty(AValue, AProp, AInstanceName);
end;

procedure TGBSwaggerValidator.ValidateListProperty(AValue: TObject; AProp: TRttiProperty; AInstanceName: string);
var
  LType: TRttiType;
  LMethod: TRttiMethod;
  LListValue: TValue;
  I: Integer;
begin
  LListValue := AProp.GetValue(AValue);
  if LListValue.AsObject = nil then
    Exit;

  LType := TGBSwaggerRTTI.GetInstance.GetType(LListValue.AsObject.ClassType);
  LMethod := LType.GetMethod('ToArray');
  LListValue := LMethod.Invoke(LListValue.AsObject, []);
  if LListValue.GetArrayLength = 0 then
    Exit;

  for I := 0 to LListValue.GetArrayLength - 1 do
    ValidateObjectListProperty(LListValue.GetArrayElement(I).AsObject, AProp, AInstanceName);
end;

procedure TGBSwaggerValidator.ValidateNumberProperty(AValue: TObject; AProp: TRttiProperty; AInstanceName: string);
var
  LPropValue: Double;
  LNumber: SwagNumber;
  LPositive: SwagPositive;
begin
  LPropValue := AProp.GetValue(AValue).AsExtended;
  LNumber := AProp.GetAttribute<SwagNumber>;
  LPositive := AProp.GetAttribute<SwagPositive>;

  if Assigned(LNumber) then
  begin
    if (LNumber.minimum <> 0) and (LPropValue < LNumber.minimum) then
      raise Exception.CreateFmt(FMessages.MinimumValueMessage, [GetPropertyName(AProp, AInstanceName), LNumber.minimum.ToString]);

    if (LNumber.maximum <> 0) and (LPropValue > LNumber.maximum) then
      raise Exception.CreateFmt(FMessages.MaximumValueMessage, [GetPropertyName(AProp, AInstanceName), LNumber.maximum.ToString]);
  end;

  if (Assigned(LPositive)) and (LPropValue < 0) then
    raise Exception.CreateFmt(FMessages.PositiveMessage, [GetPropertyName(AProp, AInstanceName)]);
end;

procedure TGBSwaggerValidator.ValidateObjectListProperty(AValue: TObject; AProp: TRttiProperty; AInstanceName: string);
var
  LPropertiesToValidate: TArray<string>;
  LProps: SwagValidateProperties;
  I: Integer;
  LProperty: TRttiProperty;
begin
  LProps := AProp.GetAttribute<SwagValidateProperties>;
  if not Assigned(LProps) then
  begin
    Validate(AValue, GetPropertyName(AProp, AInstanceName));
    Exit;
  end;

  LPropertiesToValidate := LProps.Properties;
  for I := 0 to Pred(Length(LPropertiesToValidate)) do
  begin
    LProperty := AValue.GetProperty(LPropertiesToValidate[I]);
    if Assigned(LProperty) then
      ValidateProperty(AValue, LProperty, GetPropertyName(LProperty, AInstanceName));
  end;
end;

procedure TGBSwaggerValidator.ValidateObjectProperty(AValue: TObject; AProp: TRttiProperty; AInstanceName: string);
var
  LPropertiesToValidate: TArray<string>;
  LProps: SwagValidateProperties;
  LProp: TRttiProperty;
  AObject: TObject;
  I: Integer;
begin
  LProps := AProp.GetAttribute<SwagValidateProperties>;
  AObject := AProp.GetValue(AValue).AsObject;
  if not Assigned(LProps) then
  begin
    Validate(AObject, GetPropertyName(AProp, AInstanceName));
    Exit;
  end;

  LPropertiesToValidate := LProps.Properties;
  for I := 0 to Pred(Length(LPropertiesToValidate)) do
  begin
    LProp := AObject.GetProperty(LPropertiesToValidate[I]);
    if Assigned(LProp) then
      ValidateProperty(AObject, LProp, GetPropertyName(LProp, AInstanceName));
  end;
end;

procedure TGBSwaggerValidator.ValidateProperty(AValue: TObject; AProp: TRttiProperty; AInstanceName: string);
begin
  ValidateRequiredProperty(AValue, AProp, AInstanceName);
  if AProp.IsString then
  begin
    ValidateStringProperty(AValue, AProp, AInstanceName);
    Exit;
  end;

  if AProp.IsInteger then
  begin
    ValidateIntegerProperty(AValue, AProp, AInstanceName);
    Exit;
  end;

  if AProp.IsFloat then
  begin
    ValidateDoubleProperty(AValue, AProp, AInstanceName);
    Exit;
  end;

  if AProp.IsObject then
  begin
    ValidateObjectProperty(AValue, AProp, AInstanceName);
    Exit;
  end;

  if AProp.IsList then
  begin
    ValidateListProperty(AValue, AProp, AInstanceName);
    Exit;
  end;

  if AProp.IsEnum then
  begin
    ValidateEnumProperty(AValue, AProp, AInstanceName);
    Exit;
  end;
end;

procedure TGBSwaggerValidator.ValidateRequiredProperty(AValue: TObject; AProp: TRttiProperty; AInstanceName: string);
var
  LRequired: SwagRequired;
  LProp: SwagProp;
begin
  LRequired := AProp.GetAttribute<SwagRequired>;
  if (Assigned(LRequired)) and (AProp.IsEmptyValue(AValue)) then
    raise Exception.CreateFmt(FMessages.RequiredMessage, [GetPropertyName(AProp, AInstanceName)]);

  LProp := AProp.GetAttribute<SwagProp>;
  if (Assigned(LProp)) and (LProp.required) and (AProp.IsEmptyValue(AValue)) then
    raise Exception.CreateFmt(FMessages.RequiredMessage, [GetPropertyName(AProp, AInstanceName)]);
end;

procedure TGBSwaggerValidator.ValidateStringProperty(AValue: TObject; AProp: TRttiProperty; AInstanceName: string);
var
  LStr: SwagString;
  LPropValue: string;
begin
  LStr := AProp.GetAttribute<SwagString>;
  if Assigned(LStr) then
  begin
    LPropValue := AProp.GetValue(AValue).AsString;

    if LPropValue.IsEmpty then
      Exit;

    if (LStr.minLength > 0) and (LPropValue.Length < LStr.minLength) then
      raise Exception.CreateFmt(FMessages.MinimumLengthMessage, [GetPropertyName(AProp, AInstanceName), LStr.minLength]);

    if (LStr.maxLength > 0) and (LPropValue.Length > LStr.maxLength) then
      raise Exception.CreateFmt(FMessages.MaximumLengthMessage, [GetPropertyName(AProp, AInstanceName), LStr.maxLength]);
  end;
end;

end.
