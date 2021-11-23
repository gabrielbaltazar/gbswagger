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
  Web.HTTPD24Impl,
  Annotation.Classes in '..\Annotation.Classes.pas',
  Annotation.Controller.User in '..\Annotation.Controller.User.pas';

var
  ApacheModuleData: TApacheModuleData;

exports
  ApacheModuleData name 'apache_horse_module';

procedure SwaggerConfig;
begin
  Swagger
    .Config
      .ModuleName('apache_horse')
    .&End
    .Register
      .SchemaOnError(TAPIError)
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
    .BasePath('apache_horse/v1');
end;

begin

  THorse.DefaultModule := @ApacheModuleData;
  THorse.HandlerName := 'apache_horse_module-handle';

  THorse.Use(HorseSwagger);

  SwaggerConfig;
  THorseGBSwaggerRegister.RegisterPath(TUserController);

  THorse.Listen;

end.
