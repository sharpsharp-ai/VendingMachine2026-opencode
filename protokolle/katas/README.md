# Proben der Kata-Repos, 2026-09-22

Modell `openai/gpt-5.4-mini`, `opencode run` nicht-interaktiv, je in einer frischen Kopie des Startstands.

## gildedrose: `/charakterisiere` (heute `/characterization-test`)
- Ein Lauf, Exit 0. Ergebnis: vier Testklassen, 14 Tests, `mvn -q verify` grün, `scripts/unabgedeckt.sh GildedRose`: 36 von 36 Zweigen erreicht.
- Produktivcode unverändert (`git status`: nur `src/test`).
- Abweichung von der Vorgabe: `GildedRoseTest` wurde nach `OrdinaryItemTest` verschoben und gelöscht; der Command sagt seitdem ausdrücklich „umziehen erlaubt, löschen nicht". Grenzwerte aus Regel 5 nur teilweise (Sulfuras nur bei `sellIn` -1).
- `probe.log`: Ausgabe des Laufs. `tests/`: die erzeugten Tests.

## gildedrose: `/approval-test`
- Ein Lauf, Exit 0. Golden Master nach dem Muster im Skill: fünf Namen × zehn `sellIn` × sieben `quality` = 350 Zeilen. Erster Lauf rot, Stichproben gegen den Code benannt (Sulfuras 80, Backstage nach dem Konzert 0, Deckel 50), dann `scripts/approve.sh`, `mvn -q verify` grün, 36 von 36 Zweigen erreicht. Produktivcode unverändert.
- `gildedrose-approval/`: Ausgabe, Testklasse, genehmigte Datei.

## tripservice: `/coach`, drei Runden
- Runde 1 (`--command coach`): Lage in fünf Sätzen, Technik benannt, eine Frage, keine Änderung. Ausgesagt, der kürzeste Weg brauche noch keine Naht; das stellte sich in Runde 2 als falsch heraus, der Coach hat es dort selbst korrigiert.
- Runde 2 (`-c "Ich würde testen, dass … Ja, mach den Schritt."`): ein Test `throwsWhenUserIsNotLoggedIn`, rot wegen `CollaboratorCallException`, nächster Schritt vorgeschlagen, Frage. Lief als Rolle `build`, weil `opencode run -c` ohne `--agent` die Rolle nicht hält; im TUI und in IntelliJ bleibt die Rolle, wenn opencode mit `--agent clean-code-coach` gestartet oder der Session-Modus gewählt ist. Steht so in der README.
- Runde 3 (`--agent refactoring-coach -c "Ja, bau die Naht."`): Extract and Override Call in `TripService` (`protected User getLoggedUser()`), Testsubklasse `TestableTripService`, `mvn -q verify` grün, nächster Schritt vorgeschlagen, Frage. `TripService_Original.java` unverändert.
- `runde-*.log`: Ausgaben. `diff-nach-runde-3.patch`: der Stand nach drei Runden.

## Frische Clones von GitHub
`git clone` und `mvn -q verify` je Repo: Exit 0 (stringcalculator 1 Test, gildedrose 1 Test, tripservice 0 Tests).
