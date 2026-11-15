-- =====================================================================
-- Buchtausch-App | 01_schema.sql
-- Erstellt die Datenbank und alle 18 Tabellen
-- (5 Stammdaten-, 9 Prozessdaten-, 4 Beziehungstabellen)
-- Voraussetzung: MySQL >= 8.0.16 (CHECK-Constraints werden erst ab
-- dieser Version tatsächlich geprüft)
-- =====================================================================

DROP DATABASE IF EXISTS buchtausch_app;
CREATE DATABASE buchtausch_app
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_0900_ai_ci;

USE buchtausch_app;

-- =====================================================================
-- Stammdatentabellen
-- =====================================================================

-- Adress- und Geodaten (Grundlage für die Umkreissuche)
CREATE TABLE Adresse (
    adresse_id   INT AUTO_INCREMENT PRIMARY KEY,
    strasse      VARCHAR(100) NOT NULL,
    hausnummer   VARCHAR(10)  NOT NULL,
    plz          VARCHAR(10)  NOT NULL,
    ort          VARCHAR(100) NOT NULL,
    land         VARCHAR(100) NOT NULL,
    breitengrad  DECIMAL(9,6),
    laengengrad  DECIMAL(9,6)
);

CREATE TABLE Verlag (
    verlag_id  INT AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    sitz       VARCHAR(100)
);

