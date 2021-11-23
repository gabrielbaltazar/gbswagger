unit GBSwagger.JSON.V2.Contact;

interface

uses
  GBSwagger.JSON.Interfaces,
  GBSwagger.Model.Interfaces,
  GBSwagger.Types,
  System.JSON;

type TGBSwaggerJSONV2Contact = class(TInterfacedObject, IGBSwaggerModelJSON)

  private
    FSwaggerContact: IGBSwaggerContact;

  public
    constructor create(SwaggerContact: IGBSwaggerContact);
    class function New(SwaggerContact: IGBSwaggerContact): IGBSwaggerModelJSON;

    function ToJSON: TJSONValue;
end;

implementation

{ TGBSwaggerJSONV2Contact }

constructor TGBSwaggerJSONV2Contact.create(SwaggerContact: IGBSwaggerContact);
begin
  FSwaggerContact := SwaggerContact;
end;

class function TGBSwaggerJSONV2Contact.New(SwaggerContact: IGBSwaggerContact): IGBSwaggerModelJSON;
begin
  result := Self.create(SwaggerContact);
end;

function TGBSwaggerJSONV2Contact.ToJSON: TJSONValue;
begin
  Result := TJSONObject.Create
              .AddPair('name', FSwaggerContact.Name)
              .AddPair('email', FSwaggerContact.Email)
              .AddPair('url', FSwaggerContact.URL);
end;

end.
