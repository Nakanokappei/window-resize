# Window Resize — Manuale utente

## Indice

1. [Configurazione iniziale](#configurazione-iniziale)
2. [Ridimensionare una finestra](#ridimensionare-una-finestra)
3. [Impostazioni](#impostazioni)
4. [Risoluzione dei problemi](#risoluzione-dei-problemi)

---

## Configurazione iniziale

### Concedere il permesso di accessibilità

Window Resize utilizza l'API di accessibilità di macOS per ridimensionare le finestre. È necessario concedere il permesso al primo avvio dell'applicazione.

1. Avviare **Window Resize**. Apparirà una finestra di dialogo del sistema che chiede di concedere l'accesso all'accessibilità.
2. Fare clic su **"Apri Impostazioni"** (oppure andare manualmente in **Impostazioni di Sistema > Privacy e sicurezza > Accessibilità**).
3. Trovare **"Window Resize"** nell'elenco e attivare l'interruttore.
4. Tornare all'applicazione — l'icona nella barra dei menu apparirà e l'app sarà pronta all'uso.

> **Nota:** Se la finestra di dialogo non appare, è possibile aprire le impostazioni di accessibilità direttamente dalla finestra Impostazioni dell'app (vedere [Stato dell'accessibilità](#stato-dellaccessibilità)).

---

## Ridimensionare una finestra

### Passo per passo

1. Fare clic sull'**icona di Window Resize** nella barra dei menu.
2. Passare il cursore su **"Ridimensiona"** per aprire l'elenco delle finestre.
3. Tutte le finestre attualmente aperte sono elencate come **[Nome dell'app] Titolo della finestra**.
4. Passare il cursore su una finestra per visualizzare le dimensioni predefinite disponibili.
5. Fare clic su una dimensione per ridimensionare la finestra immediatamente.

### Come vengono visualizzate le dimensioni

Ogni voce di dimensione nel menu mostra:

```
1920 x 1080          Full HD
```

- **Sinistra:** Larghezza x Altezza (in pixel)
- **Destra:** Etichetta (nome del dispositivo o nome standard), visualizzata in grigio

### Dimensioni che superano lo schermo

Se una dimensione predefinita è più grande dello schermo in cui si trova la finestra, quella dimensione sarà **disattivata e non selezionabile**. Questo impedisce di ridimensionare una finestra oltre i confini dello schermo.

> **Multi-display:** L'app rileva su quale schermo si trova ogni finestra e regola le dimensioni disponibili di conseguenza.

---

## Impostazioni

Aprire le Impostazioni dalla barra dei menu: fare clic sull'icona di Window Resize, quindi selezionare **"Impostazioni..."** (scorciatoia: **⌘,**).

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

È possibile aggiungere le proprie dimensioni all'elenco:

1. Nella sezione **"Personalizzate"**, inserire la **Larghezza** e l'**Altezza** in pixel.
2. Fare clic su **"Aggiungi"**.
3. La nuova dimensione appare nell'elenco personalizzato ed è immediatamente disponibile nel menu di ridimensionamento.

Per rimuovere una dimensione personalizzata, fare clic sul pulsante rosso **"Rimuovi"** accanto ad essa.

> Le dimensioni personalizzate appaiono nel menu di ridimensionamento dopo le dimensioni integrate.

### Avvia al login

Attivare **"Avvia al login"** per far avviare Window Resize automaticamente quando si accede a macOS.

### Istantanea dello schermo

Attivare **"Scatta istantanea dopo il ridimensionamento"** per catturare automaticamente la finestra dopo il ridimensionamento.

Quando è attivata, sono disponibili le seguenti opzioni:

- **Salva su file** — Salva l'istantanea come file PNG. Quando è attivata, scegliere la posizione di salvataggio:
  - **Scrivania** — Salvare nella cartella Scrivania.
  - **Immagini** — Salvare nella cartella Immagini.
- **Copia negli appunti** — Copia l'istantanea negli appunti per incollarla in altre applicazioni.

Entrambe le opzioni possono essere attivate in modo indipendente. Ad esempio, è possibile copiare negli appunti senza salvare su file.

> **Nota:** La funzione di istantanea richiede il permesso di **Registrazione schermo**. Quando si utilizza questa funzione per la prima volta, macOS chiederà di concedere il permesso in **Impostazioni di Sistema > Privacy e Sicurezza > Registrazione schermo**.

### Stato dell'accessibilità

Nella parte inferiore della finestra delle Impostazioni, un indicatore di stato mostra lo stato attuale del permesso di accessibilità:

| Indicatore | Significato |
|------------|-------------|
| 🟢 **Accessibilità: abilitata** | Il permesso è attivo e funziona correttamente. |
| 🟠 **Accessibilità: aggiornamento necessario** | Il sistema indica che il permesso è stato concesso, ma non è più valido (vedere [Correggere i permessi obsoleti](#correggere-i-permessi-obsoleti)). Viene mostrato un pulsante **"Apri Impostazioni"**. |
| 🔴 **Accessibilità: non abilitata** | Il permesso non è stato concesso. Viene mostrato un pulsante **"Apri Impostazioni"**. |

---

## Risoluzione dei problemi

### Correggere i permessi obsoleti

Se si vede un indicatore di stato arancione o il messaggio "Accessibilità: aggiornamento necessario", il permesso è diventato obsoleto. Questo può accadere dopo un aggiornamento o una ricompilazione dell'app.

**Per correggere:**

1. Aprire **Impostazioni di Sistema > Privacy e sicurezza > Accessibilità**.
2. Trovare **"Window Resize"** nell'elenco.
3. Disattivare l'interruttore, quindi **riattivarlo**.
4. In alternativa, rimuoverlo completamente dall'elenco, quindi riavviare l'app per aggiungerlo di nuovo.

### Ridimensionamento non riuscito

Se si vede un avviso "Ridimensionamento non riuscito", le possibili cause includono:

- L'applicazione di destinazione non supporta il ridimensionamento tramite accessibilità.
- La finestra è in **modalità a schermo intero** (uscire prima dalla modalità a schermo intero).
- Il permesso di accessibilità non è attivo (verificare lo stato nelle Impostazioni).

### La finestra non appare nell'elenco

Il menu di ridimensionamento mostra solo le finestre che:

- Sono attualmente visibili sullo schermo
- Non fanno parte della Scrivania (ad esempio, la Scrivania del Finder è esclusa)
- Non sono le finestre stesse di Window Resize

Se una finestra è minimizzata nel Dock, non apparirà nell'elenco.

### L'istantanea dello schermo non funziona

Se le istantanee non vengono catturate:

- Concedere il permesso di **Registrazione schermo** in **Impostazioni di Sistema > Privacy e Sicurezza > Registrazione schermo**.
- Assicurarsi che almeno una delle opzioni **"Salva su file"** o **"Copia negli appunti"** sia attivata.
