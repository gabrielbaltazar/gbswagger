program Console_jwt;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  Horse.JWT,
  Horse.GBSwagger,
  System.SysUtils,
  Annotation.JWT.Classes in 'Annotation.JWT.Classes.pas',
  Annotation.JWT.Controller.User in 'Annotation.JWT.Controller.User.pas';

procedure SwaggerConfig;
var
  jwtConfig: IHorseJWTConfig;
begin
  jwtConfig := THorseJWTConfig.New;
  jwtConfig.IsRequireAudience(False)
    .ExpectedAudience(['Teste Client']);

  Swagger
    .Register
      .SchemaOnError(TAPIError)
    .&End
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
    .AddBearerSecurity
      .AddCallback(HorseJWT('MY-PASSWORD', jwtConfig));
end;

begin
  IsConsole := False;
  ReportMemoryLeaksOnShutdown := True;
  SwaggerConfig;

  THorse.Use(HorseSwagger);

  THorseGBSwaggerRegister.RegisterPath(TUserController);

  THorse.Listen(9000,
    procedure (Horse: THorse)
    begin
      Writeln('Server running...');
      Readln;
    end);
end.
