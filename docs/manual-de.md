# Window Resize — Benutzerhandbuch

## Inhaltsverzeichnis

1. [Ersteinrichtung](#ersteinrichtung)
2. [Fenstergröße ändern](#fenstergröße-ändern)
3. [Einstellungen](#einstellungen)
4. [Fehlerbehebung](#fehlerbehebung)

---

## Ersteinrichtung

### Berechtigung für Bedienungshilfen erteilen

Window Resize verwendet die Bedienungshilfen-API von macOS, um Fenstergrößen zu ändern. Sie müssen die Berechtigung beim ersten Start der App erteilen.

1. Starten Sie **Window Resize**. Ein Systemdialog erscheint und bittet Sie, den Zugriff auf die Bedienungshilfen zu gewähren.
2. Klicken Sie auf **"Einstellungen öffnen"** (oder navigieren Sie manuell zu **Systemeinstellungen > Datenschutz & Sicherheit > Bedienungshilfen**).
3. Suchen Sie **"Window Resize"** in der Liste und aktivieren Sie den Schalter.
4. Kehren Sie zur App zurück — das Symbol in der Menüleiste erscheint und die App ist einsatzbereit.

> **Hinweis:** Wenn der Dialog nicht erscheint, können Sie die Einstellungen für Bedienungshilfen direkt aus dem Einstellungsfenster der App öffnen (siehe [Status der Bedienungshilfen](#status-der-bedienungshilfen)).

---

## Fenstergröße ändern

### Schritt für Schritt

1. Klicken Sie auf das **Window Resize-Symbol** in der Menüleiste.
2. Bewegen Sie den Mauszeiger über **"Größe ändern"**, um die Fensterliste zu öffnen.
3. Alle derzeit geöffneten Fenster werden mit ihrem **Anwendungssymbol** und Namen als **[App-Name] Fenstertitel** angezeigt. Lange Titel werden automatisch gekürzt, um das Menü übersichtlich zu halten.
4. Bewegen Sie den Mauszeiger über ein Fenster, um die verfügbaren voreingestellten Größen zu sehen.
5. Klicken Sie auf eine Größe, um das Fenster sofort zu ändern.

### Darstellung der Größen

Jeder Größeneintrag im Menü zeigt:

```
1920 x 1080          Full HD
```

- **Links:** Breite x Höhe (in Pixeln)
- **Rechts:** Bezeichnung (Gerätename oder Standardname), in Grau angezeigt

### Größen, die den Bildschirm überschreiten

Wenn eine voreingestellte Größe größer als der Bildschirm ist, auf dem sich das Fenster befindet, wird diese Größe **ausgegraut und ist nicht auswählbar**. Dies verhindert, dass Sie ein Fenster über die Bildschirmgrenzen hinaus vergrößern.

> **Mehrere Bildschirme:** Die App erkennt, auf welchem Bildschirm sich jedes Fenster befindet, und passt die verfügbaren Größen entsprechend an.

---

## Einstellungen

Öffnen Sie die Einstellungen über die Menüleiste: Klicken Sie auf das Window Resize-Symbol und wählen Sie **"Einstellungen ..."** (Tastenkombination: **⌘,**).

### Integrierte Größen

Die App enthält 12 integrierte voreingestellte Größen:

| Größe | Bezeichnung |
|-------|-------------|
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

Integrierte Größen können weder entfernt noch bearbeitet werden.

### Benutzerdefinierte Größen

Sie können eigene Größen zur Liste hinzufügen:

1. Geben Sie im Bereich **"Benutzerdefiniert"** die **Breite** und **Höhe** in Pixeln ein.
2. Klicken Sie auf **"Hinzufügen"**.
3. Die neue Größe erscheint in der benutzerdefinierten Liste und ist sofort im Menü zur Größenänderung verfügbar.

Um eine benutzerdefinierte Größe zu entfernen, klicken Sie auf die rote Schaltfläche **"Entfernen"** daneben.

> Benutzerdefinierte Größen erscheinen im Menü zur Größenänderung nach den integrierten Größen.

### Beim Anmelden starten

Aktivieren Sie **"Beim Anmelden starten"**, damit Window Resize automatisch gestartet wird, wenn Sie sich bei macOS anmelden.

### Bildschirmfoto

Aktivieren Sie **"Nach Größenänderung fotografieren"**, um das Fenster nach der Größenänderung automatisch aufzunehmen.

Wenn diese Option aktiviert ist, stehen folgende Optionen zur Verfügung:

- **In Datei speichern** — Speichert das Bildschirmfoto als PNG-Datei. Wenn aktiviert, wählen Sie den Speicherort:
  > **Dateinamenformat:** `MMddHHmmss_AppName_Fenstertitel.png` (z. B. `0227193012_Safari_Apple.png`). Sonderzeichen werden entfernt; es werden nur Buchstaben, Ziffern und Unterstriche verwendet.
  - **Schreibtisch** — Im Ordner „Schreibtisch" speichern.
  - **Bilder** — Im Ordner „Bilder" speichern.
- **In die Zwischenablage kopieren** — Kopiert das Bildschirmfoto in die Zwischenablage zum Einfügen in andere Apps.

Beide Optionen können unabhängig voneinander aktiviert werden. Sie können beispielsweise in die Zwischenablage kopieren, ohne in eine Datei zu speichern.

> **Hinweis:** Die Bildschirmfoto-Funktion erfordert die Berechtigung für **Bildschirmaufnahme**. Wenn Sie diese Funktion zum ersten Mal verwenden, fordert macOS Sie auf, die Berechtigung unter **Systemeinstellungen > Datenschutz & Sicherheit > Bildschirmaufnahme** zu erteilen.

### Status der Bedienungshilfen

Am unteren Rand des Einstellungsfensters zeigt ein Statusindikator den aktuellen Zustand der Berechtigung für Bedienungshilfen an:

| Indikator | Bedeutung |
|-----------|-----------|
| 🟢 **Bedienungshilfen: Aktiviert** | Die Berechtigung ist aktiv und funktioniert ordnungsgemäß. |
| 🟠 **Bedienungshilfen: Aktualisierung nötig** | Das System meldet, dass die Berechtigung erteilt wurde, aber sie ist nicht mehr gültig (siehe [Veraltete Berechtigungen korrigieren](#veraltete-berechtigungen-korrigieren)). Eine Schaltfläche **"Einstellungen öffnen"** wird angezeigt. |
| 🔴 **Bedienungshilfen: Deaktiviert** | Die Berechtigung wurde nicht erteilt. Eine Schaltfläche **"Einstellungen öffnen"** wird angezeigt. |

---

## Fehlerbehebung

### Veraltete Berechtigungen korrigieren

Wenn Sie einen orangefarbenen Statusindikator oder die Meldung „Bedienungshilfen: Aktualisierung nötig" sehen, ist die Berechtigung veraltet. Dies kann nach einem Update oder einer Neuerstellung der App geschehen.

**So beheben Sie das Problem:**

1. Öffnen Sie **Systemeinstellungen > Datenschutz & Sicherheit > Bedienungshilfen**.
2. Suchen Sie **"Window Resize"** in der Liste.
3. Schalten Sie den Schalter **AUS** und dann wieder **EIN**.
4. Alternativ können Sie den Eintrag vollständig aus der Liste entfernen und die App erneut starten, um ihn wieder hinzuzufügen.

### Größenänderung fehlgeschlagen

Wenn Sie die Meldung „Größenänderung fehlgeschlagen" sehen, können folgende Ursachen vorliegen:

- Die Zielanwendung unterstützt keine Größenänderung über Bedienungshilfen.
- Das Fenster befindet sich im **Vollbildmodus** (verlassen Sie zuerst den Vollbildmodus).
- Die Berechtigung für Bedienungshilfen ist nicht aktiv (überprüfen Sie den Status in den Einstellungen).

### Fenster erscheint nicht in der Liste

Das Menü zur Größenänderung zeigt nur Fenster an, die:

- Derzeit auf dem Bildschirm sichtbar sind
- Nicht zum Schreibtisch gehören (z. B. wird der Finder-Schreibtisch ausgeschlossen)
- Nicht die eigenen Fenster von Window Resize sind

Wenn ein Fenster im Dock minimiert ist, wird es nicht in der Liste angezeigt.

### Bildschirmfoto funktioniert nicht

Wenn Bildschirmfotos nicht aufgenommen werden:

- Erteilen Sie die Berechtigung für **Bildschirmaufnahme** unter **Systemeinstellungen > Datenschutz & Sicherheit > Bildschirmaufnahme**.
- Stellen Sie sicher, dass mindestens eine der Optionen **"In Datei speichern"** oder **"In die Zwischenablage kopieren"** aktiviert ist.
