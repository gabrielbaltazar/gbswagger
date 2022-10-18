program Console;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  Horse.GBSwagger,
  System.SysUtils;

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
