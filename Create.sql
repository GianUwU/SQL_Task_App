-- Benutzer-Tabelle
CREATE TABLE Benutzer (
    BenutzerID INT PRIMARY KEY IDENTITY(1,1),
    Benutzername VARCHAR(50) NOT NULL UNIQUE
);

-- Aufgaben-Tabelle
CREATE TABLE Aufgaben (
    AufgabeID INT PRIMARY KEY IDENTITY(1,1),
    BenutzerID INT NOT NULL,
    ParentTaskID INT NULL,
    Titel VARCHAR(100) NOT NULL,
    Beschreibung NVARCHAR(MAX),
    Erstellungsdatum DATETIME NOT NULL DEFAULT GETDATE(),
    Deadline DATETIME,
    GeschaetzteStunden FLOAT,
    Status BIT NOT NULL DEFAULT 0, -- 0 = nicht erledigt, 1 = erledigt
    FOREIGN KEY (BenutzerID) REFERENCES Benutzer(BenutzerID),
    FOREIGN KEY (ParentTaskID) REFERENCES Aufgaben(AufgabeID)
);

-- Kategorien-Tabelle
CREATE TABLE Kategorien (
    KategorieID INT PRIMARY KEY IDENTITY(1,1),
    Kategoriename VARCHAR(50) NOT NULL UNIQUE
);

-- n:m-Tabelle Aufgaben_Kategorien
CREATE TABLE Aufgaben_Kategorien (
    AufgabeID INT NOT NULL,
    KategorieID INT NOT NULL,
    PRIMARY KEY (AufgabeID, KategorieID),
    FOREIGN KEY (AufgabeID) REFERENCES Aufgaben(AufgabeID) ON DELETE CASCADE,
    FOREIGN KEY (KategorieID) REFERENCES Kategorien(KategorieID) ON DELETE CASCADE
);

-- Erinnerungen-Tabelle
CREATE TABLE Erinnerungen (
    ErinnerungID INT PRIMARY KEY IDENTITY(1,1),
    AufgabeID INT NOT NULL,
    Erinnerungszeit DATETIME NOT NULL,
    Wichtigkeit INT NOT NULL, -- z.B. 1 = niedrig, 2 = mittel, 3 = hoch
    Gesendet BIT NOT NULL DEFAULT 0,
    FOREIGN KEY (AufgabeID) REFERENCES Aufgaben(AufgabeID) ON DELETE CASCADE
);
