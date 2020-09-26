unit ServerMethodsUnit1;

interface

uses
  Web.HTTPApp, Datasnap.DSHTTPWebBroker,
  System.SysUtils, System.Classes, System.Json,
  Datasnap.DSServer, Datasnap.DSAuth,
  Datasnap.Classes,
  Datasnap.GBSwagger,
  GBSwagger.Validator.Interfaces;

type
{$METHODINFO ON}
  [SwagPath('TServerMethods1/usuario', 'Usuarios')]
  TServerMethods1 = class(TDataModule)
  public
    [SwagGET('{id}', 'Consulta Usuario')]
    [SwagParamPath('id', 'id do Usuario')]
    [SwagResponse(200, TUser, 'Dados do Usuario')]
    [SwagResponse(400)]
    [SwagResponse(404)]
    function swagUsuario: TJSONValue; virtual; abstract;

    [SwagGET('Lista Usuarios')]
    [SwagResponse(200, TUser, 'Lista de Usuarios', True)]
    [SwagResponse(400)]
    function usuario: TJSONValue;

    [SwagPOST('Insere um usuario')]
    [SwagParamBody('usuario', TUser, '')]
    [SwagResponse(201, TUser, 'Created')]
    [SwagResponse(400)]
    [SwagResponse(500)]
    function updateUsuario: TJSONValue;

    [SwagPUT('{id}', 'Altera Usuario')]
    [SwagParamPath('id', 'id do usuario')]
    [SwagParamBody('usuario', TUser, '')]
    [SwagResponse(204)]
    [SwagResponse(400)]
    [SwagResponse(500)]
    function acceptUsuario(IdUsuario: Integer): TJSONValue;

    [SwagDELETE('{id}', 'Excluir Usuario')]
    [SwagParamPath('id', 'id do usuario')]
    [SwagResponse(204)]
    [SwagResponse(400)]
    [SwagResponse(500)]
    function cancelUsuario: TJSONValue;

  end;
{$METHODINFO OFF}

implementation

{$R *.dfm}

{ TServerMethods1 }

function TServerMethods1.acceptUsuario(IdUsuario: Integer): TJSONValue;
begin

end;

function TServerMethods1.cancelUsuario: TJSONValue;
begin

end;

function TServerMethods1.updateUsuario: TJSONValue;
var
  user : TUser;
begin
  user := TUser.Create;
  SwaggerValidator.validate(user);
end;

function TServerMethods1.usuario: TJSONValue;
begin

end;

initialization
  TGBSwaggerPathRegister.RegisterPath(TServerMethods1);

end.

