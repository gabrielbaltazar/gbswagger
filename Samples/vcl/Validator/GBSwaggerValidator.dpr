program GBSwaggerValidator;

uses
  Vcl.Forms,
  FMain in 'FMain.pas' {frmMain},
  Validator.Model in 'Validator.Model.pas',
  GBSwagger.Model.Attributes in '..\..\Source\Core\GBSwagger.Model.Attributes.pas',
  GBSwagger.Model.Config in '..\..\Source\Core\GBSwagger.Model.Config.pas',
  GBSwagger.Model.Contact in '..\..\Source\Core\GBSwagger.Model.Contact.pas',
  GBSwagger.Model.Header in '..\..\Source\Core\GBSwagger.Model.Header.pas',
  GBSwagger.Model.Info in '..\..\Source\Core\GBSwagger.Model.Info.pas',
  GBSwagger.Model.Interfaces in '..\..\Source\Core\GBSwagger.Model.Interfaces.pas',
  GBSwagger.Model.JSON.Contact in '..\..\Source\Core\GBSwagger.Model.JSON.Contact.pas',
  GBSwagger.Model.JSON.Header in '..\..\Source\Core\GBSwagger.Model.JSON.Header.pas',
  GBSwagger.Model.JSON.Info in '..\..\Source\Core\GBSwagger.Model.JSON.Info.pas',
  GBSwagger.Model.JSON.Interfaces in '..\..\Source\Core\GBSwagger.Model.JSON.Interfaces.pas',
  GBSwagger.Model.JSON.Parameter in '..\..\Source\Core\GBSwagger.Model.JSON.Parameter.pas',
  GBSwagger.Model.JSON in '..\..\Source\Core\GBSwagger.Model.JSON.pas',
  GBSwagger.Model.JSON.Path in '..\..\Source\Core\GBSwagger.Model.JSON.Path.pas',
  GBSwagger.Model.JSON.PathMethod in '..\..\Source\Core\GBSwagger.Model.JSON.PathMethod.pas',
  GBSwagger.Model.JSON.PathResponse in '..\..\Source\Core\GBSwagger.Model.JSON.PathResponse.pas',
  GBSwagger.Model.JSON.Schema in '..\..\Source\Core\GBSwagger.Model.JSON.Schema.pas',
  GBSwagger.Model.JSON.Utils in '..\..\Source\Core\GBSwagger.Model.JSON.Utils.pas',
  GBSwagger.Model.Parameter in '..\..\Source\Core\GBSwagger.Model.Parameter.pas',
  GBSwagger.Model in '..\..\Source\Core\GBSwagger.Model.pas',
  GBSwagger.Model.Path in '..\..\Source\Core\GBSwagger.Model.Path.pas',
  GBSwagger.Model.PathMethod in '..\..\Source\Core\GBSwagger.Model.PathMethod.pas',
  GBSwagger.Model.PathResponse in '..\..\Source\Core\GBSwagger.Model.PathResponse.pas',
  GBSwagger.Model.Schema in '..\..\Source\Core\GBSwagger.Model.Schema.pas',
  GBSwagger.Model.Tag in '..\..\Source\Core\GBSwagger.Model.Tag.pas',
  GBSwagger.Model.Types in '..\..\Source\Core\GBSwagger.Model.Types.pas',
  GBSwagger.Path.Attributes in '..\..\Source\Core\GBSwagger.Path.Attributes.pas',
  GBSwagger.Path.Register in '..\..\Source\Core\GBSwagger.Path.Register.pas',
  GBSwagger.Register.Interfaces in '..\..\Source\Core\GBSwagger.Register.Interfaces.pas',
  GBSwagger.Register in '..\..\Source\Core\GBSwagger.Register.pas',
  GBSwagger.Register.Response in '..\..\Source\Core\GBSwagger.Register.Response.pas',
  GBSwagger.RTTI in '..\..\Source\Core\GBSwagger.RTTI.pas',
  GBSwagger.Web.HTML in '..\..\Source\Core\GBSwagger.Web.HTML.pas',
  GBSwagger.Validator.Interfaces in '..\..\Source\Validator\GBSwagger.Validator.Interfaces.pas',
  GBSwagger.Validator.Base in '..\..\Source\Validator\GBSwagger.Validator.Base.pas',
  GBSwagger.Validator.Attributes in '..\..\Source\Validator\GBSwagger.Validator.Attributes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
