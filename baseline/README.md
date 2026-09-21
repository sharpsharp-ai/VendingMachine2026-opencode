# Baseline: Story 1 mit Vanilla-opencode

Ausgangslage: Branch `training-start`, kein Paket, keine AGENTS.md. Modell `openai/gpt-5.4-mini`,
nicht-interaktiv (`opencode run`). Prompt in `prompt.txt`. Zwei Versuche, gleicher Prompt.

| Versuch | Dauer | Ergebnis |
|---|---|---|
| 1 (`versuch-1.log`, `versuch-1.diff`) | 57 s | `mvn -q verify` grün. Eine Datei geändert: `VendingMachine.java`, 16 Zeilen. Kein Unit-Test, kein roter Test vorab, keine Spec. Nebenbei `takeCoins` und `coinReturn` gebaut, die keine Story verlangt. |
| 2 (`versuch-2.log`) | 10 s | Nichts geändert. Das Modell erfand einen Dateipfad außerhalb des Projekts, die Rechteabfrage wurde abgelehnt, das Modell hörte auf. |

Was fehlt gegenüber der Pipeline: Regeln vor dem Code, Szenario für den Grenzfall (leeres Fach),
Unit-Test, Review. Was es zeigt: Ohne Führung entscheidet das Modell selbst, was "fertig" heißt, und
ob es überhaupt weitermacht.
