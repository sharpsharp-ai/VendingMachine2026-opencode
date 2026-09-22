# opencode für den Getränkeautomaten

Das Paket gibt opencode im Trainingsprojekt feste Rollen und feste Schritte: Spec, Szenarien, Implementierung, Review.
Jeder Schritt ist ein Command, jede Rolle hat nur die Rechte, die sie braucht, und `mvn -q verify` entscheidet, was fertig ist.

Es liegt direkt im Startstand (`VendingMachine2026-Start`, Branch `training-start`, und damit in jedem Team-Repo):
`AGENTS.md`, `opencode.json`, `.opencode/` mit vier Commands und vier Skills, `scripts/bis-gruen.sh`. Nichts installieren.

## Loslegen

```bash
git clone <URL eures Team-Repos> getraenkeautomat     # oder in IntelliJ auschecken
cd getraenkeautomat
mvn -q verify        # rot: das Szenario "Ein Getränk wählen" wartet auf euch. Richtig so.
opencode             # kennt /spec, /akzeptanztest, /implementiere, /review
```

Voraussetzungen: JDK 17, Maven, git, opencode mit einem konfigurierten Modell (`/models`).

## Die erste Story mit der Pipeline

```text
/spec 1                              Spec nach specs/1-alles-umsonst/spec.md
/akzeptanztest 1                     Szenarien nach features/, Schritte nach VendingMachineSteps.java
/implementiere Ein Getränk wählen    genau ein Szenario grün, Test zuerst
/review                              Befunde mit Datei:Zeile, Smell, Vorschlag
```

Vor jedem Command eine neue Session (`/new`): der Command bringt alles mit, was die Rolle wissen muss.
Nach jedem grünen Szenario selbst committen. Vom Terminal aus: `scripts/bis-gruen.sh "Ein Getränk wählen"`.

Welche Datei was tut und welche Rolle was darf, steht in der README des Projekts, Abschnitt „Mit opencode arbeiten“.
Was ein Command genau tut, steht in ihm selbst: `.opencode/commands/*.md` ist lesbares Markdown, das ist der Prompt.

## In diesem Repo

| Was | Wo |
|---|---|
| Bericht zur Verifikation, Abnahmekriterien, Hypothesen, Risiken | `BERICHT.md` |
| Jede Änderung am Setup mit Grund | `ITERATIONEN.md` |
| Folien (PDF, PPTX, Quelle) | `folien/` |
| Story 1 ohne Paket, zum Vergleich | `baseline/` |
| Protokolle aller Läufe, Proben und Tests, Prüfskripte | `protokolle/` |
