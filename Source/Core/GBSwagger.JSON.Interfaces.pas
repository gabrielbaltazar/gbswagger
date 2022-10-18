unit GBSwagger.JSON.Interfaces;

interface

uses
  REST.Json,
  System.JSON,
  GBSwagger.Model.Interfaces;

type
  IGBSwaggerModelJSON = interface
    ['{ADE6FCAC-D20E-4C53-A0A2-1E42D6B8C481}']
    function ToJSON: TJSONValue;
  end;

function SwaggerJSON(ASwagger: IGBSwagger): TJSONValue;
function SwaggerJSONString(ASwagger: IGBSwagger): string;

implementation

uses
  GBSwagger.JSON.V2;

function SwaggerJSON(ASwagger: IGBSwagger): TJSONValue;
begin
  Result := TGBSwaggerJSONV2.New(ASwagger)
    .ToJSON;
end;

function SwaggerJSONString(ASwagger: IGBSwagger): string;
var
  LJson: TJSONValue;
begin
  LJson := SwaggerJSON(ASwagger);
  try
    {$IF CompilerVersion > 32.0}
    Result := LJson.Format;
    {$ELSE}
    Result := TJson.Format(LJson);
    {$ENDIF}
  finally
    LJson.Free;
  end;
end;

end.
