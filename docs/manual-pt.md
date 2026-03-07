# Window Resize — Manual do usuário

## Sumário

1. [Configuração inicial](#configuração-inicial)
2. [Redimensionar uma janela](#redimensionar-uma-janela)
3. [Configurações](#configurações)
4. [Recursos de acessibilidade](#recursos-de-acessibilidade)
5. [Solução de problemas](#solução-de-problemas)

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
3. Todas as janelas abertas são exibidas com seu **ícone de aplicativo** e nome como **[Nome do app] Título da janela**. Títulos longos são automaticamente truncados para manter o menu legível.
4. Quando um aplicativo tem **3 ou mais janelas**, elas são automaticamente agrupadas sob o nome do aplicativo (ex.: **"Safari (4)"**). Passe o cursor sobre o aplicativo para ver as janelas individuais e, em seguida, sobre uma janela para ver os tamanhos.
5. Passe o cursor sobre uma janela para ver os tamanhos predefinidos disponíveis.
6. Clique em um tamanho para redimensionar a janela imediatamente.

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

---

## Recursos de acessibilidade

Os recursos a seguir aprimoram a acessibilidade no gerenciamento de janelas. Quando qualquer um deles estiver ativado, o menu de redimensionamento inclui a opção **"Tamanho atual"** no topo, permitindo reposicionar ou trazer uma janela para a frente sem alterar seu tamanho.

### Trazer para frente

Ative **"Trazer janela para frente após redimensionar"** para elevar automaticamente a janela redimensionada acima de todas as outras. Isso é útil quando a janela de destino está parcialmente oculta por outras janelas.

### Mover para a tela principal

Ative **"Mover para a tela principal"** para realocar a janela para o monitor principal ao redimensionar. Isso é útil em configurações com múltiplos monitores quando você deseja mover rapidamente uma janela de um monitor secundário.

### Posição da janela

Escolha onde posicionar a janela na tela após o redimensionamento. Uma fileira de 9 botões representa as opções de posicionamento:

- **Cantos:** Superior esquerdo, Superior direito, Inferior esquerdo, Inferior direito
- **Bordas:** Centro superior, Centro esquerdo, Centro direito, Centro inferior
- **Centro:** Centro da tela

Clique em um botão de posição para selecioná-lo. Clique no mesmo botão novamente (ou clique em **"Não mover"**) para desmarcar. Quando nenhuma posição estiver selecionada, a janela permanece no lugar após o redimensionamento.

> **Nota:** O posicionamento da janela leva em conta a barra de menus e o Dock, mantendo a janela dentro da área utilizável da tela.

---

### Captura de tela

Ative **"Capturar após redimensionar"** para capturar automaticamente a janela após o redimensionamento.

Quando ativada, as seguintes opções estão disponíveis:

- **Salvar em arquivo** — Salva a captura como um arquivo PNG. Clique em **"Escolher..."** para selecionar a pasta de destino.
  > **Formato do nome do arquivo:** `MMddHHmmss_NomeApp_TítuloDaJanela.png` (ex. `0227193012_Safari_Apple.png`). Símbolos são removidos; apenas letras, dígitos e underscores são utilizados.
- **Copiar para a área de transferência** — Copia a captura para a área de transferência para colar em outros aplicativos.

Ambas as opções podem ser ativadas de forma independente. Por exemplo, você pode copiar para a área de transferência sem salvar em um arquivo.

> **Nota:** O recurso de captura de tela requer a permissão de **Gravação de Tela**. Quando você usar este recurso pela primeira vez, o macOS solicitará que conceda a permissão em **Ajustes do Sistema > Privacidade e Segurança > Gravação de Tela**.

### Idioma

Selecione o idioma de exibição do aplicativo no menu suspenso **Idioma**. Escolha entre 16 idiomas ou **"Padrão do sistema"** para seguir o idioma do macOS. A alteração do idioma requer reiniciar o aplicativo.

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
