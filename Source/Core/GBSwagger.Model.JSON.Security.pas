unit GBSwagger.Model.JSON.Security;

interface

uses
  GBSwagger.Model.JSON.Interfaces,
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.Types,
  System.SysUtils,
  System.JSON;

type TGBSwaggerModelJSONSecurity = class(TInterfacedObject, IGBSwaggerModelJSON)

  private
    FSwaggerSecurity: IGBSwaggerSecurity;

    function JSONBasicAuth: TJSONObject;
    function JSONAPIKey   : TJSONObject;
    function JSONOAuth    : TJSONObject;
  public
    constructor create(SwaggerSecurity: IGBSwaggerSecurity);
    class function New(SwaggerSecurity: IGBSwaggerSecurity): IGBSwaggerModelJSON;

    function ToJSON: TJSONValue;

end;

implementation

{ TGBSwaggerModelJSONSecurity }

constructor TGBSwaggerModelJSONSecurity.create(SwaggerSecurity: IGBSwaggerSecurity);
begin
  FSwaggerSecurity := SwaggerSecurity;
end;

function TGBSwaggerModelJSONSecurity.JSONAPIKey: TJSONObject;
begin
  result := TJSONObject.Create
                .AddPair('type', FSwaggerSecurity.&Type.toString)
                .AddPair('name', FSwaggerSecurity.Name)
                .AddPair('in', FSwaggerSecurity.&In.toString);
end;

function TGBSwaggerModelJSONSecurity.JSONBasicAuth: TJSONObject;
begin
  result := TJSONObject.Create
              .AddPair('type', FSwaggerSecurity.&Type.toString)
              .AddPair('name', FSwaggerSecurity.Name);
end;

function TGBSwaggerModelJSONSecurity.JSONOAuth: TJSONObject;
begin
  Result := TJSONObject.Create
              .AddPair('type', FSwaggerSecurity.&Type.toString)
              .AddPair('authorizationUrl', FSwaggerSecurity.AuthorizationURL)
              .AddPair('flow', FSwaggerSecurity.Flow.toString);
end;

class function TGBSwaggerModelJSONSecurity.New(SwaggerSecurity: IGBSwaggerSecurity): IGBSwaggerModelJSON;
begin
  result := Self.create(SwaggerSecurity);
end;

function TGBSwaggerModelJSONSecurity.ToJSON: TJSONValue;
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
