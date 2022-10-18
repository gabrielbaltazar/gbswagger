unit GBSwagger.Validator.Messages.PtBR;

interface

uses
  GBSwagger.Validator.Messages.Interfaces,
  GBSwagger.Validator.Messages.Base;

type
  TGBSwaggerValidatorMessagesPtBR = class(TGBSwaggerValidatorMessagesBase, IGBSwaggerValidatorMessages)
  public
    constructor Create;
    class function New: IGBSwaggerValidatorMessages;
  end;

implementation

{ TGBSwaggerValidatorMessagesPtBR }

constructor TGBSwaggerValidatorMessagesPtBR.Create;
begin
  inherited;
  FEnumValueMessage := 'Os valores aceitos da propriedade %s são [%s]';
  FMaximumLengthMessage := 'O tamanho máximo da propriedade %s é %d.';
  FMaximumValueMessage := 'O valor máximo da propriedade %s é %s.';
  FMinimumLengthMessage := 'O tamanho mínimo da propriedade %s é %d.';
  FMinimumValueMessage := 'O valor mínimo da propriedade %s é %s.';
  FPositiveMessage := 'O valor da propriedade %s deve ser positiva.';
  FRequiredMessage := 'A propriedade %s é obrigatória.';
end;

class function TGBSwaggerValidatorMessagesPtBR.New: IGBSwaggerValidatorMessages;
begin
  Result := Self.Create;
end;

end.

