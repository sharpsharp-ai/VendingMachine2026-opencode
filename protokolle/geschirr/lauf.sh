#!/bin/bash
# lauf.sh <name> <bis-story>: Verifikationslauf über die Pipeline, nicht-interaktiv, mit Protokollen.
S="$(cd "$(dirname "$0")" && pwd)"
ST="/Users/seb/Desktop/Claude Arbeitsfolder/sharp sharp AI/taskforce/compax_csd_mit_opencode/vending_machine_start"
PK="/Users/seb/Desktop/Claude Arbeitsfolder/sharp sharp AI/taskforce/compax_csd_mit_opencode/VendingMachine2026-opencode"
NAME="$1"; BIS="${2:-7}"; VON="${3:-1}"
W="$S/lauf-$NAME"; PROT="$PK/protokolle/lauf-$NAME"; mkdir -p "$PROT"
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
export OPENCODE_MODEL="${OPENCODE_MODEL:-openai/gpt-5.4-mini}"
if [ ! -d "$W" ]; then
  git -C "$ST" worktree add -q "$W" -b "lauf-$NAME" training-start || exit 1
  cd "$W" && echo "Paket liegt seit Iteration 15 im Startstand, nichts zu installieren" > "$PROT/install.log"
fi
cd "$W" || exit 1
oc() { local log="$PROT/$1.log"; shift; timeout 1200 opencode run -m "$OPENCODE_MODEL" "$@" < /dev/null 2>&1 | sed 's/\x1b\[[0-9;]*m//g' > "$log"; }
for STORY in $(seq "$VON" "$BIS"); do
  echo "=== Story $STORY  $(date +%H:%M:%S)"
  if [ "${RESUME:-0}" = "1" ] && [ "$STORY" = "$VON" ]; then
    # Wiederaufnahme nach Abbruch: Spec und Szenarien sind schon committet, nur die Implementierung fehlt.
    echo "    Wiederaufnahme: Spec und Szenarien aus $(git log -1 --format=%h)"
    FEATURES=$(git diff --name-only HEAD~1 HEAD -- src/test/resources/features | while read -r f; do [ -f "$f" ] && echo "$f"; done)
  else
    oc "s$STORY-1-spec" --command spec "$STORY"
    oc "s$STORY-2-akzeptanztest" --command akzeptanztest "$STORY"
    FEATURES=$(git status --short -- src/test/resources/features | awk '{print $2}' | while read -r f; do [ -f "$f" ] && echo "$f"; done)
    git add -A; git commit -qm "Story $STORY: Spec und Szenarien"
  fi
  # Keine Feature-Datei geändert (das vorhandene Szenario deckt die Karte schon ab): dann alle Szenarien durchgehen.
  [ -z "$FEATURES" ] && FEATURES=$(ls src/test/resources/features/*.feature)
  echo "    Feature-Dateien: $FEATURES"
  K=0
  grep -hE '^\s*(Szenario|Szenariogrundriss):' $FEATURES | sed -E 's/^[[:space:]]*(Szenario|Szenariogrundriss):[[:space:]]*//' | while read -r TITEL; do
    K=$((K+1)); echo "    Szenario $K: $TITEL  $(date +%H:%M:%S)"
    scripts/bis-gruen.sh "$TITEL" > "$PROT/s$STORY-3-impl-$K.log" 2>&1; echo "    bis-gruen exit=$?"
    cp target/bis-gruen.log "$PROT/s$STORY-3-impl-$K-verify.log" 2>/dev/null
  done
  UNERLAUBT=$(git status --short -- src/test/resources/features specs src/test/java/de/sharpsharp/vendingmachine/VendingMachineSteps.java src/test/java/de/sharpsharp/vendingmachine/ParameterTypes.java pom.xml config)
  echo "    Implementierer hat Features/Specs/Schritte/Gates geändert: ${UNERLAUBT:-nein}"
  mvn -q verify > "$PROT/s$STORY-4-verify.log" 2>&1; echo "    mvn -q verify exit=$?"
  oc "s$STORY-5-review" --command review
  echo "    Review: $(tail -3 "$PROT/s$STORY-5-review.log" | tr '\n' ' ' | cut -c1-160)"
  bash "$S/checks.sh" "$STORY" > "$PROT/s$STORY-6-http.log" 2>&1; echo "    HTTP: $(grep RESULT "$PROT/s$STORY-6-http.log")"
  git add -A; git commit -qm "Story $STORY: implementiert"
done
echo "=== done $(date +%H:%M:%S)"
