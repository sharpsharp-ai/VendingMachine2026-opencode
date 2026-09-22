---
name: ears-regeln
description: Regeln einer Story in EARS formulieren (WHEN, WHILE, IF, SHALL), die Vorstufe der Gherkin-Szenarien
---
# EARS-Regeln

Eine Regel je Akzeptanzkriterium. Die Schlüsselwörter bleiben englisch und groß.

| Form | Muster | Beispiel |
|---|---|---|
| Immer | Der Automat SHALL <Verhalten>. | Der Automat SHALL jedes Fach mit fünf Dosen füllen. |
| Ereignis | WHEN <Ereignis>, SHALL der Automat <Verhalten>. | WHEN der Kunde Dosen aus dem Ausgabefach nimmt, SHALL der Automat das Ausgabefach leeren. |
| Zustand | WHILE <Zustand>, WHEN <Ereignis>, SHALL der Automat <Verhalten>. | WHILE das Fach leer ist, WHEN der Kunde es wählt, SHALL der Automat keine Dose ausgeben und "Ausverkauft" melden. |
| Unerwünscht | IF <Bedingung>, THEN SHALL der Automat <Verhalten>. | IF eine Münze nicht angenommen wird, THEN SHALL der Automat sie in die Münzrückgabe legen. |

Von EARS nach Gherkin: WHILE wird Angenommen, WHEN wird Wenn, SHALL wird Dann, IF wird ein eigenes Fehlerfall-Szenario, Immer wird ein Szenario ohne Wenn.
EARS nennt die Regel, Gherkin das konkrete Beispiel mit Zahlen.

## Checkliste, je Regel ja oder nein
1. Genau ein SHALL je Regel.
2. Das Verhalten ist von außen sichtbar: Dose, Guthaben, Meldung, Münzrückgabe, Preis und Bestand am Fach. Kein interner Zustand.
3. Die Bedingung ist allgemein und nennt die Schwelle: „solange das Fach leer ist“. Beispielwerte wie 0,99 € gehören ins Szenario, nicht in die Regel.
4. Keine Wörter der Oberfläche: kein Knopf, Klick, Button, HTTP, JSON.
5. Fachbegriffe aus dem Glossar.
6. Jedes Akzeptanzkriterium der Karte hat eine Regel, keine Regel ohne Kriterium.
7. Hebt die Story eine frühere Regel auf, steht das da: „Hebt auf: <Regel> aus specs/<nr>-<name>".
8. Jede Zahl in einer Regel steht auf der Karte. Fehlt eine (ein Betrag, eine Anzahl), steht die Frage unter „Offene Fragen"; niemand erfindet Werte.
