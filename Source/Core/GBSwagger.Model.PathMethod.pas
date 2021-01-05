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

type TGBSwaggerModelPathMethod = class(TInterfacedObject, IGBSwaggerPathMethod)

  private
    [Weak]
    FParent: IGBSwaggerPath;

    FMethodType : TMethodType;
    FSummary    : String;
    FDescription: string;
    FOperationId: string;
    FIsPublic   : Boolean;

    FConsumes  : TList<String>;
    FProduces  : TList<String>;
    FParameters: TList<IGBSwaggerParameter>;
    FResponses : TList<IGBSwaggerPathResponse>;
    FSecurities: TList<String>;
    FTags      : TList<String>;

  protected
    function MethodType  (Value: TMethodType): IGBSwaggerPathMethod; overload;
    function Summary     (Value: String): IGBSwaggerPathMethod; overload;
    function Description (Value: string): IGBSwaggerPathMethod; overload;
    function OperationId (Value: string): IGBSwaggerPathMethod; overload;
    function AddConsumes (Value: String): IGBSwaggerPathMethod; overload;
    function AddConsumes (Value: TGBSwaggerContentType): IGBSwaggerPathMethod; overload;
    function AddProduces (Value: String): IGBSwaggerPathMethod; overload;
    function AddProduces (Value: TGBSwaggerContentType): IGBSwaggerPathMethod; overload;
    function AddTag      (Value: String): IGBSwaggerPathMethod; overload;

    function MethodType : TMethodType; overload;
    function Summary    : String; overload;
    function Description: string; overload;
    function OperationId: string; overload;

    function AddParameter    (Name: String = ''; Description: String = '') : IGBSwaggerParameter;
    function AddParamHeader  (Name: string = ''; Description: String = ''): IGBSwaggerParameter;
    function AddParamBody    (Name: string = ''; Description: String = ''): IGBSwaggerParameter;
    function AddParamQuery   (Name: string = ''; Description: String = ''): IGBSwaggerParameter;
    function AddParamPath    (Name: string = ''; Description: String = ''): IGBSwaggerParameter;
    function AddParamFormData(Name: string = ''; Description: String = ''): IGBSwaggerParameter;

    function AddResponse (HttpCode: Integer; Description: String = '')  : IGBSwaggerPathResponse; overload;
    function AddSecurity(Description: String): IGBSwaggerPathMethod;

    function IsPublic(Value: Boolean): IGBSwaggerPathMethod; overload;
    function IsPublic: Boolean; overload;

    function Consumes  : TArray<String>;
    function Produces  : TArray<String>;
    function Parameters: TArray<IGBSwaggerParameter>;
    function Responses : TArray<IGBSwaggerPathResponse>;
    function Tags      : TArray<String>;
    function Securities: TArray<String>;

    function &End: IGBSwaggerPath;

  public
    constructor create(Parent: IGBSwaggerPath);
    class function New(Parent: IGBSwaggerPath): IGBSwaggerPathMethod;
    destructor Destroy; override;

end;

implementation

{ TGBSwaggerModelPathMethod }

function TGBSwaggerModelPathMethod.AddConsumes(Value: TGBSwaggerContentType): IGBSwaggerPathMethod;
begin
  result := Self;
  AddConsumes(Value.toString);
end;

function TGBSwaggerModelPathMethod.AddParameter(Name, Description: String) : IGBSwaggerParameter;
begin
  result := TGBSwaggerModelParameter.New(Self)
              .Name(Name)
              .Description(Description);

  FParameters.Add(result);
end;

function TGBSwaggerModelPathMethod.AddConsumes(Value: String): IGBSwaggerPathMethod;
begin
  result := Self;
  if not FConsumes.Contains(Value) then
    FConsumes.Add(Value);
end;

function TGBSwaggerModelPathMethod.AddParamBody(Name, Description: String): IGBSwaggerParameter;
begin
  result := Self.AddParameter(Name, Description)
                .ParamType(gbBody)
                .Required(True);
end;

function TGBSwaggerModelPathMethod.AddParamFormData(Name, Description: String): IGBSwaggerParameter;
begin
  result := Self.AddParameter(Name, Description)
                .ParamType(gbFormData);
end;

function TGBSwaggerModelPathMethod.AddParamHeader(Name, Description: String): IGBSwaggerParameter;
begin
  result := Self.AddParameter(Name, Description)
                .ParamType(gbHeader)
                .Schema(SWAG_STRING)
                .Required(True);
end;

function TGBSwaggerModelPathMethod.AddParamPath(Name, Description: String): IGBSwaggerParameter;
begin
  result := Self.AddParameter(Name, Description)
                .ParamType(gbPath)
                .Schema(SWAG_STRING)
                .Required(True);
end;

function TGBSwaggerModelPathMethod.AddParamQuery(Name, Description: String): IGBSwaggerParameter;
begin
  result := Self.AddParameter(Name, Description)
                .ParamType(gbQuery)
                .Schema(SWAG_STRING);
