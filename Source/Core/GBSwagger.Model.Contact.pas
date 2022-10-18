unit GBSwagger.Model.Contact;

interface

uses
  GBSwagger.Model.Interfaces;

type
  TGBSwaggerModelContact = class(TInterfacedObject, IGBSwaggerContact)
  private
    [Weak]
    FParent: IGBSwaggerInfo;
    FName: string;
    FEmail: string;
    FURL: string;
  protected
    function Name(AValue: string): IGBSwaggerContact; overload;
    function Email(AValue: string): IGBSwaggerContact; overload;
    function URL(AValue: string): IGBSwaggerContact; overload;

    function Name: string; overload;
    function Email: string; overload;
    function URL: string; overload;
    function &End: IGBSwaggerInfo;
  public
    constructor Create(AParent: IGBSwaggerInfo);
    class function New(AParent: IGBSwaggerInfo): IGBSwaggerContact;
    destructor Destroy; override;
  end;

implementation

{ TGBSwaggerModelContact }

constructor TGBSwaggerModelContact.Create(AParent: IGBSwaggerInfo);
begin
  FParent := AParent;
end;

destructor TGBSwaggerModelContact.Destroy;
begin
  inherited;
end;

function TGBSwaggerModelContact.Email: string;
begin
  Result := FEmail;
end;

function TGBSwaggerModelContact.Email(AValue: string): IGBSwaggerContact;
begin
  Result := Self;
  FEmail := AValue;
end;

function TGBSwaggerModelContact.Name(AValue: string): IGBSwaggerContact;
begin
  Result := Self;
  FName := AValue;
end;

function TGBSwaggerModelContact.Name: string;
begin
  Result := FName;
end;

class function TGBSwaggerModelContact.New(AParent: IGBSwaggerInfo): IGBSwaggerContact;
begin
  Result := Self.Create(AParent);
end;

function TGBSwaggerModelContact.&End: IGBSwaggerInfo;
begin
  Result := FParent;
end;

function TGBSwaggerModelContact.URL(AValue: string): IGBSwaggerContact;
begin
  Result := Self;
  FURL := AValue;
end;

function TGBSwaggerModelContact.URL: string;
begin
  Result := FURL;
end;

end.
