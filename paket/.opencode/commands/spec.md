---
description: Spec für Story <nr> schreiben, EARS-Regeln nach specs/<nr>-<name>/spec.md
agent: spec-autor
---
Schreibe die Spec für Story Nummer $ARGUMENTS.

Skill ears-regeln, hier eingefügt:
@.opencode/skills/ears-regeln/SKILL.md

Alle Stories:
@specs/stories.md

Glossar:
@specs/glossar.md

Vorhandene Specs:
!`ls specs`

Vorgehen:
1. Suche in den Stories die Überschrift mit der Nummer $ARGUMENTS. Nur diese Story.
2. Lege die Datei `specs/$ARGUMENTS-<kurzname>/spec.md` an. Kurzname: klein, ohne Umlaute, Wörter mit Bindestrich. Gibt es die Datei schon, überarbeite sie.
3. Inhalt, höchstens eine halbe Seite, genau diese drei Abschnitte:
   `## Story`: wörtlich von der Karte.
   `## Regeln`: eine EARS-Regel je Akzeptanzkriterium, nach dem Skill: allgemein, mit der Schwelle, ohne Beispielwerte.
   `## Offene Fragen`: Fragen an den Kunden, oder "keine".
4. Ändere nichts außerhalb von `specs/`.
5. Antworte mit dem Pfad der Datei und den Regeln.
