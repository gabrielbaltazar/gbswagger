unit GBSwagger.Model.Attributes;

interface

uses
{$IF DEFINED(FPC)}
  SysUtils, typinfo, Classes;
{$ELSE}
  System.SysUtils;
{$ENDIF}

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
  protected
    FName: string;
    FDescription: string;
    FReadOnly: Boolean;
    FRequired: Boolean;

  public
    property name: String read FName write FName;
    property description: String read FDescription write FDescription;
    property readOnly: Boolean read FReadOnly write FReadOnly;
    property required: Boolean read FRequired write FRequired;

    constructor create(AName: String;
                       ADescription: string = '';
                       bRequired: Boolean = False;
                       bReadOnly: Boolean = False); overload;

    constructor create(ADescription: string;
                       bRequired: Boolean;
                       bReadOnly: Boolean = False;
                       AName: string = ''); overload;

    constructor create(bRequired: Boolean;
                       bReadOnly: Boolean = False;
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

constructor SwagProp.create(AName, ADescription: string; bRequired, bReadOnly: Boolean);
begin
  FName        := AName;
  FDescription := ADescription;
  FRequired    := bRequired;
  FReadOnly    := bReadOnly;
end;

constructor SwagProp.create(bRequired, bReadOnly: Boolean; ADescription, AName: String);
begin
  FName        := AName;
  FDescription := ADescription;
  FRequired    := bRequired;
  FReadOnly    := bReadOnly;
end;

constructor SwagProp.create(ADescription: string; bRequired,  bReadOnly: Boolean; AName: string);
begin
  FName        := AName;
  FDescription := ADescription;
  FRequired    := bRequired;
  FReadOnly    := bReadOnly;
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
