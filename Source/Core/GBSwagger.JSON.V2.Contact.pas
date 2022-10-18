unit GBSwagger.JSON.V2.Contact;

interface

uses
  GBSwagger.JSON.Interfaces,
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.Types,
  System.JSON;

type
  TGBSwaggerJSONV2Contact = class(TInterfacedObject, IGBSwaggerModelJSON)
  private
    FSwaggerContact: IGBSwaggerContact;
  public
    constructor Create(ASwaggerContact: IGBSwaggerContact);
    class function New(ASwaggerContact: IGBSwaggerContact): IGBSwaggerModelJSON;

    function ToJSON: TJSONValue;
  end;

implementation

{ TGBSwaggerJSONV2Contact }

constructor TGBSwaggerJSONV2Contact.Create(ASwaggerContact: IGBSwaggerContact);
begin
  FSwaggerContact := ASwaggerContact;
end;

class function TGBSwaggerJSONV2Contact.New(ASwaggerContact: IGBSwaggerContact): IGBSwaggerModelJSON;
begin
  Result := Self.Create(ASwaggerContact);
end;

function TGBSwaggerJSONV2Contact.ToJSON: TJSONValue;
begin
  Result := TJSONObject.Create
    .AddPair('name', FSwaggerContact.Name)
    .AddPair('email', FSwaggerContact.Email)
    .AddPair('url', FSwaggerContact.URL);
end;

end.
