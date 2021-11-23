unit GBSwagger.Model.Info;

interface

uses
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.Contact;

type TGBSwaggerModelInfo = class(TInterfacedObject, IGBSwaggerInfo)

  private
    {$IF NOT DEFINED(FPC)} [Weak] {$ENDIF}
    FParent: IGBSwagger;
    FContact: IGBSwaggerContact;
    FLicense: IGBSwaggerContact;
    FTitle: string;
    FDescription: String;
    FTermsOfService: string;
    FVersion: string;

  protected
    function Title(Value: String): IGBSwaggerInfo; overload;
    function TermsOfService(Value: String): IGBSwaggerInfo; overload;
    function Description(Value: String): IGBSwaggerInfo; overload;
    function Version(Value: String): IGBSwaggerInfo; overload;

    function Title: string; overload;
    function Description: String; overload;
    function TermsOfService: string; overload;
    function Version: string; overload;

    function Contact: IGBSwaggerContact;
    function License: IGBSwaggerContact;

    function &End: IGBSwagger;

  public
    class function New(Parent: IGBSwagger): IGBSwaggerInfo;
    constructor create(Parent: IGBSwagger);
    destructor  Destroy; override;

end;

implementation

{ TGBSwaggerModelInfo }

function TGBSwaggerModelInfo.Contact: IGBSwaggerContact;
begin
  if not Assigned(FContact) then
    FContact := TGBSwaggerModelContact.New(Self);
  result := FContact;
end;

constructor TGBSwaggerModelInfo.create(Parent: IGBSwagger);
begin
  FParent         := Parent;
  FVersion        := '1.0.0';
  FTermsOfService := 'http://www.apache.org/licenses/LICENSE-2.0.txt';

  License
    .Name('Apache License - Version 2.0, January 2004')
    .URL('http://www.apache.org/licenses/LICENSE-2.0');
end;

function TGBSwaggerModelInfo.Description: String;
begin
  result := FDescription;
end;

destructor TGBSwaggerModelInfo.Destroy;
begin

  inherited;
end;

function TGBSwaggerModelInfo.License: IGBSwaggerContact;
begin
  if not Assigned(FLicense) then
    FLicense := TGBSwaggerModelContact.New(Self);
  result := FLicense;
end;

function TGBSwaggerModelInfo.Description(Value: String): IGBSwaggerInfo;
begin
  result := Self;
  FDescription := Value;
end;

class function TGBSwaggerModelInfo.New(Parent: IGBSwagger): IGBSwaggerInfo;
begin
  Result := Self.Create(Parent);
end;

function TGBSwaggerModelInfo.&End: IGBSwagger;
begin
  result := FParent;
end;

function TGBSwaggerModelInfo.TermsOfService(Value: String): IGBSwaggerInfo;
begin
  Result := Self;
  FTermsOfService := Value;
end;

function TGBSwaggerModelInfo.TermsOfService: string;
begin
  result := FTermsOfService;
end;

function TGBSwaggerModelInfo.Title: string;
begin
  result := FTitle;
end;

function TGBSwaggerModelInfo.Title(Value: String): IGBSwaggerInfo;
begin
  result := Self;
  FTitle := Value;
end;

function TGBSwaggerModelInfo.Version: string;
begin
  result := FVersion;
end;

function TGBSwaggerModelInfo.Version(Value: String): IGBSwaggerInfo;
begin
  result := Self;
  FVersion := Value;
end;

end.
