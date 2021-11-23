unit GBSwagger.JSON.Interfaces;

interface

uses
  REST.Json,
  System.JSON,
  GBSwagger.Model.Interfaces;

type
  IGBSwaggerModelJSON = interface
    function ToJSON: TJSONValue;
  end;

function SwaggerJSON(ASwagger: IGBSwagger): TJSONValue;
function SwaggerJSONString(ASwagger: IGBSwagger): String;

implementation

uses
  GBSwagger.JSON.V2;

function SwaggerJSON(ASwagger: IGBSwagger): TJSONValue;
begin
  result := TGBSwaggerJSONV2.New(ASwagger)
              .ToJSON;
end;

function SwaggerJSONString(ASwagger: IGBSwagger): String;
var
  json: TJSONValue;
begin
  json := SwaggerJSON(ASwagger);
  try
    {$IF CompilerVersion > 32.0}
    Result := json.Format;
    {$ELSE}
    Result := TJson.Format(json);
    {$ENDIF}
  finally
    json.Free;
  end;
end;


end.
