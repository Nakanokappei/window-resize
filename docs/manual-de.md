# Window Resize — Benutzerhandbuch

## Inhaltsverzeichnis

1. [Ersteinrichtung](#ersteinrichtung)
2. [Snap-Resize](#snap-resize)
3. [Tastaturkurzbefehle](#tastaturkurzbefehle)
4. [Einstellungen](#einstellungen)
5. [Fehlerbehebung](#fehlerbehebung)

---

## Ersteinrichtung

### Berechtigung fuer Bedienungshilfen erteilen

Window Resize verwendet die Bedienungshilfen-API von macOS, um Fenster zu erkennen und ihre Groesse zu aendern. Sie muessen die Berechtigung beim ersten Start der App erteilen.

1. Starten Sie **Window Resize**. Ein Systemdialog erscheint und bittet Sie, den Zugriff auf die Bedienungshilfen zu gewaehren.
2. Klicken Sie auf **"Einstellungen oeffnen"** (oder navigieren Sie manuell zu **Systemeinstellungen > Datenschutz & Sicherheit > Bedienungshilfen**).
3. Suchen Sie **"Window Resize"** in der Liste und aktivieren Sie den Schalter.
4. Kehren Sie zur App zurueck — das Symbol in der Menuezeile erscheint und die App ist einsatzbereit.

> **Hinweis:** Wenn der Dialog nicht erscheint, koennen Sie die Einstellungen fuer Bedienungshilfen direkt aus dem Einstellungsfenster der App oeffnen (siehe [Status der Bedienungshilfen](#status-der-bedienungshilfen)).

---

## Snap-Resize

### So funktioniert es

Window Resize ueberwacht Fenstergroessenaenderungen in Echtzeit. Wenn Sie eine Fensterkante oder -ecke ziehen, um die Groesse zu aendern, erkennt die App, wie nah die Fensterabmessungen an einer voreingestellten Groesse sind.

1. **Groessenaenderung starten** — ziehen Sie wie gewohnt an einer beliebigen Fensterkante oder -ecke.
2. **Overlay erscheint** — wenn die Fenstergroesse sich einer Voreinstellung naehert (innerhalb von 30 Pixeln), erscheint ein farbiger Rahmen um das Fenster, der die voreingestellte Zielgroesse anzeigt.
3. **Loslassen zum Einrasten** — lassen Sie die Maustaste los und das Fenster rastet praezise auf die voreingestellte Groesse ein.
4. **Abbrechen** — wenn Sie die Fenstergroesse vor dem Loslassen wieder von der Voreinstellung wegbewegen, verschwindet das Overlay und es wird nicht eingerastet.

### Verschieben und Einrasten

Ziehen Sie ein Fenster an eine Bildschirmkante oder -ecke, um es dort einzurasten:

- **Kanteneinrastung** (links/rechts) — fuellt die Hoehe, behaelt die Breite bei
- **Kanteneinrastung** (oben/unten) — fuellt die Breite, behaelt die Hoehe bei
- **Eckeneinrastung** — positioniert das Fenster in der Ecke, behaelt beide Dimensionen bei

### Seitenverhaeltnis-Anzeige

Waehrend der Groessenaenderung wird das aktuelle Seitenverhaeltnis im Overlay angezeigt. Wenn das Verhaeltnis einer bekannten Proportion entspricht, wird dessen Name angezeigt:

- **Goldener Schnitt** (1.618:1)
- **Silberner Schnitt** (2.414:1)
- **Platin-Verhaeltnis** (1.325:1)
- **Bronze-Verhaeltnis** (3.303:1)

Andere Verhaeltnisse werden als vereinfachte Brueche angezeigt (z. B. "16:9", "4:3").

> Diese Funktion kann in den Einstellungen deaktiviert werden (siehe [Tab Darstellung](#tab-darstellung)).

### Shift zum Sperren des Seitenverhaeltnisses

Halten Sie die **Shift**-Taste waehrend der Groessenaenderung gedrueckt, um das Seitenverhaeltnis zu sperren. Das Fenster behaelt seine aktuellen Proportionen bei, waehrend Sie ziehen.

> Diese Funktion kann in den Einstellungen deaktiviert werden (siehe [Tab Allgemein](#tab-allgemein)).

---

## Tastaturkurzbefehle

Alle Tastaturkurzbefehle sind im Tab Kurzbefehle der Einstellungen vollstaendig anpassbar. Standardwerte:

### Schnellvoreinstellungen

Druecken Sie **Control+Option+1** bis **Control+Option+9**, um das vorderste Fenster sofort auf eine benannte Voreinstellung zu aendern. Ein zentriertes HUD zeigt kurz den Voreinstellungsnamen und die Groesse an.

| Kurzbefehl | Standardvoreinstellung |
|------------|------------------------|
| Control+Option+1 | Writing (1280 x 800) |
| Control+Option+2 | Reading (900 x 1200) |
| Control+Option+3 | Browsing (1440 x 900) |
| Control+Option+4 | Sidebar (720 x 900) |
| Control+Option+5 | Preview (1920 x 1080) |

Schnellvoreinstellungen koennen (Name, Groesse und Kurzbefehl) im Tab Allgemein der Einstellungen bearbeitet werden. Bis zu 9 Voreinstellungen werden unterstuetzt.

### Schrittweise Groessenaenderung

Aendern Sie die Groesse des vordersten Fensters um 10 Pixel pro Tastendruck, wobei das Fenster zentriert bleibt:

| Kurzbefehl | Aktion |
|------------|--------|
| Control+Option+Right | Breite vergroessern (+10px) |
| Control+Option+Left | Breite verkleinern (-10px) |
| Control+Option+Up | Hoehe vergroessern (+10px) |
| Control+Option+Down | Hoehe verkleinern (-10px) |

### Praezisionsmodus

Halten Sie Shift fuer Anpassungen um 1 Pixel:

| Kurzbefehl | Aktion |
|------------|--------|
| Control+Option+Shift+Right | Breite vergroessern (+1px) |
| Control+Option+Shift+Left | Breite verkleinern (-1px) |
| Control+Option+Shift+Up | Hoehe vergroessern (+1px) |
| Control+Option+Shift+Down | Hoehe verkleinern (-1px) |

### Rueckgaengig / Wiederholen

| Kurzbefehl | Aktion |
|------------|--------|
| Control+Option+Z | Letzte Groessenaenderung rueckgaengig machen |
| Control+Option+Shift+Z | Wiederholen |

Jedes Fenster hat seinen eigenen Rueckgaengig/Wiederholen-Verlauf.

### HUD-Rueckmeldung

Wenn Sie einen Tastaturkurzbefehl verwenden, erscheint ein zentriertes HUD auf dem Zielfenster:

- **Schnellvoreinstellung:** zeigt den Voreinstellungsnamen (z. B. "Writing") mit Groesse darunter (z. B. "1280 x 800")
- **Schrittweise Groessenaenderung:** zeigt die aktuelle Groesse (z. B. "1290 x 800")
- **Rueckgaengig:** zeigt "Restored" mit der wiederhergestellten Groesse

Das HUD wird 0,8 Sekunden angezeigt und blendet dann aus.

---

## Einstellungen

Oeffnen Sie die Einstellungen ueber die Menuezeile: Klicken Sie auf das Window Resize-Symbol und waehlen Sie **"Einstellungen..."**.

Die Einstellungen sind in 4 Tabs unterteilt: **Allgemein**, **Darstellung**, **Kurzbefehle** und **Voreinstellungen**.

### Tab Allgemein

#### Schnellvoreinstellungen

Konfigurieren Sie bis zu 9 Schnellvoreinstellungen, die ueber Tastaturkurzbefehle (Control+Option+1-9) angewendet werden koennen. Jede Voreinstellung hat:

- **Kurzbefehl** — klicken Sie auf das Kurzbefehlfeld, um eine neue Tastenkombination aufzuzeichnen
- **Name** — eine beschreibende Bezeichnung (z. B. "Writing", "Coding")
- **Groesse** — Breite und Hoehe in Pixeln

Um eine Voreinstellung hinzuzufuegen, geben Sie Name, Breite und Hoehe in die Felder unten ein und klicken Sie auf **"Hinzufuegen"**. Um eine Voreinstellung zu entfernen, klicken Sie auf die X-Schaltflaeche daneben.

#### Beim Anmelden starten

Aktivieren Sie **"Beim Anmelden starten"**, damit Window Resize automatisch gestartet wird, wenn Sie sich bei macOS anmelden.

#### Shift-Verhaeltnissperre

Steuert, ob das Halten der Shift-Taste waehrend der Groessenaenderung das Seitenverhaeltnis sperrt. Standard: Ein.

#### Status der Bedienungshilfen

Ein Statusindikator zeigt den aktuellen Zustand der Berechtigung fuer Bedienungshilfen an:

| Indikator | Bedeutung |
|-----------|-----------|
| Gruen | Die Berechtigung ist aktiv und funktioniert ordnungsgemaess. |
| Orange | Die Berechtigung ist erteilt, aber nicht mehr gueltig (siehe [Veraltete Berechtigungen korrigieren](#veraltete-berechtigungen-korrigieren)). |
| Rot | Die Berechtigung wurde nicht erteilt. |

### Tab Darstellung

Konfigurieren Sie den visuellen Stil des Snap-Overlays:

- **Resize-Rahmen** — Rahmenfarbe und Linienstil waehrend der Groessenaenderung. Waehlen Sie aus 9 Farben (Rot, Orange, Gelb, Gruen, Cyan, Blau, Lila, Weiss, Grau) und 4 Stilen (Keiner, Durchgezogen, Gestrichelt, Animiert). Standard: Weiss, Animiert.
- **Snap-Rahmen** — Rahmen beim Einrasten des Fensters auf eine Voreinstellung. Standard: Weiss, Durchgezogen.
- **Seitenverhaeltnis anzeigen** — Seitenverhaeltnis-Anzeige im Overlay ein- oder ausschalten. Standard: Ein.

### Tab Kurzbefehle

Alle Tastaturkurzbefehle werden in einem 2-Spalten-Raster angezeigt und koennen individuell angepasst werden:

1. Klicken Sie auf das Kurzbefehlfeld neben einer Aktion.
2. Druecken Sie die gewuenschte Tastenkombination (muss mindestens eine Modifikatortaste enthalten).
3. Druecken Sie **Escape**, um die Aufzeichnung abzubrechen.

Wenn Sie einen Kurzbefehl aufzeichnen, der mit einer anderen Aktion in der App in Konflikt steht, erscheint ein Warndialog mit der Option **Ersetzen** (Kurzbefehl neu zuweisen) oder **Abbrechen**.

Ein Warnsymbol erscheint neben Kurzbefehlen, die mit bekannten Systemkurzbefehlen in Konflikt stehen (Mission Control, Spotlight usw.).

Klicken Sie auf **"Auf Standard zuruecksetzen"**, um alle Kurzbefehle auf ihre urspruenglichen Zuweisungen zurueckzusetzen.

### Tab Voreinstellungen

Der Tab Voreinstellungen zeigt 18 integrierte Voreinstellungsgroessen, sortiert nach Pixelflaeche (kleinste bis groesste). Jede Voreinstellung hat einen Aktivieren/Deaktivieren-Schalter:

- **Aktiviert** — die Voreinstellung wird fuer die Snap-Erkennung waehrend der Groessenaenderung verwendet
- **Deaktiviert** — die Voreinstellung wird von der Snap-Erkennung ausgeschlossen (mit 50% Deckkraft angezeigt)

Integrierte Voreinstellungen koennen nicht geloescht, sondern nur deaktiviert werden. Standardmaessig sind 6 Mac-spezifische Voreinstellungen (MacBook Air/Pro Displaygroessen) deaktiviert und 12 allgemeine Voreinstellungen aktiviert.

Die Kopfzeile zeigt, wie viele Voreinstellungen derzeit aktiviert sind (z. B. "12 of 18 enabled").

---

## Fehlerbehebung

### Veraltete Berechtigungen korrigieren

Wenn Sie einen orangefarbenen Statusindikator oder die Meldung "Bedienungshilfen: Aktualisierung noetig" sehen, ist die Berechtigung veraltet. Dies kann nach einem Update oder einer Neuerstellung der App geschehen.

**So beheben Sie das Problem:**

1. Oeffnen Sie **Systemeinstellungen > Datenschutz & Sicherheit > Bedienungshilfen**.
2. Suchen Sie **"Window Resize"** in der Liste.
3. Schalten Sie den Schalter **AUS** und dann wieder **EIN**.
4. Alternativ koennen Sie den Eintrag vollstaendig aus der Liste entfernen und die App erneut starten, um ihn wieder hinzuzufuegen.

### Snap funktioniert nicht

Wenn das Overlay waehrend der Groessenaenderung nicht erscheint:

- Ueberpruefen Sie, ob die Berechtigung fuer Bedienungshilfen aktiv ist (gruener Indikator in den Einstellungen).
- Stellen Sie sicher, dass das Fenster, dessen Groesse Sie aendern, die Standard-Groessenaenderung unterstuetzt (einige Apps schraenken die Fenstergroessenaenderung ein).
- Fenster im Vollbildmodus koennen nicht in der Groesse geaendert werden — verlassen Sie zuerst den Vollbildmodus.
- Pruefen Sie den Tab Voreinstellungen — die Zielgroesse koennte deaktiviert sein.

### Darstellungsprobleme nach dem Einrasten

In seltenen Faellen wird das Zielfenster nach dem Einrasten moeglicherweise nicht korrekt neu gezeichnet. Die App erzwingt automatisch ein Neuzeichnen, aber wenn visuelle Artefakte bestehen bleiben, minimieren Sie das Fenster und stellen Sie es wieder her.
