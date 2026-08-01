#!/bin/bash
# Autopilot-Selbstkorrektur für Claude Code.
#
# Läuft als PostToolUse-Hook nach jeder Edit/Write-Aktion, führt die
# Projektprüfung aus und spielt das Ergebnis über additionalContext ZURÜCK ins
# Modell. Der Agent sieht seinen eigenen Fehler und korrigiert ihn selbst.
#
# Einbau nach .claude/hooks/validate.sh, ausführbar machen (chmod +x), dann in
# .claude/settings.json eintragen:
#
#   { "hooks": { "PostToolUse": [ { "matcher": "Edit|Write",
#       "hooks": [ { "type": "command",
#         "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/validate.sh" } ] } ] } }
#
# WICHTIG: Nach dem Einbau gegenprüfen — absichtlich einen Fehler einbauen, eine
# Datei ändern und nachsehen, ob die Rückmeldung wirklich ankommt. Ein Hook, der
# stillschweigend nichts tut, ist schlimmer als keiner.

set -uo pipefail

# ── Projektbefehle: HIER ANPASSEN ────────────────────────────────────────────
TEST_CMD="npm test --silent"
LINT_CMD="npm run lint --silent"
# Nur diese Dateiendungen lösen eine Prüfung aus (leer = alle).
WATCH_EXT="ts|tsx|js|jsx"
# ─────────────────────────────────────────────────────────────────────────────

INPUT=$(cat)
FILE=$(printf '%s' "$INPUT" | jq -r '.tool_response.filePath // .tool_input.file_path // empty')

# Nichts zu tun: keine Datei erkennbar oder Endung nicht überwacht.
[ -z "$FILE" ] && exit 0
if [ -n "$WATCH_EXT" ] && ! printf '%s' "$FILE" | grep -qE "\.($WATCH_EXT)$"; then
  exit 0
fi

ausgabe=""
fehlgeschlagen=0

if [ -n "$LINT_CMD" ]; then
  if ! lint_out=$(eval "$LINT_CMD" 2>&1); then
    fehlgeschlagen=1
    ausgabe+="LINT fehlgeschlagen:"$'\n'"$(printf '%s' "$lint_out" | tail -40)"$'\n\n'
  fi
fi

if [ -n "$TEST_CMD" ]; then
  if ! test_out=$(eval "$TEST_CMD" 2>&1); then
    fehlgeschlagen=1
    ausgabe+="TESTS fehlgeschlagen:"$'\n'"$(printf '%s' "$test_out" | tail -60)"$'\n'
  fi
fi

if [ "$fehlgeschlagen" -eq 0 ]; then
  exit 0
fi

# Fehler an das Modell zurückspielen. additionalContext MUSS in
# hookSpecificOutput verschachtelt sein — auf oberster Ebene wird es
# stillschweigend ignoriert.
jq -cn --arg ctx "$ausgabe" --arg datei "$FILE" '{
  decision: "block",
  reason: ("Prüfung nach Änderung an " + $datei + " fehlgeschlagen"),
  hookSpecificOutput: {
    hookEventName: "PostToolUse",
    additionalContext: ("Deine letzte Änderung an " + $datei
      + " hat die Projektprüfung gebrochen. Lies die Ausgabe vollständig, behebe die URSACHE"
      + " (nicht das Symptom) und prüfe erneut. Unterdrücke den Fehler nicht.\n\n" + $ctx)
  }
}'
exit 0
