unit Validation.Classes;

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
    [SwagProp('id', 'user id')]
    property id: Double read Fid write Fid;

    [SwagRequired]
    [SwagString(30, 3)]
    property name: String read Fname write Fname;

    [SwagString(100)]
    [SwagProp('', '', True)]
    property lastName: string read FlastName write FlastName;

    property birthdayDate: TDateTime read FbirthdayDate write FbirthdayDate;
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
