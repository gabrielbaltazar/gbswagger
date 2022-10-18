unit GBSwagger.Path.Attributes;

interface

uses
  GBSwagger.Model.Types,
  System.SysUtils;

type
  SwagApp = class(TCustomAttribute)
  private
    FTitle: string;
    FVersion: string;
    FHost: string;
  public
    constructor Create(ATitle, AVersion: string; AHost: string = ''); overload;
    constructor Create(ATitle: string); overload;
    property Title: string read FTitle;
    property Version: string read FVersion;
    property Host: string read FHost;
  end;

  SwagContact = class(TCustomAttribute)
  private
    FName: string;
    FEmail: string;
    FSite: string;
  public
    constructor Create(AName: string; AEmail: string = ''; ASite: string = '');
    property Name: string read FName;
    property Email: string read FEmail;
    property Site: string read FSite;
  end;

  SwagBasePath = class(TCustomAttribute)
  private
    FValue: string;
  public
    constructor Create(Value: string);
    property Value: string read FValue;
  end;

  SwagAppDescription = class(TCustomAttribute)
  private
    FDescription: string;
  public
    constructor Create(ADescription: string);
    property Description: string read FDescription;
  end;

  SwagSecurityBearer = class(TCustomAttribute)
  end;

  SwagSecurityBasic = class(TCustomAttribute)
  end;

  SwagPath = class(TCustomAttribute)
  private
    FName: string;
    FTag: string;
  public
    constructor Create(ATag: string); overload;
    constructor Create(AName, ATag: string); overload;
    property Name: string read FName;
    property Tag: string read FTag write FTag;
  end;

  SwagParam = class(TCustomAttribute)
  private
    FName: string;
    FDescription: string;
    FRequired: Boolean;
    FIsArray: Boolean;
    FSchema: string;
    FEnumValues: string;
    function GetEnumValues: TArray<Variant>;
  public
    function IsEnum: Boolean;
    property Name: string read FName;
    property Description: string read FDescription;
    property Required: Boolean read FRequired;
    property IsArray: Boolean read FIsArray;
    property Schema: string read FSchema write FSchema;
    property EnumValues: TArray<Variant> read GetEnumValues;
  end;

  SwagParamPath = class(SwagParam)
  public
    constructor Create(AName: string; ADescription: string = '';
      AIsNumber: Boolean = False); overload;

    constructor Create(AName, ADescription, AEnumValues: string;
      AIsNumber: Boolean = False); overload;
  end;

  SwagParamHeader = class(SwagParam)
  public
    constructor Create(AName: string; ADescription: string = '';
      ARequired: Boolean = True; AIsNumber: Boolean = False); overload;

    constructor Create(AName: string; ADescription: string;
      AEnumValues: string; ARequired: Boolean = True;
      AIsNumber: Boolean = False); overload;
  end;

  SwagParamQuery = class(SwagParam)
  public
    constructor Create(AName: string; ADescription: string = '';
      ARequired: Boolean = False; AIsNumber: Boolean = False); overload;

    constructor Create(AName: string; ADescription: string;
      AEnumValues: string; ARequired: Boolean = False;
      AIsNumber: Boolean = False); overload;
  end;

  SwagParamBody = class(SwagParam)
  private
    FClassType: TClass;
  public
    constructor Create(AName: string; AClassType: TClass;
      ADescription: string; AIsArray: Boolean = False;
      ARequired: Boolean = True); overload;

    constructor Create(AName: string; ASchema: string;
      ADescription: string; AIsArray: Boolean = False;
      ARequired: Boolean = True); overload;

    constructor Create(AName: string; AClassType: TClass;
      AIsArray: Boolean = False; ADescription: string = '';
      ARequired: Boolean = True); overload;

    constructor Create(AName: string; ASchema: string;
      AIsArray: Boolean = False; ADescription: string = '';
      ARequired: Boolean = True); overload;

    function ClassType: TClass;
  end;

  SwagParamFormData = class(SwagParam)
  private
    FIsFile: Boolean;
    function GetIsFile: Boolean;
  public
    constructor Create(AName: string; ADescription: string = '';
      AFile: Boolean = False; ARequired: Boolean = True); overload;

    constructor Create(AName: string; AFile: Boolean; ADescription: string = '';
      ARequired: Boolean = True); overload;

    property IsFile: Boolean read GetIsFile;
  end;

  SwagEndPoint = class(TCustomAttribute)
  private
    FSummary: string;
    FDescription: string;
    FPath: string;
    FPublic: Boolean;
  public
    constructor Create(ASummary: string; APublic: Boolean = False;
      ADescription: string = ''); overload;

    constructor Create(APath: string; ASummary: string;
      APublic: Boolean = False; ADescription: string = ''); overload;

    property Path: string read FPath;
    property Summary: string read FSummary;
    property Description: string read FDescription;
    property IsPublic: Boolean read FPublic;
  end;

  SwagConsumes = class(TCustomAttribute)
  private
    FContentType: string;
  public
    property ContentType: string read FContentType;
    constructor Create(AValue: TGBSwaggerContentType); overload;
    constructor Create(AValue: string); overload;
  end;

  SwagProduces = class(TCustomAttribute)
  private
    FAccept: string;
  public
    property Accept: string read FAccept;
    constructor Create(AValue: TGBSwaggerContentType); overload;
    constructor Create(AValue: string); overload;
  end;

  SwagGET = class(SwagEndPoint)
  end;

  SwagPOST = class(SwagEndPoint)
  end;

  SwagPUT = class(SwagEndPoint)
  end;

  SwagDELETE = class(SwagEndPoint)
  end;

  SwagPATCH = class(SwagEndPoint)
  end;

  SwagResponse = class(TCustomAttribute)
  private
    FHttpCode: Integer;
    FDescription: string;
    FSchema: string;
    FClassType: TClass;
    FIsArray: Boolean;
  public
    constructor Create(AHttpCode: Integer; AClassType: TClass;
      ADescription: string = ''; AIsArray: Boolean = False); overload;

    constructor Create(AHttpCode: Integer; AClassType: TClass;
      AIsArray: Boolean; ADescription: string = ''); overload;

    constructor Create(AHttpCode: Integer; ASchema: string;
      AIsArray: Boolean; ADescription: string = ''); overload;

    constructor Create(AHttpCode: Integer; ASchema: string;
      ADescription: string = ''; AIsArray: Boolean = False); overload;

    constructor Create(AHttpCode: Integer); overload;

    function ClassType: TClass; reintroduce;

    property HttpCode: Integer read FHttpCode;
    property Description: string read FDescription;
    property Schema: string read FSchema;
    property IsArray: Boolean read FIsArray;
  end;

