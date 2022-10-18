unit GBSwagger.Model.Parameter;

interface

uses
  System.SysUtils,
  System.StrUtils,
  System.Rtti,
  GBSwagger.Model.Interfaces,
  GBSwagger.RTTI,
  GBSwagger.Model.Types;

type
  TGBSwaggerModelParameter = class(TInterfacedObject, IGBSwaggerParameter)
  private
    [Weak]
    FParent: IGBSwaggerPathMethod;
    FParamType: TGBSwaggerParamType;
    FName: string;
    FDescription: string;
    FSchemaStr: string;
    FSchema: TClass;
    FRequired: Boolean;
    FIsArray: Boolean;
    FEnumValues: TArray<Variant>;
  protected
    function ParamType(AValue: TGBSwaggerParamType): IGBSwaggerParameter; overload;
    function Name(AValue: string): IGBSwaggerParameter; overload;
    function Description(AValue: string): IGBSwaggerParameter; overload;
    function Schema(AValue: string): IGBSwaggerParameter; overload;
    function Schema(AValue: TClass): IGBSwaggerParameter; overload;
    function Required(AValue: Boolean): IGBSwaggerParameter; overload;
    function IsArray(AValue: Boolean): IGBSwaggerParameter; overload;
    function EnumValues(AValue: TArray<Variant>): IGBSwaggerParameter; overload;

    function ParamType: TGBSwaggerParamType; overload;
    function Name: string; overload;
    function Description: string; overload;
    function Schema: TClass; overload;
    function Required: Boolean; overload;
    function IsArray: Boolean; overload;
    function IsObject: Boolean; overload;
    function IsEnum: Boolean;
    function EnumValues: TArray<Variant>; overload;
    function SchemaType: string;
    function &End: IGBSwaggerPathMethod;
  public
    constructor Create(AParent: IGBSwaggerPathMethod);
    class function New(AParent: IGBSwaggerPathMethod): IGBSwaggerParameter;
    destructor Destroy; override;
  end;

implementation

{ TGBSwaggerModelParameter }

function TGBSwaggerModelParameter.Description(AValue: string): IGBSwaggerParameter;
begin
  Result := Self;
  FDescription := AValue;
end;

constructor TGBSwaggerModelParameter.Create(AParent: IGBSwaggerPathMethod);
begin
  FParent := AParent;
end;

function TGBSwaggerModelParameter.Description: string;
begin
  Result := FDescription;
end;

destructor TGBSwaggerModelParameter.Destroy;
begin
  inherited;
end;

function TGBSwaggerModelParameter.&End: IGBSwaggerPathMethod;
begin
  Result := FParent;
end;

function TGBSwaggerModelParameter.EnumValues: TArray<Variant>;
begin
  Result := FEnumValues;
end;

function TGBSwaggerModelParameter.EnumValues(AValue: TArray<Variant>): IGBSwaggerParameter;
begin
  Result := Self;
  FEnumValues := AValue;
end;

function TGBSwaggerModelParameter.IsArray(AValue: Boolean): IGBSwaggerParameter;
begin
  Result := Self;
  FIsArray := AValue;
end;

function TGBSwaggerModelParameter.IsArray: Boolean;
begin
  Result := FIsArray;
end;

function TGBSwaggerModelParameter.IsEnum: Boolean;
begin
  Result := Length(FEnumValues) > 0;
end;

function TGBSwaggerModelParameter.IsObject: Boolean;
begin
  Result := (Assigned(Self.FSchema) and (not IsArray));
end;

function TGBSwaggerModelParameter.Name: string;
begin
  Result := FName;
end;

class function TGBSwaggerModelParameter.New(AParent: IGBSwaggerPathMethod): IGBSwaggerParameter;
begin
  Result := Self.Create(AParent);
end;

function TGBSwaggerModelParameter.Name(AValue: string): IGBSwaggerParameter;
begin
  Result := Self;
  FName := AValue;
end;

function TGBSwaggerModelParameter.ParamType: TGBSwaggerParamType;
begin
  Result := FParamType;
end;

function TGBSwaggerModelParameter.ParamType(AValue: TGBSwaggerParamType): IGBSwaggerParameter;
begin
  Result := Self;
  FParamType := AValue;
end;

function TGBSwaggerModelParameter.Required: Boolean;
begin
  Result := FRequired;
end;

function TGBSwaggerModelParameter.Required(AValue: Boolean): IGBSwaggerParameter;
begin
  Result := Self;
  FRequired := AValue;
end;

function TGBSwaggerModelParameter.Schema(AValue: string): IGBSwaggerParameter;
begin
  Result := Self;
  FSchemaStr := AValue;
end;

function TGBSwaggerModelParameter.Schema(AValue: TClass): IGBSwaggerParameter;
begin
  Result := Self;
  FSchema := AValue;
  if not Name.IsEmpty then
    FParent.&End.&End.AddModel(AValue);
end;

function TGBSwaggerModelParameter.Schema: TClass;
begin
  Result := nil;
  if Assigned(FSchema) then
    Exit(FSchema);
//  FSchema := TRttiInstanceType( TGBSwaggerRTTI.GetInstance.FindType(FSchemaStr)).MetaclassType;
//  Result  := FSchema;
end;

function TGBSwaggerModelParameter.SchemaType: string;
begin
  if (FSchemaStr.IsEmpty) and (Assigned(FSchema)) then
    Exit(FParent.&End.&End.SchemaName(FSchema));

  if IsEnum then
    Exit('array');

  Result := IfThen(FSchemaStr.IsEmpty, SWAG_STRING, FSchemaStr);
end;

end.
