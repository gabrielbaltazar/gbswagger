unit GBSwagger.Model.Config;

interface

uses
  GBSwagger.Model.Interfaces;

type
  TGBSwaggerModelConfig = class(TInterfacedObject, IGBSwaggerConfig)
  private
    [Weak]
    FParent: IGBSwagger;
    FModuleName: string;
    FHTMLTitle: string;
    FDateFormat: string;
    FLanguage: string;
    FResourcePath: string;
    FHTMLContentType: string;
    FDocExpansion: TGBSwaggerConfigureDocExpansion;
    FClassPrefixes: TArray<string>;
  protected
    function DateFormat(AValue: string): IGBSwaggerConfig; overload;
    function DateFormat: string; overload;

    function ClassPrefixes(AValue: string): IGBSwaggerConfig; overload;
    function ClassPrefixes: TArray<string>; overload;

    function ModuleName(AValue: string): IGBSwaggerConfig; overload;
    function ModuleName: string; overload;

    function Language(AValue: string): IGBSwaggerConfig; overload;
    function Language: string; overload;

    function ResourcePath(AValue: string): IGBSwaggerConfig; overload;
    function ResourcePath: string; overload;

    function DocExpansion(AValue: TGBSwaggerConfigureDocExpansion): IGBSwaggerConfig; overload;
    function DocExpansion: TGBSwaggerConfigureDocExpansion; overload;

    function HTMLContentType(AValue: string): IGBSwaggerConfig; overload;
    function HTMLContentType: string; overload;

    function &End: IGBSwagger;
  public
    class function New(AParent: IGBSwagger): IGBSwaggerConfig;
    constructor Create(AParent: IGBSwagger);
  end;

implementation

{ TGBSwaggerModelConfig }

function TGBSwaggerModelConfig.ClassPrefixes( AValue: string): IGBSwaggerConfig;
begin
  Result := Self;
  SetLength(FClassPrefixes, Length(FClassPrefixes) + 1);
  FClassPrefixes[ Length(FClassPrefixes) - 1] := AValue;
end;

function TGBSwaggerModelConfig.&End: IGBSwagger;
begin
  Result := FParent;
end;

function TGBSwaggerModelConfig.HTMLContentType(AValue: string): IGBSwaggerConfig;
begin
  Result := Self;
  FHTMLContentType := AValue;
end;

function TGBSwaggerModelConfig.HTMLContentType: string;
begin
  Result := FHTMLContentType;
end;

function TGBSwaggerModelConfig.Language: string;
begin
  Result := FLanguage;
end;

function TGBSwaggerModelConfig.Language(AValue: string): IGBSwaggerConfig;
begin
  Result := Self;
  FLanguage := AValue;
end;

function TGBSwaggerModelConfig.ModuleName: string;
begin
  Result := FModuleName;
end;

function TGBSwaggerModelConfig.ModuleName(AValue: string): IGBSwaggerConfig;
begin
  Result := Self;
  FModuleName := AValue;
end;

function TGBSwaggerModelConfig.ClassPrefixes: TArray<string>;
begin
  Result := FClassPrefixes;
  if Length(Result) = 0 then
    Result := ['T'];
end;

constructor TGBSwaggerModelConfig.Create(AParent: IGBSwagger);
begin
  FParent := AParent;
  FHTMLTitle := 'GBSwagger';
  FLanguage := 'en-US';
  FDocExpansion := TGBSwaggerConfigureDocExpansion.gbList;
  FResourcePath := 'https://petstore.swagger.io';
{$IF CompilerVersion <= 30.0}
  FHTMLContentType := 'text/html; charset=UTF-8';
{$ENDIF}
end;

function TGBSwaggerModelConfig.DateFormat: string;
begin
  Result := FDateFormat;
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

function TGBSwaggerModelConfig.DateFormat(AValue: string): IGBSwaggerConfig;
begin
  Result := Self;
  FDateFormat := AValue;
end;

class function TGBSwaggerModelConfig.New(AParent: IGBSwagger): IGBSwaggerConfig;
begin
  Result := Self.Create(AParent);
end;

function TGBSwaggerModelConfig.ResourcePath: string;
begin
  Result := FResourcePath;
end;

function TGBSwaggerModelConfig.ResourcePath(AValue: string): IGBSwaggerConfig;
begin
  Result := Self;
  FResourcePath := AValue;
end;

end.