end;

function TGBSwaggerModelPathMethod.AddProduces(Value: String): IGBSwaggerPathMethod;
begin
  result := Self;
  if not FProduces.Contains(Value) then
    FProduces.Add(Value);
end;

function TGBSwaggerModelPathMethod.AddProduces(Value: TGBSwaggerContentType): IGBSwaggerPathMethod;
begin
  result := Self;
  AddProduces(Value.toString);
end;

function TGBSwaggerModelPathMethod.AddResponse(HttpCode: Integer; Description: String = '')  : IGBSwaggerPathResponse;
var
  Swagger : IGBSwagger;
  response: IGBSwaggerPathResponse;
begin
  Swagger := FParent.&End;
  result  := TGBSwaggerModelPathResponse.New(Self).HttpCode(HttpCode);

  if Swagger.Register.ResponseExists(HttpCode) then
  begin
    response := Swagger.Register.response(HttpCode).PathResponse;
    Result.Description(response.Description)
          .Schema(response.&Type)
          .Schema(response.Schema)
          .IsArray(response.IsArray);
  end;

  if not Description.IsEmpty then
    Result.Description(Description);

  FResponses.Add(result);
end;

function TGBSwaggerModelPathMethod.AddSecurity(Description: String): IGBSwaggerPathMethod;
begin
  result := Self;
  if not FSecurities.Contains(Description) then
    FSecurities.Add(Description);
end;

function TGBSwaggerModelPathMethod.AddTag(Value: String): IGBSwaggerPathMethod;
begin
  result := Self;
  FTags.Add(Value);
end;

function TGBSwaggerModelPathMethod.Consumes: TArray<String>;
begin
  result := FConsumes.ToArray;

  if Length(result) = 0 then
    result := FParent.&End.Consumes;
end;

constructor TGBSwaggerModelPathMethod.create(Parent: IGBSwaggerPath);
begin
  FIsPublic   := False;
  FParent     := Parent;
  FConsumes   := TList<String>.Create;
  FProduces   := TList<String>.Create;
  FParameters := TList<IGBSwaggerParameter>.create;
  FResponses  := TList<IGBSwaggerPathResponse>.create;
  FTags       := TList<String>.create;
  FSecurities := TList<String>.create;
end;

function TGBSwaggerModelPathMethod.Description(Value: string): IGBSwaggerPathMethod;
begin
  result := Self;
  FDescription := Value;
end;

function TGBSwaggerModelPathMethod.Description: string;
begin
  result := FDescription;
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
  result := FParent;
end;

function TGBSwaggerModelPathMethod.IsPublic: Boolean;
begin
  result := FIsPublic;
end;

function TGBSwaggerModelPathMethod.IsPublic(Value: Boolean): IGBSwaggerPathMethod;
begin
  result := Self;
  FIsPublic := Value;
end;

function TGBSwaggerModelPathMethod.MethodType: TMethodType;
begin
  result := FMethodType;
end;

function TGBSwaggerModelPathMethod.MethodType(Value: TMethodType): IGBSwaggerPathMethod;
begin
  result := Self;
  FMethodType := Value;
end;

class function TGBSwaggerModelPathMethod.New(Parent: IGBSwaggerPath): IGBSwaggerPathMethod;
begin
  Result := Self.create(Parent);
end;

function TGBSwaggerModelPathMethod.OperationId: string;
begin
  result := FOperationId;
end;

function TGBSwaggerModelPathMethod.OperationId(Value: string): IGBSwaggerPathMethod;
begin
  Result := Self;
  FOperationId := Value;
end;

function TGBSwaggerModelPathMethod.Parameters: TArray<IGBSwaggerParameter>;
begin
  result := FParameters.ToArray;
end;

function TGBSwaggerModelPathMethod.Produces: TArray<String>;
begin
  result := FProduces.ToArray;

  if Length(result) = 0 then
    result := FParent.&End.Produces;
end;

function TGBSwaggerModelPathMethod.Responses: TArray<IGBSwaggerPathResponse>;
begin
  result := FResponses.ToArray;
end;

function TGBSwaggerModelPathMethod.Securities: TArray<String>;
begin
  result := FSecurities.ToArray;
end;

function TGBSwaggerModelPathMethod.Summary: String;
begin
  Result := FSummary;
end;

function TGBSwaggerModelPathMethod.Tags: TArray<String>;
var
  tagsPath: TArray<String>;
  i       : Integer;
begin
  tagsPath := FParent.Tags;

  for i := 0 to Pred(Length(tagsPath)) do
    if not FTags.Contains(tagsPath[i]) then
      FTags.Add(tagsPath[i]);

  result := FTags.ToArray;
end;

function TGBSwaggerModelPathMethod.Summary(Value: String): IGBSwaggerPathMethod;
begin
  Result := Self;
  FSummary := Value;
end;

end.
