-- Testdaten für die Task App

INSERT INTO benutzer (benutzername) VALUES
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

INSERT INTO kategorien (kategoriename) VALUES
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
CALL CreateTask(1, 'Mathe Hausaufgabe', 'Kapitel 5 Aufgaben lösen', DATE_ADD(NOW(), INTERVAL 2 DAY), 2.5, 0, '2,1', NULL);
CALL CreateTask(2, 'Einkaufen gehen', 'Milch, Brot, Eier besorgen', DATE_ADD(NOW(), INTERVAL 1 DAY), 1.0, 0, '7', NULL);
CALL CreateTask(3, 'Joggen', '5km im Park laufen', DATE_ADD(NOW(), INTERVAL 3 DAY), 1.5, 1, '4', NULL);
CALL CreateTask(4, 'Projektarbeit', 'Datenbankmodell erstellen', DATE_ADD(NOW(), INTERVAL 7 DAY), 5.0, 0, '6,1', NULL);
CALL CreateTask(5, 'Familienbesuch', 'Eltern besuchen', DATE_ADD(NOW(), INTERVAL 10 DAY), 3.0, 0, '3', NULL);
CALL CreateTask(6, 'Wohnung putzen', 'Küche und Bad reinigen', DATE_ADD(NOW(), INTERVAL 2 DAY), 2.0, 0, '5', NULL);
CALL CreateTask(7, 'Arzttermin', 'Routineuntersuchung', DATE_ADD(NOW(), INTERVAL 5 DAY), 1.0, 0, '9', NULL);
CALL CreateTask(7, 'Reise buchen', 'Flug nach Spanien', DATE_ADD(NOW(), INTERVAL 20 DAY), 0.5, 0, '8', NULL);
CALL CreateTask(8, 'Sporttraining', 'Vereinstraining', DATE_ADD(NOW(), INTERVAL 4 DAY), 2.0, 0, '4', NULL);
CALL CreateTask(9, 'Geburtstagsgeschenk kaufen', 'Für Freundin', DATE_ADD(NOW(), INTERVAL 6 DAY), 1.0, 0, '7,10', NULL);

-- Beispiel-Subtasks (ParentTaskID = 1, 4, 6)
CALL CreateTask(1, 'Mathe Teilaufgabe 1', 'Bruchrechnung', DATE_ADD(NOW(), INTERVAL 1 DAY), 1.0, 0, '2', 1);
CALL CreateTask(1, 'Mathe Teilaufgabe 2', 'Textaufgaben', DATE_ADD(NOW(), INTERVAL 2 DAY), 1.5, 0, '2', 1);
CALL CreateTask(4, 'ER-Modell zeichnen', 'Diagramm erstellen', DATE_ADD(NOW(), INTERVAL 3 DAY), 2.0, 0, '6', 4);
CALL CreateTask(6, 'Bad putzen', 'Gründlich reinigen', DATE_ADD(NOW(), INTERVAL 1 DAY), 1.0, 0, '5', 6);

-- Erinnerungen für die ersten 10 Aufgaben (direkt, da keine Prozedur vorhanden)
INSERT INTO erinnerungen (aufgabe_id, erinnerungszeit, wichtigkeit, gesendet) VALUES
(1, DATE_ADD(NOW(), INTERVAL 12 HOUR), 3, 0),
(2, DATE_ADD(NOW(), INTERVAL 6 HOUR), 2, 0),
(3, DATE_ADD(NOW(), INTERVAL 24 HOUR), 1, 1),
(4, DATE_ADD(NOW(), INTERVAL 48 HOUR), 2, 0),
(5, DATE_ADD(NOW(), INTERVAL 72 HOUR), 1, 0),
(6, DATE_ADD(NOW(), INTERVAL 36 HOUR), 2, 0),
(7, DATE_ADD(NOW(), INTERVAL 18 HOUR), 3, 0),
(8, DATE_ADD(NOW(), INTERVAL 60 HOUR), 1, 0),
(9, DATE_ADD(NOW(), INTERVAL 30 HOUR), 2, 0),
(10, DATE_ADD(NOW(), INTERVAL 15 HOUR), 3, 0);

-- Weitere Erinnerungen für Subtasks
INSERT INTO erinnerungen (aufgabe_id, erinnerungszeit, wichtigkeit, gesendet) VALUES
(11, DATE_ADD(NOW(), INTERVAL 3 HOUR), 2, 0),
(12, DATE_ADD(NOW(), INTERVAL 5 HOUR), 1, 0),
(13, DATE_ADD(NOW(), INTERVAL 8 HOUR), 3, 0),
(14, DATE_ADD(NOW(), INTERVAL 2 HOUR), 2, 0);
