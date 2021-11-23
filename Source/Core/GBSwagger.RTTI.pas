unit GBSwagger.RTTI;

{$IF DEFINED(FPC)}
  {$MODE DELPHI}{$H+}
{$ENDIF}

interface

uses
{$IF DEFINED(FPC)}
  SysUtils, StrUtils, TypInfo, Rtti,
{$ELSE}
  System.SysUtils, System.StrUtils, System.TypInfo, System.Rtti,
  GBSwagger.Model.Attributes,
  GBSwagger.Path.Attributes,
{$ENDIF}
  GBSwagger.Model.Interfaces;

type
  IGBSwaggerRTTI = interface
    ['{B432A34C-5601-4254-A951-0DE059E73CCE}']
    function GetType(AClass: TClass): TRttiType;
    {$IF NOT DEFINED(FPC)}
    function FindType(ATypeName: string): TRttiType;
    {$ENDIF}
  end;

  TGBSwaggerRTTI = class(TInterfacedObject, IGBSwaggerRTTI)
    private
      class var FInstance: IGBSwaggerRTTI;

    private
      FContext: TRttiContext;

      constructor createPrivate;
    public
      function GetType (AClass: TClass): TRttiType;
      function FindType(ATypeName: string): TRttiType;

      class function GetInstance: IGBSwaggerRTTI;
      constructor create;
      destructor  Destroy; override;
  end;

  TGBSwaggerRTTITypeHelper = class helper for TRttiType
    public
      {$IF NOT DEFINED(FPC)}
      function GetAttribute<T: TCustomAttribute>: T;
      function GetSwagClass: SwagClass;
      {$ENDIF}
      function IsList: Boolean;
      function TypeName: string;
  end;

  TGBSwaggerRTTIPropertyHelper = class helper for TRttiProperty
    public
      function IsList     : Boolean;
      function IsString   : Boolean;
      function IsInteger  : Boolean;
      function IsEnum     : Boolean;
      function IsArray    : Boolean;
      function IsObject   : Boolean;
      function IsFloat    : Boolean;
      function IsDateTime : Boolean;
      function IsBoolean  : Boolean;

      // V�rios ORMs trabalham com tipo Nullable
      // Colabora��o do Giorgio para essa compatibilidade
      function IsNullable : Boolean;
      function NullableType : string;

      function IsEmptyValue(AObject: TObject): Boolean;

      {$IF NOT DEFINED(FPC)}
      function GetAttribute<T: TCustomAttribute>: T;
      function GetSwagNumber: SwagNumber;
      {$ENDIF}

      function IsSwaggerArray: Boolean;
      function IsSwaggerIgnore(AClass: TClass): Boolean;
      function IsSwaggerReadOnly: Boolean;

      function ArrayType: string;
      function ListType : string;
      function ListTypeClass: TClass;

      function SwagName: string;
      function SwagType: string;
      function SwagDescription: string;
      function SwagMinLength: Integer;
      function SwagMaxLength: Integer;

      function GetClassType: TClass;
      function GetListType(AObject: TObject): TRttiType;
      function GetEnumNames: TArray<String>;
  end;

  TGBSwaggerMethodHelper = class helper for TRttiMethod
    public
      {$IF NOT DEFINED(FPC)}
      function GetSwagEndPoint: SwagEndPoint;
      function GetSwagParamPath: TArray<SwagParamPath>;
      function GetSwagParamHeader: TArray<SwagParamHeader>;
      function GetSwagConsumes: TArray<String>;
      function GetSwagProduces: TArray<String>;
      function GetSwagParamQuery: TArray<SwagParamQuery>;
      function GetSwagParamBody: SwagParamBody;
      function GetSwagResponse: TArray<SwagResponse>;
      {$ENDIF}
  end;

  TGBSwaggerObjectHelper = class helper for TObject
    private
      {$IF NOT DEFINED(FPC)}
      class function GetAttributes: TArray<TCustomAttribute>; overload;
      class function GetAttributes<T: TCustomAttribute>: TArray<T>; overload;
      {$ENDIF}
    public
      function invokeMethod(const MethodName: string; const Parameters: array of TValue): TValue;

      function GetProperty(Name: String): TRttiProperty;

      class function GetObjectProperties: TArray<TClass>;
      class function GetProperties: TArray<TRttiProperty>;
      class function GetMethods   : TArray<TRttiMethod>;
      {$IF NOT DEFINED(FPC)}
      class function GetAttribute<T: TCustomAttribute>: T;
      class function GetSwagClass: SwagClass;
      class function GetSwagPath : SwagPath;
      class function GetSwagParamPaths: TArray<SwagParamPath>;
      class function GetSwagParamHeaders: TArray<SwagParamHeader>;
      class function GetSwagParamQueries: TArray<SwagParamQuery>;
      {$ENDIF}

      class function SwagDescription(ASwagger: IGBSwagger): string;
      class function SwaggerRequiredFields: TArray<String>;
      class function SwaggerIgnoreFields: TArray<String>;
  end;

