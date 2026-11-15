-- =====================================================================
-- Buchtausch-App | 04_seed_data.sql
-- Beispieldaten (fiktiv). Reihenfolge beachten: Die Trigger aus
-- 03_triggers.sql sind bereits aktiv und prüfen die Ausleihen/Bewertungen.
-- =====================================================================

USE buchtausch_app;

-- Fügt Beispieldaten in die Tabelle "Adresse" ein
INSERT INTO Adresse
(strasse, hausnummer, plz, ort, land, breitengrad, laengengrad)
VALUES
('Hauptstrasse', '12', '10115', 'Berlin', 'Deutschland', 52.520008, 13.404954),
('Bahnhofstrasse', '5', '20095', 'Hamburg', 'Deutschland', 53.551086, 9.993682),
('Goethestrasse', '21', '60311', 'Frankfurt', 'Deutschland', 50.110924, 8.682127),
('Mozartweg', '8', '80331', 'Muenchen', 'Deutschland', 48.135124, 11.581981),
('Schillerallee', '17', '50667', 'Koeln', 'Deutschland', 50.937531, 6.960279),
('Parkstrasse', '3', '70173', 'Stuttgart', 'Deutschland', 48.775846, 9.182932),
('Wiesenweg', '44', '28195', 'Bremen', 'Deutschland', 53.079296, 8.801694),
('Birkenweg', '9', '01067', 'Dresden', 'Deutschland', 51.050409, 13.737262),
('Lindenstrasse', '15', '04109', 'Leipzig', 'Deutschland', 51.339695, 12.373075),
('Seestrasse', '27', '24103', 'Kiel', 'Deutschland', 54.323293, 10.122765);

-- Fügt Beispieldaten in die Tabelle "Benutzer" ein
INSERT INTO Benutzer
(adresse_id, vorname, nachname, anzeigename, email, telefonnummer, registrierungsdatum, kontostatus)
VALUES
(1, 'Max', 'Mueller', 'maxbooks', 'max@example.de', '015111111111', '2025-01-10', 'aktiv'),
(2, 'Anna', 'Schmidt', 'annareads', 'anna@example.de', '015122222222', '2025-01-11', 'aktiv'),
(3, 'Lukas', 'Weber', 'lukasw', 'lukas@example.de', '015133333333', '2025-01-12', 'aktiv'),
(4, 'Sophie', 'Fischer', 'sofiebooks', 'sophie@example.de', '015144444444', '2025-01-13', 'aktiv'),
(5, 'Leon', 'Becker', 'leonliest', 'leon@example.de', '015155555555', '2025-01-14', 'aktiv'),
(6, 'Emma', 'Wagner', 'emma_reads', 'emma@example.de', '015166666666', '2025-01-15', 'aktiv'),
(7, 'Paul', 'Hoffmann', 'paulbooks', 'paul@example.de', '015177777777', '2025-01-16', 'inaktiv'),
(8, 'Mia', 'Schulz', 'miareads', 'mia@example.de', '015188888888', '2025-01-17', 'aktiv'),
(9, 'Noah', 'Koch', 'noahliest', 'noah@example.de', '015199999999', '2025-01-18', 'gesperrt'),
(10, 'Clara', 'Bauer', 'clarabooks', 'clara@example.de', '015100000000', '2025-01-19', 'aktiv');

-- Fügt Beispieldaten in die Tabelle "Verlag" ein
INSERT INTO Verlag
(name, sitz)
VALUES
('Droemer Knaur', 'Muenchen'),
('Carlsen Verlag', 'Hamburg'),
('Ullstein Verlag', 'Berlin'),
('Heyne Verlag', 'Muenchen'),
('Dressler Verlag', 'Hamburg'),
('Chilton Books', 'Philadelphia'),
('Goldmann Verlag', 'Muenchen'),
('Bastei Luebbe', 'Koeln'),
('Heyne Science Fiction', 'Muenchen'),
('Arena Verlag', 'Wuerzburg');

