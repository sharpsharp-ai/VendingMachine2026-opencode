---
name: tdd-zyklus
description: Rot, Grün, Aufräumen: ein Szenario mit Unit-Tests in kleinen Schritten grün machen, Fertig-Kriterium mvn -q verify
---
# TDD-Zyklus

## Schleife
1. Rot: ein Unit-Test in `VendingMachineTest.java` für die kleinste Regel, die noch fehlt.
   `mvn -q test -Dtest=VendingMachineTest` zeigt ihn rot. Ist er sofort grün, war es kein Test.
2. Grün: so wenig Code wie möglich, damit der Test grün wird. Kein Vorgriff auf spätere Stories.
3. Aufräumen: Namen, Duplikate, Methodenlänge. Tests bleiben grün.
4. Szenario prüfen: `mvn -q test -Dtest=RunCucumberTest`. Noch rot: zurück zu 1.
5. Fertig: `mvn -q verify` ohne Ausgabe.

## Regeln
- Ein Test prüft eine Regel. Sein Name nennt die Regel: `leeresFachGibtKeineDose`.
- Kompiliert das Projekt nicht, verlangen die Schritte eine Methode oder ein Interface, das fehlt. Erst das bauen, dann Rot.
- Keine Testwerte im Produktivcode. Wer `if (drink == COLA) return 3` schreibt, statt den Bestand zu führen, rät.
- Zeit, Zufall, Mechanik: Interface im Produktivcode, Mock oder Fake im Test. Mockito ist da.
- Meldungen wörtlich aus der Story.
- Tests, die grün waren, bleiben grün. Bricht einer, ist der Code falsch, nicht der Test.
  Einzige Ausnahme, der veraltete Test: die Story hebt eine alte Regel auf (der Test-Autor hat das alte Szenario gelöscht oder geändert), oder ein Test schreibt das Fehlen von etwas fest, das die Story einführt.
  Dann gilt der alte Unit-Test nicht mehr: ändere oder lösche ihn und nenne das in der Antwort. Nie einen Sonderfall im Code bauen, nur damit er grün bleibt, und nie einen Wert in `Main` festnageln.

## Checkliste vor "fertig", je Punkt ja oder nein
1. Der Test war rot, bevor der Code kam.
2. `mvn -q verify` endet ohne Ausgabe.
3. Keine Feature-Datei, kein Schritt, keine Spec geändert.
4. Kein Wert aus einem Test im Produktivcode hartkodiert.
5. Alle Methoden höchstens 20 Zeilen, eine Abstraktionsebene.