implementation

{ TGBSwaggerRTTI }

constructor TGBSwaggerRTTI.create;
begin
  raise Exception.Create('Utilize o Construtor GetInstance.');
end;

constructor TGBSwaggerRTTI.createPrivate;
begin
  FContext := TRttiContext.Create;
end;

destructor TGBSwaggerRTTI.Destroy;
begin
  FContext.Free;
  inherited;
end;

{$IF NOT DEFINED(FPC)}
function TGBSwaggerRTTI.FindType(ATypeName: string): TRttiType;
begin
  Result := FContext.FindType(ATypeName);
end;
{$ENDIF}

class function TGBSwaggerRTTI.GetInstance: IGBSwaggerRTTI;
begin
  if not Assigned(FInstance) then
    FInstance := TGBSwaggerRTTI.createPrivate;
  result := FInstance;
end;

function TGBSwaggerRTTI.GetType(AClass: TClass): TRttiType;
begin
  result := FContext.GetType(AClass);
end;

{ TGBSwaggerRTTITypeHelper }

{$IF NOT DEFINED(FPC)}
function TGBSwaggerRTTITypeHelper.GetAttribute<T>: T;
var
  i : Integer;
begin
  result := nil;

  for i := 0 to Length(GetAttributes) - 1 do
  begin
    if GetAttributes[i].ClassNameIs(T.className) then
      Exit(T( GetAttributes[i]));
  end;
end;
{$ENDIF}

function TGBSwaggerRTTITypeHelper.IsList: Boolean;
begin
  result := False;

  if Self.AsInstance.Name.ToLower.StartsWith('tobjectlist<') then
    Exit(True);

  if Self.AsInstance.Name.ToLower.StartsWith('tlist<') then
    Exit(True);
end;

function TGBSwaggerRTTITypeHelper.TypeName: string;
begin
  result := Self.AsInstance.Name;
end;

{$IF NOT DEFINED(FPC)}
function TGBSwaggerRTTITypeHelper.GetSwagClass: SwagClass;
begin
  result := GetAttribute<SwagClass>;
end;
{$ENDIF}

{ TGBSwaggerRTTIPropertyHelper }

function TGBSwaggerRTTIPropertyHelper.ArrayType: string;
begin
  result := EmptyStr;
  if (IsArray) then
    {$IF NOT DEFINED(FPC)}
    result := TRttiDynamicArrayType(Self.PropertyType).ElementType.Name;
    {$ELSE}
    result := Self.PropertyType.Name;
    {$ENDIF}
end;

{$IF NOT DEFINED(FPC)}
function TGBSwaggerRTTIPropertyHelper.GetAttribute<T>: T;
var
  i: Integer;
begin
  result := nil;
  for i := 0 to Pred(Length(Self.GetAttributes)) do
    if Self.GetAttributes[i].ClassNameIs(T.className) then
      Exit(T( Self.GetAttributes[i]));
end;
{$ENDIF}

function TGBSwaggerRTTIPropertyHelper.GetClassType: TClass;
begin
  {$IF NOT DEFINED(FPC)}
  result := TRttiInstanceType( TGBSwaggerRTTI.GetInstance.FindType(
    PropertyType.QualifiedName
  )).MetaclassType;
  {$ELSE}
  result := PropertyType.ClassType;
  {$ENDIF}
end;

function TGBSwaggerRTTIPropertyHelper.GetEnumNames: TArray<String>;
var
  i : Integer;
  unitName: string;
  enumName: string;
