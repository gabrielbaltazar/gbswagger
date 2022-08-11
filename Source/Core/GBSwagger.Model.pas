unit GBSwagger.Model;

interface

uses
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.Types,
  GBSwagger.Model.Info,
  GBSwagger.Model.Tag,
  GBSwagger.Model.Path,
  GBSwagger.Model.Schema,
  GBSwagger.Model.Config,
  GBSwagger.Model.Security,
  GBSwagger.RTTI,
  System.SysUtils,
  System.TypInfo,
  System.StrUtils,
  System.Generics.Collections,
  Web.HTTPApp;

type TGBSwaggerModel = class(TInterfacedObject, IGBSwagger)

  private
    class var
      FInstance: IGBSwagger;

    FInfo: IGBSwaggerInfo;
    FConfig: IGBSwaggerConfig;
    FTags: TList<IGBSwaggerTag>;
    FConsumes: TList<String>;
    FProduces: TList<String>;
    FProtocols: TList<TGBSwaggerProtocol>;
    FSchemas: TDictionary<String,IGBSwaggerSchema>;
    FPaths: TDictionary<String,IGBSwaggerPath>;
    FSecurities: TDictionary<String,IGBSwaggerSecurity>;
    FRegister: IGBSwaggerRegister;
    FVersion: string;
    FHost: String;
    FBasePath: String;

    function AddSchemaObjectReference(Schemas: TArray<TClass>): IGBSwagger;

    procedure createConfig;
    procedure createProduces;
    procedure createConsumes;
    procedure createProtocols;
    procedure createTags;
    procedure createPaths;
    procedure createSchemas;
    procedure createRegister;
    procedure createSecurities;

    procedure RegisterDefaultResponses;

    function containSchema(ClassType: TClass): Boolean;
  	constructor createPrivate;

  protected
    function Version(Value: String): IGBSwagger; overload;
    function Host(Value: String): IGBSwagger; overload;
    function BasePath(Value: String): IGBSwagger; overload;

    function Version: string; overload;
    function Host: String; overload;
    function BasePath: String; overload;

    function Path(Name: String): IGBSwaggerPath;

    function Consumes: TArray<String>;
    function Produces: TArray<String>;
    function Protocols: TArray<TGBSwaggerProtocol>;
    function Schemas: TArray<IGBSwaggerSchema>;
    function Paths: TArray<IGBSwaggerPath>;
    function Securities: TArray<IGBSwaggerSecurity>;

    function Info: IGBSwaggerInfo;
    function Config: IGBSwaggerConfig;

    function AddConsumes(Value: TGBSwaggerContentType): IGBSwagger; overload;
    function AddConsumes(Value: String): IGBSwagger; overload;
    function AddProduces(Value: String): IGBSwagger; overload;
    function AddProduces(Value: TGBSwaggerContentType): IGBSwagger; overload;
    function AddProtocol(Value: TGBSwaggerProtocol)   : IGBSwagger;

    function AddSecurity(Description: String): IGBSwaggerSecurity;
    function AddBearerSecurity: IGBSwaggerSecurity;
    function AddBasicSecurity: IGBSwaggerSecurity;

    function AddTag: IGBSwaggerTag;
    function AddModel(ClassType: TClass): IGBSwagger; overload;
    function SchemaName(ClassType: TClass): string;

    function &Register: IGBSwaggerRegister;

    function &End: IGBSwagger;
  public
    constructor create;
    class function GetInstance: IGBSwagger;
    destructor  Destroy; override;

end;

implementation

{ TGBSwaggerModel }

uses
  GBSwagger.Register;

function TGBSwaggerModel.BasePath(Value: String): IGBSwagger;
begin
  result := Self;
  FBasePath := Value;

  if not FBasePath.StartsWith('/') then
    FBasePath := '/' + FBasePath;
end;

function TGBSwaggerModel.&End: IGBSwagger;
begin
  result := Self;
end;

function TGBSwaggerModel.AddBasicSecurity: IGBSwaggerSecurity;
begin
  result := AddSecurity('Basic')
              .&Type(gbBasic)
              .Name('Authorization')
              .&In(gbHeader)
end;

function TGBSwaggerModel.AddBearerSecurity: IGBSwaggerSecurity;
begin
  result := AddSecurity('Bearer')
              .&Type(gbApiKey)
              .Name('Authorization')
              .&In(gbHeader)
