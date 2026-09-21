#!/bin/bash
# Installiert das opencode-Paket in ein Projekt.
# Aufruf: ./install.sh /pfad/zum/projekt [--force]
# Idempotent: kopiert paket/ ins Projekt, meldet je Datei kopiert oder unverändert.
# Eine vorhandene, abweichende AGENTS.md bleibt stehen; --force überschreibt sie.
set -euo pipefail
HIER="$(cd "$(dirname "$0")" && pwd)"
ZIEL="${1:?Aufruf: ./install.sh /pfad/zum/projekt [--force]}"
FORCE="${2:-}"
[ -f "$ZIEL/pom.xml" ] || { echo "Kein Maven-Projekt in $ZIEL (pom.xml fehlt)"; exit 1; }
ZIEL="$(cd "$ZIEL" && pwd)"
cd "$HIER/paket"
find . -type f | sort | while read -r f; do
  f="${f#./}"
  if [ "$f" = "AGENTS.md" ] && [ -f "$ZIEL/AGENTS.md" ] && ! cmp -s AGENTS.md "$ZIEL/AGENTS.md" && [ "$FORCE" != "--force" ]; then
    echo "übersprungen $f (vorhanden und anders; --force überschreibt)"
    continue
  fi
  mkdir -p "$ZIEL/$(dirname "$f")"
  if [ -f "$ZIEL/$f" ] && cmp -s "$f" "$ZIEL/$f"; then
    echo "unverändert  $f"
  else
    cp "$f" "$ZIEL/$f"
    echo "kopiert      $f"
  fi
done
chmod +x "$ZIEL"/scripts/*.sh
if [ -x "$ZIEL/scripts/steps-glossar.sh" ]; then
  (cd "$ZIEL" && scripts/steps-glossar.sh)
fi
echo "Fertig. opencode im Projekt starten (oder neu starten), dann: /spec 1"
