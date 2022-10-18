unit GBSwagger.Model.PathMethod;

interface

uses
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.Types,
  GBSwagger.Model.Parameter,
  GBSwagger.Model.PathResponse,
  System.Generics.Collections,
  System.SysUtils,
  Web.HTTPApp;

type
  TGBSwaggerModelPathMethod = class(TInterfacedObject, IGBSwaggerPathMethod)
  private
    [Weak]
    FParent: IGBSwaggerPath;
    FMethodType: TMethodType;
    FSummary: string;
    FDescription: string;
    FOperationId: string;
    FIsPublic: Boolean;
    FConsumes: TList<string>;
    FProduces: TList<string>;
    FParameters: TList<IGBSwaggerParameter>;
    FResponses: TList<IGBSwaggerPathResponse>;
    FSecurities: TList<string>;
    FTags: TList<string>;
  protected
    function MethodType(AValue: TMethodType): IGBSwaggerPathMethod; overload;
    function Summary(AValue: string): IGBSwaggerPathMethod; overload;
    function Description(AValue: string): IGBSwaggerPathMethod; overload;
    function OperationId(AValue: string): IGBSwaggerPathMethod; overload;
    function AddConsumes(AValue: string): IGBSwaggerPathMethod; overload;
    function AddConsumes(AValue: TGBSwaggerContentType): IGBSwaggerPathMethod; overload;
    function AddProduces(AValue: string): IGBSwaggerPathMethod; overload;
    function AddProduces(AValue: TGBSwaggerContentType): IGBSwaggerPathMethod; overload;
    function AddTag(AValue: string): IGBSwaggerPathMethod; overload;

    function MethodType: TMethodType; overload;
    function Summary: string; overload;
    function Description: string; overload;
    function OperationId: string; overload;

    function AddParameter(AName: string = ''; ADescription: string = '') : IGBSwaggerParameter;
    function AddParamHeader(AName: string = ''; ADescription: string = ''): IGBSwaggerParameter;
    function AddParamBody(AName: string = ''; ADescription: string = ''): IGBSwaggerParameter;
    function AddParamQuery(AName: string = ''; ADescription: string = ''): IGBSwaggerParameter;
    function AddParamPath(AName: string = ''; ADescription: string = ''): IGBSwaggerParameter;
    function AddParamFormData(AName: string = ''; ADescription: string = ''): IGBSwaggerParameter;

    function AddResponse(AHttpCode: Integer; ADescription: string = ''): IGBSwaggerPathResponse; overload;
    function AddSecurity(ADescription: string): IGBSwaggerPathMethod;

    function IsPublic(AValue: Boolean): IGBSwaggerPathMethod; overload;
    function IsPublic: Boolean; overload;

    function Consumes: TArray<string>;
    function Produces: TArray<string>;
    function Parameters: TArray<IGBSwaggerParameter>;
    function Responses: TArray<IGBSwaggerPathResponse>;
    function Tags: TArray<string>;
    function Securities: TArray<string>;
    function &End: IGBSwaggerPath;
  public
    constructor Create(AParent: IGBSwaggerPath);
    class function New(AParent: IGBSwaggerPath): IGBSwaggerPathMethod;
    destructor Destroy; override;
  end;

implementation

{ TGBSwaggerModelPathMethod }

function TGBSwaggerModelPathMethod.AddConsumes(AValue: TGBSwaggerContentType): IGBSwaggerPathMethod;
begin
  Result := Self;
  AddConsumes(AValue.toString);
end;

function TGBSwaggerModelPathMethod.AddParameter(AName, ADescription: string) : IGBSwaggerParameter;
begin
  Result := TGBSwaggerModelParameter.New(Self)
    .Name(AName)
    .Description(ADescription);
  FParameters.Add(Result);
end;

function TGBSwaggerModelPathMethod.AddConsumes(AValue: string): IGBSwaggerPathMethod;
begin
  Result := Self;
  if not FConsumes.Contains(AValue) then
    FConsumes.Add(AValue);
end;

function TGBSwaggerModelPathMethod.AddParamBody(AName, ADescription: string): IGBSwaggerParameter;
begin
  Result := Self.AddParameter(AName, ADescription)
    .ParamType(gbBody)
    .Required(True);
end;

function TGBSwaggerModelPathMethod.AddParamFormData(AName, ADescription: string): IGBSwaggerParameter;
begin
  Result := Self.AddParameter(AName, ADescription)
    .ParamType(gbFormData);
end;

function TGBSwaggerModelPathMethod.AddParamHeader(AName, ADescription: string): IGBSwaggerParameter;
begin
  Result := Self.AddParameter(AName, ADescription)
    .ParamType(gbHeader)
    .Schema(SWAG_STRING)
    .Required(True);
end;

function TGBSwaggerModelPathMethod.AddParamPath(AName, ADescription: string): IGBSwaggerParameter;
begin
  Result := Self.AddParameter(AName, ADescription)
    .ParamType(gbPath)
    .Schema(SWAG_STRING)
    .Required(True);
end;

function TGBSwaggerModelPathMethod.AddParamQuery(AName, ADescription: string): IGBSwaggerParameter;
begin
  Result := Self.AddParameter(AName, ADescription)
    .ParamType(gbQuery)
    .Schema(SWAG_STRING);
end;