-- Fügt Beispieldaten in die Tabelle "Sprache" ein
INSERT INTO Sprache
(bezeichnung)
VALUES
('Deutsch'),
('Englisch'),
('Franzoesisch'),
('Spanisch'),
('Italienisch'),
('Niederlaendisch'),
('Polnisch'),
('Schwedisch'),
('Japanisch'),
('Russisch');

-- Fügt Beispieldaten in die Tabelle "Genre" ein
INSERT INTO Genre
(bezeichnung)
VALUES
('Roman'),
('Thriller'),
('Fantasy'),
('Science Fiction'),
('Drama'),
('Krimi'),
('Biografie'),
('Sachbuch'),
('Horror'),
('Abenteuer');

-- Fügt Beispieldaten in die Tabelle "Autor" ein
INSERT INTO Autor
(vorname, nachname)
VALUES
('Sebastian', 'Fitzek'),
('J.K.', 'Rowling'),
('George', 'Orwell'),
('Stephen', 'King'),
('Cornelia', 'Funke'),
('Frank', 'Herbert'),
('Joanne', 'Harris'),
('Dan', 'Brown'),
('Isaac', 'Asimov'),
('Jules', 'Verne');

-- Fügt Beispieldaten in die Tabelle "Buch" ein
INSERT INTO Buch
(verlag_id, titel, untertitel, isbn, erscheinungsjahr, kurzbeschreibung)
VALUES
(1, 'Der Insasse', NULL, '9783426281781', 2018, 'Psychothriller von Sebastian Fitzek'),
(2, 'Harry Potter und der Stein der Weisen', NULL, '9783551551672', 1997, 'Fantasyroman'),
(3, '1984', NULL, '9783548234101', 1949, 'Dystopischer Roman'),
(4, 'Es', NULL, '9783453435771', 1986, 'Horrorroman'),
(5, 'Tintenherz', NULL, '9783791504650', 2003, 'Fantasyroman'),
(6, 'Dune', 'Der Wuestenplanet', '9783453319910', 1965, 'Science-Fiction-Klassiker'),
(7, 'Chocolat', NULL, '9783442457524', 1999, 'Roman'),
(8, 'Illuminati', NULL, '9783404158612', 2000, 'Thriller'),
(9, 'Foundation', NULL, '9783453319972', 1951, 'Science Fiction'),
(10, 'Reise zum Mittelpunkt der Erde', NULL, '9783150105407', 1864, 'Abenteuerroman');

-- Fügt Beziehungen zwischen Büchern und Autor:innen ein
INSERT INTO Buch_Autor
(buch_id, autor_id)
VALUES
(1,1),
(2,2),
(3,3),
(4,4),
(5,5),
(6,6),
(7,7),
(8,8),
(9,9),
(10,10);

-- Fügt Beziehungen zwischen Büchern und Sprachen ein
INSERT INTO Buch_Sprache
(buch_id, sprach_id)
VALUES
(1,1),
(2,1),
(2,2),
(3,1),
(3,2),
(4,1),
(5,1),
(6,2),
(7,1),
(8,1);

-- Fügt Beziehungen zwischen Büchern und Genres ein
INSERT INTO Buch_Genre
(buch_id, genre_id)
VALUES
(1,2),
(2,3),
(3,4),
(4,9),
(5,3),
(6,4),
(7,1),
(8,2),
(9,4),
(10,1);

-- Fügt Beispieldaten in die Tabelle "BuchExemplar" ein
INSERT INTO BuchExemplar
(buch_id, benutzer_id, zustand, notiz_zum_zustand, verleihbar)
VALUES
(1,1,'gut','Leichte Gebrauchsspuren',TRUE),
(2,2,'sehr_gut','Wie neu',TRUE),
(3,3,'gebraucht','Knick im Cover',TRUE),
(4,4,'gut','Normale Nutzungsspuren',TRUE),
(5,5,'neu','Ungelesen',TRUE),
(6,6,'gut','Kleine Kratzer',TRUE),
(7,7,'gebraucht','Markierungen vorhanden',FALSE),
(8,8,'sehr_gut','Sehr gepflegt',TRUE),
(9,9,'gut','Leicht vergilbt',TRUE),
(10,10,'neu','Originalzustand',TRUE);