end;

function TGBSwaggerModel.AddConsumes(Value: String): IGBSwagger;
begin
  result := Self;
  if not FConsumes.Contains(Value) then
    FConsumes.Add(Value);
end;

function TGBSwaggerModel.AddConsumes(Value: TGBSwaggerContentType): IGBSwagger;
begin
  result := Self;
  AddConsumes(Value.toString);
end;

function TGBSwaggerModel.AddProduces(Value: TGBSwaggerContentType): IGBSwagger;
begin
  result := Self;
  AddProduces(Value.toString);
end;

function TGBSwaggerModel.AddProduces(Value: String): IGBSwagger;
begin
  result := Self;
  if not FProduces.Contains(Value) then
    FProduces.Add(Value);
end;

function TGBSwaggerModel.AddProtocol(Value: TGBSwaggerProtocol): IGBSwagger;
begin
  result := Self;
  if not FProtocols.Contains(Value) then
    FProtocols.Add(Value);
end;

function TGBSwaggerModel.AddModel(ClassType: TClass): IGBSwagger;
var
  schema: IGBSwaggerSchema;
  name  : string;
begin
  Result := Self;
  try
    if containSchema(ClassType) then
      Exit;

    name := ClassType.SwagDescription(Self);

    schema := TGBSwaggerModelSchema.New(Self)
                .Name(name)
                .ClassType(ClassType);

    if not FSchemas.ContainsKey(name) then
    begin
      FSchemas.Add(name, schema);
      AddSchemaObjectReference(ClassType.GetObjectProperties);
    end;
  except
    on e: Exception do
    begin
      e.Message := Format('Error on Add Model %s: %s.', [ClassType.ClassName, e.Message] );
      raise;
    end;
  end;
end;

function TGBSwaggerModel.AddSchemaObjectReference(Schemas: TArray<TClass>): IGBSwagger;
var
  i : Integer;
begin
  result := Self;
  for i := 0 to Pred(Length( Schemas)) do
    AddModel(Schemas[i]);
end;

function TGBSwaggerModel.AddSecurity(Description: String): IGBSwaggerSecurity;
begin
  if FSecurities.ContainsKey(Description) then
    Exit(FSecurities.Items[Description]);

  result := TGBSwaggerModelSecurity.New(Self).Description(Description).&In(gbHeader);
  FSecurities.Add(Description, result);
end;

function TGBSwaggerModel.AddTag: IGBSwaggerTag;
begin
  result := TGBSwaggerModelTag.New(Self);
  FTags.Add(result);
end;

function TGBSwaggerModel.BasePath: String;
begin
  result := FBasePath;
end;

function TGBSwaggerModel.Config: IGBSwaggerConfig;
begin
  result := FConfig;
end;

function TGBSwaggerModel.Consumes: TArray<String>;
begin
  result := FConsumes.ToArray;
end;

function TGBSwaggerModel.containSchema(ClassType: TClass): Boolean;
var
  schema: IGBSwaggerSchema;
begin
  result := False;
  for schema in FSchemas.Values do
  begin
    if schema.ClassType.ClassNameIs(ClassType.ClassName) then
      Exit(True);
  end;
end;

constructor TGBSwaggerModel.create;
begin
  raise Exception.Create('Utilize o GetInstance.');
end;

procedure TGBSwaggerModel.createConfig;
begin
  FConfig := TGBSwaggerModelConfig.New(Self);
end;

procedure TGBSwaggerModel.createConsumes;
begin
  FConsumes := TList<String>.Create;
  FConsumes.Add(gbAppJSON.toString);
end;

procedure TGBSwaggerModel.createPaths;
begin
  FPaths := TDictionary<String,IGBSwaggerPath>.Create;
end;

constructor TGBSwaggerModel.createPrivate;
begin
  FVersion := '2.0';
  createConfig;
  createProduces;
  createConsumes;
  createProtocols;
  createTags;
  createSchemas;
  createPaths;
  createRegister;
  createSecurities;

  RegisterDefaultResponses;
end;

procedure TGBSwaggerModel.createProduces;
begin
  FProduces := TList<String>.Create;
  FProduces.Add(gbAppJSON.toString);
end;

