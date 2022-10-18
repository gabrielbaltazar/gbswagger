unit GBSwagger.Validator.Interfaces;

interface

type
  IGBSwaggerValidator = interface
    ['{132A6324-5991-49CA-8006-880C6C7CE789}']
    procedure Validate(AValue: TObject; AInstanceName: String = '');
  end;

function SwaggerValidator: IGBSwaggerValidator;

implementation

uses
  GBSwagger.Validator.Base;

function SwaggerValidator: IGBSwaggerValidator;
begin
  Result := TGBSwaggerValidator.New;
end;

end.
