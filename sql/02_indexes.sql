-- =====================================================================
-- Buchtausch-App | 02_indexes.sql
-- Benannte Indizes auf häufig verknüpften bzw. gefilterten Fremdschlüsseln
-- =====================================================================

USE buchtausch_app;

CREATE INDEX idx_buchexemplar_buch     ON BuchExemplar(buch_id);
CREATE INDEX idx_buchexemplar_benutzer ON BuchExemplar(benutzer_id);
CREATE INDEX idx_angebot_ex            ON Angebot(ex_id);
CREATE INDEX idx_anfrage_angebot       ON Anfrage(angebot_id);
CREATE INDEX idx_anfrage_benutzer      ON Anfrage(benutzer_id);
CREATE INDEX idx_ausleihe_ex           ON Ausleihe(ex_id);
CREATE INDEX idx_bewertung_buch        ON Bewertung(buch_id);
