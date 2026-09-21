#!/usr/bin/env python3
"""Erzeugt die Folien „So verwendet ihr opencode" als HTML (für PDF und PNG) und als PPTX.
Aufruf: python3 folien.py  → folien.html, folien.pdf, folie-NN.png, folien.pptx im selben Ordner."""
import html, os, subprocess, sys
from pathlib import Path

HIER = Path(__file__).resolve().parent
CHROME = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
BLAU = "0B5FA5"; DUNKEL = "1F2933"; GRAU = "5C6670"; HELL = "EAF2FB"; LINIE = "D5DEE8"

# Jede Folie: titel, art, inhalt. Arten: bullets, spalten, tabelle, code, zitat.
FOLIEN = [
    dict(art="titel", titel="So verwendet ihr opencode",
         untertitel="Getränkeautomat, Story für Story: Spec, Szenarien, Test, Code, Review"),
    dict(titel="opencode sitzt zwischen dir und dem LLM", art="spalten", spalten=[
        ("Du", ["gibst ein Ziel vor", "prüfst jedes Diff", "entscheidest, was gilt"]),
        ("opencode", ["Kontext: AGENTS.md, Dateien, Verlauf", "Tools: lesen, suchen, ändern, bash", "Schleife: bis das LLM fertig meldet", "Grenzen: Rechte und Schrittlimit"]),
        ("LLM", ["liest den Kontext", "erzeugt Text: Antwort oder Tool-Aufruf", "sieht nur, was opencode ihm zeigt"]),
    ], fuss="Das LLM entscheidet, opencode handelt. Zusammen sind sie ein Agent."),
    dict(titel="Ein Agent verfolgt ein Ziel mit Werkzeugen", art="spalten", spalten=[
        ("Ziel", ["bekommt ein Ergebnis vorgegeben, keine Einzelschritte"]),
        ("Werkzeuge", ["liest, ändert und führt aus, in deinem Projekt"]),
        ("Schleife", ["handelt, sieht das Ergebnis, entscheidet neu"]),
        ("Grenzen", ["Rechte, Schrittlimit, ein Mensch, der prüft"]),
    ], fuss="Agent = LLM + Kontext + Tools + Schleife. Ein Chatbot antwortet. Ein Agent handelt, prüft das Ergebnis und macht weiter."),
    dict(titel="Bedienung", art="tabelle", kopf=("Was", "Wie"), zeilen=[
        ("starten", "im Projektordner: opencode"),
        ("Rolle wechseln", "Tab: build, plan, spec-autor, test-autor, implementierer, reviewer"),
        ("Datei in den Kontext", "@src/main/java/.../VendingMachine.java im Text"),
        ("letzte Änderung zurück", "/undo"),
        ("eigene Commands", "/spec 1, /akzeptanztest 1, /implementiere Ein Getränk wählen, /review"),
        ("neue Session", "/new, vor jedem Command und je Szenario"),
    ]),
    dict(titel="Was opencode mitbringt und was nicht", art="spalten", spalten=[
        ("Bringt es mit", ["Dateien lesen, suchen, ändern", "Befehle ausführen, Ergebnis lesen", "Rechte: allow, ask, deny", "AGENTS.md als Dauerkontext"]),
        ("Bringt es nicht mit", ["die Reihenfolge der Schritte", "den Maßstab für gut genug", "das Fertig-Kriterium", "das Fachwissen zum Automaten"]),
    ], fuss="Das Repo ist der stärkste Prompt: AGENTS.md, Commands, Skills, Gates liegen im Projekt."),
    dict(titel="Die Bausteine im Projekt", art="tabelle", kopf=("Baustein", "Was er tut", "Wann im Kontext"), zeilen=[
        ("AGENTS.md", "Befehle, Struktur, Arbeitsweise, Code-Regeln", "immer, jede Session"),
        ("features/AGENTS.md", "Regeln für Szenarien", "sobald eine Feature-Datei gelesen wird"),
        ("Commands", "Prompt-Vorlage mit Spec, Glossar, mvn-Ausgabe", "wenn du /spec, /akzeptanztest, /implementiere, /review tippst"),
        ("Skills", "Checklisten: EARS, elf Regeln, TDD, Clean Code", "der Command fügt sie ein"),
        ("Agents", "Rolle mit Rechten und Schrittlimit", "der Command wählt die Rolle"),
        ("Gates", "mvn -q verify: Tests, Checkstyle, ArchUnit, JaCoCo", "vor jedem Fertig"),
    ]),
    dict(titel="Die Pipeline je Story", art="schritte", schritte=[
        ("Story", "Karte aus specs/stories.md"),
        ("/spec", "Regeln in EARS, specs/<nr>-<name>/spec.md"),
        ("/akzeptanztest", "Szenarien in Gherkin, Schritte in Java"),
        ("/implementiere", "je Szenario: roter Test, Code, aufräumen, mvn -q verify"),
        ("/review", "Befunde mit Datei:Zeile, Smell, Vorschlag"),
    ], fuss="Du prüfst nach jedem Schritt: Stimmen die Regeln? Erfüllen die Szenarien die elf Regeln? Verstehst du das Diff? Welche Befunde nimmst du an?"),
    dict(titel="Spec Driven Development", art="code", text=(
        "Erst die Regel, dann das Beispiel, dann der Code.\n"
        "Die Feature-Datei ist der ausführbare Teil der Spec.\n\n"
        "EARS      WHILE es vor 16:00 Uhr ist, WHEN der Kunde Bier wählt,\n"
        "          SHALL der Automat keine Dose ausgeben und \"Kein Bier vor 4\" melden.\n\n"
        "Gherkin   Szenario: Vor 16 Uhr fällt kein Bier\n"
        "            Angenommen es ist 15:59 Uhr\n"
        "            Und ich habe 2 € eingeworfen\n"
        "            Wenn ich Bier wähle\n"
        "            Dann ist das Ausgabefach leer\n"
        "            Und der Automat meldet \"Kein Bier vor 4\"")),
    dict(titel="Elf Regeln für Akzeptanztests", art="nummern", punkte=[
        "Ein Szenario, ein Verhalten: genau ein Wenn, keins bei einer Regel ohne Auslöser.",
        "Deklarativ: was, nicht wie. Keine Knöpfe, Klicks, IDs, HTTP.",
        "Fachsprache des Kunden: Namen statt Nummern.",
        "Angenommen ist Zustand, Wenn ist Ereignis, Dann ist von außen sichtbar: Dose, Guthaben, Meldung, Preis, Bestand.",
        "Konkrete Beispiele mit Grenzwerten, nur relevante Details.",
        "Der Titel nennt die Regel, nicht den Ablauf.",
        "Unabhängig und wiederholbar: Zeit und Zufall gestellt.",
        "Vorhandene Schritte wiederverwenden, neue nur bei fehlendem Wort.",
        "Jedes Kriterium: Normalfall, Randfall, Fehlerfall.",
        "Höchstens sechs Schritte, Grundlage sparsam.",
        "Schritte sprechen mit dem Automaten, nicht mit der Oberfläche.",
    ]),
    dict(titel="Vorher und nachher: Story 1", art="spalten", spalten=[
        ("Vanilla opencode, zwei Versuche", [
            "Versuch 1, 57 Sekunden: mvn -q verify grün. 16 Zeilen in VendingMachine.java, kein Test, keine Spec.",
            "Nebenbei takeCoins und coinReturn gebaut, die keine Story verlangt.",
            "Versuch 2, 10 Sekunden: Dateipfad außerhalb des Projekts erfunden, Rechteabfrage abgelehnt, aufgehört.",
        ]),
        ("Mit Pipeline, viereinhalb Minuten", [
            "/spec: eine Regel: WHILE eine Dose im Fach ist, WHEN der Kunde ein Fach wählt, SHALL … Keine offenen Fragen.",
            "/akzeptanztest: zweites Szenario „Guthaben bleibt beim freien Getränk gleich“, beide rot.",
            "/implementiere: Unit-Test zuerst rot, dann zehn Zeilen Code, verify grün.",
            "/review: ein Befund mit Datei:Zeile: der Bestand wird beim Ausgeben nicht verringert.",
        ]),
    ], fuss="Gleiches Modell, gleiche Story. Der Unterschied: Regeln, Szenarien, Test und Review, jedes Mal in dieser Reihenfolge."),
    dict(titel="Deine Verantwortung", art="bullets", punkte=[
        "Du reviewst jedes Diff. Der Agent liefert Vorschläge, du lieferst Code.",
        "Wer eine Regel nicht formulieren kann, kann sie auch nicht vom Agenten verlangen.",
        "Kleine Schritte: ein Szenario, eine Session, ein Commit.",
        "Hängt der Agent: Szenario kleiner schneiden, /implementiere neu starten, scripts/bis-gruen.sh.",
        "mvn -q verify entscheidet. Nicht das Gefühl, nicht der Agent.",
    ]),
]

