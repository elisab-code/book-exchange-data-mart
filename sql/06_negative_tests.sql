-- =====================================================================
-- Buchtausch-App | 06_negative_tests.sql
-- Negative Testfälle: Jede Anweisung MUSS mit einem Fehler abbrechen.
--
-- WICHTIG: Anweisungen einzeln ausführen (MySQL Workbench: Cursor in die
-- Anweisung setzen, Strg+Enter). Bei Ausführung als Ganzes stoppt das
-- Skript beim ersten (erwarteten) Fehler.
-- =====================================================================

USE buchtausch_app;

-- Testfall 9: Selbstausleihe verhindern (Trigger trg_keine_selbstausleihe)
INSERT INTO Ausleihe
(ex_id, verleiher_id, entleiher_id, ausleihdatum, faellig_am, status)
VALUES
(2, 2, 2, '2025-06-01', '2025-06-15', 'aktiv');
-- Erwartet: Error Code 1644. Selbstausleihe ist nicht erlaubt

-- Testfall 10: Parallele Ausleihe verhindern (Trigger trg_eine_aktive_ausleihe)
-- Exemplar 1 ist laut Testdaten bereits aktiv ausgeliehen.
INSERT INTO Ausleihe
(ex_id, verleiher_id, entleiher_id, ausleihdatum, faellig_am, status)
VALUES
(1, 1, 3, '2025-06-01', '2025-06-15', 'aktiv');
-- Erwartet: Error Code 1644. Das Buchexemplar ist bereits aktiv ausgeliehen

-- Testfall 11: Bewertung ohne abgeschlossene Ausleihe verhindern
-- (Trigger trg_bewertung_nach_rueckgabe). Benutzer 5 hat Buch 1 nie ausgeliehen.
INSERT INTO Bewertung
(buch_id, benutzer_id, sterne, kommentar, bewertungsdatum)
VALUES
(1, 5, 5, 'Testbewertung', '2025-06-01');
-- Erwartet: Error Code 1644. Bewertung erst nach abgeschlossener Ausleihe erlaubt

-- Testfall 12: Ungültige Sternebewertung (CHECK-Constraint sterne BETWEEN 1 AND 5)
-- Benutzer 3 hat Buch 2 zurückgegeben -> Trigger erfüllt, aber 6 Sterne sind unzulässig.
INSERT INTO Bewertung
(buch_id, benutzer_id, sterne, kommentar, bewertungsdatum)
VALUES
(2, 3, 6, 'Zu viele Sterne', '2025-06-01');
-- Erwartet: Error Code 3819. Check constraint ... is violated

-- Testfall 13: Doppelte E-Mail-Adresse (UNIQUE-Constraint)
INSERT INTO Benutzer
(adresse_id, vorname, nachname, anzeigename, email, registrierungsdatum, kontostatus)
VALUES
(1, 'Test', 'Person', 'test', 'max@example.de', '2025-06-01', 'aktiv');
-- Erwartet: Error Code 1062. Duplicate entry 'max@example.de' for key ...
