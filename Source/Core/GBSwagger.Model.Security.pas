unit GBSwagger.Model.Security;

interface

uses
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.Types;

type TGBSwaggerModelSecurity = class(TInterfacedObject, IGBSwaggerSecurity)

  private
    [Weak]
    FParent: IGBSwagger;
    FType: TGBSwaggerSecurityType;
    FCallback: TRouteCallback;
    FDescription: String;
    FName: String;
    FIn: TGBSwaggerParamType;
    FFlow: TGBSwaggerSecurityFlow;
    FAuthorizationURL: String;
    FTokenURL: String;

  protected
    function &Type(Value: TGBSwaggerSecurityType): IGBSwaggerSecurity; overload;
    function Description(Value: String): IGBSwaggerSecurity; overload;
    function Name(Value: String): IGBSwaggerSecurity; overload;
    function Flow(Value: TGBSwaggerSecurityFlow): IGBSwaggerSecurity; overload;
    function &In(Value: TGBSwaggerParamType): IGBSwaggerSecurity; overload;
    function AuthorizationURL(Value: String): IGBSwaggerSecurity; overload;
    function TokenURL(Value: String): IGBSwaggerSecurity; overload;
    function Callback(Value: TRouteCallback): IGBSwaggerSecurity; overload;

    function &Type: TGBSwaggerSecurityType; overload;
    function Description: String; overload;
    function Name: String; overload;
    function &In: TGBSwaggerParamType; overload;
    function Flow: TGBSwaggerSecurityFlow; overload;
    function AuthorizationURL: String; overload;
    function TokenURL: String; overload;
    function Callback: TRouteCallback; overload;

    function &End: IGBSwagger;

  public
    constructor create(Parent: IGBSwagger);
    class function New(Parent: IGBSwagger): IGBSwaggerSecurity;
    destructor Destroy; override;
end;

implementation

{ TGBSwaggerModelSecurity }

function TGBSwaggerModelSecurity.AuthorizationURL: String;
begin
  result := FAuthorizationURL;
end;

function TGBSwaggerModelSecurity.Callback: TRouteCallback;
begin
  Result := FCallback;
end;

function TGBSwaggerModelSecurity.Callback(Value: TRouteCallback): IGBSwaggerSecurity;
begin
  result := Self;
  FCallback := Value;
end;

function TGBSwaggerModelSecurity.AuthorizationURL(Value: String): IGBSwaggerSecurity;
begin
  result := Self;
  FAuthorizationURL := Value;
end;

constructor TGBSwaggerModelSecurity.create(Parent: IGBSwagger);
begin
  FParent := Parent;
end;

function TGBSwaggerModelSecurity.Description: String;
begin
  result := FDescription;
end;

function TGBSwaggerModelSecurity.Description(Value: String): IGBSwaggerSecurity;
begin
  result := Self;
  FDescription := Value;
end;

destructor TGBSwaggerModelSecurity.Destroy;
begin

  inherited;
end;

function TGBSwaggerModelSecurity.&End: IGBSwagger;
begin
  result := FParent;
end;

function TGBSwaggerModelSecurity.Flow(Value: TGBSwaggerSecurityFlow): IGBSwaggerSecurity;
begin
  result := Self;
  FFlow  := Value;
end;

function TGBSwaggerModelSecurity.Flow: TGBSwaggerSecurityFlow;
begin
  result := FFlow;
end;

function TGBSwaggerModelSecurity.&In(Value: TGBSwaggerParamType): IGBSwaggerSecurity;
begin
  result := Self;
  FIn := Value;
end;

function TGBSwaggerModelSecurity.&In: TGBSwaggerParamType;
begin
  result := FIn;
end;

function TGBSwaggerModelSecurity.Name(Value: String): IGBSwaggerSecurity;
begin
  result := Self;
  FName  := Value;
end;

function TGBSwaggerModelSecurity.Name: String;
begin
  result := FName;
end;

class function TGBSwaggerModelSecurity.New(Parent: IGBSwagger): IGBSwaggerSecurity;
begin
  result := Self.create(Parent);
end;

function TGBSwaggerModelSecurity.TokenURL(Value: String): IGBSwaggerSecurity;
begin
  Result := Self;
  FTokenURL := Value;
end;

function TGBSwaggerModelSecurity.TokenURL: String;
begin
  result := FTokenURL;
end;

function TGBSwaggerModelSecurity.&Type(Value: TGBSwaggerSecurityType): IGBSwaggerSecurity;
begin
  FType := Value;
  result := Self;
end;

function TGBSwaggerModelSecurity.&Type: TGBSwaggerSecurityType;
begin
  result := FType;
end;

end.
