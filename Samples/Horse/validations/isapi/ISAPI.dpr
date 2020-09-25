library ISAPI;

{$R *.res}

uses
  Horse,
  Horse.GBSwagger,
  Validation.Classes in '..\Validation.Classes.pas',
  Validation.Controller.User in '..\Validation.Controller.User.pas';

procedure SwaggerConfig;
begin
  Swagger
    .Config
      .ModuleName('api/ISAPI.dll')
    .&End
    .Register
      .SchemaOnError(TAPIError)
    .&End
    .Info
      .Title('Horse ISAPI Sample')
      .Description('API Horse')
      .Contact
        .Name('Contact Name')
        .Email('contact@email.com.br')
        .URL('http://www.mypage.com.br')
      .&End
    .&End
    .BasePath('api/ISAPI.dll');
end;

begin
  THorse.GetInstance.Use(HorseSwagger);

  SwaggerConfig;
  THorseGBSwaggerRegister.RegisterPath(TUserController);

  THorse.Listen;

end.
