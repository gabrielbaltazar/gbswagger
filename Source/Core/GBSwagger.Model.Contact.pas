unit GBSwagger.Model.Contact;

interface

uses
  GBSwagger.Model.Interfaces;

type TGBSwaggerModelContact = class(TInterfacedObject, IGBSwaggerContact)

  private
    [Weak]
    FParent: IGBSwaggerInfo;
    FName: String;
    FEmail: string;
    FURL: string;

  protected
    function Name(Value: String): IGBSwaggerContact; overload;
    function Email(Value: string): IGBSwaggerContact; overload;
    function URL(Value: String): IGBSwaggerContact; overload;

    function Name: String; overload;
    function Email: string; overload;
    function URL: string; overload;

    function &End: IGBSwaggerInfo;

  public
    constructor create(Parent: IGBSwaggerInfo);
    class function New(Parent: IGBSwaggerInfo): IGBSwaggerContact;
    destructor Destroy; override;
end;

implementation

{ TGBSwaggerModelContact }

constructor TGBSwaggerModelContact.create(Parent: IGBSwaggerInfo);
begin
  FParent := Parent;
end;

destructor TGBSwaggerModelContact.Destroy;
begin

  inherited;
end;

function TGBSwaggerModelContact.Email: string;
begin
  result := FEmail;
end;

function TGBSwaggerModelContact.Email(Value: string): IGBSwaggerContact;
begin
  result := Self;
  FEmail := Value;
end;

function TGBSwaggerModelContact.Name(Value: String): IGBSwaggerContact;
begin
  Result := Self;
  FName := Value;
end;

function TGBSwaggerModelContact.Name: String;
begin
  Result := FName;
end;

class function TGBSwaggerModelContact.New(Parent: IGBSwaggerInfo): IGBSwaggerContact;
begin
  result := Self.create(Parent);
end;

function TGBSwaggerModelContact.&End: IGBSwaggerInfo;
begin
  result := FParent;
end;

function TGBSwaggerModelContact.URL(Value: String): IGBSwaggerContact;
begin
  result := Self;
  FURL   := Value;
end;

function TGBSwaggerModelContact.URL: string;
begin
  result := FURL;
end;

end.
