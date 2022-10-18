unit Horse.GBSwagger.Controller;

interface

uses
  Horse;

type
  THorseGBSwagger = class
  protected
    FRequest: THorseRequest;
    FResponse: THorseResponse;
  public
    constructor Create(Req: THorseRequest; Res: THorseResponse);
end;

implementation

{ THorseGBSwagger }

constructor THorseGBSwagger.Create(Req: THorseRequest; Res: THorseResponse);
begin
  FRequest := Req;
  FResponse := Res;
end;

end.
