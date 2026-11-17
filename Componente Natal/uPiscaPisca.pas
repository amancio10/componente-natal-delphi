unit uPiscaPisca;

{ Pisca-pisca de Natal (paleta "Natal-Amancio"). Cordão de luzes pendurado em
  arcos, com lâmpadas coloridas que acendem e apagam em sequência.

  Uso:
    uses uPiscaPisca;

    var Luzes: TPiscaPisca;
    Luzes := TPiscaPisca.Create(Self);
    Luzes.Parent := Self;        // ou um TPanel
    Luzes.Align := alTop;        // ocupa a largura; altura padrão 24 px

  Propriedades:
    Color / ParentColor  fundo (por padrão o do pai)
    Transparente         não pinta o fundo (sobre imagens/degradês)
    CorFio               cor do fio
    CorDestaque          quinta cor das lâmpadas (por padrão laranja)
    Intervalo            velocidade do pisca em ms (padrão 800)
    Piscando             liga/desliga a animação (lâmpadas ficam acesas)
    Comprimento          largura de cada arco do fio (padrão 132 px)
    SoNaEpoca            só aparece de 1º/11 a 6/1 (em tempo de execução)
}

interface

uses
  System.Classes, Vcl.Graphics, Winapi.GDIPOBJ, uEnfeitesNatal;

type
  TPiscaPisca = class(TEnfeiteNatal)
  private
    FCorFio: TColor;
    FCorDestaque: TColor;
    FComprimento: Integer;
    procedure SetCorFio(Valor: TColor);
    procedure SetCorDestaque(Valor: TColor);
    procedure SetComprimento(Valor: Integer);
  protected
    procedure Desenhar(G: TGPGraphics); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Transparente default False;
    property CorFio: TColor read FCorFio write SetCorFio default $00677280;
    property CorDestaque: TColor read FCorDestaque write SetCorDestaque default $003473EB;
    property Intervalo default 800;
    property Piscando: Boolean read GetAnimado write SetAnimado default True;
    property Comprimento: Integer read FComprimento write SetComprimento default 132;
  end;

implementation

uses
  System.Math;

{ TPiscaPisca }

constructor TPiscaPisca.Create(AOwner: TComponent);
begin
  inherited;
  Transparente := False;
  FCorFio := $00677280;      // #807267 (marrom acinzentado)
  FCorDestaque := $003473EB; // #EB7334 (laranja)
  FComprimento := 132;
  Width := 300;
  Height := EI(24);
  Intervalo := 800;
  Piscando := True;
end;

procedure TPiscaPisca.SetCorFio(Valor: TColor);
begin
  FCorFio := Valor;
  Invalidate;
end;

procedure TPiscaPisca.SetCorDestaque(Valor: TColor);
begin
  FCorDestaque := Valor;
  Invalidate;
end;

procedure TPiscaPisca.SetComprimento(Valor: Integer);
begin
  FComprimento := Max(Valor, 40);
  Invalidate;
end;

procedure TPiscaPisca.Desenhar(G: TGPGraphics);
var
  Fio: TGPPen;
  Seg, Sag, X0, CX, CY, T, W, H: Single;
  N, K: Integer;
  Lampada: Cardinal;
  Acesa: Boolean;
begin
  Fio := TGPPen.Create(CorGP(FCorFio, 150), Max(1, E(1)));
  try
    Seg := E(FComprimento);
    Sag := E(8);
    N := 0;
    X0 := -E(20);
    while X0 < Width do
    begin
      // Fio: arco entre dois ganchos na borda de cima
      G.DrawBezier(Fio, X0, 0, X0 + Seg / 3, Sag * 1.4, X0 + 2 * Seg / 3, Sag * 1.4, X0 + Seg, 0);
      // Três lâmpadas por arco, sobre a curva
      for K := 1 to 3 do
      begin
        T := K / 4;
        CX := X0 + Seg * T;
        CY := 3 * (1 - T) * T * (Sag * 1.4);
        // Soquete
        Elipse(G, CorGP(FCorFio, 230), CX - E(3), CY, E(6), E(5));
        case N mod 5 of
          0: Lampada := cVermelho;
          1: Lampada := cDourado;
          2: Lampada := cVerdeClaro;
          3: Lampada := CorGP(FCorDestaque);
        else
          Lampada := cAzul;
        end;
        // Uma em cada quatro fica apagada, andando a cada piscada
        Acesa := not Piscando or ((N + FQuadro) mod 4 <> 0);
        W := E(8);
        H := E(11);
        if Acesa then
        begin
          Elipse(G, ComAlfa(Lampada, $38), CX - W, CY + E(2), W * 2, H * 1.5); // brilho
          Elipse(G, Lampada, CX - W / 2, CY + E(4), W, H);
          Elipse(G, $96FFFFFF, CX - W / 4, CY + E(6), W / 3, H / 3);          // reflexo
        end
        else
          Elipse(G, ComAlfa(Lampada, $70), CX - W / 2, CY + E(4), W, H);
        Inc(N);
      end;
      X0 := X0 + Seg;
    end;
  finally
    Fio.Free;
  end;
end;

end.
