unit GBSwagger.JSON.V2;

interface

uses
  GBSwagger.JSON.Interfaces,
  GBSwagger.JSON.V2.Info,
  GBSwagger.JSON.V2.Schema,
  GBSwagger.JSON.V2.Path,
  GBSwagger.JSON.V2.Security,
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.Types,
  GBSwagger.Model,
  GBSwagger.RTTI,
  System.SysUtils,
  System.Generics.Collections,
  System.Generics.Defaults,
  System.JSON;

type
  TGBSwaggerJSONV2 = class(TGBSwaggerModel, IGBSwaggerModelJSON)
  private
    [Weak]
    FSwagger: IGBSwagger;

    procedure ProcessOptions(AJsonObject: TJSOnObject);

    function JSONSecurity: TJSONObject;
    function JSONPath: TJSONObject;
    function JSONSchemes: TJSONArray;
    function JSONDefinitions: TJSONObject;
    function JSONContentTypes(AValue: TArray<string>): TJSONArray;
  public
    constructor Create(ASwagger: IGBSwagger);
    destructor Destroy; override;
    class function New(ASwagger: IGBSwagger): IGBSwaggerModelJSON;

    function ToJSON: TJSONValue;
  end;

implementation

{ TGBSwaggerJSONV2 }

constructor TGBSwaggerJSONV2.Create(ASwagger: IGBSwagger);
begin
  FSwagger := ASwagger;
end;

destructor TGBSwaggerJSONV2.Destroy;
begin
  inherited;
end;

function TGBSwaggerJSONV2.JSONContentTypes(AValue: TArray<string>): TJSONArray;
var
  I: Integer;
begin
  Result := TJSONArray.Create;
  for I := 0 to Pred(Length(AValue)) do
    Result.Add(AValue[I]);
end;

function TGBSwaggerJSONV2.JSONDefinitions: TJSONObject;
var
  I: Integer;
  LSwaggerSchema: TArray<IGBSwaggerSchema>;
begin
  Result := TJSONObject.Create;
  LSwaggerSchema := FSwagger.Schemas;

  TArray.Sort<IGBSwaggerSchema>(LSwaggerSchema,
    TComparer<IGBSwaggerSchema>.Construct(
      function (const Left, Right: IGBSwaggerSchema): Integer
      begin
        Result := Left.Name.CompareTo(Right.Name);
      end));

  for I := 0 to Pred(Length(LSwaggerSchema)) do
  begin
    Result.AddPair(
      LSwaggerSchema[I].Name,
      TGBSwaggerJSONV2Schema.New(LSwaggerSchema[I]).ToJSON);
  end;
end;

function TGBSwaggerJSONV2.JSONPath: TJSONObject;
var
  I: Integer;
  LPath: string;
  LSwaggerPaths: TArray<IGBSwaggerPath>;
begin
  Result := TJSONObject.create;
  LSwaggerPaths := FSwagger.Paths;

  TArray.Sort<IGBSwaggerPath>(LSwaggerPaths,
    TComparer<IGBSwaggerPath>.construct( function(const Left, Right: IGBSwaggerPath): Integer
    begin
      Result := Left.Tags[0].CompareTo(Right.Tags[0]);
    end));

  for I := 0 to Pred(Length(LSwaggerPaths)) do
  begin
    LPath := LSwaggerPaths[I].Name;
    if not LPath.StartsWith('/') then
      LPath := '/' + LPath;

    Result.AddPair(LPath, TGBSwaggerJSONV2Path.New(LSwaggerPaths[I]).ToJSON);
  end;
end;

function TGBSwaggerJSONV2.JSONSchemes: TJSONArray;
var
  I: Integer;
  LProtocols: TArray<TGBSwaggerProtocol>;
begin
  Result := TJSONArray.Create;
  LProtocols := FSwagger.Protocols;
  for I := 0 to Pred(Length(LProtocols)) do
    Result.Add(LProtocols[I].toString);
end;

function TGBSwaggerJSONV2.JSONSecurity: TJSONObject;
var
  I: Integer;
  LSecurities: TArray<IGBSwaggerSecurity>;
begin
  Result := TJSONObject.Create;
  LSecurities := FSwagger.Securities;
  for I := 0 to Pred(Length(LSecurities)) do
    Result.AddPair(LSecurities[I].Description, TGBSwaggerJSONV2Security.New(LSecurities[I]).ToJSON);
end;

class function TGBSwaggerJSONV2.New(ASwagger: IGBSwagger): IGBSwaggerModelJSON;
begin
  Result := Self.Create(ASwagger);
end;

procedure TGBSwaggerJSONV2.ProcessOptions(AJsonObject: TJSOnObject);
var
  LPair: TJSONPair;
  LItem: TObject;
  I: Integer;
begin
  if not assigned(AJsonObject) then
    Exit;

  for I := AJsonObject.Count -1 downto 0  do
  begin
    LPair := TJSONPair(AJsonObject.Pairs[I]);
    if LPair.JsonValue is TJSOnObject then
    begin
      ProcessOptions(TJSOnObject(LPair.JsonValue));
      if LPair.JsonValue.ToString.Equals('{}') then
      begin
        AJsonObject.RemovePair(LPair.JsonString.Value).DisposeOf;
        Continue;
      end;
    end
    else if LPair.JsonValue is TJSONArray then
    begin
//      if (TJSONArray(LPair.JsonValue).Count = 0) then
//      begin
//        AJsonObject.RemovePair(LPair.JsonString.Value).DisposeOf;
//      end
//      else
        for LItem in TJSONArray(LPair.JsonValue) do
        begin
          if LItem is TJSOnObject then
            ProcessOptions(TJSOnObject(LItem));
        end;
    end
    else
    begin
      if (LPair.JsonValue.value = '') or (LPair.JsonValue.ToJSON = '0') then
      begin
        AJsonObject.RemovePair(LPair.JsonString.Value).DisposeOf;
      end;
    end;
  end;
end;

function TGBSwaggerJSONV2.ToJSON: TJSONValue;
begin
  Result := TJSONObject.Create
    .AddPair('swagger', FSwagger.Version)
    .AddPair('info', TGBSwaggerJSONV2Info.New(FSwagger.Info).ToJSON)
    .AddPair('host', FSwagger.Host)
    .AddPair('basePath', FSwagger.BasePath)
    .AddPair('schemes', JSONSchemes)
    .AddPair('consumes', JSONContentTypes(FSwagger.Consumes))
    .AddPair('produces', JSONContentTypes(FSwagger.Produces))
    .AddPair('securityDefinitions', JSONSecurity)
    .AddPair('paths', JSONPath)
    .AddPair('definitions', JSONDefinitions);

  ProcessOptions(TJSONObject(Result));
end;

end.
