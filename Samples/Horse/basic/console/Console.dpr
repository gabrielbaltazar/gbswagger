program Console;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  Horse.GBSwagger,
  System.SysUtils,
  GBSwagger.Model.Attributes in '..\..\..\..\Source\Core\GBSwagger.Model.Attributes.pas',
  GBSwagger.Model.Config in '..\..\..\..\Source\Core\GBSwagger.Model.Config.pas',
  GBSwagger.Model.Contact in '..\..\..\..\Source\Core\GBSwagger.Model.Contact.pas',
  GBSwagger.Model.Header in '..\..\..\..\Source\Core\GBSwagger.Model.Header.pas',
  GBSwagger.Model.Info in '..\..\..\..\Source\Core\GBSwagger.Model.Info.pas',
  GBSwagger.Model.Interfaces in '..\..\..\..\Source\Core\GBSwagger.Model.Interfaces.pas',
  GBSwagger.Model.Parameter in '..\..\..\..\Source\Core\GBSwagger.Model.Parameter.pas',
  GBSwagger.Model in '..\..\..\..\Source\Core\GBSwagger.Model.pas',
  GBSwagger.Model.Path in '..\..\..\..\Source\Core\GBSwagger.Model.Path.pas',
  GBSwagger.Model.PathMethod in '..\..\..\..\Source\Core\GBSwagger.Model.PathMethod.pas',
  GBSwagger.Model.PathResponse in '..\..\..\..\Source\Core\GBSwagger.Model.PathResponse.pas',
  GBSwagger.Model.Schema in '..\..\..\..\Source\Core\GBSwagger.Model.Schema.pas',
  GBSwagger.Model.Security in '..\..\..\..\Source\Core\GBSwagger.Model.Security.pas',
  GBSwagger.Model.Tag in '..\..\..\..\Source\Core\GBSwagger.Model.Tag.pas',
  GBSwagger.Model.Types in '..\..\..\..\Source\Core\GBSwagger.Model.Types.pas',
  GBSwagger.Path.Attributes in '..\..\..\..\Source\Core\GBSwagger.Path.Attributes.pas',
  GBSwagger.Path.Register in '..\..\..\..\Source\Core\GBSwagger.Path.Register.pas',
  GBSwagger.Register.Interfaces in '..\..\..\..\Source\Core\GBSwagger.Register.Interfaces.pas',
  GBSwagger.Register in '..\..\..\..\Source\Core\GBSwagger.Register.pas',
  GBSwagger.Register.Response in '..\..\..\..\Source\Core\GBSwagger.Register.Response.pas',
  GBSwagger.Resources in '..\..\..\..\Source\Core\GBSwagger.Resources.pas' {GBSwaggerResources: TDataModule},
  GBSwagger.RTTI in '..\..\..\..\Source\Core\GBSwagger.RTTI.pas',
  GBSwagger.Web.HTML in '..\..\..\..\Source\Core\GBSwagger.Web.HTML.pas',
  GBSwagger.JSON.Interfaces in '..\..\..\..\Source\Core\GBSwagger.JSON.Interfaces.pas',
  GBSwagger.JSON.Utils in '..\..\..\..\Source\Core\GBSwagger.JSON.Utils.pas',
  GBSwagger.JSON.V2.Contact in '..\..\..\..\Source\Core\GBSwagger.JSON.V2.Contact.pas',
  GBSwagger.JSON.V2.Header in '..\..\..\..\Source\Core\GBSwagger.JSON.V2.Header.pas',
  GBSwagger.JSON.V2.Info in '..\..\..\..\Source\Core\GBSwagger.JSON.V2.Info.pas',
  GBSwagger.JSON.V2.Parameter in '..\..\..\..\Source\Core\GBSwagger.JSON.V2.Parameter.pas',
  GBSwagger.JSON.V2 in '..\..\..\..\Source\Core\GBSwagger.JSON.V2.pas',
  GBSwagger.JSON.V2.Path in '..\..\..\..\Source\Core\GBSwagger.JSON.V2.Path.pas',
  GBSwagger.JSON.V2.PathMethod in '..\..\..\..\Source\Core\GBSwagger.JSON.V2.PathMethod.pas',
  GBSwagger.JSON.V2.PathResponse in '..\..\..\..\Source\Core\GBSwagger.JSON.V2.PathResponse.pas',
  GBSwagger.JSON.V2.Schema in '..\..\..\..\Source\Core\GBSwagger.JSON.V2.Schema.pas',
  GBSwagger.JSON.V2.Security in '..\..\..\..\Source\Core\GBSwagger.JSON.V2.Security.pas';

type
  TUser = class
  private
    Fid: Double;
    Fname: String;
    FlastName: string;
    FbirthdayDate: TDateTime;
    FlastUpdate: TDateTime;
  public
    property id: Double read Fid write Fid;
    property name: String read Fname write Fname;
    property lastName: string read FlastName write FlastName;
    property birthdayDate: TDateTime read FbirthdayDate write FbirthdayDate;
    property lastUpdate: TDateTime read FlastUpdate write FlastUpdate;
  end;

  TAPIError = class
  private
    Ferror: string;
  public
    property error: string read Ferror write Ferror;
  end;

begin
  ReportMemoryLeaksOnShutdown := True;

  THorse.GetInstance.Use(HorseSwagger);

  THorse.GetInstance.Get ('v1/user',
    procedure (Req: THorseRequest; Resp: THorseResponse; Next: TProc)
    begin
      Resp.Send('[]').Status(200);
    end);

  THorse.GetInstance.Post('v1/user',
    procedure (Req: THorseRequest; Resp: THorseResponse; Next: TProc)
    begin
      Resp.Send('{"id": 1, "name":"user 1", "lastName": "user 1"}').Status(201);
    end);

  Swagger
    .Info
      .Title('Horse Sample')
      .Description('API Horse')
      .Contact
        .Name('Contact Name')
        .Email('contact@email.com.br')
        .URL('http://www.mypage.com.br')
      .&End
    .&End
    .BasePath('v1')
    .Path('user')
      .Tag('User')
      .GET('List All', 'List All Users')
        .AddResponse(200, 'successful operation')
          .Schema(TUser)
          .IsArray(True)
        .&End
        .AddResponse(400).&End
        .AddResponse(500).&End
      .&End
      .POST('Add user', 'Add a new user')
        .AddParamBody('User data', 'User data')
          .Required(True)
          .Schema('string')
        .&End
        .AddResponse(201, 'Created')
          .Schema(TUser)
        .&End
        .AddResponse(400, 'BadRequest')
          .Schema(TAPIError)
        .&End
        .AddResponse(500).&End
      .&End
    .&End
  .&End;

  THorse.Listen(9000);

end.
