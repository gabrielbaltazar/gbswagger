unit GBSwagger.Model.Schema;

interface

uses
  GBSwagger.Model.Interfaces;

type TGBSwaggerModelSchema = class(TInterfacedObject, IGBSwaggerSchema)

  private
    [Weak]
    FParent: IGBSwagger;

    FName     : String;
    FClassType: TClass;
  protected
    function Name      (Value: String): IGBSwaggerSchema; overload;
    function ClassType (Value: TClass): IGBSwaggerSchema; overload;

    function Name     : String; overload;
    function ClassType: TClass; overload;

    function &End: IGBSwagger;
  public
    constructor create(Parent: IGBSwagger);
    class function New(Parent: IGBSwagger): IGBSwaggerSchema;
    destructor  Destroy; override;

end;

implementation

{ TGBSwaggerModelSchema }

function TGBSwaggerModelSchema.ClassType: TClass;
begin
  result := FClassType;
end;

function TGBSwaggerModelSchema.ClassType(Value: TClass): IGBSwaggerSchema;
begin
  result := Self;
  FClassType := Value;
end;

constructor TGBSwaggerModelSchema.create(Parent: IGBSwagger);
begin
  FParent := Parent;
end;

destructor TGBSwaggerModelSchema.Destroy;
begin

  inherited;
end;

function TGBSwaggerModelSchema.Name(Value: String): IGBSwaggerSchema;
begin
  result := Self;
  FName  := Value;
end;

function TGBSwaggerModelSchema.Name: String;
begin
  result := FName;
end;

class function TGBSwaggerModelSchema.New(Parent: IGBSwagger): IGBSwaggerSchema;
begin
  result := Self.create(Parent);
end;

function TGBSwaggerModelSchema.&End: IGBSwagger;
begin
  result := FParent;
end;

end.
