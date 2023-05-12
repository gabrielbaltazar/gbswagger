unit GBSwagger.RTTI;

interface

uses
  System.Rtti,
  System.SysUtils,
  System.TypInfo,
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.Attributes,
  GBSwagger.Path.Attributes;

type
  IGBSwaggerRTTI = interface
    ['{B432A34C-5601-4254-A951-0DE059E73CCE}']
    function GetType(AClass: TClass): TRttiType;
    function FindType(ATypeName: string): TRttiType;
  end;

  TGBSwaggerRTTI = class(TInterfacedObject, IGBSwaggerRTTI)
  private
    class var FInstance: IGBSwaggerRTTI;
  private
    FContext: TRttiContext;

    constructor CreatePrivate;
  public
    class function GetInstance: IGBSwaggerRTTI;
    constructor Create;
    destructor Destroy; override;

    function GetType(AClass: TClass): TRttiType;
    function FindType(ATypeName: string): TRttiType;
  end;

  TGBSwaggerRTTITypeHelper = class helper for TRttiType
  public
    function GetAttribute<T: TCustomAttribute>: T;
    function GetSwagClass: SwagClass;
    function IsList: Boolean;
    function TypeName: string;
  end;

  TGBSwaggerRTTIPropertyHelper = class helper for TRttiProperty
  public
    function IsList: Boolean;
    function IsString: Boolean;
    function IsInteger: Boolean;
    function IsEnum: Boolean;
    function IsArray: Boolean;
    function IsObject: Boolean;
    function IsFloat: Boolean;
    function IsDateTime: Boolean;
    function IsDate: Boolean;
    function IsTime: Boolean;
    function IsBoolean: Boolean;

    // Vários ORMs trabalham com tipo Nullable
    // Colaboração do Giorgio para essa compatibilidade
    function IsNullable: Boolean;
    function NullableType: string;

    function IsEmptyValue(AObject: TObject): Boolean;

    function GetAttribute<T: TCustomAttribute>: T;

    function IsSwaggerArray: Boolean;
    function IsSwaggerIgnore(AClass: TClass): Boolean;
    function IsSwaggerReadOnly: Boolean;

    function ArrayType: string;
    function ListType: string;
    function ListTypeClass: TClass;

    function GetSwagNumber: SwagNumber;

    function SwagName: string;
    function SwagType: string;
    function SwagDescription: string;
    function SwagMinLength: Integer;
    function SwagMaxLength: Integer;

    function GetClassType: TClass;
    function GetListType(AObject: TObject): TRttiType;
    function GetEnumNames: TArray<string>;
  end;

  TGBSwaggerMethodHelper = class helper for TRttiMethod
  public
    function IsAuthBasic: Boolean;
    function IsAuthBearer: Boolean;
    function GetSwagEndPoint: SwagEndPoint;
    function GetSwagParamPath: TArray<SwagParamPath>;
    function GetSwagParamHeader: TArray<SwagParamHeader>;
    function GetSwagParamFormData: TArray<SwagParamFormData>;
    function GetSwagConsumes: TArray<string>;
    function GetSwagProduces: TArray<string>;
    function GetSwagParamQuery: TArray<SwagParamQuery>;
    function GetSwagParamBody: SwagParamBody;
    function GetSwagResponse: TArray<SwagResponse>;
  end;

  TGBSwaggerObjectHelper = class helper for TObject
  private
    class function GetAttributes: TArray<TCustomAttribute>; overload;
    class function GetAttributes<T: TCustomAttribute>: TArray<T>; overload;
  public
    function InvokeMethod(const AMethodName: string; const AParameters: array of TValue): TValue;

    function GetProperty(AName: string): TRttiProperty;

    class function GetObjectProperties: TArray<TClass>;
    class function GetProperties: TArray<TRttiProperty>;
    class function GetMethods: TArray<TRttiMethod>;
    class function GetAttribute<T: TCustomAttribute>: T;
    class function GetSwagClass: SwagClass;
    class function GetSwagPath: SwagPath;

    class function GetSwagParamPaths: TArray<SwagParamPath>;
    class function GetSwagParamHeaders: TArray<SwagParamHeader>;
    class function GetSwagParamQueries: TArray<SwagParamQuery>;
    class function GetSwagParamsFormData: TArray<SwagParamFormData>;

    class function SwagDescription(ASwagger: IGBSwagger): string;
    class function SwaggerRequiredFields: TArray<string>;
    class function SwaggerIgnoreFields: TArray<string>;
  end;

