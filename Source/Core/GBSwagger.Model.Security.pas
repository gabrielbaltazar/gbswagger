unit GBSwagger.Model.Security;

interface

uses
  System.Generics.Collections,
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.Types;

type
  TGBSwaggerModelSecurity = class(TInterfacedObject, IGBSwaggerSecurity)
  private
    [Weak]
    FParent: IGBSwagger;
    FType: TGBSwaggerSecurityType;
    FCallbacks: TList<TRouteCallback>;
    FDescription: string;
    FName: string;
    FIn: TGBSwaggerParamType;
    FFlow: TGBSwaggerSecurityFlow;
    FAuthorizationURL: string;
    FTokenURL: string;
  protected
    function &Type(AValue: TGBSwaggerSecurityType): IGBSwaggerSecurity; overload;
    function Description(AValue: string): IGBSwaggerSecurity; overload;
    function Name(AValue: string): IGBSwaggerSecurity; overload;
    function Flow(AValue: TGBSwaggerSecurityFlow): IGBSwaggerSecurity; overload;
    function &In(AValue: TGBSwaggerParamType): IGBSwaggerSecurity; overload;
    function AuthorizationURL(AValue: string): IGBSwaggerSecurity; overload;
    function TokenURL(AValue: string): IGBSwaggerSecurity; overload;

    function AddCallback(AValue: TRouteCallback): IGBSwaggerSecurity;
    function Callbacks: TArray<TRouteCallback>;

    function &Type: TGBSwaggerSecurityType; overload;
    function Description: string; overload;
    function Name: string; overload;
    function &In: TGBSwaggerParamType; overload;
    function Flow: TGBSwaggerSecurityFlow; overload;
    function AuthorizationURL: string; overload;
    function TokenURL: string; overload;
    function &End: IGBSwagger;
  public
    constructor Create(AParent: IGBSwagger);
    class function New(AParent: IGBSwagger): IGBSwaggerSecurity;
    destructor Destroy; override;
  end;

implementation

{ TGBSwaggerModelSecurity }

function TGBSwaggerModelSecurity.AddCallback(AValue: TRouteCallback): IGBSwaggerSecurity;
begin
  Result := Self;
  FCallbacks.Add(AValue);
end;

function TGBSwaggerModelSecurity.AuthorizationURL: string;
begin
  Result := FAuthorizationURL;
end;

function TGBSwaggerModelSecurity.Callbacks: TArray<TRouteCallback>;
begin
  Result := FCallbacks.ToArray;
end;

function TGBSwaggerModelSecurity.AuthorizationURL(AValue: string): IGBSwaggerSecurity;
begin
  Result := Self;
  FAuthorizationURL := AValue;
end;

constructor TGBSwaggerModelSecurity.Create(AParent: IGBSwagger);
begin
  FParent := AParent;
  FCallbacks := TList<TRouteCallback>.Create;
end;

function TGBSwaggerModelSecurity.Description: string;
begin
  Result := FDescription;
end;

function TGBSwaggerModelSecurity.Description(AValue: string): IGBSwaggerSecurity;
begin
  Result := Self;
  FDescription := AValue;
end;

destructor TGBSwaggerModelSecurity.Destroy;
begin
  FCallbacks.Free;
  inherited;
end;

function TGBSwaggerModelSecurity.&End: IGBSwagger;
begin
  Result := FParent;
end;

function TGBSwaggerModelSecurity.Flow(AValue: TGBSwaggerSecurityFlow): IGBSwaggerSecurity;
begin
  Result := Self;
  FFlow := AValue;
end;

function TGBSwaggerModelSecurity.Flow: TGBSwaggerSecurityFlow;
begin
  Result := FFlow;
end;

function TGBSwaggerModelSecurity.&In(AValue: TGBSwaggerParamType): IGBSwaggerSecurity;
begin
  Result := Self;
  FIn := AValue;
end;

function TGBSwaggerModelSecurity.&In: TGBSwaggerParamType;
begin
  Result := FIn;
end;

function TGBSwaggerModelSecurity.Name(AValue: string): IGBSwaggerSecurity;
begin
  Result := Self;
  FName := AValue;
end;

function TGBSwaggerModelSecurity.Name: string;
begin
  Result := FName;
end;

class function TGBSwaggerModelSecurity.New(AParent: IGBSwagger): IGBSwaggerSecurity;
begin
  Result := Self.Create(AParent);
end;

function TGBSwaggerModelSecurity.TokenURL(AValue: string): IGBSwaggerSecurity;
begin
  Result := Self;
  FTokenURL := AValue;
end;

function TGBSwaggerModelSecurity.TokenURL: string;
begin
  Result := FTokenURL;
end;

function TGBSwaggerModelSecurity.&Type(AValue: TGBSwaggerSecurityType): IGBSwaggerSecurity;
begin
  FType := AValue;
  Result := Self;
end;

function TGBSwaggerModelSecurity.&Type: TGBSwaggerSecurityType;
begin
  Result := FType;
end;

end.
