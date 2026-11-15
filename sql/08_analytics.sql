-- =====================================================================
-- Buchtausch-App | 08_analytics.sql
-- Auswertungen auf dem Datenbestand: Aggregationen, Fensterfunktionen,
-- Geodistanzen und eine wiederverwendbare View.
-- Voraussetzung: 01–04 wurden ausgeführt.
-- =====================================================================

USE buchtausch_app;

-- ---------------------------------------------------------------------
-- A1: Durchschnittliche Bewertung pro Genre
-- ---------------------------------------------------------------------
SELECT
    g.bezeichnung               AS genre,
    COUNT(bw.bewertung_id)      AS anzahl_bewertungen,
    ROUND(AVG(bw.sterne), 2)    AS durchschnitt_sterne
FROM Genre g
JOIN Buch_Genre bg ON g.genre_id = bg.genre_id
JOIN Bewertung bw  ON bw.buch_id = bg.buch_id
GROUP BY g.genre_id, g.bezeichnung
ORDER BY durchschnitt_sterne DESC, anzahl_bewertungen DESC;

-- ---------------------------------------------------------------------
-- A2: Überfällige Ausleihen zu einem Stichtag
-- (Stichtag passend zu den Testdaten aus 2025; für echte Daten CURDATE())
-- ---------------------------------------------------------------------
SET @stichtag = '2025-03-31';

SELECT
    a.ausleihe_id,
    b.titel,
    e.anzeigename                         AS entleiher,
    a.faellig_am,
    DATEDIFF(@stichtag, a.faellig_am)     AS tage_ueberfaellig
FROM Ausleihe a
JOIN BuchExemplar be ON a.ex_id = be.ex_id
JOIN Buch b          ON be.buch_id = b.buch_id
JOIN Benutzer e      ON a.entleiher_id = e.benutzer_id
WHERE a.rueckgabe_am IS NULL
  AND a.faellig_am < @stichtag
ORDER BY tage_ueberfaellig DESC;

-- ---------------------------------------------------------------------
-- A3: Ranking der aktivsten Verleiher:innen (Fensterfunktion RANK)
-- ---------------------------------------------------------------------
SELECT
    u.anzeigename,
    COUNT(*)                               AS anzahl_verleihvorgaenge,
    RANK() OVER (ORDER BY COUNT(*) DESC)   AS rang
FROM Ausleihe a
JOIN Benutzer u ON a.verleiher_id = u.benutzer_id
GROUP BY u.benutzer_id, u.anzeigename
ORDER BY rang, u.anzeigename;

-- ---------------------------------------------------------------------
-- A4: Verteilung der Anfragestatus mit Prozentanteil
-- (Fensterfunktion über das Aggregat)
-- ---------------------------------------------------------------------
SELECT
    status,
    COUNT(*)                                              AS anzahl,
    ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 1)      AS anteil_prozent
FROM Anfrage
GROUP BY status
ORDER BY anzahl DESC;

-- ---------------------------------------------------------------------
-- A5: Umkreissuche – verfügbare Angebote im Radius um einen Standort
-- ST_Distance_Sphere liefert die Entfernung in Metern (POINT(Längengrad, Breitengrad))
-- ---------------------------------------------------------------------
SET @lat = 52.520008;   -- Berlin Mitte
SET @lng = 13.404954;
SET @radius_km = 300;

SELECT
    b.titel,
    ao.bezeichnung AS abholort,
    ad.ort,
    ROUND(ST_Distance_Sphere(
        POINT(ad.laengengrad, ad.breitengrad),
        POINT(@lng, @lat)
    ) / 1000, 1) AS entfernung_km
FROM Angebot ag
JOIN BuchExemplar be           ON ag.ex_id = be.ex_id
JOIN Buch b                    ON be.buch_id = b.buch_id
JOIN Angebot_Verfuegbarkeit av ON ag.angebot_id = av.angebot_id
JOIN Abholort ao               ON av.aort_id = ao.aort_id
JOIN Adresse ad                ON ao.adresse_id = ad.adresse_id
WHERE ag.status = 'verfuegbar'
HAVING entfernung_km <= @radius_km
ORDER BY entfernung_km;

-- ---------------------------------------------------------------------
-- A6: View für die Suche in der App – alle aktuell verfügbaren Angebote
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW v_verfuegbare_angebote AS
SELECT
    ag.angebot_id,
    b.titel,
    GROUP_CONCAT(DISTINCT CONCAT(au.vorname, ' ', au.nachname)
                 ORDER BY au.nachname SEPARATOR ', ') AS autor_innen,
    be.zustand,
    ag.max_verleihdauer,
    ag.versand_moeglich,
    u.anzeigename AS anbieter
FROM Angebot ag
JOIN BuchExemplar be ON ag.ex_id = be.ex_id
JOIN Buch b          ON be.buch_id = b.buch_id
JOIN Buch_Autor ba   ON b.buch_id = ba.buch_id
JOIN Autor au        ON ba.autor_id = au.autor_id
JOIN Benutzer u      ON be.benutzer_id = u.benutzer_id
WHERE ag.status = 'verfuegbar'
  AND be.verleihbar = TRUE
GROUP BY ag.angebot_id, b.titel, be.zustand,
         ag.max_verleihdauer, ag.versand_moeglich, u.anzeigename;

SELECT * FROM v_verfuegbare_angebote ORDER BY titel;