implementation

{ TGBSwaggerRTTI }

constructor TGBSwaggerRTTI.Create;
begin
  raise Exception.Create('Use the GetInstance Construtor.');
end;

constructor TGBSwaggerRTTI.CreatePrivate;
begin
  FContext := TRttiContext.Create;
end;

destructor TGBSwaggerRTTI.Destroy;
begin
  FContext.Free;
  inherited;
end;

function TGBSwaggerRTTI.FindType(ATypeName: string): TRttiType;
begin
  Result := FContext.FindType(ATypeName);
end;

class function TGBSwaggerRTTI.GetInstance: IGBSwaggerRTTI;
begin
  if not Assigned(FInstance) then
    FInstance := TGBSwaggerRTTI.CreatePrivate;
  Result := FInstance;
end;

function TGBSwaggerRTTI.GetType(AClass: TClass): TRttiType;
begin
  Result := FContext.GetType(AClass);
end;

{ TGBSwaggerRTTITypeHelper }

function TGBSwaggerRTTITypeHelper.GetAttribute<T>: T;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Length(GetAttributes) - 1 do
  begin
    if GetAttributes[I].ClassNameIs(T.className) then
      Exit(T( GetAttributes[I]));
  end;
end;

function TGBSwaggerRTTITypeHelper.IsList: Boolean;
begin
  Result := False;

  if Self.AsInstance.Name.ToLower.StartsWith('tobjectlist<') then
    Exit(True);

  if Self.AsInstance.Name.ToLower.StartsWith('tlist<') then
    Exit(True);
end;

function TGBSwaggerRTTITypeHelper.TypeName: string;
begin
  Result := Self.AsInstance.Name;
end;

function TGBSwaggerRTTITypeHelper.GetSwagClass: SwagClass;
begin
  Result := GetAttribute<SwagClass>;
end;

{ TGBSwaggerRTTIPropertyHelper }

function TGBSwaggerRTTIPropertyHelper.ArrayType: string;
begin
  Result := EmptyStr;
  if (IsArray) then
    Result := TRttiDynamicArrayType(Self.PropertyType).ElementType.Name;
end;

function TGBSwaggerRTTIPropertyHelper.GetAttribute<T>: T;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Pred(Length(Self.GetAttributes)) do
    if Self.GetAttributes[I].ClassNameIs(T.className) then
      Exit(T( Self.GetAttributes[I]));
end;

function TGBSwaggerRTTIPropertyHelper.GetClassType: TClass;
begin
  Result := TRttiInstanceType(TGBSwaggerRTTI.GetInstance.FindType(
    PropertyType.QualifiedName)).MetaclassType;
end;

function TGBSwaggerRTTIPropertyHelper.GetEnumNames: TArray<string>;
var
  I: Integer;
  LUnitName: string;
  LEnumName: string;
begin
  LUnitName := PropertyType.QualifiedName.Replace('.' + PropertyType.ToString, EmptyStr);
  I := 0;
  repeat
    LEnumName := GetEnumName(TGBSwaggerRTTI.GetInstance.FindType(PropertyType.QualifiedName).Handle, I);
    if not LEnumName.Equals(LUnitName) then
    begin
      SetLength(Result, I + 1);
      Result[I] := LEnumName;
      I := I + 1;
    end;
  until LEnumName.Equals(LUnitName);
end;

function TGBSwaggerRTTIPropertyHelper.GetListType(AObject: TObject): TRttiType;
var
  ListType: TRttiType;
  ListTypeName: string;
begin
  ListType := TGBSwaggerRTTI.GetInstance.GetType(Self.GetValue(AObject).AsObject.ClassType);
  ListTypeName := ListType.ToString;
  ListTypeName := ListTypeName.Replace('TObjectList<', EmptyStr);
  ListTypeName := ListTypeName.Replace('TList<', EmptyStr);
  ListTypeName := ListTypeName.Replace('>', EmptyStr);
  Result := TGBSwaggerRTTI.GetInstance.FindType(ListTypeName);
