unit Annotation.Classes;

interface

uses
  GBSwagger.Model.Attributes;

type
  TUser = class
  private
    FId: Double;
    FName: string;
    FLastName: string;
    FBirthdayDate: TDateTime;
    FLastUpdate: TDateTime;
  public
    [SwagProp('user id', True)]
    property Id: Double read FId write FId;

    [SwagProp('User Description', True)]
    property Name: string read FName write FName;

    [SwagString(100)]
    property LastName: string read FLastName write FLastName;
    property BirthdayDate: TDateTime read FBirthdayDate write FBirthdayDate;

    [SwagIgnore]
    property LastUpdate: TDateTime read FLastUpdate write FLastUpdate;
  end;

  TAPIError = class
  private
    FError: string;
  public
    property Error: string read FError write FError;
  end;

implementation

end.
