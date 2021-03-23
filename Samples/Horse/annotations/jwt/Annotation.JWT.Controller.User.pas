unit Annotation.JWT.Controller.User;

interface

uses
  Horse,
  GBSwagger.Path.Attributes,
  Annotation.JWT.Classes,
  System.JSON;

type
  [SwagPath('company/{companyId}/user', 'Users')]
  [SwagParamPath('companyId', 'Company Id')]
  [SwagParamHeader('TestHeader', 'Header Default')]
  [SwagParamQuery('TestQuery', 'Query Default')]
  TUserController = class
  private
    FRequest: THorseRequest;
    FResponse: THorseResponse;

  public
    [SwagGET('List Users', True)]
    [SwagParamQuery('id', 'user id')]
    [SwagResponse(200, TUser, 'Users data', True)]
    procedure GetUsers;

    [SwagGET('{id}', 'Find User')]
    [SwagParamPath('id', 'user id')]
    [SwagResponse(200, TUser, 'User data')]
    [SwagResponse(404)]
    procedure FindUser;

    [SwagPOST('Insert a new user')]
    [SwagParamBody('UserData', TUser)]
    [SwagResponse(201, TUser)]
    [SwagResponse(400)]
    procedure InsertUser;

    [SwagPUT('{id}', 'Update user')]
    [SwagParamPath('id', 'user id')]
    [SwagParamBody('User Data', TUser)]
    [SwagResponse(204)]
    [SwagResponse(400)]
    [SwagResponse(404)]
    procedure UpdateUser;

    [SwagDELETE('{id}', 'Delete user')]
    [SwagParamPath('id', 'user id')]
    [SwagResponse(204)]
    [SwagResponse(400)]
    [SwagResponse(404)]
    procedure DeleteUser;

    constructor create(Req: THorseRequest; Res: THorseResponse);
    destructor Destroy; override;
end;

implementation

{ TUserController }

constructor TUserController.create(Req: THorseRequest; Res: THorseResponse);
begin
  FRequest := Req;
  FResponse:= Res;
end;

procedure TUserController.DeleteUser;
begin
  FResponse.Status(204);
end;

destructor TUserController.Destroy;
begin

  inherited;
end;

procedure TUserController.UpdateUser;
begin
  FResponse.Status(204);
end;

procedure TUserController.FindUser;
begin
  FResponse.Send('{"id": 1, "name": "user 1"}');
end;

procedure TUserController.GetUsers;
begin
  FResponse.Send('[{"id": 1, "name": "user 1"}]');
end;

procedure TUserController.InsertUser;
begin
  FResponse.Send(FRequest.Body).Status(201);
end;

end.
