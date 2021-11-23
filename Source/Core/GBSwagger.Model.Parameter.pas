unit GBSwagger.Model.Parameter;

interface

uses
{$IF DEFINED(FPC)}
  SysUtils, StrUtils, Rtti,
{$ELSE}
  System.SysUtils, System.StrUtils, System.Rtti,
{$ENDIF}
  GBSwagger.Model.Interfaces,
  GBSwagger.RTTI,
  GBSwagger.Types;

type TGBSwaggerModelParameter = class(TInterfacedObject, IGBSwaggerParameter)

  private
    {$IF NOT DEFINED(FPC)} [Weak] {$ENDIF}
    FParent: IGBSwaggerPathMethod;
    FParamType: TGBSwaggerParamType;
    FName: string;
    FDescription: String;
    FSchemaStr: string;
    FSchema: TClass;
    FRequired: Boolean;
    FIsArray: Boolean;
    FEnumValues: TArray<Variant>;

  protected
    function ParamType(Value: TGBSwaggerParamType): IGBSwaggerParameter; overload;
    function Name(Value: string): IGBSwaggerParameter; overload;
    function Description(Value: String): IGBSwaggerParameter; overload;
    function Schema(Value: String): IGBSwaggerParameter; overload;
    function Schema(Value: TClass): IGBSwaggerParameter; overload;
    function Required(Value: Boolean): IGBSwaggerParameter; overload;
    function IsArray(Value: Boolean): IGBSwaggerParameter; overload;
    function EnumValues(Value: TArray<Variant>): IGBSwaggerParameter; overload;

    function ParamType: TGBSwaggerParamType; overload;
    function Name: string; overload;
    function Description: String; overload;
    function Schema: TClass; overload;
    function Required: Boolean; overload;
    function IsArray: Boolean; overload;
    function IsObject: Boolean; overload;
    function IsEnum: Boolean;
    function EnumValues: TArray<Variant>; overload;
    function SchemaType: string;

    function &End: IGBSwaggerPathMethod;

  public
    constructor create(Parent: IGBSwaggerPathMethod);
    class function New(Parent: IGBSwaggerPathMethod): IGBSwaggerParameter;
    destructor Destroy; override;
end;

implementation

{ TGBSwaggerModelParameter }

function TGBSwaggerModelParameter.Description(Value: String): IGBSwaggerParameter;
begin
  result := Self;
  FDescription := Value;
end;

constructor TGBSwaggerModelParameter.create(Parent: IGBSwaggerPathMethod);
begin
  FParent := Parent;
end;

function TGBSwaggerModelParameter.Description: String;
begin
  result := FDescription;
end;

destructor TGBSwaggerModelParameter.Destroy;
begin

  inherited;
end;

function TGBSwaggerModelParameter.&End: IGBSwaggerPathMethod;
begin
  result := FParent;
end;

function TGBSwaggerModelParameter.EnumValues: TArray<Variant>;
begin
  result := FEnumValues;
end;

function TGBSwaggerModelParameter.EnumValues(Value: TArray<Variant>): IGBSwaggerParameter;
begin
  result := Self;
  FEnumValues := Value;
end;

function TGBSwaggerModelParameter.IsArray(Value: Boolean): IGBSwaggerParameter;
begin
  result := Self;
  FIsArray := Value;
end;

function TGBSwaggerModelParameter.IsArray: Boolean;
begin
  result := FIsArray;
end;

function TGBSwaggerModelParameter.IsEnum: Boolean;
begin
  Result := Length(FEnumValues) > 0;
end;

function TGBSwaggerModelParameter.IsObject: Boolean;
begin
  result := (Assigned(Self.FSchema) and (not IsArray));
end;

function TGBSwaggerModelParameter.Name: string;
begin
  result := FName;
end;

class function TGBSwaggerModelParameter.New(Parent: IGBSwaggerPathMethod): IGBSwaggerParameter;
begin
  result := Self.create(Parent);
end;

function TGBSwaggerModelParameter.Name(Value: string): IGBSwaggerParameter;
begin
  result := Self;
  FName  := Value;
end;

function TGBSwaggerModelParameter.ParamType: TGBSwaggerParamType;
begin
  result := FParamType;
end;

function TGBSwaggerModelParameter.ParamType(Value: TGBSwaggerParamType): IGBSwaggerParameter;
begin
  result := Self;
  FParamType := Value;
end;

function TGBSwaggerModelParameter.Required: Boolean;
begin
  result := FRequired;
end;

function TGBSwaggerModelParameter.Required(Value: Boolean): IGBSwaggerParameter;
begin
  result := Self;
  FRequired := Value;
end;

function TGBSwaggerModelParameter.Schema(Value: String): IGBSwaggerParameter;
begin
  result     := Self;
  FSchemaStr := Value;
end;

function TGBSwaggerModelParameter.Schema(Value: TClass): IGBSwaggerParameter;
begin
  result  := Self;
  FSchema := Value;

  if not Name.IsEmpty then
    FParent
      .&End
      .&End
      .AddModel(Value);
end;

function TGBSwaggerModelParameter.Schema: TClass;
begin
  result := nil;
  if Assigned( FSchema ) then
    Exit(FSchema);

//  FSchema := TRttiInstanceType( TGBSwaggerRTTI.GetInstance.FindType(FSchemaStr)).MetaclassType;
//  result  := FSchema;
end;

function TGBSwaggerModelParameter.SchemaType: string;
begin
  if (FSchemaStr.IsEmpty) and (Assigned(FSchema)) then
    Exit ( FParent.&End.&End.SchemaName(FSchema));

  if IsEnum then
    Exit('array');

  result := IfThen( FSchemaStr.IsEmpty, SWAG_STRING, FSchemaStr);
end;

end.
