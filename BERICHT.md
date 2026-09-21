# Bericht: opencode-Trainingspaket für den Getränkeautomaten

Stand 2026-09-22. opencode 1.18.30. Verifiziert mit `openai/gpt-5.4-mini` (nicht Sonnet: günstiger, und
näher an einem schwachen Modell). Alle Läufe nicht-interaktiv mit `opencode run`, Protokolle unter `protokolle/`.

## 1. Was Sebastian morgen sagt und tut

Vorab, einmal: die drei Team-Repos aus `VendingMachine2026-Start`, Branch `training-start`, anlegen
(Konzept in `taskforce/compax_csd_mit_opencode/trainings-repos.md`); die Teilnehmerinnen bekommen die Clone-URL mit Token.
Beim Kunden hängt hinter opencode Qwen 3.6; das Paket setzt kein Modell, es nimmt das konfigurierte.

Für die Teilnehmerinnen, in dieser Reihenfolge (steht so im `README.md` des Pakets):

```bash
git clone -b training-start <URL des Team-Repos> getraenkeautomat
git clone https://github.com/sharpsharp-ai/VendingMachine2026-opencode.git
./VendingMachine2026-opencode/install.sh getraenkeautomat
cd getraenkeautomat
mvn -q verify        # rot: ein Szenario wartet. Richtig so.
opencode             # neu starten, falls es schon lief: erst dann kennt es die Commands
```

Dann je Story, jeder Command in einer neuen Session (`/new`), nach jedem Schritt lesen und entscheiden:

```text
/spec 1                              Regeln lesen: stimmen sie mit der Karte überein?
/akzeptanztest 1                     Szenarien gegen die elf Regeln prüfen, dann committen
/implementiere Ein Getränk wählen    Diff lesen, mvn -q verify, committen; je Szenario einmal
/review                              Befunde annehmen oder verwerfen
```

Wer lieber tippt als klickt: `scripts/bis-gruen.sh "Ein Getränk wählen"` ruft den Implementierer bis zu fünfmal.
Wer opencode das Setup machen lassen will: Text aus `PROMPT.md` einfügen (Weg B der Teilnehmer-Probe).

## 2. Stand der Abnahmekriterien

TODO-ABNAHME

## 3. Hypothesen H1 bis H4, opencode 1.18.30

Getestet mit einem Mini-Projekt (`AGENTS.md` mit Marker ZEBRA, `sub/AGENTS.md` mit Marker GIRAFFE, zwei Agents, ein Command).
Skript und Ausgabe: `protokolle/h-tests/`.

| Hypothese | Ergebnis | Folge fürs Setup |
|---|---|---|
| H1: eigener `prompt` ersetzt den eingebauten System-Prompt; Agent ohne `prompt` behält ihn | Bestätigt, mit Ergänzung: `AGENTS.md`, Umgebung und Skills werden in jedem Fall angehängt (Marker ZEBRA erschien bei allen drei Agents). Quelle: `session/llm/request.ts` im opencode-Quelltext, und der Lauf. Nebenbefund: nur der eingebaute `build`-Agent hat `apply_patch`, eigene Agents haben `edit` | Die vier Rollen haben keinen `prompt`, nur Rechte. Die Rollenanweisung steht im Command |
| H2: verschachtelte `AGENTS.md` lädt, sobald eine Datei darunter gelesen wird | Bestätigt: GIRAFFE erschien nur nach `Read sub/info.txt`, nicht beim Lesen im Root | `src/test/resources/features/AGENTS.md` mit den Szenarien-Regeln |
| H3: `opencode run` läuft durch, wenn keine Permission auf `ask` steht | Bestätigt, und schärfer: `ask` hängt nicht, es wird im `run`-Modus automatisch abgelehnt ("auto-rejecting"), der Lauf endet mit Exit 0. `--auto` erlaubt alles, was nicht `deny` ist. `edit: deny` allein hält nicht: das Modell schrieb die Datei per `bash` mit einem Python-Heredoc | Bash-Whitelist in `opencode.json` (mvn, git, ls, cat, grep, `scripts/*`), alles andere `deny`. Kein `ask` in den Rollen. Zweiter Fund: `opencode run` in Skripten braucht `< /dev/null`, sonst hängt es an der offenen stdin-Pipe |
| H4: Command mit `agent:`, `@datei`, `` !`befehl` `` | Bestätigt: Agent wurde gewählt, `$ARGUMENTS` kam an (auch innerhalb von `` !`…` ``), Dateiinhalt und Shell-Ausgabe standen im Prompt | Jeder Command bringt Spec, Glossar, Schritte, Automat und den `mvn`-Stand mit |

