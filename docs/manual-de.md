# Window Resize — Benutzerhandbuch

## Inhaltsverzeichnis

1. [Ersteinrichtung](#ersteinrichtung)
2. [Snap-Resize](#snap-resize)
3. [Einstellungen](#einstellungen)
4. [Fehlerbehebung](#fehlerbehebung)

---

## Ersteinrichtung

### Berechtigung für Bedienungshilfen erteilen

Window Resize verwendet die Bedienungshilfen-API von macOS, um Fenster zu erkennen und ihre Größe zu ändern. Sie müssen die Berechtigung beim ersten Start der App erteilen.

1. Starten Sie **Window Resize**. Ein Systemdialog erscheint und bittet Sie, den Zugriff auf die Bedienungshilfen zu gewähren.
2. Klicken Sie auf **"Einstellungen öffnen"** (oder navigieren Sie manuell zu **Systemeinstellungen > Datenschutz & Sicherheit > Bedienungshilfen**).
3. Suchen Sie **"Window Resize"** in der Liste und aktivieren Sie den Schalter.
4. Kehren Sie zur App zurück — das Symbol in der Menüleiste erscheint und die App ist einsatzbereit.

> **Hinweis:** Wenn der Dialog nicht erscheint, können Sie die Einstellungen für Bedienungshilfen direkt aus dem Einstellungsfenster der App öffnen (siehe [Status der Bedienungshilfen](#status-der-bedienungshilfen)).

---

## Snap-Resize

### So funktioniert es

Window Resize überwacht Fenstergrößenänderungen in Echtzeit. Wenn Sie eine Fensterkante oder -ecke ziehen, um die Größe zu ändern, erkennt die App, wie nah die Fensterabmessungen an einer voreingestellten Größe sind.

1. **Größenänderung starten** — ziehen Sie wie gewohnt an einer beliebigen Fensterkante oder -ecke.
2. **Overlay erscheint** — wenn die Fenstergröße sich einer Voreinstellung nähert (innerhalb von 30 Pixeln), erscheint ein farbiger Rahmen um das Fenster, der die voreingestellte Zielgröße anzeigt.
3. **Loslassen zum Einrasten** — lassen Sie die Maustaste los und das Fenster rastet präzise auf die voreingestellte Größe ein.
4. **Abbrechen** — wenn Sie die Fenstergröße vor dem Loslassen wieder von der Voreinstellung wegbewegen, verschwindet das Overlay und es wird nicht eingerastet.

### Seitenverhältnis-Anzeige

Während der Größenänderung wird das aktuelle Seitenverhältnis im Overlay angezeigt. Wenn das Verhältnis einer bekannten Proportion entspricht, wird dessen Name angezeigt:

- **Goldener Schnitt** (1,618:1)
- **Silberner Schnitt** (2,414:1)
- **Platin-Verhältnis** (1,325:1)
- **Bronze-Verhältnis** (3,303:1)

Andere Verhältnisse werden als vereinfachte Brüche angezeigt (z. B. „16:9", „4:3").

> Diese Funktion kann in den Einstellungen deaktiviert werden (siehe [Seitenverhältnis anzeigen](#Overlay-Darstellung)).

### Shift zum Sperren des Seitenverhältnisses

Halten Sie die **Shift**-Taste während der Größenänderung gedrückt, um das Seitenverhältnis zu sperren. Das Fenster behält seine aktuellen Proportionen bei, während Sie ziehen.

> Diese Funktion kann in den Einstellungen deaktiviert werden (siehe [Shift-Verhältnissperre](#Overlay-Darstellung)).

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
3. Die neue Größe ist sofort für die Snap-Erkennung während der Größenänderung verfügbar.

Um eine benutzerdefinierte Größe zu entfernen, klicken Sie auf die rote Schaltfläche **"Entfernen"** daneben.

### Overlay-Darstellung

Konfigurieren Sie den visuellen Stil des Snap-Overlays:

- **Resize-Rahmen** — Rahmenfarbe und Linienstil (durchgezogen oder gestrichelt), der angezeigt wird, wenn die Größe in der Nähe einer Voreinstellung geändert wird. Standard: Orange, gestrichelt.
- **Snap-Rahmen** — Rahmenfarbe und Linienstil, der beim Einrasten des Fensters auf eine Voreinstellung angezeigt wird. Standard: Orange, durchgezogen.
- **Seitenverhältnis anzeigen** — Seitenverhältnis-Anzeige im Overlay ein- oder ausschalten. Standard: Ein.
- **Shift-Verhältnissperre** — Steuert, ob das Halten der Shift-Taste das Seitenverhältnis während der Größenänderung sperrt. Standard: Ein.

Verfügbare Rahmenfarben: Orange, Blau, Grün, Rot, Lila, Weiß.

### Beim Anmelden starten

Aktivieren Sie **"Beim Anmelden starten"**, damit Window Resize automatisch gestartet wird, wenn Sie sich bei macOS anmelden.

### Sprache

Wählen Sie die Anzeigesprache der App über das Dropdown-Menü **Sprache** aus. Sie können aus 16 Sprachen wählen oder **"Systemstandard"** auswählen, um der macOS-Systemsprache zu folgen. Nach dem Ändern der Sprache ist ein Neustart der App erforderlich.

### Status der Bedienungshilfen

Am unteren Rand des Einstellungsfensters zeigt ein Statusindikator den aktuellen Zustand der Berechtigung für Bedienungshilfen an:

| Indikator | Bedeutung |
|-----------|-----------|
| Grün | Die Berechtigung ist aktiv und funktioniert ordnungsgemäß. |
| Orange | Das System meldet, dass die Berechtigung erteilt wurde, aber sie ist nicht mehr gültig (siehe [Veraltete Berechtigungen korrigieren](#veraltete-berechtigungen-korrigieren)). Eine Schaltfläche „Einstellungen öffnen" wird angezeigt. |
| Rot | Die Berechtigung wurde nicht erteilt. Eine Schaltfläche „Einstellungen öffnen" wird angezeigt. |

---

## Fehlerbehebung

### Veraltete Berechtigungen korrigieren

Wenn Sie einen orangefarbenen Statusindikator oder die Meldung „Bedienungshilfen: Aktualisierung nötig" sehen, ist die Berechtigung veraltet. Dies kann nach einem Update oder einer Neuerstellung der App geschehen.

**So beheben Sie das Problem:**

1. Öffnen Sie **Systemeinstellungen > Datenschutz & Sicherheit > Bedienungshilfen**.
2. Suchen Sie **"Window Resize"** in der Liste.
3. Schalten Sie den Schalter **AUS** und dann wieder **EIN**.
4. Alternativ können Sie den Eintrag vollständig aus der Liste entfernen und die App erneut starten, um ihn wieder hinzuzufügen.

### Snap funktioniert nicht

Wenn das Overlay während der Größenänderung nicht erscheint:

- Überprüfen Sie, ob die Berechtigung für Bedienungshilfen aktiv ist (grüner Indikator in den Einstellungen).
- Stellen Sie sicher, dass das Fenster, dessen Größe Sie ändern, die Standard-Größenänderung unterstützt (einige Apps schränken die Fenstergrößenänderung ein).
- Fenster im Vollbildmodus können nicht in der Größe geändert werden — verlassen Sie zuerst den Vollbildmodus.

### Darstellungsprobleme nach dem Einrasten

In seltenen Fällen wird das Zielfenster nach dem Einrasten möglicherweise nicht korrekt neu gezeichnet. Die App erzwingt automatisch ein Neuzeichnen, aber wenn visuelle Artefakte bestehen bleiben, minimieren Sie das Fenster und stellen Sie es wieder her.
