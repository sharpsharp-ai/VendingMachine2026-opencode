#!/bin/bash
# Ruft den Implementierer für ein Szenario auf, bis `mvn -q verify` grün ist. Höchstens 5 Runden.
# Aufruf:  scripts/bis-gruen.sh "<Titel des Szenarios>"
# Modell:  OPENCODE_MODEL=anbieter/modell   (sonst das konfigurierte)
# Runden:  MAX_RUNDEN=5
set -u
cd "$(dirname "$0")/.."
if [ $# -lt 1 ]; then
  echo "Aufruf: scripts/bis-gruen.sh \"<Titel des Szenarios>\""
  exit 2
fi
SZENARIO="$1"
MAX="${MAX_RUNDEN:-5}"
MODEL=()
[ -n "${OPENCODE_MODEL:-}" ] && MODEL=(-m "$OPENCODE_MODEL")
LOG="target/bis-gruen.log"
mkdir -p target
for RUNDE in $(seq 1 "$MAX"); do
  echo "### Runde $RUNDE von $MAX: /implementiere $SZENARIO"
  opencode run "${MODEL[@]}" --command implementiere "$SZENARIO" < /dev/null
  if mvn -q verify > "$LOG" 2>&1; then
    echo "### Grün nach Runde $RUNDE."
    exit 0
  fi
  echo "### Noch rot. Letzte Zeilen:"
  tail -15 "$LOG"
done
echo "### Abbruch: nach $MAX Runden nicht grün. Ganzer Report: $LOG"
git status --short
exit 1
