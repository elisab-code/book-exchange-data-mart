-- =====================================================================
-- Buchtausch-App | 07_use_case.sql
-- End-to-End-Anwendungsfall:
-- Exemplar einstellen -> Angebot -> Anfrage -> Annahme -> Ausleihe
-- -> Rückgabe -> Bewertung
--
-- Neu angelegte Datensätze werden über LAST_INSERT_ID() in Variablen
-- gespeichert. Dadurch arbeitet der Ablauf immer mit SEINEN Datensätzen
-- und kollidiert nicht mit den Testdaten (z. B. aktiven Ausleihen).
-- Voraussetzung: 01–04 wurden ausgeführt.
-- =====================================================================

USE buchtausch_app;

-- ---------------------------------------------------------------------
-- Schritt 0: Benutzerin 4 (sofiebooks) stellt ein eigenes Exemplar von
-- "Harry Potter und der Stein der Weisen" (buch_id 2) ein
-- ---------------------------------------------------------------------
INSERT INTO BuchExemplar
(buch_id, benutzer_id, zustand, notiz_zum_zustand, verleihbar)
VALUES
(2, 4, 'gut', 'Leichte Gebrauchsspuren', TRUE);

SET @ex_id = LAST_INSERT_ID();

-- ---------------------------------------------------------------------
-- Schritt 1: Sie bietet das Exemplar zur Ausleihe an (max. 3 Wochen)
-- und hinterlegt Abholort und Zeitslot
-- ---------------------------------------------------------------------
INSERT INTO Angebot
(ex_id, max_verleihdauer, versand_moeglich, status, erstellt_am)
VALUES
(@ex_id, 3, TRUE, 'verfuegbar', CURDATE());

SET @angebot_id = LAST_INSERT_ID();

INSERT INTO Angebot_Verfuegbarkeit
(angebot_id, aort_id, zeitslot_id, hinweis)
VALUES
(@angebot_id, 1, 1, 'Treffpunkt Haupteingang');

SELECT * FROM Angebot WHERE angebot_id = @angebot_id;

-- ---------------------------------------------------------------------
-- Schritt 2: Benutzerin 6 (emma_reads) sendet eine Anfrage
-- ---------------------------------------------------------------------
INSERT INTO Anfrage
(angebot_id, benutzer_id, anfragedatum, nachricht, status)
VALUES
(@angebot_id, 6, CURDATE(), 'Ich moechte das Buch gerne ausleihen.', 'offen');

SET @anfrage_id = LAST_INSERT_ID();

SELECT * FROM Anfrage WHERE anfrage_id = @anfrage_id;

-- ---------------------------------------------------------------------
-- Schritt 3: Die Anfrage wird angenommen, das Angebot reserviert
-- ---------------------------------------------------------------------
UPDATE Anfrage SET status = 'angenommen' WHERE anfrage_id = @anfrage_id;
UPDATE Angebot SET status = 'reserviert' WHERE angebot_id = @angebot_id;

SELECT a.anfrage_id, a.status AS anfrage_status, ag.status AS angebot_status
FROM Anfrage a
JOIN Angebot ag ON a.angebot_id = ag.angebot_id
WHERE a.anfrage_id = @anfrage_id;

-- ---------------------------------------------------------------------
-- Schritt 4: Das Buch wird ausgeliehen (Fälligkeit = max. Verleihdauer)
-- ---------------------------------------------------------------------
INSERT INTO Ausleihe
(ex_id, verleiher_id, entleiher_id, ausleihdatum, faellig_am, rueckgabe_am, status)
VALUES
(@ex_id, 4, 6, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 3 WEEK), NULL, 'aktiv');

SET @ausleihe_id = LAST_INSERT_ID();

SELECT * FROM Ausleihe WHERE ausleihe_id = @ausleihe_id;

-- ---------------------------------------------------------------------
-- Schritt 5: Rückgabe; das Angebot ist wieder verfügbar
-- ---------------------------------------------------------------------
UPDATE Ausleihe
SET rueckgabe_am = CURDATE(),
    status       = 'zurueckgegeben'
WHERE ausleihe_id = @ausleihe_id;

UPDATE Angebot SET status = 'verfuegbar' WHERE angebot_id = @angebot_id;

SELECT ausleihe_id, rueckgabe_am, status FROM Ausleihe WHERE ausleihe_id = @ausleihe_id;

-- ---------------------------------------------------------------------
-- Schritt 6: Benutzerin 6 bewertet das Buch
-- (wird vom Trigger zugelassen, da die Ausleihe abgeschlossen ist)
-- ---------------------------------------------------------------------
INSERT INTO Bewertung
(buch_id, benutzer_id, sterne, kommentar, bewertungsdatum)
VALUES
(2, 6, 5, 'Sehr spannendes Buch und unkomplizierte Ausleihe.', CURDATE());

SELECT b.titel, u.anzeigename, bw.sterne, bw.kommentar, bw.bewertungsdatum
FROM Bewertung bw
JOIN Buch b     ON bw.buch_id = b.buch_id
JOIN Benutzer u ON bw.benutzer_id = u.benutzer_id
WHERE bw.bewertung_id = LAST_INSERT_ID();
