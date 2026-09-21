---
description: Ein Szenario grün machen, Test zuerst, kleine Schritte
agent: implementierer
---
Mache genau dieses Szenario grün: "$ARGUMENTS". Kein anderes.

Skill tdd-zyklus, hier eingefügt:
@.opencode/skills/tdd-zyklus/SKILL.md

Skill clean-code-check, hier eingefügt:
@.opencode/skills/clean-code-check/SKILL.md

Die Szenarien:
!`for f in src/test/resources/features/*.feature; do echo "=== $f"; cat "$f"; done`

Was der Test-Autor zuletzt an den Szenarien geändert hat (gelöschte oder geänderte Szenarien heißen: die alte Regel gilt nicht mehr, ihre Unit-Tests sind veraltet):
!`git show --stat --oneline HEAD -- src/test/resources/features | tail -n +2; git status --short -- src/test/resources/features`

Die Schritte:
@src/test/java/de/sharpsharp/vendingmachine/VendingMachineSteps.java

Der Automat heute:
@src/main/java/de/sharpsharp/vendingmachine/VendingMachine.java

Stand von `mvn -q verify` jetzt (keine Zeilen heißt grün):
!`mvn -q verify 2>&1 | tail -30`

Vorgehen:
1. Ist das Szenario schon grün: sag das und höre auf.
2. Kompiliert der Code nicht: die Schritte verlangen eine Methode oder ein Interface, das fehlt. Baue genau das, so klein wie möglich.
3. Schreibe einen Unit-Test in `src/test/java/de/sharpsharp/vendingmachine/VendingMachineTest.java` für die kleinste Regel, die das Szenario braucht. Lass ihn laufen: rot.
4. Schreibe den Code, so wenig wie möglich. Lass den Test laufen: grün.
5. Wiederhole 3 und 4, bis das Szenario grün ist.
6. Räum auf nach dem Clean-Code-Check. Dann `mvn -q verify`. Nicht grün: zurück zu 3.
7. Feature-Dateien, Schritte, Specs, `pom.xml` und `config/` bleiben unverändert.
8. Antworte in drei Zeilen: geänderte Dateien, letzte Zeilen von `mvn -q verify`, offen.
