unit uNatalAmancioReg;

{ Registro dos enfeites na paleta de componentes do Delphi (aba "Natal-Amancio"). }

interface

procedure Register;

implementation

{$R NatalAmancio.dcr}

uses
  System.Classes, uEnfeitesNatal, uPiscaPisca;

procedure Register;
begin
  RegisterComponents('Natal-Amancio', [TPiscaPisca, TArvoreNatal, TBolasPenduradas, TContagemNatal,
    TEstrelaBrilho, TFaixaNatal, TFlocosNeve, TGorroNatal, TGuirlanda, TNeveCaindo, TSeloNatal]);
end;

end.