end;

function TGBSwaggerRTTIPropertyHelper.GetSwagNumber: SwagNumber;
begin
  Result := GetAttribute<SwagNumber>;
end;

function TGBSwaggerRTTIPropertyHelper.IsArray: Boolean;
begin
  Result := Self.PropertyType.TypeKind in
    [tkSet, tkArray, tkDynArray]
end;

function TGBSwaggerRTTIPropertyHelper.IsBoolean: Boolean;
begin
  if Self.IsNullable then
    Result := Self.NullableType.ToLower.Equals('boolean') or
      Self.NullableType.ToLower.Equals('bool')
  else
    Result := Self.PropertyType.ToString.ToLower.Equals('boolean');
end;

function TGBSwaggerRTTIPropertyHelper.IsDate: Boolean;
var
  Ltype: string;
begin
  if Self.IsNullable then
    Ltype := Self.NullableType.ToLower
  else
    Ltype := Self.PropertyType.ToString.ToLower;
  Result := (Ltype.Equals('tdate'));
end;

function TGBSwaggerRTTIPropertyHelper.IsDateTime: Boolean;
var
  Ltype: string;
begin
  if Self.IsNullable then
    Ltype := Self.NullableType.ToLower
  else
    Ltype := Self.PropertyType.ToString.ToLower;

  Result := (Ltype.Equals('tdatetime'));
end;

function TGBSwaggerRTTIPropertyHelper.IsEmptyValue(AObject: TObject): Boolean;
begin
  Result := False;
  if IsString then
    Exit(Self.GetValue(AObject).AsString.Trim.IsEmpty);

  if IsInteger then
    Exit(Self.GetValue(AObject).AsInteger = 0);

  if IsFloat then
    Exit(Self.GetValue(AObject).AsExtended = 0);

  if IsDateTime or IsDate or IsTime then
    Exit(Self.GetValue(AObject).AsExtended = 0);
end;

function TGBSwaggerRTTIPropertyHelper.IsEnum: Boolean;
begin
  Result := (not IsBoolean) and (Self.PropertyType.TypeKind = tkEnumeration);
end;

function TGBSwaggerRTTIPropertyHelper.IsFloat: Boolean;
begin
  if Self.IsNullable then
    Result := Self.NullableType.ToLower.Equals('double') or
      Self.NullableType.ToLower.Equals('currency') or
      Self.NullableType.ToLower.Equals('real') or
      Self.NullableType.ToLower.Equals('extended') or
      Self.NullableType.ToLower.Equals('single')
  else
    Result := (Self.PropertyType.TypeKind = tkFloat) and
      (not IsDateTime) and (not IsDate) and (not IsTime);
end;

function TGBSwaggerRTTIPropertyHelper.IsInteger: Boolean;
begin
  if Self.IsNullable then
    Result := Self.NullableType.ToLower.Equals('integer') or
      Self.NullableType.ToLower.Equals('int64') or
      Self.NullableType.ToLower.Equals('word') or
      Self.NullableType.ToLower.Equals('dword') or
      Self.NullableType.ToLower.Equals('byte') or
      Self.NullableType.ToLower.Equals('longint') or
      Self.NullableType.ToLower.Equals('smallint')
  else
    Result := Self.PropertyType.TypeKind in [tkInt64, tkInteger];
end;

function TGBSwaggerRTTIPropertyHelper.IsList: Boolean;
begin
  Result := False;

  if Self.PropertyType.ToString.ToLower.StartsWith('tobjectlist<') then
    Exit(True);

  if Self.PropertyType.ToString.ToLower.StartsWith('tlist<') then
    Exit(True);

  if Assigned(Self.PropertyType.BaseType) then
  begin
    if Self.PropertyType.BaseType.Name.ToLower.StartsWith('tobjectlist<') then
      Exit(True);

    if Self.PropertyType.BaseType.Name.ToLower.StartsWith('tlist<') then
      Exit(True);
  end;
end;

function TGBSwaggerRTTIPropertyHelper.IsNullable: Boolean;
begin
  Result := False;
  if Self.PropertyType.ToString.ToLower.StartsWith('nullable<') then
    Exit(True);
end;

