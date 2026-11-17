unit uEnfeitesNatal;

{ Enfeites de Natal para aplicações VCL (Delphi 10.3 ou superior), por Amancio.
  Todos desenhados com GDI+ (bordas suaves), sem imagens e sem dependências
  além da VCL. Paleta: "Natal-Amancio".

  Comuns a todos (TEnfeiteNatal):
    SoNaEpoca   True: em tempo de execução, fora de 1º/11 a 6/1, o enfeite fica invisível
    Transparente  não pinta o fundo (sobre imagens/degradês)
    Color / ParentColor  fundo, quando não é transparente

  Componentes:
    TArvoreNatal      árvore com bolinhas que piscam, estrela e presentes
    TBolasPenduradas  bolas penduradas em fios, balançando de leve
    TContagemNatal    "Faltam N dias para o Natal" (no dia 25: "Feliz Natal!")
    TEstrelaBrilho    estrelinhas que brilham em pontos aleatórios
    TFaixaNatal       faixa listrada (bengala ou cores natalinas)
    TFlocosNeve       flocos de neve parados, discretos, para fundos
    TGorroNatal       gorro de Papai Noel (canto de logo/avatar)
    TGuirlanda        coroa de folhas com frutinhas e laço
    TNeveCaindo       neve caindo devagar (cliques passam para o que está atrás)
    TSeloNatal        selo "Feliz Natal" com árvore desenhada
    TPiscaPisca       (unit uPiscaPisca) cordão de luzes piscando

  Observação: como todo TGraphicControl, os enfeites ficam atrás de controles
  com janela (TEdit, TPanel, TButton...). Os animados ligam DoubleBuffered no
  pai para não piscar a tela. }

{$Q-}
{$R-}

interface

uses
  Winapi.Windows, Winapi.Messages, System.Classes, System.Types, System.SysUtils,
  Vcl.Controls, Vcl.Graphics, Vcl.ExtCtrls, Winapi.GDIPAPI, Winapi.GDIPOBJ;

