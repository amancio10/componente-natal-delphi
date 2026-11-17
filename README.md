# componente-natal-delphi

Pacote de componentes VCL com enfeites de Natal para Delphi (paleta **Natal-Amancio**).
Tudo é desenhado com GDI+ (bordas suaves), sem imagens externas e sem dependências além da VCL.

![Exemplo dos componentes em uso](Imagens/Exemplo.png)

## Componentes

| Componente         | Descrição                                                         |
| ------------------ | ----------------------------------------------------------------- |
| `TPiscaPisca`      | Cordão de luzes coloridas piscando em sequência                   |
| `TArvoreNatal`     | Árvore com bolinhas que piscam, estrela e presentes               |
| `TBolasPenduradas` | Bolas penduradas em fios, balançando de leve                      |
| `TContagemNatal`   | "Faltam N dias para o Natal" (no dia 25: "Feliz Natal!")          |
| `TEstrelaBrilho`   | Estrelinhas que brilham em pontos aleatórios                      |
| `TFaixaNatal`      | Faixa listrada (bengala ou cores natalinas)                       |
| `TFlocosNeve`      | Flocos de neve parados, discretos, para fundos                    |
| `TGorroNatal`      | Gorro de Papai Noel (canto de logo/avatar)                        |
| `TGuirlanda`       | Coroa de folhas com frutinhas e laço                              |
| `TNeveCaindo`      | Neve caindo devagar (os cliques passam para o que está atrás)     |
| `TSeloNatal`       | Selo "Feliz Natal" com árvore desenhada                           |

## Requisitos

- Delphi 10.3 Rio ou superior (o pacote foi salvo no Delphi 12 Athens).
- Aplicação VCL (Windows).

## Estrutura do repositório

```
componente-natal-delphi/
├── Componente Natal/        pacote do componente
│   ├── NatalAmancio.dpk     pacote (design-time + runtime)
│   ├── NatalAmancio.dproj
│   ├── NatalAmancio.dcr     ícones da paleta
│   ├── uEnfeitesNatal.pas   enfeites
│   ├── uPiscaPisca.pas      pisca-pisca
│   └── uNatalAmancioReg.pas registro na paleta
├── Projeto exemplo/         aplicação de demonstração
└── Imagens/Exemplo.png
```

## Instalação

### 1. Baixar o código

Clone o repositório ou baixe o ZIP pelo GitHub e extraia em uma pasta fixa
(evite mover a pasta depois de instalar, pois o Delphi guarda o caminho):

```
git clone https://github.com/amancio10/componente-natal-delphi.git
```

### 2. Abrir o pacote

1. Abra o Delphi.
2. Vá em **File > Open...** e selecione `Componente Natal\NatalAmancio.dproj`
   (ou o `NatalAmancio.dpk`).

### 3. Compilar e instalar

1. No **Projects** (Project Manager), confirme que a plataforma ativa é **Windows 32-bit**
   — a IDE do Delphi é 32 bits e só instala pacotes Win32.
2. Clique com o botão direito em `NatalAmancio.bpl` e escolha **Compile**.
3. Clique novamente com o botão direito e escolha **Install**.
4. Deve aparecer a mensagem informando que o pacote foi instalado e os
   componentes registrados (`TPiscaPisca`, `TArvoreNatal`, ...).

### 4. Adicionar a pasta ao Library Path

Para que seus projetos encontrem as units do componente:

1. Vá em **Tools > Options > Language > Delphi > Library**
   (em versões mais antigas: **Tools > Options > Delphi Options > Library**).
2. Selecione a plataforma **Windows 32-bit** e, em **Library path**, clique em **...**.
3. Adicione o caminho da pasta `Componente Natal`, por exemplo:
   `C:\Componentes\componente-natal-delphi\Componente Natal`
4. Repita para **Windows 64-bit** se for compilar aplicações 64 bits.
5. Clique em **Save** / **OK**.

### 5. Conferir na paleta

Abra (ou crie) uma aplicação VCL. Na **Tool Palette** aparecerá a aba
**Natal-Amancio** com todos os enfeites. Basta arrastar para o formulário.

## Uso

Pelo designer, basta soltar o componente no form. Por código:

```pascal
uses
  uPiscaPisca, uEnfeitesNatal;

procedure TForm1.FormCreate(Sender: TObject);
var
  Luzes: TPiscaPisca;
begin
  Luzes := TPiscaPisca.Create(Self);
  Luzes.Parent := Self;     // ou um TPanel
  Luzes.Align := alTop;     // ocupa a largura; altura padrão 24 px
end;
```

### Propriedades comuns

| Propriedade             | Descrição                                                            |
| ----------------------- | -------------------------------------------------------------------- |
| `SoNaEpoca`             | Se `True`, em tempo de execução o enfeite só aparece de 1º/11 a 6/1  |
| `Transparente`          | Não pinta o fundo (para usar sobre imagens/degradês)                 |
| `Animado`               | Liga/desliga a animação (no `TPiscaPisca` a propriedade é `Piscando`) |
| `Intervalo`             | Velocidade da animação, em milissegundos                             |
| `Color` / `ParentColor` | Cor de fundo, quando não é transparente                              |

> **Observação:** como todo `TGraphicControl`, os enfeites ficam atrás de controles
> com janela (`TEdit`, `TPanel`, `TButton`...). Para colocar um enfeite sobre um painel,
> solte-o **dentro** do painel.

## Projeto de exemplo

A pasta `Projeto exemplo` contém uma aplicação de demonstração (`Natal.dproj`)
com os enfeites montados em uma tela, como na imagem acima.
Instale o pacote antes de abri-la.

## Desinstalação

1. **Component > Install Packages...**
2. Selecione **Enfeites de Natal (Natal-Amancio)** e clique em **Remove**.
3. Remova a pasta `Componente Natal` do Library Path.