unit GBSwagger.Model.Config;

interface

uses
  GBSwagger.Model.Interfaces;

type TGBSwaggerModelConfig = class(TInterfacedObject, IGBSwaggerConfig)

  private
    [Weak]
    FParent: IGBSwagger;
    FModuleName: string;
    FHTMLTitle: string;
    FDateFormat: string;
    FLanguage: String;
    FResourcePath: String;
    FDocExpansion: TGBSwaggerConfigureDocExpansion;
    FClassPrefixes: TArray<String>;

  protected
    function DateFormat(Value: String): IGBSwaggerConfig; overload;
    function DateFormat: string; overload;

    function ClassPrefixes(Value: String): IGBSwaggerConfig; overload;
    function ClassPrefixes: TArray<String>; overload;

    function ModuleName(Value: String): IGBSwaggerConfig; overload;
    function ModuleName: String; overload;

    function Language(Value: String): IGBSwaggerConfig; overload;
    function Language: String; overload;

    function ResourcePath(AValue: string): IGBSwaggerConfig; overload;
    function ResourcePath: string; overload;

    function DocExpansion(AValue: TGBSwaggerConfigureDocExpansion): IGBSwaggerConfig; overload;
    function DocExpansion: TGBSwaggerConfigureDocExpansion; overload;

    function &End: IGBSwagger;
  public
    class function New(Parent: IGBSwagger): IGBSwaggerConfig;
    constructor create(Parent: IGBSwagger);
end;

implementation

{ TGBSwaggerModelConfig }

function TGBSwaggerModelConfig.ClassPrefixes( Value: String): IGBSwaggerConfig;
begin
  result := Self;

  SetLength(FClassPrefixes, Length(FClassPrefixes) + 1);
  FClassPrefixes[ Length(FClassPrefixes) - 1] := Value;
end;

function TGBSwaggerModelConfig.&End: IGBSwagger;
begin
  result := FParent;
end;

function TGBSwaggerModelConfig.Language: String;
begin
  result := FLanguage;
end;

function TGBSwaggerModelConfig.Language(Value: String): IGBSwaggerConfig;
begin
  result := Self;
  FLanguage := Value;
end;

function TGBSwaggerModelConfig.ModuleName: String;
begin
  result := FModuleName;
end;

function TGBSwaggerModelConfig.ModuleName(Value: String): IGBSwaggerConfig;
begin
  result := Self;
  FModuleName := Value;
end;

function TGBSwaggerModelConfig.ClassPrefixes: TArray<String>;
begin
  result := FClassPrefixes;
  if Length(result) = 0 then
    result := ['T'];
end;

constructor TGBSwaggerModelConfig.create(Parent: IGBSwagger);
begin
  FParent := Parent;
  FHTMLTitle := 'GBSwagger';
  FLanguage := 'en-US';
  FDocExpansion := TGBSwaggerConfigureDocExpansion.gbList;
  FResourcePath := 'https://petstore.swagger.io';
end;

function TGBSwaggerModelConfig.DateFormat: string;
begin
  result := FDateFormat;
end;

function TGBSwaggerModelConfig.DocExpansion: TGBSwaggerConfigureDocExpansion;
begin
  Result := FDocExpansion;
end;

function TGBSwaggerModelConfig.DocExpansion(AValue: TGBSwaggerConfigureDocExpansion): IGBSwaggerConfig;
begin
  Result := Self;
  FDocExpansion := AValue;
end;

function TGBSwaggerModelConfig.DateFormat(Value: String): IGBSwaggerConfig;
begin
  result := Self;
  FDateFormat := Value;
end;

class function TGBSwaggerModelConfig.New(Parent: IGBSwagger): IGBSwaggerConfig;
begin
  result := Self.create(Parent);
end;

function TGBSwaggerModelConfig.ResourcePath: string;
begin
  result := FResourcePath;
end;

function TGBSwaggerModelConfig.ResourcePath(AValue: string): IGBSwaggerConfig;
begin
  result := Self;
  FResourcePath := AValue;
end;

end.
