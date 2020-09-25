unit Validator.Model;

interface

uses
  GBSwagger.Model.Attributes,
  GBSwagger.Validator.Attributes,
  System.Generics.Collections;

type
  TStatus = (active, inactive);

  TAddress = class;
  TPhone = class;

  TPerson = class
  private
    Fid: Double;
    Fname: String;
    Fbirthday: TDateTime;
    Fstatus: TStatus;
    Faddress: TAddress;
    Fphones: TObjectList<TPhone>;

  public
    [SwagRequired]
    [SwagNumber(0, 2)]
    property id: Double read Fid write Fid;

    [SwagRequired]
    property name: String read Fname write Fname;
    [SwagRequired]
    property birthday: TDateTime read Fbirthday write Fbirthday;

    [SwagValidateProperties('street')]
    property address: TAddress read Faddress write Faddress;
    property phones: TObjectList<TPhone> read Fphones write Fphones;

    property status: TStatus read Fstatus write Fstatus;

    constructor create;
    destructor  Destroy; override;
  end;

  TAddress = class
  private
    Fstreet: string;
    Fstate: String;

  public
    [SwagRequired]
    property street: string read Fstreet write Fstreet;
    [SwagRequired]
    [SwagString(2, 2)]
    property state: String read Fstate write Fstate;
  end;

  TPhone = class
  private
    FphoneNumber: string;

  public
    [SwagRequired]
    property phoneNumber: string read FphoneNumber write FphoneNumber;
  end;

implementation

{ TPerson }

constructor TPerson.create;
begin
  Faddress := TAddress.Create;
  Fphones  := TObjectList<TPhone>.create;
end;

destructor TPerson.Destroy;
begin
  Faddress.Free;
  Fphones.Free;
  inherited;
end;

end.
