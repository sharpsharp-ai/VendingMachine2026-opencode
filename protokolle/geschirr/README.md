# Prüfgeschirr

Die Skripte, mit denen die Läufe und Proben unter `protokolle/` entstanden sind. Kein Teil des Pakets.

| Skript | Was es tut |
|---|---|
| `lauf.sh N 7` | Frischer Worktree aus `training-start` (das Paket liegt seit Iteration 15 darin), dann je Story `/spec`, `/akzeptanztest`, Commit, je Szenario `scripts/bis-gruen.sh`, `mvn -q verify`, `/review`, `checks.sh`; Protokolle nach `protokolle/lauf-N/` |
| `checks.sh N STORY` | Startet `Main`, spricht die Oberfläche per HTTP an und prüft je Story das Verhalten (kumulativ) |
| `probe.sh NAME` | Teilnehmer-Probe des alten Setups (Weg A mit `install.sh`, Weg B mit `PROMPT.md`); seit Iteration 15 gibt es beides nicht mehr, das Skript bleibt als Protokoll-Erzeuger von `probe-1` und `probe-2` |
| `tabelle.sh N` | Zieht aus `lauf-N.log` und den Implementierer-Protokollen eine Tabelle je Story |

Die Pfade in Zeile 4 bis 10 zeigen auf Sebastians Rechner (`vending_machine_start`, dieses Repo) und den Scratch-Ordner der Session; vor dem Wiederverwenden anpassen.
Starten immer losgelöst, sonst beendet ein Hintergrund-Manager den Lauf: `nohup bash lauf.sh 11 7 > lauf-11.log 2>&1 < /dev/null & disown`.
Modell über `OPENCODE_MODEL`, hier `openai/gpt-5.4-mini`; `JAVA_HOME` auf ein JDK 17.