type
  /// Base dos enfeites: pintura GDI+, animação por timer e época de Natal.
  TEnfeiteNatal = class(TGraphicControl)
  private
    FTimer: TTimer;
    FSoNaEpoca: Boolean;
    FTransparente: Boolean;
    FCliqueAtravessa: Boolean;
    procedure Tique(Sender: TObject);
    procedure SetSoNaEpoca(Valor: Boolean);
    procedure AplicarEpoca;
    procedure GarantirBuffer;
    procedure CMHitTest(var Msg: TCMHitTest); message CM_HITTEST;
  protected
    FQuadro: Integer;
    procedure Loaded; override;
    procedure SetParent(AParent: TWinControl); override;
    procedure Paint; override;
    /// Antes do desenho (medidas de texto etc.)
    procedure Preparar; virtual;
    /// Desenho GDI+ do enfeite
    procedure Desenhar(G: TGPGraphics); virtual; abstract;
    /// Depois do GDI+ (texto com a fonte do controle)
    procedure DesenharTexto; virtual;
    /// Um quadro da animação (padrão: avança e repinta)
    procedure Avancar; virtual;
    function E(Valor: Single): Single;
    function EI(Valor: Integer): Integer;
    function GetAnimado: Boolean;
    procedure SetAnimado(Valor: Boolean);
    function GetIntervalo: Cardinal;
    procedure SetIntervalo(Valor: Cardinal);
    procedure SetTransparente(Valor: Boolean);
    property Animado: Boolean read GetAnimado write SetAnimado;
    property Intervalo: Cardinal read GetIntervalo write SetIntervalo;
    property Transparente: Boolean read FTransparente write SetTransparente;
    property CliqueAtravessa: Boolean read FCliqueAtravessa write FCliqueAtravessa;
  public
    constructor Create(AOwner: TComponent); override;
    /// Natal: de 1º de novembro a 6 de janeiro (Dia de Reis)
    class function EpocaDeNatal: Boolean;
  published
    property Align;
    property Anchors;
    property Color;
    property Constraints;
    property ParentColor;
    property Visible;
    property Hint;
    property ShowHint;
    property ParentShowHint;
    property OnClick;
    property OnDblClick;
    property SoNaEpoca: Boolean read FSoNaEpoca write SetSoNaEpoca default False;
  end;

  /// Árvore de Natal com bolinhas que piscam, estrela e presentes
  TArvoreNatal = class(TEnfeiteNatal)
  private
    FCorArvore: TColor;
    FMostrarPresentes: Boolean;
    procedure SetCorArvore(Valor: TColor);
    procedure SetMostrarPresentes(Valor: Boolean);
  protected
    procedure Desenhar(G: TGPGraphics); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Transparente default True;
    property Animado default True;
    property Intervalo default 600;
    property CorArvore: TColor read FCorArvore write SetCorArvore default $00327D2E;
    property MostrarPresentes: Boolean read FMostrarPresentes write SetMostrarPresentes default True;
  end;

  /// Bolas de Natal penduradas em fios de tamanhos diferentes
  TBolasPenduradas = class(TEnfeiteNatal)
  private
    FQuantidade: Integer;
    FAmplitude: Integer;
    FCorFio: TColor;
    FCorDestaque: TColor;
    procedure SetQuantidade(Valor: Integer);
    procedure SetCorFio(Valor: TColor);
    procedure SetCorDestaque(Valor: TColor);
  protected
    procedure Desenhar(G: TGPGraphics); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Transparente default True;
    property Animado default True;
    property Intervalo default 40;
    property Quantidade: Integer read FQuantidade write SetQuantidade default 5;
    /// Balanço máximo, em graus
    property Amplitude: Integer read FAmplitude write FAmplitude default 6;
    property CorFio: TColor read FCorFio write SetCorFio default $00677280;
    property CorDestaque: TColor read FCorDestaque write SetCorDestaque default $003473EB;
  end;

  /// Contagem regressiva para o Natal
  TContagemNatal = class(TEnfeiteNatal)
  private
    FTextoContagem: string;
    FTextoVespera: string;
    FTextoNatal: string;
    FTextoFestas: string;
    FMostrarIcone: Boolean;
    FAlinhamento: TAlignment;
    FTextoX: Single;
    FIcone: TRectF;
    function GetTexto(const Index: Integer): string;
    procedure SetTexto(const Index: Integer; const Valor: string);
    procedure SetMostrarIcone(Valor: Boolean);
    procedure SetAlinhamento(Valor: TAlignment);
  protected
    procedure Preparar; override;
    procedure Desenhar(G: TGPGraphics); override;
    procedure DesenharTexto; override;
  public
    constructor Create(AOwner: TComponent); override;
    /// Dias até o próximo dia 25 de dezembro (0 no próprio dia)
    class function DiasParaONatal: Integer;
    /// Texto exibido hoje
    function TextoAtual: string;
  published
    property Font;
    property ParentFont;
    property Transparente default True;
    property Animado default True;
    /// Confere a data a cada minuto (vira o texto à meia-noite)
    property Intervalo default 60000;
    /// Com %d para o número de dias
    property TextoContagem: string index 0 read GetTexto write SetTexto;
    property TextoVespera: string index 1 read GetTexto write SetTexto;
    property TextoNatal: string index 2 read GetTexto write SetTexto;
    /// De 26/12 a 6/1
    property TextoFestas: string index 3 read GetTexto write SetTexto;
    property MostrarIcone: Boolean read FMostrarIcone write SetMostrarIcone default True;
    property Alinhamento: TAlignment read FAlinhamento write SetAlinhamento default taLeftJustify;
  end;

  /// Estrelinhas que brilham em pontos aleatórios
  TEstrelaBrilho = class(TEnfeiteNatal)
  private
    type
      TEstrela = record
        X, Y, Tam, Fase, Vel: Single;
      end;
  private
    FQuantidade: Integer;
    FCorEstrela: TColor;
    FSemente: Integer;
    FEstrelas: TArray<TEstrela>;
    procedure Gerar;
    procedure SetQuantidade(Valor: Integer);
    procedure SetCorEstrela(Valor: TColor);
    procedure SetSemente(Valor: Integer);
  protected
    procedure Desenhar(G: TGPGraphics); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Transparente default True;
    property Animado default True;
    property Intervalo default 60;
    property Quantidade: Integer read FQuantidade write SetQuantidade default 25;
    property CorEstrela: TColor read FCorEstrela write SetCorEstrela default $004EC1F2;
    /// Muda a posição das estrelas
    property Semente: Integer read FSemente write SetSemente default 1225;
  end;

  TEstiloFaixa = (efBengala, efNatalino);

  /// Faixa listrada para separar áreas
  TFaixaNatal = class(TEnfeiteNatal)
  private
    FEstilo: TEstiloFaixa;
    FLarguraListra: Integer;
    FRaio: Integer;
    procedure SetEstilo(Valor: TEstiloFaixa);
    procedure SetLarguraListra(Valor: Integer);
    procedure SetRaio(Valor: Integer);
  protected
    procedure Desenhar(G: TGPGraphics); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Transparente default True;
    /// As listras andam
    property Animado default False;
    property Intervalo default 50;
    property Estilo: TEstiloFaixa read FEstilo write SetEstilo default efBengala;
    property LarguraListra: Integer read FLarguraListra write SetLarguraListra default 10;
    /// Cantos arredondados (0 = retos)
    property Raio: Integer read FRaio write SetRaio default 0;
  end;

  /// Flocos de neve parados, discretos, para pintar fundos
  TFlocosNeve = class(TEnfeiteNatal)
  private
    FCorFlocos: TColor;
    FOpacidade: Byte;
    FEspacamento: Integer;
    FSemente: Integer;
    procedure SetCorFlocos(Valor: TColor);
    procedure SetOpacidade(Valor: Byte);
    procedure SetEspacamento(Valor: Integer);
    procedure SetSemente(Valor: Integer);
  protected
    procedure Desenhar(G: TGPGraphics); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Transparente default True;
    property CorFlocos: TColor read FCorFlocos write SetCorFlocos default $00B4C0DE;
    property Opacidade: Byte read FOpacidade write SetOpacidade default 140;
    /// Distância média entre flocos (menor = mais flocos)
    property Espacamento: Integer read FEspacamento write SetEspacamento default 170;
    property Semente: Integer read FSemente write SetSemente default 1225;
  end;

  /// Gorro de Papai Noel
  TGorroNatal = class(TEnfeiteNatal)
  private
    FCorGorro: TColor;
    FInclinacao: Integer;
    procedure SetCorGorro(Valor: TColor);
    procedure SetInclinacao(Valor: Integer);
  protected
    procedure Desenhar(G: TGPGraphics); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Transparente default True;
    property CorGorro: TColor read FCorGorro write SetCorGorro default $002F2FD3;
    /// Graus (negativo = para a esquerda)
    property Inclinacao: Integer read FInclinacao write SetInclinacao default -18;
  end;

  /// Coroa de folhas com frutinhas e laço
  TGuirlanda = class(TEnfeiteNatal)
  private
    FCorLaco: TColor;
    procedure SetCorLaco(Valor: TColor);
  protected
    procedure Desenhar(G: TGPGraphics); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Transparente default True;
    /// As frutinhas brilham alternadas
    property Animado default False;
    property Intervalo default 700;
    property CorLaco: TColor read FCorLaco write SetCorLaco default $002F2FD3;
  end;

  /// Neve caindo devagar; os cliques passam para o que está atrás
  TNeveCaindo = class(TEnfeiteNatal)
  private
    type
      TFloco = record
        X, Y, R, V, Fase: Single;
      end;
  private
    FQuantidade: Integer;
    FCorNeve: TColor;
    FOpacidade: Byte;
    FVelocidade: Integer;
    FFlocos: TArray<TFloco>;
    FLarguraGerada, FAlturaGerada: Integer;
    FSorteio: Cardinal;
    function Sortear: Single;
    procedure Gerar;
    procedure SetQuantidade(Valor: Integer);
    procedure SetCorNeve(Valor: TColor);
    procedure SetOpacidade(Valor: Byte);
    procedure SetVelocidade(Valor: Integer);
  protected
    procedure Desenhar(G: TGPGraphics); override;
    procedure Avancar; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Transparente default True;
    property Animado default True;
    property Intervalo default 40;
    property Quantidade: Integer read FQuantidade write SetQuantidade default 60;
    property CorNeve: TColor read FCorNeve write SetCorNeve default $00E6D8C8;
    property Opacidade: Byte read FOpacidade write SetOpacidade default 210;
    /// 1 (devagar) a 10 (rápido)
    property Velocidade: Integer read FVelocidade write SetVelocidade default 3;
  end;

  /// Selo "Feliz Natal" com uma árvore desenhada
  TSeloNatal = class(TEnfeiteNatal)
  private
    FTexto: string;
    FCorFundo: TColor;
    FCorBorda: TColor;
    procedure SetTexto(const Valor: string);
    procedure SetCorFundo(Valor: TColor);
    procedure SetCorBorda(Valor: TColor);
    procedure CMFontChanged(var Msg: TMessage); message CM_FONTCHANGED;
  protected
    procedure Desenhar(G: TGPGraphics); override;
    procedure DesenharTexto; override;
    function CanAutoSize(var NewWidth, NewHeight: Integer): Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    /// Largura para caber o texto
    function LarguraIdeal: Integer;
  published
    property AutoSize;
    property Font;
    property ParentFont default False;
    property Transparente default True;
    property Texto: string read FTexto write SetTexto;
    property CorFundo: TColor read FCorFundo write SetCorFundo default $00E5E5F8;
    property CorBorda: TColor read FCorBorda write SetCorBorda default $009EC69C;
  end;

{ Rotinas de desenho (também usadas pelo TPiscaPisca) }

const
  cVermelho       = $FFD32F2F;
  cVermelhoEscuro = $FFA0181E;
  cVerde          = $FF2E7D32;
  cVerdeClaro     = $FF4CA050;
  cVerdeEscuro    = $FF1B5E20;
  cDourado        = $FFFFC107;
  cAzul           = $FF42A5F5;
  cMarrom         = $FF795548;
  cBranco         = $FFFFFFFF;

/// TColor -> cor GDI+ com transparência
function CorGP(C: TColor; Alfa: Byte = 255): Cardinal;
/// Clareia (Fator > 0) ou escurece (Fator < 0) uma cor
function Tom(C: TColor; Fator: Single; Alfa: Byte = 255): Cardinal;
function ComAlfa(C: Cardinal; Alfa: Byte): Cardinal;
procedure Elipse(G: TGPGraphics; ACor: Cardinal; X, Y, W, H: Single);
procedure Poligono(G: TGPGraphics; ACor: Cardinal; const Pts: array of TGPPointF);
procedure Linha(G: TGPGraphics; ACor: Cardinal; Espessura, X1, Y1, X2, Y2: Single);
procedure Estrela(G: TGPGraphics; ACor: Cardinal; CX, CY, RExt, RInt: Single; Pontas: Integer;
  Giro: Single = 0);
