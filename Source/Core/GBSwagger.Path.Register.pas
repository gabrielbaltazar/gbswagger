unit GBSwagger.Path.Register;

interface

uses
  GBSwagger.Types,
  GBSwagger.Model.Interfaces,
  GBSwagger.RTTI,
  GBSwagger.Path.Attributes,
  System.Rtti,
  System.StrUtils,
  System.SysUtils;

const
  SWAG_STRING  = GBSwagger.Types.SWAG_STRING;
  SWAG_INTEGER = GBSwagger.Types.SWAG_INTEGER;

type
  SwagPath        = GBSwagger.Path.Attributes.SwagPath;
  SwagParamPath   = GBSwagger.Path.Attributes.SwagParamPath;
  SwagParamHeader = GBSwagger.Path.Attributes.SwagParamHeader;
  SwagParamQuery  = GBSwagger.Path.Attributes.SwagParamQuery;
  SwagParamBody   = GBSwagger.Path.Attributes.SwagParamBody;
  SwagGET         = GBSwagger.Path.Attributes.SwagGET;
  SwagPOST        = GBSwagger.Path.Attributes.SwagPOST;
  SwagPUT         = GBSwagger.Path.Attributes.SwagPUT;
  SwagDELETE      = GBSwagger.Path.Attributes.SwagDELETE;
  SwagResponse    = GBSwagger.Path.Attributes.SwagResponse;

  TGBSwaggerPathRegister = class

  private
    class procedure RegisterMethods(AClass: TClass; APath: SwagPath);
    class procedure RegisterMethod (AClass: TClass; AMethod: TRttiMethod);

    class procedure RegisterMethodHeaders  (AClass: TClass; AMethod: TRttiMethod; APathMethod: IGBSwaggerPathMethod);
    class procedure RegisterMethodPaths    (AClass: TClass; AMethod: TRttiMethod; APathMethod: IGBSwaggerPathMethod);
    class procedure RegisterMethodQueries  (AClass: TClass; AMethod: TRttiMethod; APathMethod: IGBSwaggerPathMethod);
    class procedure RegisterConsumes       (AMethod: TRttiMethod; APathMethod: IGBSwaggerPathMethod);
    class procedure RegisterProduces       (AMethod: TRttiMethod; APathMethod: IGBSwaggerPathMethod);
    class procedure RegisterMethodBody     (AMethod: TRttiMethod; APathMethod: IGBSwaggerPathMethod);
    class procedure RegisterMethodResponse (AMethod: TRttiMethod; APathMethod: IGBSwaggerPathMethod);

    class function GetSwaggerMethod(AClass: TClass; AMethod: TRttiMethod): IGBSwaggerPathMethod;
  public
    class procedure RegisterPath(AClass: TClass); virtual;
end;

implementation

{ TGBSwaggerPathRegister }

class function TGBSwaggerPathRegister.GetSwaggerMethod(AClass: TClass; AMethod: TRttiMethod): IGBSwaggerPathMethod;
var
  pathAttr   : SwagPath;
  endpoint   : SwagEndPoint;
  path       : string;
  pathName   : string;
  swaggerPath: IGBSwaggerPath;
begin
  pathAttr := AClass.GetSwagPath;
  endpoint := AMethod.GetSwagEndPoint;
//  pathName := IfThen(pathAttr.name.IsEmpty, AClass.ClassName, pathAttr.name);
  pathName := pathAttr.name;
  path     := (pathName + '/' + endpoint.path).Replace('//', '/');

  if path.EndsWith('/') then
    path := path.Remove(High(path) - 1, 1);
  swaggerPath := Swagger.Path(path).Tag(pathAttr.tag);

  if endpoint is SwagGET then
    result := swaggerPath.GET
  else
  if endpoint is SwagPOST then
    Result := swaggerPath.POST
  else
  if endpoint is SwagPUT then
    result := swaggerPath.PUT
  else
  if endpoint is SwagDELETE then
    Result := swaggerPath.DELETE
  else
  if endpoint is SwagPATCH then
    Result := swaggerPath.PATCH
  else
    raise ENotImplemented.CreateFmt('Verbo http não implementado.', []);

  Result
    .Summary(endpoint.summary)
    .Description(endpoint.description)
    .IsPublic(endpoint.isPublic);
end;

class procedure TGBSwaggerPathRegister.RegisterProduces(AMethod: TRttiMethod; APathMethod: IGBSwaggerPathMethod);
var
  i : Integer;
  accept: TArray<String>;
begin
  accept := AMethod.GetSwagProduces;
  for i := 0 to Pred(Length(accept)) do
    APathMethod.AddProduces(accept[i]);
end;

class procedure TGBSwaggerPathRegister.RegisterConsumes(AMethod: TRttiMethod; APathMethod: IGBSwaggerPathMethod);
var
  i : Integer;
  contentType: TArray<String>;
begin
  contentType := AMethod.GetSwagConsumes;
  for i := 0 to Pred(Length(contentType)) do
    APathMethod.AddConsumes(contentType[i]);
end;

class procedure TGBSwaggerPathRegister.RegisterMethod(AClass: TClass; AMethod: TRttiMethod);
var
  pathMethod: IGBSwaggerPathMethod;
