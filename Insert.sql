-- Testdaten für die Task App (MS-SQL kompatibel)

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


-- Aufgaben und Aufgaben_Kategorien mit Stored Procedure (10 Aufgaben, verschiedene Benutzer, Kategorien, Subtasks)
EXEC CreateTask 1, 'Mathe Hausaufgabe', 'Kapitel 5 Aufgaben lösen', DATEADD(day, 2, GETDATE()), 2.5, 0, '2,1', NULL;
EXEC CreateTask 2, 'Einkaufen gehen', 'Milch, Brot, Eier besorgen', DATEADD(day, 1, GETDATE()), 1.0, 0, '7', NULL;
EXEC CreateTask 3, 'Joggen', '5km im Park laufen', DATEADD(day, 3, GETDATE()), 1.5, 1, '4', NULL;
EXEC CreateTask 4, 'Projektarbeit', 'Datenbankmodell erstellen', DATEADD(day, 7, GETDATE()), 5.0, 0, '6,1', NULL;
EXEC CreateTask 5, 'Familienbesuch', 'Eltern besuchen', DATEADD(day, 10, GETDATE()), 3.0, 0, '3', NULL;
EXEC CreateTask 6, 'Wohnung putzen', 'Küche und Bad reinigen', DATEADD(day, 2, GETDATE()), 2.0, 0, '5', NULL;
EXEC CreateTask 7, 'Arzttermin', 'Routineuntersuchung', DATEADD(day, 5, GETDATE()), 1.0, 0, '9', NULL;
EXEC CreateTask 7, 'Reise buchen', 'Flug nach Spanien', DATEADD(day, 20, GETDATE()), 0.5, 0, '8', NULL;
EXEC CreateTask 8, 'Sporttraining', 'Vereinstraining', DATEADD(day, 4, GETDATE()), 2.0, 0, '4', NULL;
EXEC CreateTask 9, 'Geburtstagsgeschenk kaufen', 'Für Freundin', DATEADD(day, 6, GETDATE()), 1.0, 0, '7,10', NULL;

-- Beispiel-Subtasks (ParentTaskID = 1, 4, 6)
EXEC CreateTask 1, 'Mathe Teilaufgabe 1', 'Bruchrechnung', DATEADD(day, 1, GETDATE()), 1.0, 0, '2', 1;
EXEC CreateTask 1, 'Mathe Teilaufgabe 2', 'Textaufgaben', DATEADD(day, 2, GETDATE()), 1.5, 0, '2', 1;
EXEC CreateTask 4, 'ER-Modell zeichnen', 'Diagramm erstellen', DATEADD(day, 3, GETDATE()), 2.0, 0, '6', 4;
EXEC CreateTask 6, 'Bad putzen', 'Gründlich reinigen', DATEADD(day, 1, GETDATE()), 1.0, 0, '5', 6;

-- Erinnerungen für die ersten 10 Aufgaben (direkt, da keine Prozedur vorhanden)
INSERT INTO Erinnerungen (AufgabeID, Erinnerungszeit, Wichtigkeit, Gesendet) VALUES
(1, DATEADD(hour, 12, GETDATE()), 3, 0),
(2, DATEADD(hour, 6, GETDATE()), 2, 0),
(3, DATEADD(hour, 24, GETDATE()), 1, 1),
(4, DATEADD(hour, 48, GETDATE()), 2, 0),
(5, DATEADD(hour, 72, GETDATE()), 1, 0),
(6, DATEADD(hour, 36, GETDATE()), 2, 0),
(7, DATEADD(hour, 18, GETDATE()), 3, 0),
(8, DATEADD(hour, 60, GETDATE()), 1, 0),
(9, DATEADD(hour, 30, GETDATE()), 2, 0),
(10, DATEADD(hour, 15, GETDATE()), 3, 0);

-- Weitere Erinnerungen für Subtasks
INSERT INTO Erinnerungen (AufgabeID, Erinnerungszeit, Wichtigkeit, Gesendet) VALUES
(11, DATEADD(hour, 3, GETDATE()), 2, 0),
(12, DATEADD(hour, 5, GETDATE()), 1, 0),
(13, DATEADD(hour, 8, GETDATE()), 3, 0),
(14, DATEADD(hour, 2, GETDATE()), 2, 0);
