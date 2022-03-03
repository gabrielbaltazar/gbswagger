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

type TGBSwaggerJSONV2PathMethod = class(TInterfacedObject, IGBSwaggerModelJSON)

  private
    FSwaggerPathMethod: IGBSwaggerPathMethod;

    function JSONSecurity: TJSONArray;
    function JSONMethod: TJSONObject;
    function JSONResponses: TJSONObject;
    function JSONParameters: TJSONArray;
    function JSONTags: TJSONArray;

  public
    constructor create(SwaggerPathMethod: IGBSwaggerPathMethod);
    class function New(SwaggerPathMethod: IGBSwaggerPathMethod): IGBSwaggerModelJSON;

    function ToJSON: TJSONValue;
end;

implementation

{ TGBSwaggerJSONV2PathMethod }

constructor TGBSwaggerJSONV2PathMethod.create(SwaggerPathMethod: IGBSwaggerPathMethod);
begin
  FSwaggerPathMethod := SwaggerPathMethod;
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
  i: Integer;
begin
  result := TJSONArray.Create;
  for i := 0 to Pred(Length(FSwaggerPathMethod.Parameters)) do
    Result.AddElement(TGBSwaggerJSONV2Parameter.New(FSwaggerPathMethod.Parameters[i]).ToJSON);
end;

function TGBSwaggerJSONV2PathMethod.JSONResponses: TJSONObject;
var
  i: Integer;
begin
  result := TJSONObject.Create;

  for i := 0 to Pred(Length(FSwaggerPathMethod.Responses)) do
    Result.AddPair(FSwaggerPathMethod.Responses[i].HttpCode.ToString,
                   TGBSwaggerJSONV2PathResponse
                      .New(FSwaggerPathMethod.Responses[i])
                        .ToJSON);
end;

function TGBSwaggerJSONV2PathMethod.JSONSecurity: TJSONArray;
var
  i          : Integer;
  swagger    : IGBSwagger;
  securities : TArray<IGBSwaggerSecurity>;
begin
  result  := TJSONArray.Create;
  swagger := FSwaggerPathMethod.&End.&End;

  if (not FSwaggerPathMethod.IsPublic) and (Length(FSwaggerPathMethod.Securities) = 0)  then
  begin
    securities := swagger.Securities;
    for i := 0 to Pred(Length(securities)) do
    Result.Add(TJSONObject.Create.AddPair(securities[i].Description, TJSONArray.Create));
  end
  else
  begin
    for i := 0 to Pred(Length(FSwaggerPathMethod.Securities)) do
      Result.Add(TJSONObject.Create.AddPair(FSwaggerPathMethod.Securities[i], TJSONArray.Create));
  end;
end;

function TGBSwaggerJSONV2PathMethod.JSONTags: TJSONArray;
var
  i: Integer;
begin
  result := TJSONArray.Create;
  for i := 0 to Pred(Length(FSwaggerPathMethod.Tags)) do
    Result.Add(FSwaggerPathMethod.Tags[i]);
end;

class function TGBSwaggerJSONV2PathMethod.New(SwaggerPathMethod: IGBSwaggerPathMethod): IGBSwaggerModelJSON;
begin
  result := Self.create(SwaggerPathMethod);
end;

function TGBSwaggerJSONV2PathMethod.ToJSON: TJSONValue;
begin
  result := JSONMethod;

end;

end.
