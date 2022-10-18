unit GBSwagger.JSON.V2.PathMethod;

interface

uses
  GBSwagger.JSON.Interfaces,
  GBSwagger.JSON.Utils,
  GBSwagger.JSON.V2.PathResponse,
  GBSwagger.JSON.V2.Parameter,
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.Types,
  System.SysUtils,
  System.StrUtils,
  System.JSON;

type
  TGBSwaggerJSONV2PathMethod = class(TInterfacedObject, IGBSwaggerModelJSON)
  private
    FSwaggerPathMethod: IGBSwaggerPathMethod;

    function JSONSecurity: TJSONArray;
    function JSONMethod: TJSONObject;
    function JSONResponses: TJSONObject;
    function JSONParameters: TJSONArray;
    function JSONTags: TJSONArray;
  public
    constructor Create(ASwaggerPathMethod: IGBSwaggerPathMethod);
    class function New(ASwaggerPathMethod: IGBSwaggerPathMethod): IGBSwaggerModelJSON;
    function ToJSON: TJSONValue;
  end;

implementation

{ TGBSwaggerJSONV2PathMethod }

constructor TGBSwaggerJSONV2PathMethod.Create(ASwaggerPathMethod: IGBSwaggerPathMethod);
begin
  FSwaggerPathMethod := ASwaggerPathMethod;
end;

function TGBSwaggerJSONV2PathMethod.JSONMethod: TJSONObject;
begin
  Result := TJSONObject.Create
    .AddPair('tags', JSONTags)
    .AddPair('summary', FSwaggerPathMethod.Summary)
    .AddPair('description', FSwaggerPathMethod.Description)
    .AddPair('consumes', TGBSwaggerModelJSONUtils.JSONContentTypes(FSwaggerPathMethod.Consumes))
    .AddPair('produces', TGBSwaggerModelJSONUtils.JSONContentTypes(FSwaggerPathMethod.Produces))
    .AddPair('parameters', JSONParameters)
    .AddPair('responses', JSONResponses)
    .AddPair('security', JSONSecurity);
end;

function TGBSwaggerJSONV2PathMethod.JSONParameters: TJSONArray;
var
  I: Integer;
begin
  Result := TJSONArray.Create;
  for I := 0 to Pred(Length(FSwaggerPathMethod.Parameters)) do
    Result.AddElement(TGBSwaggerJSONV2Parameter.New(FSwaggerPathMethod.Parameters[I]).ToJSON);
end;

function TGBSwaggerJSONV2PathMethod.JSONResponses: TJSONObject;
var
  I: Integer;
begin
  Result := TJSONObject.Create;
  for I := 0 to Pred(Length(FSwaggerPathMethod.Responses)) do
    Result.AddPair(FSwaggerPathMethod.Responses[I].HttpCode.ToString,
      TGBSwaggerJSONV2PathResponse.New(FSwaggerPathMethod.Responses[I]).ToJSON);
end;

function TGBSwaggerJSONV2PathMethod.JSONSecurity: TJSONArray;
var
  I: Integer;
  LSwagger: IGBSwagger;
  LSecurities: TArray<IGBSwaggerSecurity>;
begin
  Result := TJSONArray.Create;
  LSwagger := FSwaggerPathMethod.&End.&End;
  if (not FSwaggerPathMethod.IsPublic) and (Length(FSwaggerPathMethod.Securities) = 0)  then
  begin
    LSecurities := LSwagger.Securities;
    for I := 0 to Pred(Length(LSecurities)) do
      Result.Add(TJSONObject.Create
        .AddPair(LSecurities[I].Description, TJSONArray.Create));
  end
  else
  begin
    for I := 0 to Pred(Length(FSwaggerPathMethod.Securities)) do
      Result.Add(TJSONObject.Create
        .AddPair(FSwaggerPathMethod.Securities[I], TJSONArray.Create));
  end;
end;

function TGBSwaggerJSONV2PathMethod.JSONTags: TJSONArray;
var
  I: Integer;
begin
  Result := TJSONArray.Create;
  for I := 0 to Pred(Length(FSwaggerPathMethod.Tags)) do
    Result.Add(FSwaggerPathMethod.Tags[I]);
end;

class function TGBSwaggerJSONV2PathMethod.New(ASwaggerPathMethod: IGBSwaggerPathMethod): IGBSwaggerModelJSON;
begin
  Result := Self.Create(ASwaggerPathMethod);
end;

function TGBSwaggerJSONV2PathMethod.ToJSON: TJSONValue;
begin
  Result := JSONMethod;
end;

end.