/// Bolinha com reflexo; Acesa desenha o brilho em volta, Apagada fica mais fosca
procedure Bola(G: TGPGraphics; ACor: Cardinal; CX, CY, R: Single; Acesa: Boolean = False;
  Apagada: Boolean = False);

implementation

uses
  System.Math, System.DateUtils;

{ Rotinas }

function CorGP(C: TColor; Alfa: Byte): Cardinal;
var
  Cor: TColorRef;
begin
  Cor := ColorToRGB(C);
  Result := MakeColor(Alfa, GetRValue(Cor), GetGValue(Cor), GetBValue(Cor));
end;

function Tom(C: TColor; Fator: Single; Alfa: Byte): Cardinal;
var
  Cor: TColorRef;
  R, G, B: Integer;

  function Ajustar(V: Integer): Byte;
  begin
    if Fator >= 0 then
      Result := EnsureRange(V + Round((255 - V) * Fator), 0, 255)
    else
      Result := EnsureRange(V + Round(V * Fator), 0, 255);
  end;

begin
  Cor := ColorToRGB(C);
  R := GetRValue(Cor);
  G := GetGValue(Cor);
  B := GetBValue(Cor);
  Result := MakeColor(Alfa, Ajustar(R), Ajustar(G), Ajustar(B));
end;

function ComAlfa(C: Cardinal; Alfa: Byte): Cardinal;
begin
  Result := (C and $00FFFFFF) or (Cardinal(Alfa) shl 24);
end;

procedure Elipse(G: TGPGraphics; ACor: Cardinal; X, Y, W, H: Single);
var
  B: TGPSolidBrush;
begin
  B := TGPSolidBrush.Create(ACor);
  try
    G.FillEllipse(B, X, Y, W, H);
  finally
    B.Free;
  end;
end;

procedure Poligono(G: TGPGraphics; ACor: Cardinal; const Pts: array of TGPPointF);
var
  B: TGPSolidBrush;
begin
  if Length(Pts) < 3 then
    Exit;
  B := TGPSolidBrush.Create(ACor);
  try
    G.FillPolygon(B, PGPPointF(@Pts[0]), Length(Pts));
  finally
    B.Free;
  end;
end;

procedure Linha(G: TGPGraphics; ACor: Cardinal; Espessura, X1, Y1, X2, Y2: Single);
var
  P: TGPPen;
begin
  P := TGPPen.Create(ACor, Espessura);
  try
    P.SetStartCap(LineCapRound);
    P.SetEndCap(LineCapRound);
    G.DrawLine(P, X1, Y1, X2, Y2);
  finally
    P.Free;
  end;
end;

procedure Estrela(G: TGPGraphics; ACor: Cardinal; CX, CY, RExt, RInt: Single; Pontas: Integer;
  Giro: Single);
var
  Pts: array of TGPPointF;
  I: Integer;
  A, R: Single;
begin
  SetLength(Pts, Pontas * 2);
  for I := 0 to Pontas * 2 - 1 do
  begin
    if Odd(I) then
      R := RInt
    else
      R := RExt;
    A := Giro + I * Pi / Pontas - Pi / 2;
    Pts[I] := MakePoint(Single(CX + R * Cos(A)), Single(CY + R * Sin(A)));
  end;
  Poligono(G, ACor, Pts);
end;

procedure Bola(G: TGPGraphics; ACor: Cardinal; CX, CY, R: Single; Acesa, Apagada: Boolean);
begin
  if Acesa then
  begin
    Elipse(G, ComAlfa(ACor, $30), CX - R * 2.2, CY - R * 2.2, R * 4.4, R * 4.4);
    Elipse(G, ComAlfa(ACor, $50), CX - R * 1.5, CY - R * 1.5, R * 3, R * 3);
  end;
  if Apagada then
    Elipse(G, ComAlfa(ACor, $80), CX - R, CY - R, R * 2, R * 2)
  else
    Elipse(G, ACor, CX - R, CY - R, R * 2, R * 2);
  // Reflexo
  Elipse(G, MakeColor(IfThen(Apagada, 70, 160), 255, 255, 255), CX - R * 0.55, CY - R * 0.6,
    R * 0.6, R * 0.5);
end;

function Ponto(X, Y: Single): TGPPointF; inline;
begin
  Result.X := X;
  Result.Y := Y;
end;

{ TEnfeiteNatal }

constructor TEnfeiteNatal.Create(AOwner: TComponent);
begin
  inherited;
  FTransparente := True;
  ControlStyle := ControlStyle - [csOpaque];
  Width := 100;
  Height := 100;
  FTimer := TTimer.Create(Self);
  FTimer.Enabled := False;
  FTimer.OnTimer := Tique;
end;

class function TEnfeiteNatal.EpocaDeNatal: Boolean;
var
  Hoje: TDateTime;
begin
  Hoje := Date;
  Result := (MonthOf(Hoje) >= 11) or ((MonthOf(Hoje) = 1) and (DayOf(Hoje) <= 6));
end;

function TEnfeiteNatal.E(Valor: Single): Single;
begin
  // Acompanha a escala (DPI) do monitor
  Result := Valor * CurrentPPI / 96;
end;

function TEnfeiteNatal.EI(Valor: Integer): Integer;
begin
  Result := MulDiv(Valor, CurrentPPI, 96);
end;

procedure TEnfeiteNatal.Loaded;
begin
  inherited;
  AplicarEpoca;
  GarantirBuffer;
end;

procedure TEnfeiteNatal.SetParent(AParent: TWinControl);
begin
  inherited;
  GarantirBuffer;
end;

procedure TEnfeiteNatal.GarantirBuffer;
begin
  // Os animados repintam o pai várias vezes por segundo: sem buffer a tela pisca
  if Animado and (Parent <> nil) and not (csDesigning in ComponentState) then
    Parent.DoubleBuffered := True;
end;

procedure TEnfeiteNatal.AplicarEpoca;
begin
  if FSoNaEpoca and not (csDesigning in ComponentState) and not EpocaDeNatal then
    Visible := False;
end;

procedure TEnfeiteNatal.SetSoNaEpoca(Valor: Boolean);
begin
  FSoNaEpoca := Valor;
  if not (csLoading in ComponentState) then
    AplicarEpoca;
end;

procedure TEnfeiteNatal.SetTransparente(Valor: Boolean);
begin
  FTransparente := Valor;
  if Valor then
    ControlStyle := ControlStyle - [csOpaque]
  else
    ControlStyle := ControlStyle + [csOpaque];
  Invalidate;
end;

function TEnfeiteNatal.GetAnimado: Boolean;
begin
  Result := FTimer.Enabled;
end;

procedure TEnfeiteNatal.SetAnimado(Valor: Boolean);
begin
  FTimer.Enabled := Valor;
  GarantirBuffer;
  Invalidate;
end;

function TEnfeiteNatal.GetIntervalo: Cardinal;
begin
  Result := FTimer.Interval;
end;

procedure TEnfeiteNatal.SetIntervalo(Valor: Cardinal);
begin
  if Valor < 20 then
    Valor := 20;
  FTimer.Interval := Valor;
end;

procedure TEnfeiteNatal.Tique(Sender: TObject);
begin
  // Não gasta pintura com a tela escondida ou minimizada
  if not Visible or (Parent = nil) or not Parent.Showing then
    Exit;
  Avancar;
end;

procedure TEnfeiteNatal.Avancar;
begin
  Inc(FQuadro);
  Invalidate;
end;

