unit GBSwagger.Model.JSON.Header;

interface

uses
  GBSwagger.Model.JSON.Interfaces,
  GBSwagger.Model.Interfaces,
  System.SysUtils,
  System.StrUtils,
  System.JSON;

type TGBSwaggerModelJSONHeader = class(TInterfacedObject, IGBSwaggerModelJSON)

  private
    FSwaggerHeader: IGBSwaggerHeader;

  public
    constructor create(SwaggerHeader: IGBSwaggerHeader);
    class function New(SwaggerHeader: IGBSwaggerHeader): IGBSwaggerModelJSON;

    function ToJSON: TJSONValue;
end;

implementation

{ TGBSwaggerModelJSONHeader }

constructor TGBSwaggerModelJSONHeader.create(SwaggerHeader: IGBSwaggerHeader);
begin
  FSwaggerHeader := SwaggerHeader;
end;

class function TGBSwaggerModelJSONHeader.New(SwaggerHeader: IGBSwaggerHeader): IGBSwaggerModelJSON;
begin
  result := Self.create(SwaggerHeader);
end;

function TGBSwaggerModelJSONHeader.ToJSON: TJSONValue;
begin
  result :=
    TJSONObject.Create
      .AddPair('type', FSwaggerHeader.&Type)
      .AddPair('format', FSwaggerHeader.Format)
      .AddPair('description', FSwaggerHeader.Description);

end;

end.
