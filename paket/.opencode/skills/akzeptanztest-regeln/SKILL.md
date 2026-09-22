---
name: akzeptanztest-regeln
description: Die elf Regeln für gute Akzeptanztests in Gherkin, mit Beispiel und Checkliste; gilt für jede Feature-Datei
---
# Elf Regeln für Akzeptanztests

1. Ein Szenario, ein Verhalten: genau ein Wenn. Hat die Regel keinen Auslöser (EARS „Immer“), entfällt das Wenn: nur Angenommen und Dann.
2. Deklarativ: was, nicht wie. Keine Knöpfe, Klicks, IDs, Indizes, HTTP.
3. Fachsprache des Kunden: Namen statt nullbasierter Nummern. "Cola", nicht "Fach 0".
4. Angenommen ist Zustand, Wenn ist Ereignis, Dann ist von außen beobachtbar: Dose im Ausgabefach, Guthaben, Meldung, Münzrückgabe, Preis und Bestand am Fach. Nie interner Zustand.
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
Funktionalität: Ausverkauft
  Ein leeres Fach gibt nichts her und sagt das.

  Szenario: Aus einem leeren Fach fällt nichts
    Angenommen das Fach Cola ist leer
    Wenn ich Cola wähle
    Dann ist das Ausgabefach leer
    Und der Automat meldet "Ausverkauft"

  Szenario: Aus einem vollen Fach fällt die Dose
    Angenommen der Automat ist frisch gestartet
    Wenn ich Cola wähle
    Dann liegt eine Dose Cola im Ausgabefach
```

Eine Regel ohne Auslöser, als Szenariogrundriss mit Beispielen:

```gherkin
  Szenariogrundriss: Jedes Fach startet voll
    Angenommen der Automat ist frisch gestartet
    Dann liegen im Fach <Getränk> 5 Dosen

    Beispiele:
      | Getränk |
      | Cola    |
      | Bier    |
```

Schritte dazu, in `VendingMachineSteps.java`. Angenommen bedient den Automaten und stellt so den Zustand her,
Wenn ruft eine Methode, Dann prüft eine Sache. `{drink}` und `{betrag}` ("1,00 €", "2 €", "50 ct" als Cent) stehen in `ParameterTypes.java`:

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

@Dann("liegen im Fach {drink} {int} Dosen")
public void theSlotHolds(Drink drink, int cans) {
    assertThat(machine.stock(drink), is(cans));
}
```

Zeit kommt von außen. Der Automat hat im Konstruktor eine Uhr (`Clock`, eine Methode `LocalTime now()`); die Schritte-Klasse
baut ihn mit einer `FakeClock` (Feld `clock`) und stellt sie. Nie ein Setter für die Zeit am Automaten: den hätte die echte Anwendung nicht.

```java
@Angenommen("es ist {int}:{int} Uhr")
public void itIs(int hour, int minute) {
    clock.set(LocalTime.of(hour, minute));
}
```

## Checkliste vor dem Abgeben, je Szenario ja oder nein
- Genau ein Wenn, oder keins, weil die Regel keinen Auslöser hat? (1)
- Kein Wort der Oberfläche? (2, 11)
- Namen statt Nummern? (3)
- Angenommen stellt Zustand her und prüft nichts? Dann prüft etwas Sichtbares: Dose, Guthaben, Meldung, Münzrückgabe, Preis, Bestand? (4)
- Zahlen und Grenzwerte konkret? (5)
- Titel nennt die Regel? (6)
- Läuft allein und wiederholt gleich? (7)
- Schritte aus dem Glossar benutzt? (8)
- Jede Regel der Spec hat ein Szenario? (9)
- Höchstens sechs Schritte? (10)
