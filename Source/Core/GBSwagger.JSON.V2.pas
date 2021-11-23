unit GBSwagger.JSON.V2;

interface

uses
  GBSwagger.JSON.Interfaces,
  GBSwagger.JSON.V2.Info,
  GBSwagger.JSON.V2.Schema,
  GBSwagger.JSON.V2.Path,
  GBSwagger.JSON.V2.Security,
  GBSwagger.Model.Interfaces,
  GBSwagger.Types,
  GBSwagger.Model,
  GBSwagger.RTTI,
  System.SysUtils,
  System.Generics.Collections,
  System.Generics.Defaults,
  System.JSON;

type TGBSwaggerJSONV2 = class(TGBSwaggerModel, IGBSwaggerModelJSON)

  private
    [Weak]
    FSwagger: IGBSwagger;

    procedure ProcessOptions(AJsonObject: TJSOnObject);

    function JSONSecurity: TJSONObject;
    function JSONPath: TJSONObject;
    function JSONSchemes: TJSONArray;
    function JSONDefinitions: TJSONObject;
    function JSONContentTypes(Value: TArray<String>): TJSONArray;
  public
    constructor create(Swagger: IGBSwagger);
    destructor Destroy; override;
    class function New(Swagger: IGBSwagger): IGBSwaggerModelJSON;

    function ToJSON: TJSONValue;

end;

implementation

{ TGBSwaggerJSONV2 }

constructor TGBSwaggerJSONV2.create(Swagger: IGBSwagger);
begin
  FSwagger := Swagger;
end;

destructor TGBSwaggerJSONV2.Destroy;
begin

  inherited;
end;

function TGBSwaggerJSONV2.JSONContentTypes(Value: TArray<String>): TJSONArray;
var
  i: Integer;
begin
  result := TJSONArray.Create;
  for i := 0 to Pred(Length(Value)) do
    Result.Add(Value[i]);
end;

function TGBSwaggerJSONV2.JSONDefinitions: TJSONObject;
var
  i: Integer;
  swaggerSchema: TArray<IGBSwaggerSchema>;
begin
  result := TJSONObject.Create;
  swaggerSchema := FSwagger.Schemas;

  TArray.Sort<IGBSwaggerSchema>(swaggerSchema,
    TComparer<IGBSwaggerSchema>.Construct(
      function (const Left, Right: IGBSwaggerSchema): Integer
      begin
        result := Left.Name.CompareTo(Right.Name);
      end));

  for i := 0 to Pred(Length(swaggerSchema)) do
  begin
    result.AddPair(
      swaggerSchema[i].Name,
      TGBSwaggerJSONV2Schema.New(swaggerSchema[i]).ToJSON
    );
  end;
end;

function TGBSwaggerJSONV2.JSONPath: TJSONObject;
var
  i: Integer;
  path: string;
  swaggerPaths: TArray<IGBSwaggerPath>;
begin
  result := TJSONObject.create;
  swaggerPaths := FSwagger.Paths;

  TArray.Sort<IGBSwaggerPath>(swaggerPaths,
    TComparer<IGBSwaggerPath>.construct( function(const Left, Right: IGBSwaggerPath): Integer
    begin
      result := Left.Tags[0].CompareTo(Right.Tags[0]);
    end));

  for i := 0 to Pred(Length(swaggerPaths)) do
  begin
    path := swaggerPaths[i].Name;
    if not path.StartsWith('/') then
      path := '/' + path;

    Result.AddPair(path, TGBSwaggerJSONV2Path.New(swaggerPaths[i]).ToJSON);
  end;
end;

function TGBSwaggerJSONV2.JSONSchemes: TJSONArray;
var
  i        : Integer;
  protocols: TArray<TGBSwaggerProtocol>;
begin
  result    := TJSONArray.Create;
  protocols := FSwagger.Protocols;

  for i := 0 to Pred(Length(protocols)) do
    Result.Add(protocols[i].toString);
end;

function TGBSwaggerJSONV2.JSONSecurity: TJSONObject;
var
  i: Integer;
  securities: TArray<IGBSwaggerSecurity>;
begin
  result     := TJSONObject.Create;
  securities := FSwagger.Securities;

  for i := 0 to Pred(Length(securities)) do
    Result.AddPair(securities[i].Description, TGBSwaggerJSONV2Security.New(securities[i]).ToJSON);
end;

class function TGBSwaggerJSONV2.New(Swagger: IGBSwagger): IGBSwaggerModelJSON;
begin
  result := SElf.create(Swagger);
end;

procedure TGBSwaggerJSONV2.ProcessOptions(AJsonObject: TJSOnObject);
var
  LPair: TJSONPair;
  LItem: TObject;
  i: Integer;

begin
  if not assigned(AJsonObject) then
    Exit;

  for i := AJsonObject.Count -1 downto 0  do
  begin
    LPair := TJSONPair(AJsonObject.Pairs[i]);
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
  result := TJSONObject.Create
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

  ProcessOptions(TJSONObject(result));
end;

end.
