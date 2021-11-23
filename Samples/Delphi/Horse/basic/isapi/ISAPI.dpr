library ISAPI;

{$R *.res}

uses
  Horse,
  Horse.GBSwagger;

type
  TUser = class
  private
    Fid: Double;
    Fname: String;
    FlastName: string;
  public
    property id: Double read Fid write Fid;
    property name: String read Fname write Fname;
    property lastName: string read FlastName write FlastName;
  end;

  TAPIError = class
  private
    Ferror: string;
  public
    property error: string read Ferror write Ferror;
  end;

begin
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
    .Config
      .ModuleName('api/ISAPI.dll')
    .&End
    .Info
      .Title('Horse Isapi Sample')
      .Description('API Horse')
      .Contact
        .Name('Contact Name')
        .Email('contact@email.com.br')
        .URL('http://www.mypage.com.br')
      .&End
    .&End
    .BasePath('api/ISAPI.dll/v1')
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
