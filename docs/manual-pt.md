# Window Resize — Manual do Utilizador

## Sumário

1. [Configuração inicial](#configuração-inicial)
2. [Redimensionamento por encaixe](#redimensionamento-por-encaixe)
3. [Configurações](#configurações)
4. [Solução de problemas](#solução-de-problemas)

---

## Configuração inicial

### Conceder permissão de acessibilidade

Window Resize utiliza a API de acessibilidade do macOS para detetar e redimensionar janelas. Você deve conceder a permissão na primeira vez que iniciar o aplicativo.

1. Inicie o **Window Resize**. Um diálogo do sistema aparecerá solicitando acesso à acessibilidade.
2. Clique em **"Abrir Ajustes do Sistema"** (ou vá manualmente para **Ajustes do Sistema > Privacidade e Segurança > Acessibilidade**).
3. Encontre **"Window Resize"** na lista e ative o interruptor.
4. Retorne ao aplicativo — o ícone na barra de menus aparecerá e o app estará pronto para uso.

> **Nota:** Se o diálogo não aparecer, você pode abrir as configurações de acessibilidade diretamente pela janela de Configurações do aplicativo (consulte [Status da acessibilidade](#status-da-acessibilidade)).

---

## Redimensionamento por encaixe

### Como funciona

O Window Resize monitora operações de redimensionamento de janelas em tempo real. Quando você arrasta a borda ou o canto de uma janela para redimensioná-la, o aplicativo deteta a proximidade das dimensões da janela a qualquer tamanho predefinido.

1. **Comece a redimensionar** — arraste a borda ou o canto de qualquer janela normalmente.
2. **A sobreposição aparece** — quando o tamanho da janela se aproxima de um tamanho predefinido (dentro de 30 pixels), uma borda colorida aparece ao redor da janela indicando o tamanho predefinido de destino.
3. **Solte para encaixar** — solte o mouse e a janela se ajusta automaticamente ao tamanho predefinido com precisão.
4. **Cancelar** — se você afastar o tamanho da janela do tamanho predefinido antes de soltar, a sobreposição desaparece e nenhum encaixe ocorre.

### Exibição da proporção

Durante o redimensionamento, a proporção atual é exibida na sobreposição. Quando a proporção corresponde a uma proporção conhecida, seu nome é mostrado:

- **Proporção áurea** (1,618:1)
- **Proporção de prata** (2,414:1)
- **Proporção de platina** (1,325:1)
- **Proporção de bronze** (3,303:1)

Outras proporções são exibidas como frações simplificadas (por exemplo, "16:9", "4:3").

> Este recurso pode ser desativado nas Configurações (consulte [Aparência da sobreposição](#aparência-da-sobreposição)).

### Shift para travar a proporção

Mantenha a tecla **Shift** pressionada durante o redimensionamento para travar a proporção. A janela manterá suas proporções atuais enquanto você arrasta.

> Este recurso pode ser desativado nas Configurações (consulte [Shift para travar a proporção](#aparência-da-sobreposição)).

---

## Configurações

Abra as Configurações pela barra de menus: clique no ícone do Window Resize e selecione **"Configurações..."** (atalho: **Cmd+,**).

### Tamanhos integrados

O aplicativo inclui 12 tamanhos predefinidos integrados:

| Tamanho | Rótulo |
|---------|--------|
| 2560 x 1600 | MacBook Pro 16" |
| 2560 x 1440 | QHD / iMac |
| 1728 x 1117 | MacBook Pro 14" |
| 1512 x 982 | MacBook Air 15" |
| 1470 x 956 | MacBook Air 13" M3 |
| 1440 x 900 | MacBook Air 13" |
| 1920 x 1080 | Full HD |
| 1680 x 1050 | WSXGA+ |
| 1280 x 800 | WXGA |
| 1280 x 720 | HD |
| 1024 x 768 | XGA |
| 800 x 600 | SVGA |

Os tamanhos integrados não podem ser removidos ou editados.

### Tamanhos personalizados

Você pode adicionar seus próprios tamanhos à lista:

1. Na seção **"Personalizados"**, insira a **Largura** e a **Altura** em pixels.
2. Clique em **"Adicionar"**.
3. O novo tamanho estará disponível imediatamente para deteção de encaixe durante o redimensionamento.

Para remover um tamanho personalizado, clique no botão vermelho **"Remover"** ao lado dele.

### Aparência da sobreposição

Configure o estilo visual da sobreposição de encaixe:

- **Borda de redimensionamento** — a cor e o estilo da linha (sólida ou tracejada) da borda exibida ao redimensionar perto de um tamanho predefinido. Padrão: laranja, tracejada.
- **Borda de encaixe** — a cor e o estilo da linha da borda exibida quando a janela se encaixa em um tamanho predefinido. Padrão: laranja, sólida.
- **Mostrar proporção** — ativar ou desativar o rótulo de proporção na sobreposição. Padrão: ativado.
- **Shift para travar a proporção** — ativar ou desativar se manter Shift pressionado trava a proporção durante o redimensionamento. Padrão: ativado.

Cores de borda disponíveis: Laranja, Azul, Verde, Vermelho, Roxo, Branco.

### Iniciar ao fazer login

Ative **"Iniciar ao fazer login"** para que o Window Resize inicie automaticamente quando você fizer login no macOS.

### Idioma

Selecione o idioma de exibição do aplicativo no menu suspenso **Idioma**. Escolha entre 16 idiomas ou **"Padrão do sistema"** para seguir o idioma do macOS. A alteração do idioma requer reiniciar o aplicativo.

### Status da acessibilidade

Na parte inferior da janela de Configurações, um indicador de status mostra o estado atual da permissão de acessibilidade:

| Indicador | Significado |
|-----------|-------------|
| Verde | A permissão está ativa e funcionando corretamente. |
| Laranja | O sistema informa que a permissão foi concedida, mas não é mais válida (consulte [Corrigir permissões obsoletas](#corrigir-permissões-obsoletas)). Um botão "Abrir Configurações" é exibido. |
| Vermelho | A permissão não foi concedida. Um botão "Abrir Configurações" é exibido. |

---

## Solução de problemas

### Corrigir permissões obsoletas

Se você vir um indicador de status laranja ou a mensagem "Acessibilidade: Precisa Atualizar", a permissão se tornou obsoleta. Isso pode acontecer após uma atualização ou reconstrução do aplicativo.

**Para corrigir:**

1. Abra **Ajustes do Sistema > Privacidade e Segurança > Acessibilidade**.
2. Encontre **"Window Resize"** na lista.
3. Desative o interruptor e **ative-o** novamente.
4. Alternativamente, remova-o completamente da lista e reinicie o aplicativo para adicioná-lo novamente.

### O encaixe não funciona

Se a sobreposição não aparecer durante o redimensionamento:

- Verifique se a permissão de acessibilidade está ativa (indicador verde nas Configurações).
- Certifique-se de que a janela que você está redimensionando suporta redimensionamento padrão (alguns aplicativos restringem o tamanho das janelas).
- Janelas em tela cheia não podem ser redimensionadas — saia do modo tela cheia primeiro.

### Problemas de renderização após o encaixe

Em casos raros, a janela de destino pode não redesenhar corretamente após o encaixe. O aplicativo força automaticamente um redesenho, mas se artefatos visuais persistirem, tente minimizar e restaurar a janela.
