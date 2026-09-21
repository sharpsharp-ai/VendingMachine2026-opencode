# Getränkeautomat

## Befehle
- `mvn -q verify`: das einzige Fertig-Kriterium. Keine Ausgabe und Exit-Code 0 heißt grün, alles andere heißt rot.
- `mvn -q test -Dtest=RunCucumberTest`: nur die Szenarien, schneller.
- `mvn -q test -Dtest=VendingMachineTest`: nur die Unit-Tests des Automaten.
- `scripts/steps-glossar.sh`: nach jedem neuen Schritt ausführen, erzeugt `specs/glossar.md`.
- Verboten: Tests löschen oder mit `@Ignore` abschalten, `-DskipTests`, Änderungen an `pom.xml`, `config/`, `.opencode/`, `AGENTS.md`.

## Struktur
- `src/main/java/de/sharpsharp/vendingmachine/VendingMachine.java`: alle Fachregeln.
- `Main.java`: nur Web und JSON, keine Fachlogik. `Drink.java`: die Fächer. `Clock.java`: die Uhr, kommt in den Konstruktor.
- `src/test/resources/features/*.feature`: die Szenarien, auf Deutsch. Sie sind die Spezifikation.
- `src/test/java/de/sharpsharp/vendingmachine/VendingMachineSteps.java`: die Schritte. Sie sprechen nur mit `VendingMachine`.
- `src/test/java/de/sharpsharp/vendingmachine/VendingMachineTest.java`: Unit-Tests. JUnit 4, Hamcrest, Mockito.
- `specs/stories.md`: die Stories. `specs/<nr>-<name>/spec.md`: die Regeln je Story. `specs/glossar.md`: Fachbegriffe und vorhandene Schritte.

## Arbeitsweise
- Ein Szenario nach dem anderen.
- Erst der rote Test, dann der Code, dann `mvn -q verify`.
- Beim Code schreiben bleiben Feature-Dateien, Schritte und Specs unverändert. Ein Test wird nie passend gemacht.
- Keine Testwerte hartkodieren. Der Automat rechnet, er rät nicht.
- Fertig ist erst, wenn `mvn -q verify` grün ist. Vorher nicht "fertig" sagen.
- Am Ende drei Zeilen: geändert, Ergebnis von `mvn -q verify`, offen.

## Code-Regeln
- Java 17. Methoden höchstens 20 Zeilen, Dateien höchstens 200 Zeilen, eine Abstraktionsebene je Methode.
- Namen aus `specs/glossar.md`, im Code englisch: credit, slot, can, outputTray, coinReturn, cashBox.
- Beträge in Cent als `int`. Meldungen als Text, wörtlich wie in der Story.
- Zeit nie direkt aus dem System holen: der Automat fragt seine `Clock`, die Tests stellen eine `FakeClock`. Zufall und Mechanik genauso über ein Interface.
- Fachlogik nur in `VendingMachine` und Klassen daneben. Nie in `Main`, nie in Tests.
