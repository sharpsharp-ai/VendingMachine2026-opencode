#!/bin/bash
# checks.sh <story>: baut die Anwendung, startet sie auf Port 7091 und prüft die Story per HTTP.
cd "$(pwd)"
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
mvn -q -DskipTests package > /dev/null 2>&1 || { echo "FAIL package"; exit 1; }
PORT=7091 java -jar target/getraenkeautomat.jar > /dev/null 2>&1 &
PID=$!
for i in $(seq 1 30); do curl -sf http://localhost:7091/api/state > /dev/null 2>&1 && break; sleep 1; done
python3 - "$1" <<'PY'
import json, sys, urllib.request, datetime
B = "http://localhost:7091"
def get(): return json.load(urllib.request.urlopen(B + "/api/state"))
def post(p): return json.load(urllib.request.urlopen(urllib.request.Request(B + p, method="POST")))
def tray(s): return [c["drink"] for c in s["outputTray"]]
story = int(sys.argv[1]); ok = True
def check(name, cond):
    global ok; print(("OK   " if cond else "FAIL ") + name); ok = ok and cond
s = get()
if story == 1:
    r = post("/api/select/COLA"); check("Cola fällt ohne Geld", tray(r) == ["COLA"])
    r = post("/api/take-drinks"); check("Ausgabefach leer nach Entnahme", tray(r) == [])
if story == 2:
    check("jedes Fach hat einen Preis", all(sl["price"] is not None for sl in s["slots"]))
    check("Cola kostet 1,00 €", s["slots"][0]["price"] == 100)
if story == 3:
    post("/api/insert/200"); r = post("/api/insert/50"); check("Guthaben 2,50 € nach 2 € und 50 ct", r["credit"] == 250)
if story >= 4:
    r = post("/api/select/COLA"); check("ohne Guthaben: Zu wenig Geld", "Zu wenig Geld" in r["message"] and tray(r) == [])
    post("/api/insert/200"); r = post("/api/select/COLA"); check("mit 2 €: Cola fällt, Rest 1,00 €", tray(r) == ["COLA"] and r["credit"] == 100)
    post("/api/take-drinks")
if story == 5:
    r = post("/api/cancel"); check("Abbruch: Guthaben 0, Münzen in Rückgabe", r["credit"] == 0 and sum(r["coinReturn"]) == 100)
    r = post("/api/take-coins"); check("Münzrückgabe leer nach Entnahme", r["coinReturn"] == [])
if story >= 6:
    check("Bier kostet 2,00 €", s["slots"][3]["price"] == 200)
    post("/api/cancel"); post("/api/take-coins")
    post("/api/insert/100"); r = post("/api/select/BEER"); check("Bier mit 1 €: Zu wenig Geld", "Zu wenig Geld" in r["message"] and tray(r) == [])
    post("/api/insert/100"); r = post("/api/select/BEER")
    if story == 6 or datetime.datetime.now().hour >= 16:
        check("Bier mit 2 €: fällt", tray(r) == ["BEER"] and r["credit"] == 0)
    else:
        check("Bier vor 16 Uhr: Kein Bier vor 4, Guthaben bleibt", "Kein Bier vor 4" in r["message"] and r["credit"] == 200)
print("RESULT", "OK" if ok else "FAIL")
PY
kill $PID 2>/dev/null
