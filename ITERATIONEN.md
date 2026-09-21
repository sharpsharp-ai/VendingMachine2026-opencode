# Iterationen

Eine Zeile je Änderung am Setup, mit Grund. Produktcode und Tests werden nie von Hand repariert.

| Nr | Datum | Änderung | Grund |
|---|---|---|---|
| 1 | 2026-09-21 | `/akzeptanztest` und Skill: Angenommen stellt Zustand her und prüft nichts, Beispiel „leeres Fach"; vorhandene Szenarien bleiben samt Titel | Lauf 1, Story 1: Schritt „das Fach Cola ist leer" war eine Assertion, Szenario nie grün; Szenario „Ein Getränk wählen" wurde umbenannt |
| 2 | 2026-09-21 | `training-start` repariert: Drink ohne Preis, `VendingMachine.price(Drink)` liefert null, Seite und WebTest kommen ohne Preis aus; Angenommen-Schritt „frisch gestartet" prüft nichts mehr; Parametertyp `{betrag}` („1,00 €", „2 €", „50 ct") | Lauf 2, Story 2: der Commit 3747407 nannte die Preisentfernung, enthielt sie aber nicht; Story 2 war damit im Code schon gelöst, und der Start-Schritt widersprach der Regel „Angenommen prüft nichts" |
| 3 | 2026-09-21 | Skill akzeptanztest-regeln, `/akzeptanztest`, Skill ears-regeln: Regel ohne Auslöser (EARS „Immer") wird Szenario ohne Wenn; beobachtbar sind auch Preis und Bestand am Fach; Beispiel Szenariogrundriss „Der Preis steht am Fach"; Wenn- und Dann-Methoden des Automaten namentlich | Lauf 2, Story 2: Szenario „Wenn ich Cola sehe / Dann der Automat meldet "Cola 1,00 €"" erfand ein Ereignis, der Schritt rief `stock()`, der Implementierer zählte daraufhin `stock()`-Aufrufe in `message()` |
| 4 | 2026-09-21 | Glossar (aus `scripts/steps-glossar.sh`): Spalte „Am Automaten" mit der Methode je Fachbegriff, Guthaben als eigene Display-Zeile; `/akzeptanztest` verweist darauf | Lauf 2, Story 3: Spec und Szenarien packten das Guthaben in die Meldung („Guthaben: 0,50 €" per `message()`), obwohl der Automat `credit()` hat |
| 5 | 2026-09-21 | `WebTest` prüft nach Aktionen nur noch, dass ein Zustand mit Guthaben, Meldung und Fächern kommt, nicht den Meldungstext | Lauf 2, Story 3: der Implementierer setzte in `Main` nach jeder Aktion „Bitte Münzen einwerfen" hart, weil der WebTest diesen Text verlangte |
| 6 | 2026-09-21 | `/akzeptanztest`: hebt eine Story eine alte Regel auf, wird das alte Szenario angepasst oder gelöscht und das in der Antwort genannt; Skill ears-regeln Punkt 7 „Hebt auf: …" | Lauf 2, Story 4: „Zu wenig Geld" und „Ein Getränk wählen" (frisch gestartet, Cola fällt) widersprachen sich, der Implementierer drehte drei Runden |
| 7 | 2026-09-21 | Skill ears-regeln Punkt 3 und `/spec`: Regel allgemein mit Schwelle („unter dem Preis"), Beispielwerte nur ins Szenario | Lauf 2, Story 4: Regeln wie „IF das Guthaben 0,99 € beträgt und der Preis 1,00 € ist" waren Beispiele, keine Regeln |
| 8 | 2026-09-21 | Karte Story 2 in `specs/stories.md`: „Alle Getränke kosten 1,00 €"; Skill ears-regeln Punkt 8 und `/akzeptanztest`: fehlende Zahlen werden offene Fragen, nie erfundene Werte | Lauf 3, Story 2: die Karte nannte nur „z. B. Cola 1,00 €", der Test-Autor setzte alle Preise auf 0,00 €, die Spec meldete keine offene Frage |

Änderungen am Prüfgeschirr (kein Teil des Pakets, `scratchpad/lauf.sh` und `checks.sh`), der Vollständigkeit halber:

| Datum | Änderung | Grund |
|---|---|---|
| 2026-09-22 | HTTP-Prüfung: „Zu wenig Geld" und „Kein Bier vor 4" werden an Meldung und leerem Ausgabefach geprüft, nicht mehr an `refused` | Lauf 4, Story 4: die Prüfung verlangte `refused = true`, keine Karte verlangt das (die Meldung stand da, das Fach war leer); Nachprüfung auf dem Story-4-Commit: OK (`protokolle/lauf-4/s4-6-http-nachgeprueft.log`) |
| 2026-09-22 | `lauf.sh` kann nach einem Abbruch bei einer Story mit schon committeter Spec und Szenarien wieder aufsetzen (`RESUME=1`) | Lauf 4 wurde bei Story 4 vom System wegen Speichermangel beendet (Mac mit 16 GB, IntelliJ, Miro, Chrome offen) |
| 9 | 2026-09-22 | Skill akzeptanztest-regeln und `/akzeptanztest`: Zeit kommt über `Clock` in den Konstruktor, der Test stellt eine `FakeClock`; nie ein Setter am Automaten | Lauf 4, Story 7: der Schritt „es ist 15:59 Uhr" rief `machine.setTime(15, 59)`, der Implementierer prüfte die Regel nur, wenn die Zeit gesetzt war; die laufende Anwendung verkaufte Bier immer |
| 10 | 2026-09-22 | Startstand: Interface `Clock` (`LocalTime now()`), `VendingMachine(Clock)`, `Main` gibt `LocalTime::now`, `FakeClock` in `src/test/java`, Schritte-Klasse hält `clock`; Glossar, AGENTS.md, Skill entsprechend | Lauf 5, Story 7: der Test-Autor schrieb den Zeitschritt nicht, weil `Clock` noch fehlte und er „bewusst rot" blieb; ohne Naht im Start kommt ein schwaches Modell nicht über den nicht kompilierenden Schritt |