procedure TEnfeiteNatal.CMHitTest(var Msg: TCMHitTest);
begin
  // Enfeites de fundo deixam o clique passar (no editor do Delphi continuam selecionáveis)
  if FCliqueAtravessa and not (csDesigning in ComponentState) then
    Msg.Result := HTNOWHERE
  else
    inherited;
end;

procedure TEnfeiteNatal.Preparar;
begin
end;

procedure TEnfeiteNatal.DesenharTexto;
begin
end;

procedure TEnfeiteNatal.Paint;
var
  G: TGPGraphics;
begin
  if not FTransparente then
  begin
    Canvas.Brush.Style := bsSolid;
    Canvas.Brush.Color := Color;
    Canvas.FillRect(ClientRect);
  end;
  Preparar;
  if (Width > 0) and (Height > 0) then
  begin
    G := TGPGraphics.Create(Canvas.Handle);
    try
      G.SetSmoothingMode(SmoothingModeAntiAlias);
      G.SetPixelOffsetMode(PixelOffsetModeHighQuality);
      Desenhar(G);
    finally
      G.Free;
    end;
  end;
  DesenharTexto;
  // No editor do Delphi: contorno pontilhado para achar o enfeite no form
  if csDesigning in ComponentState then
  begin
    Canvas.Pen.Style := psDot;
    Canvas.Pen.Color := clGray;
    Canvas.Brush.Style := bsClear;
    Canvas.Rectangle(ClientRect);
  end;
end;

{ TArvoreNatal }

constructor TArvoreNatal.Create(AOwner: TComponent);
begin
  inherited;
  FCorArvore := $00327D2E;
  FMostrarPresentes := True;
  Width := 120;
  Height := 160;
  Intervalo := 600;
  Animado := True;
end;

procedure TArvoreNatal.SetCorArvore(Valor: TColor);
begin
  FCorArvore := Valor;
  Invalidate;
end;

procedure TArvoreNatal.SetMostrarPresentes(Valor: Boolean);
begin
  FMostrarPresentes := Valor;
  Invalidate;
end;

procedure Presente(G: TGPGraphics; X, Y, W, H: Single; Caixa, Fita: Cardinal);
var
  B: TGPSolidBrush;
begin
  B := TGPSolidBrush.Create(Caixa);
  try
    G.FillRectangle(B, X, Y, W, H);
  finally
    B.Free;
  end;
  B := TGPSolidBrush.Create(Fita);
  try
    G.FillRectangle(B, X + W * 0.42, Y, W * 0.16, H);
    G.FillRectangle(B, X, Y + H * 0.38, W, H * 0.18);
  finally
    B.Free;
  end;
  // Laço
  Elipse(G, Fita, X + W * 0.24, Y - H * 0.22, W * 0.26, H * 0.26);
  Elipse(G, Fita, X + W * 0.50, Y - H * 0.22, W * 0.26, H * 0.26);
end;

procedure TArvoreNatal.Desenhar(G: TGPGraphics);
const
  // Camadas: topo, base (frações da altura da copa) e meia largura
  Camadas: array[0..2, 0..2] of Single = ((0, 0.45, 0.55), (0.25, 0.72, 0.78), (0.5, 1.0, 1.0));
  // Bolinhas: camada, posição horizontal (-1..1) e altura dentro da camada
  Bolas: array[0..11, 0..2] of Single = (
    (0, -0.40, 0.75), (0, 0.35, 0.85), (0, 0.00, 0.50), (1, -0.55, 0.80),
    (1, 0.10, 0.90), (1, 0.60, 0.70), (1, -0.15, 0.55), (2, -0.70, 0.85),
    (2, -0.25, 0.92), (2, 0.25, 0.80), (2, 0.70, 0.90), (2, 0.00, 0.60));
  CoresBolas: array[0..3] of Cardinal = (cVermelho, cDourado, cAzul, cBranco);
var
  W, H, LT, CX, SY, S, Y0, YB, PB, Top, Bot, HW, TH, X, Y, R, V: Single;
  I, C: Integer;
  Caminho: TGPGraphicsPath;
  Pincel: TGPLinearGradientBrush;
  Festao: TGPPen;
  B: TGPSolidBrush;
begin
  W := Width;
  H := Height;
  LT := Min(W, H * 0.72);
  CX := W / 2;
  S := LT * 0.12;
  // Espaço para o brilho da estrela não ser cortado no topo
  SY := S * 1.45 + E(1);
  Y0 := SY + S * 0.35;
  PB := H - 1;
  if FMostrarPresentes then
    YB := PB - LT * 0.16
  else
    YB := PB - LT * 0.10;

  // Tronco
  B := TGPSolidBrush.Create(cMarrom);
  try
    G.FillRectangle(B, CX - LT * 0.07, YB - E(2), LT * 0.14, LT * 0.12);
  finally
    B.Free;
  end;

  // Copa: de baixo para cima, cada camada sobre a anterior
  Festao := TGPPen.Create(ComAlfa(cDourado, 210), Max(1, E(1.4)));
  try
    for I := 2 downto 0 do
    begin
      Top := Y0 + (YB - Y0) * Camadas[I, 0];
      Bot := Y0 + (YB - Y0) * Camadas[I, 1];
      HW := LT / 2 * Camadas[I, 2];
      TH := Bot - Top;
      Caminho := TGPGraphicsPath.Create;
      Pincel := TGPLinearGradientBrush.Create(Ponto(CX - HW, Top), Ponto(CX + HW, Bot),
        Tom(FCorArvore, 0.22), Tom(FCorArvore, -0.30));
      try
        Caminho.StartFigure;
        Caminho.AddLine(CX, Top, CX - HW, Bot);
        Caminho.AddBezier(CX - HW, Bot, CX - HW / 3, Bot + TH * 0.12, CX + HW / 3, Bot + TH * 0.12,
          CX + HW, Bot);
        Caminho.CloseFigure;
        G.FillPath(Pincel, Caminho);
      finally
        Pincel.Free;
        Caminho.Free;
      end;
      // Festão dourado atravessando a camada
      G.DrawBezier(Festao, CX - HW * 0.42, Top + TH * 0.45, CX - HW * 0.1, Top + TH * 0.66,
        CX + HW * 0.25, Top + TH * 0.70, CX + HW * 0.64, Top + TH * 0.68);
    end;
  finally
    Festao.Free;
  end;

  // Bolinhas (piscam em sequência)
  R := Max(E(2), LT * 0.032);
  for I := 0 to High(Bolas) do
  begin
    C := Trunc(Bolas[I, 0]);
    Top := Y0 + (YB - Y0) * Camadas[C, 0];
    Bot := Y0 + (YB - Y0) * Camadas[C, 1];
    HW := LT / 2 * Camadas[C, 2];
    V := Bolas[I, 2];
    X := CX + Bolas[I, 1] * HW * V;
    Y := Top + (Bot - Top) * V;
    Bola(G, CoresBolas[I mod 4], X, Y, R, Animado and ((I + FQuadro) mod 3 = 0));
  end;

  // Estrela no topo (pulsa junto com as bolinhas)
  if Animado and Odd(FQuadro) then
    Elipse(G, ComAlfa(cDourado, $48), CX - S * 1.7, SY - S * 1.7, S * 3.4, S * 3.4)
  else
    Elipse(G, ComAlfa(cDourado, $28), CX - S * 1.4, SY - S * 1.4, S * 2.8, S * 2.8);
  Estrela(G, cDourado, CX, SY, S, S * 0.45, 5);

  // Presentes
  if FMostrarPresentes then
  begin
    Presente(G, CX - LT * 0.46, PB - LT * 0.19, LT * 0.26, LT * 0.19, cVermelho, cDourado);
    Presente(G, CX + LT * 0.20, PB - LT * 0.15, LT * 0.24, LT * 0.15, cAzul, cBranco);
    Presente(G, CX - LT * 0.15, PB - LT * 0.11, LT * 0.18, LT * 0.11, cVerdeClaro, cVermelho);
  end;
