-- Benutzer
INSERT INTO Benutzer (Benutzername) VALUES
('Halldor'),
('Gian'),
('Egor'),
('Sanjivan'),
('Loka'),
('Zoe'),
('Kenan'),
('Boris'),
('Flavia'),
('Beyonce');

INSERT INTO Kategorien (Kategoriename) VALUES
('Wichtig'),
('Hausaufgaben'),
('Familie'),
('Sport'),
('Haushalt'),
('Projekt'),
('Einkaufsliste'),
('Reisen'),
('Gesundheit'),
('Sonstiges');


-- Aufgaben
INSERT INTO Aufgaben (BenutzerID, ParentTaskID, Titel, Beschreibung, Erstellungsdatum, Deadline, GeschaetzteStunden, Status) VALUES
(1, NULL, 'Mathe Hausaufgabe', 'Kapitel 5 Aufgaben lösen', GETDATE(), DATEADD(day, 2, GETDATE()), 2.5, 0),
(2, NULL, 'Einkaufen gehen', 'Milch, Brot, Eier besorgen', GETDATE(), DATEADD(day, 1, GETDATE()), 1.0, 0),
(3, NULL, 'Joggen', '5km im Park laufen', GETDATE(), DATEADD(day, 3, GETDATE()), 1.5, 1);

-- Aufgaben_Kategorien
INSERT INTO Aufgaben_Kategorien (AufgabeID, KategorieID) VALUES
(1, 2),
(2, 7),
(3, 4);

-- Erinnerungen
INSERT INTO Erinnerungen (AufgabeID, Erinnerungszeit, Wichtigkeit, Gesendet) VALUES
(1, DATEADD(hour, 12, GETDATE()), 3, 0),
(2, DATEADD(hour, 6, GETDATE()), 2, 0),
(3, DATEADD(hour, 24, GETDATE()), 1, 1);