begin
  unitName := PropertyType.QualifiedName.Replace('.' + PropertyType.ToString, EmptyStr);
  i        := 0;

  repeat
    enumName := GetEnumName(TGBSwaggerRTTI.GetInstance.FindType(PropertyType.QualifiedName).Handle, i);
    if not enumName.Equals(unitName) then
    begin
      SetLength(result, i + 1);
      result[i] := enumName;
      i := i + 1;
    end;
  until enumName.Equals(unitName);
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

  result := TGBSwaggerRTTI.GetInstance.FindType(ListTypeName);
end;

{$IF NOT DEFINED(FPC)}
function TGBSwaggerRTTIPropertyHelper.GetSwagNumber: SwagNumber;
begin
  result := GetAttribute<SwagNumber>;
end;
{$ENDIF}

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
    result := Self.PropertyType.ToString.ToLower.Equals('boolean');
end;

function TGBSwaggerRTTIPropertyHelper.IsDateTime: Boolean;
var
  Ltype : string;
begin
  if Self.IsNullable then
    Ltype := Self.NullableType.ToLower
  else
    Ltype := Self.PropertyType.ToString.ToLower;

  result := (Ltype.Equals('tdatetime')) or
            (Ltype.Equals('tdate')) or
            (Ltype.Equals('ttime'));
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

  if IsDateTime then
    Exit(Self.GetValue(AObject).AsExtended = 0);
end;

function TGBSwaggerRTTIPropertyHelper.IsEnum: Boolean;
begin
  result := (not IsBoolean) and (Self.PropertyType.TypeKind = tkEnumeration);
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
    Result := (Self.PropertyType.TypeKind = tkFloat) and (not IsDateTime);
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
    result := Self.PropertyType.TypeKind in [tkInt64, tkInteger];
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
  result := (not IsList) and (Self.PropertyType.TypeKind = tkClass);
end;

function TGBSwaggerRTTIPropertyHelper.IsString: Boolean;
begin
  if Self.IsNullable then
    Result := Self.NullableType.ToLower.Equals('string')
  else
    result := Self.PropertyType.TypeKind in [tkChar,
                                             tkString,
                                             tkWChar,
                                             tkLString,
                                             tkWString,
                                             tkUString];
end;

{$IF NOT DEFINED(FPC)}
function TGBSwaggerRTTIPropertyHelper.IsSwaggerArray: Boolean;
begin
  result := (IsArray) or (IsList);
end;
{$ENDIF}

function TGBSwaggerRTTIPropertyHelper.IsSwaggerIgnore(AClass: TClass): Boolean;
var
  ignoreFields: TArray<String>;
  i: Integer;
begin
  result := False;
  ignoreFields := AClass.SwaggerIgnoreFields;
  for i := 0 to Pred(Length(ignoreFields)) do
  begin
    if Name.ToLower.Equals(ignoreFields[i].ToLower) then
      Exit(True);
  end;

  {$IF NOT DEFINED(FPC)}
  result := Self.GetAttribute<SwagIgnore> <> nil;
  if not Result then
  begin
    if AClass.InheritsFrom(TInterfacedObject) then
      result := Self.Name.ToLower.Equals('refcount');
  end;
  {$ENDIF}
end;

function TGBSwaggerRTTIPropertyHelper.IsSwaggerReadOnly: Boolean;
{$IF NOT DEFINED(FPC)}
var
  swaggerProp: SwagProp;
{$ENDIF}
begin
  result := False;
  {$IF NOT DEFINED(FPC)}
  swaggerProp := GetAttribute<SwagProp>;
  if (Assigned(swaggerProp)) and (swaggerProp.readOnly) then
    result := True;
  {$ENDIF}
end;

function TGBSwaggerRTTIPropertyHelper.ListType: string;
var
  baseType: string;
