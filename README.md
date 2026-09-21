# opencode für den Getränkeautomaten

Dieses Paket gibt opencode im Trainingsprojekt feste Rollen und feste Schritte: Spec, Szenarien,
Implementierung, Review. Jeder Schritt ist ein Command, jede Rolle hat nur die Rechte, die sie braucht,
und `mvn -q verify` entscheidet, was fertig ist.

## Voraussetzungen

JDK 17, Maven, git, opencode (`opencode --version`) mit einem konfigurierten Modell.

## Auschecken und installieren

```bash
git clone -b training-start https://github.com/sharpsharp-ai/VendingMachine2026-Start.git getraenkeautomat
# im Training: git clone <URL eures Team-Repos> getraenkeautomat
git clone https://github.com/sharpsharp-ai/VendingMachine2026-opencode.git
./VendingMachine2026-opencode/install.sh getraenkeautomat
cd getraenkeautomat
mvn -q verify        # rot: das Szenario "Ein Getränk wählen" wartet auf euch. Richtig so.
```

Wer lieber opencode installieren lässt: opencode im Projektordner starten, den Text aus `PROMPT.md` einfügen.

## Die erste Story mit der Pipeline

```text
opencode                             im Projektordner starten
/spec 1                              Spec nach specs/1-alles-umsonst/spec.md
/akzeptanztest 1                     Szenarien nach features/, Schritte nach VendingMachineSteps.java
/implementiere Ein Getränk wählen    genau ein Szenario grün, Test zuerst
/review                              Befunde mit Datei:Zeile, Smell, Vorschlag
```

Vor jedem Command eine neue Session (`/new`): Der Command bringt alles mit, was die Rolle wissen muss.
Nach jedem grünen Szenario committen. Vom Terminal aus, ohne Oberfläche:

```bash
scripts/bis-gruen.sh "Ein Getränk wählen"    # ruft den Implementierer bis zu fünfmal, bis mvn -q verify grün ist
```

## Was das Paket ins Projekt legt

| Datei | Wirkung |
|---|---|
| `AGENTS.md` | Befehle, Struktur, Arbeitsweise, Code-Regeln. Liest jede Rolle in jeder Session |
| `src/test/resources/features/AGENTS.md` | Regeln für Szenarien. Lädt opencode, sobald eine Feature-Datei gelesen wird |
| `opencode.json` | die vier Rollen mit ihren Rechten, die Bash-Whitelist |
| `.opencode/commands/*.md` | `/spec`, `/akzeptanztest`, `/implementiere`, `/review` |
| `.opencode/skills/*/SKILL.md` | Checklisten: EARS, elf Regeln für Akzeptanztests, TDD-Zyklus, Clean-Code-Check |
| `scripts/bis-gruen.sh` | Implementierer in Schleife, bis grün, höchstens fünf Runden |

## Rollen und Rechte

| Rolle | Darf ändern | Bash |
|---|---|---|
| `spec-autor` | nur `specs/` | mvn, ls, cat, grep, git status/diff/log |
| `test-autor` | Feature-Dateien, `*Steps.java`, `ParameterTypes.java`, `Fake*.java` | dieselbe Liste plus `scripts/steps-glossar.sh` |
| `implementierer` | alles außer Feature-Dateien, Schritten, `specs/`, `pom.xml`, `config/`, `.opencode/`, `AGENTS.md` | dieselbe Liste |
| `reviewer` | nichts | dieselbe Liste |

Keine Rolle darf ins Netz, Fragen stellen oder außerhalb des Projekts arbeiten. Was nicht auf der Whitelist
steht, ist verboten, auch `sed -i` und `python3`: Dateien ändert nur das Edit-Werkzeug, und das prüft die Rechte.
