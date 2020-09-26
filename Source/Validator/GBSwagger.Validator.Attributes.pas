unit GBSwagger.Validator.Attributes;

interface

uses
  System.Classes;

type SwagValidateProperties = class(TCustomAttribute)
  private
    Fproperties: TArray<String>;

  public
    constructor create(AProperties: String);
    property properties: TArray<String> read Fproperties;
end;

implementation

{ SwagValidateProperties }

constructor SwagValidateProperties.create(AProperties: String);
var
  split: TStrings;
  i: Integer;
begin
  split := TStringList.Create;
  try
    split.Delimiter       := ',';
    split.StrictDelimiter := True;
    split.DelimitedText   := AProperties;

    SetLength(Fproperties, split.Count);
    for i := 0 to Pred(split.Count) do
      Fproperties[i] := split[i];
  finally
    split.Free;
  end;
end;

end.
