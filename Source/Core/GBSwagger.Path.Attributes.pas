unit GBSwagger.Path.Attributes;

interface

uses
  GBSwagger.Model.Types,
  System.SysUtils;

type
  SwagApp = class(TCustomAttribute)
  private
    FTitle: string;
    FVersion: String;
    FHost: string;

  public
    property title: String read FTitle;
    property version: string read FVersion;
    property host: string read FHost;

    constructor create(ATitle, AVersion: string; AHost: String = ''); overload;
    constructor create(ATitle: String); overload;
  end;

  SwagContact = class(TCustomAttribute)
  private
    Fname: String;
    Femail: String;
    Fsite: String;

  public
    property name: String read Fname;
    property email: String read Femail;
    property site: String read Fsite;

    constructor create(AName: string; AEmail: String = ''; ASite: string = '');
  end;

  SwagBasePath = class(TCustomAttribute)
  private
    FValue: string;
  public
    constructor create(Value: String);
    property value: String read FValue;
  end;

  SwagAppDescription = class(TCustomAttribute)
  private
    FDescription: string;
  public
    constructor create(ADescription: String);
    property description: string read FDescription;
  end;

  SwagSecurityBearer = class(TCustomAttribute)
  end;

  SwagSecurityBasic = class(TCustomAttribute)
  end;

  SwagPath = class(TCustomAttribute)
  private
    Fname: string;
    Ftag: String;
  public
    property name: string read Fname;
    property tag: String read Ftag write Ftag;

    constructor create(ATag: String); overload;
    constructor create(AName, ATag: string); overload;
  end;

  SwagParam = class(TCustomAttribute)
  private
    Fname: String;
    Fdescription: String;
    Frequired: Boolean;
    FisArray: Boolean;
    Fschema: String;
    FEnumValues: String;
    function GetEnumValues: TArray<Variant>;
  public
    property name: String read Fname;
    property description: String read Fdescription;
    property required: Boolean read Frequired;
    property isArray: Boolean read FisArray;
    property schema: String read Fschema write Fschema;
    property enumValues: TArray<Variant> read GetEnumValues;

    function isEnum: Boolean;
  end;

  SwagParamPath = class(SwagParam)
  public
    constructor create(AName: String; ADescription: string = ''; bIsNumber: Boolean = False); overload;
    constructor create(AName, ADescription, AEnumValues: String; bIsNumber: Boolean = False); overload;
  end;

  SwagParamHeader = class(SwagParam)
    constructor create(AName: String;
                       ADescription: string = '';
                       bRequired: Boolean = True;
                       bIsNumber: Boolean = False); overload;

    constructor create(AName: String;
                       ADescription: string;
                       AEnumValues: String;
                       bRequired: Boolean = True;
                       bIsNumber: Boolean = False); overload;
  end;

  SwagParamQuery = class(SwagParam)
    constructor create(AName: String;
                       ADescription: string = '';
                       bRequired: Boolean = False;
                       bIsNumber: Boolean = False); overload;

    constructor create(AName: string;
                       ADescription: String;
                       AEnumValues: String;
                       bRequired: Boolean = False;
                       bIsNumber: Boolean = False); overload;
  end;

  SwagParamBody = class(SwagParam)
  private
    FclassType: TClass;
  public
    function classType: TClass;

    constructor create(AName: string;
                       AClassType: TClass;
                       ADescription: string;
                       bIsArray: Boolean = False;
                       bRequired: Boolean = True); overload;

    constructor create(AName: string;
                       AClassType: TClass;
                       bIsArray: Boolean = False;
                       ADescription: string = '';
                       bRequired: Boolean = True); overload;
  end;

  SwagEndPoint = class(TCustomAttribute)
  private
    Fsummary: string;
    Fdescription: string;
    Fpath: string;
    Fpublic: Boolean;
  public
    property path: string read Fpath;
    property summary: string read Fsummary;
    property description: string read Fdescription;
    property isPublic: Boolean read Fpublic;

    constructor create(ASummary: String; APublic: Boolean = False; ADescription: String = ''); overload;
    constructor create(APath: String; ASummary: String; APublic: Boolean = False; ADescription: String = ''); overload;
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
    FhttpCode: Integer;
    Fdescription: string;
    Fschema: string;
    FclassType: TClass;
    FisArray: Boolean;
  public
    property httpCode: Integer read FhttpCode;
    property description: string read Fdescription;
    property schema: string read Fschema;
    property isArray: Boolean read FisArray;

    function classType: TClass; reintroduce;

    constructor create(AHttpCode    : Integer;
                       AClassType   : TClass;
                       ADescription : String = '';
                       bIsArray     : Boolean = False); overload;

    constructor create(AHttpCode    : Integer;
                       AClassType   : TClass;
                       bIsArray     : Boolean;
                       ADescription : String = ''); overload;

    constructor create(AHttpCode    : Integer;
                       ASchema      : String;
                       bIsArray     : Boolean;
                       ADescription : String = ''); overload;

    constructor create(AHttpCode    : Integer;
                       ASchema      : String;
                       ADescription : String = '';
                       bIsArray     : Boolean = False); overload;

    constructor create(AHttpCode: Integer); overload;
  end;

implementation

{ SwagPath }

constructor SwagPath.create(ATag: String);
begin
  Fname := EmptyStr;
  Ftag  := ATag;
end;

constructor SwagPath.create(AName, ATag: string);
begin
  Fname := AName;
  Ftag  := ATag;
end;

{ SwagEndPoint }

constructor SwagEndPoint.create(ASummary: String; APublic: Boolean = False; ADescription: String = '');
begin
  Fsummary     := ASummary;
  Fdescription := ADescription;
  Fpath        := EmptyStr;
  Fpublic      := APublic;
end;

