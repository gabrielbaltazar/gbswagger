unit GBSwagger.JSON.V2.Header;

interface

uses
  GBSwagger.JSON.Interfaces,
  GBSwagger.Model.Interfaces,
  System.SysUtils,
  System.StrUtils,
  System.JSON;

type TGBSwaggerJSONV2Header = class(TInterfacedObject, IGBSwaggerModelJSON)

  private
    FSwaggerHeader: IGBSwaggerHeader;

  public
    constructor create(SwaggerHeader: IGBSwaggerHeader);
    class function New(SwaggerHeader: IGBSwaggerHeader): IGBSwaggerModelJSON;

    function ToJSON: TJSONValue;
end;

implementation

{ TGBSwaggerJSONV2Header }

constructor TGBSwaggerJSONV2Header.create(SwaggerHeader: IGBSwaggerHeader);
begin
  FSwaggerHeader := SwaggerHeader;
end;

class function TGBSwaggerJSONV2Header.New(SwaggerHeader: IGBSwaggerHeader): IGBSwaggerModelJSON;
begin
  result := Self.create(SwaggerHeader);
end;

function TGBSwaggerJSONV2Header.ToJSON: TJSONValue;
begin
  result :=
    TJSONObject.Create
      .AddPair('type', FSwaggerHeader.&Type)
      .AddPair('format', FSwaggerHeader.Format)
      .AddPair('description', FSwaggerHeader.Description);

end;

end.
