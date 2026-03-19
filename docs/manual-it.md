# Window Resize — Manuale utente

## Indice

1. [Configurazione iniziale](#configurazione-iniziale)
2. [Ridimensionamento con snap](#ridimensionamento-con-snap)
3. [Impostazioni](#impostazioni)
4. [Risoluzione dei problemi](#risoluzione-dei-problemi)

---

## Configurazione iniziale

### Concedere il permesso di accessibilita

Window Resize utilizza l'API di accessibilita di macOS per rilevare e ridimensionare le finestre. E necessario concedere il permesso al primo avvio dell'applicazione.

1. Avviare **Window Resize**. Apparira una finestra di dialogo del sistema che chiede di concedere l'accesso all'accessibilita.
2. Fare clic su **"Apri Impostazioni di Sistema"** (oppure andare manualmente in **Impostazioni di Sistema > Privacy e sicurezza > Accessibilita**).
3. Trovare **"Window Resize"** nell'elenco e attivare l'interruttore.
4. Tornare all'applicazione — l'icona nella barra dei menu apparira e l'app sara pronta all'uso.

> **Nota:** Se la finestra di dialogo non appare, e possibile aprire le impostazioni di accessibilita direttamente dalla finestra Impostazioni dell'app (vedere [Stato dell'accessibilita](#stato-dellaccessibilità)).

---

## Ridimensionamento con snap

### Come funziona

Window Resize monitora le operazioni di ridimensionamento delle finestre in tempo reale. Quando si trascina il bordo o l'angolo di una finestra per ridimensionarla, l'app rileva quanto le dimensioni della finestra siano vicine a una dimensione predefinita.

1. **Iniziare a ridimensionare** — trascinare un bordo o un angolo di qualsiasi finestra come di consueto.
2. **Appare l'overlay** — quando le dimensioni della finestra si avvicinano a una dimensione predefinita (entro 30 pixel), un bordo colorato appare intorno alla finestra mostrando la dimensione predefinita di destinazione.
3. **Rilasciare per eseguire lo snap** — rilasciare il mouse e la finestra si adattera precisamente alla dimensione predefinita.
4. **Annullare** — se si allontanano le dimensioni della finestra dalla dimensione predefinita prima di rilasciare, l'overlay scompare e lo snap non viene eseguito.

### Visualizzazione del rapporto d'aspetto

Durante il ridimensionamento, il rapporto d'aspetto corrente viene visualizzato nell'overlay. Quando il rapporto corrisponde a una proporzione nota, ne viene mostrato il nome:

- **Sezione aurea** (1,618:1)
- **Rapporto d'argento** (2,414:1)
- **Rapporto di platino** (1,325:1)
- **Rapporto di bronzo** (3,303:1)

Gli altri rapporti vengono visualizzati come frazioni semplificate (ad esempio "16:9", "4:3").

> Questa funzione puo essere disattivata nelle Impostazioni (vedere [Aspetto dell'overlay](#aspetto-delloverlay)).

### Shift per bloccare il rapporto d'aspetto

Tenere premuto il tasto **Shift** durante il ridimensionamento per bloccare il rapporto d'aspetto. La finestra manterra le proporzioni correnti durante il trascinamento.

> Questa funzione puo essere disattivata nelle Impostazioni (vedere [Shift per bloccare il rapporto](#aspetto-delloverlay)).

---

## Impostazioni

Aprire le Impostazioni dalla barra dei menu: fare clic sull'icona di Window Resize, quindi selezionare **"Impostazioni..."** (scorciatoia: **Cmd+,**).

### Dimensioni integrate

L'app include 12 dimensioni predefinite integrate:

| Dimensione | Etichetta |
|------------|-----------|
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

Le dimensioni integrate non possono essere rimosse o modificate.

### Dimensioni personalizzate

E possibile aggiungere le proprie dimensioni all'elenco:

1. Nella sezione **"Personalizzate"**, inserire la **Larghezza** e l'**Altezza** in pixel.
2. Fare clic su **"Aggiungi"**.
3. La nuova dimensione e immediatamente disponibile per il rilevamento dello snap durante il ridimensionamento.

Per rimuovere una dimensione personalizzata, fare clic sul pulsante rosso **"Rimuovi"** accanto ad essa.

### Aspetto dell'overlay

Configurare lo stile visivo dell'overlay di snap:

- **Bordo di ridimensionamento** — il colore e lo stile della linea (continua o tratteggiata) del bordo mostrato durante il ridimensionamento vicino a una dimensione predefinita. Predefinito: arancione, tratteggiata.
- **Bordo di snap** — il colore e lo stile della linea del bordo mostrato quando la finestra si adatta a una dimensione predefinita. Predefinito: arancione, continua.
- **Mostra rapporto d'aspetto** — attivare o disattivare l'etichetta del rapporto d'aspetto nell'overlay. Predefinito: attivato.
- **Shift per bloccare il rapporto** — attivare o disattivare il blocco del rapporto d'aspetto tenendo premuto Shift durante il ridimensionamento. Predefinito: attivato.

Colori del bordo disponibili: arancione, blu, verde, rosso, viola, bianco.

### Avvia al login

Attivare **"Avvia al login"** per far avviare Window Resize automaticamente quando si accede a macOS.

### Lingua

Selezionare la lingua di visualizzazione dell'app dal menu a discesa **Lingua**. Sono disponibili 16 lingue oppure **"Predefinita di sistema"** per utilizzare la lingua di macOS. La modifica della lingua richiede il riavvio dell'app.

### Stato dell'accessibilita

Nella parte inferiore della finestra delle Impostazioni, un indicatore di stato mostra lo stato attuale del permesso di accessibilita:

| Indicatore | Significato |
|------------|-------------|
| Verde | Il permesso e attivo e funziona correttamente. |
| Arancione | Il sistema indica che il permesso e stato concesso, ma non e piu valido (vedere [Correggere i permessi obsoleti](#correggere-i-permessi-obsoleti)). Viene mostrato un pulsante "Apri Impostazioni". |
| Rosso | Il permesso non e stato concesso. Viene mostrato un pulsante "Apri Impostazioni". |

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

### Problemi di rendering della finestra dopo lo snap

In rari casi, la finestra di destinazione potrebbe non essere ridisegnata correttamente dopo lo snap. L'app forza automaticamente un aggiornamento della visualizzazione, ma se persistono artefatti visivi, provare a ridurre a icona e ripristinare la finestra.