function TGBSwaggerRTTIPropertyHelper.IsObject: Boolean;
begin
  Result := (not IsList) and (Self.PropertyType.TypeKind = tkClass);
end;

function TGBSwaggerRTTIPropertyHelper.IsString: Boolean;
begin
  if Self.IsNullable then
    Result := Self.NullableType.ToLower.Equals('string')
  else
    Result := Self.PropertyType.TypeKind in [tkChar,
      tkString, tkWChar, tkLString, tkWString, tkUString];
end;

function TGBSwaggerRTTIPropertyHelper.IsSwaggerArray: Boolean;
begin
  Result := (IsArray) or (IsList);
end;

function TGBSwaggerRTTIPropertyHelper.IsSwaggerIgnore(AClass: TClass): Boolean;
var
  LIgnoreFields: TArray<string>;
  I: Integer;
begin
  LIgnoreFields := AClass.SwaggerIgnoreFields;
  for I := 0 to Pred(Length(LIgnoreFields)) do
  begin
    if Name.ToLower.Equals(LIgnoreFields[I].ToLower) then
      Exit(True);
  end;

  Result := Self.GetAttribute<SwagIgnore> <> nil;
  if not Result then
  begin
    if AClass.InheritsFrom(TInterfacedObject) then
      Result := Self.Name.ToLower.Equals('refcount');
  end;
end;

function TGBSwaggerRTTIPropertyHelper.IsSwaggerReadOnly: Boolean;
var
  LSwaggerProp: SwagProp;
begin
  Result := False;
  LSwaggerProp := GetAttribute<SwagProp>;
  if (Assigned(LSwaggerProp)) and (LSwaggerProp.readOnly) then
    Result := True;
end;

function TGBSwaggerRTTIPropertyHelper.IsTime: Boolean;
var
  Ltype: string;
begin
  if Self.IsNullable then
    Ltype := Self.NullableType.ToLower
  else
    Ltype := Self.PropertyType.ToString.ToLower;

  Result := (Ltype.Equals('ttime'));
end;

function TGBSwaggerRTTIPropertyHelper.ListType: string;
var
  LBaseType: string;
begin
  Result := EmptyStr;
  if IsList then
  begin
    if Assigned(PropertyType.BaseType) then
    begin
      LBaseType := PropertyType.Name;
      LBaseType := Copy(LBaseType, 1, Pos('<', LBaseType));
    end;
    Result := PropertyType.ToString
      .Replace('TObjectList<', EmptyStr)
      .Replace('TList<', EmptyStr)
      .Replace(LBaseType, EmptyStr)
      .Replace('>', EmptyStr);
  end;
end;

function TGBSwaggerRTTIPropertyHelper.ListTypeClass: TClass;
var
  StrListType: string;
begin
  StrListType := ListType;
  Result := TRttiInstanceType( TGBSwaggerRTTI.GetInstance
    .FindType(StrListType)).MetaclassType;
end;

function TGBSwaggerRTTIPropertyHelper.NullableType: string;
var
  LNullableType: string;
begin
  Result := '';
  if not IsNullable then
    Exit;
  LNullableType := Self.PropertyType.ToString.ToLower;
  LNullableType := StringReplace(LNullableType,'nullable<','',[rfIgnoreCase]);
  LNullableType := StringReplace(LNullableType,'system.','',[rfIgnoreCase]);
  LNullableType := LNullableType.Remove(LNullableType.Length-1);
  Result := LNullableType;
end;

function TGBSwaggerRTTIPropertyHelper.SwagDescription: string;
var
  LSwaggerProp: SwagProp;
begin
  Result := EmptyStr;
  LSwaggerProp := Self.GetAttribute<SwagProp>;
  if Assigned(LSwaggerProp) then
    Result := LSwaggerProp.description;
end;

function TGBSwaggerRTTIPropertyHelper.SwagMaxLength: Integer;
var
  LSwaggerString: SwagString;
begin
  Result := 0;
  LSwaggerString := Self.GetAttribute<SwagString>;
  if Assigned(LSwaggerString) then
    Result := LSwaggerString.maxLength;
end;

function TGBSwaggerRTTIPropertyHelper.SwagMinLength: Integer;
var
  LSwaggerString: SwagString;
