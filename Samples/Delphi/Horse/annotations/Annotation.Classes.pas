unit Annotation.Classes;

interface

uses
  GBSwagger.Model.Attributes;

type
  TUser = class
  private
    Fid: Double;
    Fname: String;
    FlastName: string;
    FbirthdayDate: TDateTime;
    FlastUpdate: TDateTime;
  public
    [SwagProp('user id', True)]
    property id: Double read Fid write Fid;

    [SwagProp('User Description', True)]
    property name: String read Fname write Fname;

    [SwagString(100)]
    property lastName: string read FlastName write FlastName;
    property birthdayDate: TDateTime read FbirthdayDate write FbirthdayDate;

    [SwagIgnore]
    property lastUpdate: TDateTime read FlastUpdate write FlastUpdate;
  end;

  TAPIError = class
  private
    Ferror: string;
  public
    property error: string read Ferror write Ferror;
  end;

implementation

end.
