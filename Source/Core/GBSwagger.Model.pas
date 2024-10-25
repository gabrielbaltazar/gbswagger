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

type
  TGBSwaggerModel = class(TInterfacedObject, IGBSwagger)
  private
    class var FInstance: IGBSwagger;

  	constructor CreatePrivate;
  private
    FInfo: IGBSwaggerInfo;
    FConfig: IGBSwaggerConfig;
    FTags: TList<IGBSwaggerTag>;
    FConsumes: TList<string>;
    FProduces: TList<string>;
    FProtocols: TList<TGBSwaggerProtocol>;
    FSchemas: TDictionary<string,IGBSwaggerSchema>;
    FPaths: TDictionary<string,IGBSwaggerPath>;
    FSecurities: TDictionary<string,IGBSwaggerSecurity>;
    FRegister: IGBSwaggerRegister;
    FVersion: string;
    FHost: string;
    FBasePath: string;

    function AddSchemaObjectReference(ASchemas: TArray<TClass>): IGBSwagger;

    procedure CreateConfig;
    procedure CreateProduces;
    procedure CreateConsumes;
    procedure CreateProtocols;
    procedure CreateTags;
    procedure CreatePaths;
    procedure CreateSchemas;
    procedure CreateRegistry;
    procedure CreateSecurities;

    procedure RegisterDefaultResponses;

    function ContainSchema(AClassType: TClass): Boolean;
  protected
    function Version(AValue: string): IGBSwagger; overload;
    function Host(AValue: string): IGBSwagger; overload;
    function BasePath(AValue: string): IGBSwagger; overload;

    function Version: string; overload;
    function Host: string; overload;
    function BasePath: string; overload;

    function Path(AName: string): IGBSwaggerPath;

    function Consumes: TArray<string>;
    function Produces: TArray<string>;
    function Protocols: TArray<TGBSwaggerProtocol>;
    function Schemas: TArray<IGBSwaggerSchema>;
    function Paths: TArray<IGBSwaggerPath>;
    function Securities: TArray<IGBSwaggerSecurity>;

    function Info: IGBSwaggerInfo;
    function Config: IGBSwaggerConfig;

    function AddConsumes(AValue: TGBSwaggerContentType): IGBSwagger; overload;
    function AddConsumes(AValue: string): IGBSwagger; overload;
    function AddProduces(AValue: string): IGBSwagger; overload;
    function AddProduces(AValue: TGBSwaggerContentType): IGBSwagger; overload;
    function AddProtocol(AValue: TGBSwaggerProtocol)   : IGBSwagger;

    function AddSecurity(ADescription: string): IGBSwaggerSecurity;
    function AddBearerSecurity: IGBSwaggerSecurity;
    function AddBasicSecurity: IGBSwaggerSecurity;

    function AddTag: IGBSwaggerTag;
    function AddModel(AClassType: TClass): IGBSwagger; overload;
    function SchemaName(AClassType: TClass): string;

    function &Register: IGBSwaggerRegister;

    function &End: IGBSwagger;
  public
    constructor Create;
    class function GetInstance: IGBSwagger;
    destructor Destroy; override;
  end;

implementation

{ TGBSwaggerModel }

uses
  GBSwagger.Register;

function TGBSwaggerModel.BasePath(AValue: string): IGBSwagger;
begin
  Result := Self;
  FBasePath := AValue;
  if not FBasePath.StartsWith('/') then
    FBasePath := '/' + FBasePath;
end;

function TGBSwaggerModel.&End: IGBSwagger;
begin
  Result := Self;
end;

function TGBSwaggerModel.AddBasicSecurity: IGBSwaggerSecurity;
begin
  Result := AddSecurity('Basic')
    .&Type(gbBasic)
    .Name('Authorization')
    .&In(gbHeader);
end;

function TGBSwaggerModel.AddBearerSecurity: IGBSwaggerSecurity;
begin
  Result := AddSecurity('Bearer')
    .&Type(gbApiKey)
    .Name('Authorization')
    .&In(gbHeader);
end;

function TGBSwaggerModel.AddConsumes(AValue: string): IGBSwagger;
begin
  Result := Self;
  if not FConsumes.Contains(AValue) then
    FConsumes.Add(AValue);
