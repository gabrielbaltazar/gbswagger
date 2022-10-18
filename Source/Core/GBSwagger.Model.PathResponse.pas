unit GBSwagger.Model.PathResponse;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  GBSwagger.Model.Types,
  GBSwagger.Model.Header,
  GBSwagger.Model.Interfaces;

type
  TGBSwaggerModelPathResponse = class(TInterfacedObject, IGBSwaggerPathResponse)
  private
    [Weak]
    FParent: IGBSwaggerPathMethod;
    FHttpCode: Integer;
    FDescription: string;
    FSchemaStr: string;
    FSchema: TClass;
    FIsArray: Boolean;
    FHeaders: TList<IGBSwaggerHeader>;

    function GetHeader(AName: string): IGBSwaggerHeader;
  protected
    function HttpCode(AValue: Integer): IGBSwaggerPathResponse; overload;
    function Description(AValue: string): IGBSwaggerPathResponse; overload;
    function Schema(AValue: string): IGBSwaggerPathResponse; overload;
    function Schema(AValue: TClass): IGBSwaggerPathResponse; overload;
    function IsArray(AValue: Boolean): IGBSwaggerPathResponse; overload;

    function Header(AName: string = ''; ADescription: string = ''): IGBSwaggerHeader;
    function Headers: TArray<IGBSwaggerHeader>;

    function HttpCode: Integer; overload;
    function Description: string; overload;
    function Schema: TClass; overload;
    function IsArray: Boolean; overload;
    function &Type: string;
    function &End: IGBSwaggerPathMethod;
  public
    constructor Create(AParent: IGBSwaggerPathMethod);
    class function New(AParent: IGBSwaggerPathMethod): IGBSwaggerPathResponse;
    destructor Destroy; override;
  end;

implementation

{ TGBSwaggerModelPathResponse }

function TGBSwaggerModelPathResponse.Header(AName, ADescription: string): IGBSwaggerHeader;
begin
  Result := GetHeader(AName);
  if not Assigned(Result) then
  begin
    Result := TGBSwaggerModelHeader.New(Self)
      .Name(AName)
      .Description(ADescription);
    FHeaders.Add(Result);
  end;
end;

function TGBSwaggerModelPathResponse.Headers: TArray<IGBSwaggerHeader>;
begin
  Result := FHeaders.ToArray;
end;

function TGBSwaggerModelPathResponse.&Type: string;
begin
  Result := FSchemaStr;
end;

constructor TGBSwaggerModelPathResponse.Create(AParent: IGBSwaggerPathMethod);
begin
  FParent := AParent;
  FIsArray := False;
  FHeaders := TList<IGBSwaggerHeader>.create;
end;

function TGBSwaggerModelPathResponse.Description: string;
begin
  Result := FDescription;
end;

function TGBSwaggerModelPathResponse.Description(AValue: string): IGBSwaggerPathResponse;
begin
  Result := Self;
  FDescription := AValue;
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

function TGBSwaggerModelPathResponse.GetHeader(AName: string): IGBSwaggerHeader;
var
  LHeader: IGBSwaggerHeader;
begin
  Result := nil;
  for LHeader in FHeaders do
  begin
    if LHeader.Name.ToLower.Equals(AName.ToLower) then
      Exit(LHeader);
  end;
end;

function TGBSwaggerModelPathResponse.HttpCode(AValue: Integer): IGBSwaggerPathResponse;
begin
  Result := Self;
  FHttpCode := AValue;
end;

function TGBSwaggerModelPathResponse.HttpCode: Integer;
begin
  Result := FHttpCode;
end;

function TGBSwaggerModelPathResponse.IsArray(AValue: Boolean): IGBSwaggerPathResponse;
begin
  Result := Self;
  FIsArray := AValue;
end;

function TGBSwaggerModelPathResponse.IsArray: Boolean;
begin
  Result := FIsArray;
end;

class function TGBSwaggerModelPathResponse.New(AParent: IGBSwaggerPathMethod): IGBSwaggerPathResponse;
begin
  Result := Self.Create(AParent);
end;

function TGBSwaggerModelPathResponse.Schema(AValue: string): IGBSwaggerPathResponse;
begin
  Result := Self;
  FSchemaStr := AValue;
end;

function TGBSwaggerModelPathResponse.Schema(AValue: TClass): IGBSwaggerPathResponse;
begin
  Result  := Self;
  FSchema := AValue;
  if (Assigned(FParent)) and (Assigned(FSchema)) then
  begin
    FParent.&End
      .&End
      .AddModel(FSchema);
  end;
end;

function TGBSwaggerModelPathResponse.Schema: TClass;
begin
  Result := FSchema;
end;

end.
