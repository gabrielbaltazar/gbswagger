program Console;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  Horse.GBSwagger,
  System.SysUtils,
  Annotation.Classes in '..\..\annotations\Annotation.Classes.pas',
  Annotation.Controller.User in '..\..\annotations\Annotation.Controller.User.pas';

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

  THorse.GetInstance.Use(HorseSwagger);

  SwaggerConfig;
  THorseGBSwaggerRegister.RegisterPath(TUserController);

  THorse.Listen(9000);

end.