begin
  Result := 0;
  LSwaggerString := Self.GetAttribute<SwagString>;
  if Assigned(LSwaggerString) then
    Result := LSwaggerString.minLength;
end;

function TGBSwaggerRTTIPropertyHelper.SwagName: string;
var
  LSwaggerProp: SwagProp;
begin
  Result := EmptyStr;
  LSwaggerProp := Self.GetAttribute<SwagProp>;
  if Assigned(LSwaggerProp) then
    Result := LSwaggerProp.name;

  if Result.Trim.IsEmpty then
    Result := Name;
end;

function TGBSwaggerRTTIPropertyHelper.SwagType: string;
begin
  if Self.IsString then
    Exit('string');

  if Self.IsInteger then
    Exit('integer');

  if Self.IsFloat then
    Exit('number');

  if Self.IsBoolean then
    Exit('boolean');

  if Self.IsList then
    Exit('array');

  if Self.IsArray then
    Exit('array');

  if Self.IsObject then
    Exit('object');

  if Self.IsEnum then
    Exit('string');

  if Self.IsDateTime then
    Exit('string');

  if Self.IsDate then
    Exit('string');

  if Self.IsTime then
    Exit('string');

  if Self.IsNullable then
    Exit(Self.NullableType);

  raise Exception.CreateFmt('Swagger type not found for Property %s.', [Self.SwagName]);
end;

{ TGBSwaggerObjectHelper }

class function TGBSwaggerObjectHelper.GetAttribute<T>: T;
var
  I: Integer;
  LType: TRttiType;
begin
  Result := nil;
  LType := TGBSwaggerRTTI.GetInstance.GetType(Self);
  for I := 0 to Pred(Length(LType.GetAttributes)) do
    if LType.GetAttributes[I].ClassNameIs(T.className) then
      Exit(T( LType.GetAttributes[I]));
end;

class function TGBSwaggerObjectHelper.GetAttributes: TArray<TCustomAttribute>;
var
  LType: TRttiType;
begin
  Result := nil;
  LType := TGBSwaggerRTTI.GetInstance.GetType(Self);
  Result := LType.GetAttributes;
end;

class function TGBSwaggerObjectHelper.GetAttributes<T>: TArray<T>;
var
  I: Integer;
  LAttr: TArray<TCustomAttribute>;
begin
  LAttr := Self.GetAttributes;
  for i := 0 to Pred(Length(LAttr)) do
  begin
    if LAttr[i].ClassNameIs(T.className) then
    begin
      SetLength(Result, Length(Result) + 1);
      Result[Length(Result) - 1] := T(LAttr[i] );
    end;
  end;
end;

class function TGBSwaggerObjectHelper.GetMethods: TArray<TRttiMethod>;
begin
  Result := TGBSwaggerRTTI.GetInstance.GetType(Self).GetMethods;
end;

class function TGBSwaggerObjectHelper.GetObjectProperties: TArray<TClass>;
var
  I: Integer;
begin
  for I := 0 to Pred(Length(Self.GetProperties)) do
  begin
    if GetProperties[I].IsSwaggerIgnore(Self) then
      Continue;

    if GetProperties[I].IsObject then
    begin
      SetLength(Result, Length(Result) + 1);
      Result[Length(Result) - 1] := GetProperties[I].GetClassType;
      Continue;
    end;

    if GetProperties[I].IsList then
    begin
      SetLength(Result, Length(Result) + 1);
      Result[Length(Result) - 1] := GetProperties[I].ListTypeClass;
      Continue;
    end;
  end;
end;

class function TGBSwaggerObjectHelper.GetProperties: TArray<TRttiProperty>;
begin
  Result := TGBSwaggerRTTI.GetInstance.GetType(Self).GetProperties;
end;

function TGBSwaggerObjectHelper.GetProperty(AName: string): TRttiProperty;
var
  I: Integer;
  LProperties: TArray<TRttiProperty>;
begin
  Result := nil;
  LProperties := Self.ClassType.GetProperties;

  for I := 0 to Pred(Length(LProperties)) do
    if LProperties[I].Name.ToLower.Equals(AName.ToLower) then
      Exit(LProperties[I]);
end;

class function TGBSwaggerObjectHelper.GetSwagClass: SwagClass;
begin
  Result := GetAttribute<SwagClass>;
