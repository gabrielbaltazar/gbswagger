unit FMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  PetStore.Models,
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.JSON.Interfaces,
  GBSwagger.Model.Types,
  System.TypInfo;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  // Base in DemoSwagger https://petstore.swagger.io/#/

  ReportMemoryLeaksOnShutdown := True;
  Swagger
    .Register
      .Response(200)
        .Description('Successful Operation')
      .&End
      .Response(201)
        .Description('Successful Operation')
      .&End
      .Response(400)
        .Description('Bad Request')
        .Schema(TAPIError)
      .&End
      .Response(404)
        .Description('Not Found')
        .Schema(TAPIError)
      .&End
    .&End
    .Host('petstore.swagger.io')
    .BasePath('v1')
    .AddConsumes(gbAppJSON).AddConsumes(gbAppXML)
    .AddProduces(gbAppJSON).AddProduces(gbAppXML)
    .AddBearerSecurity.&End
    .AddSecurity('Basica').&Type(gbBasic).&End
    .Info
      .Title('Swagger Petstore')
      .Description('This is a sample server Petstore server.')
      .Contact
        .Name('apiTeam')
        .Email('apiteam@swagger.io')
      .&End
    .&End
    .Path('pet/{petId}/uploadImage')
      .Tag('PET')
      .POST('uploads an image')
        .AddSecurity('Basica')
        .AddConsumes(gbMultiPartFormData)
        .AddParamPath('petId', 'ID of pet to update')
          .Required(True)
          .Schema(SWAG_STRING)
        .&End
        .AddParamFormData('additionalMetadata', 'Additional data to pass to server')
          .Required(False)
          .Schema(SWAG_STRING)
        .&End
        .AddParamFormData('file', 'file to upload')
          .Schema('file')
        .&End
        .AddResponse(200)
          .Schema(TApiResponse)
        .&End
      .&End
    .&End
    .Path('pet')
      .Tag('PET')
      .POST('Add a new pet to the store')
        .AddParamBody('body', 'Pet object that needs to be added to the store')
          .Required(True)
          .Schema(TPet)
        .&End
        .AddResponse(201)
          .Schema(TPet)
        .&End
        .AddResponse(405, 'Invalid input').&End
      .&End
      .PUT('Update a pet to the store')
        .Summary('Update an existing pet')
        .AddParamBody('body', 'Pet object that needs to be update to the store')
          .Required(True)
          .Schema(TPet)
        .&End
        .AddResponse(400).&End
        .AddResponse(404).&End
        .AddResponse(405, 'Validation exception').&End
      .&end
    .&End
    .Path('pet/findByStatus')
      .Tag('PET')
      .GET('Finds Pets by status')
        .Description('Multiple status values can be provided with comma separated strings')
        .AddParamQuery('status', 'Status values that need to be considered for filter')
          .EnumValues(['sAvailable', 'sPending', 'sSold'])
          .Schema(SWAG_STRING)
          .Required(True)
        .&End
        .AddResponse(200)
          .IsArray(True)
          .Schema(TPet)
        .&End
      .&End
    .&End
    .Path('pet/findByTags')
      .Tag('PET')
      .GET('Finds Pets by tags')
        .Description('Muliple tags can be provided with comma separated strings. Use tag1, tag2, tag3 for testing.')
        .AddParamQuery('tags', 'Tags to filter by')
          .Required(True)
          .IsArray(True)
          .Schema(SWAG_STRING)
        .&End
        .AddResponse(200)
          .Schema(TPet)
          .IsArray(True)
        .&End
        .AddResponse(400).&End
      .&End
    .&End
    .Path('pet/{petId}')
      .Tag('PET')
      .GET('/pet/{petId}')
        .AddSecurity('Bearer')
        .Description('Returns a single pet')
        .AddParamPath('petId', 'ID of pet to return')
          .Required(True)
          .Schema(SWAG_INTEGER)
        .&End
        .AddResponse(200)
          .Schema(TPet)
          .Header('X-Expires-After', 'date in UTC when token expires').&End
          .Header
            .Name('X-Rate-Limit')
            .Description('calls per hour allowed by the user')
            .&Type(SWAG_INTEGER)
          .&End
        .&End
        .AddResponse(400).&End
        .AddResponse(404).&End
      .&End
      .POST('Updates a pet in the store with form data')
        .AddConsumes(gbMultiPartFormData)
        .AddParamPath('petId', 'ID of pet that needs to be updated')
          .Required(True)
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
        .AddParamHeader('api_key')
          .Schema(SWAG_STRING)
        .&End
        .AddResponse(400).&End
        .AddResponse(404, 'Pet not found').&End
      .&End
    .&End
    .Path('user/login')
      .Tag('User')
      .GET('Logs user into the system')
        .AddParamQuery('username', 'The user name for login')
          .Required(True)
        .&End
        .AddParamQuery('password', 'The password for login in clear text')
          .Required(True)
        .&End
        .AddResponse(200)
          .Schema(SWAG_STRING)
          .Header('X-Expires-After', 'date in UTC when token expires').&End
          .Header('X-Rate-Limit', 'calls per hour allowed by the user')
            .&Type(SWAG_INTEGER)
          .&End
        .&End
      .&End
    .&End
    .AddModel(TOrder);

  Memo1.Lines.Text := SwaggerJSONString(Swagger);

end;

end.
