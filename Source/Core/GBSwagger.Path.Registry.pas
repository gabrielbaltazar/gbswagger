unit GBSwagger.Path.Registry;

interface

uses
  GBSwagger.Model.Types,
  GBSwagger.Model.Interfaces,
  GBSwagger.RTTI,
  GBSwagger.Path.Attributes,
  System.Rtti,
  System.StrUtils,
  System.SysUtils;

const
  SWAG_STRING  = GBSwagger.Model.Types.SWAG_STRING;
  SWAG_INTEGER = GBSwagger.Model.Types.SWAG_INTEGER;

type
  SwagPath = GBSwagger.Path.Attributes.SwagPath;
  SwagParamPath = GBSwagger.Path.Attributes.SwagParamPath;
  SwagParamHeader = GBSwagger.Path.Attributes.SwagParamHeader;
  SwagParamQuery = GBSwagger.Path.Attributes.SwagParamQuery;
  SwagParamBody = GBSwagger.Path.Attributes.SwagParamBody;
  SwagGET = GBSwagger.Path.Attributes.SwagGET;
  SwagPOST = GBSwagger.Path.Attributes.SwagPOST;
  SwagPUT = GBSwagger.Path.Attributes.SwagPUT;
  SwagDELETE = GBSwagger.Path.Attributes.SwagDELETE;
  SwagResponse = GBSwagger.Path.Attributes.SwagResponse;

  TGBSwaggerPathRegistry = class
  private
    class procedure RegisterMethods(AClass: TClass; APath: SwagPath);
    class procedure RegisterMethod(AClass: TClass; AMethod: TRttiMethod);

    class procedure RegisterMethodHeaders(AClass: TClass; AMethod: TRttiMethod; APathMethod: IGBSwaggerPathMethod);
    class procedure RegisterMethodPaths(AClass: TClass; AMethod: TRttiMethod; APathMethod: IGBSwaggerPathMethod);
    class procedure RegisterMethodQueries(AClass: TClass; AMethod: TRttiMethod; APathMethod: IGBSwaggerPathMethod);
    class procedure RegisterConsumes(AMethod: TRttiMethod; APathMethod: IGBSwaggerPathMethod);
    class procedure RegisterProduces(AMethod: TRttiMethod; APathMethod: IGBSwaggerPathMethod);
    class procedure RegisterMethodBody(AMethod: TRttiMethod; APathMethod: IGBSwaggerPathMethod);
    class procedure RegisterMethodFormData(AMethod: TRttiMethod; APathMethod: IGBSwaggerPathMethod);
    class procedure RegisterMethodResponse(AMethod: TRttiMethod; APathMethod: IGBSwaggerPathMethod);

    class function GetSwaggerMethod(AClass: TClass; AMethod: TRttiMethod): IGBSwaggerPathMethod;
  public
    class procedure RegisterPath(AClass: TClass); virtual;
end;

implementation

{ TGBSwaggerPathRegistry }

class function TGBSwaggerPathRegistry.GetSwaggerMethod(AClass: TClass; AMethod: TRttiMethod): IGBSwaggerPathMethod;
var
  LPathAttr: SwagPath;
  LEndpoint: SwagEndPoint;
  LPath: string;
  LPathName: string;
  LSwaggerPath: IGBSwaggerPath;
begin
  LPathAttr := AClass.GetSwagPath;
  LEndpoint := AMethod.GetSwagEndPoint;
//  pathName := IfThen(pathAttr.name.IsEmpty, AClass.ClassName, pathAttr.name);
  LPathName := LPathAttr.Name;
  LPath     := (LPathName + '/' + LEndpoint.Path).Replace('//', '/');

  if LPath.EndsWith('/') then
    LPath := LPath.Remove(High(LPath) - 1, 1);
  LSwaggerPath := Swagger.Path(LPath).Tag(LPathAttr.Tag);

  if LEndpoint is SwagGET then
    Result := LSwaggerPath.GET
  else
  if LEndpoint is SwagPOST then
    Result := LSwaggerPath.POST
  else
  if LEndpoint is SwagPUT then
    Result := LSwaggerPath.PUT
  else
  if LEndpoint is SwagDELETE then
    Result := LSwaggerPath.DELETE
  else
  if LEndpoint is SwagPATCH then
    Result := LSwaggerPath.PATCH
  else
    raise ENotImplemented.CreateFmt('Verbo http não implementado.', []);

  Result
    .Summary(LEndpoint.Summary)
    .Description(LEndpoint.Description)
    .IsPublic(LEndpoint.IsPublic);
