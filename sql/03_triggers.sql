-- =====================================================================
-- Buchtausch-App | 03_triggers.sql
-- Geschäftsregeln, die direkt auf Datenbankebene durchgesetzt werden
-- =====================================================================

USE buchtausch_app;

-- Regel 1: Niemand darf sein eigenes Buch ausleihen.
DELIMITER $$
CREATE TRIGGER trg_keine_selbstausleihe
BEFORE INSERT ON Ausleihe
FOR EACH ROW
BEGIN
    IF NEW.verleiher_id = NEW.entleiher_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Selbstausleihe ist nicht erlaubt';
    END IF;
END$$
DELIMITER ;

-- Regel 2: Ein Exemplar kann nicht gleichzeitig mehrfach aktiv ausgeliehen sein.
DELIMITER $$
CREATE TRIGGER trg_eine_aktive_ausleihe
BEFORE INSERT ON Ausleihe
FOR EACH ROW
BEGIN
    IF NEW.status = 'aktiv'
       AND EXISTS (
            SELECT 1
            FROM Ausleihe
            WHERE ex_id = NEW.ex_id
              AND status = 'aktiv'
       )
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Das Buchexemplar ist bereits aktiv ausgeliehen';
    END IF;
END$$
DELIMITER ;

-- Regel 3: Bewerten darf nur, wer das Buch ausgeliehen und zurückgegeben hat.
-- Hinweis: Der Statuswert muss exakt dem CHECK-Constraint der Tabelle
-- Ausleihe entsprechen ('zurueckgegeben', ohne Umlaut).
DELIMITER $$
CREATE TRIGGER trg_bewertung_nach_rueckgabe
BEFORE INSERT ON Bewertung
FOR EACH ROW
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM Ausleihe a
        JOIN BuchExemplar be ON a.ex_id = be.ex_id
        WHERE be.buch_id      = NEW.buch_id
          AND a.entleiher_id  = NEW.benutzer_id
          AND a.status        = 'zurueckgegeben'
    )
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Bewertung erst nach abgeschlossener Ausleihe erlaubt';
    END IF;
END$$
DELIMITER ;