# ---------------------------------------------------------------- HTML
CSS = f"""
@page {{ size: 1600px 900px; margin: 0; }}
* {{ box-sizing: border-box; }}
body {{ margin: 0; font-family: "Helvetica Neue", Helvetica, Arial, sans-serif; color: #{DUNKEL}; background: #fff; }}
.folie {{ width: 1600px; height: 900px; padding: 80px 110px 70px; page-break-after: always; position: relative; background: #fff; overflow: hidden; }}
h1 {{ color: #{BLAU}; font-size: 54px; font-weight: 700; margin: 0 0 44px; letter-spacing: -0.5px; }}
.titel {{ display: flex; flex-direction: column; justify-content: center; }}
.titel h1 {{ font-size: 82px; margin-bottom: 26px; }}
.titel p {{ font-size: 34px; color: #{GRAU}; margin: 0; }}
ul, ol {{ font-size: 30px; line-height: 1.5; margin: 0; padding-left: 42px; }}
li {{ margin-bottom: 14px; }}
.spalten {{ display: flex; gap: 34px; }}
.spalte {{ flex: 1; background: #{HELL}; border-radius: 14px; padding: 30px 32px; }}
.spalte h2 {{ color: #{BLAU}; font-size: 32px; margin: 0 0 18px; }}
.spalte ul {{ font-size: 26px; padding-left: 28px; }}
.fuss {{ position: absolute; left: 110px; right: 110px; bottom: 70px; font-size: 28px; color: #{DUNKEL}; border-top: 3px solid #{BLAU}; padding-top: 22px; }}
table {{ border-collapse: collapse; width: 100%; font-size: 27px; }}
th {{ text-align: left; color: #{BLAU}; font-size: 26px; border-bottom: 3px solid #{BLAU}; padding: 10px 14px; }}
td {{ padding: 14px 14px; border-bottom: 1px solid #{LINIE}; vertical-align: top; line-height: 1.35; }}
td:first-child {{ font-weight: 700; white-space: nowrap; }}
pre {{ font-family: "SF Mono", Menlo, Consolas, monospace; font-size: 27px; line-height: 1.45; background: #{HELL}; border-radius: 14px; padding: 34px 40px; margin: 0; }}
.schritte {{ display: flex; gap: 22px; align-items: stretch; }}
.schritt {{ flex: 1; background: #{HELL}; border-radius: 14px; padding: 26px 24px; }}
.schritt b {{ display: block; color: #{BLAU}; font-size: 30px; margin-bottom: 12px; font-family: Menlo, monospace; }}
.schritt span {{ font-size: 24px; line-height: 1.4; }}
.nummern ol {{ columns: 2; column-gap: 60px; font-size: 27px; }}
.nummern li {{ break-inside: avoid; margin-bottom: 12px; }}
"""

