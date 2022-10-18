unit GBSwagger.Model.Tag;

interface

uses
  GBSwagger.Model.Interfaces;

type
  TGBSwaggerModelTag = class(TInterfacedObject, IGBSwaggerTag)
  private
    [Weak]
    FParent: IGBSwagger;
    FName: string;
    FDescription: string;
    FDocDescription: string;
    FDocURL: string;
  protected
    function Name(AValue: string): IGBSwaggerTag; overload;
    function Description(AValue: string): IGBSwaggerTag; overload;
    function DocDescription(AValue: string): IGBSwaggerTag; overload;
    function DocURL(AValue: string): IGBSwaggerTag; overload;

    function Name: string; overload;
    function Description: string; overload;
    function DocDescription: string; overload;
    function DocURL: string; overload;
    function &End: IGBSwagger;
  public
    constructor Create(AParent: IGBSwagger);
    class function New(AParent: IGBSwagger): IGBSwaggerTag;
    destructor Destroy; override;
  end;

implementation

{ TGBSwaggerModelTag }

constructor TGBSwaggerModelTag.Create(AParent: IGBSwagger);
begin
  FParent := AParent;
end;

function TGBSwaggerModelTag.Description(AValue: string): IGBSwaggerTag;
begin
  Result := Self;
  FDescription := AValue;
end;

function TGBSwaggerModelTag.Description: string;
begin
  Result := FDescription;
end;

destructor TGBSwaggerModelTag.Destroy;
begin
  inherited;
end;

function TGBSwaggerModelTag.DocDescription(AValue: string): IGBSwaggerTag;
begin
  Result := Self;
  FDocDescription := AValue;
end;

function TGBSwaggerModelTag.DocDescription: string;
begin
  Result := FDocDescription;
end;

function TGBSwaggerModelTag.DocURL(AValue: string): IGBSwaggerTag;
begin
  Result := Self;
  FDocURL := AValue;
end;

function TGBSwaggerModelTag.DocURL: string;
begin
  Result := FDocURL;
end;

function TGBSwaggerModelTag.Name(AValue: string): IGBSwaggerTag;
begin
  Result := Self;
  FName := AValue;
end;

function TGBSwaggerModelTag.Name: string;
begin
  Result := FName;
end;

class function TGBSwaggerModelTag.New(AParent: IGBSwagger): IGBSwaggerTag;
begin
  Result := Self.Create(AParent);
end;

function TGBSwaggerModelTag.&End: IGBSwagger;
begin
  Result := FParent;
end;

end.
