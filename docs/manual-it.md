# Window Resize — Manuale utente

## Indice

1. [Configurazione iniziale](#configurazione-iniziale)
2. [Ridimensionamento con snap](#ridimensionamento-con-snap)
3. [Scorciatoie da tastiera](#scorciatoie-da-tastiera)
4. [Impostazioni](#impostazioni)
5. [Risoluzione dei problemi](#risoluzione-dei-problemi)

---

## Configurazione iniziale

### Concedere il permesso di accessibilita

Window Resize utilizza l'API di accessibilita di macOS per rilevare e ridimensionare le finestre. E necessario concedere il permesso al primo avvio dell'applicazione.

1. Avviare **Window Resize**. Apparira una finestra di dialogo del sistema che chiede di concedere l'accesso all'accessibilita.
2. Fare clic su **"Apri Impostazioni di Sistema"** (oppure andare manualmente in **Impostazioni di Sistema > Privacy e sicurezza > Accessibilita**).
3. Trovare **"Window Resize"** nell'elenco e attivare l'interruttore.
4. Tornare all'applicazione — l'icona nella barra dei menu apparira e l'app sara pronta all'uso.

> **Nota:** Se la finestra di dialogo non appare, e possibile aprire le impostazioni di accessibilita direttamente dalla finestra Impostazioni dell'app (vedere [Stato dell'accessibilita](#stato-dellaccessibilita)).

---

## Ridimensionamento con snap

### Come funziona

Window Resize monitora le operazioni di ridimensionamento delle finestre in tempo reale. Quando si trascina il bordo o l'angolo di una finestra per ridimensionarla, l'app rileva quanto le dimensioni della finestra siano vicine a una dimensione predefinita.

1. **Iniziare a ridimensionare** — trascinare un bordo o un angolo di qualsiasi finestra come di consueto.
2. **Appare l'overlay** — quando le dimensioni della finestra si avvicinano a una dimensione predefinita (entro 30 pixel), un bordo colorato appare intorno alla finestra mostrando la dimensione predefinita di destinazione.
3. **Rilasciare per eseguire lo snap** — rilasciare il mouse e la finestra si adattera precisamente alla dimensione predefinita.
4. **Annullare** — se si allontanano le dimensioni della finestra dalla dimensione predefinita prima di rilasciare, l'overlay scompare e lo snap non viene eseguito.

### Snap per spostamento

Trascinare una finestra verso un bordo o un angolo dello schermo per posizionarla automaticamente:

- **Snap bordo** (sinistra/destra) — riempie l'altezza, mantiene la larghezza
- **Snap bordo** (alto/basso) — riempie la larghezza, mantiene l'altezza
- **Snap angolo** — posiziona la finestra nell'angolo, mantiene entrambe le dimensioni

### Visualizzazione del rapporto d'aspetto

Durante il ridimensionamento, il rapporto d'aspetto corrente viene visualizzato nell'overlay. Quando il rapporto corrisponde a una proporzione nota, ne viene mostrato il nome:

- **Sezione aurea** (1.618:1)
- **Rapporto d'argento** (2.414:1)
- **Rapporto di platino** (1.325:1)
- **Rapporto di bronzo** (3.303:1)

Gli altri rapporti vengono visualizzati come frazioni semplificate (ad esempio "16:9", "4:3").

> Questa funzione puo essere disattivata nelle Impostazioni (vedere [Scheda Aspetto](#scheda-aspetto)).

### Shift per bloccare il rapporto d'aspetto

Tenere premuto il tasto **Shift** durante il ridimensionamento per bloccare il rapporto d'aspetto. La finestra manterra le proporzioni correnti durante il trascinamento.

> Questa funzione puo essere disattivata nelle Impostazioni (vedere [Scheda Generale](#scheda-generale)).

---

## Scorciatoie da tastiera

Tutte le scorciatoie da tastiera sono completamente personalizzabili nella scheda Scorciatoie delle Impostazioni. Valori predefiniti:

### Preset rapidi

Premere **Control+Option+1** fino a **Control+Option+9** per ridimensionare istantaneamente la finestra in primo piano a un preset denominato. Un HUD centrato mostra brevemente il nome e la dimensione del preset.

| Scorciatoia | Preset predefinito |
|-------------|-------------------|
| Control+Option+1 | Writing (1280 x 800) |
| Control+Option+2 | Reading (900 x 1200) |
| Control+Option+3 | Browsing (1440 x 900) |
| Control+Option+4 | Sidebar (720 x 900) |
| Control+Option+5 | Preview (1920 x 1080) |

I Preset rapidi possono essere modificati (nome, dimensione e scorciatoia) nella scheda Generale delle Impostazioni. Sono supportati fino a 9 preset.

### Ridimensionamento incrementale

Ridimensionare la finestra in primo piano di 10 pixel per pressione del tasto, mantenendo la finestra centrata:

| Scorciatoia | Azione |
|-------------|--------|
| Control+Option+Right | Aumenta larghezza (+10px) |
| Control+Option+Left | Riduci larghezza (-10px) |
| Control+Option+Up | Aumenta altezza (+10px) |
| Control+Option+Down | Riduci altezza (-10px) |

### Modalita precisione

Tenere premuto Shift per regolazioni di 1 pixel:

| Scorciatoia | Azione |
|-------------|--------|
| Control+Option+Shift+Right | Aumenta larghezza (+1px) |
| Control+Option+Shift+Left | Riduci larghezza (-1px) |
| Control+Option+Shift+Up | Aumenta altezza (+1px) |
| Control+Option+Shift+Down | Riduci altezza (-1px) |

### Annulla / Ripeti

| Scorciatoia | Azione |
|-------------|--------|
| Control+Option+Z | Annulla l'ultimo ridimensionamento |
| Control+Option+Shift+Z | Ripeti |

Ogni finestra mantiene la propria cronologia annulla/ripeti.

### Feedback HUD

Quando si utilizza una scorciatoia da tastiera, un HUD centrato appare sulla finestra di destinazione:

- **Preset rapido:** mostra il nome del preset (ad es. "Writing") con la dimensione sotto (ad es. "1280 x 800")
- **Ridimensionamento incrementale:** mostra la dimensione attuale (ad es. "1290 x 800")
- **Annulla:** mostra "Restored" con la dimensione ripristinata

L'HUD viene visualizzato per 0,8 secondi, poi scompare gradualmente.

---

## Impostazioni

Aprire le Impostazioni dalla barra dei menu: fare clic sull'icona di Window Resize, quindi selezionare **"Impostazioni..."**.

Le Impostazioni sono organizzate in 4 schede: **Generale**, **Aspetto**, **Scorciatoie** e **Preset**.

### Scheda Generale

#### Preset rapidi

Configurare fino a 9 Preset rapidi applicabili tramite scorciatoie da tastiera (Control+Option+1-9). Ogni preset ha:

- **Scorciatoia** — fare clic sul campo scorciatoia per registrare una nuova combinazione di tasti
- **Nome** — un nome descrittivo (ad es. "Writing", "Coding")
- **Dimensione** — larghezza e altezza in pixel

Per aggiungere un preset, compilare i campi nome, larghezza e altezza in basso e fare clic su **"Aggiungi"**. Per rimuovere un preset, fare clic sul pulsante X accanto ad esso.

#### Avvia al login

Attivare **"Avvia al login"** per far avviare Window Resize automaticamente quando si accede a macOS.

#### Shift per bloccare il rapporto

Attivare o disattivare il blocco del rapporto d'aspetto tenendo premuto Shift durante il ridimensionamento. Predefinito: attivato.

#### Stato dell'accessibilita

Un indicatore di stato mostra lo stato attuale del permesso di accessibilita:

| Indicatore | Significato |
|------------|-------------|
| Verde | Il permesso e attivo e funziona correttamente. |
| Arancione | Il permesso e stato concesso ma non e piu valido (vedere [Correggere i permessi obsoleti](#correggere-i-permessi-obsoleti)). |
| Rosso | Il permesso non e stato concesso. |

### Scheda Aspetto

Configurare lo stile visivo dell'overlay di snap:

- **Bordo di ridimensionamento** — il colore e lo stile della linea del bordo mostrato durante il ridimensionamento. Scegliere tra 9 colori (rosso, arancione, giallo, verde, ciano, blu, viola, bianco, grigio) e 4 stili (nessuno, continua, tratteggiata, animata). Predefinito: bianco, animata.
- **Bordo di snap** — il bordo mostrato quando la finestra si adatta a una dimensione predefinita. Predefinito: bianco, continua.
- **Mostra rapporto d'aspetto** — attivare o disattivare l'etichetta del rapporto d'aspetto nell'overlay. Predefinito: attivato.

### Scheda Scorciatoie

Tutte le scorciatoie da tastiera sono visualizzate in una griglia a 2 colonne e possono essere personalizzate individualmente:

1. Fare clic sul campo scorciatoia accanto a qualsiasi azione.
2. Premere la combinazione di tasti desiderata (deve includere almeno un tasto modificatore).
3. Premere **Escape** per annullare la registrazione.

Se si registra una scorciatoia in conflitto con un'altra azione nell'app, appare una finestra di dialogo di avviso che offre di **Sostituire** (riassegnare la scorciatoia) o **Annullare**.

Un'icona di avviso appare accanto alle scorciatoie in conflitto con scorciatoie di sistema note (Mission Control, Spotlight, ecc.).

Fare clic su **"Ripristina predefiniti"** per ripristinare tutte le scorciatoie alle assegnazioni originali.

### Scheda Preset

La scheda Preset mostra 18 dimensioni predefinite integrate ordinate per area in pixel (dalla piu piccola alla piu grande). Ogni preset ha un interruttore attiva/disattiva:

- **Attivato** — il preset viene utilizzato per il rilevamento dello snap durante il ridimensionamento
- **Disattivato** — il preset viene escluso dal rilevamento dello snap (mostrato al 50% di opacita)

I preset integrati non possono essere eliminati, solo disattivati. Per impostazione predefinita, 6 preset specifici per Mac (dimensioni display MacBook Air/Pro) sono disattivati e 12 preset generici sono attivati.

L'intestazione mostra quanti preset sono attualmente attivati (ad es. "12 of 18 enabled").

---

## Risoluzione dei problemi

### Correggere i permessi obsoleti

Se si vede un indicatore di stato arancione o il messaggio "Accessibilita: aggiornamento necessario", il permesso e diventato obsoleto. Questo puo accadere dopo un aggiornamento o una ricompilazione dell'app.

**Per correggere:**

1. Aprire **Impostazioni di Sistema > Privacy e sicurezza > Accessibilita**.
2. Trovare **"Window Resize"** nell'elenco.
3. Disattivare l'interruttore, quindi **riattivarlo**.
4. In alternativa, rimuoverlo completamente dall'elenco, quindi riavviare l'app per aggiungerlo di nuovo.

### Lo snap non funziona

Se l'overlay non appare durante il ridimensionamento:

- Verificare che il permesso di accessibilita sia attivo (indicatore verde nelle Impostazioni).
- Assicurarsi che la finestra che si sta ridimensionando supporti il ridimensionamento standard (alcune applicazioni limitano le dimensioni della finestra).
- Le finestre a schermo intero non possono essere ridimensionate — uscire prima dalla modalita a schermo intero.
- Controllare la scheda Preset — la dimensione di destinazione potrebbe essere disattivata.

### Problemi di rendering della finestra dopo lo snap

In rari casi, la finestra di destinazione potrebbe non essere ridisegnata correttamente dopo lo snap. L'app forza automaticamente un aggiornamento della visualizzazione, ma se persistono artefatti visivi, provare a ridurre a icona e ripristinare la finestra.
