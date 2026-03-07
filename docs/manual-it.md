# Window Resize — Manuale utente

## Indice

1. [Configurazione iniziale](#configurazione-iniziale)
2. [Ridimensionare una finestra](#ridimensionare-una-finestra)
3. [Impostazioni](#impostazioni)
4. [Funzioni di accessibilità](#funzioni-di-accessibilità)
5. [Risoluzione dei problemi](#risoluzione-dei-problemi)

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
3. Tutte le finestre attualmente aperte sono visualizzate con la propria **icona dell'applicazione** e il nome come **[Nome dell'app] Titolo della finestra**. I titoli lunghi vengono automaticamente troncati per mantenere il menu leggibile.
4. Quando un'applicazione ha **3 o più finestre**, queste vengono raggruppate automaticamente sotto il nome dell'applicazione (es. **"Safari (4)"**). Passare il cursore sull'app per visualizzare le singole finestre, quindi passare su una finestra per vedere le dimensioni.
5. Passare il cursore su una finestra per visualizzare le dimensioni predefinite disponibili.
6. Fare clic su una dimensione per ridimensionare la finestra immediatamente.

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

---

## Funzioni di accessibilità

Le seguenti funzioni migliorano l'accessibilità nella gestione delle finestre. Quando una qualsiasi di queste funzioni è attivata, nel menu di ridimensionamento compare un'opzione **"Dimensione attuale"**, che consente di riposizionare o portare in primo piano una finestra senza modificarne le dimensioni.

### Porta in primo piano

Attivare **"Porta la finestra in primo piano dopo il ridimensionamento"** per sollevare automaticamente la finestra ridimensionata sopra tutte le altre. È utile quando la finestra di destinazione è parzialmente nascosta dietro ad altre.

### Sposta sullo schermo principale

Attivare **"Sposta sullo schermo principale"** per spostare la finestra sul display principale al momento del ridimensionamento. È comodo nelle configurazioni multi-monitor quando si desidera spostare rapidamente una finestra da un display secondario.

### Posizione della finestra

Scegliere dove posizionare la finestra sullo schermo dopo il ridimensionamento. Una riga di 9 pulsanti rappresenta le opzioni di posizionamento:

- **Angoli:** In alto a sinistra, In alto a destra, In basso a sinistra, In basso a destra
- **Lati:** Centro superiore, Centro sinistro, Centro destro, Centro inferiore
- **Centro:** Centro dello schermo

Fare clic su un pulsante per selezionare la posizione. Fare clic di nuovo sullo stesso pulsante (oppure fare clic su **"Non spostare"**) per deselezionare. Quando nessuna posizione è selezionata, la finestra resta nella posizione corrente dopo il ridimensionamento.

> **Nota:** Il posizionamento della finestra tiene conto della barra dei menu e del Dock, mantenendo la finestra nell'area utilizzabile dello schermo.

---

### Istantanea dello schermo

Attivare **"Scatta istantanea dopo il ridimensionamento"** per catturare automaticamente la finestra dopo il ridimensionamento.

Quando è attivata, sono disponibili le seguenti opzioni:

- **Salva su file** — Salva l'istantanea come file PNG. Fare clic su **"Scegli..."** per selezionare la cartella di salvataggio.
  > **Formato del nome file:** `MMddHHmmss_NomeApp_TitoloFinestra.png` (es. `0227193012_Safari_Apple.png`). I simboli vengono rimossi; vengono utilizzati solo lettere, cifre e trattini bassi.
- **Copia negli appunti** — Copia l'istantanea negli appunti per incollarla in altre applicazioni.

Entrambe le opzioni possono essere attivate in modo indipendente. Ad esempio, è possibile copiare negli appunti senza salvare su file.

> **Nota:** La funzione di istantanea richiede il permesso di **Registrazione schermo**. Quando si utilizza questa funzione per la prima volta, macOS chiederà di concedere il permesso in **Impostazioni di Sistema > Privacy e Sicurezza > Registrazione schermo**.

### Lingua

Selezionare la lingua di visualizzazione dell'app dal menu a discesa **Lingua**. Sono disponibili 16 lingue oppure **"Predefinita di sistema"** per utilizzare la lingua di macOS. La modifica della lingua richiede il riavvio dell'app.

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
