program Console_ce;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  Horse.CORS,
  Horse.GBSwagger,
  System.SysUtils,
  Annotation.Classes in '..\Annotation.Classes.pas',
  Annotation.Controller.User in '..\Annotation.Controller.User.pas';

procedure SwaggerConfig;
begin
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
    .BasePath('v1');
end;

begin
  ReportMemoryLeaksOnShutdown := True;

  THorse
    .Use(CORS)
    .Use(HorseSwagger());

  SwaggerConfig;
  THorseGBSwaggerRegister.RegisterPath(TUserController);

  THorse.Listen(9000);

end.
