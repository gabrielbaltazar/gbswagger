unit PetStore.Models;

interface

uses
  GBSwagger.Model.Attributes,
  System.Variants,
  System.Generics.Collections;

type
  TStatus = (sAvailable, sPending, sSold);
  TOrderStatus = (osPlaced, osApproved, odDelivered);

  TTag = class;

  TPet = class
  private
    Fid: Integer;
    Fname: String;
    FphotoUrls: TArray<string>;
    Fstatus: TStatus;
    Ftags: TObjectList<TTag>;
    public
      [SwagNumber(1, 100)]
      property id: Integer read Fid write Fid;

      [SwagRequired]
      [SwagString(30, 'Pet name')]
      property name: String read Fname write Fname;
      [SwagRequired]
      property photoUrls: TArray<string> read FphotoUrls write FphotoUrls;
      property status: TStatus read Fstatus write Fstatus;
      property tags: TObjectList<TTag> read Ftags write Ftags;
  end;

  TCategory = class
  private
    Fid: Integer;
    Fname: String;
    public
      property id: Integer read Fid write Fid;
      property name: String read Fname write Fname;
  end;

  [SwagClass('MyTag')]
  TTag = class
  private
    Fid: Integer;
    Fname: String;
    public
      property id: Integer read Fid write Fid;
      property name: String read Fname write Fname;
  end;

  TOrder = class
  private
    Fid: Integer;
    Fquantity: Double;
    FshipDate: TDateTime;
    Fstatus: TOrderStatus;
    Fcomplete: Boolean;
    Fpet: TPet;
    FcreateDate: TDateTime;
    public
      property id: Integer read Fid write Fid;
      property pet: TPet read Fpet write Fpet;
      property quantity: Double read Fquantity write Fquantity;
      property shipDate: TDateTime read FshipDate write FshipDate;
      property createDate: TDateTime read FcreateDate write FcreateDate;
      property status: TOrderStatus read Fstatus write Fstatus;
      property complete: Boolean read Fcomplete write Fcomplete;
  end;

  TUser = class
  private
    Fid: Integer;
    Fusername: String;
    FfirstName: string;
    FlastName: String;
    Femail: String;
    Fpassword: String;
    Fphone: String;
    public
      property id: Integer read Fid write Fid;
      property username: String read Fusername write Fusername;
      property firstName: string read FfirstName write FfirstName;
      property lastName: String read FlastName write FlastName;
      property email: String read Femail write Femail;
      property password: String read Fpassword write Fpassword;
      property phone: String read Fphone write Fphone;
  end;

  TApiResponse = class
  private
    Fcode: Integer;
    Ftype: String;
    Fmessage: String;
    public
      property code: Integer read Fcode write Fcode;
      property &type: String read Ftype write Ftype;
      property message: String read Fmessage write Fmessage;
  end;

  TAPIError = class
  private
    FerrorMessage: String;
    public
      property errorMessage: String read FerrorMessage write FerrorMessage;
  end;
  
implementation

end.
