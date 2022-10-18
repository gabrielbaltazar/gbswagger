unit GBSwagger.Model.Schema;

interface

uses
  GBSwagger.Model.Interfaces;

type
  TGBSwaggerModelSchema = class(TInterfacedObject, IGBSwaggerSchema)
  private
    [Weak]
    FParent: IGBSwagger;
    FName: string;
    FClassType: TClass;
  protected
    function Name(AValue: string): IGBSwaggerSchema; overload;
    function ClassType(AValue: TClass): IGBSwaggerSchema; overload;

    function Name: string; overload;
    function ClassType: TClass; overload;
    function &End: IGBSwagger;
  public
    constructor Create(AParent: IGBSwagger);
    class function New(AParent: IGBSwagger): IGBSwaggerSchema;
    destructor Destroy; override;
  end;

implementation

{ TGBSwaggerModelSchema }

function TGBSwaggerModelSchema.ClassType: TClass;
begin
  Result := FClassType;
end;

function TGBSwaggerModelSchema.ClassType(AValue: TClass): IGBSwaggerSchema;
begin
  Result := Self;
  FClassType := AValue;
end;

constructor TGBSwaggerModelSchema.Create(AParent: IGBSwagger);
begin
  FParent := AParent;
end;

destructor TGBSwaggerModelSchema.Destroy;
begin
  inherited;
end;

function TGBSwaggerModelSchema.Name(AValue: string): IGBSwaggerSchema;
begin
  Result := Self;
  FName := AValue;
end;

function TGBSwaggerModelSchema.Name: string;
begin
  Result := FName;
end;

class function TGBSwaggerModelSchema.New(AParent: IGBSwagger): IGBSwaggerSchema;
begin
  Result := Self.Create(AParent);
end;

function TGBSwaggerModelSchema.&End: IGBSwagger;
begin
  Result := FParent;
end;

end.
