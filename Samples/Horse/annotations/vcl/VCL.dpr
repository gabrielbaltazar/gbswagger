program VCL;

uses
  Vcl.Forms,
  uVCL in 'uVCL.pas' {frmVCL},
  Annotation.Classes in '..\Annotation.Classes.pas',
  Annotation.Controller.User in '..\Annotation.Controller.User.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmVCL, frmVCL);
  Application.Run;
end.