def e(t): return html.escape(t)

def html_folie(f):
    art = f["art"]
    if art == "titel":
        return f'<section class="folie titel"><h1>{e(f["titel"])}</h1><p>{e(f["untertitel"])}</p></section>'
    body = ""
    if art == "bullets":
        body = "<ul>" + "".join(f"<li>{e(p)}</li>" for p in f["punkte"]) + "</ul>"
    elif art == "nummern":
        body = '<div class="nummern"><ol>' + "".join(f"<li>{e(p)}</li>" for p in f["punkte"]) + "</ol></div>"
    elif art == "spalten":
        body = '<div class="spalten">' + "".join(
            f'<div class="spalte"><h2>{e(k)}</h2><ul>' + "".join(f"<li>{e(z)}</li>" for z in zs) + "</ul></div>"
            for k, zs in f["spalten"]) + "</div>"
    elif art == "tabelle":
        body = "<table><tr>" + "".join(f"<th>{e(k)}</th>" for k in f["kopf"]) + "</tr>" + "".join(
            "<tr>" + "".join(f"<td>{e(z)}</td>" for z in zeile) + "</tr>" for zeile in f["zeilen"]) + "</table>"
    elif art == "code":
        body = f"<pre>{e(f['text'])}</pre>"
    elif art == "schritte":
        body = '<div class="schritte">' + "".join(f'<div class="schritt"><b>{e(k)}</b><span>{e(v)}</span></div>' for k, v in f["schritte"]) + "</div>"
    fuss = f'<div class="fuss">{e(f["fuss"])}</div>' if f.get("fuss") else ""
    return f'<section class="folie"><h1>{e(f["titel"])}</h1>{body}{fuss}</section>'