begin
  pathMethod := GetSwaggerMethod(AClass, AMethod);

  RegisterMethodHeaders  (AClass, AMethod, pathMethod);
  RegisterMethodPaths    (AClass, AMethod, pathMethod);
  RegisterMethodQueries  (AClass, AMethod, pathMethod);
  RegisterConsumes       (AMethod, pathMethod);
  RegisterProduces       (AMethod, pathMethod);
  RegisterMethodBody     (AMethod, pathMethod);
  RegisterMethodResponse (AMethod, pathMethod);
end;

class procedure TGBSwaggerPathRegister.RegisterMethodBody(AMethod: TRttiMethod; APathMethod: IGBSwaggerPathMethod);
var
  body     : SwagParamBody;
  parameter: IGBSwaggerParameter;
begin
  body := AMethod.GetSwagParamBody;
  if Assigned(body) then
  begin
    parameter :=
      APathMethod
        .AddParamBody(body.name, body.description)
        .Required(body.required)
        .IsArray(body.isArray);

    if body.classType <> nil then
      parameter.Schema(body.classType)
    else
      parameter.Schema(body.schema);
  end;
end;

class procedure TGBSwaggerPathRegister.RegisterMethodHeaders(AClass: TClass; AMethod: TRttiMethod; APathMethod: IGBSwaggerPathMethod);
var
  i      : Integer;
  params : TArray<SwagParamHeader>;
  classParams : TArray<SwagParamHeader>;
begin
  classParams := AClass.GetSwagParamHeaders;
  params := AMethod.GetSwagParamHeader;

  for i := 0 to Pred(Length(classParams)) do
  begin
    SetLength(params, Length(params) + 1);
    params[Length(params) - 1] := classParams[i];
  end;

  for i := 0 to Pred(Length(params)) do
  begin
    APathMethod
      .AddParamHeader(params[i].name, params[i].description)
        .Required(params[i].required)
        .Schema(params[i].schema)
        .EnumValues(params[i].enumValues);
  end;
end;

class procedure TGBSwaggerPathRegister.RegisterMethodPaths(AClass: TClass; AMethod: TRttiMethod; APathMethod: IGBSwaggerPathMethod);
var
  i           : Integer;
  params      : TArray<SwagParamPath>;
  classParams : TArray<SwagParamPath>;
begin
  classParams := AClass.GetSwagParamPaths;
  params := AMethod.GetSwagParamPath;

  for i := 0 to Pred(Length(classParams)) do
  begin
    SetLength(params, Length(params) + 1);
    params[Length(params) - 1] := classParams[i];
  end;

  for i := 0 to Pred(Length(params)) do
  begin
    APathMethod
      .AddParamPath(params[i].name, params[i].description)
        .Required(params[i].required)
        .Schema(params[i].schema)
        .EnumValues(params[i].enumValues);
  end;
end;

class procedure TGBSwaggerPathRegister.RegisterMethodQueries(AClass: TClass; AMethod: TRttiMethod; APathMethod: IGBSwaggerPathMethod);
var
  i           : Integer;
  params      : TArray<SwagParamQuery>;
  classParams : TArray<SwagParamQuery>;
begin
  classParams := AClass.GetSwagParamQueries;
  params := AMethod.GetSwagParamQuery;

  for i := 0 to Pred(Length(classParams)) do
  begin
    SetLength(params, Length(params) + 1);
    params[Length(params) - 1] := classParams[i];
  end;

  for i := 0 to Pred(Length(params)) do
  begin
    APathMethod
      .AddParamQuery(params[i].name, params[i].description)
        .Required(params[i].required)
        .Schema(params[i].schema)
        .EnumValues(params[i].enumValues);
  end;
end;

class procedure TGBSwaggerPathRegister.RegisterMethodResponse(AMethod: TRttiMethod; APathMethod: IGBSwaggerPathMethod);
var
  i            : Integer;
  responses    : TArray<SwagResponse>;
  pathResponse : IGBSwaggerPathResponse;
  classType    : TClass;
begin
  responses := AMethod.GetSwagResponse;
  for i := 0 to Pred(Length(responses)) do
  begin
    pathResponse := APathMethod.AddResponse(responses[i].httpCode).IsArray(responses[i].isArray);

    if not responses[i].description.IsEmpty then
      pathResponse.Description(responses[i].description);

    if not responses[i].schema.IsEmpty then
      pathResponse.Schema(responses[i].schema);

    classType := responses[i].classType;
    if Assigned(classType) then
      pathResponse.Schema(responses[i].classType);
  end;
end;

class procedure TGBSwaggerPathRegister.RegisterMethods(AClass: TClass; APath: SwagPath);
var
  i, j    : Integer;
  methods : TArray<TRttiMethod>;
begin
  methods := AClass.GetMethods;
  for i := 0 to Pred(Length(methods)) do
  begin
    for j := 0 to Pred(Length(methods[i].GetAttributes)) do
    begin
      if methods[i].GetAttributes[j].InheritsFrom(SwagEndPoint) then
        RegisterMethod(AClass, methods[i]);
    end;
  end;
end;

class procedure TGBSwaggerPathRegister.RegisterPath(AClass: TClass);
var
  path : SwagPath;
begin
  path := AClass.GetSwagPath;

  if Assigned(path) then
    RegisterMethods(AClass, path);
end;

end.

