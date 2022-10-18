unit GBSwagger.Validator.Messages.Interfaces;

interface

uses
  GBSwagger.Model.Interfaces;

type
  IGBSwaggerValidatorMessages = interface
    ['{C42C0A7D-3A81-4770-9D53-69B64C85927A}']
    function EnumValueMessage: string;
    function MaximumLengthMessage: string;
    function MaximumValueMessage: string;
    function MinimumLengthMessage: string;
    function MinimumValueMessage: string;
    function PositiveMessage: string;
    function RequiredMessage: string;
  end;

function GetValidatorMessage: IGBSwaggerValidatorMessages;

implementation

uses
  System.SysUtils,
  GBSwagger.Validator.Messages.PtBR,
  GBSwagger.Validator.Messages.EnUS;

function GetValidatorMessage: IGBSwaggerValidatorMessages;
var
  LLanguage: String;
begin
  Result := TGBSwaggerValidatorMessagesEnUS.New;
  LLanguage := Swagger.Config.Language.ToLower.Replace('-', EmptyStr);
  if LLanguage = 'ptbr' then
    Result := TGBSwaggerValidatorMessagesPtBR.New;
end;

end.