def schreibe_html():
    doc = f'<!doctype html><html lang="de"><head><meta charset="utf-8"><title>So verwendet ihr opencode</title><style>{CSS}</style></head><body>' + "".join(html_folie(f) for f in FOLIEN) + "</body></html>"
    (HIER / "folien.html").write_text(doc, encoding="utf-8")
    # eine Datei je Folie für die PNGs
    for i, f in enumerate(FOLIEN, 1):
        (HIER / f"_folie-{i:02d}.html").write_text(f'<!doctype html><html lang="de"><head><meta charset="utf-8"><style>{CSS}</style></head><body>{html_folie(f)}</body></html>', encoding="utf-8")

def rendere():
    subprocess.run([CHROME, "--headless=new", "--no-sandbox", "--disable-gpu", "--no-pdf-header-footer",
                    f"--print-to-pdf={HIER / 'folien.pdf'}", str(HIER / "folien.html")], check=True, capture_output=True)
    for i in range(1, len(FOLIEN) + 1):
        subprocess.run([CHROME, "--headless=new", "--no-sandbox", "--disable-gpu", "--window-size=1600,900", "--hide-scrollbars",
                        f"--screenshot={HIER / f'folie-{i:02d}.png'}", str(HIER / f"_folie-{i:02d}.html")], check=True, capture_output=True)
        (HIER / f"_folie-{i:02d}.html").unlink()