end;

{ TBolasPenduradas }

constructor TBolasPenduradas.Create(AOwner: TComponent);
begin
  inherited;
  FQuantidade := 5;
  FAmplitude := 6;
  FCorFio := $00677280;
  FCorDestaque := $003473EB;
  Width := 260;
  Height := 110;
  Intervalo := 40;
  Animado := True;
end;

procedure TBolasPenduradas.SetQuantidade(Valor: Integer);
begin
  FQuantidade := EnsureRange(Valor, 1, 50);
  Invalidate;
end;

procedure TBolasPenduradas.SetCorFio(Valor: TColor);
begin
  FCorFio := Valor;
  Invalidate;
end;

procedure TBolasPenduradas.SetCorDestaque(Valor: TColor);
begin
  FCorDestaque := Valor;
  Invalidate;
end;

procedure TBolasPenduradas.Desenhar(G: TGPGraphics);
const
  Comprimentos: array[0..4] of Single = (0.30, 0.62, 0.45, 0.75, 0.52);
var
  I: Integer;
  Passo, D, L, X, Y, Ang: Single;
  Cor: Cardinal;
  Estado: GraphicsState;
  B: TGPSolidBrush;
begin
  Passo := Width / FQuantidade;
  D := Min(Passo * 0.55, Height * 0.32);
  for I := 0 to FQuantidade - 1 do
  begin
    X := Passo * (I + 0.5);
    L := Max(E(4), (Height - D * 1.2 - E(4)) * Comprimentos[I mod 5]);
    if Animado then
      Ang := FAmplitude * Sin(FQuadro * 0.07 + I * 1.3)
    else
      Ang := 0;
    case I mod 5 of
      0: Cor := cVermelho;
      1: Cor := cDourado;
      2: Cor := cVerdeClaro;
      3: Cor := cAzul;
    else
      Cor := CorGP(FCorDestaque);
    end;

    // Gira em torno do gancho (ponto de cima), como um pêndulo
    Estado := G.Save;
    try
      G.TranslateTransform(X, 0);
      G.RotateTransform(Ang);
      Linha(G, CorGP(FCorFio, 200), Max(1, E(1)), 0, 0, 0, L);
      // Tampinha dourada
      B := TGPSolidBrush.Create(Tom(clYellow, -0.25));
      try
        G.FillRectangle(B, -D * 0.13, L, D * 0.26, D * 0.17);
      finally
        B.Free;
      end;
      Y := L + D * 0.15 + D / 2;
      Bola(G, Cor, 0, Y, D / 2);
      // Faixa decorativa nas bolas alternadas
      if Odd(I) then
        Elipse(G, $50FFFFFF, -D * 0.47, Y - D * 0.07, D * 0.94, D * 0.14);
    finally
      G.Restore(Estado);
    end;
  end;
end;

{ TContagemNatal }

constructor TContagemNatal.Create(AOwner: TComponent);
begin
  inherited;
  FTextoContagem := 'Faltam %d dias para o Natal';
  FTextoVespera := 'Amanhã é Natal!';
  FTextoNatal := 'Feliz Natal!';
  FTextoFestas := 'Boas Festas!';
  FMostrarIcone := True;
  FAlinhamento := taLeftJustify;
  Width := 240;
  Height := 24;
  Intervalo := 60000;
  Animado := True;
end;

class function TContagemNatal.DiasParaONatal: Integer;
var
  Natal: TDateTime;
begin
  Natal := EncodeDate(YearOf(Date), 12, 25);
  if Date > Natal then
    Natal := EncodeDate(YearOf(Date) + 1, 12, 25);
  Result := Trunc(Natal - Date);
end;

function TContagemNatal.TextoAtual: string;
var
  Hoje: TDateTime;
  Dias: Integer;
begin
  Hoje := Date;
  if ((MonthOf(Hoje) = 12) and (DayOf(Hoje) > 25)) or ((MonthOf(Hoje) = 1) and (DayOf(Hoje) <= 6)) then
    Exit(FTextoFestas);
  Dias := DiasParaONatal;
  case Dias of
    0: Result := FTextoNatal;
    1: Result := FTextoVespera;
  else
    if Pos('%d', FTextoContagem) > 0 then
      Result := Format(FTextoContagem, [Dias])
    else
      Result := FTextoContagem;
  end;
end;

function TContagemNatal.GetTexto(const Index: Integer): string;
begin
  case Index of
    0: Result := FTextoContagem;
    1: Result := FTextoVespera;
    2: Result := FTextoNatal;
  else
    Result := FTextoFestas;
  end;
end;

procedure TContagemNatal.SetTexto(const Index: Integer; const Valor: string);
begin
  case Index of
    0: FTextoContagem := Valor;
    1: FTextoVespera := Valor;
    2: FTextoNatal := Valor;
    3: FTextoFestas := Valor;
  end;
  Invalidate;
end;

procedure TContagemNatal.SetMostrarIcone(Valor: Boolean);
begin
  FMostrarIcone := Valor;
  Invalidate;
end;

procedure TContagemNatal.SetAlinhamento(Valor: TAlignment);
begin
  FAlinhamento := Valor;
  Invalidate;
end;

procedure TContagemNatal.Preparar;
var
  Tam, Total, X, Folga: Single;
begin
  Canvas.Font.Assign(Font);
  Folga := E(2);
  if FMostrarIcone then
    Tam := Min(Height * 0.78, E(22))
  else
    Tam := 0;
  Total := Canvas.TextWidth(TextoAtual);
  if Tam > 0 then
    Total := Total + Tam + E(6);
  case FAlinhamento of
    taCenter: X := (Width - Total) / 2;
    taRightJustify: X := Width - Total - Folga;
  else
    X := Folga;
  end;
  X := Max(X, Folga);
  FIcone := TRectF.Create(X, (Height - Tam) / 2, X + Tam, (Height + Tam) / 2);
  if Tam > 0 then
    FTextoX := X + Tam + E(6)
  else
    FTextoX := X;
end;

procedure TContagemNatal.Desenhar(G: TGPGraphics);
var
  R: TRectF;
begin
  if not FMostrarIcone or (FIcone.Width <= 0) then
    Exit;
  R := FIcone;
  // Presente (no dia de Natal, uma estrela)
  if DiasParaONatal = 0 then
  begin
    Elipse(G, ComAlfa(cDourado, $40), R.Left, R.Top, R.Width, R.Height);
    Estrela(G, cDourado, R.Left + R.Width / 2, R.Top + R.Height / 2, R.Width * 0.48, R.Width * 0.2, 5);
  end
  else
    Presente(G, R.Left + R.Width * 0.08, R.Top + R.Height * 0.32, R.Width * 0.84, R.Height * 0.64,
      cVermelho, cDourado);
end;

procedure TContagemNatal.DesenharTexto;
var
  R: TRect;
  S: string;
begin
  S := TextoAtual;
  Canvas.Brush.Style := bsClear;
  Canvas.Font.Assign(Font);
  R := Rect(Round(FTextoX), 0, Width, Height);
  DrawText(Canvas.Handle, PChar(S), -1, R, DT_LEFT or DT_VCENTER or DT_SINGLELINE or DT_NOPREFIX or
    DT_END_ELLIPSIS);
end;

{ TEstrelaBrilho }