begin
  result := EmptyStr;
  if IsList then
  begin
    if Assigned(PropertyType.BaseType) then
    begin
      baseType := PropertyType.Name;
      baseType := Copy(baseType, 1, Pos('<', baseType));
    end;
    Result := PropertyType.ToString
                .Replace('TObjectList<', EmptyStr)
                .Replace('TList<', EmptyStr)
                .Replace(baseType, EmptyStr)
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
  LNullableType : string;
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
{$IF NOT DEFINED(FPC)}
var
  swaggerProp: SwagProp;
{$ENDIF}
begin
  result := EmptyStr;
  {$IF NOT DEFINED(FPC)}
  swaggerProp := Self.GetAttribute<SwagProp>;
  if Assigned(swaggerProp) then
    result := swaggerProp.description;
  {$ENDIF}
end;

function TGBSwaggerRTTIPropertyHelper.SwagMaxLength: Integer;
{$IF NOT DEFINED(FPC)}
var
  swaggerString: SwagString;
{$ENDIF}
begin
  result := 0;
  {$IF NOT DEFINED(FPC)}
  swaggerString := Self.GetAttribute<SwagString>;
  if Assigned(swaggerString) then
    result := swaggerString.maxLength;
  {$ENDIF}
end;

function TGBSwaggerRTTIPropertyHelper.SwagMinLength: Integer;
{$IF NOT DEFINED(FPC)}
var
  swaggerString: SwagString;
{$ENDIF}
begin
  result := 0;
  {$IF NOT DEFINED(FPC)}
  swaggerString := Self.GetAttribute<SwagString>;
  if Assigned(swaggerString) then
    result := swaggerString.minLength;
  {$ENDIF}
end;

function TGBSwaggerRTTIPropertyHelper.SwagName: string;
{$IF NOT DEFINED(FPC)}
var
  SwaggerProp: SwagProp;
{$ENDIF}
begin
  result := EmptyStr;
  {$IF NOT DEFINED(FPC)}
  swaggerProp := Self.GetAttribute<SwagProp>;
  if Assigned(swaggerProp) then
    result := swaggerProp.name;
  {$ENDIF}

  if result.Trim.IsEmpty then
    result := Name;
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

  if Self.IsNullable then
    Exit(Self.NullableType);

  raise Exception.CreateFmt('Swagger type not found for Property %s.', [Self.SwagName]);
end;

{ TGBSwaggerObjectHelper }

{$IF NOT DEFINED(FPC)}
class function TGBSwaggerObjectHelper.GetAttribute<T>: T;
var
  i: Integer;
  rType: TRttiType;
begin
  result := nil;
  rType  := TGBSwaggerRTTI.GetInstance.GetType(Self);

  for i := 0 to Pred(Length(rType.GetAttributes)) do
    if rType.GetAttributes[i].ClassNameIs(T.className) then
      Exit(T( rType.GetAttributes[i]));
end;
{$ENDIF}

{$IF NOT DEFINED(FPC)}
class function TGBSwaggerObjectHelper.GetAttributes: TArray<TCustomAttribute>;
var
  rType: TRttiType;
begin
  result := nil;
  rType  := TGBSwaggerRTTI.GetInstance.GetType(Self);
  result := rType.GetAttributes;
end;
{$ENDIF}

{$IF NOT DEFINED(FPC)}
class function TGBSwaggerObjectHelper.GetAttributes<T>: TArray<T>;
var
  i : Integer;
  attr: TArray<TCustomAttribute>;
begin
  attr := Self.GetAttributes;
  for i := 0 to Pred(Length(attr)) do
  begin
    if attr[i].ClassNameIs(T.className) then
    begin
      SetLength(Result, Length(result) + 1);
      result[Length(result) - 1] := T( attr[i] );
    end;
  end;
end;
{$ENDIF}

class function TGBSwaggerObjectHelper.GetMethods: TArray<TRttiMethod>;
begin
  result := TGBSwaggerRTTI.GetInstance.GetType(Self).GetMethods;
end;

class function TGBSwaggerObjectHelper.GetObjectProperties: TArray<TClass>;
var
  i: Integer;
begin
  for i := 0 to Pred(Length(Self.GetProperties)) do
  begin
    if GetProperties[i].IsSwaggerIgnore(Self) then
      Continue;

    if GetProperties[i].IsObject then
    begin
      SetLength(Result, Length(result) + 1);
      result[Length(result) - 1] := GetProperties[i].GetClassType;
      Continue;
    end;

    if GetProperties[i].IsList then
    begin
      SetLength(Result, Length(result) + 1);
      result[Length(result) - 1] := GetProperties[i].ListTypeClass;
      Continue;
    end;
  end;
