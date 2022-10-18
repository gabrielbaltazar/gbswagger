unit GBSwagger.Register.Response;

interface

uses
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.PathResponse,
  System.Classes,
  System.sysUtils,
  System.Generics.Collections;

type
  TGBSwaggerRegisterResponse = class(TInterfacedObject, IGBSwaggerRegisterResponse)
  private
    [Weak]
    FParent: IGBSwaggerRegister;
    FStatusCode: Integer;
    FResponses: TDictionary<Integer, IGBSwaggerPathResponse>;

    function ActiveResponse: IGBSwaggerPathResponse;
    function Response(AStatusCode: Integer): IGBSwaggerPathResponse;
  protected
    function &Register(AStatusCode: Integer): IGBSwaggerRegisterResponse;
    function HttpCode(AValue: Integer): IGBSwaggerRegisterResponse;
    function Description(AValue: string): IGBSwaggerRegisterResponse;
    function Schema(AValue: string): IGBSwaggerRegisterResponse; overload;
    function Schema(AValue: TClass): IGBSwaggerRegisterResponse; overload;
    function IsArray(AValue: Boolean): IGBSwaggerRegisterResponse;
    function PathResponse: IGBSwaggerPathResponse;
    function &End: IGBSwaggerRegister;
  public
    constructor Create(AParent: IGBSwaggerRegister);
    class function New(AParent: IGBSwaggerRegister): IGBSwaggerRegisterResponse;
    destructor Destroy; override;
  end;

implementation

{ TGBSwaggerRegisterResponse }

function TGBSwaggerRegisterResponse.Description(AValue: string): IGBSwaggerRegisterResponse;
begin
  Result := Self;
  ActiveResponse.Description(AValue);
end;

function TGBSwaggerRegisterResponse.ActiveResponse: IGBSwaggerPathResponse;
begin
  Result := Response(FStatusCode);
end;

constructor TGBSwaggerRegisterResponse.Create(AParent: IGBSwaggerRegister);
begin
  FParent := AParent;
  FResponses := TDictionary<Integer, IGBSwaggerPathResponse>.Create;
end;

destructor TGBSwaggerRegisterResponse.Destroy;
begin
  FResponses.Free;
  inherited;
end;

function TGBSwaggerRegisterResponse.&End: IGBSwaggerRegister;
begin
  Result := FParent;
end;

function TGBSwaggerRegisterResponse.HttpCode(AValue: Integer): IGBSwaggerRegisterResponse;
begin
  Result := Self;
  FStatusCode := AValue;
end;

class function TGBSwaggerRegisterResponse.New(AParent: IGBSwaggerRegister): IGBSwaggerRegisterResponse;
begin
  Result := Self.Create(AParent);
end;

function TGBSwaggerRegisterResponse.PathResponse: IGBSwaggerPathResponse;
begin
  if FResponses.ContainsKey(FStatusCode) then
    Exit(FResponses.Items[FStatusCode]);
  raise EResNotFound.CreateFmt('Path %s não encontrado.', [FStatusCode.Tostring]);
end;

function TGBSwaggerRegisterResponse.IsArray(AValue: Boolean): IGBSwaggerRegisterResponse;
begin
  Result := Self;
  ActiveResponse.IsArray(AValue);
end;

function TGBSwaggerRegisterResponse.Register(AStatusCode: Integer): IGBSwaggerRegisterResponse;
begin
  Result := Self;
  FStatusCode := AStatusCode;
  Response(FStatusCode);
end;

function TGBSwaggerRegisterResponse.Response(AStatusCode: Integer): IGBSwaggerPathResponse;
begin
  if FResponses.ContainsKey(AStatusCode) then
    Exit(FResponses.Items[AStatusCode]);

  Result := TGBSwaggerModelPathResponse.New(nil)
              .HttpCode(AStatusCode);
  FResponses.Add(AStatusCode, Result);
end;

function TGBSwaggerRegisterResponse.Schema(AValue: TClass): IGBSwaggerRegisterResponse;
begin
  Result := Self;
  ActiveResponse.Schema(AValue);
end;

function TGBSwaggerRegisterResponse.Schema(AValue: string): IGBSwaggerRegisterResponse;
begin
  Result := Self;
  ActiveResponse.Schema(AValue);
end;

end.