# ---------------------------------------------------------------- PPTX
def schreibe_pptx():
    from pptx import Presentation
    from pptx.util import Inches, Pt, Emu
    from pptx.dml.color import RGBColor
    from pptx.enum.text import PP_ALIGN
    blau, dunkel, grau, hell = (RGBColor.from_string(c) for c in (BLAU, DUNKEL, GRAU, HELL))
    prs = Presentation(); prs.slide_width = Inches(13.333); prs.slide_height = Inches(7.5)
    leer = prs.slide_layouts[6]
    L, T, W = Inches(0.9), Inches(0.65), Inches(11.5)

    def text(slide, x, y, w, h, zeilen, size=22, bold=False, color=dunkel, bullets=False, font=None, fill=None):
        box = slide.shapes.add_textbox(x, y, w, h)
        if fill is not None:
            box.fill.solid(); box.fill.fore_color.rgb = fill
        tf = box.text_frame; tf.word_wrap = True
        tf.margin_left = tf.margin_right = Inches(0.25); tf.margin_top = tf.margin_bottom = Inches(0.18)
        for i, z in enumerate(zeilen):
            p = tf.paragraphs[0] if i == 0 else tf.add_paragraph()
            r = p.add_run(); r.text = ("•  " + z) if bullets else z
            r.font.size = Pt(size); r.font.bold = bold; r.font.color.rgb = color
            if font: r.font.name = font
            p.space_after = Pt(6)
        return box

    def titel(slide, t):
        text(slide, L, T, W, Inches(0.9), [t], size=36, bold=True, color=blau)

    def fuss(slide, t):
        if not t: return
        line = slide.shapes.add_shape(1, L, Inches(6.35), W, Emu(28000)); line.fill.solid(); line.fill.fore_color.rgb = blau; line.line.fill.background()
        text(slide, L, Inches(6.45), W, Inches(0.9), [t], size=18)

    for f in FOLIEN:
        s = prs.slides.add_slide(leer); art = f["art"]
        if art == "titel":
            text(s, L, Inches(2.6), W, Inches(1.4), [f["titel"]], size=54, bold=True, color=blau)
            text(s, L, Inches(4.0), W, Inches(1.0), [f["untertitel"]], size=24, color=grau)
            continue
        titel(s, f["titel"])
        y = Inches(1.7)
        if art in ("bullets", "nummern"):
            pts = f["punkte"]
            if art == "nummern": pts = [f"{i}. {p}" for i, p in enumerate(pts, 1)]
            if len(pts) > 6:
                h = (len(pts) + 1) // 2
                text(s, L, y, Inches(5.6), Inches(4.5), pts[:h], size=18)
                text(s, L + Inches(5.9), y, Inches(5.6), Inches(4.5), pts[h:], size=18)
            else:
                text(s, L, y, W, Inches(4.5), pts, size=22, bullets=True)
        elif art == "spalten":
            n = len(f["spalten"]); gap = Inches(0.25); w = (W - gap * (n - 1)) / n
            for i, (k, zs) in enumerate(f["spalten"]):
                x = L + (w + gap) * i
                box = text(s, x, y, w, Inches(4.3), [k] + zs, size=18, fill=hell)
                tf = box.text_frame
                p0 = tf.paragraphs[0]; p0.runs[0].font.bold = True; p0.runs[0].font.size = Pt(22); p0.runs[0].font.color.rgb = blau
                for p in tf.paragraphs[1:]: p.runs[0].text = "•  " + p.runs[0].text
        elif art == "tabelle":
            zeilen = [f["kopf"]] + f["zeilen"]
            tbl = s.shapes.add_table(len(zeilen), len(f["kopf"]), L, y, W, Inches(0.5) * len(zeilen)).table
            for r, zeile in enumerate(zeilen):
                for c, z in enumerate(zeile):
                    cell = tbl.cell(r, c); cell.text = z
                    for p in cell.text_frame.paragraphs:
                        for run in p.runs:
                            run.font.size = Pt(15 if r else 16); run.font.bold = (r == 0 or c == 0)
                            run.font.color.rgb = blau if r == 0 else dunkel
                    cell.fill.solid(); cell.fill.fore_color.rgb = RGBColor(0xFF, 0xFF, 0xFF) if r else hell
        elif art == "code":
            text(s, L, y, W, Inches(4.6), f["text"].split("\n"), size=16, font="Menlo", fill=hell)
        elif art == "schritte":
            n = len(f["schritte"]); gap = Inches(0.2); w = (W - gap * (n - 1)) / n
            for i, (k, v) in enumerate(f["schritte"]):
                box = text(s, L + (w + gap) * i, y, w, Inches(3.4), [k, v], size=16, fill=hell)
                r0 = box.text_frame.paragraphs[0].runs[0]; r0.font.bold = True; r0.font.size = Pt(20); r0.font.color.rgb = blau; r0.font.name = "Menlo"
        fuss(s, f.get("fuss"))
    prs.save(HIER / "folien.pptx")

if __name__ == "__main__":
    schreibe_html(); rendere(); schreibe_pptx()
    print("ok:", [p.name for p in sorted(HIER.glob("folie*"))])
