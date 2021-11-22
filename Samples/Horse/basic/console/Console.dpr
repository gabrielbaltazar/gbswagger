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
  GBSwagger.Model.JSON.Contact in '..\..\..\..\Source\Core\GBSwagger.Model.JSON.Contact.pas',
  GBSwagger.Model.JSON.Header in '..\..\..\..\Source\Core\GBSwagger.Model.JSON.Header.pas',
  GBSwagger.Model.JSON.Info in '..\..\..\..\Source\Core\GBSwagger.Model.JSON.Info.pas',
  GBSwagger.Model.JSON.Interfaces in '..\..\..\..\Source\Core\GBSwagger.Model.JSON.Interfaces.pas',
  GBSwagger.Model.JSON.Parameter in '..\..\..\..\Source\Core\GBSwagger.Model.JSON.Parameter.pas',
  GBSwagger.Model.JSON in '..\..\..\..\Source\Core\GBSwagger.Model.JSON.pas',
  GBSwagger.Model.JSON.Path in '..\..\..\..\Source\Core\GBSwagger.Model.JSON.Path.pas',
  GBSwagger.Model.JSON.PathMethod in '..\..\..\..\Source\Core\GBSwagger.Model.JSON.PathMethod.pas',
  GBSwagger.Model.JSON.PathResponse in '..\..\..\..\Source\Core\GBSwagger.Model.JSON.PathResponse.pas',
  GBSwagger.Model.JSON.Schema in '..\..\..\..\Source\Core\GBSwagger.Model.JSON.Schema.pas',
  GBSwagger.Model.JSON.Security in '..\..\..\..\Source\Core\GBSwagger.Model.JSON.Security.pas',
  GBSwagger.Model.JSON.Utils in '..\..\..\..\Source\Core\GBSwagger.Model.JSON.Utils.pas',
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
  GBSwagger.Web.HTML in '..\..\..\..\Source\Core\GBSwagger.Web.HTML.pas';

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