constructor TEstrelaBrilho.Create(AOwner: TComponent);
begin
  inherited;
  CliqueAtravessa := True;
  FQuantidade := 25;
  FCorEstrela := $004EC1F2;
  FSemente := 1225;
  Width := 240;
  Height := 140;
  Intervalo := 60;
  Animado := True;
  Gerar;
end;

procedure TEstrelaBrilho.Gerar;
var
  Semente: Cardinal;
  I: Integer;

  function Sortear: Single;
  begin
    Semente := Semente * 1103515245 + 12345;
    Result := ((Semente shr 8) and $FFFF) / 65535;
  end;

begin
  Semente := Cardinal(FSemente);
  SetLength(FEstrelas, FQuantidade);
  for I := 0 to FQuantidade - 1 do
  begin
    FEstrelas[I].X := Sortear;
    FEstrelas[I].Y := Sortear;
    FEstrelas[I].Tam := Sortear;
    FEstrelas[I].Fase := Sortear * 2 * Pi;
    FEstrelas[I].Vel := 0.05 + Sortear * 0.10;
  end;
end;

procedure TEstrelaBrilho.SetQuantidade(Valor: Integer);
begin
  FQuantidade := EnsureRange(Valor, 0, 500);
  Gerar;
  Invalidate;
end;

procedure TEstrelaBrilho.SetCorEstrela(Valor: TColor);
begin
  FCorEstrela := Valor;
  Invalidate;
end;

procedure TEstrelaBrilho.SetSemente(Valor: Integer);
begin
  FSemente := Valor;
  Gerar;
  Invalidate;
end;

procedure TEstrelaBrilho.Desenhar(G: TGPGraphics);
var
  I: Integer;
  Brilho, Tam, X, Y: Single;
  Alfa: Byte;
begin
  for I := 0 to High(FEstrelas) do
  begin
    Brilho := (Sin(FEstrelas[I].Fase + FQuadro * FEstrelas[I].Vel) + 1) / 2;
    if not Animado then
      Brilho := 0.8;
    Alfa := Round(40 + 215 * Brilho);
    Tam := (E(4) + FEstrelas[I].Tam * E(7)) * (0.55 + 0.45 * Brilho);
    X := E(8) + FEstrelas[I].X * (Width - E(16));
    Y := E(8) + FEstrelas[I].Y * (Height - E(16));
    Elipse(G, CorGP(FCorEstrela, Alfa div 5), X - Tam * 0.9, Y - Tam * 0.9, Tam * 1.8, Tam * 1.8);
    Estrela(G, CorGP(FCorEstrela, Alfa), X, Y, Tam, Tam * 0.22, 4);
    Estrela(G, CorGP(clWhite, Alfa div 2), X, Y, Tam * 0.45, Tam * 0.12, 4, Pi / 4);
  end;
end;

{ TFaixaNatal }

constructor TFaixaNatal.Create(AOwner: TComponent);
begin
  inherited;
  FEstilo := efBengala;
  FLarguraListra := 10;
  Width := 240;
  Height := 8;
  Intervalo := 50;
end;

procedure TFaixaNatal.SetEstilo(Valor: TEstiloFaixa);
begin
  FEstilo := Valor;
  Invalidate;
end;

procedure TFaixaNatal.SetLarguraListra(Valor: Integer);
begin
  FLarguraListra := EnsureRange(Valor, 2, 200);
  Invalidate;
end;

procedure TFaixaNatal.SetRaio(Valor: Integer);
begin
  FRaio := Max(Valor, 0);
  Invalidate;
end;

procedure TFaixaNatal.Desenhar(G: TGPGraphics);
var
  W, H, SW, Periodo, X, R: Single;
  Cores: array of Cardinal;
  I: Integer;
  Caminho: TGPGraphicsPath;
  B: TGPSolidBrush;
begin
  W := Width;
  H := Height;
  if FEstilo = efNatalino then
    Cores := [cVermelho, cBranco, cVerde, cBranco]
  else
    Cores := [cVermelho, cBranco];
  SW := E(FLarguraListra);
  Periodo := SW * Length(Cores);

  // Cantos arredondados: tudo é desenhado dentro do contorno
  Caminho := TGPGraphicsPath.Create;
  try
    R := Min(E(FRaio) * 2, Min(W, H));
    if R > 0 then
    begin
      Caminho.AddArc(0.0, 0.0, R, R, 180, 90);
      Caminho.AddArc(W - R - 1, 0.0, R, R, 270, 90);
      Caminho.AddArc(W - R - 1, H - R - 1, R, R, 0, 90);
      Caminho.AddArc(0.0, H - R - 1, R, R, 90, 90);
      Caminho.CloseFigure;
    end
    else
      Caminho.AddRectangle(MakeRect(0.0, 0.0, W, H));
    G.SetClip(Caminho);
    B := TGPSolidBrush.Create(cBranco);
    try
      G.FillPath(B, Caminho);
    finally
      B.Free;
    end;
  finally
    Caminho.Free;
  end;

  // Listras diagonais; animadas, andam um pixel por quadro
  X := -H - Periodo;
  if Animado then
    X := X + (FQuadro * E(1)) - Trunc((FQuadro * E(1)) / Periodo) * Periodo;
  I := 0;
  while X < W + H do
  begin
    if Cores[I mod Length(Cores)] <> cBranco then
      Poligono(G, Cores[I mod Length(Cores)], [Ponto(X, H), Ponto(X + H, 0), Ponto(X + H + SW, 0),
        Ponto(X + SW, H)]);
    X := X + SW;
    Inc(I);
  end;
  G.ResetClip;
end;

{ TFlocosNeve }

constructor TFlocosNeve.Create(AOwner: TComponent);
begin
  inherited;
  CliqueAtravessa := True;
  FCorFlocos := $00B4C0DE;
  FOpacidade := 140;
  FEspacamento := 170;
  FSemente := 1225;
  Width := 300;
  Height := 200;
end;

procedure TFlocosNeve.SetCorFlocos(Valor: TColor);
begin
  FCorFlocos := Valor;
  Invalidate;
end;

procedure TFlocosNeve.SetOpacidade(Valor: Byte);
begin
  FOpacidade := Valor;
  Invalidate;
end;

procedure TFlocosNeve.SetEspacamento(Valor: Integer);
begin
  FEspacamento := EnsureRange(Valor, 20, 2000);
  Invalidate;
end;

procedure TFlocosNeve.SetSemente(Valor: Integer);
begin
  FSemente := Valor;
  Invalidate;
end;

procedure TFlocosNeve.Desenhar(G: TGPGraphics);
var
  Caneta: TGPPen;
  Semente: Cardinal;
  I, Qtde, K, Passo: Integer;
  CX, CY, Raio, Ang, PX, PY, BX, BY: Single;

  function Proximo(Limite: Integer): Integer;
  begin
    // Sequência fixa: o mesmo desenho em toda pintura
    Semente := Semente * 1103515245 + 12345;
    Result := Integer((Semente shr 8) mod Cardinal(Max(1, Limite)));
  end;

