unit GBSwagger.Register;

interface

uses
  GBSwagger.Model.Interfaces,
  System.Generics.Collections;

type
  TGBSwaggerRegister = class(TInterfacedObject, IGBSwaggerRegister)
  protected
    [Weak]
    FParent: IGBSwagger;
    FResponse: IGBSwaggerRegisterResponse;
    FSchemaOnError: TClass;
    FListResponses: TList<Integer>;

    function ResponseExists(AStatusCode: Integer): Boolean;
    function Response(AStatusCode: Integer): IGBSwaggerRegisterResponse;
    function SchemaOnError(AValue: TClass): IGBSwaggerRegister;
    function &End: IGBSwagger;
  public
    constructor Create(AParent: IGBSwagger);
    class function New(AParent: IGBSwagger): IGBSwaggerRegister;
    destructor Destroy; override;
  end;

implementation

{ TGBSwaggerRegister }

uses
  GBSwagger.Register.Response;

destructor TGBSwaggerRegister.Destroy;
begin
  FListResponses.Free;
  inherited;
end;

function TGBSwaggerRegister.&End: IGBSwagger;
begin
  Result := FParent;
end;

constructor TGBSwaggerRegister.Create(AParent: IGBSwagger);
begin
  FParent := AParent;
  FResponse := TGBSwaggerRegisterResponse.New(Self);
  FListResponses := TList<Integer>.create;
end;

class function TGBSwaggerRegister.New(AParent: IGBSwagger): IGBSwaggerRegister;
begin
  Result := Self.Create(AParent);
end;

function TGBSwaggerRegister.Response(AStatusCode: Integer): IGBSwaggerRegisterResponse;
begin
  Result := FResponse.Register(AStatusCode);
  if not FListResponses.Contains(AStatusCode) then
    FListResponses.Add(AStatusCode);
end;

function TGBSwaggerRegister.ResponseExists(AStatusCode: Integer): Boolean;
begin
  Result := FListResponses.Contains(AStatusCode);
end;

function TGBSwaggerRegister.SchemaOnError(AValue: TClass): IGBSwaggerRegister;
var
  I: Integer;
begin
  Result := Self;
  FSchemaOnError := AValue;
  for I := 0 to Pred(Self.FListResponses.Count) do
  begin
    if FListResponses.Items[I] >= 400 then
      Self.Response(FListResponses[I]).Schema(FSchemaOnError);
  end;
end;

end.
