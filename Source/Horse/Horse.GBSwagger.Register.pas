unit Horse.GBSwagger.Register;

interface

uses
  Horse,
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.Types,
  GBSwagger.Path.Attributes,
  GBSwagger.Path.Register,
  GBSwagger.RTTI,
  System.Rtti,
  System.StrUtils,
  System.SysUtils,
  System.Classes;

type THorseGBSwaggerRegister = class(TGBSwaggerPathRegister)

  private
    class function GetPathMethod(AClass: TClass; AEndPoint: SwagEndPoint): string;

    class procedure RegisterMethods(AClass: TClass; APath: SwagPath);
    class procedure RegisterMethod (AClass: TClass; AMethod: TRttiMethod);

  public
    class procedure RegisterPath(AClass: TClass); override;

end;

function HorseCallback(AClass: TClass; AMethod: TRttiMethod): THorseCallback;

implementation

function HorseCallback(AClass: TClass; AMethod: TRttiMethod): THorseCallback;
begin
  result :=
    procedure (Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      constructMethod : TRttiMethod;
      instance        : TObject;
      args            : array of TValue;

      procedure raiseConstructorException;
      begin
        raise EMethodNotFound.CreateFmt('You must implemented constructor method ' +
                                        'create(Req: THorseRequest; Res: THorseResponse) ' +
                                        'in %s class', [AClass.ClassName]);
      end;

    begin
      constructMethod := TGBSwaggerRTTI.GetInstance.GetType(AClass)
                            .GetMethod('create');

      if Assigned(constructMethod) then
      begin
        if Length( constructMethod.GetParameters ) <> 2 then
          raiseConstructorException;

        if not constructMethod.GetParameters[0]
              .ParamType.TypeName.ToLower.Equals('thorserequest')
        then
          raiseConstructorException;

        if not constructMethod.GetParameters[1]
              .ParamType.TypeName.ToLower.Equals('thorseresponse')
        then
          raiseConstructorException;

        setLength(args, 2);
        args[0] := TValue.From<THorseRequest>(Req);
        args[1] := TValue.From<THorseResponse>(Res);

        instance := constructMethod.Invoke(AClass, args).AsObject;
        try
          AMethod.Invoke(instance, []);
        finally
          if not instance.InheritsFrom(TInterfacedObject) then
            instance.Free;
        end;
      end
    end;


end;

{ THorseGBSwaggerRegister }

class function THorseGBSwaggerRegister.GetPathMethod(AClass: TClass; AEndPoint: SwagEndPoint): string;
var
  pathAttr : SwagPath;
  pathName : string;
  basePath : string;
begin
  pathAttr := AClass.GetSwagPath;
//  pathName := IfThen(pathAttr.name.IsEmpty, AClass.ClassName, pathAttr.name);
  pathName := pathAttr.name;
  basePath := Swagger.BasePath.Replace(Swagger.Config.ModuleName, EmptyStr);
  if (not basePath.IsEmpty) and (not basePath.EndsWith('/')) then
    basePath := basePath + '/';

  result := (basePath + pathName + '/' + AEndPoint.path);
  result := result.Replace('//', '/');
  result := result.Replace('{', ':');
  result := result.Replace('}', '');
end;

class procedure THorseGBSwaggerRegister.RegisterMethod(AClass: TClass; AMethod: TRttiMethod);
var
  endpoint : SwagEndPoint;
  path : string;
  i : Integer;
begin
  endpoint := AMethod.GetSwagEndPoint;
  path := GetPathMethod(AClass, endpoint);
  {if not endpoint.isPublic then
    for i := 0 to Pred(Length(Swagger.Securities)) do
      THorse.AddCallbacks(Swagger.Securities[i].Callbacks);}

  if endpoint is SwagGET then
    THorse.Get(path, HorseCallback(AClass, AMethod))
  else
  if endpoint is SwagPOST then
    THorse.Post(path, HorseCallback(AClass, AMethod))
  else
  if endpoint is SwagPUT then
    THorse.Put(path, HorseCallback(AClass, AMethod))
  else
  if endpoint is SwagDELETE then
    THorse.Delete(path, HorseCallback(AClass, AMethod))
  else
  if endpoint is SwagPATCH then
    THorse.Patch(path, HorseCallback(AClass, AMethod))
  else
    raise ENotImplemented.CreateFmt('Verbo http não implementado.', []);
end;

class procedure THorseGBSwaggerRegister.RegisterMethods(AClass: TClass; APath: SwagPath);
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

class procedure THorseGBSwaggerRegister.RegisterPath(AClass: TClass);
var
  path : SwagPath;
begin
  inherited;
  path := AClass.GetSwagPath;

  if Assigned(path) then
    RegisterMethods(AClass, path);
end;

end.
