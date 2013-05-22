program CadPessoas;

uses
  System.StartUpCopy,
  FMX.Forms,
  uCadPessoas in 'uCadPessoas.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
