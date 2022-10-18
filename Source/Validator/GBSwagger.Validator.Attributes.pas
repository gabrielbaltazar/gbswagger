unit GBSwagger.Validator.Attributes;

interface

uses
  System.Classes;

type
  SwagValidateProperties = class(TCustomAttribute)
  private
    FProperties: TArray<string>;
  public
    constructor Create(AProperties: string);
    property Properties: TArray<string> read FProperties;
  end;

implementation

{ SwagValidateProperties }

constructor SwagValidateProperties.Create(AProperties: string);
var
  LSplit: TStrings;
  I: Integer;
begin
  LSplit := TStringList.Create;
  try
    LSplit.Delimiter := ',';
    LSplit.StrictDelimiter := True;
    LSplit.DelimitedText := AProperties;

    SetLength(FProperties, LSplit.Count);
    for I := 0 to Pred(LSplit.Count) do
      FProperties[I] := LSplit[I];
  finally
    LSplit.Free;
  end;
end;

end.
