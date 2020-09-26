unit GBSwagger.Register;

interface

uses
  GBSwagger.Model.Interfaces,
  GBSwagger.Register.Interfaces,
  System.Generics.Collections;

type TGBSwaggerRegister = class(TInterfacedObject, IGBSwaggerRegister)

  protected
    [Weak]
    FParent: IGBSwagger;
    FResponse: IGBSwaggerRegisterResponse;
    FSchemaOnError: TClass;
    FListResponses: TList<Integer>;

    function ResponseExists(StatusCode: Integer): Boolean;
    function Response(StatusCode: Integer): IGBSwaggerRegisterResponse;
    function SchemaOnError (Value: TClass): IGBSwaggerRegister;

    function &End: IGBSwagger;
  public
    constructor create(Parent: IGBSwagger);
    class function New(Parent: IGBSwagger): IGBSwaggerRegister;
    destructor Destroy; override;
end;

implementation

{ TGBSwaggerRegister }

uses
  GBSwagger.Register.Response;

destructor TGBSwaggerRegister.Destroy;
begin
  FListResponses.free;
  inherited;
end;

function TGBSwaggerRegister.&End: IGBSwagger;
begin
  result := FParent;
end;

constructor TGBSwaggerRegister.create(Parent: IGBSwagger);
begin
  FParent       := Parent;
  FResponse     := TGBSwaggerRegisterResponse.New(Self);
  FListResponses:= TList<Integer>.create;
end;

class function TGBSwaggerRegister.New(Parent: IGBSwagger): IGBSwaggerRegister;
begin
  Result := Self.create(Parent);
end;

function TGBSwaggerRegister.Response(StatusCode: Integer): IGBSwaggerRegisterResponse;
begin
  result := FResponse.Register(StatusCode);
  if not FListResponses.Contains(StatusCode) then
    FListResponses.Add(StatusCode);
end;

function TGBSwaggerRegister.ResponseExists(StatusCode: Integer): Boolean;
begin
  result := FListResponses.Contains(StatusCode);
end;

function TGBSwaggerRegister.SchemaOnError(Value: TClass): IGBSwaggerRegister;
var
  i: Integer;
begin
  result := Self;
  FSchemaOnError := Value;

  for i := 0 to Pred(Self.FListResponses.Count) do
  begin
    if FListResponses.Items[i] >= 400 then
      Self.Response(FListResponses[i]).Schema(FSchemaOnError);
  end;
end;

end.
