program Natal;

uses
  Vcl.Forms,
  uMain in '..\..\..\..\Área de Trabalho\PiscaPisca VCL\Prj-Teste\uMain.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