begin
  Caneta := TGPPen.Create(CorGP(FCorFlocos, FOpacidade), Max(1, E(1)) * 1.2);
  try
    Caneta.SetStartCap(LineCapRound);
    Caneta.SetEndCap(LineCapRound);
    Semente := Cardinal(FSemente);
    Passo := Max(1, EI(FEspacamento));
    Qtde := Max(3, Round((Width / Passo) * (Height / Passo)));
    for I := 1 to Qtde do
    begin
      CX := Proximo(Width);
      CY := Proximo(Height);
      Raio := E(5) + Proximo(EI(9));
      // Seis braços, cada um com dois raminhos
      for K := 0 to 5 do
      begin
        Ang := K * Pi / 3 + I * 0.4;
        PX := CX + Raio * Cos(Ang);
        PY := CY + Raio * Sin(Ang);
        G.DrawLine(Caneta, CX, CY, PX, PY);
        BX := CX + Raio * 0.6 * Cos(Ang);
        BY := CY + Raio * 0.6 * Sin(Ang);
        G.DrawLine(Caneta, BX, BY, BX + Raio * 0.3 * Cos(Ang + 0.8), BY + Raio * 0.3 * Sin(Ang + 0.8));
        G.DrawLine(Caneta, BX, BY, BX + Raio * 0.3 * Cos(Ang - 0.8), BY + Raio * 0.3 * Sin(Ang - 0.8));
      end;
    end;
  finally
    Caneta.Free;
  end;
end;

{ TGorroNatal }

constructor TGorroNatal.Create(AOwner: TComponent);
begin
  inherited;
  FCorGorro := $002F2FD3;
  FInclinacao := -18;
  Width := 64;
  Height := 52;
end;

procedure TGorroNatal.SetCorGorro(Valor: TColor);
begin
  FCorGorro := Valor;
  Invalidate;
end;

procedure TGorroNatal.SetInclinacao(Valor: Integer);
begin
  FInclinacao := EnsureRange(Valor, -90, 90);
  Invalidate;
end;

procedure TGorroNatal.Desenhar(G: TGPGraphics);
var
  Caminho: TGPGraphicsPath;
  Pincel: TGPLinearGradientBrush;
  Branco: TGPSolidBrush;
  Borda: TGPPen;
  W, H, Aba, R: Single;
begin
  W := Width;
  H := Height;
  // Inclinado, como se estivesse "vestido"
  G.TranslateTransform(W / 2, H / 2);
  G.RotateTransform(FInclinacao);
  G.TranslateTransform(-W / 2, -H / 2);

  Aba := H * 0.26;
  // Corpo, com a ponta caindo para a direita
  Caminho := TGPGraphicsPath.Create;
  Pincel := TGPLinearGradientBrush.Create(Ponto(0, 0), Ponto(W, H), CorGP(FCorGorro),
    Tom(FCorGorro, -0.35));
  try
    Caminho.StartFigure;
    Caminho.AddBezier(W * 0.10, H - Aba, W * 0.18, H * 0.05, W * 0.70, -H * 0.05, W * 0.88, H * 0.42);
    Caminho.AddBezier(W * 0.88, H * 0.42, W * 0.80, H * 0.55, W * 0.78, H * 0.62, W * 0.80, H - Aba);
    Caminho.CloseFigure;
    G.FillPath(Pincel, Caminho);
  finally
    Pincel.Free;
    Caminho.Free;
  end;

  Branco := TGPSolidBrush.Create(cBranco);
  Borda := TGPPen.Create(MakeColor(255, 224, 224, 224), 1);
  try
    // Aba de pelúcia
    Caminho := TGPGraphicsPath.Create;
    try
      Caminho.AddArc(W * 0.02, H - Aba - 1, Aba, Aba - 1, 90, 180);
      Caminho.AddArc(W * 0.92 - Aba, H - Aba - 1, Aba, Aba - 1, 270, 180);
      Caminho.CloseFigure;
      G.FillPath(Branco, Caminho);
      G.DrawPath(Borda, Caminho);
    finally
      Caminho.Free;
    end;
    // Pompom
    R := H * 0.13;
    G.FillEllipse(Branco, W * 0.88 - R, H * 0.42 - R, 2 * R, 2 * R);
    G.DrawEllipse(Borda, W * 0.88 - R, H * 0.42 - R, 2 * R, 2 * R);
  finally
    Borda.Free;
    Branco.Free;
  end;
  G.ResetTransform;
end;

{ TGuirlanda }

constructor TGuirlanda.Create(AOwner: TComponent);
begin
  inherited;
  FCorLaco := $002F2FD3;
  Width := 120;
  Height := 120;
  Intervalo := 700;
end;

procedure TGuirlanda.SetCorLaco(Valor: TColor);
begin
  FCorLaco := Valor;
  Invalidate;
end;

procedure TGuirlanda.Desenhar(G: TGPGraphics);
const
  N = 30;
  Folhas: array[0..2] of Cardinal = (cVerdeEscuro, cVerde, cVerdeClaro);
var
  S, CX, CY, R, Ra, A, X, Y, L, LW, RB, BX, BY: Single;
  Anel, I, K, J: Integer;
  Estado: GraphicsState;
  Laco, LacoEscuro: Cardinal;
begin
  S := Min(Width, Height);
  CX := Width / 2;
  CY := Height / 2 - S * 0.04;
  R := S * 0.31;
  L := S * 0.13;
  LW := S * 0.055;

  // Folhas em três anéis, giradas ao longo do círculo
  for Anel := 0 to 2 do
  begin
    Ra := R + (Anel - 1) * S * 0.07;
    for I := 0 to N - 1 do
    begin
      A := (I + Anel * 0.5) * 2 * Pi / N;
      X := CX + Ra * Cos(A);
      Y := CY + Ra * Sin(A);
      Estado := G.Save;
      try
        G.TranslateTransform(X, Y);
        if Odd(I) then
          G.RotateTransform(RadToDeg(A) + 125)
        else
          G.RotateTransform(RadToDeg(A) + 55);
        Elipse(G, Folhas[(I + Anel) mod 3], -L / 2, -LW / 2, L, LW);
      finally
        G.Restore(Estado);
      end;
    end;
  end;

  // Frutinhas em cachos de três
  RB := Max(E(1.5), S * 0.022);
  for K := 0 to 7 do
  begin
    A := K * Pi / 4 + Pi / 8;
    X := CX + R * Cos(A);
    Y := CY + R * Sin(A);
    for J := 0 to 2 do
      Bola(G, cVermelho, X + RB * 1.2 * Cos(J * 2 * Pi / 3), Y + RB * 1.2 * Sin(J * 2 * Pi / 3), RB,
        Animado and ((K + FQuadro) mod 2 = 0));
  end;

  // Laço embaixo
  Laco := CorGP(FCorLaco);
  LacoEscuro := Tom(FCorLaco, -0.35);
  BX := CX;
  BY := CY + R - S * 0.01;
  Poligono(G, LacoEscuro, [Ponto(BX - S * 0.02, BY), Ponto(BX - S * 0.12, BY + S * 0.18),
    Ponto(BX - S * 0.07, BY + S * 0.165), Ponto(BX + S * 0.005, BY + S * 0.02)]);
  Poligono(G, LacoEscuro, [Ponto(BX + S * 0.02, BY), Ponto(BX + S * 0.12, BY + S * 0.18),
    Ponto(BX + S * 0.07, BY + S * 0.165), Ponto(BX - S * 0.005, BY + S * 0.02)]);
  for I := 0 to 1 do
  begin
    Estado := G.Save;
    try
      G.TranslateTransform(BX, BY);
      if I = 0 then
      begin
        G.RotateTransform(-20);
        Elipse(G, Laco, -S * 0.17, -S * 0.06, S * 0.17, S * 0.12);
        Elipse(G, LacoEscuro, -S * 0.12, -S * 0.025, S * 0.08, S * 0.05);
      end
      else
      begin
        G.RotateTransform(20);
        Elipse(G, Laco, 0, -S * 0.06, S * 0.17, S * 0.12);
        Elipse(G, LacoEscuro, S * 0.04, -S * 0.025, S * 0.08, S * 0.05);
      end;
    finally
      G.Restore(Estado);
    end;
  end;
  Elipse(G, Laco, BX - S * 0.035, BY - S * 0.035, S * 0.07, S * 0.07);
