unit GBSwagger.Validator.Messages.Base;

interface

uses
  GBSwagger.Validator.Messages.Interfaces,
  System.SysUtils;

type TGBSwaggerValidatorMessagesBase = class(TInterfacedObject, IGBSwaggerValidatorMessages)

  protected
    FLanguage: string;
    FRequiredMessage: String;
    FMinimumLengthMessage: String;
    FMaximumLengthMessage: String;
    FMinimumValueMessage: String;
    FMaximumValueMessage: string;
    FPositiveMessage: string;
    FEnumValueMessage: string;

    function EnumValueMessage: string;
    function MinimumLengthMessage: string;
    function MaximumLengthMessage: string;
    function MinimumValueMessage: string;
    function MaximumValueMessage: string;
    function PositiveMessage: string;
    function RequiredMessage: String;

end;

implementation

{ TGBSwaggerValidatorMessagesBase }

function TGBSwaggerValidatorMessagesBase.EnumValueMessage: string;
begin
  result := FEnumValueMessage;
end;

function TGBSwaggerValidatorMessagesBase.MaximumLengthMessage: string;
begin
  result := FMaximumLengthMessage;
end;

function TGBSwaggerValidatorMessagesBase.MaximumValueMessage: string;
begin
  result := FMaximumValueMessage;
end;

function TGBSwaggerValidatorMessagesBase.MinimumLengthMessage: string;
begin
  result := FMinimumLengthMessage;
end;

function TGBSwaggerValidatorMessagesBase.MinimumValueMessage: string;
begin
  result := FMinimumValueMessage;
end;

function TGBSwaggerValidatorMessagesBase.PositiveMessage: string;
begin
  result := FPositiveMessage;
end;

function TGBSwaggerValidatorMessagesBase.RequiredMessage: String;
begin
  result := FRequiredMessage;
end;

end.
