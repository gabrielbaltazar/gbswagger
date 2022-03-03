program Console_basic;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse.GBSwagger,
  Horse,
  Horse.BasicAuthentication;

procedure SwaggerConfig;
begin
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
    .BasePath('v1');
end;

begin
  THorse.Use(HorseSwagger);
  THorse.Use(HorseBasicAuthentication(
    function(const AUsername, APassword: string): Boolean
    begin
      Result := AUsername.Equals('user') and APassword.Equals('password');
    end,
    THorseBasicAuthenticationConfig.New.
      SkipRoutes(['swagger/doc/html', 'swagger/doc/json'])));

  THorse.Get('/ping',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    begin
      Res.Send('pong');
    end);

  THorse.Listen(9000,
    procedure(Horse: THorse)
    begin
      Writeln(Format('Server is runing on port %d', [Horse.Port]));
    end);

end.