implementation

{ SwagPath }

constructor SwagPath.Create(ATag: string);
begin
  FName := EmptyStr;
  FTag := ATag;
end;

constructor SwagPath.Create(AName, ATag: string);
begin
  FName := AName;
  FTag := ATag;
end;

{ SwagEndPoint }

constructor SwagEndPoint.Create(ASummary: string; APublic: Boolean = False; ADescription: string = '');
begin
  FSummary := ASummary;
  FDescription := ADescription;
  FPath := EmptyStr;
  FPublic := APublic;
end;

constructor SwagEndPoint.Create(APath, ASummary: string; APublic: Boolean; ADescription: string);
begin
  FSummary := ASummary;
  FDescription := ADescription;
  FPath := APath;
  FPublic := APublic;
end;

{ SwagParam }

function SwagParam.GetEnumValues: TArray<Variant>;
var
  LSplitter: TArray<string>;
  I: Integer;
begin
  LSplitter := FEnumValues.Split([',']);
  SetLength(Result, Length(LSplitter));
  for I := 0 to Pred(Length(LSplitter)) do
    Result[I] := LSplitter[I];
end;

function SwagParam.IsEnum: Boolean;
begin
  Result := Length(FEnumValues) > 0;
end;

{ SwagParamBody }

function SwagParamBody.ClassType: TClass;
begin
  Result := FClassType;
end;

constructor SwagParamBody.Create(AName: string; AClassType: TClass; AIsArray: Boolean; ADescription: string; ARequired: Boolean);
begin
  FName := AName;
  FClassType := AClassType;
  FIsArray := AIsArray;
  FDescription := ADescription;
  FRequired := ARequired;
end;

constructor SwagParamBody.Create(AName: string; AClassType: TClass; ADescription: string; AIsArray, ARequired: Boolean);
begin
  Create(AName, AClassType, AIsArray, ADescription, ARequired);
end;

constructor SwagParamBody.Create(AName, ASchema: string; AIsArray: Boolean; ADescription: string; ARequired: Boolean);
begin
  FName := AName;
  FSchema := ASchema;
  FIsArray := AIsArray;
  FDescription := ADescription;
  FRequired := ARequired;
end;

constructor SwagParamBody.Create(AName, ASchema, ADescription: string; AIsArray, ARequired: Boolean);
begin
  FName := AName;
  FSchema := ASchema;
  FIsArray := AIsArray;
  FDescription := ADescription;
  FRequired := ARequired;
end;

{ SwagResponse }

constructor SwagResponse.Create(AHttpCode: Integer; AClassType: TClass; AIsArray: Boolean; ADescription: string);
begin
  FHttpCode := AHttpCode;
  FClassType := AClassType;
  FDescription := ADescription;
  FIsArray := AIsArray;
end;

constructor SwagResponse.Create(AHttpCode: Integer; ASchema, ADescription: string; AIsArray: Boolean);
begin
  FHttpCode := AHttpCode;
  FSchema := ASchema;
  FDescription := ADescription;
  FIsArray := AIsArray;
end;