end;

class procedure TGBSwaggerPathRegistry.RegisterProduces(AMethod: TRttiMethod; APathMethod: IGBSwaggerPathMethod);
var
  I: Integer;
  LAccept: TArray<string>;
begin
  LAccept := AMethod.GetSwagProduces;
  for I := 0 to Pred(Length(LAccept)) do
    APathMethod.AddProduces(LAccept[I]);
end;

class procedure TGBSwaggerPathRegistry.RegisterConsumes(AMethod: TRttiMethod; APathMethod: IGBSwaggerPathMethod);
var
  I: Integer;
  LContentType: TArray<string>;
begin
  LContentType := AMethod.GetSwagConsumes;
  for I := 0 to Pred(Length(LContentType)) do
    APathMethod.AddConsumes(LContentType[I]);
end;

class procedure TGBSwaggerPathRegistry.RegisterMethod(AClass: TClass; AMethod: TRttiMethod);
var
  LPathMethod: IGBSwaggerPathMethod;
begin
  LPathMethod := GetSwaggerMethod(AClass, AMethod);

  RegisterMethodHeaders(AClass, AMethod, LPathMethod);
  RegisterMethodPaths(AClass, AMethod, LPathMethod);
  RegisterMethodQueries(AClass, AMethod, LPathMethod);
  RegisterConsumes(AMethod, LPathMethod);
  RegisterProduces(AMethod, LPathMethod);
  RegisterMethodBody(AMethod, LPathMethod);
  RegisterMethodFormData(AMethod, LPathMethod);
  RegisterMethodResponse(AMethod, LPathMethod);
end;

class procedure TGBSwaggerPathRegistry.RegisterMethodBody(AMethod: TRttiMethod; APathMethod: IGBSwaggerPathMethod);
var
  LBody: SwagParamBody;
  LParameter: IGBSwaggerParameter;
begin
  LBody := AMethod.GetSwagParamBody;
  if Assigned(LBody) then
  begin
    LParameter := APathMethod
      .AddParamBody(LBody.Name, LBody.Description)
      .Required(LBody.Required)
      .IsArray(LBody.IsArray);

    if LBody.ClassType <> nil then
      LParameter.Schema(LBody.ClassType)
    else
      LParameter.Schema(LBody.Schema);
  end;
end;

class procedure TGBSwaggerPathRegistry.RegisterMethodFormData(AMethod: TRttiMethod; APathMethod: IGBSwaggerPathMethod);
var
  LParams: TArray<SwagParamFormData>;
  LFormData: SwagParamFormData;
  LCount: Integer;
  LParameter: IGBSwaggerParameter;
begin
  LParams := AMethod.GetSwagParamFormData;
  for LCount := 0 to Pred(Length(LParams)) do
  begin
    LFormData := LParams[LCount];
    LParameter := APathMethod.AddParamFormData(LFormData.Name, LFormData.Description);
    LParameter
      .Required(LFormData.Required)
      .Schema('string');

    if LFormData.IsFile then
      LParameter.Schema('file');
  end;
end;

class procedure TGBSwaggerPathRegistry.RegisterMethodHeaders(AClass: TClass; AMethod: TRttiMethod; APathMethod: IGBSwaggerPathMethod);
var
  I: Integer;
  LParams: TArray<SwagParamHeader>;
  LClassParams: TArray<SwagParamHeader>;
