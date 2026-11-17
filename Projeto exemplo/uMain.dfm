object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Painel de Natal - Natal-Amancio'
  ClientHeight = 740
  ClientWidth = 1180
  Color = 15725559
  Font.Charset = DEFAULT_CHARSET
  Font.Color = 3156516
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 17
  object FlocosNeve1: TFlocosNeve
    Left = 0
    Top = 148
    Width = 1180
    Height = 582
    Align = alClient
    Espacamento = 150
  end
  object PiscaPisca1: TPiscaPisca
    Left = 0
    Top = 120
    Width = 1180
    Height = 28
    Align = alTop
  end
  object FaixaRodape: TFaixaNatal
    Left = 0
    Top = 730
    Width = 1180
    Height = 10
    Align = alBottom
    Animado = True
    Estilo = efNatalino
  end
  object pnlTopo: TPanel
    Left = 0
    Top = 0
    Width = 1180
    Height = 120
    Align = alTop
    BevelOuter = bvNone
    Color = 4204058
    ParentBackground = False
    TabOrder = 0
    object NeveCaindo1: TNeveCaindo
      Left = 0
      Top = 0
      Width = 1180
      Height = 120
      Align = alClient
      Quantidade = 80
      CorNeve = clWhite
      Opacidade = 220
    end
    object EstrelaBrilho1: TEstrelaBrilho
      Left = 430
      Top = 6
      Width = 350
      Height = 108
      Quantidade = 18
    end
    object shpLogo: TShape
      Left = 28
      Top = 32
      Width = 60
      Height = 60
      Brush.Color = 5161458
      Pen.Style = psClear
      Shape = stCircle
    end
    object lblLogo: TLabel
      Left = 28
      Top = 32
      Width = 60
      Height = 60
      Alignment = taCenter
      AutoSize = False
      Caption = 'PN'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 4204058
      Font.Height = -22
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
      Layout = tlCenter
    end
    object GorroNatal1: TGorroNatal
      Left = 12
      Top = 12
      Width = 58
      Height = 46
    end
    object lblTitulo: TLabel
      Left = 108
      Top = 26
      Width = 220
      Height = 41
      Caption = 'Painel de Natal'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -30
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object lblSubtitulo: TLabel
      Left = 110
      Top = 70
      Width = 300
      Height = 19
      Caption = 'Campanha Polo Norte'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 14274760
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object ContagemNatal1: TContagemNatal
      Left = 790
      Top = 42
      Width = 366
      Height = 36
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -18
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Alinhamento = taRightJustify
    end
  end
  object pnlVendas: TPanel
    Left = 24
    Top = 168
    Width = 271
    Height = 116
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    object FaixaVendas: TFaixaNatal
      Left = 0
      Top = 0
      Width = 271
      Height = 6
      Align = alTop
    end
    object lblVendasTitulo: TLabel
      Left = 20
      Top = 20
      Width = 200
      Height = 17
      Caption = 'Vendas de Natal'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 8880506
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object lblVendasValor: TLabel
      Left = 20
      Top = 40
      Width = 220
      Height = 41
      Caption = 'R$ 182.450'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3156516
      Font.Height = -30
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object lblVendasRodape: TLabel
      Left = 20
      Top = 86
      Width = 200
      Height = 17
      Caption = #9650' 18% sobre o Natal de 2025'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3308846
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
  end
  object pnlPedidos: TPanel
    Left = 311
    Top = 168
    Width = 271
    Height = 116
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 2
    object FaixaPedidos: TFaixaNatal
      Left = 0
      Top = 0
      Width = 271
      Height = 6
      Align = alTop
      Estilo = efNatalino
    end
    object lblPedidosTitulo: TLabel
      Left = 20
      Top = 20
      Width = 200
      Height = 17
      Caption = 'Pedidos'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 8880506
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object lblPedidosValor: TLabel
      Left = 20
      Top = 40
      Width = 220
      Height = 41
      Caption = '1.284'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3156516
      Font.Height = -30
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object lblPedidosRodape: TLabel
      Left = 20
      Top = 86
      Width = 200
      Height = 17
      Caption = #9650' 212 nesta semana'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3308846
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
  end
  object pnlEntregas: TPanel
    Left = 598
    Top = 168
    Width = 271
    Height = 116
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 3
    object FaixaEntregas: TFaixaNatal
      Left = 0
      Top = 0
      Width = 271
      Height = 6
      Align = alTop
    end
    object lblEntregasTitulo: TLabel
      Left = 20
      Top = 20
      Width = 200
      Height = 17
      Caption = 'Presentes entregues'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 8880506
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object lblEntregasValor: TLabel
      Left = 20
      Top = 40
      Width = 220
      Height = 41
      Caption = '1.193'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3156516
      Font.Height = -30
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object lblEntregasRodape: TLabel
      Left = 20
      Top = 86
      Width = 200
      Height = 17
      Caption = '96% dentro do prazo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3308846
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
  end
  object pnlClientes: TPanel
    Left = 885
    Top = 168
    Width = 271
    Height = 116
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 4
    object FaixaClientes: TFaixaNatal
      Left = 0
      Top = 0
      Width = 271
      Height = 6
      Align = alTop
      Estilo = efNatalino
    end
    object lblClientesTitulo: TLabel
      Left = 20
      Top = 20
      Width = 200
      Height = 17
      Caption = 'Clientes novos'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 8880506
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object lblClientesValor: TLabel
      Left = 20
      Top = 40
      Width = 220
      Height = 41
      Caption = '312'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3156516
      Font.Height = -30
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object lblClientesRodape: TLabel
      Left = 20
      Top = 86
      Width = 200
      Height = 17
      Caption = #9650' 9% sobre novembro'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3308846
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
  end
  object pnlArvore: TPanel
    Left = 24
    Top = 304
    Width = 360
    Height = 400
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 5
    object lblArvoreTitulo: TLabel
      Left = 22
      Top = 20
      Width = 300
      Height = 23
      Caption = #193'rvore da equipe'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3156516
      Font.Height = -17
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object lblArvoreSub: TLabel
      Left = 22
      Top = 46
      Width = 300
      Height = 17
      Caption = 'Cada bolinha acesa '#233' uma meta batida'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 8880506
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object ArvoreNatal1: TArvoreNatal
      Left = 60
      Top = 78
      Width = 240
      Height = 304
    end
  end
  object pnlMetas: TPanel
    Left = 400
    Top = 304
    Width = 420
    Height = 400
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 6
    object BolasPenduradas1: TBolasPenduradas
      Left = 240
      Top = 0
      Width = 170
      Height = 92
      Quantidade = 4
    end
    object lblMetasTitulo: TLabel
      Left = 22
      Top = 20
      Width = 200
      Height = 23
      Caption = 'Metas da campanha'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3156516
      Font.Height = -17
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object lblMetasSub: TLabel
      Left = 22
      Top = 46
      Width = 200
      Height = 17
      Caption = 'Progresso de dezembro'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 8880506
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object lblMeta1: TLabel
      Left = 22
      Top = 110
      Width = 250
      Height = 17
      Caption = 'Vendas online'
      Transparent = True
    end
    object lblMeta1Valor: TLabel
      Left = 330
      Top = 110
      Width = 68
      Height = 17
      Alignment = taRightJustify
      AutoSize = False
      Caption = '0%'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3156516
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object shpMeta1Trilho: TShape
      Left = 22
      Top = 134
      Width = 376
      Height = 10
      Brush.Color = 15592173
      Pen.Style = psClear
      Shape = stRoundRect
    end
    object shpMeta1: TShape
      Left = 22
      Top = 134
      Width = 0
      Height = 10
      Brush.Color = 3092435
      Pen.Style = psClear
      Shape = stRoundRect
    end
    object lblMeta2: TLabel
      Left = 22
      Top = 172
      Width = 250
      Height = 17
      Caption = 'Entregas no prazo'
      Transparent = True
    end
    object lblMeta2Valor: TLabel
      Left = 330
      Top = 172
      Width = 68
      Height = 17
      Alignment = taRightJustify
      AutoSize = False
      Caption = '0%'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3156516
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object shpMeta2Trilho: TShape
      Left = 22
      Top = 196
      Width = 376
      Height = 10
      Brush.Color = 15592173
      Pen.Style = psClear
      Shape = stRoundRect
    end
    object shpMeta2: TShape
      Left = 22
      Top = 196
      Width = 0
      Height = 10
      Brush.Color = 3308846
      Pen.Style = psClear
      Shape = stRoundRect
    end
    object lblMeta3: TLabel
      Left = 22
      Top = 234
      Width = 250
      Height = 17
      Caption = 'Cestas de Natal montadas'
      Transparent = True
    end
    object lblMeta3Valor: TLabel
      Left = 330
      Top = 234
      Width = 68
      Height = 17
      Alignment = taRightJustify
      AutoSize = False
      Caption = '0%'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3156516
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object shpMeta3Trilho: TShape
      Left = 22
      Top = 258
      Width = 376
      Height = 10
      Brush.Color = 15592173
      Pen.Style = psClear
      Shape = stRoundRect
    end
    object shpMeta3: TShape
      Left = 22
      Top = 258
      Width = 0
      Height = 10
      Brush.Color = 508415
      Pen.Style = psClear
      Shape = stRoundRect
    end
    object lblMeta4: TLabel
      Left = 22
      Top = 296
      Width = 250
      Height = 17
      Caption = 'Satisfa'#231#227'o dos clientes'
      Transparent = True
    end
    object lblMeta4Valor: TLabel
      Left = 330
      Top = 296
      Width = 68
      Height = 17
      Alignment = taRightJustify
      AutoSize = False
      Caption = '0%'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3156516
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object shpMeta4Trilho: TShape
      Left = 22
      Top = 320
      Width = 376
      Height = 10
      Brush.Color = 15592173
      Pen.Style = psClear
      Shape = stRoundRect
    end
    object shpMeta4: TShape
      Left = 22
      Top = 320
      Width = 0
      Height = 10
      Brush.Color = 16098626
      Pen.Style = psClear
      Shape = stRoundRect
    end
    object lblMetasRodape: TLabel
      Left = 22
      Top = 362
      Width = 300
      Height = 17
      Caption = 'Atualizado hoje'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 8880506
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
  end
  object pnlMensagem: TPanel
    Left = 836
    Top = 304
    Width = 320
    Height = 400
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 7
    object Guirlanda1: TGuirlanda
      Left = 80
      Top = 18
      Width = 160
      Height = 160
      Animado = True
    end
    object SeloNatal1: TSeloNatal
      Left = 50
      Top = 190
      Width = 220
      Height = 28
      AutoSize = True
    end
    object lblMensagem: TLabel
      Left = 24
      Top = 236
      Width = 272
      Height = 110
      Alignment = taCenter
      AutoSize = False
      Caption = 'Obrigado a toda a equipe por este ano incr'#237'vel! Que o Natal traga descanso, alegria e muitas conquistas em 2027.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3156516
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      Transparent = True
      WordWrap = True
    end
    object lblAssinatura: TLabel
      Left = 24
      Top = 356
      Width = 272
      Height = 19
      Alignment = taCenter
      AutoSize = False
      Caption = #8212' Equipe Polo Norte'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 8880506
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsItalic]
      ParentFont = False
      Transparent = True
    end
  end
  object tmrMetas: TTimer
    Interval = 30
    OnTimer = tmrMetasTimer
    Left = 1120
    Top = 680
  end
end
