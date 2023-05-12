unit Horse.GBSwagger.Register;

interface

uses
  Horse,
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.Types,
  GBSwagger.Path.Attributes,
  GBSwagger.Path.Registry,
  GBSwagger.RTTI,
  System.Rtti,
  System.StrUtils,
  System.SysUtils,
  System.Classes;

type
  THorseGBSwaggerRegister = class(TGBSwaggerPathRegistry)
  private
    class function GetPathMethod(AClass: TClass; AEndPoint: SwagEndPoint): string;
    class procedure RegisterMethods(AClass: TClass; APath: SwagPath);
    class procedure RegisterMethod(AClass: TClass; AMethod: TRttiMethod);
    class procedure RegisterMethodAuth(AClass: TClass; AMethod: TRttiMethod);
  public
    class procedure RegisterPath(AClass: TClass); override;
  end;

function HorseCallback(AClass: TClass; AMethod: TRttiMethod): THorseCallback;

implementation

function HorseCallback(AClass: TClass; AMethod: TRttiMethod): THorseCallback;
begin
  Result :=
    procedure (Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      LConstructMethod: TRttiMethod;
      LInstance: TObject;
      LArgs: array of TValue;

      procedure RaiseConstructorException;
      begin
        raise EMethodNotFound.CreateFmt('You must implemented constructor method ' +
          'create(Req: THorseRequest; Res: THorseResponse) ' +
          'in %s class', [AClass.ClassName]);
      end;

    begin
      LConstructMethod := TGBSwaggerRTTI.GetInstance.GetType(AClass)
        .GetMethod('create');
      if Assigned(LConstructMethod) then
      begin
        if Length( LConstructMethod.GetParameters ) <> 2 then
          RaiseConstructorException;

        if not LConstructMethod.GetParameters[0]
          .ParamType.TypeName.ToLower.Equals('thorserequest') then
          RaiseConstructorException;

        if not LConstructMethod.GetParameters[1]
          .ParamType.TypeName.ToLower.Equals('thorseresponse') then
          RaiseConstructorException;

        SetLength(LArgs, 2);
        LArgs[0] := TValue.From<THorseRequest>(Req);
        LArgs[1] := TValue.From<THorseResponse>(Res);

        LInstance := LConstructMethod.Invoke(AClass, LArgs).AsObject;
        try
          AMethod.Invoke(LInstance, []);
        finally
          if not LInstance.InheritsFrom(TInterfacedObject) then
            LInstance.Free;
        end;
      end
    end;
end;

{ THorseGBSwaggerRegister }

class function THorseGBSwaggerRegister.GetPathMethod(AClass: TClass; AEndPoint: SwagEndPoint): string;
var
  LPathAttr: SwagPath;
  LPathName: string;
  LBasePath: string;
begin
  LPathAttr := AClass.GetSwagPath;
//  pathName := IfThen(pathAttr.name.IsEmpty, AClass.ClassName, pathAttr.name);
  LPathName := LPathAttr.name;
  LBasePath := Swagger.BasePath.Replace(Swagger.Config.ModuleName, EmptyStr);
  if (not LBasePath.IsEmpty) and (not LBasePath.EndsWith('/')) then
    LBasePath := LBasePath + '/';

  Result := (LBasePath + LPathName + '/' + AEndPoint.path);
  Result := Result.Replace('//', '/');
  Result := Result.Replace('{', ':');
  Result := Result.Replace('}', '');
end;

class procedure THorseGBSwaggerRegister.RegisterMethod(AClass: TClass; AMethod: TRttiMethod);
var
  LEndpoint: SwagEndPoint;
  LPath: string;
  I: Integer;
begin
  LEndpoint := AMethod.GetSwagEndPoint;
  LPath := GetPathMethod(AClass, LEndpoint);
  if not LEndpoint.isPublic then
    RegisterMethodAuth(AClass, AMethod);

  if LEndpoint is SwagGET then
    THorse.Get(LPath, HorseCallback(AClass, AMethod))
  else
  if LEndpoint is SwagPOST then
    THorse.Post(LPath, HorseCallback(AClass, AMethod))
  else
  if LEndpoint is SwagPUT then
    THorse.Put(LPath, HorseCallback(AClass, AMethod))
  else
  if LEndpoint is SwagDELETE then
    THorse.Delete(LPath, HorseCallback(AClass, AMethod))
  else
  if LEndpoint is SwagPATCH then
    THorse.Patch(LPath, HorseCallback(AClass, AMethod))
  else
    raise ENotImplemented.CreateFmt('HTTP Verb not implemented.', []);
end;

class procedure THorseGBSwaggerRegister.RegisterMethodAuth(AClass: TClass; AMethod: TRttiMethod);
var
  LSecurity: IGBSwaggerSecurity;
  LIsBasic: Boolean;
  LIsBearer: Boolean;
begin
  LIsBasic := AMethod.IsAuthBasic;
  LIsBearer := AMethod.IsAuthBearer;

  if (Length(Swagger.Securities) > 1) and
    ((not LIsBasic) and (not LIsBearer)) then
    THorse.AddCallbacks(Swagger.Securities[0].Callbacks)
  else
  for LSecurity in Swagger.Securities do
  begin
    if LIsBasic then
    begin
      if LSecurity.&Type = gbBasic then
        THorse.AddCallbacks(LSecurity.Callbacks);
    end
    else
    if LIsBearer then
    begin
      if LSecurity.&Type = gbApiKey then
        THorse.AddCallbacks(LSecurity.Callbacks);
    end
    else
      THorse.AddCallbacks(LSecurity.Callbacks);
  end;
end;

class procedure THorseGBSwaggerRegister.RegisterMethods(AClass: TClass; APath: SwagPath);
var
  I, J: Integer;
  LMethods: TArray<TRttiMethod>;
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

class procedure THorseGBSwaggerRegister.RegisterPath(AClass: TClass);
var
  LPath: SwagPath;
begin
  inherited;
  LPath := AClass.GetSwagPath;
  if Assigned(LPath) then
    RegisterMethods(AClass, LPath);
end;

end.
