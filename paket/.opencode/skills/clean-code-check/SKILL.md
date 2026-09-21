---
name: clean-code-check
description: Checkliste für Review und Aufräumen: die häufigsten Smells mit Namen und dem passenden Refactoring
---
# Clean-Code-Check

Je Punkt ja oder nein. Bei nein: Smell nennen, Refactoring vorschlagen.

| Nr | Frage | Smell bei nein | Refactoring |
|---|---|---|---|
| 1 | Jede Methode höchstens 20 Zeilen? | Long Method | Extract Method |
| 2 | Jede Methode eine Sache auf einer Abstraktionsebene? | Mixed Levels | Extract Method |
| 3 | Jeder Name sagt, was das Ding ist oder tut, mit Wörtern aus dem Glossar? | Bad Name | Rename |
| 4 | Kein Code doppelt? | Duplicated Code | Extract Method |
| 5 | Keine nackten Zahlen und Texte im Code, außer 0 und 1? | Magic Number | Extract Constant |
| 6 | Keine Kommentare, die erklären, was der Code tut? | Comment | Rename, Extract Method |
| 7 | Keine Kette von if/else über denselben Wert? | Switch Statement | Map, Polymorphismus |
| 8 | Keine Fachlogik in `Main`? | Misplaced Responsibility | Move Method |
| 9 | Keine Testwerte im Produktivcode? | Hardcoded Test Data | die Regel bauen |
| 10 | Jeder Test prüft eine Regel und hat einen sprechenden Namen? | Eager Test | Split Test, Rename |
| 11 | Kein toter Code, keine ungenutzten Felder? | Dead Code | Remove |
| 12 | Zeit und Zufall hinter einem Interface? | Hidden Dependency | Extract Interface |

Antwort je Befund: `Datei:Zeile`, Smell, Vorschlag in einem Satz.
Nichts gefunden: "Keine wesentlichen Befunde."
