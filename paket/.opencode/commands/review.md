---
description: Review der Änderungen, Befunde mit Datei:Zeile, Smell und Vorschlag
agent: reviewer
---
Prüfe die Änderungen im Projekt.

Skill clean-code-check, hier eingefügt:
@.opencode/skills/clean-code-check/SKILL.md

Geänderte Dateien seit dem letzten Commit:
!`git diff HEAD --stat -- src`

Der Diff:
!`git diff HEAD -- src`

Ist der Diff leer, prüfe stattdessen den letzten Commit mit `git show HEAD`.

Regeln:
- Lies die geänderten Dateien ganz, nicht nur den Diff.
- Prüfe jeden Punkt des Skills. Je Befund eine Zeile: `Datei:Zeile`, Name des Smells, Refactoring-Vorschlag in einem Satz.
- Prüfe zusätzlich: Testwerte im Produktivcode, Fachlogik in `Main`, Tests, die nichts prüfen, Szenarien gegen die elf Regeln in `.opencode/skills/akzeptanztest-regeln/SKILL.md`.
- Ändere nichts.
- Gibt es nichts Wesentliches, antworte genau: "Keine wesentlichen Befunde."
