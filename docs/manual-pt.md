# Window Resize — Manual do usuário

## Sumário

1. [Configuração inicial](#configuração-inicial)
2. [Redimensionar uma janela](#redimensionar-uma-janela)
3. [Configurações](#configurações)
4. [Solução de problemas](#solução-de-problemas)

---

## Configuração inicial

### Conceder permissão de acessibilidade

Window Resize utiliza a API de acessibilidade do macOS para redimensionar janelas. Você deve conceder a permissão na primeira vez que iniciar o aplicativo.

1. Inicie o **Window Resize**. Um diálogo do sistema aparecerá solicitando acesso à acessibilidade.
2. Clique em **"Abrir Configurações"** (ou vá manualmente para **Ajustes do Sistema > Privacidade e Segurança > Acessibilidade**).
3. Encontre **"Window Resize"** na lista e ative o interruptor.
4. Retorne ao aplicativo — o ícone na barra de menus aparecerá e o app estará pronto para uso.

> **Nota:** Se o diálogo não aparecer, você pode abrir as configurações de acessibilidade diretamente pela janela de Configurações do aplicativo (consulte [Status da acessibilidade](#status-da-acessibilidade)).

---

## Redimensionar uma janela

### Passo a passo

1. Clique no **ícone do Window Resize** na barra de menus.
2. Passe o cursor sobre **"Redimensionar"** para abrir a lista de janelas.
3. Todas as janelas abertas são listadas como **[Nome do app] Título da janela**.
4. Passe o cursor sobre uma janela para ver os tamanhos predefinidos disponíveis.
5. Clique em um tamanho para redimensionar a janela imediatamente.

### Como os tamanhos são exibidos

Cada entrada de tamanho no menu mostra:

```
1920 x 1080          Full HD
```

- **Esquerda:** Largura x Altura (em pixels)
- **Direita:** Rótulo (nome do dispositivo ou nome padrão), exibido em cinza

### Tamanhos que excedem a tela

Se um tamanho predefinido for maior que a tela onde a janela está localizada, esse tamanho ficará **esmaecido e não será selecionável**. Isso impede que você redimensione uma janela além dos limites da tela.

> **Múltiplas telas:** O aplicativo detecta em qual tela cada janela está e ajusta os tamanhos disponíveis de acordo.

---

## Configurações

Abra as Configurações pela barra de menus: clique no ícone do Window Resize e selecione **"Configurações..."** (atalho: **⌘,**).

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
3. O novo tamanho aparecerá na lista personalizada e estará disponível imediatamente no menu de redimensionamento.

Para remover um tamanho personalizado, clique no botão vermelho **"Remover"** ao lado dele.

> Os tamanhos personalizados aparecem no menu de redimensionamento após os tamanhos integrados.

### Iniciar ao Fazer Login

Ative **"Iniciar ao Fazer Login"** para que o Window Resize inicie automaticamente quando você fizer login no macOS.

### Captura de tela

Ative **"Capturar após redimensionar"** para capturar automaticamente a janela após o redimensionamento.

Quando ativada, as seguintes opções estão disponíveis:

- **Salvar em arquivo** — Salva a captura como um arquivo PNG. Quando ativada, escolha o local de salvamento:
  - **Mesa** — Salvar na pasta Mesa.
  - **Imagens** — Salvar na pasta Imagens.
- **Copiar para a área de transferência** — Copia a captura para a área de transferência para colar em outros aplicativos.

Ambas as opções podem ser ativadas de forma independente. Por exemplo, você pode copiar para a área de transferência sem salvar em um arquivo.

> **Nota:** O recurso de captura de tela requer a permissão de **Gravação de Tela**. Quando você usar este recurso pela primeira vez, o macOS solicitará que conceda a permissão em **Ajustes do Sistema > Privacidade e Segurança > Gravação de Tela**.

### Status da acessibilidade

Na parte inferior da janela de Configurações, um indicador de status mostra o estado atual da permissão de acessibilidade:

| Indicador | Significado |
|-----------|-------------|
| 🟢 **Acessibilidade: Ativada** | A permissão está ativa e funcionando corretamente. |
| 🟠 **Acessibilidade: Precisa Atualizar** | O sistema informa que a permissão foi concedida, mas não é mais válida (consulte [Corrigir permissões obsoletas](#corrigir-permissões-obsoletas)). Um botão **"Abrir Configurações"** é exibido. |
| 🔴 **Acessibilidade: Desativada** | A permissão não foi concedida. Um botão **"Abrir Configurações"** é exibido. |

---

## Solução de problemas

### Corrigir permissões obsoletas

Se você vir um indicador de status laranja ou a mensagem "Acessibilidade: Precisa Atualizar", a permissão se tornou obsoleta. Isso pode acontecer após uma atualização ou reconstrução do aplicativo.

**Para corrigir:**

1. Abra **Ajustes do Sistema > Privacidade e Segurança > Acessibilidade**.
2. Encontre **"Window Resize"** na lista.
3. Desative o interruptor e **ative-o** novamente.
4. Alternativamente, remova-o completamente da lista e reinicie o aplicativo para adicioná-lo novamente.

### Falha ao Redimensionar

Se você vir um alerta "Falha ao Redimensionar", as possíveis causas incluem:

- O aplicativo de destino não suporta redimensionamento via acessibilidade.
- A janela está em **modo tela cheia** (saia do modo tela cheia primeiro).
- A permissão de acessibilidade não está ativa (verifique o status nas Configurações).

### A janela não aparece na lista

O menu de redimensionamento mostra apenas janelas que:

- Estão atualmente visíveis na tela
- Não fazem parte da área de trabalho (por exemplo, a Mesa do Finder é excluída)
- Não são as próprias janelas do Window Resize

Se uma janela estiver minimizada no Dock, ela não aparecerá na lista.

### A captura de tela não funciona

Se as capturas de tela não estão sendo realizadas:

- Conceda a permissão de **Gravação de Tela** em **Ajustes do Sistema > Privacidade e Segurança > Gravação de Tela**.
- Certifique-se de que pelo menos uma das opções **"Salvar em arquivo"** ou **"Copiar para a área de transferência"** esteja ativada.