end;

class function TGBSwaggerObjectHelper.GetProperties: TArray<TRttiProperty>;
begin
  result := TGBSwaggerRTTI.GetInstance.GetType(Self).GetProperties;
end;

function TGBSwaggerObjectHelper.GetProperty(Name: String): TRttiProperty;
var
  i : Integer;
  properties: TArray<TRttiProperty>;
begin
  result := nil;
  properties := Self.ClassType.GetProperties;

  for i := 0 to Pred(Length(properties)) do
    if properties[i].Name.ToLower.Equals(Name.ToLower) then
      Exit(properties[i]);
end;

class function TGBSwaggerObjectHelper.GetSwagClass: SwagClass;
begin
  Result := GetAttribute<SwagClass>;
end;

class function TGBSwaggerObjectHelper.GetSwagParamHeaders: TArray<SwagParamHeader>;
begin
  result := Self.GetAttributes<SwagParamHeader>;
end;

class function TGBSwaggerObjectHelper.GetSwagParamPaths: TArray<SwagParamPath>;
begin
  result := Self.GetAttributes<SwagParamPath>;
end;

class function TGBSwaggerObjectHelper.GetSwagParamQueries: TArray<SwagParamQuery>;
begin
  result := Self.GetAttributes<SwagParamQuery>;
end;

class function TGBSwaggerObjectHelper.GetSwagPath: SwagPath;
begin
  result := Self.GetAttribute<SwagPath>;
end;

function TGBSwaggerObjectHelper.invokeMethod(const MethodName: string; const Parameters: array of TValue): TValue;
var
  rttiType: TRttiType;
  method  : TRttiMethod;
begin
  rttiType := TGBSwaggerRTTI.GetInstance.GetType(Self.ClassType);
  method   := rttiType.GetMethod(MethodName);

  if not Assigned(method) then
    raise ENotImplemented.CreateFmt('Cannot find method %s in %s', [MethodName, Self.ClassName]);

  result := method.Invoke(Self, Parameters);
end;

class function TGBSwaggerObjectHelper.SwagDescription(ASwagger: IGBSwagger): string;
var
{$IF NOT DEFINED(FPC)}
  swag: SwagClass;
{$ENDIF}
  i: Integer;
begin
  result := EmptyStr;
  {$IF NOT DEFINED(FPC)}
  swag := GetSwagClass;

  if swag <> nil then
    result := swag.description
  else
  {$ENDIF}
  begin
    result := Self.ClassName;

    for i := 0 to Pred(Length(ASwagger.Config.ClassPrefixes)) do
    begin
      if not ASwagger.Config.ClassPrefixes[i].IsEmpty then
      begin
        if Result.StartsWith(ASwagger.Config.ClassPrefixes[i]) then
          result := Copy(Result, ASwagger.Config.ClassPrefixes[i].Length + 1, result.Length).Trim;
      end;
    end;
  end;
end;

class function TGBSwaggerObjectHelper.SwaggerIgnoreFields: TArray<String>;
{$IF NOT DEFINED(FPC)}
var
  swaggerIgnore: SwagIgnore;
{$ENDIF}
begin
  result := [];
  {$IF NOT DEFINED(FPC)}
  swaggerIgnore := GetAttribute<SwagIgnore>;

  if Assigned(swaggerIgnore) then
    result := swaggerIgnore.IgnoreProperties;
  {$ENDIF}
end;

class function TGBSwaggerObjectHelper.SwaggerRequiredFields: TArray<String>;
var
{$IF NOT DEFINED(FPC)}
  swaggerRequired: SwagRequired;
  swaggerProp: SwagProp;
  rProp: TRttiProperty;
{$ENDIF}
begin
  result := [];

  {$IF NOT DEFINED(FPC)}
  for rProp in Self.GetProperties do
  begin
    swaggerRequired := rProp.GetAttribute<SwagRequired>;
    if (Assigned(swaggerRequired)) then
    begin
      SetLength(result, Length(result) + 1);
      result[Length(result) - 1] := rProp.Name;
      Continue;
    end;

    swaggerProp := rProp.GetAttribute<SwagProp>;
    if (Assigned(swaggerProp)) and (swaggerProp.required) then
    begin
      SetLength(result, Length(result) + 1);
      result[Length(result) - 1] := rProp.SwagName;
      Continue;
    end;
  end;
  {$ENDIF}