procedure TGBSwaggerModel.createProtocols;
begin
  FProtocols := TList<TGBSwaggerProtocol>.Create;
end;

procedure TGBSwaggerModel.createRegister;
begin
  FRegister := TGBSwaggerRegister.New(Self);
end;

procedure TGBSwaggerModel.createSchemas;
begin
  FSchemas := TDictionary<String, IGBSwaggerSchema>.create;
end;

procedure TGBSwaggerModel.createSecurities;
begin
  FSecurities := TDictionary<String,IGBSwaggerSecurity>.Create;
end;

procedure TGBSwaggerModel.createTags;
begin
  FTags := TList<IGBSwaggerTag>.create;
end;

destructor TGBSwaggerModel.Destroy;
begin
  FreeAndNil(FTags);
  FreeAndNil(FSchemas);
  FreeAndNil(FProtocols);
  FreeAndNil(FConsumes);
  FreeAndNil(FProduces);
  FreeAndNil(FPaths);
  FreeAndNil(FSecurities);
  inherited;
end;

function TGBSwaggerModel.Host: String;
begin
  result := FHost;
end;

function TGBSwaggerModel.Host(Value: String): IGBSwagger;
begin
  result := Self;
  FHost  := Value;
end;

function TGBSwaggerModel.Info: IGBSwaggerInfo;
begin
  if not Assigned(FInfo) then
    FInfo := TGBSwaggerModelInfo.New(Self);
  result := FInfo;
end;

class function TGBSwaggerModel.GetInstance: IGBSwagger;
begin
  if not Assigned(FInstance) then
  	FInstance := Self.createPrivate;
  result := FInstance;
end;

function TGBSwaggerModel.Path(Name: String): IGBSwaggerPath;
begin
  if FPaths.ContainsKey(Name) then
    Exit(FPaths.Items[Name]);

  result := TGBSwaggerModelPath.New(Self).Name(Name);
  FPaths.Add(Name, result);
end;

function TGBSwaggerModel.Paths: TArray<IGBSwaggerPath>;
var
  key: String;
  i  : Integer;
begin
  i := 0;

  for key in FPaths.Keys do
  begin
    SetLength(Result, i + 1);
    Result[i] := FPaths.Items[key];
    Inc(i);
  end;

end;

function TGBSwaggerModel.Produces: TArray<String>;
begin
  Result := FProduces.ToArray;
end;

function TGBSwaggerModel.Protocols: TArray<TGBSwaggerProtocol>;
begin
  result := FProtocols.ToArray;
end;

function TGBSwaggerModel.Register: IGBSwaggerRegister;
begin
  result := Self.FRegister;
end;

procedure TGBSwaggerModel.RegisterDefaultResponses;
var
  enumName: string;
  enumValue: Integer;
  httpStatus: TGBSwaggerHTTPStatus;
begin
  for httpStatus := Low(TGBSwaggerHTTPStatus) to High(TGBSwaggerHTTPStatus) do
  begin
    enumValue := httpStatus.httpCode;
    enumName  := httpStatus.description;

    Self.Register.Response(enumValue).Description(httpStatus.description);
  end;
end;

function TGBSwaggerModel.SchemaName(ClassType: TClass): string;
var
  &class: IGBSwaggerSchema;
begin
  if ClassType = nil then
    Exit(EmptyStr);

  for &class in FSchemas.Values do
  begin
    if &class.ClassType.ClassNameIs(ClassType.ClassName) then
      Exit(&class.Name);
  end;
end;

function TGBSwaggerModel.Schemas: TArray<IGBSwaggerSchema>;
var
  key: string;
begin

  for key in FSchemas.Keys do
  begin
    SetLength(Result, Length(Result) + 1);
    Result[Length(result) - 1] := FSchemas.Items[key];
  end;
end;

function TGBSwaggerModel.Securities: TArray<IGBSwaggerSecurity>;
var
  key: string;
begin
  for key in FSecurities.Keys do
  begin
    SetLength(Result, Length(Result) + 1);
    Result[Length(result) - 1] := FSecurities.Items[key];
  end;
end;

function TGBSwaggerModel.Version: string;
begin
  result := FVersion;
end;

function TGBSwaggerModel.Version(Value: String): IGBSwagger;
begin
  result := Self;
  FVersion := Value;
end;

end.
