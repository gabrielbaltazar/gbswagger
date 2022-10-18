unit GBSwagger.Model.Info;

interface

uses
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.Contact;

type
  TGBSwaggerModelInfo = class(TInterfacedObject, IGBSwaggerInfo)
  private
    [Weak]
    FParent: IGBSwagger;
    FContact: IGBSwaggerContact;
    FLicense: IGBSwaggerContact;
    FTitle: string;
    FDescription: string;
    FTermsOfService: string;
    FVersion: string;
  protected
    function Title(AValue: string): IGBSwaggerInfo; overload;
    function TermsOfService(AValue: string): IGBSwaggerInfo; overload;
    function Description(AValue: string): IGBSwaggerInfo; overload;
    function Version(AValue: string): IGBSwaggerInfo; overload;

    function Title: string; overload;
    function Description: string; overload;
    function TermsOfService: string; overload;
    function Version: string; overload;

    function Contact: IGBSwaggerContact;
    function License: IGBSwaggerContact;
    function &End: IGBSwagger;
  public
    class function New(AParent: IGBSwagger): IGBSwaggerInfo;
    constructor Create(AParent: IGBSwagger);
    destructor Destroy; override;
  end;

implementation

{ TGBSwaggerModelInfo }

function TGBSwaggerModelInfo.Contact: IGBSwaggerContact;
begin
  if not Assigned(FContact) then
    FContact := TGBSwaggerModelContact.New(Self);
  Result := FContact;
end;

constructor TGBSwaggerModelInfo.Create(AParent: IGBSwagger);
begin
  FParent := AParent;
  FVersion := '1.0.0';
  FTermsOfService := 'http://www.apache.org/licenses/LICENSE-2.0.txt';

  License.Name('Apache License - Version 2.0, January 2004')
    .URL('http://www.apache.org/licenses/LICENSE-2.0');
end;

function TGBSwaggerModelInfo.Description: string;
begin
  Result := FDescription;
end;

destructor TGBSwaggerModelInfo.Destroy;
begin
  inherited;
end;

function TGBSwaggerModelInfo.License: IGBSwaggerContact;
begin
  if not Assigned(FLicense) then
    FLicense := TGBSwaggerModelContact.New(Self);
  Result := FLicense;
end;

function TGBSwaggerModelInfo.Description(AValue: string): IGBSwaggerInfo;
begin
  Result := Self;
  FDescription := AValue;
end;

class function TGBSwaggerModelInfo.New(AParent: IGBSwagger): IGBSwaggerInfo;
begin
  Result := Self.Create(AParent);
end;

function TGBSwaggerModelInfo.&End: IGBSwagger;
begin
  Result := FParent;
end;

function TGBSwaggerModelInfo.TermsOfService(AValue: string): IGBSwaggerInfo;
begin
  Result := Self;
  FTermsOfService := AValue;
end;

function TGBSwaggerModelInfo.TermsOfService: string;
begin
  Result := FTermsOfService;
end;

function TGBSwaggerModelInfo.Title: string;
begin
  Result := FTitle;
end;

function TGBSwaggerModelInfo.Title(AValue: string): IGBSwaggerInfo;
begin
  Result := Self;
  FTitle := AValue;
end;

function TGBSwaggerModelInfo.Version: string;
begin
  Result := FVersion;
end;

function TGBSwaggerModelInfo.Version(AValue: string): IGBSwaggerInfo;
begin
  Result := Self;
  FVersion := AValue;
end;

end.
