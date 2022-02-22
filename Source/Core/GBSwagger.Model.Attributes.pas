unit GBSwagger.Model.Attributes;

interface

uses
  System.SysUtils;

type
  SwagClass = class(TCustomAttribute)
  private
    Fdescription: String;
    public
      constructor create(ADescription: String); overload;

      property description: String read Fdescription;
  end;

  SwagRequired = class(TCustomAttribute)
  end;

  SwagIgnore = class(TCustomAttribute)
  private
    FIgnoreProperties: TArray<String>;

  public
    property IgnoreProperties: TArray<String> read FIgnoreProperties write FIgnoreProperties;
    constructor create; overload;
    constructor create(AIgnoreProperties: String); overload;
  end;

  SwagProp = class(TCustomAttribute)
  private
    FwriteOnly: Boolean;
  protected
    FName: string;
    FDescription: string;
    FReadOnly: Boolean;
    FRequired: Boolean;

  public
    property name: String read FName;
    property description: String read FDescription;
    property readOnly: Boolean read FReadOnly;
    property writeOnly: Boolean read FwriteOnly;
    property required: Boolean read FRequired;

    constructor create(AName: String;
                       ADescription: string = '';
                       bRequired: Boolean = False;
                       bReadOnly: Boolean = False;
                       bWriteOnly: Boolean = False); overload;

    constructor create(ADescription: string;
                       bRequired: Boolean;
                       bReadOnly: Boolean = False;
                       bWriteOnly: Boolean = False;
                       AName: string = ''); overload;

    constructor create(bRequired: Boolean;
                       bReadOnly: Boolean = False;
                       bWriteOnly: Boolean = False;
                       ADescription: String = '';
                       AName: String = ''); overload;
  end;

  SwagString = class(TCustomAttribute)
  private
    FmaxLength: Integer;
    FminLength: Integer;
  public
    property minLength: Integer read FminLength;
    property maxLength: Integer read FmaxLength;

    constructor create(AMaxLength: Integer; AMinLength: Integer = 0); overload;

  end;

  SwagNumber = class(TCustomAttribute)
  private
    Fminimum: Double;
    Fmaximum: Double;

    public
      constructor create(AMinimum: Double; AMaximum: Double = 0); overload;

      property minimum: Double read Fminimum write Fminimum;
      property maximum: Double read Fmaximum write Fmaximum;
  end;

  SwagPositive = class(TCustomAttribute)
  end;

  SwagDate = class(TCustomAttribute)
  private
    FDateFormat: string;
  public
    constructor create(DateFormat: string);
    property dateFormat: string read FdateFormat;
  end;

implementation

{ SwagClass }

constructor SwagClass.create(ADescription: String);
begin
  Fdescription:= ADescription;
end;

{ SwagNumber }

constructor SwagNumber.create(AMinimum: Double; AMaximum: Double = 0);
begin
  Fminimum := AMinimum;
  Fmaximum := AMaximum;
end;

{ SwagString }

constructor SwagString.create(AMaxLength: Integer; AMinLength: Integer = 0);
begin
  FminLength := AMinLength;
  FMaxLength := AMaxLength;
end;

{ SwagDate }

constructor SwagDate.create(DateFormat: string);
begin
  FDateFormat := DateFormat;
end;

{ SwagProp }

constructor SwagProp.create(AName, ADescription: string; bRequired, bReadOnly, bWriteOnly: Boolean);
begin
  FName        := AName;
  FDescription := ADescription;
  FRequired    := bRequired;
  FReadOnly    := bReadOnly;
  FwriteOnly   := bWriteOnly;
end;

constructor SwagProp.create(bRequired, bReadOnly, bWriteOnly: Boolean; ADescription, AName: String);
begin
  FName        := AName;
  FDescription := ADescription;
  FRequired    := bRequired;
  FReadOnly    := bReadOnly;
  FwriteOnly   := bWriteOnly;
end;

constructor SwagProp.create(ADescription: string; bRequired,  bReadOnly, bWriteOnly: Boolean; AName: string);
begin
  FName        := AName;
  FDescription := ADescription;
  FRequired    := bRequired;
  FReadOnly    := bReadOnly;
  FwriteOnly   := bWriteOnly;
end;

{ SwagIgnore }

constructor SwagIgnore.create(AIgnoreProperties: String);
begin
  FIgnoreProperties := AIgnoreProperties.Split([',']);
end;

constructor SwagIgnore.create;
begin

end;

end.
