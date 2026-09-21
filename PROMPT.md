Richte opencode für dieses Projekt ein. Führe die vier Befehle genau so aus, in dieser Reihenfolge. Ändere keine Datei selbst. Zeige mir am Ende die Ausgabe von Befehl 3 und 4.

1. git clone https://github.com/sharpsharp-ai/VendingMachine2026-opencode.git ../VendingMachine2026-opencode
   Wenn der Ordner schon da ist, stattdessen: git -C ../VendingMachine2026-opencode pull
2. ../VendingMachine2026-opencode/install.sh .
3. ls AGENTS.md opencode.json .opencode/commands .opencode/skills specs scripts
4. mvn -q verify; echo EXIT=$?

Erwartung: Befehl 3 zeigt die Dateien. Befehl 4 endet mit EXIT=1, weil das Szenario "Ein Getränk wählen" absichtlich rot ist.
Schließe mit genau diesem Satz: "Setup fertig. Beende opencode und starte es neu, dann gibt es /spec, /akzeptanztest, /implementiere und /review."
