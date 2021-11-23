unit PetStore.Order;

interface

uses
  Horse,
  Horse.GBSwagger,
  PetStore.Models;

procedure addOrder    (Req: THorseRequest; Resp: THorseResponse; Next: TProc);
procedure findOrder   (Req: THorseRequest; Resp: THorseResponse; Next: TProc);
procedure deleteOrder (Req: THorseRequest; Resp: THorseResponse; Next: TProc);
procedure inventory    (Req: THorseRequest; Resp: THorseResponse; Next: TProc);

implementation

procedure addOrder(Req: THorseRequest; Resp: THorseResponse; Next: TProc);
begin
end;

procedure findOrder(Req: THorseRequest; Resp: THorseResponse; Next: TProc);
begin
end;

procedure deleteOrder(Req: THorseRequest; Resp: THorseResponse; Next: TProc);
begin
end;

procedure inventory(Req: THorseRequest; Resp: THorseResponse; Next: TProc);
begin
end;

initialization
  Swagger
    .Path('store/order')
      .Tag('Store')
      .POST('Place an order for a Pet')
        .AddParamBody('order', 'order placed for purchasing the pet')
          .Schema(TOrder)
        .&End
        .AddResponse(200, 'successful operation')
          .Schema(TOrder)
        .&End
        .AddResponse(400).&End
      .&End
    .&End
    .Path('store/order/{orderId}')
      .Tag('Store')
      .GET('Find purchase order by ID')
        .Description('For valid response try integer IDs with value >= 1 and <= 10. Other values will generated exceptions')
        .AddParamPath('orderId', 'ID of pet that needs to be fetched')
          .Schema(SWAG_INTEGER)
        .&End
        .AddResponse(200, 'successful operation')
          .Schema(TOrder)
        .&End
        .AddResponse(400).&End
        .AddResponse(404).&End
      .&End
      .DELETE('Delete purchase order by ID', 'For valid response try integer IDs with positive integer value. Negative or non-integer values will generate API errors')
        .AddParamPath('orderId', 'ID of pet that needs to be deleted')
          .Schema(SWAG_INTEGER)
        .&End
        .AddResponse(400).&End
        .AddResponse(404).&End
      .&End
    .&End;

end.
