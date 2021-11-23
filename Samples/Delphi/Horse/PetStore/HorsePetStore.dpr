program HorsePetStore;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  Horse.GBSwagger,
  PetStore.Models in 'PetStore.Models.pas',
  PetStore.Pet in 'PetStore.Pet.pas',
  PetStore.Order in 'PetStore.Order.pas',
  PetStore.User in 'PetStore.User.pas';

var
  API: THorse;

begin
  ReportMemoryLeaksOnShutdown := True;
  API := THorse.Create(9000);

  API.Use(HorseSwagger); // Access http://localhost:9000/swagger/doc/html

  // Swagger Document defined in PetStore.Order, PetStore.Pet, PetStore.User

  API.Get('pet/{petId}/uploadImage', procedure (Req: THorseRequest; Resp: THorseResponse; Next: TProc)begin end);
  API.Post('pet', procedure (Req: THorseRequest; Resp: THorseResponse; Next: TProc)begin end);

  API.Get('store/order', procedure (Req: THorseRequest; Resp: THorseResponse; Next: TProc)begin end);

  API.Start;

end.
