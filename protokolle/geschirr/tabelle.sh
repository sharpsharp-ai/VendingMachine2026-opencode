#!/bin/bash
# Bewertungstabelle je Story aus lauf-N.log und den Implementierer-Protokollen.
# Aufruf: bash tabelle.sh N
N="$1"
LOG="lauf-$N.log"
PROTO="/Users/seb/Desktop/Claude Arbeitsfolder/sharp sharp AI/taskforce/compax_csd_mit_opencode/VendingMachine2026-opencode/protokolle/lauf-$N"
echo "| Story | Szenarien | bis-gruen | Test zuerst rot | Fremdänderung | verify | Review | HTTP |"
echo "|---|---|---|---|---|---|---|---|"
for S in 1 2 3 4 5 6 7; do
  block=$(awk -v s="=== Story $S " 'index($0,s)==1{f=1;next} /^=== Story/{f=0} f' "$LOG")
  [ -z "$block" ] && continue
  szen=$(echo "$block" | grep -c "Szenario [0-9]*:")
  bg=$(echo "$block" | grep -o "bis-gruen exit=[0-9]*" | sed 's/bis-gruen exit=//' | tr '\n' ' ')
  fremd=$(echo "$block" | grep -o "Gates geändert: .*" | sed 's/Gates geändert: //')
  verify=$(echo "$block" | grep -o "mvn -q verify exit=[0-9]*" | sed 's/.*exit=//')
  review=$(echo "$block" | grep "Review:" | grep -q "Keine wesentlichen Befunde" && echo "keine wesentlichen Befunde" || echo "Befunde, siehe s$S-5-review.log")
  http=$(echo "$block" | grep -o "HTTP: RESULT [A-Z]*" | sed 's/HTTP: RESULT //')
  # Test zuerst: in jedem Implementierer-Log, das Code geändert hat, kommt ein roter Testlauf vor dem ersten grünen
  tf=""
  for f in "$PROTO"/s$S-3-impl-*.log; do
    case "$f" in *-verify.log) continue;; esac
    grep -qE "Geändert: keine|Geänderte Dateien: keine" "$f" && continue
    first_red=$(grep -nE "Failures: [1-9]|Errors: [1-9]|COMPILATION ERROR" "$f" | head -1 | cut -d: -f1)
    first_green=$(grep -nE "Tests run: [0-9]+, Failures: 0, Errors: 0" "$f" | head -1 | cut -d: -f1)
    i=$(basename "$f" .log | sed 's/.*impl-//')
    if [ -n "$first_red" ] && { [ -z "$first_green" ] || [ "$first_red" -lt "$first_green" ]; }; then tf="$tf $i:ja"; else tf="$tf $i:PRÜFEN"; fi
  done
  echo "| $S | $szen | $bg| ${tf# } | $fremd | $verify | $review | $http |"
done
