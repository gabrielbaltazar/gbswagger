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


begin
  ReportMemoryLeaksOnShutdown := True;

  THorse.Use(HorseSwagger); // Access http://localhost:9000/swagger/doc/html

  // Swagger Document defined in PetStore.Order, PetStore.Pet, PetStore.User

  THorse.Get('pet/{petId}/uploadImage', procedure (Req: THorseRequest; Resp: THorseResponse; Next: TProc)begin end);
  THorse.Post('pet', procedure (Req: THorseRequest; Resp: THorseResponse; Next: TProc)begin end);

  THorse.Get('store/order', procedure (Req: THorseRequest; Resp: THorseResponse; Next: TProc)begin end);

  THorse.Listen(9000);

end.
