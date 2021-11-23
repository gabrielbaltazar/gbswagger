unit GBSwagger.Model.Tag;

interface

uses
  GBSwagger.Model.Interfaces;

type TGBSwaggerModelTag = class(TInterfacedObject, IGBSwaggerTag)

  private
    {$IF NOT DEFINED(FPC)} [Weak] {$ENDIF}
    FParent: IGBSwagger;
    FName: String;
    FDescription: String;
    FDocDescription: String;
    FDocURL: String;

  protected
    function Name(Value: String): IGBSwaggerTag; overload;
    function Description(Value: String): IGBSwaggerTag; overload;
    function DocDescription(Value: String): IGBSwaggerTag; overload;
    function DocURL(Value: String): IGBSwaggerTag; overload;

    function Name: String; overload;
    function Description: String; overload;
    function DocDescription: String; overload;
    function DocURL: String; overload;

    function &End: IGBSwagger;

  public
    constructor create(Parent: IGBSwagger);
    class function New(Parent: IGBSwagger): IGBSwaggerTag;
    destructor Destroy; override;
end;

implementation

{ TGBSwaggerModelTag }

constructor TGBSwaggerModelTag.create(Parent: IGBSwagger);
begin
  FParent := Parent;
end;

function TGBSwaggerModelTag.Description(Value: String): IGBSwaggerTag;
begin
  result := Self;
  FDescription := Value;
end;

function TGBSwaggerModelTag.Description: String;
begin
  result := FDescription;
end;

destructor TGBSwaggerModelTag.Destroy;
begin

  inherited;
end;

function TGBSwaggerModelTag.DocDescription(Value: String): IGBSwaggerTag;
begin
  result := Self;
  FDocDescription := Value;
end;

function TGBSwaggerModelTag.DocDescription: String;
begin
  result := FDocDescription;
end;

function TGBSwaggerModelTag.DocURL(Value: String): IGBSwaggerTag;
begin
  result  := Self;
  FDocURL := Value;
end;

function TGBSwaggerModelTag.DocURL: String;
begin
  Result := FDocURL;
end;

function TGBSwaggerModelTag.Name(Value: String): IGBSwaggerTag;
begin
  result := Self;
  FName  := Value;
end;

function TGBSwaggerModelTag.Name: String;
begin
  result := FName;
end;

class function TGBSwaggerModelTag.New(Parent: IGBSwagger): IGBSwaggerTag;
begin
  result := Self.create(Parent);
end;

function TGBSwaggerModelTag.&End: IGBSwagger;
begin
  Result := FParent;
end;

end.
