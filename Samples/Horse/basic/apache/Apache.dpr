library Apache;

{$R *.res}

(*
 httpd.conf entries:
 LoadModule apache_horse_module modules/Apache.dll
 <Location /apache_horse>
    SetHandler apache_horse_module-handle
 </Location>
 To use the feature:
 http://localhost/apache_horse/ping
 These entries assume that the output directory for this project is the apache/modules directory.
 httpd.conf entries should be different if the project is changed in these ways:
   1. The TApacheModuleData variable name is changed.
   2. The project is renamed.
   3. The output directory is not the apache/modules directory.
   4. The dynamic library extension depends on a platform. Use .dll on Windows and .so on Linux.
*)

// Declare exported variable so that Apache can access this module.

uses
  Horse,
  Horse.GBSwagger,
  Web.HTTPD24Impl;

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

var
  ApacheModuleData: TApacheModuleData;

exports
  ApacheModuleData name 'apache_horse_module';

begin

  THorse.DefaultModule := @ApacheModuleData;
  THorse.HandlerName := 'apache_horse_module-handle';

  THorse.Use(HorseSwagger);

  THorse.Get ('v1/user',
    procedure (Req: THorseRequest; Resp: THorseResponse; Next: TProc)
    begin
      Resp.Send('[]').Status(200);
    end);

  THorse.Post('v1/user',
    procedure (Req: THorseRequest; Resp: THorseResponse; Next: TProc)
    begin
      Resp.Send('{"id": 1, "name":"user 1", "lastName": "user 1"}').Status(201);
    end);

  Swagger
    .Config
      .ModuleName('apache_horse')
    .&End
    .Info
      .Title('Horse Apache Sample')
      .Description('API Horse')
      .Contact
        .Name('Contact Name')
        .Email('contact@email.com.br')
        .URL('http://www.mypage.com.br')
      .&End
    .&End
    .BasePath('apache_horse/v1')
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
          .Schema(TUser)
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

  THorse.Listen;

end.
