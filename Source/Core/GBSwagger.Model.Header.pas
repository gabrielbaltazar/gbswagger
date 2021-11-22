unit GBSwagger.Model.Header;

interface

uses
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.Types;

type TGBSwaggerModelHeader = class(TInterfacedObject, IGBSwaggerHeader)

  private
    [Weak]
    FParent: IGBSwaggerPathResponse;
    FName: string;
    FDescription: string;
    FType: string;
    FFormat: string;

  protected
    function Name: String; overload;
    function Description: String; overload;
    function &Type: String; overload;
    function Format: string; overload;

    function Name(Value: String): IGBSwaggerHeader; overload;
    function Description(Value: String): IGBSwaggerHeader; overload;
    function &Type(Value: String): IGBSwaggerHeader; overload;
    function Format(Value: String): IGBSwaggerHeader; overload;

    function &End: IGBSwaggerPathResponse;

  public
    constructor create(Parent: IGBSwaggerPathResponse);
    class function New(Parent: IGBSwaggerPathResponse): IGBSwaggerHeader;
    destructor Destroy; override;

end;

implementation

{ TGBSwaggerModelHeader }

constructor TGBSwaggerModelHeader.create(Parent: IGBSwaggerPathResponse);
begin
  FParent := Parent;
  FType   := SWAG_STRING;
end;

function TGBSwaggerModelHeader.Description(Value: String): IGBSwaggerHeader;
begin
  result := Self;
  FDescription := Value;
end;

function TGBSwaggerModelHeader.Description: String;
begin
  result := FDescription;
end;

destructor TGBSwaggerModelHeader.Destroy;
begin

  inherited;
end;

function TGBSwaggerModelHeader.&End: IGBSwaggerPathResponse;
begin
  result := FParent;
end;

function TGBSwaggerModelHeader.Format(Value: String): IGBSwaggerHeader;
begin
  result := Self;
  FFormat := Value;
end;

function TGBSwaggerModelHeader.Format: string;
begin
  result := FFormat;
end;

function TGBSwaggerModelHeader.Name(Value: String): IGBSwaggerHeader;
begin
  result := Self;
  FName  := Value;
end;

function TGBSwaggerModelHeader.Name: String;
begin
  result := FName;
end;

class function TGBSwaggerModelHeader.New(Parent: IGBSwaggerPathResponse): IGBSwaggerHeader;
begin
  Result := Self.create(Parent);
end;

function TGBSwaggerModelHeader.&Type: String;
begin
  result := FType;
end;

function TGBSwaggerModelHeader.&Type(Value: String): IGBSwaggerHeader;
begin
  result := Self;
  FType  := Value;
end;

end.