end;

function TGBSwaggerModel.AddConsumes(AValue: TGBSwaggerContentType): IGBSwagger;
begin
  Result := Self;
  AddConsumes(AValue.ToString);
end;

function TGBSwaggerModel.AddProduces(AValue: TGBSwaggerContentType): IGBSwagger;
begin
  Result := Self;
  AddProduces(AValue.ToString);
end;

function TGBSwaggerModel.AddProduces(AValue: string): IGBSwagger;
begin
  Result := Self;
  if not FProduces.Contains(AValue) then
    FProduces.Add(AValue);
end;

function TGBSwaggerModel.AddProtocol(AValue: TGBSwaggerProtocol): IGBSwagger;
begin
  Result := Self;
  if not FProtocols.Contains(AValue) then
    FProtocols.Add(AValue);
end;

function TGBSwaggerModel.AddModel(AClassType: TClass): IGBSwagger;
var
  LSchema: IGBSwaggerSchema;
  LName: string;
begin
  Result := Self;
  try
    if ContainSchema(AClassType) then
      Exit;

    LName := AClassType.SwagDescription(Self);
    LSchema := TGBSwaggerModelSchema.New(Self)
      .Name(LName)
      .ClassType(AClassType);

    if not FSchemas.ContainsKey(LName) then
    begin
      FSchemas.Add(LName, LSchema);
      AddSchemaObjectReference(AClassType.GetObjectProperties);
    end;
  except
    on E: Exception do
    begin
      E.Message := Format('Error on Add Model %s: %s.', [AClassType.ClassName, E.Message]);
      raise;
    end;
  end;
end;

function TGBSwaggerModel.AddSchemaObjectReference(ASchemas: TArray<TClass>): IGBSwagger;
var
  I: Integer;
begin
  Result := Self;
  for I := 0 to Pred(Length(ASchemas)) do
    AddModel(ASchemas[I]);
end;

function TGBSwaggerModel.AddSecurity(ADescription: string): IGBSwaggerSecurity;
begin
  if FSecurities.ContainsKey(ADescription) then
    Exit(FSecurities.Items[ADescription]);

  Result := TGBSwaggerModelSecurity.New(Self).Description(ADescription).&In(gbHeader);
  FSecurities.Add(ADescription, Result);
end;

function TGBSwaggerModel.AddTag: IGBSwaggerTag;
begin
  Result := TGBSwaggerModelTag.New(Self);
  FTags.Add(Result);
end;

function TGBSwaggerModel.BasePath: string;
begin
  Result := FBasePath;
end;

function TGBSwaggerModel.Config: IGBSwaggerConfig;
begin
  Result := FConfig;
end;

function TGBSwaggerModel.Consumes: TArray<string>;
begin
  Result := FConsumes.ToArray;
end;

function TGBSwaggerModel.ContainSchema(AClassType: TClass): Boolean;
var
  LSchema: IGBSwaggerSchema;
begin
  Result := False;
  for LSchema in FSchemas.Values do
  begin
    if LSchema.ClassType.ClassNameIs(AClassType.ClassName) then
      Exit(True);
  end;
end;

constructor TGBSwaggerModel.Create;
begin
  raise Exception.Create('Use the GetInstance.');
end;

procedure TGBSwaggerModel.CreateConfig;
begin
  FConfig := TGBSwaggerModelConfig.GetInstance(Self);
end;

procedure TGBSwaggerModel.CreateConsumes;
begin
  FConsumes := TList<string>.Create;
  FConsumes.Add(gbAppJSON.tostring);
end;

procedure TGBSwaggerModel.CreatePaths;
begin
  FPaths := TDictionary<string,IGBSwaggerPath>.Create;
end;

constructor TGBSwaggerModel.CreatePrivate;
begin
  FVersion := '2.0';
  CreateConfig;
  CreateProduces;
  CreateConsumes;
  CreateProtocols;
  CreateTags;
  CreateSchemas;
  CreatePaths;
  CreateRegistry;
  CreateSecurities;
  RegisterDefaultResponses;
end;

procedure TGBSwaggerModel.CreateProduces;
begin
  FProduces := TList<string>.Create;
  FProduces.Add(gbAppJSON.ToString);
