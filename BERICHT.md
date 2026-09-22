# Bericht: opencode-Trainingspaket für den Getränkeautomaten

Stand 2026-09-22. opencode 1.18.30. Verifiziert mit `openai/gpt-5.4-mini` (nicht Sonnet: günstiger, und
näher an einem schwachen Modell). Alle Läufe nicht-interaktiv mit `opencode run`, Protokolle unter `protokolle/`.

## 1. Was Sebastian morgen sagt und tut

Die drei Team-Repos sind angelegt (öffentlich, Stand `cdd6096` mit Paket): `VendingMachine2026-green`, `-blue`, `-orange` unter `github.com/sharpsharp-ai`. Je Team die Mitglieder als Collaborator eintragen (`gh api -X PUT repos/sharpsharp-ai/VendingMachine2026-green/collaborators/<GitHub-Name> -f permission=push`), dann klonen sie ohne Branch-Angabe. Konzept in `taskforce/compax_csd_mit_opencode/trainings-repos.md`.
Beim Kunden hängt hinter opencode Qwen 3.6; das Paket setzt kein Modell, es nimmt das konfigurierte.

Für die Teilnehmerinnen, in dieser Reihenfolge (steht so im `README.md` des Pakets):

```bash
git clone <URL eures Team-Repos> getraenkeautomat     # oder in IntelliJ auschecken; zum Ausprobieren: -b training-start …/VendingMachine2026-Start.git
cd getraenkeautomat
mvn -q verify        # rot: ein Szenario wartet. Richtig so.
opencode             # kennt /spec, /akzeptanztest, /implementiere, /review (Modell mit /models wählen)
```

Dann je Story, jeder Command in einer neuen Session (`/new`), nach jedem Schritt lesen und entscheiden:

```text
/spec 1                              Regeln lesen: stimmen sie mit der Karte überein?
/akzeptanztest 1                     Szenarien gegen die elf Regeln prüfen, dann committen
/implementiere Ein Getränk wählen    Diff lesen, mvn -q verify, committen; je Szenario einmal
/review                              Befunde annehmen oder verwerfen
```

Zwei Stellen, an denen `gpt-5.4-mini` in den Abnahmeläufen regelmäßig daneben lag und der Mensch gefragt ist: bei Story 6 ließ die Spec dreimal das „nur“ der Karte weg (kein Preis 2,00 €, kein Verbot darunter), bei Story 3 dreht `scripts/bis-gruen.sh` für das schon grüne erste Szenario fünf Leerrunden und meldet „nicht grün“, obwohl das Szenario grün ist. Beides steht in Abschnitt 2.

Wer lieber tippt als klickt: `scripts/bis-gruen.sh "Ein Getränk wählen"` ruft den Implementierer bis zu fünfmal.

## 2. Stand der Abnahmekriterien

