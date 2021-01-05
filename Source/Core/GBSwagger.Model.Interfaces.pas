unit GBSwagger.Model.Interfaces;

interface

uses
  Web.HTTPApp,
  GBSwagger.Model.Types;

const
  SWAG_STRING  = GBSwagger.Model.Types.SWAG_STRING;
  SWAG_INTEGER = GBSwagger.Model.Types.SWAG_INTEGER;

type
  TGBSwaggerContentType  = GBSwagger.Model.Types.TGBSwaggerContentType;
  TGBSwaggerProtocol     = GBSwagger.Model.Types.TGBSwaggerProtocol;
  TGBSwaggerParamType    = GBSwagger.Model.Types.TGBSwaggerParamType;
  TGBSwaggerSecurityType = GBSwagger.Model.Types.TGBSwaggerSecurityType;
  TGBSwaggerSecurityFlow = GBSwagger.Model.Types.TGBSwaggerSecurityFlow;

  IGBSwagger                 = interface;
  IGBSwaggerInfo             = interface;
  IGBSwaggerContact          = interface;
  IGBSwaggerTag              = interface;
  IGBSwaggerSchema           = interface;
  IGBSwaggerParameter        = interface;
  IGBSwaggerPathResponse     = interface;
  IGBSwaggerPath             = interface;
  IGBSwaggerPathMethod       = interface;
  IGBSwaggerHeader           = interface;
  IGBSwaggerRegisterResponse = interface;
  IGBSwaggerRegister         = interface;
  IGBSwaggerSecurity         = interface;

  IGBSwaggerConfig = interface
    ['{8C8E5F41-02CF-4FC2-BBF9-7E5C0A4FF607}']
    function DateFormat   (Value: String): IGBSwaggerConfig; overload;
    function ClassPrefixes(Value: String): IGBSwaggerConfig; overload;
    function ResourcePath (Value: String): IGBSwaggerConfig; overload;
    function ModuleName   (Value: String): IGBSwaggerConfig; overload;

    function DateFormat   : string; overload;
    function ClassPrefixes: TArray<String>; overload;
    function ResourcePath : String; overload;
    function ModuleName   : String; overload;

    function &End: IGBSwagger;
  end;

  IGBSwagger = interface
    ['{4982C423-B4B0-4856-931F-A960365F8855}']
    function Version  (Value: String): IGBSwagger; overload;
    function Host     (Value: String): IGBSwagger; overload;
    function BasePath (Value: String): IGBSwagger; overload;

    function Version  : string; overload;
    function Host     : String; overload;
    function BasePath : String; overload;

    function AddConsumes (Value: TGBSwaggerContentType): IGBSwagger;
    function AddProduces (Value: TGBSwaggerContentType): IGBSwagger;
    function AddProtocol (Value: TGBSwaggerProtocol)   : IGBSwagger;

    function AddSecurity(Description: String): IGBSwaggerSecurity;
    function AddBearerSecurity: IGBSwaggerSecurity;
    function AddBasicSecurity : IGBSwaggerSecurity;

    function Path(Name: String): IGBSwaggerPath;

    function Consumes  : TArray<TGBSwaggerContentType>;
    function Produces  : TArray<TGBSwaggerContentType>;
    function Protocols : TArray<TGBSwaggerProtocol>;
    function Schemas   : TArray<IGBSwaggerSchema>;
    function Paths     : TArray<IGBSwaggerPath>;
    function Securities: TArray<IGBSwaggerSecurity>;

    function Info   : IGBSwaggerInfo;
    function Config : IGBSwaggerConfig;
    function AddTag : IGBSwaggerTag;

    function &Register: IGBSwaggerRegister;

    function AddModel(ClassType: TClass): IGBSwagger; overload;

    function SchemaName(ClassType: TClass): string;

    function &End: IGBSwagger;
  end;

  IGBSwaggerInfo = interface
    ['{BF421BCA-7A85-4B1D-8814-C22AF03E743B}']
    function Title          (Value: String): IGBSwaggerInfo; overload;
    function TermsOfService (Value: String): IGBSwaggerInfo; overload;
    function Description    (Value: String): IGBSwaggerInfo; overload;
    function Version        (Value: String): IGBSwaggerInfo; overload;

    function Title          : string; overload;
    function Description    : String; overload;
    function TermsOfService : string; overload;
    function Version        : string; overload;

    function Contact: IGBSwaggerContact;
    function License: IGBSwaggerContact;

    function &End: IGBSwagger;
  end;

  IGBSwaggerContact = interface
    ['{9D38F8E0-9EB1-40F0-B2A5-94F2B50C8DE5}']
    function Name  (Value: String): IGBSwaggerContact; overload;
    function Email (Value: string): IGBSwaggerContact; overload;
    function URL   (Value: String): IGBSwaggerContact; overload;

    function Name  : String; overload;
    function Email : string; overload;
    function URL   : string; overload;

    function &End: IGBSwaggerInfo;
  end;

  IGBSwaggerTag = interface
    ['{34BE20BB-0964-4F97-B71E-BDD7DFF21D01}']
    function Name           (Value: String): IGBSwaggerTag; overload;
    function Description    (Value: String): IGBSwaggerTag; overload;
    function DocDescription (Value: String): IGBSwaggerTag; overload;
    function DocURL         (Value: String): IGBSwaggerTag; overload;

    function Name          : String; overload;
    function Description   : String; overload;
    function DocDescription: String; overload;
    function DocURL        : String; overload;

    function &End: IGBSwagger;
  end;

  IGBSwaggerSchema = interface
    ['{E1C9D3C8-AA88-44B9-AF09-E8E0E79CCD92}']
    function Name      (Value: String): IGBSwaggerSchema; overload;
    function ClassType (Value: TClass): IGBSwaggerSchema; overload;

    function Name     : String; overload;
    function ClassType: TClass; overload;

    function &End: IGBSwagger;
  end;

  IGBSwaggerPath = interface
    ['{4433F0AA-8AC8-4D47-99FA-6CD34C193079}']
    function Name(Value: String): IGBSwaggerPath; overload;
    function Name: string; overload;

    function Tag(Value: String): IGBSwaggerPath;
    function Tags: TArray<String>;

    function GET    (Summary: string = ''; Description: string = ''): IGBSwaggerPathMethod;
    function POST   (Summary: string = ''; Description: string = ''): IGBSwaggerPathMethod;
    function PUT    (Summary: string = ''; Description: string = ''): IGBSwaggerPathMethod;
    function DELETE (Summary: string = ''; Description: string = ''): IGBSwaggerPathMethod;
    function PATCH  (Summary: string = ''; Description: string = ''): IGBSwaggerPathMethod;

    function Methods: TArray<IGBSwaggerPathMethod>;

    function &End: IGBSwagger;
  end;

  IGBSwaggerPathMethod = interface
    ['{62EBE361-93B6-4828-8FC7-880C6AB82BE7}']
    function MethodType  (Value: TMethodType): IGBSwaggerPathMethod; overload;
    function Summary     (Value: String): IGBSwaggerPathMethod; overload;
    function Description (Value: string): IGBSwaggerPathMethod; overload;
    function OperationId (Value: string): IGBSwaggerPathMethod; overload;
    function AddConsumes (Value: TGBSwaggerContentType): IGBSwaggerPathMethod; overload;
    function AddProduces (Value: TGBSwaggerContentType): IGBSwaggerPathMethod; overload;
    function AddTag      (Value: String): IGBSwaggerPathMethod; overload;

    function MethodType : TMethodType; overload;
    function Summary    : String; overload;
    function Description: string; overload;
    function OperationId: string; overload;

    function AddParamHeader  (Name: string = ''; Description: String = ''): IGBSwaggerParameter;
    function AddParamBody    (Name: string = ''; Description: String = ''): IGBSwaggerParameter;
    function AddParamQuery   (Name: string = ''; Description: String = ''): IGBSwaggerParameter;
    function AddParamPath    (Name: string = ''; Description: String = ''): IGBSwaggerParameter;
    function AddParamFormData(Name: string = ''; Description: String = ''): IGBSwaggerParameter;

    function AddSecurity(Description: String): IGBSwaggerPathMethod;

    function AddResponse (HttpCode: Integer; Description: String = ''): IGBSwaggerPathResponse; overload;

    function IsPublic(Value: Boolean): IGBSwaggerPathMethod; overload;
    function IsPublic: Boolean; overload;

    function Consumes  : TArray<TGBSwaggerContentType>;
    function Produces  : TArray<TGBSwaggerContentType>;
    function Parameters: TArray<IGBSwaggerParameter>;
    function Responses : TArray<IGBSwaggerPathResponse>;
    function Tags      : TArray<String>;
    function Securities: TArray<String>;

    function &End: IGBSwaggerPath;
  end;

  IGBSwaggerParameter = interface
    ['{6DE498AC-E611-4B20-B8A1-ED821879A0F8}']
    function ParamType   (Value: TGBSwaggerParamType): IGBSwaggerParameter; overload;
    function Name        (Value: string): IGBSwaggerParameter; overload;
    function Description (Value: String): IGBSwaggerParameter; overload;
    function Schema      (Value: String): IGBSwaggerParameter; overload;
    function Schema      (Value: TClass): IGBSwaggerParameter; overload;
    function Required    (Value: Boolean): IGBSwaggerParameter; overload;
    function IsArray     (Value: Boolean): IGBSwaggerParameter; overload;
    function EnumValues  (Value: TArray<Variant>): IGBSwaggerParameter; overload;

    function ParamType  : TGBSwaggerParamType; overload;
    function Name       : string; overload;
    function Description: String; overload;
    function Schema     : TClass; overload;
    function Required   : Boolean; overload;
    function IsArray    : Boolean; overload;
    function IsObject   : Boolean; overload;
    function IsEnum     : Boolean;
    function EnumValues : TArray<Variant>; overload;

    function SchemaType: string;

    function &End: IGBSwaggerPathMethod;
  end;

  IGBSwaggerPathResponse = interface
    ['{F17B129B-F589-4C0C-B6A8-D4CD0C960A90}']
    function HttpCode    (Value: Integer): IGBSwaggerPathResponse; overload;
    function Description (Value: String): IGBSwaggerPathResponse; overload;
    function Schema      (Value: String): IGBSwaggerPathResponse; overload;
    function Schema      (Value: TClass): IGBSwaggerPathResponse; overload;
    function IsArray     (Value: Boolean): IGBSwaggerPathResponse; overload;

    function HttpCode   : Integer; overload;
    function Description: String; overload;
    function Schema     : TClass; overload;
    function IsArray    : Boolean; overload;
    function &Type      : string;

    function Header(Name: String = ''; Description: String = ''): IGBSwaggerHeader;
    function Headers: TArray<IGBSwaggerHeader>;

    function &End: IGBSwaggerPathMethod;
  end;

  IGBSwaggerHeader = interface
    ['{B5E9EC73-9A59-4297-9871-8E972ADC8E2F}']
    function Name        : String; overload;
    function Description : String; overload;
    function &Type       : String; overload;
    function Format      : string; overload;

    function Name        (Value: String): IGBSwaggerHeader; overload;
    function Description (Value: String): IGBSwaggerHeader; overload;
    function &Type       (Value: String): IGBSwaggerHeader; overload;
    function Format      (Value: String): IGBSwaggerHeader; overload;

    function &End: IGBSwaggerPathResponse;
  end;

  /////////////////////////////////////////////////////////////////////////////////
  ///  Auth
  ////////////////////////////////////////////////////////////////////////////////
  IGBSwaggerSecurity = interface
    ['{9FC3A862-C12E-4B89-A834-91FCBA4E4E15}']
    function &Type       (Value: TGBSwaggerSecurityType): IGBSwaggerSecurity; overload;
    function Description (Value: String): IGBSwaggerSecurity; overload;
    function Name        (Value: String): IGBSwaggerSecurity; overload;
    function Flow        (Value: TGBSwaggerSecurityFlow): IGBSwaggerSecurity; overload;
    function &In         (Value: TGBSwaggerParamType): IGBSwaggerSecurity; overload;
    function AuthorizationURL(Value: String): IGBSwaggerSecurity; overload;
    function TokenURL (Value: String): IGBSwaggerSecurity; overload;

    function &Type            : TGBSwaggerSecurityType; overload;
    function Description      : String; overload;
    function Name             : String; overload;
    function &In              : TGBSwaggerParamType; overload;
    function Flow             : TGBSwaggerSecurityFlow; overload;
    function AuthorizationURL : String; overload;
    function TokenURL         : String; overload;

    function &End: IGBSwagger;
  end;

  /////////////////////////////////////////////////////////////////////////////////
  ///  Registers
  ////////////////////////////////////////////////////////////////////////////////

  IGBSwaggerRegister = interface
    ['{0831DD2A-238E-4817-AC5D-B8A7A939AEDC}']
    function ResponseExists(StatusCode: Integer): Boolean;
    function Response      (StatusCode: Integer): IGBSwaggerRegisterResponse;
    function SchemaOnError (Value: TClass): IGBSwaggerRegister;

    function &End: IGBSwagger;
  end;

  IGBSwaggerRegisterResponse = interface
    ['{0F98B81A-EEE6-4B89-B147-303A215B9526}']
    function &Register   (StatusCode: Integer): IGBSwaggerRegisterResponse;
    function HttpCode    (Value: Integer): IGBSwaggerRegisterResponse; overload;
    function Description (Value: String): IGBSwaggerRegisterResponse; overload;
    function Schema      (Value: String): IGBSwaggerRegisterResponse; overload;
    function Schema      (Value: TClass): IGBSwaggerRegisterResponse; overload;
    function IsArray     (Value: Boolean): IGBSwaggerRegisterResponse; overload;

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
