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
    FClassPrefixes: TArray<String>;

  protected
    function DateFormat(Value: String): IGBSwaggerConfig; overload;
    function ClassPrefixes(Value: String): IGBSwaggerConfig; overload;
    function ModuleName(Value: String): IGBSwaggerConfig; overload;

    function DateFormat: string; overload;
    function ClassPrefixes: TArray<String>; overload;
    function ModuleName: String; overload;

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
end;

function TGBSwaggerModelConfig.DateFormat: string;
begin
  result := FDateFormat;
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

end.