constructor SwagEndPoint.create(APath, ASummary: String; APublic: Boolean; ADescription: String);
begin
  Fsummary     := ASummary;
  Fdescription := ADescription;
  Fpath        := APath;
  Fpublic      := APublic;
end;

{ SwagParam }

function SwagParam.GetEnumValues: TArray<Variant>;
var
  splitter: TArray<String>;
  i       : Integer;
begin
  splitter := FEnumValues.Split([',']);

  SetLength(result, Length(splitter));
  for i := 0 to Pred(Length(splitter)) do
    result[i] := splitter[i];
end;

function SwagParam.isEnum: Boolean;
begin
  result := Length(FEnumValues) > 0;
end;

{ SwagParamBody }

function SwagParamBody.classType: TClass;
begin
  result := FclassType;
end;

constructor SwagParamBody.create(AName: string; AClassType: TClass; bIsArray: Boolean; ADescription: string; bRequired: Boolean);
begin
  Fname        := AName;
  FclassType   := AClassType;
  FisArray     := bIsArray;
  Fdescription := ADescription;
  Frequired    := bRequired;
end;

constructor SwagParamBody.create(AName: string; AClassType: TClass; ADescription: string; bIsArray, bRequired: Boolean);
begin
  create(AName, AClassType, bIsArray, ADescription, bRequired);
end;

{ SwagResponse }

constructor SwagResponse.create(AHttpCode: Integer; AClassType: TClass; bIsArray: Boolean; ADescription: String);
begin
  FhttpCode    := AHttpCode;
  FclassType   := AClassType;
  Fdescription := ADescription;
  FisArray     := bIsArray;
end;

constructor SwagResponse.create(AHttpCode: Integer; ASchema, ADescription: String; bIsArray: Boolean);
begin
  FhttpCode    := AHttpCode;
  Fschema      := ASchema;
  Fdescription := ADescription;
  FisArray     := bIsArray;
end;

constructor SwagResponse.create(AHttpCode: Integer; AClassType: TClass; ADescription: String; bIsArray: Boolean);
begin
  FhttpCode    := AHttpCode;
  FclassType   := AClassType;
  Fdescription := ADescription;
  FisArray     := bIsArray;
end;

function SwagResponse.classType: TClass;
begin
  result := FclassType;
end;

constructor SwagResponse.create(AHttpCode: Integer);
begin
  FhttpCode:= AHttpCode;
end;

constructor SwagResponse.create(AHttpCode: Integer; ASchema: String; bIsArray: Boolean; ADescription: String);
begin
  FhttpCode    := AHttpCode;
  Fschema      := ASchema;
  Fdescription := ADescription;
  FisArray     := bIsArray;
end;

{ SwaggerApp }

constructor SwagApp.create(ATitle, AVersion, AHost: String);
begin
  FTitle   := ATitle;
  FVersion := AVersion;
  FHost    := AHost;
end;

constructor SwagApp.create(ATitle: String);
begin
  create(ATitle, EmptyStr, EmptyStr);
end;

{ SwagAppDescription }

constructor SwagAppDescription.create(ADescription: String);
begin
  FDescription := ADescription;
end;

{ SwagBasePath }

constructor SwagBasePath.create(Value: String);
begin
  FValue := Value;
end;

{ SwagParamPath }

constructor SwagParamPath.create(AName, ADescription, AEnumValues: String; bIsNumber: Boolean = False);
begin
  Fname        := AName;
  Fdescription := ADescription;
  Fschema      := SWAG_STRING;
  FisArray     := False;
  Frequired    := True;
  FEnumValues  := AEnumValues;

  if bIsNumber then
    FSchema := SWAG_INTEGER;
end;

constructor SwagParamPath.create(AName, ADescription: String; bIsNumber: Boolean);
begin
  Fname        := AName;
  Fdescription := ADescription;
  Fschema      := SWAG_STRING;
  FisArray     := False;
  Frequired    := True;

  if bIsNumber then
    FSchema := SWAG_INTEGER;
end;

{ SwagParamHeader }

constructor SwagParamHeader.create(AName, ADescription, AEnumValues: String; bRequired: Boolean; bIsNumber: Boolean);
begin
  Fname        := AName;
  Fdescription := ADescription;
  Fschema      := SWAG_STRING;
  FisArray     := False;
  Frequired    := bRequired;
  FEnumValues  := AEnumValues;

  if bIsNumber then
    FSchema := SWAG_INTEGER;
end;

constructor SwagParamHeader.create(AName, ADescription: string; bRequired: Boolean; bIsNumber: Boolean);
begin
  Fname        := AName;
  Fdescription := ADescription;
  Fschema      := SWAG_STRING;
  FisArray     := False;
  Frequired    := bRequired;

  if bIsNumber then
    FSchema := SWAG_INTEGER;
end;

{ SwagParamQuery }

constructor SwagParamQuery.create(AName, ADescription, AEnumValues: String; bRequired: Boolean; bIsNumber: Boolean);
begin
  Fname        := AName;
  Fdescription := ADescription;
  Fschema      := SWAG_STRING;
  FisArray     := False;
  Frequired    := bRequired;
  FEnumValues  := AEnumValues;

  if bIsNumber then
    FSchema := SWAG_INTEGER;
end;

constructor SwagParamQuery.create(AName, ADescription: string; bRequired: Boolean; bIsNumber: Boolean);
begin
  Fname        := AName;
  Fdescription := ADescription;
  Fschema      := SWAG_STRING;
  FisArray     := False;
  Frequired    := bRequired;

  if bIsNumber then
    FSchema := SWAG_INTEGER;
end;

{ SwagContact }

constructor SwagContact.create(AName, AEmail, ASite: string);
begin
  Fname := AName;
  Femail:= AEmail;
  Fsite := ASite;
end;

end.