-- Fügt Beispieldaten in die Tabelle "Angebot" ein
INSERT INTO Angebot
(ex_id, max_verleihdauer, versand_moeglich, status, erstellt_am)
VALUES
(1,4,TRUE,'verfuegbar','2025-02-01'),
(2,3,FALSE,'verfuegbar','2025-02-02'),
(3,6,TRUE,'reserviert','2025-02-03'),
(4,2,FALSE,'verfuegbar','2025-02-04'),
(5,8,TRUE,'verfuegbar','2025-02-05'),
(6,5,TRUE,'pausiert','2025-02-06'),
(7,4,FALSE,'reserviert','2025-02-07'),
(8,3,TRUE,'verfuegbar','2025-02-08'),
(9,6,FALSE,'verfuegbar','2025-02-09'),
(10,2,TRUE,'verfuegbar','2025-02-10');

-- Fügt Beispieldaten in die Tabelle "Abholort" ein
INSERT INTO Abholort
(adresse_id, bezeichnung, hinweis)
VALUES
(1,'Bahnhof Berlin','Treffpunkt Haupteingang'),
(2,'Cafe Hamburg','Neben dem Eingang'),
(3,'Bibliothek Frankfurt','1. Stock'),
(4,'Uni Muenchen','Vor Hoersaal A'),
(5,'Dom Koeln','Treffpunkt Vorplatz'),
(6,'Stadtpark Stuttgart','Am Brunnen'),
(7,'Hbf Bremen','Gleis 3'),
(8,'Altmarkt Dresden','Vor dem Cafe'),
(9,'Innenstadt Leipzig','Buchhandlung'),
(10,'Kieler Hafen','Beim Ticketschalter');

-- Fügt Beispieldaten in die Tabelle "Zeitslot" ein
INSERT INTO Zeitslot
(wochentag, startzeit, endzeit, gueltig_von, gueltig_bis)
VALUES
('Montag','10:00','12:00','2025-02-01','2025-06-01'),
('Dienstag','14:00','16:00','2025-02-01','2025-06-01'),
('Mittwoch','09:00','11:00','2025-02-01','2025-06-01'),
('Donnerstag','17:00','19:00','2025-02-01','2025-06-01'),
('Freitag','15:00','18:00','2025-02-01','2025-06-01'),
('Samstag','10:00','13:00','2025-02-01','2025-06-01'),
('Montag','18:00','20:00','2025-02-01','2025-06-01'),
('Dienstag','08:00','10:00','2025-02-01','2025-06-01'),
('Mittwoch','16:00','18:00','2025-02-01','2025-06-01'),
('Freitag','09:00','11:00','2025-02-01','2025-06-01');

-- Fügt Verfügbarkeitsdaten für Angebote ein
INSERT INTO Angebot_Verfuegbarkeit
(angebot_id, aort_id, zeitslot_id, hinweis)
VALUES
(1,1,1,'Pünktlich erscheinen'),
(2,2,2,'Vorher schreiben'),
(3,3,3,'Bibliotheksausweis mitbringen'),
(4,4,4,'Treffpunkt Eingang'),
(5,5,5,'Nur Barzahlung Versandkosten'),
(6,6,6,'Kurz vorher melden'),
(7,7,7,'Verspaetung mitteilen'),
(8,8,8,'Treffpunkt Cafe'),
(9,9,9,'Telefonisch erreichbar'),
(10,10,10,'Bitte rechtzeitig kommen');

