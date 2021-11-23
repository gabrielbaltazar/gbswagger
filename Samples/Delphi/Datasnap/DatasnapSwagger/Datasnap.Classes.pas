unit Datasnap.Classes;

interface

uses
  GBSwagger.Model.Attributes;

type
  TUser = class
  private
    Fid: Double;
    Fname: String;
    FlastName: string;
  public
    property id: Double read Fid write Fid;
    [SwagRequired]
    property name: String read Fname write Fname;
    property lastName: string read FlastName write FlastName;
  end;

  TAPIError = class
  private
    Ferror: string;
  public
    property error: string read Ferror write Ferror;
  end;

implementation

end.