end;

procedure TGBSwaggerModel.CreateProtocols;
begin
  FProtocols := TList<TGBSwaggerProtocol>.Create;
end;

procedure TGBSwaggerModel.CreateRegistry;
begin
  FRegister := TGBSwaggerRegister.New(Self);
end;

procedure TGBSwaggerModel.CreateSchemas;
begin
  FSchemas := TDictionary<string, IGBSwaggerSchema>.Create;
end;

procedure TGBSwaggerModel.CreateSecurities;
begin
  FSecurities := TDictionary<string,IGBSwaggerSecurity>.Create;
end;

procedure TGBSwaggerModel.CreateTags;
begin
  FTags := TList<IGBSwaggerTag>.Create;
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

function TGBSwaggerModel.Host: string;
begin
  Result := FHost;
end;

function TGBSwaggerModel.Host(AValue: string): IGBSwagger;
begin
  Result := Self;
  FHost := AValue;
end;

function TGBSwaggerModel.Info: IGBSwaggerInfo;
begin
  if not Assigned(FInfo) then
    FInfo := TGBSwaggerModelInfo.New(Self);
  Result := FInfo;
end;

class function TGBSwaggerModel.GetInstance: IGBSwagger;
begin
  if not Assigned(FInstance) then
  	FInstance := Self.CreatePrivate;
  Result := FInstance;
end;

function TGBSwaggerModel.Path(AName: string): IGBSwaggerPath;
begin
  if FPaths.ContainsKey(AName) then
    Exit(FPaths.Items[AName]);

  Result := TGBSwaggerModelPath.New(Self).Name(AName);
  FPaths.Add(AName, Result);
end;

function TGBSwaggerModel.Paths: TArray<IGBSwaggerPath>;
var
  LKey: string;
  I: Integer;
begin
  I := 0;
  for LKey in FPaths.Keys do
  begin
    SetLength(Result, I + 1);
    Result[I] := FPaths.Items[LKey];
    Inc(I);
  end;
end;

function TGBSwaggerModel.Produces: TArray<string>;
begin
  Result := FProduces.ToArray;
end;

function TGBSwaggerModel.Protocols: TArray<TGBSwaggerProtocol>;
begin
  Result := FProtocols.ToArray;
end;

function TGBSwaggerModel.Register: IGBSwaggerRegister;
begin
  Result := Self.FRegister;
end;

procedure TGBSwaggerModel.RegisterDefaultResponses;
var
  LEnumName: string;
  LEnumValue: Integer;
  LHttpStatus: TGBSwaggerHTTPStatus;
begin
  for LHttpStatus := Low(TGBSwaggerHTTPStatus) to High(TGBSwaggerHTTPStatus) do
  begin
    LEnumValue := LHttpStatus.httpCode;
    LEnumName := LHttpStatus.description;
    Self.Register.Response(LEnumValue).Description(LHttpStatus.Description);
  end;
end;

function TGBSwaggerModel.SchemaName(AClassType: TClass): string;
var
  LClass: IGBSwaggerSchema;
begin
  if AClassType = nil then
    Exit(EmptyStr);

  for LClass in FSchemas.Values do
  begin
    if LClass.ClassType.ClassNameIs(AClassType.ClassName) then
      Exit(LClass.Name);
  end;
end;

function TGBSwaggerModel.Schemas: TArray<IGBSwaggerSchema>;
var
  LKey: string;
begin
  for LKey in FSchemas.Keys do
  begin
    SetLength(Result, Length(Result) + 1);
    Result[Length(Result) - 1] := FSchemas.Items[LKey];
  end;
end;

function TGBSwaggerModel.Securities: TArray<IGBSwaggerSecurity>;
var
  LKey: string;
begin
  for LKey in FSecurities.Keys do
  begin
    SetLength(Result, Length(Result) + 1);
    Result[Length(Result) - 1] := FSecurities.Items[LKey];
  end;
end;

function TGBSwaggerModel.Version: string;
begin
  Result := FVersion;
end;

function TGBSwaggerModel.Version(AValue: string): IGBSwagger;
begin
  Result := Self;
  FVersion := AValue;
end;

end.