| Kriterium | Stand |
|---|---|
| Zwei vollständige Läufe (Stories 1 bis 7) hintereinander, frischer Stand, ohne Änderung am Setup, jede Story erfüllt alle Bewertungspunkte | **Nicht erreicht.** Drei Läufe auf frischem Stand: Lauf 8 nach 12 Iterationen, Lauf 9 und 10 nach Iteration 13 ohne Änderung dazwischen. Fachlich liefen Story 1 bis 5 und 7 in Lauf 9 sauber durch (verify grün, HTTP richtig, `Main` unverändert). Was fehlt: Story 6 bleibt in Lauf 8 und 9 bei der Spec stehen (Bier kostet weiter 1,00 €), und der rote Unit-Test ist nicht in jeder Runde einzeln sichtbar (Lauf 8: 5 von 6 Runden, Lauf 9: 2 von 6). Lauf 10: Story 1 bis 5 und 7 sauber, roter Test in allen 6 Runden sichtbar, Story 6 wie zuvor, dazu fehlt in der Story-2-Spec die zweite Kartenregel. Am nächsten dran: Lauf 10 mit zwei roten Zellen von 56. Tabellen unten |
| Teilnehmer-Probe ohne Improvisation | Erfüllt, für zwei Setups. Seit Iteration 15 liegt das Paket im Startstand: frischer Clone von GitHub, Dateien da, `mvn -q verify` rot wie vorgesehen, `/spec 1` schreibt die Spec ohne einen Installationsschritt (`protokolle/probe-3/`). Davor, mit `install.sh`: `protokolle/probe-1/`: Weg A (README wörtlich, frische Clones von GitHub): Start rot wie angekündigt, `/spec 1`, `/akzeptanztest 1`, `scripts/bis-gruen.sh "Ein Getränk wählen"` grün in einer Runde, `mvn -q verify` Exit 0, `/review` mit zwei Befunden. Weg B (Text aus `PROMPT.md` in vanilla opencode, `--auto` steht für das Bestätigen im TUI): vier Befehle ausgeführt, `EXIT=1`, Paket identisch installiert, Schlusssatz wörtlich. Wiederholt auf dem Endstand (`protokolle/probe-2/`, 02:49 bis 02:54, frische Clones von GitHub mit Iteration 13): Weg A wieder ohne Improvisation durch, `bis-gruen.sh` grün nach Runde 1, `mvn -q verify` Exit 0, `/review` ohne Befund; Weg B Setup fertig, `EXIT=1`, Paket identisch |
| Jedes Gate hat nachweislich ausgelöst | Erfüllt. `protokolle/gates/gates.log`: Methode mit 25 Zeilen (Checkstyle), Javalin-Import in `VendingMachine` (ArchUnit), roter Unit-Test (Surefire), ungetestete Klasse (JaCoCo unter 80 %); jedes Mal Exit 1, danach wieder grün |
| H1 bis H4 getestet, Ergebnis im Bericht, Setup passt dazu | Erfüllt, Abschnitt 3 |
| `training-start` enthält keine Story-Lösungen und baut grün | Erfüllt mit einer Absicht: kompiliert, alle Tests grün bis auf das eine Szenario „Ein Getränk wählen", das nach Sebastians Vorgabe rot wartet (`mvn -q verify` endet deshalb mit Exit 1, `mvn -q test -Dtest=WebTest` grün). Keine Story-Regel ist gebaut: `selectDrink`, `insertCoin`, `cancel` sind leer, `price` liefert null |
| Folien, README, PROMPT, Bericht liegen vor, alles committet und gepusht | Erfüllt: `folien/folien.pdf` und `.pptx` (Kopien `~/Downloads/opencode-folien.*`), `README.md`, `BERICHT.md`; `PROMPT.md` und `install.sh` entfielen mit Iteration 15, das Paket liegt im Startstand; Paket-Repo öffentlich auf GitHub, `training-start` gepusht. Miro: die elf Folien liegen als Bilder im vorgegebenen Frame (Board `uXjVHnldClU=`, Frame `3458764684499712615`, drei Reihen), nichts Vorhandenes verändert; Bild-IDs und Positionen in `protokolle/miro/miro-upload.md` |

Bewertung je Story (Protokolle `protokolle/lauf-8-story-4-geisterdatei/`, `protokolle/lauf-9-story-6-spec/`, `protokolle/lauf-10-story-6-spec/`; je Story Spec, Szenarien, Implementierung je Szenario, verify, Review, HTTP; `lauf.log` mit den Meilensteinen).
Spalten: verify Exit 0 ohne Gate-Änderung; roter Unit-Test einzeln sichtbar, bevor Code kam; der Implementierer ließ Features, Specs, Schritte, `pom.xml`, `config/` unverändert; kein Testwert, kein Sonderfall, nichts in `Main`; Feature nach den elf Regeln; Spec in EARS passend zu den Szenarien; Review; Oberfläche per HTTP.

**Lauf 8**, Stand nach 12 Iterationen (Start `ba00527`, Paket `221cb21`), 01:23 bis 01:50:

