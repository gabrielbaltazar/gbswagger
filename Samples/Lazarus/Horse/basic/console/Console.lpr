program Console;

{$mode delphi}

uses
  Horse, SysUtils, TypInfo, Rtti, Classes,
  Horse.GBSwagger;

procedure GetPing(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
begin
  Res.Send('Pong');
end;

procedure OnListen(Horse: THorse);
begin
  Writeln(Format('Server is runing on %s:%d', [Horse.Host, Horse.Port]));
end;

begin
  THorse.Get('/ping', GetPing);

  THorse.Listen(9000, OnListen);
end.
