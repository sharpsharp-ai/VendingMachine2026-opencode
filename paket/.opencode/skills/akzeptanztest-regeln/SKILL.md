---
name: akzeptanztest-regeln
description: Die elf Regeln für gute Akzeptanztests in Gherkin, mit Beispiel und Checkliste; gilt für jede Feature-Datei
---
# Elf Regeln für Akzeptanztests

1. Ein Szenario, ein Verhalten: genau ein Wenn.
2. Deklarativ: was, nicht wie. Keine Knöpfe, Klicks, IDs, Indizes, HTTP.
3. Fachsprache des Kunden: Namen statt nullbasierter Nummern. "Cola", nicht "Fach 0".
4. Angenommen ist Zustand, Wenn ist Ereignis, Dann ist von außen beobachtbar. Nie interner Zustand.
5. Konkrete Beispiele mit Grenzwerten. Nur Details, die für die Regel zählen.
6. Der Titel nennt die Regel, nicht den Ablauf.
7. Unabhängig und wiederholbar: keine Reihenfolge zwischen Szenarien, Zeit und Zufall sind gestellt.
8. Vorhandene Schritte wiederverwenden und parametrisieren. Neue Schritte nur bei fehlendem Vokabular.
9. Jedes Akzeptanzkriterium hat mindestens ein Szenario: Normalfall, Randfall, Fehlerfall. Varianten per Szenariogrundriss.
10. Höchstens etwa sechs Schritte. Grundlage sparsam.
11. Schritte sprechen mit `VendingMachine`, nicht mit der Oberfläche.

## Beispiel

```gherkin
# language: de
Funktionalität: Kein Bier vor 4
  Bier gibt es erst ab 16:00 Uhr.

  Szenario: Vor 16 Uhr fällt kein Bier
    Angenommen es ist 15:59 Uhr
    Und ich habe 2 € eingeworfen
    Wenn ich Bier wähle
    Dann ist das Ausgabefach leer
    Und der Automat meldet "Kein Bier vor 4"
    Und das Guthaben ist 2,00 €

  Szenario: Ab 16 Uhr fällt Bier
    Angenommen es ist 16:00 Uhr
    Und ich habe 2 € eingeworfen
    Wenn ich Bier wähle
    Dann liegt eine Dose Bier im Ausgabefach
```

Schritte dazu, in `VendingMachineSteps.java`. Angenommen bedient den Automaten und stellt so den Zustand her,
Wenn ruft eine Methode, Dann prüft eine Sache:

```java
@Angenommen("das Fach {drink} ist leer")
public void theSlotIsEmpty(Drink drink) {
    while (machine.stock(drink) > 0) {
        int before = machine.stock(drink);
        machine.insertCoin(200);
        machine.selectDrink(drink);
        machine.takeDrinks();
        assertThat("Fach lässt sich nicht leeren: " + machine.message(), machine.stock(drink), is(before - 1));
    }
}

@Wenn("ich {drink} wähle")
public void iSelect(Drink drink) {
    machine.selectDrink(drink);
}

@Dann("der Automat meldet {string}")
public void theMachineSays(String text) {
    assertThat(machine.message(), is(text));
}
```

## Checkliste vor dem Abgeben, je Szenario ja oder nein
- Genau ein Wenn? (1)
- Kein Wort der Oberfläche? (2, 11)
- Namen statt Nummern? (3)
- Angenommen stellt Zustand her und prüft nichts? Dann prüft etwas Sichtbares: Dose, Guthaben, Meldung, Münzrückgabe? (4)
- Zahlen und Grenzwerte konkret? (5)
- Titel nennt die Regel? (6)
- Läuft allein und wiederholt gleich? (7)
- Schritte aus dem Glossar benutzt? (8)
- Jede Regel der Spec hat ein Szenario? (9)
- Höchstens sechs Schritte? (10)
