unit GBSwagger.JSON.V2.Header;

interface

uses
  GBSwagger.JSON.Interfaces,
  GBSwagger.Model.Interfaces,
  System.SysUtils,
  System.StrUtils,
  System.JSON;

type
  TGBSwaggerJSONV2Header = class(TInterfacedObject, IGBSwaggerModelJSON)
  private
    FSwaggerHeader: IGBSwaggerHeader;
  public
    constructor Create(ASwaggerHeader: IGBSwaggerHeader);
    class function New(ASwaggerHeader: IGBSwaggerHeader): IGBSwaggerModelJSON;

    function ToJSON: TJSONValue;
  end;

implementation

{ TGBSwaggerJSONV2Header }

constructor TGBSwaggerJSONV2Header.Create(ASwaggerHeader: IGBSwaggerHeader);
begin
  FSwaggerHeader := ASwaggerHeader;
end;

class function TGBSwaggerJSONV2Header.New(ASwaggerHeader: IGBSwaggerHeader): IGBSwaggerModelJSON;
begin
  Result := Self.Create(ASwaggerHeader);
end;

function TGBSwaggerJSONV2Header.ToJSON: TJSONValue;
begin
  Result := TJSONObject.Create
    .AddPair('type', FSwaggerHeader.&Type)
    .AddPair('format', FSwaggerHeader.Format)
    .AddPair('description', FSwaggerHeader.Description);
end;

end.