end;

class function TGBSwaggerObjectHelper.GetSwagParamsFormData: TArray<SwagParamFormData>;
begin
  Result := Self.GetAttributes<SwagParamFormData>;
end;

class function TGBSwaggerObjectHelper.GetSwagParamHeaders: TArray<SwagParamHeader>;
begin
  Result := Self.GetAttributes<SwagParamHeader>;
end;

class function TGBSwaggerObjectHelper.GetSwagParamPaths: TArray<SwagParamPath>;
begin
  Result := Self.GetAttributes<SwagParamPath>;
end;

class function TGBSwaggerObjectHelper.GetSwagParamQueries: TArray<SwagParamQuery>;
begin
  Result := Self.GetAttributes<SwagParamQuery>;
end;

class function TGBSwaggerObjectHelper.GetSwagPath: SwagPath;
begin
  Result := Self.GetAttribute<SwagPath>;
end;

function TGBSwaggerObjectHelper.InvokeMethod(const AMethodName: string; const AParameters: array of TValue): TValue;
var
  LRttiType: TRttiType;
  LMethod: TRttiMethod;
begin
  LRttiType := TGBSwaggerRTTI.GetInstance.GetType(Self.ClassType);
  LMethod := LRttiType.GetMethod(AMethodName);
  if not Assigned(LMethod) then
    raise ENotImplemented.CreateFmt('Cannot find method %s in %s', [AMethodName, Self.ClassName]);
  Result := LMethod.Invoke(Self, AParameters);
end;

class function TGBSwaggerObjectHelper.SwagDescription(ASwagger: IGBSwagger): string;
var
  LSwag: SwagClass;
  I: Integer;
begin
  Result := EmptyStr;
  LSwag := GetSwagClass;
  if LSwag <> nil then
    Result := LSwag.description
  else
  begin
    Result := Self.ClassName;
    for I := 0 to Pred(Length(ASwagger.Config.ClassPrefixes)) do
    begin
      if not ASwagger.Config.ClassPrefixes[I].IsEmpty then
      begin
        if Result.StartsWith(ASwagger.Config.ClassPrefixes[I]) then
          Result := Copy(Result, ASwagger.Config.ClassPrefixes[I].Length + 1, Result.Length).Trim;
      end;
    end;
  end;
end;

class function TGBSwaggerObjectHelper.SwaggerIgnoreFields: TArray<string>;
var
  LSwaggerIgnore: SwagIgnore;
begin
  Result := [];
  LSwaggerIgnore := GetAttribute<SwagIgnore>;
  if Assigned(LSwaggerIgnore) then
    Result := LSwaggerIgnore.IgnoreProperties;
end;

class function TGBSwaggerObjectHelper.SwaggerRequiredFields: TArray<string>;
var
  LSwaggerRequired: SwagRequired;
  LSwaggerProp: SwagProp;
  LProp: TRttiProperty;
begin
  Result := [];
  for LProp in Self.GetProperties do
  begin
    LSwaggerRequired := LProp.GetAttribute<SwagRequired>;
    if (Assigned(LSwaggerRequired)) then
    begin
      SetLength(Result, Length(Result) + 1);
      Result[Length(Result) - 1] := LProp.Name;
      Continue;
    end;

    LSwaggerProp := LProp.GetAttribute<SwagProp>;
    if (Assigned(LSwaggerProp)) and (LSwaggerProp.required) then
    begin
      SetLength(Result, Length(Result) + 1);
      Result[Length(Result) - 1] := LProp.SwagName;
      Continue;
    end;
  end;
end;

{ TGBSwaggerMethodHelper }

function TGBSwaggerMethodHelper.GetSwagProduces: TArray<string>;
var
  LSwaggerProduces: SwagProduces;
  I: Integer;
begin
  Result := [];
  for I := 0 to Pred(Length(GetAttributes)) do
  begin
    if GetAttributes[I].ClassNameIs(SwagProduces.ClassName) then
    begin
      LSwaggerProduces := SwagProduces(GetAttributes[I]);
      SetLength(Result, Length(Result) + 1);
      Result[Length(Result) - 1] := LSwaggerProduces.Accept;
    end;
  end;
end;