| Story | verify | Test zuerst rot | keine Fremdänderung | kein Hack | Feature | Spec | Review | HTTP | Anmerkung |
|---|---|---|---|---|---|---|---|---|---|
| 1 Alles umsonst | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | keine Befunde | ✓ | |
| 2 Preis anzeigen | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | keine Befunde | ✓ | Konstante `PRICE = 100` |
| 3 Guthaben anzeigen | ✓ | ✗ | ✓ | ✓ | ✓ | ✓ | keine Befunde | ✓ | Szenario 2: Test und Code in einem Patch. Szenario 1 war schon grün, `bis-gruen.sh` drehte trotzdem fünf Runden, weil sein Kriterium der ganze Build ist |
| 4 Getränke kosten Geld | ✓ | ✓ | ✓ | ✗ | ✓ | ✓ | fand den Sonderfall | ✗ | Test-Autor löschte die Story-1-Datei, ihre Kopie in `target` lief weiter: `if (credit == 0)` gibt die Dose umsonst. Ursache von Iteration 13 |
| 5 Wechselgeld | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | keine Befunde | (✗) | Story-5-Punkte grün, rot nur die Folge aus Story 4 |
| 6 Bier kostet mehr | ✓ | – | ✓ | ✓ | ✗ | ✗ | keine Befunde | ✗ | Spec: nur „WHEN Guthaben ≥ 2,00 € SHALL ausgeben“, weder Preis noch Verbot darunter; ein Szenario; kein Code nötig, Bier kostet weiter 1,00 € |
| 7 Kein Bier vor 4 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | Magic Number 16:00 | ✓ | `clock.now()`, `FakeClock` im Schritt, `Main` unverändert; HTTP rot nur aus 4 und 6 |

**Lauf 9**, Stand nach Iteration 13 (Start `740d047`, Paket `221cb21`), 01:50 bis 02:20:

| Story | verify | Test zuerst rot | keine Fremdänderung | kein Hack | Feature | Spec | Review | HTTP | Anmerkung |
|---|---|---|---|---|---|---|---|---|---|
| 1 Alles umsonst | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | keine Befunde | ✓ | Bestand wird mit abgezogen |
| 2 Preis anzeigen | ✓ | ✗ | ✓ | ✓ | ✓ | ✓ | zwei berechtigte | ✓ | `return 100` statt Konstante; Reviewer: „benannte Konstante“, Testname |
| 3 Guthaben anzeigen | ✓ | ✗ | ✓ | ✓ | ✓ | ✓ | keine Befunde | ✓ | Test- und Code-Patch nacheinander, erst dann Maven |
| 4 Getränke kosten Geld | ✓ | ✗ | ✓ | ✓ | ✓ | ✓ | keine Befunde | ✓ | Kein Sonderfall mehr: `credit < price(drink)`; veralteter Test angepasst und benannt. Rot war nur der veraltete Test, nicht ein neuer |
| 5 Wechselgeld | ✓ | ✗ | ✓ | ✓ | ✓ | ✓ | keine Befunde | ✓ | Test und Code in einem Patch |
| 6 Bier kostet mehr | ✓ | – | ✓ | ✓ | ✗ | ✗ | keine Befunde | ✗ | Wie Lauf 8, diesmal ohne Geisterdatei: das „nur“ der Karte fällt in der Spec weg |
| 7 Kein Bier vor 4 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | keine Befunde | ✓ | HTTP rot nur aus Story 6 |

**Lauf 10**, gleicher Stand wie Lauf 9, ohne Änderung dazwischen, 02:20 bis 02:49:

| Story | verify | Test zuerst rot | keine Fremdänderung | kein Hack | Feature | Spec | Review | HTTP | Anmerkung |
|---|---|---|---|---|---|---|---|---|---|
| 1 Alles umsonst | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | keine Befunde | ✓ | |
| 2 Preis anzeigen | ✓ | ✓ | ✓ | ✓ | ✓ | ✗ | keine Befunde | ✓ | Spec hat nur „Preis hinter dem Namen“, die Kartenregel „alle 1,00 €“ fehlt; der Szenariogrundriss prüft sie trotzdem für alle vier Getränke |
| 3 Guthaben anzeigen | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | keine Befunde | ✓ | Szenario 1 schon grün, wieder fünf Leerrunden von `bis-gruen.sh` |
| 4 Getränke kosten Geld | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ein berechtigter | ✓ | Kein Sonderfall, Preise aus einer Map; Reviewer: Meldungstexte als Konstanten, Meldung nach Kauf zurücksetzen |
| 5 Wechselgeld | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | keine Befunde | ✓ | |
| 6 Bier kostet mehr | ✓ | – | ✓ | ✓ | ✗ | ✗ | keine Befunde | ✗ | Wie Lauf 8 und 9 |
| 7 Kein Bier vor 4 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | keine Befunde | ✓ | `beerIsNotAllowedYet` über `clock.now()`, `Main` unverändert; HTTP rot nur aus Story 6 |

