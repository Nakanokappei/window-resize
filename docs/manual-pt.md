# Window Resize — Manual do Utilizador

## Sumario

1. [Configuracao inicial](#configuracao-inicial)
2. [Redimensionamento por encaixe](#redimensionamento-por-encaixe)
3. [Atalhos de teclado](#atalhos-de-teclado)
4. [Configuracoes](#configuracoes)
5. [Solucao de problemas](#solucao-de-problemas)

---

## Configuracao inicial

### Conceder permissao de acessibilidade

Window Resize utiliza a API de acessibilidade do macOS para detetar e redimensionar janelas. Voce deve conceder a permissao na primeira vez que iniciar o aplicativo.

1. Inicie o **Window Resize**. Um dialogo do sistema aparecera solicitando acesso a acessibilidade.
2. Clique em **"Abrir Ajustes do Sistema"** (ou va manualmente para **Ajustes do Sistema > Privacidade e Seguranca > Acessibilidade**).
3. Encontre **"Window Resize"** na lista e ative o interruptor.
4. Retorne ao aplicativo — o icone na barra de menus aparecera e o app estara pronto para uso.

> **Nota:** Se o dialogo nao aparecer, voce pode abrir as configuracoes de acessibilidade diretamente pela janela de Configuracoes do aplicativo (consulte [Status da acessibilidade](#status-da-acessibilidade)).

---

## Redimensionamento por encaixe

### Como funciona

O Window Resize monitora operacoes de redimensionamento de janelas em tempo real. Quando voce arrasta a borda ou o canto de uma janela para redimensiona-la, o aplicativo deteta a proximidade das dimensoes da janela a qualquer tamanho predefinido.

1. **Comece a redimensionar** — arraste a borda ou o canto de qualquer janela normalmente.
2. **A sobreposicao aparece** — quando o tamanho da janela se aproxima de um tamanho predefinido (dentro de 30 pixels), uma borda colorida aparece ao redor da janela indicando o tamanho predefinido de destino.
3. **Solte para encaixar** — solte o mouse e a janela se ajusta automaticamente ao tamanho predefinido com precisao.
4. **Cancelar** — se voce afastar o tamanho da janela do tamanho predefinido antes de soltar, a sobreposicao desaparece e nenhum encaixe ocorre.

### Encaixe por movimento

Arraste uma janela em direcao a uma borda ou canto da tela para encaixa-la na posicao:

- **Encaixe de borda** (esquerda/direita) — preenche a altura, preserva a largura
- **Encaixe de borda** (cima/baixo) — preenche a largura, preserva a altura
- **Encaixe de canto** — posiciona a janela no canto, preserva ambas as dimensoes

### Exibicao da proporcao

Durante o redimensionamento, a proporcao atual e exibida na sobreposicao. Quando a proporcao corresponde a uma proporcao conhecida, seu nome e mostrado:

- **Proporcao aurea** (1.618:1)
- **Proporcao de prata** (2.414:1)
- **Proporcao de platina** (1.325:1)
- **Proporcao de bronze** (3.303:1)

Outras proporcoes sao exibidas como fracoes simplificadas (por exemplo, "16:9", "4:3").

> Este recurso pode ser desativado nas Configuracoes (consulte [Aba Aparencia](#aba-aparencia)).

### Shift para travar a proporcao

Mantenha a tecla **Shift** pressionada durante o redimensionamento para travar a proporcao. A janela mantera suas proporcoes atuais enquanto voce arrasta.

> Este recurso pode ser desativado nas Configuracoes (consulte [Aba Aparencia](#aba-aparencia)).

---

## Atalhos de teclado

Todos os atalhos de teclado sao totalmente personalizaveis na aba Atalhos das Configuracoes. Padroes:

### Presets rapidos

Pressione **Control+Option+1** ate **Control+Option+9** para redimensionar instantaneamente a janela ativa para um preset nomeado. Um HUD centralizado mostra brevemente o nome e o tamanho do preset.

| Atalho | Preset padrao |
|--------|--------------|
| Control+Option+1 | Writing (1280 x 800) |
| Control+Option+2 | Reading (900 x 1200) |
| Control+Option+3 | Browsing (1440 x 900) |
| Control+Option+4 | Sidebar (720 x 900) |
| Control+Option+5 | Preview (1920 x 1080) |

Os Presets rapidos podem ser editados (rotulo, tamanho e atalho) na aba Geral das Configuracoes. Ate 9 presets sao suportados.

### Redimensionamento incremental

Redimensione a janela ativa em 10 pixels por pressionamento de tecla, mantendo a janela centralizada:

| Atalho | Acao |
|--------|------|
| Control+Option+Right | Aumentar largura (+10px) |
| Control+Option+Left | Reduzir largura (-10px) |
| Control+Option+Up | Aumentar altura (+10px) |
| Control+Option+Down | Reduzir altura (-10px) |

### Modo de precisao

Segure Shift para ajustes de 1 pixel:

| Atalho | Acao |
|--------|------|
| Control+Option+Shift+Right | Aumentar largura (+1px) |
| Control+Option+Shift+Left | Reduzir largura (-1px) |
| Control+Option+Shift+Up | Aumentar altura (+1px) |
| Control+Option+Shift+Down | Reduzir altura (-1px) |

### Desfazer / Refazer

| Atalho | Acao |
|--------|------|
| Control+Option+Z | Desfazer ultimo redimensionamento |
| Control+Option+Shift+Z | Refazer |

Cada janela mantem seu proprio historico de desfazer/refazer.

### Feedback HUD

Quando voce usa um atalho de teclado, um HUD centralizado aparece na janela de destino:

- **Preset rapido:** mostra o nome do preset (por exemplo, "Writing") com o tamanho abaixo (por exemplo, "1280 x 800")
- **Redimensionamento incremental:** mostra o tamanho atual (por exemplo, "1290 x 800")
- **Desfazer:** mostra "Restored" com o tamanho restaurado

O HUD e exibido por 0,8 segundos e depois desaparece.

---

## Configuracoes

Abra as Configuracoes pela barra de menus: clique no icone do Window Resize e selecione **"Configuracoes..."**.

As Configuracoes estao organizadas em 4 abas: **Geral**, **Aparencia**, **Atalhos** e **Presets**.

### Aba Geral

#### Presets rapidos

Configure ate 9 Presets rapidos que podem ser aplicados via atalhos de teclado (Control+Option+1-9). Cada preset tem:

- **Atalho** — clique no campo de atalho para gravar uma nova combinacao de teclas
- **Rotulo** — um nome descritivo (por exemplo, "Writing", "Coding")
- **Tamanho** — largura e altura em pixels

Para adicionar um preset, preencha os campos de rotulo, largura e altura na parte inferior e clique em **"Adicionar"**. Para remover um preset, clique no botao X ao lado dele.

#### Iniciar ao fazer login

Ative **"Iniciar ao fazer login"** para que o Window Resize inicie automaticamente quando voce fizer login no macOS.

#### Idioma

Selecione o idioma de exibicao do aplicativo no menu suspenso. Escolha entre 16 idiomas ou **"Padrao do sistema"** para seguir o idioma do macOS. A alteracao do idioma requer reiniciar o aplicativo.

#### Status da acessibilidade

Um indicador de status mostra o estado atual da permissao de acessibilidade:

| Indicador | Significado |
|-----------|-------------|
| Verde | A permissao esta ativa e funcionando corretamente. |
| Laranja | A permissao foi concedida mas nao e mais valida (consulte [Corrigir permissoes obsoletas](#corrigir-permissoes-obsoletas)). |
| Vermelho | A permissao nao foi concedida. |

### Aba Aparencia

Configure o estilo visual da sobreposicao de encaixe:

- **Borda de redimensionamento** — a cor e o estilo da linha da borda exibida ao redimensionar. Escolha entre 9 cores (vermelho, laranja, amarelo, verde, ciano, azul, roxo, branco, cinza) e 4 estilos (nenhum, solida, tracejada, animada). Padrao: branco, animada.
- **Borda de encaixe** — a borda exibida quando a janela se encaixa em um tamanho predefinido. Padrao: branco, solida.
- **Mostrar proporcao** — ativar ou desativar o rotulo de proporcao na sobreposicao. Padrao: ativado.
- **Shift para travar a proporcao** — ativar ou desativar se manter Shift pressionado trava a proporcao. Padrao: ativado.

### Aba Atalhos

Todos os atalhos de teclado sao exibidos em uma grade de 2 colunas e podem ser personalizados individualmente:

1. Clique no campo de atalho ao lado de qualquer acao.
2. Pressione a combinacao de teclas desejada (deve incluir pelo menos uma tecla modificadora).
3. Pressione **Escape** para cancelar a gravacao.

Se voce gravar um atalho que entra em conflito com outra acao no aplicativo, um dialogo de alerta aparece oferecendo **Substituir** (reatribuir o atalho) ou **Cancelar**.

Um icone de aviso aparece ao lado de atalhos que entram em conflito com atalhos do sistema conhecidos (Mission Control, Spotlight, etc.).

Clique em **"Restaurar padroes"** para restaurar todos os atalhos as suas atribuicoes originais.

### Aba Presets

A aba Presets mostra 18 tamanhos predefinidos integrados ordenados por area de pixels (do menor ao maior). Cada preset tem um interruptor de ativar/desativar:

- **Ativado** — o preset e usado para detecao de encaixe durante o redimensionamento
- **Desativado** — o preset e excluido da detecao de encaixe (exibido com 50% de opacidade)

Os presets integrados nao podem ser removidos, apenas desativados. Por padrao, 6 presets especificos de Mac (tamanhos de tela MacBook Air/Pro) estao desativados, e 12 presets de uso geral estao ativados.

O cabecalho mostra quantos presets estao atualmente ativados (por exemplo, "12 of 18 enabled").

---

## Solucao de problemas

### Corrigir permissoes obsoletas

Se voce vir um indicador de status laranja ou a mensagem "Acessibilidade: Precisa Atualizar", a permissao se tornou obsoleta. Isso pode acontecer apos uma atualizacao ou reconstrucao do aplicativo.

**Para corrigir:**

1. Abra **Ajustes do Sistema > Privacidade e Seguranca > Acessibilidade**.
2. Encontre **"Window Resize"** na lista.
3. Desative o interruptor e **ative-o** novamente.
4. Alternativamente, remova-o completamente da lista e reinicie o aplicativo para adiciona-lo novamente.

### O encaixe nao funciona

Se a sobreposicao nao aparecer durante o redimensionamento:

- Verifique se a permissao de acessibilidade esta ativa (indicador verde nas Configuracoes).
- Certifique-se de que a janela que voce esta redimensionando suporta redimensionamento padrao (alguns aplicativos restringem o tamanho das janelas).
- Janelas em tela cheia nao podem ser redimensionadas — saia do modo tela cheia primeiro.
- Verifique a aba Presets — o tamanho de destino pode estar desativado.

### Problemas de renderizacao apos o encaixe

Em casos raros, a janela de destino pode nao redesenhar corretamente apos o encaixe. O aplicativo forca automaticamente um redesenho, mas se artefatos visuais persistirem, tente minimizar e restaurar a janela.
