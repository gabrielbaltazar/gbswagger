program Console;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  Horse.BasicAuthentication,
  Horse.GBSwagger,
  System.SysUtils,
  Annotation.Classes in '..\..\annotations\Annotation.Classes.pas',
  Annotation.Controller.User in '..\..\annotations\Annotation.Controller.User.pas',
  GBSwagger.Validator.Messages.Interfaces in '..\..\..\..\Source\Validator\GBSwagger.Validator.Messages.Interfaces.pas',
  GBSwagger.Validator.Messages.Base in '..\..\..\..\Source\Validator\GBSwagger.Validator.Messages.Base.pas',
  GBSwagger.Validator.Messages.EnUS in '..\..\..\..\Source\Validator\GBSwagger.Validator.Messages.EnUS.pas',
  GBSwagger.Validator.Messages.PtBR in '..\..\..\..\Source\Validator\GBSwagger.Validator.Messages.PtBR.pas';

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
    .BasePath('v1')
    .AddBasicSecurity
      .AddCallback(
        HorseBasicAuthentication(function(const AUsername, APassword: string): Boolean
          begin
            result := AUsername = 'teste';
          end));
end;

begin
  ReportMemoryLeaksOnShutdown := True;

  THorse.GetInstance.Use(HorseSwagger);

  SwaggerConfig;
  THorseGBSwaggerRegister.RegisterPath(TUserController);

  THorse.Listen(9000);

end.
