unit GBSwagger.JSON.V2.Security;

interface

uses
  GBSwagger.JSON.Interfaces,
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.Types,
  System.SysUtils,
  System.JSON;

type
  TGBSwaggerJSONV2Security = class(TInterfacedObject, IGBSwaggerModelJSON)
  private
    FSwaggerSecurity: IGBSwaggerSecurity;

    function JSONBasicAuth: TJSONObject;
    function JSONAPIKey: TJSONObject;
    function JSONOAuth: TJSONObject;
  public
    constructor Create(ASwaggerSecurity: IGBSwaggerSecurity);
    class function New(ASwaggerSecurity: IGBSwaggerSecurity): IGBSwaggerModelJSON;
    function ToJSON: TJSONValue;
  end;

implementation

{ TGBSwaggerJSONV2Security }

constructor TGBSwaggerJSONV2Security.Create(ASwaggerSecurity: IGBSwaggerSecurity);
begin
  FSwaggerSecurity := ASwaggerSecurity;
end;

function TGBSwaggerJSONV2Security.JSONAPIKey: TJSONObject;
begin
  Result := TJSONObject.Create
    .AddPair('type', FSwaggerSecurity.&Type.toString)
    .AddPair('name', FSwaggerSecurity.Name)
    .AddPair('in', FSwaggerSecurity.&In.toString);
end;

function TGBSwaggerJSONV2Security.JSONBasicAuth: TJSONObject;
begin
  Result := TJSONObject.Create
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

class function TGBSwaggerJSONV2Security.New(ASwaggerSecurity: IGBSwaggerSecurity): IGBSwaggerModelJSON;
begin
  Result := Self.Create(ASwaggerSecurity);
end;

function TGBSwaggerJSONV2Security.ToJSON: TJSONValue;
begin
  case FSwaggerSecurity.&Type of
    gbBasic : Result := JSONBasicAuth;
    gbApiKey: Result := JSONAPIKey;
    gbOAuth2: Result := JSONOAuth;
  else
    raise Exception.CreateFmt('Invalid Security Type', []);
  end;
end;

end.
