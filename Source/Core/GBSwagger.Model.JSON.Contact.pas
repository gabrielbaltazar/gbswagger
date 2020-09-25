unit GBSwagger.Model.JSON.Contact;

interface

uses
  GBSwagger.Model.JSON.Interfaces,
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.Types,
  System.JSON;

type TGBSwaggerModelJSONContact = class(TInterfacedObject, IGBSwaggerModelJSON)

  private
    FSwaggerContact: IGBSwaggerContact;

  public
    constructor create(SwaggerContact: IGBSwaggerContact);
    class function New(SwaggerContact: IGBSwaggerContact): IGBSwaggerModelJSON;

    function ToJSON: TJSONValue;
end;

implementation

{ TGBSwaggerModelJSONContact }

constructor TGBSwaggerModelJSONContact.create(SwaggerContact: IGBSwaggerContact);
begin
  FSwaggerContact := SwaggerContact;
end;

class function TGBSwaggerModelJSONContact.New(SwaggerContact: IGBSwaggerContact): IGBSwaggerModelJSON;
begin
  result := Self.create(SwaggerContact);
end;

function TGBSwaggerModelJSONContact.ToJSON: TJSONValue;
begin
  Result := TJSONObject.Create
              .AddPair('name', FSwaggerContact.Name)
              .AddPair('email', FSwaggerContact.Email)
              .AddPair('url', FSwaggerContact.URL);
end;

end.