begin
  LClassParams := AClass.GetSwagParamHeaders;
  LParams := AMethod.GetSwagParamHeader;

  for I := 0 to Pred(Length(LClassParams)) do
  begin
    SetLength(LParams, Length(LParams) + 1);
    LParams[Length(LParams) - 1] := LClassParams[I];
  end;

  for I := 0 to Pred(Length(LParams)) do
  begin
    APathMethod.AddParamHeader(LParams[I].Name, LParams[I].Description)
      .Required(LParams[I].Required)
      .Schema(LParams[I].Schema)
      .EnumValues(LParams[I].EnumValues);
  end;
end;

class procedure TGBSwaggerPathRegistry.RegisterMethodPaths(AClass: TClass; AMethod: TRttiMethod; APathMethod: IGBSwaggerPathMethod);
var
  I: Integer;
  LParams: TArray<SwagParamPath>;
  LClassParams: TArray<SwagParamPath>;
begin
  LClassParams := AClass.GetSwagParamPaths;
  LParams := AMethod.GetSwagParamPath;
  for I := 0 to Pred(Length(LClassParams)) do
  begin
    SetLength(LParams, Length(LParams) + 1);
    LParams[Length(LParams) - 1] := LClassParams[I];
  end;

  for I := 0 to Pred(Length(LParams)) do
  begin
    APathMethod.AddParamPath(LParams[I].Name, LParams[I].Description)
      .Required(LParams[I].Required)
      .Schema(LParams[I].Schema)
      .EnumValues(LParams[I].EnumValues);
  end;
end;

class procedure TGBSwaggerPathRegistry.RegisterMethodQueries(AClass: TClass; AMethod: TRttiMethod; APathMethod: IGBSwaggerPathMethod);
var
  I: Integer;
  LParams: TArray<SwagParamQuery>;
  LClassParams: TArray<SwagParamQuery>;
begin
  LClassParams := AClass.GetSwagParamQueries;
  LParams := AMethod.GetSwagParamQuery;

  for I := 0 to Pred(Length(LClassParams)) do
  begin
    SetLength(LParams, Length(LParams) + 1);
    LParams[Length(LParams) - 1] := LClassParams[I];
  end;

  for I := 0 to Pred(Length(LParams)) do
  begin
    APathMethod.AddParamQuery(LParams[I].Name, LParams[I].Description)
      .Required(LParams[I].Required)
      .Schema(LParams[I].Schema)
      .EnumValues(LParams[I].EnumValues);
  end;
end;

class procedure TGBSwaggerPathRegistry.RegisterMethodResponse(AMethod: TRttiMethod; APathMethod: IGBSwaggerPathMethod);
var
  I: Integer;
  LResponses: TArray<SwagResponse>;
  LPathResponse: IGBSwaggerPathResponse;
  LClassType: TClass;
begin
  LResponses := AMethod.GetSwagResponse;
  for I := 0 to Pred(Length(LResponses)) do
  begin
    LPathResponse := APathMethod.AddResponse(LResponses[I].HttpCode).IsArray(LResponses[I].IsArray);
    if not LResponses[I].Description.IsEmpty then
      LPathResponse.Description(LResponses[I].Description);

    if not LResponses[I].Schema.IsEmpty then
      LPathResponse.Schema(LResponses[I].Schema);

    LClassType := LResponses[I].ClassType;
    if Assigned(LClassType) then
      LPathResponse.Schema(LResponses[I].ClassType);
  end;
end;

class procedure TGBSwaggerPathRegistry.RegisterMethods(AClass: TClass; APath: SwagPath);
var
  I, J: Integer;
  LMethods : TArray<TRttiMethod>;
begin
  LMethods := AClass.GetMethods;
  for I := 0 to Pred(Length(LMethods)) do
  begin
    for J := 0 to Pred(Length(LMethods[I].GetAttributes)) do
    begin
      if LMethods[I].GetAttributes[J].InheritsFrom(SwagEndPoint) then
        RegisterMethod(AClass, LMethods[I]);
    end;
  end;
end;

class procedure TGBSwaggerPathRegistry.RegisterPath(AClass: TClass);
var
  LPath: SwagPath;
begin
  LPath := AClass.GetSwagPath;
  if Assigned(LPath) then
    RegisterMethods(AClass, LPath);
end;

end.