CREATE TABLE Sprache (
    sprach_id    INT AUTO_INCREMENT PRIMARY KEY,
    bezeichnung  VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Genre (
    genre_id     INT AUTO_INCREMENT PRIMARY KEY,
    bezeichnung  VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Autor (
    autor_id  INT AUTO_INCREMENT PRIMARY KEY,
    vorname   VARCHAR(100) NOT NULL,
    nachname  VARCHAR(100) NOT NULL
);

-- =====================================================================
-- Prozessdatentabellen
-- =====================================================================

-- Registrierte Nutzer:innen (Rollen Verleiher/Entleiher ergeben sich
-- aus den Beziehungen, nicht aus getrennten Tabellen)
CREATE TABLE Benutzer (
    benutzer_id          INT AUTO_INCREMENT PRIMARY KEY,
    adresse_id           INT NOT NULL,
    vorname              VARCHAR(100) NOT NULL,
    nachname             VARCHAR(100) NOT NULL,
    anzeigename          VARCHAR(100) NOT NULL,
    email                VARCHAR(100) NOT NULL UNIQUE,
    telefonnummer        VARCHAR(100),
    registrierungsdatum  DATE NOT NULL,
    kontostatus          VARCHAR(100) NOT NULL,

    CHECK (kontostatus IN ('aktiv', 'inaktiv', 'gesperrt')),

    FOREIGN KEY (adresse_id) REFERENCES Adresse(adresse_id)
);

-- Bibliografische Daten (ein Titel, unabhängig von physischen Exemplaren)
CREATE TABLE Buch (
    buch_id           INT AUTO_INCREMENT PRIMARY KEY,
    verlag_id         INT NOT NULL,
    titel             VARCHAR(100) NOT NULL,
    untertitel        VARCHAR(100),
    isbn              VARCHAR(20) UNIQUE,
    erscheinungsjahr  INT,
    kurzbeschreibung  TEXT,

    CHECK (erscheinungsjahr >= 0),

    FOREIGN KEY (verlag_id) REFERENCES Verlag(verlag_id)
);

-- Physisches, ausleihbares Exemplar eines Buches
CREATE TABLE BuchExemplar (
    ex_id              INT AUTO_INCREMENT PRIMARY KEY,
    buch_id            INT NOT NULL,
    benutzer_id        INT NOT NULL,          -- Besitzer:in
    zustand            VARCHAR(100) NOT NULL,
    notiz_zum_zustand  TEXT,
    verleihbar         BOOLEAN NOT NULL,

    CHECK (zustand IN ('neu', 'sehr_gut', 'gut', 'gebraucht', 'beschaedigt')),

    FOREIGN KEY (buch_id)     REFERENCES Buch(buch_id),
    FOREIGN KEY (benutzer_id) REFERENCES Benutzer(benutzer_id)
);

-- Ausleihangebot zu einem Exemplar
CREATE TABLE Angebot (
    angebot_id        INT AUTO_INCREMENT PRIMARY KEY,
    ex_id             INT NOT NULL,
    max_verleihdauer  INT NOT NULL,           -- in Wochen
    versand_moeglich  BOOLEAN NOT NULL,
    status            VARCHAR(100) NOT NULL,
    erstellt_am       DATE NOT NULL,

    CHECK (max_verleihdauer > 0),
    CHECK (status IN ('verfuegbar', 'reserviert', 'pausiert')),

    FOREIGN KEY (ex_id) REFERENCES BuchExemplar(ex_id)
);

CREATE TABLE Abholort (
    aort_id      INT AUTO_INCREMENT PRIMARY KEY,
    adresse_id   INT NOT NULL,
    bezeichnung  VARCHAR(100) NOT NULL,
    hinweis      TEXT,

    FOREIGN KEY (adresse_id) REFERENCES Adresse(adresse_id)
);

CREATE TABLE Zeitslot (
    zeitslot_id  INT AUTO_INCREMENT PRIMARY KEY,
    wochentag    VARCHAR(100) NOT NULL,
    startzeit    TIME NOT NULL,
    endzeit      TIME NOT NULL,
    gueltig_von  DATE,
    gueltig_bis  DATE,

    CHECK (startzeit < endzeit)
);

CREATE TABLE Anfrage (
    anfrage_id    INT AUTO_INCREMENT PRIMARY KEY,
    angebot_id    INT NOT NULL,
    benutzer_id   INT NOT NULL,
    anfragedatum  DATE NOT NULL,
    nachricht     TEXT,
    status        VARCHAR(100) NOT NULL,

    CHECK (status IN ('offen', 'angenommen', 'abgelehnt')),

    FOREIGN KEY (angebot_id)  REFERENCES Angebot(angebot_id),
    FOREIGN KEY (benutzer_id) REFERENCES Benutzer(benutzer_id)
);

CREATE TABLE Ausleihe (
    ausleihe_id   INT AUTO_INCREMENT PRIMARY KEY,
    ex_id         INT NOT NULL,
    verleiher_id  INT NOT NULL,
    entleiher_id  INT NOT NULL,
    ausleihdatum  DATE NOT NULL,
    faellig_am    DATE NOT NULL,
    rueckgabe_am  DATE,
    status        VARCHAR(100) NOT NULL,

    CHECK (status IN ('aktiv', 'zurueckgegeben', 'ueberfaellig')),

    FOREIGN KEY (ex_id)        REFERENCES BuchExemplar(ex_id),
    FOREIGN KEY (verleiher_id) REFERENCES Benutzer(benutzer_id),
    FOREIGN KEY (entleiher_id) REFERENCES Benutzer(benutzer_id)
);

CREATE TABLE Bewertung (
    bewertung_id     INT AUTO_INCREMENT PRIMARY KEY,
    buch_id          INT NOT NULL,
    benutzer_id      INT NOT NULL,
    sterne           INT NOT NULL,
    kommentar        TEXT,
    bewertungsdatum  DATE NOT NULL,

    CHECK (sterne BETWEEN 1 AND 5),

    FOREIGN KEY (buch_id)     REFERENCES Buch(buch_id),
    FOREIGN KEY (benutzer_id) REFERENCES Benutzer(benutzer_id)
);

-- =====================================================================
-- Beziehungstabellen (m:n bzw. ternär)
-- =====================================================================

CREATE TABLE Buch_Autor (
    buch_id   INT NOT NULL,
    autor_id  INT NOT NULL,
    PRIMARY KEY (buch_id, autor_id),
    FOREIGN KEY (buch_id)  REFERENCES Buch(buch_id),
    FOREIGN KEY (autor_id) REFERENCES Autor(autor_id)
);

CREATE TABLE Buch_Sprache (
    buch_id    INT NOT NULL,
    sprach_id  INT NOT NULL,
    PRIMARY KEY (buch_id, sprach_id),
    FOREIGN KEY (buch_id)   REFERENCES Buch(buch_id),
    FOREIGN KEY (sprach_id) REFERENCES Sprache(sprach_id)
);

CREATE TABLE Buch_Genre (
    buch_id   INT NOT NULL,
    genre_id  INT NOT NULL,
    PRIMARY KEY (buch_id, genre_id),
    FOREIGN KEY (buch_id)  REFERENCES Buch(buch_id),
    FOREIGN KEY (genre_id) REFERENCES Genre(genre_id)
);

-- Ternäre Beziehung: Wann (Zeitslot) und wo (Abholort) ist ein Angebot abholbar?
CREATE TABLE Angebot_Verfuegbarkeit (
    angebot_id   INT NOT NULL,
    aort_id      INT NOT NULL,
    zeitslot_id  INT NOT NULL,
    hinweis      TEXT,
    PRIMARY KEY (angebot_id, aort_id, zeitslot_id),
    FOREIGN KEY (angebot_id)  REFERENCES Angebot(angebot_id),
    FOREIGN KEY (aort_id)     REFERENCES Abholort(aort_id),
    FOREIGN KEY (zeitslot_id) REFERENCES Zeitslot(zeitslot_id)
);