function TGBSwaggerMethodHelper.GetSwagConsumes: TArray<string>;
var
  LSwaggerConsumes: SwagConsumes;
  I: Integer;
begin
  Result := [];
  for I := 0 to Pred(Length(GetAttributes)) do
  begin
    if GetAttributes[I].ClassNameIs(SwagConsumes.ClassName) then
    begin
      LSwaggerConsumes := SwagConsumes(GetAttributes[I]);
      SetLength(Result, Length(Result) + 1);
      Result[Length(Result) - 1] := LSwaggerConsumes.ContentType;
    end;
  end;
end;

function TGBSwaggerMethodHelper.GetSwagEndPoint: SwagEndPoint;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Pred(Length(GetAttributes)) do
  begin
    if GetAttributes[I].InheritsFrom(SwagEndPoint) then
      Exit(SwagEndPoint(GetAttributes[I]));
  end;
end;

function TGBSwaggerMethodHelper.GetSwagParamBody: SwagParamBody;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Pred(Length(GetAttributes)) do
  begin
    if GetAttributes[I].ClassNameIs(SwagParamBody.ClassName) then
      Exit(SwagParamBody(GetAttributes[I]));
  end;
end;

function TGBSwaggerMethodHelper.GetSwagParamFormData: TArray<SwagParamFormData>;
var
  I: Integer;
begin
  Result := [];
  for I := 0 to Pred(Length(GetAttributes)) do
  begin
    if GetAttributes[I].ClassNameIs(SwagParamFormData.ClassName) then
    begin
      SetLength(Result, Length(Result) + 1);
      Result[Length(Result) - 1] := SwagParamFormData(GetAttributes[I]);
    end;
  end;
end;

function TGBSwaggerMethodHelper.GetSwagParamHeader: TArray<SwagParamHeader>;
var
  I: Integer;
begin
  Result := [];
  for I := 0 to Pred(Length(GetAttributes)) do
  begin
    if GetAttributes[I].ClassNameIs(SwagParamHeader.ClassName) then
    begin
      SetLength(Result, Length(Result) + 1);
      Result[Length(Result) - 1] := SwagParamHeader(GetAttributes[I]);
    end;
  end;
end;

function TGBSwaggerMethodHelper.GetSwagParamPath: TArray<SwagParamPath>;
var
  I: Integer;
begin
  Result := [];
  for I := 0 to Pred(Length(GetAttributes)) do
  begin
    if GetAttributes[I].ClassNameIs(SwagParamPath.ClassName) then
    begin
      SetLength(Result, Length(Result) + 1);
      Result[Length(Result) - 1] := SwagParamPath( GetAttributes[I] );
    end;
  end;
end;

function TGBSwaggerMethodHelper.GetSwagParamQuery: TArray<SwagParamQuery>;
var
  I: Integer;
begin
  Result := [];
  for I := 0 to Pred(Length(GetAttributes)) do
  begin
    if GetAttributes[I].ClassNameIs(SwagParamQuery.ClassName) then
    begin
      SetLength(Result, Length(Result) + 1);
      Result[Length(Result) - 1] := SwagParamQuery(GetAttributes[I]);
    end;
  end;
end;

function TGBSwaggerMethodHelper.GetSwagResponse: TArray<SwagResponse>;
var
  I: Integer;
begin
  Result := [];
  for I := 0 to Pred(Length(GetAttributes)) do
  begin
    if GetAttributes[I].ClassNameIs(SwagResponse.ClassName) then
    begin
      SetLength(Result, Length(Result) + 1);
      Result[Length(Result) - 1] := SwagResponse( GetAttributes[I] );
    end;
  end;
end;

function TGBSwaggerMethodHelper.IsAuthBasic: Boolean;
var
  LAttribute: TCustomAttribute;
begin
  Result := False;
  for LAttribute in GetAttributes do
  begin
    if LAttribute.ClassNameIs(SwagSecurityBasic.ClassName) then
      Exit(True);
  end;
end;

function TGBSwaggerMethodHelper.IsAuthBearer: Boolean;
var
  LAttribute: TCustomAttribute;
begin
  Result := False;
  for LAttribute in GetAttributes do
  begin
    if LAttribute.ClassNameIs(SwagSecurityBearer.ClassName) then
      Exit(True);
  end;
end;

end.

