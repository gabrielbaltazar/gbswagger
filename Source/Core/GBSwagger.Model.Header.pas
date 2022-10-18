unit GBSwagger.Model.Header;

interface

uses
  GBSwagger.Model.Interfaces,
  GBSwagger.Model.Types;

type
  TGBSwaggerModelHeader = class(TInterfacedObject, IGBSwaggerHeader)
  private
    [Weak]
    FParent: IGBSwaggerPathResponse;
    FName: string;
    FDescription: string;
    FType: string;
    FFormat: string;
  protected
    function Name: string; overload;
    function Description: string; overload;
    function &Type: string; overload;
    function Format: string; overload;

    function Name(AValue: string): IGBSwaggerHeader; overload;
    function Description(AValue: string): IGBSwaggerHeader; overload;
    function &Type(AValue: string): IGBSwaggerHeader; overload;
    function Format(AValue: string): IGBSwaggerHeader; overload;

    function &End: IGBSwaggerPathResponse;
  public
    constructor Create(AParent: IGBSwaggerPathResponse);
    class function New(AParent: IGBSwaggerPathResponse): IGBSwaggerHeader;
    destructor Destroy; override;
  end;

implementation

{ TGBSwaggerModelHeader }

constructor TGBSwaggerModelHeader.Create(AParent: IGBSwaggerPathResponse);
begin
  FParent := AParent;
  FType := SWAG_STRING;
end;

function TGBSwaggerModelHeader.Description(AValue: string): IGBSwaggerHeader;
begin
  Result := Self;
  FDescription := AValue;
end;

function TGBSwaggerModelHeader.Description: string;
begin
  Result := FDescription;
end;

destructor TGBSwaggerModelHeader.Destroy;
begin
  inherited;
end;

function TGBSwaggerModelHeader.&End: IGBSwaggerPathResponse;
begin
  Result := FParent;
end;

function TGBSwaggerModelHeader.Format(AValue: string): IGBSwaggerHeader;
begin
  Result := Self;
  FFormat := AValue;
end;

function TGBSwaggerModelHeader.Format: string;
begin
  Result := FFormat;
end;

function TGBSwaggerModelHeader.Name(AValue: string): IGBSwaggerHeader;
begin
  Result := Self;
  FName := AValue;
end;

function TGBSwaggerModelHeader.Name: string;
begin
  Result := FName;
end;

class function TGBSwaggerModelHeader.New(AParent: IGBSwaggerPathResponse): IGBSwaggerHeader;
begin
  Result := Self.Create(AParent);
end;

function TGBSwaggerModelHeader.&Type: string;
begin
  Result := FType;
end;

function TGBSwaggerModelHeader.&Type(AValue: string): IGBSwaggerHeader;
begin
  Result := Self;
  FType := AValue;
end;

end.
