unit GBSwagger.Model.Interfaces;

interface

uses
  Web.HTTPApp,
  GBSwagger.Model.Types;

const
  SWAG_STRING = GBSwagger.Model.Types.SWAG_STRING;
  SWAG_INTEGER = GBSwagger.Model.Types.SWAG_INTEGER;

type
  TGBSwaggerContentType = GBSwagger.Model.Types.TGBSwaggerContentType;
  TGBSwaggerProtocol = GBSwagger.Model.Types.TGBSwaggerProtocol;
  TGBSwaggerParamType = GBSwagger.Model.Types.TGBSwaggerParamType;
  TGBSwaggerSecurityType = GBSwagger.Model.Types.TGBSwaggerSecurityType;
  TGBSwaggerSecurityFlow = GBSwagger.Model.Types.TGBSwaggerSecurityFlow;
  TGBSwaggerConfigureDocExpansion = GBSwagger.Model.Types.TGBSwaggerConfigureDocExpansion;

  IGBSwagger = interface;
  IGBSwaggerInfo = interface;
  IGBSwaggerContact = interface;
  IGBSwaggerTag = interface;
  IGBSwaggerSchema = interface;
  IGBSwaggerParameter = interface;
  IGBSwaggerPathResponse = interface;
  IGBSwaggerPath = interface;
  IGBSwaggerPathMethod = interface;
  IGBSwaggerHeader = interface;
  IGBSwaggerRegisterResponse = interface;
  IGBSwaggerRegister = interface;
  IGBSwaggerSecurity = interface;

  IGBSwaggerConfig = interface
    ['{8C8E5F41-02CF-4FC2-BBF9-7E5C0A4FF607}']
    function DateFormat(AValue: string): IGBSwaggerConfig; overload;
    function DateFormat: string; overload;

    function ClassPrefixes(AValue: string): IGBSwaggerConfig; overload;
    function ClassPrefixes: TArray<string>; overload;

    function ModuleName(AValue: string): IGBSwaggerConfig; overload;
    function ModuleName: string; overload;

    function Language(AValue: string): IGBSwaggerConfig; overload;
    function Language: string; overload;

    function ResourcePath(AValue: string): IGBSwaggerConfig; overload;
    function ResourcePath: string; overload;

    function DocExpansion(AValue: TGBSwaggerConfigureDocExpansion): IGBSwaggerConfig; overload;
    function DocExpansion: TGBSwaggerConfigureDocExpansion; overload;

    function HTMLContentType(AValue: string): IGBSwaggerConfig; overload;
    function HTMLContentType: string; overload;

    function &End: IGBSwagger;
  end;

  IGBSwagger = interface
    ['{4982C423-B4B0-4856-931F-A960365F8855}']
    function Version(AValue: string): IGBSwagger; overload;
    function Host(AValue: string): IGBSwagger; overload;
    function BasePath(AValue: string): IGBSwagger; overload;

    function Version: string; overload;
    function Host: string; overload;
    function BasePath: string; overload;

    function AddConsumes(AValue: string): IGBSwagger; overload;
    function AddConsumes(AValue: TGBSwaggerContentType): IGBSwagger; overload;
    function AddProduces(AValue: string): IGBSwagger; overload;
    function AddProduces(AValue: TGBSwaggerContentType): IGBSwagger; overload;
    function AddProtocol(AValue: TGBSwaggerProtocol): IGBSwagger;

    function AddSecurity(ADescription: string): IGBSwaggerSecurity;
    function AddBearerSecurity: IGBSwaggerSecurity;
    function AddBasicSecurity: IGBSwaggerSecurity;

    function Path(AName: string): IGBSwaggerPath;

    function Consumes: TArray<string>;
    function Produces: TArray<string>;
    function Protocols: TArray<TGBSwaggerProtocol>;
    function Schemas: TArray<IGBSwaggerSchema>;
    function Paths: TArray<IGBSwaggerPath>;
    function Securities: TArray<IGBSwaggerSecurity>;

    function Info: IGBSwaggerInfo;
    function Config: IGBSwaggerConfig;
    function AddTag: IGBSwaggerTag;
    function &Register: IGBSwaggerRegister;
    function AddModel(AClassType: TClass): IGBSwagger; overload;
    function SchemaName(AClassType: TClass): string;

    function &End: IGBSwagger;
  end;

  IGBSwaggerInfo = interface
    ['{BF421BCA-7A85-4B1D-8814-C22AF03E743B}']
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
  end;

  IGBSwaggerContact = interface
    ['{9D38F8E0-9EB1-40F0-B2A5-94F2B50C8DE5}']
    function Name(AValue: string): IGBSwaggerContact; overload;
    function Email(AValue: string): IGBSwaggerContact; overload;
    function URL(AValue: string): IGBSwaggerContact; overload;

    function Name: string; overload;
    function Email: string; overload;
    function URL: string; overload;
    function &End: IGBSwaggerInfo;
  end;

  IGBSwaggerTag = interface
    ['{34BE20BB-0964-4F97-B71E-BDD7DFF21D01}']
    function Name(AValue: string): IGBSwaggerTag; overload;
    function Description(AValue: string): IGBSwaggerTag; overload;
    function DocDescription(AValue: string): IGBSwaggerTag; overload;
    function DocURL(AValue: string): IGBSwaggerTag; overload;

    function Name: string; overload;
    function Description: string; overload;
    function DocDescription: string; overload;
    function DocURL: string; overload;
    function &End: IGBSwagger;
  end;

  IGBSwaggerSchema = interface
    ['{E1C9D3C8-AA88-44B9-AF09-E8E0E79CCD92}']
    function Name(AValue: string): IGBSwaggerSchema; overload;
    function ClassType(AValue: TClass): IGBSwaggerSchema; overload;

    function Name: string; overload;
    function ClassType: TClass; overload;
    function &End: IGBSwagger;
  end;

  IGBSwaggerPath = interface
    ['{4433F0AA-8AC8-4D47-99FA-6CD34C193079}']
    function Name(AValue: string): IGBSwaggerPath; overload;
    function Name: string; overload;

    function Tag(AValue: string): IGBSwaggerPath;
    function Tags: TArray<string>;

    function GET(ASummary: string = ''; ADescription: string = ''): IGBSwaggerPathMethod;
    function POST(ASummary: string = ''; ADescription: string = ''): IGBSwaggerPathMethod;
    function PUT(ASummary: string = ''; ADescription: string = ''): IGBSwaggerPathMethod;
    function DELETE(ASummary: string = ''; ADescription: string = ''): IGBSwaggerPathMethod;
    function PATCH(ASummary: string = ''; ADescription: string = ''): IGBSwaggerPathMethod;
    function Methods: TArray<IGBSwaggerPathMethod>;
    function &End: IGBSwagger;
  end;

  IGBSwaggerPathMethod = interface
    ['{62EBE361-93B6-4828-8FC7-880C6AB82BE7}']
    function MethodType(AValue: TMethodType): IGBSwaggerPathMethod; overload;
    function Summary(AValue: string): IGBSwaggerPathMethod; overload;
    function Description(AValue: string): IGBSwaggerPathMethod; overload;
    function OperationId(AValue: string): IGBSwaggerPathMethod; overload;
    function AddConsumes(AValue: string): IGBSwaggerPathMethod; overload;
    function AddConsumes(AValue: TGBSwaggerContentType): IGBSwaggerPathMethod; overload;
    function AddProduces(AValue: string): IGBSwaggerPathMethod; overload;
    function AddProduces(AValue: TGBSwaggerContentType): IGBSwaggerPathMethod; overload;
    function AddTag(AValue: string): IGBSwaggerPathMethod; overload;

    function MethodType: TMethodType; overload;
    function Summary: string; overload;
    function Description: string; overload;
    function OperationId: string; overload;

    function AddParamHeader(AName: string = ''; ADescription: string = ''): IGBSwaggerParameter;
    function AddParamBody(AName: string = ''; ADescription: string = ''): IGBSwaggerParameter;
    function AddParamQuery(AName: string = ''; ADescription: string = ''): IGBSwaggerParameter;
    function AddParamPath(AName: string = ''; ADescription: string = ''): IGBSwaggerParameter;
    function AddParamFormData(AName: string = ''; ADescription: string = ''): IGBSwaggerParameter;
    function AddSecurity(ADescription: string): IGBSwaggerPathMethod;
    function AddResponse(AHttpCode: Integer; ADescription: string = ''): IGBSwaggerPathResponse; overload;

    function IsPublic(AValue: Boolean): IGBSwaggerPathMethod; overload;
    function IsPublic: Boolean; overload;

    function Consumes: TArray<string>;
    function Produces: TArray<string>;
    function Parameters: TArray<IGBSwaggerParameter>;
    function Responses: TArray<IGBSwaggerPathResponse>;
    function Tags: TArray<string>;
    function Securities: TArray<string>;
    function &End: IGBSwaggerPath;
  end;

  IGBSwaggerParameter = interface
    ['{6DE498AC-E611-4B20-B8A1-ED821879A0F8}']
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
  end;

  IGBSwaggerPathResponse = interface
    ['{F17B129B-F589-4C0C-B6A8-D4CD0C960A90}']
    function HttpCode(AValue: Integer): IGBSwaggerPathResponse; overload;
    function Description(AValue: string): IGBSwaggerPathResponse; overload;
    function Schema(AValue: string): IGBSwaggerPathResponse; overload;
    function Schema(AValue: TClass): IGBSwaggerPathResponse; overload;
    function IsArray(AValue: Boolean): IGBSwaggerPathResponse; overload;

    function HttpCode: Integer; overload;
    function Description: string; overload;
    function Schema: TClass; overload;
    function IsArray: Boolean; overload;
    function &Type: string;

    function Header(AName: string = ''; ADescription: string = ''): IGBSwaggerHeader;
    function Headers: TArray<IGBSwaggerHeader>;
    function &End: IGBSwaggerPathMethod;
  end;

  IGBSwaggerHeader = interface
    ['{B5E9EC73-9A59-4297-9871-8E972ADC8E2F}']
    function Name: string; overload;
    function Description: string; overload;
    function &Type: string; overload;
    function Format: string; overload;

    function Name(AValue: string): IGBSwaggerHeader; overload;
    function Description(AValue: string): IGBSwaggerHeader; overload;
    function &Type(AValue: string): IGBSwaggerHeader; overload;
    function Format(AValue: string): IGBSwaggerHeader; overload;

    function &End: IGBSwaggerPathResponse;
  end;

  /////////////////////////////////////////////////////////////////////////////////
  ///  Auth
  ////////////////////////////////////////////////////////////////////////////////
  IGBSwaggerSecurity = interface
    ['{9FC3A862-C12E-4B89-A834-91FCBA4E4E15}']
    function &Type(AValue: TGBSwaggerSecurityType): IGBSwaggerSecurity; overload;
    function Description(AValue: string): IGBSwaggerSecurity; overload;
    function Name(AValue: string): IGBSwaggerSecurity; overload;
    function Flow(AValue: TGBSwaggerSecurityFlow): IGBSwaggerSecurity; overload;
    function &In(AValue: TGBSwaggerParamType): IGBSwaggerSecurity; overload;
    function AuthorizationURL(AValue: string): IGBSwaggerSecurity; overload;
    function TokenURL(AValue: string): IGBSwaggerSecurity; overload;

    function AddCallback(AValue: TRouteCallback): IGBSwaggerSecurity;
    function Callbacks: TArray<TRouteCallback>;

    function &Type: TGBSwaggerSecurityType; overload;
    function Description: string; overload;
    function Name: string; overload;
    function &In: TGBSwaggerParamType; overload;
    function Flow: TGBSwaggerSecurityFlow; overload;
    function AuthorizationURL: string; overload;
    function TokenURL: string; overload;

    function &End: IGBSwagger;
  end;

  /////////////////////////////////////////////////////////////////////////////////
  ///  Registers
  ////////////////////////////////////////////////////////////////////////////////

  IGBSwaggerRegister = interface
    ['{0831DD2A-238E-4817-AC5D-B8A7A939AEDC}']
    function ResponseExists(AStatusCode: Integer): Boolean;
    function Response(AStatusCode: Integer): IGBSwaggerRegisterResponse;
    function SchemaOnError(AValue: TClass): IGBSwaggerRegister;

    function &End: IGBSwagger;
  end;

  IGBSwaggerRegisterResponse = interface
    ['{0F98B81A-EEE6-4B89-B147-303A215B9526}']
    function &Register(AStatusCode: Integer): IGBSwaggerRegisterResponse;
    function HttpCode(AValue: Integer): IGBSwaggerRegisterResponse;
    function Description(AValue: string): IGBSwaggerRegisterResponse;
    function Schema(AValue: string): IGBSwaggerRegisterResponse; overload;
    function Schema(AValue: TClass): IGBSwaggerRegisterResponse; overload;
    function IsArray(AValue: Boolean): IGBSwaggerRegisterResponse;
    function PathResponse: IGBSwaggerPathResponse;
    function &End: IGBSwaggerRegister;
  end;

var
  APPSwagger: IGBSwagger;

function Swagger: IGBSwagger;

implementation

uses
  GBSwagger.Model;

function Swagger: IGBSwagger;
begin
  if not Assigned(APPSwagger) then
    APPSwagger := TGBSwaggerModel.GetInstance;
  Result := APPSwagger;
end;

end.