## 4. Entscheidungen und Annahmen

- Drei Klassen statt Ports und Adapter: `VendingMachine`, `Drink`, `Main`. ArchUnit prüft stattdessen: nur `Main` kennt Javalin und Jackson, nichts hängt von `Main` ab.
- Rollen ohne eigenen Prompt (H1); die Rechte in `opencode.json` sind der Zaun, der Command ist die Anweisung.
- Fertig-Kriterium ist allein `mvn -q verify`: Cucumber, Unit-Tests, Checkstyle (Methoden 20 Zeilen, Dateien 200, Komplexität 6), ArchUnit, JaCoCo 80 % Zeilen ohne `Main`. Rauchtest mit Chrome nur auf Wunsch (`-Dtest=RunSmokeTest`) und in der CI.
- Preise kommen erst mit Story 2: `Drink` hat keinen Preis, `VendingMachine.price(Drink)` liefert null, die Seite zeigt dann keinen.
- Das Glossar (`specs/glossar.md`, erzeugt aus den Schritten) ist die eine Stelle, die Fachwort, Codename und Methode verbindet. Es steckt in `/spec` und `/akzeptanztest`.
- Parametertyp `{betrag}` liegt im Start, damit Beträge wie "1,00 €" ohne Regex-Arbeit des Modells ankommen.
- `WebTest` prüft nach Aktionen nur, dass ein Zustand kommt, nicht den Text: sonst zwingt er den Implementierer, Texte in `Main` festzunageln.
- Java 17, Mockito im Start, JUnit 4 (ArchUnit-JUnit-4-Runner, Cucumber-JUnit-4).
- Verifikationsmodell `openai/gpt-5.4-mini` statt Sonnet 4.5: Sebastians Vorgabe, Budget.
- Kein Ollama, kein lokales Qwen: Sebastians Vorgabe für heute.

## 5. Offene Risiken

TODO-RISIKEN

## 6. Wo was liegt

| Was | Wo |
|---|---|
| Paket, Installer, README, PROMPT, Folien, Baseline, Protokolle, dieser Bericht | `github.com/sharpsharp-ai/VendingMachine2026-opencode` (öffentlich), lokal `taskforce/compax_csd_mit_opencode/VendingMachine2026-opencode/` |
| Startstand der Teams | `github.com/sharpsharp-ai/VendingMachine2026-Start`, Branch `training-start`; lokal Worktree `vending_machine_training_start/` |
| Referenzlösung | `github.com/sharpsharp-ai/VendingMachine2026` (privat), lokal `vending_machine_1shot/` |
| Folien | `folien/folien.pdf`, `folien/folien.pptx`, Quelle `folien/folien.py`; Kopien in `~/Downloads`; TODO-MIRO |
| Baseline Story 1 ohne Paket | `baseline/` (Prompt, zwei Läufe, Diff) |
| Verifikationsläufe | `protokolle/lauf-*/` (je Story: Spec, Szenarien, Implementierung je Szenario, verify, Review, HTTP-Prüfung), `protokolle/probe-*/` (Teilnehmer-Probe) |
| Iterationen am Setup | `ITERATIONEN.md` |
| Konzept Team-Repos | `taskforce/compax_csd_mit_opencode/trainings-repos.md` |
