#!/bin/bash
# Teilnehmer-Probe: frische Clones, README.md und PROMPT.md wörtlich befolgen, Story 1 bauen.
# Aufruf: bash probe.sh <name>
set -u
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
export OPENCODE_MODEL=openai/gpt-5.4-mini
NAME="$1"
SCRATCH="$(cd "$(dirname "$0")" && pwd)"
ROOT="$SCRATCH/probe-$NAME"
PROTO="/Users/seb/Desktop/Claude Arbeitsfolder/sharp sharp AI/taskforce/compax_csd_mit_opencode/VendingMachine2026-opencode/protokolle/probe-$NAME"
mkdir -p "$ROOT" "$PROTO"
cd "$ROOT"
log() { echo "$(date +%H:%M:%S) $*" | tee -a "$PROTO/probe.log"; }
oc() { local name="$1"; shift; timeout 1200 opencode run -m "$OPENCODE_MODEL" "$@" < /dev/null > "$PROTO/$name.log" 2>&1; log "$name exit=$?"; }

# ---------- Weg A: README.md, Abschnitt "Auschecken und installieren"
log "=== Weg A: README"
mkdir -p a && cd a
git clone -q -b training-start https://github.com/sharpsharp-ai/VendingMachine2026-Start.git getraenkeautomat; log "clone start exit=$?"
git clone -q https://github.com/sharpsharp-ai/VendingMachine2026-opencode.git; log "clone paket exit=$?"
./VendingMachine2026-opencode/install.sh getraenkeautomat > "$PROTO/a-install.log" 2>&1; log "install exit=$?"
cd getraenkeautomat
mvn -q verify > "$PROTO/a-verify-start.log" 2>&1; log "verify am Start exit=$? (erwartet 1)"

# "Die erste Story mit der Pipeline": dieselben Commands wie im README, nicht-interaktiv
oc a-spec --command spec 1
oc a-akzeptanztest --command akzeptanztest 1
git add -A && git commit -qm "Story 1: Spec und Szenarien"; log "commit szenarien exit=$?"
scripts/bis-gruen.sh "Ein Getränk wählen" > "$PROTO/a-bis-gruen.log" 2>&1; log "bis-gruen exit=$?"
mvn -q verify > "$PROTO/a-verify-ende.log" 2>&1; log "verify am Ende exit=$? (erwartet 0)"
oc a-review --command review
git status --short > "$PROTO/a-git-status.txt"
git diff HEAD --stat >> "$PROTO/a-git-status.txt"

# ---------- Weg B: PROMPT.md in vanilla opencode einfügen (--auto steht für das Bestätigen im TUI)
log "=== Weg B: PROMPT"
cd "$ROOT" && mkdir -p b && cd b
git clone -q -b training-start https://github.com/sharpsharp-ai/VendingMachine2026-Start.git getraenkeautomat; log "clone start exit=$?"
curl -fsSL https://raw.githubusercontent.com/sharpsharp-ai/VendingMachine2026-opencode/main/PROMPT.md -o PROMPT.md; log "PROMPT.md geholt exit=$?"
cd getraenkeautomat
timeout 900 opencode run --auto -m "$OPENCODE_MODEL" "$(cat ../PROMPT.md)" < /dev/null > "$PROTO/b-prompt.log" 2>&1; log "opencode PROMPT exit=$?"
ls AGENTS.md opencode.json .opencode/commands .opencode/skills specs scripts > "$PROTO/b-ls.txt" 2>&1; log "ls nach Setup exit=$?"
mvn -q verify > "$PROTO/b-verify.log" 2>&1; log "verify nach Setup exit=$? (erwartet 1)"
diff -rq ../VendingMachine2026-opencode/paket/.opencode .opencode >> "$PROTO/probe.log" 2>&1; log "Paket identisch installiert: diff exit=$?"
log "=== done"
