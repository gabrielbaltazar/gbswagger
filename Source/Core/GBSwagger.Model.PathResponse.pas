unit GBSwagger.Model.PathResponse;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  GBSwagger.Types,
  GBSwagger.Model.Header,
  GBSwagger.Model.Interfaces;

type TGBSwaggerModelPathResponse = class(TInterfacedObject, IGBSwaggerPathResponse)

  private
    [Weak]
    FParent: IGBSwaggerPathMethod;
    FHttpCode: Integer;
    FDescription: String;
    FSchemaStr: string;
    FSchema: TClass;
    FIsArray: Boolean;
    FHeaders: TList<IGBSwaggerHeader>;

    function GetHeader(Name: String): IGBSwaggerHeader;

  protected
    function HttpCode(Value: Integer): IGBSwaggerPathResponse; overload;
    function Description(Value: String): IGBSwaggerPathResponse; overload;
    function Schema(Value: String): IGBSwaggerPathResponse; overload;
    function Schema(Value: TClass): IGBSwaggerPathResponse; overload;
    function IsArray(Value: Boolean): IGBSwaggerPathResponse; overload;

    function Header(Name: String = ''; Description: String = ''): IGBSwaggerHeader;
    function Headers: TArray<IGBSwaggerHeader>;

    function HttpCode: Integer; overload;
    function Description: String; overload;
    function Schema: TClass; overload;
    function IsArray: Boolean; overload;
    function &Type: string;

    function &End: IGBSwaggerPathMethod;

  public
    constructor create(Parent: IGBSwaggerPathMethod);
    class function New(Parent: IGBSwaggerPathMethod): IGBSwaggerPathResponse;
    destructor Destroy; override;
end;

implementation

{ TGBSwaggerModelPathResponse }

function TGBSwaggerModelPathResponse.Header(Name, Description: String): IGBSwaggerHeader;
begin
  result := GetHeader(Name);

  if not Assigned(Result) then
  begin
    result := TGBSwaggerModelHeader.New(Self)
                .Name(Name)
                .Description(Description);

    FHeaders.Add(result);
  end;
end;

function TGBSwaggerModelPathResponse.Headers: TArray<IGBSwaggerHeader>;
begin
  result := FHeaders.ToArray;
end;

function TGBSwaggerModelPathResponse.&Type: string;
begin
  Result := FSchemaStr;
end;

constructor TGBSwaggerModelPathResponse.create(Parent: IGBSwaggerPathMethod);
begin
  FParent  := Parent;
  FIsArray := False;
  FHeaders := TList<IGBSwaggerHeader>.create;
end;

function TGBSwaggerModelPathResponse.Description: String;
begin
  result := FDescription;
end;

function TGBSwaggerModelPathResponse.Description(Value: String): IGBSwaggerPathResponse;
begin
  result := Self;
  FDescription := Value;
end;

destructor TGBSwaggerModelPathResponse.Destroy;
begin
  FHeaders.Free;
  inherited;
end;

function TGBSwaggerModelPathResponse.&End: IGBSwaggerPathMethod;
begin
  Result := FParent;
end;

function TGBSwaggerModelPathResponse.GetHeader(Name: String): IGBSwaggerHeader;
var
  iHeader: IGBSwaggerHeader;
begin
  result := nil;
  for iHeader in FHeaders do
  begin
    if iHeader.Name.ToLower.Equals(Name.ToLower) then
      Exit(iHeader);
  end;
end;

function TGBSwaggerModelPathResponse.HttpCode(Value: Integer): IGBSwaggerPathResponse;
begin
  result := Self;
  FHttpCode := Value;
end;

function TGBSwaggerModelPathResponse.HttpCode: Integer;
begin
  Result := FHttpCode;
end;

function TGBSwaggerModelPathResponse.IsArray(Value: Boolean): IGBSwaggerPathResponse;
begin
  result := Self;
  FIsArray := Value;
end;

function TGBSwaggerModelPathResponse.IsArray: Boolean;
begin
  result := FIsArray;
end;

class function TGBSwaggerModelPathResponse.New(Parent: IGBSwaggerPathMethod): IGBSwaggerPathResponse;
begin
  result := Self.create(Parent);
end;

function TGBSwaggerModelPathResponse.Schema(Value: String): IGBSwaggerPathResponse;
begin
  result := Self;
  FSchemaStr := Value;
end;

function TGBSwaggerModelPathResponse.Schema(Value: TClass): IGBSwaggerPathResponse;
begin
  result  := Self;
  FSchema := Value;

  if (Assigned(FParent)) and (Assigned(FSchema)) then
  begin
    FParent.&End
      .&End
      .AddModel(FSchema);
  end;

end;

function TGBSwaggerModelPathResponse.Schema: TClass;
begin
  result := FSchema;
end;

end.