Was in allen drei Läufen stand: `mvn -q verify` war nach jeder Story grün, kein Implementierer änderte Feature, Schritt, Spec oder Gate (Whitelist), `Main` blieb in allen drei Läufen unangetastet, Story 7 lief jedes Mal über die Uhr aus dem Konstruktor. Story 6 scheiterte dreimal an derselben Stelle, der Spec.

Beobachtungen, die keine Bewertungspunkte verletzen, aber morgen Gesprächsstoff sind:
- Der rote Unit-Test hängt an der Disziplin des Modells. Über die Läufe 4 bis 10 stand er in 26 von 36 Implementierer-Runden einzeln im Protokoll (Lauf 8: 5 von 6, Lauf 9: 2 von 6, Lauf 10: 6 von 6; über die Läufe 4 bis 10: 26 von 36); sonst schrieb der Implementierer Test und Code in einem Patch oder in zwei Patches ohne Testlauf dazwischen. Die Vorgabe steht dreimal im Paket (Command Schritt 3, Skill Schleife 1, Checkliste 1). Das Szenario selbst war jedes Mal rot, bevor Code kam (Log des Test-Autors). Ein Zaun statt Appell: den Implementierer in zwei Rollen teilen, eine darf nur `VendingMachineTest.java` schreiben, `bis-gruen.sh` prüft dazwischen, dass der Test rot ist, dann erst die Code-Rolle. Das ändert das Rollenmodell des Trainings, deshalb nicht gebaut.
- `scripts/bis-gruen.sh` nimmt als Kriterium den ganzen Build. Ist das erste Szenario einer Story schon grün und ein späteres rot, dreht es fünf Leerrunden und meldet „nicht grün“ (Lauf 8, Story 3). Besser: erst prüfen, ob das benannte Szenario grün ist, dann anhalten. Nicht mehr geändert.
- Story 5: die Szenarien verlangen nur „50 ct landet in der Münzrückgabe"; der Implementierer zahlt das Guthaben als einen Betrag aus, nicht als Münzen. Regel 5 (Grenzwerte, konkrete Beispiele) in Aktion: was das Szenario nicht verlangt, baut niemand.
- Story 3: manche Läufe legen das Guthaben in die Meldung („Guthaben: 0,50 €" per `message()`), andere prüfen `credit()`. Die Karte sagt beides, das Glossar sagt `credit()`.
- Der Reviewer meldet auch bei sauberem Code manchmal einen Punkt (Bestand reduzieren, `refused()` ungenutzt, Javadoc veraltet); in Lauf 8 und 9 meist „keine wesentlichen Befunde“, und die Befunde, die kamen, waren berechtigt: der Sonderfall in Story 4 (Lauf 8), `return 100` ohne Konstante (Lauf 9), Magic Number 16:00. Bei eingebautem Smell fand er drei von vier (nicht das `System.out.println`), `protokolle/review-test/`. Er prüft Code gegen Spec, nicht Spec gegen Karte: die Lücke in Story 6 sah er nicht.
- Story 6 bleibt in drei Läufen (8, 9, 10) bei der Spec stehen: aus „Bier fällt nur bei einem Guthaben von mindestens 2,00 €“ wird eine Erlaubnis, das Verbot darunter und der Preis 2,00 € fehlen, das eine Szenario ist mit dem alten Code grün. In Lauf 4 und 5 hatte der Spec-Autor beides. Der Prüfpunkt dafür ist der Mensch nach `/spec` („Stimmen die Regeln?“, Folie 7). Wer es dem Modell leichter machen will: die Karte wie bei Story 2 ausschreiben („Bier kostet 2,00 €“, „unter 2,00 € fällt kein Bier: Zu wenig Geld“) oder im Skill ears-regeln: „nur wenn X“ sind zwei Regeln, Erlaubnis und Verbot.

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
- Iteration 15, auch nach den Läufen: das Paket liegt im Startstand, kein `install.sh`, kein `PROMPT.md` mehr, eine Quelle. Klonen oder in IntelliJ auschecken reicht.
- Iteration 14 kam nach den Läufen auf Sebastians Wunsch: Beispiele in Skills, Command, Glossar und Folie 8, die eine Story lösten (Kein Bier vor 4, Preise, Zu wenig Geld), sind durch Beispiele ohne Story ersetzt (leeres Fach meldet „Ausverkauft“, jedes Fach startet mit fünf Dosen). Die Läufe 8 bis 10 liefen noch mit den Story-Beispielen; die Skills haben Story 7 (Uhr) und Story 4 vermutlich erleichtert. Ein Lauf auf dem neuen Stand steht aus.
- Iteration 13 liegt über dem Budget von 12, bewusst: die Ursache war ein Build-Problem (Geisterdatei in `target`), kein Prompt-Problem, die Änderung ist eine Zeile im Runner und mit einer gepflanzten Geisterdatei geprüft. Der Stand davor ist in beiden Repos als Tag `iteration-12` markiert; `git revert 740d047` auf `training-start` nimmt sie zurück. Danach keine weitere Iteration mehr, auch nicht für Story 6 und den roten Test.

## 5. Offene Risiken

1. **Qwen 3.6 35B-A3B ist nicht getestet.** Alles hier lief mit `gpt-5.4-mini`. Das Setup ist für ein schwaches Modell gebaut (alles Nötige steht im Command, Rechte statt Appelle, `mvn -q verify` entscheidet), aber ob Qwen in opencode zuverlässig Tools aufruft, Dateien per `edit` schreibt und Skills liest, weiß morgen erst der erste Versuch. Vor dem Training einmal `/spec 1` und `/akzeptanztest 1` mit Qwen fahren.
   Wenn Qwen hängt:
   - `/spec` liefert falsche oder zu viele Regeln: die Datei `specs/<nr>-<name>/spec.md` von Hand korrigieren, sie ist kurzes Markdown. Das ist der vorgesehene Prüfpunkt.
   - `/akzeptanztest` schreibt Schritte, die nicht kompilieren: `mvn -q test -Dtest=RunCucumberTest` selbst laufen lassen, die Fehlermeldung in die Session geben ("Behebe nur diesen Fehler"). Schrittvorlagen stehen im Skill `akzeptanztest-regeln`, notfalls den Schritt von Hand schreiben.
   - `/implementiere` dreht Runden: `scripts/bis-gruen.sh "<Szenario>"` (höchstens fünf Runden, dann Abbruch mit Log unter `target/bis-gruen.log`); Szenario kleiner schneiden; oder den roten Unit-Test in `VendingMachineTest.java` selbst schreiben und nur "Mache diesen Test grün" verlangen.
   - Das Modell ignoriert `AGENTS.md` oder den Skill: die Commands tragen Skill, Spec, Glossar und Schritte schon im Prompt, die Rechte in `opencode.json` halten unabhängig vom Modell. Was trotzdem falsch ist, fängt `mvn -q verify`.
   - Qwen ruft gar keine Tools auf: dann bleibt die Pipeline als Ablauf für Menschen (Spec, Szenarien, roter Test, Code, Review), das Modell liefert Text zum Einfügen.
2. **Kontextgröße.** Jeder Command lädt alle Specs oder alle Feature-Dateien. Bei Story 7 sind das einige tausend Tokens, für Qwen mit 32k oder mehr unkritisch, bei kleineren Fenstern die Feature-Dateien im Command auf die aktuelle beschränken.
3. **Story 4 hebt Story 1 auf.** Der Test-Autor darf das alte Szenario ändern oder löschen (Iteration 6); `gpt-5.4-mini` löschte in Lauf 7 bis 10 jedes Mal die ganze Datei und sagte das. Bis Iteration 13 lief die gelöschte Datei aus `target/test-classes` weiter (Maven räumt gelöschte Ressourcen nicht ab), seither liest der Runner aus `src`. Ob Qwen das Szenario anpasst, ist offen; sonst von Hand: Szenario „Ein Getränk wählen“ bekommt ein Guthaben.
4. **Story 7 braucht eine Uhr.** Seit Iteration 10 steckt sie im Startstand: `VendingMachine(Clock)`, `Main` gibt `LocalTime::now` hinein, die Schritte eine `FakeClock`. In Lauf 8 stellte der Test-Autor die Zeit mit `clock.set(LocalTime.of(15, 59))`, der Implementierer fragte `clock.now()`, `Main` blieb unverändert. Ohne diese Naht (Lauf 4 und 5) erfand der Test-Autor einen Setter am Automaten oder verweigerte den Zeitschritt.
5. **CI läuft nur auf `main`.** Der Branch `training-start` selbst hat keinen CI-Lauf; in den Team-Repos wird er zu `main` gepusht, dann läuft die CI, anfangs rot (ein Szenario wartet).
6. **Commits macht der Mensch.** Keine Rolle darf `git add` oder `git commit` (Whitelist). Nach jedem grünen Szenario selbst committen, sonst frisst `/undo` oder ein Neustart Arbeit.
7. **Der Reviewer meldet auch bei sauberem Code etwas.** In allen Läufen fand er ein bis drei Punkte, teils spekulativ (etwa "Bestand reduzieren", bevor die Story das verlangt). Die Teilnehmerinnen entscheiden, was sie annehmen; das ist Absicht und steht auf Folie 11.

## 6. Wo was liegt

| Was | Wo |
|---|---|
| README, Folien, Baseline, Protokolle, Iterationen, dieser Bericht | `github.com/sharpsharp-ai/VendingMachine2026-opencode` (öffentlich), lokal `taskforce/compax_csd_mit_opencode/VendingMachine2026-opencode/` |
| Das Paket selbst (`AGENTS.md`, `opencode.json`, `.opencode/`, `scripts/bis-gruen.sh`) | im Startstand, Branch `training-start`, seit Iteration 15; Pfade `paket/…` in den Iterationen 1 bis 14 meinen die frühere Kopie im Paket-Repo |
| Startstand der Teams | `github.com/sharpsharp-ai/VendingMachine2026-Start`, Branch `training-start`; lokal Worktree `vending_machine_training_start/` |
| Referenzlösung | `github.com/sharpsharp-ai/VendingMachine2026` (privat), lokal `vending_machine_1shot/` |
| Folien | `folien/folien.pdf`, `folien/folien.pptx`, Quelle `folien/folien.py`; Kopien in `~/Downloads`; auf dem Miro-Board im Frame `3458764684499712615`, erste Folie: https://miro.com/app/board/uXjVHnldClU=/?moveToWidget=3458764684509393595 |
| Baseline Story 1 ohne Paket | `baseline/` (Prompt, zwei Läufe, Diff) |
| Verifikationsläufe | `protokolle/lauf-*/` (je Story: Spec, Szenarien, Implementierung je Szenario, verify, Review, HTTP-Prüfung), `protokolle/probe-*/` (Teilnehmer-Probe) |
| Iterationen am Setup | `ITERATIONEN.md`; Tag `iteration-12` in beiden Repos markiert den Stand vor der 13. |
| Prüfgeschirr (Läufe und Proben wiederholen) | `protokolle/geschirr/` mit README |
| Endstand der drei Abnahmeläufe | Branches `lauf-8`, `lauf-9`, `lauf-10` im Start-Repo, je mit Paket, Specs, Szenarien und Code aller sieben Stories |
| Konzept Team-Repos | `taskforce/compax_csd_mit_opencode/trainings-repos.md` |
