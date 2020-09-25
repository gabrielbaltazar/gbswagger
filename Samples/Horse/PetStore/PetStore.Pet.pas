unit PetStore.Pet;

interface

uses
  Horse,
  Horse.GBSwagger,
  PetStore.Models;

procedure uploadImage  (Req: THorseRequest; Resp: THorseResponse; Next: TProc);
procedure addPet       (Req: THorseRequest; Resp: THorseResponse; Next: TProc);
procedure updatePet    (Req: THorseRequest; Resp: THorseResponse; Next: TProc);
procedure findByStatus (Req: THorseRequest; Resp: THorseResponse; Next: TProc);
procedure findById     (Req: THorseRequest; Resp: THorseResponse; Next: TProc);
procedure postFormData (Req: THorseRequest; Resp: THorseResponse; Next: TProc);
procedure deletePet    (Req: THorseRequest; Resp: THorseResponse; Next: TProc);

implementation

procedure uploadImage(Req: THorseRequest; Resp: THorseResponse; Next: TProc);
begin
end;

procedure addPet(Req: THorseRequest; Resp: THorseResponse; Next: TProc);
begin
end;

procedure updatePet(Req: THorseRequest; Resp: THorseResponse; Next: TProc);
begin
end;

procedure findByStatus(Req: THorseRequest; Resp: THorseResponse; Next: TProc);
begin
end;

procedure findById(Req: THorseRequest; Resp: THorseResponse; Next: TProc);
begin
end;

procedure postFormData(Req: THorseRequest; Resp: THorseResponse; Next: TProc);
begin
end;

procedure deletePet(Req: THorseRequest; Resp: THorseResponse; Next: TProc);
begin
end;

initialization
  Swagger
    .BasePath('v1')
    .Register
      .Response(204).Description('No Content').&End
      .Response(400).Description('Bad Request').Schema(TApiError).&End
      .Response(404).Description('Not Found').Schema(TApiError).&End
      .Response(500).Description('Internal Server Error').Schema(TApiError).&End
    .&End
    .Info
      .Title('Swagger Petstore')
      .Contact
        .Name('contactName')
        .Email('contact@email.com')
      .&End
    .&End
  .&End;


  Swagger
    .Path('/pet/{petId}/uploadImage')
      .Tag('Pet')
      .POST('uploads an image')
        .AddConsumes(TGBSwaggerContentType.gbMultiPartFormData)
        .AddParamPath('petId', 'ID of pet to update').&End
        .AddParamFormData('additionalMetadata', 'Additional data to pass to server')
          .Required(False)
          .Schema(SWAG_STRING)
        .&End
        .AddParamFormData('file', 'file to upload')
          .Schema('file')
        .&End
        .AddResponse(200, 'successful operation')
          .Schema(TApiError)
        .&End
        .AddResponse(400).&End
        .AddResponse(404).&End
        .AddResponse(500).&End
      .&End
    .&End
    .Path('pet')
      .Tag('Pet')
      .POST('Add a new pet to the store')
        .AddParamBody('body', 'Pet object that needs to be added to the store')
          .Schema(TPet)
        .&End
        .AddResponse(201, 'successful operation')
          .Schema(TPet)
        .&End
        .AddResponse(405, 'Invalid input').&End
        .AddResponse(400).&End
        .AddResponse(404).&End
        .AddResponse(500).&End
      .&End
      .PUT('Update a pet to the store')
        .Summary('Update an existing pet')
        .AddParamBody('body', 'Pet object that needs to be update to the store')
          .Schema(TPet)
        .&End
        .AddResponse(400).&End
        .AddResponse(404).&End
        .AddResponse(405, 'Validation exception').&End
        .AddResponse(500).&End
      .&end
    .&End
    .Path('pet/findByStatus')
      .Tag('Pet')
      .GET('Finds Pets by status')
        .Description('Multiple status values can be provided with comma separated strings')
        .AddParamQuery('status', 'Status values that need to be considered for filter')
          .EnumValues(['sAvailable', 'sPending', 'sSold'])
          .Schema(SWAG_STRING)
          .Required(True)
        .&End
        .AddResponse(200, 'successful operation')
          .IsArray(True)
          .Schema(TPet)
        .&End
      .&End
    .&End
    .Path('pet/findByTags')
      .Tag('Pet')
      .GET('Finds Pets by tags')
        .Description('Muliple tags can be provided with comma separated strings. Use tag1, tag2, tag3 for testing.')
        .AddParamQuery('tags', 'Tags to filter by')
          .IsArray(True)
        .&End
        .AddResponse(200, 'successful operation')
          .Schema(TPet)
          .IsArray(True)
        .&End
        .AddResponse(400).&End
        .AddResponse(404).&End
        .AddResponse(500).&End
      .&End
    .&End
    .Path('pet/{petId}')
      .Tag('Pet')
      .GET('Find pet by ID', 'Returns a single pet')
        .AddParamPath('petId', 'ID of pet to return')
          .Schema(SWAG_INTEGER)
        .&End
        .AddResponse(200)
          .Description('successful operation')
          .Schema(TPet)
        .&End
        .AddResponse(400).&End
        .AddResponse(404).&End
        .AddResponse(500).&End
      .&End
      .POST('Updates a pet in the store with form data')
        .AddConsumes(TGBSwaggerContentType.gbMultiPartFormData)
        .AddParamPath('petId', 'ID of pet that needs to be updated')
          .Schema(SWAG_INTEGER)
        .&End
        .AddParamFormData('name', 'Updated name of the pet')
          .Schema(SWAG_STRING)
        .&End
        .AddParamFormData('status', 'Updated status of the pet')
          .Schema(SWAG_STRING)
        .&End
        .AddResponse(405, 'Invalid Input').&End
      .&End
      .DELETE('Deletes a pet')
        .AddParamPath('petId', 'Pet id to delete')
          .Required(True)
          .Schema(SWAG_INTEGER)
        .&End
        .AddParamHeader('api_key').&End
        .AddResponse(400, 'Invalid ID supplied').&End
        .AddResponse(404, 'Pet not found').&End
      .&End
    .&End;

end.
