# opencode in IntelliJ unter Windows

Stand 2026-09-22, opencode 1.18, IntelliJ mit dem Plugin AI Assistant. Durchgespielt auf dem Mac; die
Windows-Pfade und -Befehle stammen aus der Doku von opencode und JetBrains.

## 1. Werkzeuge, einmal pro Rechner

| Was | Wie | Prüfen |
|---|---|---|
| JDK 17 | `winget install EclipseAdoptium.Temurin.17.JDK` | `java -version` |
| Maven auf dem PATH | Zip von maven.apache.org entpacken, `bin` in den PATH; oder `choco install maven` bzw. `scoop install maven`. IntelliJs eingebautes Maven reicht nicht, opencode ruft `mvn` in der Shell | `mvn -v` |
| Git for Windows | `winget install Git.Git`, bringt Git Bash mit | `"C:\Program Files\Git\bin\bash.exe" --version` |
| opencode | `npm install -g opencode-ai` (braucht Node) oder `scoop install opencode` oder `choco install opencode` | `opencode --version` |

Danach ein neues Terminal öffnen, damit der PATH stimmt.

## 2. opencode einstellen

Datei `C:\Users\<name>\.config\opencode\opencode.json` anlegen:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "shell": "C:\\Program Files\\Git\\bin\\bash.exe",
  "provider": {
    "compax": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Compax Qwen",
      "options": {
        "baseURL": "https://<endpunkt>/v1",
        "apiKey": "{env:COMPAX_API_KEY}"
      },
      "models": {
        "qwen3.6-35b-a3b": { "name": "Qwen 3.6 35B-A3B" }
      }
    }
  },
  "model": "compax/qwen3.6-35b-a3b"
}
```

- `shell`: Ohne diese Zeile nimmt das `bash`-Tool unter Windows cmd.exe. Die Rechte in der `opencode.json` der Repos (`mvn *`, `ls*`, `cat *`, `git status*`) und die Skripte unter `scripts/` setzen bash voraus.
- `baseURL` und Modell-ID kommen vom Betreiber des Endpunkts; die ID ist die, die der Endpunkt unter `/v1/models` meldet.
- Schlüssel als Umgebungsvariable: `setx COMPAX_API_KEY "…"`, danach ab- und anmelden, damit IntelliJ ihn sieht.
- Wer stattdessen OpenAI nutzt: `opencode auth login`, Provider OpenAI, API-Key eingeben. Nicht die ChatGPT-Anmeldung: Sie läuft über Codex und lehnt `gpt-5.4-mini` ab.

Test im Terminal, im Projektordner:

```powershell
mvn -q verify
opencode run "Welche Dateien liegen hier?"
```

## 3. IntelliJ anbinden

1. Plugin AI Assistant aktiv. Fenster AI Chat öffnen, im Agenten-Menü „Add Custom Agent" wählen. IntelliJ legt `C:\Users\<name>\.jetbrains\acp.json` an und öffnet sie.
2. Pfad der ausführbaren Datei ermitteln: `where opencode` in cmd. Es muss die `.exe` sein, nicht die `opencode.cmd` von npm; bei npm liegt sie unter `npm root -g` im Ordner `opencode-windows-x64\bin\`.
3. Inhalt der Datei, Backslashes doppelt:

```json
{
  "default_mcp_settings": {},
  "agent_servers": {
    "OpenCode": {
      "command": "C:\\Users\\<name>\\scoop\\shims\\opencode.exe",
      "args": ["acp"],
      "env": {}
    }
  }
}
```

4. IntelliJ neu starten. Projekt öffnen: File → New → Project from Version Control, Repo-URL einfügen. Im AI Chat den Agenten „OpenCode" wählen.
5. Die Rollen aus dem Repo erscheinen als Session-Modi: `spec-autor`, `test-autor`, `implementierer`, `reviewer` beim Automaten, `test-autor` bei Gilded Rose, `clean-code-coach` beim TripService. Die Commands (`/spec 1`, `/akzeptanztest 1`, `/implementiere …`, `/review`, `/approval-test`, `/characterization-test`, `/coach`) laufen wie im Terminal. `/undo` und `/redo` nicht.

## 4. Stolpersteine

- „Edit-Tool blockiert": Die Session steht noch in der Rolle des letzten Commands, etwa `reviewer`. Modus auf `build` oder `implementierer` stellen.
- `mvn` nicht gefunden: PATH prüfen, neues Terminal, IntelliJ neu starten.
- Skript endet mit `bad interpreter` oder `\r`: CRLF beim Auschecken. Die Repos bringen eine `.gitattributes` mit (`*.sh eol=lf`); ältere Clones neu klonen.
- Kein Modell oder 401: `COMPAX_API_KEY` nicht gesetzt oder IntelliJ vor dem `setx` gestartet.
- „not supported when using Codex": ChatGPT-Login statt API-Key.
