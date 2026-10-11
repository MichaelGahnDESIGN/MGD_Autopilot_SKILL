---
name: autopilot
description: Lasse Claude ein Ziel eigenständig abarbeiten — planen, umsetzen, prüfen, korrigieren, fertig machen. Mit Selbstkorrektur und harten Stoppregeln.
---

# /autopilot — Ein Ziel zu Ende bringen

Claude arbeitet unbeaufsichtigt an deinem Ziel, bis es fertig ist. Das Wichtigste: **Prüfung statt nur Umsetzung.** Ein Agent, der schnell Code schreibt und nicht nachprüft, produziert Fehler, die niemand merkt.

**Leitsatz:** Nur was nachweislich funktioniert, gilt als fertig — nicht, was logisch aussieht.

## Aufruf

```bash
/autopilot dein Ziel hier
```

## Die 4 Phasen

### Phase 0: Den Vertrag klären (MUSS vor Start)

Beantworte diese zwei Fragen, sonst startet nichts:

1. **Fertig, wenn:** … (messbar, z.B. „`npm test` sagt OK" oder „Live zeigt Version 2.0")
2. **Aufgeben, wenn:** … (z.B. „nach 3 Versuchen" oder „nach 20 Arbeits-Runden")

Ohne diese Grenzen dreht Claude sich im Kreis.

### Phase 1: Planen

Claude schaut sich das Projekt an, teilt die Aufgabe in Schritte auf und prüft den aktuellen Zustand.

**Was du siehst:** Ein Plan mit TODO-Punkte.

### Phase 2: Umsetzen (Schritt für Schritt)

Für jeden Schritt:
1. Datei ändern
2. Test laufen lassen → prüfen ob OK
3. Nächster Schritt

**Wichtig:** Nach **jedem** Schritt prüfen, nicht erst am Ende.

### Phase 3: Prüfung

Claude prüft: Ist das Ziel erreicht? Tests grün? Kein Fehler? Wenn nein, korrigieren → zurück zu Phase 2.

### Phase 4: Aufschreiben

Die Änderungen dokumentieren, Aufgaben-Liste updaten, fertig.

## Sichere Grenzen (Autopilot überschreitet nie)

- ❌ **Nicht pushen** zu GitHub
- ❌ **Nicht deployen** live
- ❌ **Nicht:** Zahlungen, Sicherheits-Einstellungen, rechtliche Texte ändern

Bei diesen Grenzen **fragt Claude immer** — auch im Autopilot.

## Praktisches Beispiel

```
Michael: /autopilot Migriere alle Login-Aufrufe auf das neue System, stop nach 3 Versuchen

Claude startet:
  Schritt 1: Login-Aufrufe in Datei 1 + 2 aktualisieren, Tests laufen lassen ✓
  Schritt 2: Datei 3 + 4, Tests ✓
  Schritt 3: Datei 5, Tests ✓
  
Prüfung: Alle Logins zeigen neue Versión, kein Fehler → Fertig ✓
```

## Welches Modell?

- **Planer (du):** Claude 5 Sonnet — macht den Plan, prüft das Ergebnis
- **Arbeiter:** Claude Haiku — billig, schnell, macht die Schritte
- **Prüfer:** Automatisch — schaut nach jedem Schritt, ob alles OK ist

Das sparte Token und Geld.

## Häufige Fragen

**F: Was passiert, wenn Claude einen Fehler macht?**  
A: Der Test schlägt fehl → Claude sieht es selbst → korrigiert es → Test nochmal. Das ist die Selbstkorrektur.

**F: Kann Claude steckenbleiben?**  
A: Ja. Deshalb die Aufgaben-Grenze („nach 3 Versuchen"). Dann stoppt Claude automatisch und zeigt dir, was noch fehlt.

**F: Was ist besser — /autopilot oder /goal?**  
A: `/goal` ist schneller für einfache Ziele. `/autopilot` ist sicherer, weil es mehr prüft. Wähle `/autopilot` für kritische Aufgaben.
