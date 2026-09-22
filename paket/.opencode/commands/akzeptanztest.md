---
description: Szenarien für Story <nr> schreiben, Gherkin auf Deutsch, Schritte gegen VendingMachine
agent: test-autor
---
Schreibe die Szenarien für Story Nummer $ARGUMENTS.

Skill akzeptanztest-regeln, hier eingefügt:
@.opencode/skills/akzeptanztest-regeln/SKILL.md

Alle Specs; nimm die mit der Nummer $ARGUMENTS:
!`for f in specs/*/spec.md; do echo "=== $f"; cat "$f"; done`

Glossar mit den vorhandenen Schritten:
@specs/glossar.md

Vorhandene Feature-Dateien:
!`ls src/test/resources/features`

Die Schritte:
@src/test/java/de/sharpsharp/vendingmachine/VendingMachineSteps.java

Der Automat, so wie er heute ist:
@src/main/java/de/sharpsharp/vendingmachine/VendingMachine.java

Vorgehen:
1. Jede Regel der Spec bekommt mindestens ein Szenario: Normalfall, Grenzwert, Fehlerfall, wo es sie gibt.
   Zahlen in den Beispielen kommen von der Karte oder aus der Spec. Steht eine Zahl nirgends, nimm sie nicht 0, sondern schreibe die Frage in die Antwort.
   WHILE wird Angenommen, WHEN wird Wenn, SHALL wird Dann. IF wird ein eigenes Fehlerfall-Szenario.
   Eine Regel ohne WHEN (Immer) bekommt ein Szenario ohne Wenn: Angenommen und Dann.
2. Datei `src/test/resources/features/<kurzname>.feature`, erste Zeile `# language: de`. Gibt es die Datei, ergänze fehlende Szenarien. Vorhandene Szenarien bleiben, wie sie sind, auch ihr Titel.
   Ausnahme: Hebt die neue Story eine alte Regel auf, dann gilt das alte Szenario nicht mehr. Ändere es so, dass es zur neuen Regel passt, oder lösche es, und schreibe das in die Antwort.
3. Schritte: erst die aus dem Glossar wiederverwenden. Fehlt ein Wort, schreibe den neuen Schritt in `VendingMachineSteps.java`. Fehlt dafür eine Methode am Automaten, benutze sie so, wie sie heißen soll; der Implementierer baut sie.
   Zeit und Zufall kommen von außen in den Konstruktor (`Clock`, Beispiel im Skill mit `FakeClock`), nie über einen Setter am Automaten.
   Angenommen-Schritte stellen den Zustand her, indem sie den Automaten bedienen. Sie prüfen nichts. Beispiel im Skill: ein leeres Fach.
   Wenn-Schritte rufen genau eine Methode auf. Dann-Schritte prüfen genau eine Sache mit `assertThat`.
   Welche Methode zu welchem Wort gehört, steht im Glossar, Spalte „Am Automaten": Guthaben ist `credit()`, Meldung ist `message()`, Preis ist `price(drink)`.
4. Führe `scripts/steps-glossar.sh` aus.
5. Führe `mvn -q test -Dtest=RunCucumberTest` aus. Neue Szenarien dürfen rot sein oder nicht kompilieren. Alte Szenarien bleiben grün. Ändere keinen Produktivcode.
6. Antworte mit: Datei, Liste der Szenarien, und je Regel des Skills "ja" oder "nein" mit einem Wort Begründung.