end;

{ TGBSwaggerMethodHelper }

{$IF NOT DEFINED(FPC)}
function TGBSwaggerMethodHelper.GetSwagProduces: TArray<String>;
var
  swaggerProduces: SwagProduces;
  i : Integer;
begin
  result := [];
  for i := 0 to Pred(Length(GetAttributes)) do
  begin
    if GetAttributes[i].ClassNameIs(SwagProduces.ClassName) then
    begin
      swaggerProduces := SwagProduces(GetAttributes[i]);
      SetLength(Result, Length(result) + 1);
      result[Length(result) - 1] := swaggerProduces.Accept;
    end;
  end;
end;

function TGBSwaggerMethodHelper.GetSwagConsumes: TArray<String>;
var
  swaggerConsumes: SwagConsumes;
  i : Integer;
begin
  result := [];
  for i := 0 to Pred(Length(GetAttributes)) do
  begin
    if GetAttributes[i].ClassNameIs(SwagConsumes.ClassName) then
    begin
      swaggerConsumes := SwagConsumes(GetAttributes[i]);
      SetLength(Result, Length(result) + 1);
      result[Length(result) - 1] := swaggerConsumes.ContentType;
    end;
  end;
end;

function TGBSwaggerMethodHelper.GetSwagEndPoint: SwagEndPoint;
var
  i: Integer;
begin
  result := nil;
  for i := 0 to Pred(Length(GetAttributes)) do
  begin
    if GetAttributes[i].InheritsFrom(SwagEndPoint) then
      Exit(SwagEndPoint(GetAttributes[i]));
  end;
end;

function TGBSwaggerMethodHelper.GetSwagParamBody: SwagParamBody;
var
  i: Integer;
begin
  result := nil;
  for i := 0 to Pred(Length(GetAttributes)) do
  begin
    if GetAttributes[i].ClassNameIs(SwagParamBody.ClassName) then
      Exit(SwagParamBody(GetAttributes[i]));
  end;
end;

function TGBSwaggerMethodHelper.GetSwagParamHeader: TArray<SwagParamHeader>;
var
  i: Integer;
begin
  result := [];
  for i := 0 to Pred(Length(GetAttributes)) do
  begin
    if GetAttributes[i].ClassNameIs(SwagParamHeader.ClassName) then
    begin
      SetLength(Result, Length(result) + 1);
      result[Length(Result) - 1] := SwagParamHeader(GetAttributes[i]);
    end;
  end;
end;

function TGBSwaggerMethodHelper.GetSwagParamPath: TArray<SwagParamPath>;
var
  i: Integer;
begin
  result := [];
  for i := 0 to Pred(Length(GetAttributes)) do
  begin
    if GetAttributes[i].ClassNameIs(SwagParamPath.ClassName) then
    begin
      SetLength(Result, Length(result) + 1);
      result[Length(Result) - 1] := SwagParamPath( GetAttributes[i] );
    end;
  end;
end;

function TGBSwaggerMethodHelper.GetSwagParamQuery: TArray<SwagParamQuery>;
var
  i: Integer;
begin
  result := [];
  for i := 0 to Pred(Length(GetAttributes)) do
  begin
    if GetAttributes[i].ClassNameIs(SwagParamQuery.ClassName) then
    begin
      SetLength(Result, Length(result) + 1);
      result[Length(Result) - 1] := SwagParamQuery(GetAttributes[i]);
    end;
  end;
end;

function TGBSwaggerMethodHelper.GetSwagResponse: TArray<SwagResponse>;
var
  i: Integer;
begin
  result := [];
  for i := 0 to Pred(Length(GetAttributes)) do
  begin
    if GetAttributes[i].ClassNameIs(SwagResponse.ClassName) then
    begin
      SetLength(Result, Length(result) + 1);
      result[Length(Result) - 1] := SwagResponse( GetAttributes[i] );
    end;
  end;
end;
{$ENDIF}

end.

