unit GBSwagger.Validator.Messages.EnUS;

interface

uses
  GBSwagger.Validator.Messages.Interfaces,
  GBSwagger.Validator.Messages.Base;

type TGBSwaggerValidatorMessagesEnUS = class(TGBSwaggerValidatorMessagesBase, IGBSwaggerValidatorMessages)

  public
    constructor create;
    class function New: IGBSwaggerValidatorMessages;
end;

implementation

{ TGBSwaggerValidatorMessagesEnUS }

constructor TGBSwaggerValidatorMessagesEnUS.create;
begin
  FEnumValueMessage := 'The property %s must be in [%s]';
  FRequiredMessage := 'The property %s is required.';
  FMinimumLengthMessage := 'The minimun length to property %s is %d.';
  FMaximumLengthMessage := 'The maximum length to property %s is %d.';
  FMinimumValueMessage := 'The minimum value to property %s is %s.';
  FMaximumValueMessage := 'The maximum value to property %s is %s.';
  FPositiveMessage := 'The value property %s must be positive.';
end;

class function TGBSwaggerValidatorMessagesEnUS.New: IGBSwaggerValidatorMessages;
begin
  result := Self.create;
end;

end.
