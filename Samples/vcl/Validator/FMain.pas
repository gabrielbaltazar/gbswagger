unit FMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Validator.Model, Vcl.StdCtrls,
  GBSwagger.Validator.Interfaces;

type
  TfrmMain = class(TForm)
    btnValidate: TButton;
    procedure btnValidateClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.btnValidateClick(Sender: TObject);
var
  person : TPerson;
begin
  person := TPerson.Create;
  try
    person.id := 2;
    person.name := '1';
    person.birthday := Now;
    person.address.street := 'Street 1';
    person.address.state := 'RJaaa';
    person.phones.Add(TPhone.Create);
    SwaggerValidator.validate(person);
  finally
    person.Free;
  end;
end;

end.
