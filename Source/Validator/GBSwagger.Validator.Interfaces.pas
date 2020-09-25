unit GBSwagger.Validator.Interfaces;

interface

type
  IGBSwaggerValidator = interface
    ['{132A6324-5991-49CA-8006-880C6C7CE789}']
    procedure validate(Value: TObject; AInstanceName: String = '');
  end;

function SwaggerValidator: IGBSwaggerValidator;

implementation

uses
  GBSwagger.Validator.Base;

function SwaggerValidator: IGBSwaggerValidator;
begin
  result := TGBSwaggerValidator.New;
end;

end.
