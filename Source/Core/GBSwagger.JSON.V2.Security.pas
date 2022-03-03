unit GBSwagger.JSON.V2.Security;

interface

uses
  GBSwagger.JSON.Interfaces,
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.Types,
  System.SysUtils,
  System.JSON;

type TGBSwaggerJSONV2Security = class(TInterfacedObject, IGBSwaggerModelJSON)

  private
    FSwaggerSecurity: IGBSwaggerSecurity;

    function JSONBasicAuth: TJSONObject;
    function JSONAPIKey: TJSONObject;
    function JSONOAuth: TJSONObject;
  public
    constructor create(SwaggerSecurity: IGBSwaggerSecurity);
    class function New(SwaggerSecurity: IGBSwaggerSecurity): IGBSwaggerModelJSON;

    function ToJSON: TJSONValue;

end;

implementation

{ TGBSwaggerJSONV2Security }

constructor TGBSwaggerJSONV2Security.create(SwaggerSecurity: IGBSwaggerSecurity);
begin
  FSwaggerSecurity := SwaggerSecurity;
end;

function TGBSwaggerJSONV2Security.JSONAPIKey: TJSONObject;
begin
  result := TJSONObject.Create
                .AddPair('type', FSwaggerSecurity.&Type.toString)
                .AddPair('name', FSwaggerSecurity.Name)
                .AddPair('in', FSwaggerSecurity.&In.toString);
end;

function TGBSwaggerJSONV2Security.JSONBasicAuth: TJSONObject;
begin
  result := TJSONObject.Create
              .AddPair('type', FSwaggerSecurity.&Type.toString)
              .AddPair('name', FSwaggerSecurity.Name);
end;

function TGBSwaggerJSONV2Security.JSONOAuth: TJSONObject;
begin
  Result := TJSONObject.Create
              .AddPair('type', FSwaggerSecurity.&Type.toString)
              .AddPair('authorizationUrl', FSwaggerSecurity.AuthorizationURL)
              .AddPair('flow', FSwaggerSecurity.Flow.toString);
end;

class function TGBSwaggerJSONV2Security.New(SwaggerSecurity: IGBSwaggerSecurity): IGBSwaggerModelJSON;
begin
  result := Self.create(SwaggerSecurity);
end;

function TGBSwaggerJSONV2Security.ToJSON: TJSONValue;
begin
  case FSwaggerSecurity.&Type of
    gbBasic : result := JSONBasicAuth;
    gbApiKey: result := JSONAPIKey;
    gbOAuth2: result := JSONOAuth;
  else
    raise Exception.CreateFmt('Invalid Security Type', []);
  end;
end;

end.
