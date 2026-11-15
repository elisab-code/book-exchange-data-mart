-- =====================================================================
-- Buchtausch-App | 05_test_queries.sql
-- Positive Testfälle: prüfen Beziehungen, Joins und Struktur
-- =====================================================================

USE buchtausch_app;

-- Wählt alle Spalten der jeweiligen Tabellen aus
SELECT * FROM Buch;
SELECT * FROM Benutzer;
SELECT * FROM BuchExemplar;
SELECT * FROM Angebot;
SELECT * FROM Abholort;
SELECT * FROM Zeitslot;
SELECT * FROM Angebot_Verfuegbarkeit;
SELECT * FROM Anfrage;
SELECT * FROM Ausleihe;
SELECT * FROM Bewertung;
SELECT * FROM Buch_Autor;
SELECT * FROM Buch_Sprache;
SELECT * FROM Buch_Genre;

-- Indizes anzeigen
SHOW INDEX FROM BuchExemplar;
SHOW INDEX FROM Angebot;
SHOW INDEX FROM Anfrage;
SHOW INDEX FROM Ausleihe;
SHOW INDEX FROM Bewertung;

-- Trigger anzeigen
SHOW TRIGGERS;

-- Testfall 1: Zeigt Bücher zusammen mit ihren Autor:innen
SELECT b.titel, au.vorname, au.nachname
FROM Buch b
JOIN Buch_Autor ba ON b.buch_id = ba.buch_id
JOIN Autor au ON ba.autor_id = au.autor_id;

-- Testfall 2: Zeigt Bücher zusammen mit ihren Genres
SELECT b.titel, g.bezeichnung AS genre
FROM Buch b
JOIN Buch_Genre bg ON b.buch_id = bg.buch_id
JOIN Genre g ON bg.genre_id = g.genre_id;

-- Testfall 3: Zeigt Bücher zusammen mit ihren Sprachen
SELECT b.titel, s.bezeichnung AS sprache
FROM Buch b
JOIN Buch_Sprache bs ON b.buch_id = bs.buch_id
JOIN Sprache s ON bs.sprach_id = s.sprach_id;

-- Testfall 4: Zeigt alle verfügbaren Bücher
SELECT b.titel, ag.status
FROM Buch b
JOIN BuchExemplar be ON b.buch_id = be.buch_id
JOIN Angebot ag ON be.ex_id = ag.ex_id
WHERE ag.status = 'verfuegbar';

-- Testfall 5: Zeigt Ausleihen mit Verleiher und Entleiher
SELECT
    b1.anzeigename AS verleiher,
    b2.anzeigename AS entleiher,
    a.ausleihdatum,
    a.status
FROM Ausleihe a
JOIN Benutzer b1 ON a.verleiher_id = b1.benutzer_id
JOIN Benutzer b2 ON a.entleiher_id = b2.benutzer_id;

-- Testfall 6: Zeigt Bewertungen zu Büchern
SELECT
    b.titel,
    bw.sterne,
    bw.kommentar
FROM Bewertung bw
JOIN Buch b ON bw.buch_id = b.buch_id;

-- Testfall 7: Verknüpft Angebote mit Abholort und Stadt
-- (echte Umkreissuche mit Entfernung: siehe 08_analytics.sql)
SELECT
    b.titel,
    ad.ort
FROM Buch b
JOIN BuchExemplar be ON b.buch_id = be.buch_id
JOIN Angebot ag ON be.ex_id = ag.ex_id
JOIN Angebot_Verfuegbarkeit av ON ag.angebot_id = av.angebot_id
JOIN Abholort ao ON av.aort_id = ao.aort_id
JOIN Adresse ad ON ao.adresse_id = ad.adresse_id;

-- Testfall 8: Zeigt verfügbare Zeitslots eines Angebots
SELECT
    ag.angebot_id,
    z.wochentag,
    z.startzeit,
    z.endzeit
FROM Angebot ag
JOIN Angebot_Verfuegbarkeit av
    ON ag.angebot_id = av.angebot_id
JOIN Zeitslot z
    ON av.zeitslot_id = z.zeitslot_id;