function TGBSwaggerModelPathMethod.AddProduces(AValue: string): IGBSwaggerPathMethod;
begin
  Result := Self;
  if not FProduces.Contains(AValue) then
    FProduces.Add(AValue);
end;

function TGBSwaggerModelPathMethod.AddProduces(AValue: TGBSwaggerContentType): IGBSwaggerPathMethod;
begin
  Result := Self;
  AddProduces(AValue.ToString);
end;

function TGBSwaggerModelPathMethod.AddResponse(AHttpCode: Integer; ADescription: string = '')  : IGBSwaggerPathResponse;
var
  LSwagger: IGBSwagger;
  LResponse: IGBSwaggerPathResponse;
begin
  LSwagger := FParent.&End;
  Result := TGBSwaggerModelPathResponse.New(Self).HttpCode(AHttpCode);

  if LSwagger.Register.ResponseExists(AHttpCode) then
  begin
    LResponse := LSwagger.Register.response(AHttpCode).PathResponse;
    Result.Description(LResponse.Description)
      .Schema(LResponse.&Type)
      .Schema(LResponse.Schema)
      .IsArray(LResponse.IsArray);
  end;

  if not ADescription.IsEmpty then
    Result.Description(ADescription);
  FResponses.Add(Result);
end;

function TGBSwaggerModelPathMethod.AddSecurity(ADescription: string): IGBSwaggerPathMethod;
begin
  Result := Self;
  if not FSecurities.Contains(ADescription) then
    FSecurities.Add(ADescription);
end;

function TGBSwaggerModelPathMethod.AddTag(AValue: string): IGBSwaggerPathMethod;
begin
  Result := Self;
  FTags.Add(AValue);
end;

function TGBSwaggerModelPathMethod.Consumes: TArray<string>;
begin
  Result := FConsumes.ToArray;
  if Length(Result) = 0 then
    Result := FParent.&End.Consumes;
end;

constructor TGBSwaggerModelPathMethod.Create(AParent: IGBSwaggerPath);
begin
  FParent := AParent;
  FIsPublic := False;
  FConsumes := TList<string>.Create;
  FProduces := TList<string>.Create;
  FParameters := TList<IGBSwaggerParameter>.Create;
  FResponses := TList<IGBSwaggerPathResponse>.Create;
  FTags := TList<string>.Create;
  FSecurities := TList<string>.Create;
end;

function TGBSwaggerModelPathMethod.Description(AValue: string): IGBSwaggerPathMethod;
begin
  Result := Self;
  FDescription := AValue;
end;

function TGBSwaggerModelPathMethod.Description: string;
begin
  Result := FDescription;
end;

destructor TGBSwaggerModelPathMethod.Destroy;
begin
  Self.FConsumes.Free;
  Self.FProduces.Free;
  Self.FParameters.Free;
  Self.FResponses.Free;
  Self.FTags.Free;
  Self.FSecurities.Free;
  inherited;
end;

function TGBSwaggerModelPathMethod.&End: IGBSwaggerPath;
begin
  Result := FParent;
end;

function TGBSwaggerModelPathMethod.IsPublic: Boolean;
begin
  Result := FIsPublic;
end;

function TGBSwaggerModelPathMethod.IsPublic(AValue: Boolean): IGBSwaggerPathMethod;
begin
  Result := Self;
  FIsPublic := AValue;
end;

function TGBSwaggerModelPathMethod.MethodType: TMethodType;
begin
  Result := FMethodType;
end;

function TGBSwaggerModelPathMethod.MethodType(AValue: TMethodType): IGBSwaggerPathMethod;
begin
  Result := Self;
  FMethodType := AValue;
end;

class function TGBSwaggerModelPathMethod.New(AParent: IGBSwaggerPath): IGBSwaggerPathMethod;
begin
  Result := Self.Create(AParent);
end;

function TGBSwaggerModelPathMethod.OperationId: string;
begin
  Result := FOperationId;
end;

function TGBSwaggerModelPathMethod.OperationId(AValue: string): IGBSwaggerPathMethod;
begin
  Result := Self;
  FOperationId := AValue;
end;

function TGBSwaggerModelPathMethod.Parameters: TArray<IGBSwaggerParameter>;
begin
  Result := FParameters.ToArray;
end;

function TGBSwaggerModelPathMethod.Produces: TArray<string>;
begin
  Result := FProduces.ToArray;
  if Length(Result) = 0 then
    Result := FParent.&End.Produces;
end;

function TGBSwaggerModelPathMethod.Responses: TArray<IGBSwaggerPathResponse>;
begin
  Result := FResponses.ToArray;
end;

function TGBSwaggerModelPathMethod.Securities: TArray<string>;
begin
  Result := FSecurities.ToArray;
end;

function TGBSwaggerModelPathMethod.Summary: string;
begin
  Result := FSummary;
end;

function TGBSwaggerModelPathMethod.Tags: TArray<string>;
var
  LTagsPath: TArray<string>;
  I: Integer;
begin
  LTagsPath := FParent.Tags;
  for I := 0 to Pred(Length(LTagsPath)) do
    if not FTags.Contains(LTagsPath[I]) then
      FTags.Add(LTagsPath[I]);
  Result := FTags.ToArray;
end;

function TGBSwaggerModelPathMethod.Summary(AValue: string): IGBSwaggerPathMethod;
begin
  Result := Self;
  FSummary := AValue;
end;

end.