-- Fügt Beispieldaten in die Tabelle "Anfrage" ein
INSERT INTO Anfrage
(angebot_id, benutzer_id, anfragedatum, nachricht, status)
VALUES
(1,2,'2025-02-11','Ist das Buch noch verfuegbar?','angenommen'),
(2,3,'2025-02-11','Ich wuerde das Buch gern ausleihen.','offen'),
(3,4,'2025-02-12','Kann ich es naechste Woche abholen?','abgelehnt'),
(4,5,'2025-02-12','Interesse an kurzfristiger Ausleihe.','angenommen'),
(5,6,'2025-02-13','Versand moeglich?','offen'),
(6,7,'2025-02-13','Bitte reservieren.','angenommen'),
(7,8,'2025-02-14','Noch verfuegbar?','abgelehnt'),
(8,9,'2025-02-14','Ich wuerde das Buch gern lesen.','offen'),
(9,10,'2025-02-15','Abholung am Freitag moeglich?','angenommen'),
(10,1,'2025-02-15','Kann ich das Buch zwei Wochen behalten?','offen');

-- Fügt Beispieldaten in die Tabelle "Ausleihe" ein
INSERT INTO Ausleihe
(ex_id, verleiher_id, entleiher_id, ausleihdatum, faellig_am, rueckgabe_am, status)
VALUES
(1,1,2,'2025-02-15','2025-03-15',NULL,'aktiv'),
(2,2,3,'2025-02-16','2025-03-09','2025-03-08','zurueckgegeben'),
(3,3,4,'2025-02-17','2025-03-31',NULL,'aktiv'),
(4,4,5,'2025-02-18','2025-03-04','2025-03-03','zurueckgegeben'),
(5,5,6,'2025-02-19','2025-04-16',NULL,'aktiv'),
(6,6,7,'2025-02-20','2025-03-27',NULL,'ueberfaellig'),
(7,7,8,'2025-02-21','2025-03-21','2025-03-20','zurueckgegeben'),
(8,8,9,'2025-02-22','2025-03-15',NULL,'aktiv'),
(9,9,10,'2025-02-23','2025-04-06',NULL,'aktiv'),
(10,10,1,'2025-02-24','2025-03-10','2025-03-09','zurueckgegeben'),
-- Abgeschlossene frühere Ausleihen (Grundlage für gültige Bewertungen)
(1,1,3,'2025-02-02','2025-02-14','2025-02-13','zurueckgegeben'),
(3,3,5,'2025-02-04','2025-02-16','2025-02-15','zurueckgegeben'),
(5,5,7,'2025-02-06','2025-02-18','2025-02-17','zurueckgegeben'),
(6,6,8,'2025-02-07','2025-02-19','2025-02-18','zurueckgegeben'),
(8,8,10,'2025-02-09','2025-02-21','2025-02-20','zurueckgegeben'),
(9,9,1,'2025-02-10','2025-02-22','2025-02-21','zurueckgegeben');

-- Fügt Beispieldaten in die Tabelle "Bewertung" ein
-- (jede Bewertung gehört zu einer zurückgegebenen Ausleihe -> Trigger erfüllt)
INSERT INTO Bewertung
(buch_id, benutzer_id, sterne, kommentar, bewertungsdatum)
VALUES
(1,3,5,'Sehr spannendes Buch!','2025-02-14'),
(2,3,5,'Klassiker der Fantasy.','2025-03-09'),
(3,5,4,'Interessante Geschichte.','2025-02-16'),
(4,5,5,'Sehr gruselig und spannend.','2025-03-04'),
(5,7,4,'Tolle Fantasywelt.','2025-02-18'),
(6,8,5,'Science Fiction auf hoechstem Niveau.','2025-02-19'),
(7,8,3,'Netter Roman.','2025-03-21'),
(8,10,4,'Spannender Thriller.','2025-02-21'),
(9,1,5,'Sehr empfehlenswert.','2025-02-22'),
(10,1,4,'Tolles Abenteuerbuch.','2025-03-10');
