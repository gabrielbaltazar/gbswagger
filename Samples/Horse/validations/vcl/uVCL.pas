unit uVCL;

interface

uses
  Winapi.Windows, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, System.SysUtils;

type
  TUser = class
  private
    Fid: Double;
    Fname: String;
    FlastName: string;
    FbirthdayDate: TDateTime;
    FlastUpdate: TDateTime;
  public
    property id: Double read Fid write Fid;
    property name: String read Fname write Fname;
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

  TfrmVCL = class(TForm)
    lbStatus: TLabel;
    lbPorta: TLabel;
    btnStartStop: TBitBtn;
    procedure btnStartStopClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FRunning: Boolean;
    procedure Start;
    procedure Stop;
  public
    { Public declarations }
  end;

var
  frmVCL: TfrmVCL;

implementation

uses
  Horse,
  Horse.GBSwagger,
  Validation.Classes,
  Validation.Controller.User;

{$R *.dfm}

{ TfrmVCL }

procedure TfrmVCL.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (FRunning) then
    Stop;
end;

procedure TfrmVCL.Start;
begin
  THorse.Use(HorseSwagger);

  THorseGBSwaggerRegister.RegisterPath(TUserController);

  THorse.Listen(9000);
  FRunning := True;
end;

procedure TfrmVCL.Stop;
begin
  THorse.StopListen;
  FRunning := False;
end;

procedure TfrmVCL.btnStartStopClick(Sender: TObject);
begin
  FRunning := (not FRunning);

  if (FRunning) then
  begin
    Start;
    btnStartStop.Caption := 'Stop';
    lbStatus.Caption := 'Status: Online';
    lbPorta.Caption := 'Port: ' + IntToStr(THorse.Port);
  end
  else
  begin
    Stop;
    btnStartStop.Caption := 'Start';
    lbStatus.Caption := 'Status: Offline';
    lbPorta.Caption := 'Port: ';
  end;
end;

initialization
  ReportMemoryLeaksOnShutDown := True;

  Swagger
    .Register
      .SchemaOnError(TAPIError)
    .&End
    .Info
      .Title('Horse Sample')
      .Description('API VCL Horse')
      .Contact
        .Name('Contact Name')
        .Email('contact@email.com.br')
        .URL('http://www.mypage.com.br')
      .&End
    .&End
    .BasePath('v1');
end.
