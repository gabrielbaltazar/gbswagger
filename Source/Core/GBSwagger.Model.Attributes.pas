unit GBSwagger.Model.Attributes;

interface

uses
  System.SysUtils;

type
  SwagClass = class(TCustomAttribute)
  private
    FDescription: string;
  public
    constructor Create(ADescription: string); overload;
    property Description: string read FDescription;
  end;

  SwagRequired = class(TCustomAttribute)
  end;

  SwagIgnore = class(TCustomAttribute)
  private
    FIgnoreProperties: TArray<string>;
  public
    property IgnoreProperties: TArray<string> read FIgnoreProperties write FIgnoreProperties;
    constructor Create; overload;
    constructor Create(AIgnoreProperties: string); overload;
  end;

  SwagProp = class(TCustomAttribute)
  private
    FWriteOnly: Boolean;
  protected
    FName: string;
    FDescription: string;
    FReadOnly: Boolean;
    FRequired: Boolean;
  public
    constructor Create(AName: string; ADescription: string = '';
      ARequired: Boolean = False; AReadOnly: Boolean = False;
      AWriteOnly: Boolean = False); overload;

    constructor Create(ADescription: string; ARequired: Boolean;
      AReadOnly: Boolean = False; AWriteOnly: Boolean = False;
      AName: string = ''); overload;

    constructor create(ARequired: Boolean; AReadOnly: Boolean = False;
      AWriteOnly: Boolean = False; ADescription: string = '';
      AName: string = ''); overload;

    property Name: string read FName;
    property Description: string read FDescription;
    property ReadOnly: Boolean read FReadOnly;
    property WriteOnly: Boolean read FWriteOnly;
    property Required: Boolean read FRequired;
  end;

  SwagString = class(TCustomAttribute)
  private
    FMaxLength: Integer;
    FMinLength: Integer;
  public
    constructor Create(AMaxLength: Integer; AMinLength: Integer = 0); overload;

    property MinLength: Integer read FMinLength;
    property MaxLength: Integer read FMaxLength;
  end;

  SwagNumber = class(TCustomAttribute)
  private
    FMinimum: Double;
    FMaximum: Double;
  public
    constructor Create(AMinimum: Double; AMaximum: Double = 0); overload;

    property Minimum: Double read FMinimum write FMinimum;
    property Maximum: Double read FMaximum write FMaximum;
  end;

  SwagPositive = class(TCustomAttribute)
  end;

  SwagDate = class(TCustomAttribute)
  private
    FDateFormat: string;
  public
    constructor Create(ADateFormat: string);
    property DateFormat: string read FdateFormat;
  end;

implementation

{ SwagClass }

constructor SwagClass.Create(ADescription: string);
begin
  FDescription:= ADescription;
end;

{ SwagNumber }

constructor SwagNumber.Create(AMinimum: Double; AMaximum: Double = 0);
begin
  FMinimum := AMinimum;
  FMaximum := AMaximum;
end;

{ SwagString }

constructor SwagString.Create(AMaxLength: Integer; AMinLength: Integer = 0);
begin
  FMinLength := AMinLength;
  FMaxLength := AMaxLength;
end;

{ SwagDate }

constructor SwagDate.Create(ADateFormat: string);
begin
  FDateFormat := ADateFormat;
end;

{ SwagProp }

constructor SwagProp.Create(AName, ADescription: string; ARequired, AReadOnly, AWriteOnly: Boolean);
begin
  FName := AName;
  FDescription := ADescription;
  FRequired := ARequired;
  FReadOnly := AReadOnly;
  FWriteOnly := AWriteOnly;
end;

constructor SwagProp.Create(ARequired, AReadOnly, AWriteOnly: Boolean; ADescription, AName: string);
begin
  FName := AName;
  FDescription := ADescription;
  FRequired := ARequired;
  FReadOnly := AReadOnly;
  FWriteOnly := AWriteOnly;
end;

constructor SwagProp.Create(ADescription: string; ARequired, AReadOnly, AWriteOnly: Boolean; AName: string);
begin
  FName := AName;
  FDescription := ADescription;
  FRequired := ARequired;
  FReadOnly := AReadOnly;
  FWriteOnly := AWriteOnly;
end;

{ SwagIgnore }

constructor SwagIgnore.Create(AIgnoreProperties: string);
begin
  FIgnoreProperties := AIgnoreProperties.Split([',']);
end;

constructor SwagIgnore.Create;
begin
end;

end.
