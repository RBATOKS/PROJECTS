program Project1;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  ConsultaCEP in '..\ConsultaCEP.pas',
  AtendeCliente1 in 'AtendeCliente1.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