end;

{ TNeveCaindo }

constructor TNeveCaindo.Create(AOwner: TComponent);
begin
  inherited;
  CliqueAtravessa := True;
  FQuantidade := 60;
  FCorNeve := $00E6D8C8;
  FOpacidade := 210;
  FVelocidade := 3;
  FSorteio := 1225;
  Width := 300;
  Height := 200;
  Intervalo := 40;
  Animado := True;
end;

function TNeveCaindo.Sortear: Single;
begin
  FSorteio := FSorteio * 1103515245 + 12345;
  Result := ((FSorteio shr 8) and $FFFF) / 65535;
end;

procedure TNeveCaindo.Gerar;
var
  I: Integer;
begin
  FLarguraGerada := Width;
  FAlturaGerada := Height;
  SetLength(FFlocos, FQuantidade);
  for I := 0 to FQuantidade - 1 do
  begin
    FFlocos[I].X := Sortear * Width;
    FFlocos[I].Y := Sortear * Height;
    FFlocos[I].R := E(1.5) + Sortear * E(3);
    // Flocos maiores caem mais rápido (sensação de profundidade)
    FFlocos[I].V := E(0.35) + FFlocos[I].R / E(4.5) * E(0.9);
    FFlocos[I].Fase := Sortear * 2 * Pi;
  end;
end;

procedure TNeveCaindo.SetQuantidade(Valor: Integer);
begin
  FQuantidade := EnsureRange(Valor, 0, 1000);
  FLarguraGerada := -1;
  Invalidate;
end;

procedure TNeveCaindo.SetCorNeve(Valor: TColor);
begin
  FCorNeve := Valor;
  Invalidate;
end;

procedure TNeveCaindo.SetOpacidade(Valor: Byte);
begin
  FOpacidade := Valor;
  Invalidate;
end;

procedure TNeveCaindo.SetVelocidade(Valor: Integer);
begin
  FVelocidade := EnsureRange(Valor, 1, 10);
end;

procedure TNeveCaindo.Avancar;
var
  I: Integer;
begin
  Inc(FQuadro);
  for I := 0 to High(FFlocos) do
    with FFlocos[I] do
    begin
      Y := Y + V * FVelocidade / 3;
      X := X + Sin(Fase + FQuadro * 0.04) * E(0.35);
      if Y - R > Height then
      begin
        Y := -R;
        X := Sortear * Width;
      end;
      if X < -R then
        X := Width + R
      else if X > Width + R then
        X := -R;
    end;
  Invalidate;
end;

procedure TNeveCaindo.Desenhar(G: TGPGraphics);
var
  I: Integer;
begin
  if (FLarguraGerada <> Width) or (FAlturaGerada <> Height) or (Length(FFlocos) <> FQuantidade) then
    Gerar;
  for I := 0 to High(FFlocos) do
    with FFlocos[I] do
    begin
      Elipse(G, CorGP(FCorNeve, FOpacidade div 4), X - R * 1.8, Y - R * 1.8, R * 3.6, R * 3.6);
      Elipse(G, CorGP(FCorNeve, FOpacidade), X - R, Y - R, R * 2, R * 2);
    end;
end;

{ TSeloNatal }

constructor TSeloNatal.Create(AOwner: TComponent);
begin
  inherited;
  FTexto := 'Feliz Natal e Boas Festas!';
  FCorFundo := $00E5E5F8;
  FCorBorda := $009EC69C;
  ParentFont := False;
  Font.Name := 'Segoe UI';
  Font.Size := 9;
  Font.Style := [fsBold];
  Font.Color := $002D2A8B;
  Width := 220;
  Height := 26;
end;

procedure TSeloNatal.SetTexto(const Valor: string);
begin
  FTexto := Valor;
  AdjustSize;
  Invalidate;
end;

procedure TSeloNatal.SetCorFundo(Valor: TColor);
begin
  FCorFundo := Valor;
  Invalidate;
end;

procedure TSeloNatal.SetCorBorda(Valor: TColor);
begin
  FCorBorda := Valor;
  Invalidate;
end;

procedure TSeloNatal.CMFontChanged(var Msg: TMessage);
begin
  inherited;
  AdjustSize;
  Invalidate;
end;

function TSeloNatal.LarguraIdeal: Integer;
var
  Medida: TBitmap;
begin
  // Mede num bitmap: funciona mesmo antes de o controle ter um pai
  Medida := TBitmap.Create;
  try
    Medida.Canvas.Font.Assign(Font);
    Result := EI(38) + Medida.Canvas.TextWidth(FTexto) + EI(14);
  finally
    Medida.Free;
  end;
end;

function TSeloNatal.CanAutoSize(var NewWidth, NewHeight: Integer): Boolean;
begin
  Result := True;
  NewWidth := LarguraIdeal;
end;

procedure TSeloNatal.Desenhar(G: TGPGraphics);
var
  Fundo: TGPSolidBrush;
  Borda: TGPPen;
  Caminho: TGPGraphicsPath;
  W, H, R, AX, AY, AW, AH: Single;
  I: Integer;

  procedure Triangulo(Topo, Base, Meia: Single; ACor: Cardinal);
  begin
    Poligono(G, ACor, [Ponto(AX + AW / 2, Topo), Ponto(AX + AW / 2 - Meia, Base),
      Ponto(AX + AW / 2 + Meia, Base)]);
  end;

begin
  W := Width - 1;
  H := Height - 1;
  R := H;
  // Pílula
  Caminho := TGPGraphicsPath.Create;
  Fundo := TGPSolidBrush.Create(CorGP(FCorFundo));
  Borda := TGPPen.Create(CorGP(FCorBorda), 1);
  try
    Caminho.AddArc(0.0, 0.0, R, R, 90, 180);
    Caminho.AddArc(W - R, 0.0, R, R, 270, 180);
    Caminho.CloseFigure;
    G.FillPath(Fundo, Caminho);
    G.DrawPath(Borda, Caminho);
  finally
    Borda.Free;
    Fundo.Free;
    Caminho.Free;
  end;

  // Árvore: três camadas, tronco, estrela e bolinhas
  AX := E(11);
  AW := E(18);
  AY := E(3);
  AH := H - E(6);
  Elipse(G, cMarrom, AX + AW / 2 - E(2), AY + AH - E(4), E(4), E(5));
  Triangulo(AY + AH * 0.40, AY + AH * 0.86, AW / 2, cVerde);
  Triangulo(AY + AH * 0.22, AY + AH * 0.62, AW * 0.40, cVerdeClaro);
  Triangulo(AY + AH * 0.06, AY + AH * 0.40, AW * 0.30, cVerde);
  Elipse(G, cDourado, AX + AW / 2 - E(3), AY - E(1), E(6), E(6));
  for I := 0 to 2 do
    Elipse(G, cVermelho, AX + AW * (0.28 + I * 0.22) - E(1), AY + AH * (0.74 - (I mod 2) * 0.22),
      E(3), E(3));
end;

procedure TSeloNatal.DesenharTexto;
var
  R: TRect;
begin
  Canvas.Brush.Style := bsClear;
  Canvas.Font.Assign(Font);
  R := Rect(EI(36), 0, Width - EI(8), Height);
  DrawText(Canvas.Handle, PChar(FTexto), -1, R, DT_LEFT or DT_VCENTER or DT_SINGLELINE or
    DT_NOPREFIX or DT_END_ELLIPSIS);
end;

end.
