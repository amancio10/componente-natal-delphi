unit uMain;

{ Exemplo de dashboard natalino com todos os componentes da paleta
  "Natal-Amancio". Os enfeites estão no DFM (dá para mexer no designer);
  o código só preenche os textos e anima as barras de metas. }

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, uPiscaPisca, uEnfeitesNatal;

type
  TForm1 = class(TForm)
    FlocosNeve1: TFlocosNeve;
    pnlTopo: TPanel;
    NeveCaindo1: TNeveCaindo;
    EstrelaBrilho1: TEstrelaBrilho;
    shpLogo: TShape;
    lblLogo: TLabel;
    GorroNatal1: TGorroNatal;
    lblTitulo: TLabel;
    lblSubtitulo: TLabel;
    ContagemNatal1: TContagemNatal;
    PiscaPisca1: TPiscaPisca;
    FaixaRodape: TFaixaNatal;
    pnlVendas: TPanel;
    FaixaVendas: TFaixaNatal;
    lblVendasTitulo: TLabel;
    lblVendasValor: TLabel;
    lblVendasRodape: TLabel;
    pnlPedidos: TPanel;
    FaixaPedidos: TFaixaNatal;
    lblPedidosTitulo: TLabel;
    lblPedidosValor: TLabel;
    lblPedidosRodape: TLabel;
    pnlEntregas: TPanel;
    FaixaEntregas: TFaixaNatal;
    lblEntregasTitulo: TLabel;
    lblEntregasValor: TLabel;
    lblEntregasRodape: TLabel;
    pnlClientes: TPanel;
    FaixaClientes: TFaixaNatal;
    lblClientesTitulo: TLabel;
    lblClientesValor: TLabel;
    lblClientesRodape: TLabel;
    pnlArvore: TPanel;
    lblArvoreTitulo: TLabel;
    lblArvoreSub: TLabel;
    ArvoreNatal1: TArvoreNatal;
    pnlMetas: TPanel;
    BolasPenduradas1: TBolasPenduradas;
    lblMetasTitulo: TLabel;
    lblMetasSub: TLabel;
    lblMeta1: TLabel;
    lblMeta1Valor: TLabel;
    shpMeta1Trilho: TShape;
    shpMeta1: TShape;
    lblMeta2: TLabel;
    lblMeta2Valor: TLabel;
    shpMeta2Trilho: TShape;
    shpMeta2: TShape;
    lblMeta3: TLabel;
    lblMeta3Valor: TLabel;
    shpMeta3Trilho: TShape;
    shpMeta3: TShape;
    lblMeta4: TLabel;
    lblMeta4Valor: TLabel;
    shpMeta4Trilho: TShape;
    shpMeta4: TShape;
    lblMetasRodape: TLabel;
    pnlMensagem: TPanel;
    Guirlanda1: TGuirlanda;
    SeloNatal1: TSeloNatal;
    lblMensagem: TLabel;
    lblAssinatura: TLabel;
    tmrMetas: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure tmrMetasTimer(Sender: TObject);
  private
    FProgresso: Double;
    FTrilhos, FBarras: array[0..3] of TShape;
    FValores: array[0..3] of TLabel;
    procedure AtualizarMetas;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

const
  // Percentual de cada meta: vendas online, entregas no prazo, cestas, satisfação
  cMetas: array[0..3] of Integer = (86, 96, 72, 91);

procedure TForm1.FormCreate(Sender: TObject);
begin
  lblSubtitulo.Caption := 'Campanha Polo Norte  ' + #$2022 + '  ' +
    FormatDateTime('dddd, d "de" mmmm "de" yyyy', Date);
  lblMetasRodape.Caption := 'Atualizado em ' + FormatDateTime('dd/mm/yyyy "às" hh:nn', Now);
  // O selo se ajusta ao texto (AutoSize): centraliza no cartão
  SeloNatal1.Left := (pnlMensagem.ClientWidth - SeloNatal1.Width) div 2;

  FTrilhos[0] := shpMeta1Trilho;  FBarras[0] := shpMeta1;  FValores[0] := lblMeta1Valor;
  FTrilhos[1] := shpMeta2Trilho;  FBarras[1] := shpMeta2;  FValores[1] := lblMeta2Valor;
  FTrilhos[2] := shpMeta3Trilho;  FBarras[2] := shpMeta3;  FValores[2] := lblMeta3Valor;
  FTrilhos[3] := shpMeta4Trilho;  FBarras[3] := shpMeta4;  FValores[3] := lblMeta4Valor;
  FProgresso := 0;
  AtualizarMetas;
end;

procedure TForm1.AtualizarMetas;
var
  I, Pct: Integer;
begin
  for I := 0 to 3 do
  begin
    Pct := Round(cMetas[I] * FProgresso);
    FBarras[I].Width := Round(FTrilhos[I].Width * Pct / 100);
    FValores[I].Caption := IntToStr(Pct) + '%';
  end;
end;

procedure TForm1.tmrMetasTimer(Sender: TObject);
begin
  // As barras crescem até a meta logo que o painel abre
  FProgresso := FProgresso + 0.04;
  if FProgresso >= 1 then
  begin
    FProgresso := 1;
    tmrMetas.Enabled := False;
  end;
  AtualizarMetas;
end;

end.
