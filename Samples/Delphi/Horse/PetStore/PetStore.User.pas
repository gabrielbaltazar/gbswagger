unit PetStore.User;

interface

uses
  Horse,
  Horse.GBSwagger,
  PetStore.Models;

procedure createWithArray (Req: THorseRequest; Resp: THorseResponse; Next: TProc);
procedure createWithList  (Req: THorseRequest; Resp: THorseResponse; Next: TProc);
procedure loadByUsername  (Req: THorseRequest; Resp: THorseResponse; Next: TProc);
procedure updateUser      (Req: THorseRequest; Resp: THorseResponse; Next: TProc);
procedure deleteUser      (Req: THorseRequest; Resp: THorseResponse; Next: TProc);
procedure login     (Req: THorseRequest; Resp: THorseResponse; Next: TProc);
procedure logout          (Req: THorseRequest; Resp: THorseResponse; Next: TProc);
procedure createUser      (Req: THorseRequest; Resp: THorseResponse; Next: TProc);

implementation

procedure createWithArray(Req: THorseRequest; Resp: THorseResponse; Next: TProc);
begin
end;

procedure createWithList(Req: THorseRequest; Resp: THorseResponse; Next: TProc);
begin
end;

procedure loadByUsername(Req: THorseRequest; Resp: THorseResponse; Next: TProc);
begin
end;

procedure updateUser(Req: THorseRequest; Resp: THorseResponse; Next: TProc);
begin
end;

procedure deleteUser(Req: THorseRequest; Resp: THorseResponse; Next: TProc);
begin
end;

procedure login(Req: THorseRequest; Resp: THorseResponse; Next: TProc);
begin
end;

procedure logout(Req: THorseRequest; Resp: THorseResponse; Next: TProc);
begin
end;

procedure createUser(Req: THorseRequest; Resp: THorseResponse; Next: TProc);
begin
end;

initialization
  Swagger
    .Path('/user/createWithArray')
      .Tag('User')
      .POST('Creates list of users with given input array')
        .AddParamBody('body', 'List of user object')
          .Schema(TUser)
          .IsArray(True)
        .&End
        .AddResponse(201, 'Created').&End
      .&End
    .&End
    .Path('/user/createWithList')
      .Tag('User')
      .POST('Creates list of users with given input array')
        .AddParamBody('body', 'List of user object')
          .Schema(TUser)
          .IsArray(True)
        .&End
        .AddResponse(201, 'Created').&End
      .&End
    .&End
    .Path('/user/{username}')
      .Tag('User')
      .GET('Get user by user name')
        .AddParamPath('username', 'The name that needs to be fetched. Use user1 for testing.')
          .Schema(SWAG_STRING)
        .&End
        .AddResponse(200, 'successful operation')
          .Schema(TUser)
        .&End
        .AddResponse(400, 'Invalid username supplied').&End
        .AddResponse(404, 'User not found').&End
      .&End
      .PUT('Update User', 'This can only be done by the logged in user.')
        .AddParamPath('username', 'name that need to be updated')
          .Schema(SWAG_STRING)
        .&End
        .AddParamBody('body', 'Updated user object')
          .Schema(TUser)
        .&End
        .AddResponse(400, 'Invalid user supplied').&End
        .AddResponse(404, 'User not found').&End
      .&End
      .DELETE('Delete user', 'This can only be done by the logged in user.')
        .AddParamPath('username', 'name that need to be deleted')
          .Schema(SWAG_STRING)
        .&End
        .AddResponse(400, 'Invalid user supplied').&End
        .AddResponse(404, 'User not found').&End
      .&End
    .&End
    .Path('user/login')
      .Tag('User')
      .GET('Logs user into the system')
        .AddParamQuery('username', 'The user name for login')
          .Required(True)
          .Schema(SWAG_STRING)
        .&End
        .AddParamQuery('password', 'The password for login in clear text')
          .Required(True)
          .Schema(SWAG_STRING)
        .&End
        .AddResponse(200, 'successful operation')
          .Schema(SWAG_STRING)
          .Header('X-Expires-After', 'date in UTC when token expires').&End
          .Header('X-Rate-Limit', 'calls per hour allowed by the user')
            .&Type(SWAG_INTEGER)
          .&End
        .&End
        .AddResponse(400, 'Invalid username/password supplied').&End
      .&End
    .&End
    .Path('user/logout')
      .Tag('User')
      .GET('Logs out current logged in user session')
        .AddResponse(200, 'successful operation').&End
      .&End
    .&End
    .Path('user')
      .Tag('User')
      .POST('Create user', 'This can only be done by the logged in user.')
        .AddParamBody('body', 'Created user object')
          .Schema(TUser)
        .&End
        .AddResponse(201, 'Created').&End;

end.
