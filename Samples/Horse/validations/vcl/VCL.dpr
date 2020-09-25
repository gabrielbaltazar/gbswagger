program VCL;

uses
  Vcl.Forms,
  uVCL in 'uVCL.pas' {frmVCL},
  Validation.Classes in '..\Validation.Classes.pas',
  Validation.Controller.User in '..\Validation.Controller.User.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmVCL, frmVCL);
  Application.Run;
end.
