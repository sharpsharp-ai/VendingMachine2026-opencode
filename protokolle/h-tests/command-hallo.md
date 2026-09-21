---
description: Test für Datei-Include und Shell-Output
agent: mitprompt
---
Argument: $ARGUMENTS
Inhalt der Datei: @wert.txt
Shell-Ausgabe: !`echo SHELL-MARKER-$(date +%Y)`
Wiederhole wörtlich: das Argument, den Dateiinhalt und die Shell-Ausgabe, je in einer Zeile.
