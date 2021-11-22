unit GBSwagger.Register.Response;

interface

uses
  GBSwagger.Register.Interfaces,
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.PathResponse,
  System.Classes,
  System.sysUtils,
  System.Generics.Collections;

type TGBSwaggerRegisterResponse = class(TInterfacedObject, IGBSwaggerRegisterResponse)

  private
    [Weak]
    FParent: IGBSwaggerRegister;
    FStatusCode: Integer;
    FResponses: TDictionary<Integer, IGBSwaggerPathResponse>;

    function ActiveResponse: IGBSwaggerPathResponse;
    function Response(StatusCode: Integer): IGBSwaggerPathResponse;

  protected
    function &Register(StatusCode: Integer): IGBSwaggerRegisterResponse;
    function HttpCode(Value: Integer): IGBSwaggerRegisterResponse;
    function Description(Value: String): IGBSwaggerRegisterResponse;
    function Schema(Value: String): IGBSwaggerRegisterResponse; overload;
    function Schema(Value: TClass): IGBSwaggerRegisterResponse; overload;
    function IsArray(Value: Boolean): IGBSwaggerRegisterResponse;
    function PathResponse: IGBSwaggerPathResponse;

    function &End: IGBSwaggerRegister;

  public
    constructor create(Parent: IGBSwaggerRegister);
    class function New(Parent: IGBSwaggerRegister): IGBSwaggerRegisterResponse;
    destructor Destroy; override;
end;

implementation

{ TGBSwaggerRegisterResponse }

function TGBSwaggerRegisterResponse.Description(Value: String): IGBSwaggerRegisterResponse;
begin
  Result := Self;
  ActiveResponse.Description(Value);
end;

function TGBSwaggerRegisterResponse.ActiveResponse: IGBSwaggerPathResponse;
begin
  result := Response(FStatusCode);
end;

constructor TGBSwaggerRegisterResponse.create(Parent: IGBSwaggerRegister);
begin
  FParent    := Parent;
  FResponses := TDictionary<Integer, IGBSwaggerPathResponse>.Create;
end;

destructor TGBSwaggerRegisterResponse.Destroy;
begin
  FResponses.Free;
  inherited;
end;

function TGBSwaggerRegisterResponse.&End: IGBSwaggerRegister;
begin
  result := FParent;
end;

function TGBSwaggerRegisterResponse.HttpCode(Value: Integer): IGBSwaggerRegisterResponse;
begin
  result := Self;
  FStatusCode := Value;
end;

class function TGBSwaggerRegisterResponse.New(Parent: IGBSwaggerRegister): IGBSwaggerRegisterResponse;
begin
  result := Self.create(Parent);
end;

function TGBSwaggerRegisterResponse.PathResponse: IGBSwaggerPathResponse;
begin
  if FResponses.ContainsKey(FStatusCode) then
    Exit(FResponses.Items[FStatusCode]);

  raise EResNotFound.CreateFmt('Path %s não encontrado.', [FStatusCode.ToString]);
end;

function TGBSwaggerRegisterResponse.IsArray(Value: Boolean): IGBSwaggerRegisterResponse;
begin
  result := Self;
  ActiveResponse.IsArray(Value);
end;

function TGBSwaggerRegisterResponse.Register(StatusCode: Integer): IGBSwaggerRegisterResponse;
begin
  Result := Self;
  FStatusCode := StatusCode;
  Response(FStatusCode);
end;

function TGBSwaggerRegisterResponse.Response(StatusCode: Integer): IGBSwaggerPathResponse;
begin
  if FResponses.ContainsKey(StatusCode) then
    Exit(FResponses.Items[StatusCode]);

  result := TGBSwaggerModelPathResponse.New(nil)
              .HttpCode(StatusCode);

  FResponses.Add(StatusCode, result);
end;

function TGBSwaggerRegisterResponse.Schema(Value: TClass): IGBSwaggerRegisterResponse;
begin
  result := Self;
  ActiveResponse.Schema(Value);
end;

function TGBSwaggerRegisterResponse.Schema(Value: String): IGBSwaggerRegisterResponse;
begin
  result := Self;
  ActiveResponse.Schema(Value);
end;

end.