constructor SwagResponse.Create(AHttpCode: Integer; AClassType: TClass; ADescription: string; AIsArray: Boolean);
begin
  FHttpCode := AHttpCode;
  FClassType := AClassType;
  FDescription := ADescription;
  FIsArray := AIsArray;
end;

function SwagResponse.ClassType: TClass;
begin
  Result := FClassType;
end;

constructor SwagResponse.Create(AHttpCode: Integer);
begin
  FHttpCode:= AHttpCode;
end;

constructor SwagResponse.Create(AHttpCode: Integer; ASchema: string; AIsArray: Boolean; ADescription: string);
begin
  FHttpCode := AHttpCode;
  FSchema := ASchema;
  FDescription := ADescription;
  FIsArray := AIsArray;
end;

{ SwaggerApp }

constructor SwagApp.Create(ATitle, AVersion, AHost: string);
begin
  FTitle := ATitle;
  FVersion := AVersion;
  FHost := AHost;
end;

constructor SwagApp.Create(ATitle: string);
begin
  Create(ATitle, EmptyStr, EmptyStr);
end;

{ SwagAppDescription }

constructor SwagAppDescription.Create(ADescription: string);
begin
  FDescription := ADescription;
end;

{ SwagBasePath }

constructor SwagBasePath.Create(Value: string);
begin
  FValue := Value;
end;

{ SwagParamPath }

constructor SwagParamPath.Create(AName, ADescription, AEnumValues: string; AIsNumber: Boolean = False);
begin
  FName := AName;
  FDescription := ADescription;
  FSchema := SWAG_STRING;
  FIsArray := False;
  FRequired := True;
  FEnumValues := AEnumValues;
  if AIsNumber then
    FSchema := SWAG_INTEGER;
end;

constructor SwagParamPath.Create(AName, ADescription: string; AIsNumber: Boolean);
begin
  FName := AName;
  FDescription := ADescription;
  FSchema := SWAG_STRING;
  FIsArray := False;
  FRequired := True;
  if AIsNumber then
    FSchema := SWAG_INTEGER;
end;

{ SwagParamHeader }

constructor SwagParamHeader.Create(AName, ADescription, AEnumValues: string; ARequired: Boolean; AIsNumber: Boolean);
begin
  FName := AName;
  FDescription := ADescription;
  FSchema := SWAG_STRING;
  FIsArray := False;
  FRequired := ARequired;
  FEnumValues := AEnumValues;
  if AIsNumber then
    FSchema := SWAG_INTEGER;
end;

constructor SwagParamHeader.Create(AName, ADescription: string; ARequired: Boolean; AIsNumber: Boolean);
begin
  FName := AName;
  FDescription := ADescription;
  FSchema := SWAG_STRING;
  FIsArray := False;
  FRequired := ARequired;
  if AIsNumber then
    FSchema := SWAG_INTEGER;
end;

{ SwagParamQuery }

constructor SwagParamQuery.Create(AName, ADescription, AEnumValues: string; ARequired: Boolean; AIsNumber: Boolean);
begin
  FName := AName;
  FDescription := ADescription;
  FSchema := SWAG_STRING;
  FIsArray := False;
  FRequired := ARequired;
  FEnumValues := AEnumValues;
  if AIsNumber then
    FSchema := SWAG_INTEGER;
end;

constructor SwagParamQuery.Create(AName, ADescription: string; ARequired: Boolean; AIsNumber: Boolean);
begin
  FName := AName;
  FDescription := ADescription;
  FSchema := SWAG_STRING;
  FIsArray := False;
  FRequired := ARequired;
  if AIsNumber then
    FSchema := SWAG_INTEGER;
end;

{ SwagContact }

constructor SwagContact.Create(AName, AEmail, ASite: string);
begin
  FName := AName;
  FEmail := AEmail;
  FSite := ASite;
end;

{ SwagContentType }

constructor SwagConsumes.Create(AValue: string);
begin
  FContentType := AValue;
end;

constructor SwagConsumes.Create(AValue: TGBSwaggerContentType);
begin
  FContentType := AValue.toString;
end;

{ SwagAccept }

constructor SwagProduces.Create(AValue: string);
begin
  FAccept := AValue;
end;

constructor SwagProduces.Create(AValue: TGBSwaggerContentType);
begin
  FAccept := AValue.toString;
end;

{ SwagParamFormData }

constructor SwagParamFormData.Create(AName, ADescription: string; AFile, ARequired: Boolean);
begin
  FName := AName;
  FDescription := ADescription;
  FIsFile := AFile;
  FRequired := ARequired;
end;

constructor SwagParamFormData.Create(AName: string; AFile: Boolean; ADescription: string; ARequired: Boolean);
begin
  Create(AName, ADescription, AFile, ARequired);
end;

function SwagParamFormData.GetIsFile: Boolean;
begin
  Result := FIsFile;
end;

end.
