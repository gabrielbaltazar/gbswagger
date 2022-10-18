unit GBSwagger.Validator.Messages.Base;

interface

uses
  GBSwagger.Validator.Messages.Interfaces,
  System.SysUtils;

type
  TGBSwaggerValidatorMessagesBase = class(TInterfacedObject, IGBSwaggerValidatorMessages)
  protected
    FLanguage: string;
    FRequiredMessage: string;
    FMinimumLengthMessage: string;
    FMaximumLengthMessage: string;
    FMinimumValueMessage: string;
    FMaximumValueMessage: string;
    FPositiveMessage: string;
    FEnumValueMessage: string;

    function EnumValueMessage: string;
    function MinimumLengthMessage: string;
    function MaximumLengthMessage: string;
    function MinimumValueMessage: string;
    function MaximumValueMessage: string;
    function PositiveMessage: string;
    function RequiredMessage: string;
  end;

implementation

{ TGBSwaggerValidatorMessagesBase }

function TGBSwaggerValidatorMessagesBase.EnumValueMessage: string;
begin
  Result := FEnumValueMessage;
end;

function TGBSwaggerValidatorMessagesBase.MaximumLengthMessage: string;
begin
  Result := FMaximumLengthMessage;
end;

function TGBSwaggerValidatorMessagesBase.MaximumValueMessage: string;
begin
  Result := FMaximumValueMessage;
end;

function TGBSwaggerValidatorMessagesBase.MinimumLengthMessage: string;
begin
  Result := FMinimumLengthMessage;
end;

function TGBSwaggerValidatorMessagesBase.MinimumValueMessage: string;
begin
  Result := FMinimumValueMessage;
end;

function TGBSwaggerValidatorMessagesBase.PositiveMessage: string;
begin
  Result := FPositiveMessage;
end;

function TGBSwaggerValidatorMessagesBase.RequiredMessage: string;
begin
  Result := FRequiredMessage;
end;

end.
