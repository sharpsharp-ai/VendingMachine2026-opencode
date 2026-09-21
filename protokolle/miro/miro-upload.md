# Folien auf dem Miro-Board

Board `uXjVHnldClU=`, Frame `3458764684499712615`. Hochgeladen am 2026-09-22 um 01:35 über die Miro-API
(`image_get_upload_url` → `curl -X PUT` je PNG, alle HTTP 200 → `image_create` mit Token).
Nichts Vorhandenes wurde verändert oder gelöscht; es kamen nur diese elf Bilder hinzu.

Position der linken oberen Ecke relativ zur linken oberen Ecke des Frames, Breite 6000, Höhe 3375.
`image_create` hatte x/y als Mittelpunkt gesetzt (erste Spalte ragte 1000 px über den linken Rand); danach per
`canvas_update_from_svg` nur diese elf Bilder verschoben, Ergebnis mit `canvas_read_as_svg` geprüft. Sonst liegen im Frame
nur zwei Dokumente weit unterhalb (y ≈ 50 000), keine Überlappung.

| Folie | Datei | Bild-ID | x | y |
|---|---|---|---|---|
| 1 | folie-01.png | 3458764684509393595 | 2000 | 2000 |
| 2 | folie-02.png | 3458764684509393636 | 8400 | 2000 |
| 3 | folie-03.png | 3458764684509393674 | 14800 | 2000 |
| 4 | folie-04.png | 3458764684509393703 | 21200 | 2000 |
| 5 | folie-05.png | 3458764684509393734 | 2000 | 5900 |
| 6 | folie-06.png | 3458764684509393774 | 8400 | 5900 |
| 7 | folie-07.png | 3458764684509393801 | 14800 | 5900 |
| 8 | folie-08.png | 3458764684509393850 | 21200 | 5900 |
| 9 | folie-09.png | 3458764684509393872 | 2000 | 9800 |
| 10 | folie-10.png | 3458764684509393894 | 8400 | 9800 |
| 11 | folie-11.png | 3458764684509393909 | 14800 | 9800 |

Link auf die erste Folie: https://miro.com/app/board/uXjVHnldClU=/?moveToWidget=3458764684509393595
